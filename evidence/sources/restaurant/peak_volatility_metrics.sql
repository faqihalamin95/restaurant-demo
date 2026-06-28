WITH daily AS (
    SELECT
        order_date,
        DAYNAME(order_date) AS day_name,
        SUM(total_orders) AS daily_orders
    FROM main_marts.mart_peak_hours
    WHERE order_date >= (SELECT MAX(order_date) FROM main_marts.mart_peak_hours) - INTERVAL '29 days'
    GROUP BY order_date, DAYNAME(order_date)
),
day_baseline AS (
    SELECT
        day_name,
        AVG(daily_orders) AS expected_orders
    FROM daily
    GROUP BY day_name
),
scored AS (
    SELECT
        d.order_date,
        d.day_name,
        d.daily_orders,
        b.expected_orders,
        ROUND((d.daily_orders - b.expected_orders) * 100.0 / NULLIF(b.expected_orders, 0), 1) AS deviation_pct
    FROM daily d
    JOIN day_baseline b USING (day_name)
),
stats AS (
    SELECT
        AVG(expected_orders) AS avg_orders,
        MAX(daily_orders) AS max_orders,
        MIN(daily_orders) AS min_orders,
        ROUND(AVG(ABS(deviation_pct)), 1) AS avg_abs_deviation_pct,
        COUNT(*) AS total_days
    FROM scored
),
anomalies AS (
    SELECT
        COUNT(CASE WHEN deviation_pct >= 25 THEN 1 END) AS spike_days,
        COUNT(CASE WHEN deviation_pct <= -25 THEN 1 END) AS drop_days
    FROM scored
),
spike_day AS (
    SELECT
        order_date AS spike_date,
        daily_orders AS spike_orders,
        ROUND(expected_orders, 0) AS spike_expected_orders,
        deviation_pct AS spike_deviation_pct
    FROM scored
    ORDER BY deviation_pct DESC
    LIMIT 1
),
drop_day AS (
    SELECT
        order_date AS drop_date,
        daily_orders AS drop_orders,
        ROUND(expected_orders, 0) AS drop_expected_orders,
        deviation_pct AS drop_deviation_pct
    FROM scored
    ORDER BY deviation_pct ASC
    LIMIT 1
)
SELECT
    ROUND(s.avg_orders, 0)  AS avg_orders,
    s.max_orders, s.min_orders, s.avg_abs_deviation_pct, s.total_days,
    a.spike_days, a.drop_days, (a.spike_days + a.drop_days) AS anomaly_days,
    s.avg_abs_deviation_pct AS cv_pct,
    sp.spike_date, sp.spike_orders, sp.spike_expected_orders, sp.spike_deviation_pct,
    dr.drop_date, dr.drop_orders, dr.drop_expected_orders, dr.drop_deviation_pct,
    CASE
        WHEN s.avg_abs_deviation_pct > 20 THEN 'tinggi'
        WHEN s.avg_abs_deviation_pct > 10 THEN 'sedang'
        ELSE 'rendah'
    END AS volatility_level,
    CASE
        WHEN s.avg_abs_deviation_pct > 100 THEN 0
        ELSE ROUND(100 - s.avg_abs_deviation_pct, 0)
    END AS stability_index
FROM stats s, anomalies a, spike_day sp, drop_day dr
