WITH max_d AS (SELECT MAX(order_date) AS d FROM main_marts.mart_daily_revenue),
stats AS (
    SELECT
        branch_name,
        SUM(CASE WHEN order_date >= (SELECT d FROM max_d) - INTERVAL '29 days' THEN total_orders ELSE 0 END) AS orders_this_period,
        SUM(CASE WHEN order_date < (SELECT d FROM max_d) - INTERVAL '29 days' AND order_date >= (SELECT d FROM max_d) - INTERVAL '59 days' THEN total_orders ELSE 0 END) AS orders_prev_period
    FROM main_marts.mart_daily_revenue
    GROUP BY branch_name
)
SELECT
    branch_name,
    orders_this_period AS "30h Sekarang",
    orders_prev_period AS "30h Lalu",
    ROUND((orders_this_period - orders_prev_period) / NULLIF(orders_prev_period, 0) * 100, 1) AS pct_change
FROM stats
ORDER BY "30h Sekarang" DESC
