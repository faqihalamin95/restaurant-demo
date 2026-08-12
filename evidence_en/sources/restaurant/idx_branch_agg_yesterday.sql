WITH daily_orders AS (
    SELECT order_date, SUM(total_orders) AS daily_orders
    FROM main_marts.mart_daily_revenue
    GROUP BY order_date
),
max_d AS (SELECT MAX(order_date) AS d FROM main_marts.mart_daily_revenue),
sdow_stats AS (
    SELECT
        AVG(daily_orders) AS sdow_avg_orders
    FROM daily_orders, max_d
    WHERE order_date < d
      AND DAYOFWEEK(order_date) = DAYOFWEEK(d)
      AND order_date >= d - INTERVAL '30 days'
),
current_stats AS (
    SELECT
        SUM(total_orders) AS total_orders_all,
        ROUND(SUM(total_revenue) / NULLIF(SUM(total_orders), 0), 0) AS aov_avg,
        ROUND((MAX(total_revenue) - MIN(total_revenue)) / NULLIF(MIN(total_revenue), 0) * 100, 1) AS gap_pct
    FROM main_marts.mart_daily_revenue
    WHERE order_date = (SELECT d FROM max_d)
)
SELECT
    c.*,
    s.sdow_avg_orders,
    ROUND((c.total_orders_all - s.sdow_avg_orders) / NULLIF(s.sdow_avg_orders, 0) * 100, 1) AS pct_change_orders_sdow
FROM current_stats c, sdow_stats s
