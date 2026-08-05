WITH max_d AS (SELECT MAX(order_date)::DATE AS d FROM main_marts.mart_daily_revenue),
stats AS (
    SELECT
        branch_name,
        SUM(CASE WHEN order_date >= DATE_TRUNC('month', (SELECT d FROM max_d)) AND order_date <= (SELECT d FROM max_d) THEN total_orders ELSE 0 END) AS orders_this_period,
        SUM(CASE WHEN order_date >= DATE_TRUNC('month', (SELECT d FROM max_d) - INTERVAL '1 month') AND order_date <= ((SELECT d FROM max_d) - INTERVAL '1 month') THEN total_orders ELSE 0 END) AS orders_prev_period
    FROM main_marts.mart_daily_revenue
    GROUP BY branch_name
)
SELECT
    branch_name,
    orders_this_period AS "Bulan Ini",
    orders_prev_period AS "Bulan Lalu (mtd)",
    ROUND((orders_this_period - orders_prev_period) / NULLIF(orders_prev_period, 0) * 100, 1) AS pct_change
FROM stats
ORDER BY "Bulan Ini" DESC
