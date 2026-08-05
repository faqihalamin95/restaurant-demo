WITH base AS (
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
    SELECT day_name, AVG(daily_orders) AS expected_orders
    FROM daily
    GROUP BY day_name
),
scored AS (
    SELECT
        d.order_date,
        d.daily_orders,
        ROUND(b.expected_orders, 0) AS expected_orders,
        ROUND((d.daily_orders - b.expected_orders) * 100.0 / NULLIF(b.expected_orders, 0), 1) AS deviation_pct
    FROM daily d
    JOIN day_baseline b USING (day_name)
)
SELECT
    order_date,
    daily_orders,
    expected_orders,
    CASE WHEN deviation_pct >= 25 THEN 'Lonjakan' ELSE 'Penurunan' END AS status,
    deviation_pct AS selisih_pct
FROM scored
WHERE deviation_pct >= 25 OR deviation_pct <= -25
ORDER BY order_date
),
dummy AS (
    SELECT 
        CAST(NULL AS DATE) AS order_date,
        CAST(NULL AS HUGEINT) AS daily_orders,
        CAST(NULL AS DOUBLE) AS expected_orders,
        CAST(NULL AS VARCHAR) AS status,
        CAST(NULL AS DOUBLE) AS selisih_pct
    WHERE NOT EXISTS (SELECT 1 FROM base)
)
SELECT * FROM base
UNION ALL
SELECT * FROM dummy
