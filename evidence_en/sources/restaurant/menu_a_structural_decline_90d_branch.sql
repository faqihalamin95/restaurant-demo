WITH max_d AS (SELECT MAX(order_date) AS d FROM main_marts.mart_menu_performance),
calendar AS (
    SELECT gs AS order_date
    FROM max_d, generate_series(d - INTERVAL '89 days', d, INTERVAL '1 day') AS t(gs)
),
source_rows AS (
    SELECT order_date, branch_name, menu_name,
        CASE category WHEN 'main' THEN 'Menu Utama' WHEN 'drink' THEN 'Minuman'
            WHEN 'snack' THEN 'Camilan' WHEN 'dessert' THEN 'Dessert'
            WHEN 'side' THEN 'Pendamping' ELSE category END AS category,
        total_qty_sold,
        total_revenue
    FROM main_marts.mart_menu_performance CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '89 days'
    UNION ALL
    SELECT order_date, 'Semua Cabang' AS branch_name, menu_name,
        CASE category WHEN 'main' THEN 'Menu Utama' WHEN 'drink' THEN 'Minuman'
            WHEN 'snack' THEN 'Camilan' WHEN 'dessert' THEN 'Dessert'
            WHEN 'side' THEN 'Pendamping' ELSE category END AS category,
        total_qty_sold,
        total_revenue
    FROM main_marts.mart_menu_performance CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '89 days'
),
menu_dim AS (
    SELECT branch_name, menu_name, MAX(category) AS category
    FROM source_rows
    GROUP BY branch_name, menu_name
),
daily AS (
    SELECT
        c.order_date,
        m.branch_name,
        m.menu_name,
        m.category,
        COALESCE(SUM(s.total_qty_sold), 0) AS qty_daily,
        COALESCE(SUM(s.total_revenue), 0) AS revenue_daily
    FROM calendar c
    CROSS JOIN menu_dim m
    LEFT JOIN source_rows s
        ON s.order_date = c.order_date
       AND s.branch_name = m.branch_name
       AND s.menu_name = m.menu_name
    GROUP BY c.order_date, m.branch_name, m.menu_name, m.category
),
rolling AS (
    SELECT
        order_date,
        branch_name,
        menu_name,
        category,
        qty_daily,
        revenue_daily,
        DATE_DIFF('day', (SELECT d - INTERVAL '89 days' FROM max_d), order_date) AS day_index,
        AVG(qty_daily) OVER (
            PARTITION BY branch_name, menu_name
            ORDER BY order_date
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ) AS rolling_avg_qty,
        AVG(revenue_daily) OVER (
            PARTITION BY branch_name, menu_name
            ORDER BY order_date
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ) AS rolling_avg_revenue
    FROM daily
),
weekly AS (
    SELECT
        branch_name,
        menu_name,
        MAX(category) AS category,
        CAST(FLOOR((day_index - 6) / 7) + 1 AS INTEGER) AS week_no,
        SUM(qty_daily) AS weekly_qty,
        SUM(revenue_daily) AS weekly_revenue
    FROM rolling
    WHERE day_index BETWEEN 6 AND 89
    GROUP BY branch_name, menu_name, week_no
),
weekly_change AS (
    SELECT *,
        LAG(weekly_qty) OVER (PARTITION BY branch_name, menu_name ORDER BY week_no) AS prev_weekly_qty
    FROM weekly
),
summary AS (
    SELECT
        branch_name,
        menu_name,
        MAX(category) AS category,
        COUNT(*) AS weeks_observed,
        SUM(CASE WHEN prev_weekly_qty IS NOT NULL AND weekly_qty < prev_weekly_qty THEN 1 ELSE 0 END) AS declining_weeks_12,
        MAX(CASE WHEN week_no=1 THEN weekly_qty END) AS weekly_qty_awal,
        AVG(weekly_qty) FILTER (WHERE week_no BETWEEN 5 AND 8) AS weekly_qty_tengah,
        MAX(CASE WHEN week_no=12 THEN weekly_qty END) AS weekly_qty_akhir,
        MAX(CASE WHEN week_no=12 THEN weekly_revenue END) AS weekly_revenue_akhir,
        AVG(weekly_qty) FILTER (WHERE week_no BETWEEN 10 AND 12) AS recent_3w_avg
    FROM weekly_change
    GROUP BY branch_name, menu_name
),
peak AS (
    SELECT branch_name, menu_name, week_no AS peak_week_no, weekly_qty AS weekly_qty_peak
    FROM (
        SELECT
            branch_name,
            menu_name,
            week_no,
            weekly_qty,
            ROW_NUMBER() OVER (
                PARTITION BY branch_name, menu_name
                ORDER BY weekly_qty DESC, week_no DESC
            ) AS rn
        FROM weekly
    )
    WHERE rn = 1
),
scored AS (
    SELECT
        s.branch_name,
        s.menu_name,
        s.category,
        p.peak_week_no,
        s.weeks_observed,
        s.declining_weeks_12,
        s.weekly_qty_awal,
        s.weekly_qty_tengah,
        p.weekly_qty_peak,
        s.weekly_qty_akhir,
        s.weekly_revenue_akhir,
        s.recent_3w_avg,
        ROUND((s.weekly_qty_akhir - p.weekly_qty_peak) * 100.0 / NULLIF(p.weekly_qty_peak, 0), 1) AS pct_change_90d
    FROM summary s
    JOIN peak p ON s.branch_name=p.branch_name AND s.menu_name=p.menu_name
)
SELECT
    branch_name,
    menu_name,
    category,
    peak_week_no,
    weeks_observed,
    declining_weeks_12,
    ROUND(weekly_qty_awal, 1) AS weekly_qty_awal,
    ROUND(weekly_qty_tengah, 1) AS weekly_qty_tengah,
    ROUND(weekly_qty_peak, 1) AS weekly_qty_peak,
    ROUND(weekly_qty_akhir, 1) AS weekly_qty_akhir,
    ROUND(weekly_revenue_akhir, 0) AS weekly_revenue_akhir,
    ROUND(weekly_qty_awal, 1) AS rolling_qty_awal,
    ROUND(weekly_qty_tengah, 1) AS rolling_qty_tengah,
    ROUND(weekly_qty_peak, 1) AS rolling_qty_peak,
    ROUND(weekly_qty_akhir, 1) AS rolling_qty_akhir,
    ROUND(weekly_revenue_akhir, 0) AS rolling_revenue_akhir,
    pct_change_90d,
    CASE
        WHEN declining_weeks_12 >= 9 AND pct_change_90d <= -25 AND weekly_qty_akhir <= recent_3w_avg * 1.10 THEN 'Kritis'
        WHEN declining_weeks_12 >= 8 AND pct_change_90d <= -15 THEN 'Waspada'
        ELSE 'Pantau'
    END AS severity,
    CAST(declining_weeks_12 AS VARCHAR) || ' dari 12 minggu turun' AS trend_status,
    CASE
        WHEN declining_weeks_12 >= 9 AND pct_change_90d <= -25 AND weekly_qty_akhir <= recent_3w_avg * 1.10 THEN '>=75% minggu turun + akhir turun >=25% + belum pulih'
        WHEN declining_weeks_12 >= 8 AND pct_change_90d <= -15 THEN '>=67% minggu turun + akhir turun >=15%'
        ELSE '>=60% minggu turun + akhir turun >=10%'
    END AS decline_rule,
    CASE WHEN weekly_qty_akhir <= recent_3w_avg * 1.10 THEN '3 minggu terakhir belum pulih signifikan' ELSE 'Ada indikasi pemulihan akhir' END AS recent_status
FROM scored
WHERE weekly_qty_peak >= 5
  AND weeks_observed = 12
  AND (
      (declining_weeks_12 >= 9 AND pct_change_90d <= -25 AND weekly_qty_akhir <= recent_3w_avg * 1.10)
      OR (declining_weeks_12 >= 8 AND pct_change_90d <= -15)
      OR (declining_weeks_12 >= 7 AND pct_change_90d <= -10)
  )
ORDER BY branch_name, pct_change_90d ASC
