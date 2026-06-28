SELECT
    order_hour,
    SUM(total_orders)  AS total_orders,
    SUM(total_revenue) AS total_revenue
FROM main_marts.mart_peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM main_marts.mart_peak_hours) - INTERVAL '29 days'
GROUP BY order_hour ORDER BY order_hour
