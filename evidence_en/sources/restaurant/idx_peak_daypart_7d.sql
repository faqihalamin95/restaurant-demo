SELECT day_part AS periode, SUM(total_orders) AS total_orders
FROM main_marts.mart_peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM main_marts.mart_peak_hours) - INTERVAL '6 days'
GROUP BY day_part ORDER BY total_orders DESC LIMIT 1
