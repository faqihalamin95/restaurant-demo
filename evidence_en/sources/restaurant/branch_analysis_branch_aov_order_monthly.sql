SELECT
    DATE_TRUNC('month', order_date) AS order_month,
    branch_name,
    SUM(total_orders) AS total_orders,
    ROUND(SUM(total_revenue) / NULLIF(SUM(total_orders), 0), 0) AS avg_order_value
FROM main_marts.mart_daily_revenue
WHERE order_date < DATE_TRUNC('month', (SELECT MAX(order_date) FROM main_marts.mart_daily_revenue))
GROUP BY 1, 2
ORDER BY 1, 2
