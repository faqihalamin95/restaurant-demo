SELECT order_date, branch_name, total_revenue FROM main_marts.mart_daily_revenue
WHERE order_date >= (SELECT MAX(order_date) FROM main_marts.mart_daily_revenue) - INTERVAL '29 days'
ORDER BY order_date, branch_name
