WITH monthly_by_year AS (
    -- Tahap 1: total per bulan per tahun — jangan SUM lintas tahun
    SELECT
        YEAR(order_date)  AS tahun,
        MONTH(order_date) AS bulan_num,
        CASE WHEN MONTH(order_date) IN (1,2,3)   THEN 'Q1'
             WHEN MONTH(order_date) IN (4,5,6)   THEN 'Q2'
             WHEN MONTH(order_date) IN (7,8,9)   THEN 'Q3'
             ELSE 'Q4' END AS kuartal,
        SUM(total_orders)  AS monthly_orders,
        SUM(total_revenue) AS monthly_revenue
    FROM main_marts.mart_peak_hours
    GROUP BY YEAR(order_date), MONTH(order_date)
),
monthly_avg AS (
    -- Tahap 2: rata-rata tiap bulan lintas tahun
    -- Bulan yang ada data 3 tahun tidak lebih berat dari bulan yang ada 2 tahun
    SELECT
        bulan_num, kuartal,
        ROUND(AVG(monthly_orders),  0) AS avg_monthly_orders,
        ROUND(AVG(monthly_revenue), 0) AS avg_monthly_revenue
    FROM monthly_by_year
    GROUP BY bulan_num, kuartal
),
quarterly AS (
    -- Tahap 3: rata-rata bulanan per kuartal
    SELECT kuartal, ROUND(AVG(avg_monthly_orders), 0) AS q_avg_orders
    FROM monthly_avg GROUP BY kuartal
),
strongest AS (SELECT kuartal AS strongest_q, q_avg_orders AS max_q_orders FROM quarterly ORDER BY q_avg_orders DESC LIMIT 1),
weakest   AS (SELECT kuartal AS weakest_q,   q_avg_orders AS min_q_orders FROM quarterly ORDER BY q_avg_orders ASC  LIMIT 1),
growth AS (
    SELECT ROUND((last_monthly_orders - first_monthly_orders) * 100.0 / NULLIF(first_monthly_orders, 0), 1) AS growth_pct
    FROM (
        SELECT
            MAX(CASE WHEN rn_asc = 1 THEN monthly_orders END) AS first_monthly_orders,
            MAX(CASE WHEN rn_desc = 1 THEN monthly_orders END) AS last_monthly_orders
        FROM (
            SELECT
                monthly_orders,
                ROW_NUMBER() OVER (ORDER BY tahun, bulan_num) AS rn_asc,
                ROW_NUMBER() OVER (ORDER BY tahun DESC, bulan_num DESC) AS rn_desc
            FROM monthly_by_year
        )
    )
),
holiday_avg     AS (SELECT AVG(avg_monthly_orders) AS avg_h FROM monthly_avg WHERE bulan_num IN (12,1,6,7)),
non_holiday_avg AS (SELECT AVG(avg_monthly_orders) AS avg_n FROM monthly_avg WHERE bulan_num NOT IN (12,1,6,7))
SELECT
    s.strongest_q, s.max_q_orders,
    w.weakest_q,   w.min_q_orders,
    g.growth_pct,
    ROUND((h.avg_h - n.avg_n) * 100.0 / NULLIF(n.avg_n, 0), 1) AS holiday_effect_pct,
    ROUND((s.max_q_orders - w.min_q_orders) * 100.0 / NULLIF(w.min_q_orders, 0), 0) AS seasonal_gap_pct,
    CASE
        WHEN ROUND((s.max_q_orders - w.min_q_orders) * 100.0 / NULLIF(w.min_q_orders, 0), 0) >= 40 THEN 'kuat'
        WHEN ROUND((s.max_q_orders - w.min_q_orders) * 100.0 / NULLIF(w.min_q_orders, 0), 0) >= 20 THEN 'moderat'
        ELSE 'lemah'
    END AS seasonal_strength
FROM strongest s, weakest w, growth g, holiday_avg h, non_holiday_avg n
