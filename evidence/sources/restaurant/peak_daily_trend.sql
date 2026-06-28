SELECT order_date, SUM(total_orders) AS daily_orders, SUM(total_revenue) AS daily_revenue
FROM main_marts.mart_peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM main_marts.mart_peak_hours) - INTERVAL '29 days'
GROUP BY order_date ORDER BY order_date
