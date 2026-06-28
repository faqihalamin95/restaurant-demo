WITH max_d AS (
    SELECT MAX(order_date) AS max_date
    FROM main_marts.mart_peak_hours
),
monthly AS (
SELECT
    DATE_TRUNC('month', order_date) AS bulan,
    YEAR(order_date) AS tahun,
    MONTH(order_date) AS bulan_num,
    CASE MONTH(order_date)
        WHEN 1 THEN 'Jan' WHEN 2 THEN 'Feb' WHEN 3 THEN 'Mar' WHEN 4 THEN 'Apr'
        WHEN 5 THEN 'Mei' WHEN 6 THEN 'Jun' WHEN 7 THEN 'Jul' WHEN 8 THEN 'Agu'
        WHEN 9 THEN 'Sep' WHEN 10 THEN 'Okt' WHEN 11 THEN 'Nov' WHEN 12 THEN 'Des'
    END AS nama_bulan,
    CASE MONTH(order_date)
        WHEN 1 THEN 'Jan' WHEN 2 THEN 'Feb' WHEN 3 THEN 'Mar' WHEN 4 THEN 'Apr'
        WHEN 5 THEN 'Mei' WHEN 6 THEN 'Jun' WHEN 7 THEN 'Jul' WHEN 8 THEN 'Agu'
        WHEN 9 THEN 'Sep' WHEN 10 THEN 'Okt' WHEN 11 THEN 'Nov' WHEN 12 THEN 'Des'
    END || ' ' || CAST(YEAR(order_date) AS VARCHAR) AS bulan_label,
    SUM(total_orders)  AS monthly_orders,
    SUM(total_revenue) AS monthly_revenue,
    COUNT(DISTINCT order_date) AS days_recorded,
    MAX(order_date) AS max_order_date
FROM main_marts.mart_peak_hours
GROUP BY DATE_TRUNC('month', order_date), MONTH(order_date), YEAR(order_date)
),
baseline_same_month AS (
    SELECT
        m.bulan_num,
        ROUND(AVG(m.monthly_orders), 0) AS baseline_orders,
        ROUND(AVG(m.monthly_revenue), 0) AS baseline_revenue
    FROM monthly m
    CROSS JOIN max_d
    WHERE DATE_TRUNC('month', m.bulan) < DATE_TRUNC('month', max_d.max_date)
    GROUP BY m.bulan_num
)
SELECT
    m.*,
    DAY(DATE_TRUNC('month', m.bulan) + INTERVAL '1 month' - INTERVAL '1 day') AS days_in_month,
    ROUND(m.monthly_orders * 1.0 / NULLIF(m.days_recorded, 0), 1) AS daily_order_pace,
    ROUND(m.monthly_revenue * 1.0 / NULLIF(m.days_recorded, 0), 0) AS daily_revenue_pace,
    ROUND((m.monthly_orders * 1.0 / NULLIF(m.days_recorded, 0)) * DAY(DATE_TRUNC('month', m.bulan) + INTERVAL '1 month' - INTERVAL '1 day'), 0) AS projected_orders,
    ROUND((m.monthly_revenue * 1.0 / NULLIF(m.days_recorded, 0)) * DAY(DATE_TRUNC('month', m.bulan) + INTERVAL '1 month' - INTERVAL '1 day'), 0) AS projected_revenue,
    b.baseline_orders,
    b.baseline_revenue,
    ROUND((((m.monthly_orders * 1.0 / NULLIF(m.days_recorded, 0)) * DAY(DATE_TRUNC('month', m.bulan) + INTERVAL '1 month' - INTERVAL '1 day')) - b.baseline_orders) * 100.0 / NULLIF(b.baseline_orders, 0), 1) AS projected_vs_baseline_pct,
    CASE
        WHEN b.baseline_orders IS NULL THEN 'Belum ada baseline historis'
        WHEN ROUND((((m.monthly_orders * 1.0 / NULLIF(m.days_recorded, 0)) * DAY(DATE_TRUNC('month', m.bulan) + INTERVAL '1 month' - INTERVAL '1 day')) - b.baseline_orders) * 100.0 / NULLIF(b.baseline_orders, 0), 1) > 10 THEN 'Di atas ekspektasi'
        WHEN ROUND((((m.monthly_orders * 1.0 / NULLIF(m.days_recorded, 0)) * DAY(DATE_TRUNC('month', m.bulan) + INTERVAL '1 month' - INTERVAL '1 day')) - b.baseline_orders) * 100.0 / NULLIF(b.baseline_orders, 0), 1) < -10 THEN 'Di bawah ekspektasi'
        ELSE 'On track'
    END AS projection_status,
    CASE WHEN DATE_TRUNC('month', m.bulan) = DATE_TRUNC('month', max_d.max_date) THEN 1 ELSE 0 END AS is_current_month,
    CASE
        WHEN DATE_TRUNC('month', m.bulan) = DATE_TRUNC('month', max_d.max_date) THEN '🟡 Bulan berjalan'
        ELSE '✅ Bulan lengkap'
    END AS status_bulan,
    CASE
        WHEN DATE_TRUNC('month', m.bulan) = DATE_TRUNC('month', max_d.max_date)
            THEN 'Data baru sampai ' || strftime('%d %b %Y', m.max_order_date) || ' (' || CAST(m.days_recorded AS VARCHAR) || ' hari tercatat)'
        ELSE 'Data bulan penuh'
    END AS catatan_bulan
FROM monthly m
CROSS JOIN max_d
LEFT JOIN baseline_same_month b USING (bulan_num)
ORDER BY m.bulan DESC
