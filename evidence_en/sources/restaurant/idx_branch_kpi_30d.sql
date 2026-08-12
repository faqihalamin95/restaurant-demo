SELECT branch_name, SUM(total_revenue) AS total_revenue, SUM(total_orders) AS total_orders,
    ROUND(SUM(total_revenue)/NULLIF(SUM(total_orders),0),0) AS avg_order_value,
    ROUND(SUM(total_revenue)/NULLIF(COUNT(DISTINCT order_date),0),0) AS avg_per_hari
FROM main_marts.mart_daily_revenue
WHERE order_date >= (SELECT MAX(order_date) FROM main_marts.mart_daily_revenue) - INTERVAL '29 days'
GROUP BY branch_name ORDER BY total_revenue DESC
