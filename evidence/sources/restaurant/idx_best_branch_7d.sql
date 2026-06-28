SELECT branch_name FROM main_marts.mart_daily_revenue
WHERE order_date >= (SELECT MAX(order_date) FROM main_marts.mart_daily_revenue) - INTERVAL '6 days'
GROUP BY branch_name ORDER BY SUM(total_revenue) DESC LIMIT 1
