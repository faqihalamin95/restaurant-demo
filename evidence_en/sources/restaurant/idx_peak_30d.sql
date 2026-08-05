SELECT order_hour, order_type, SUM(total_orders) AS total_orders
FROM main_marts.mart_peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM main_marts.mart_peak_hours) - INTERVAL '29 days'
GROUP BY order_hour, order_type ORDER BY order_hour
