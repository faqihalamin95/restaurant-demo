SELECT branch_name, total_revenue, total_orders,
    ROUND(total_revenue / NULLIF(total_orders, 0), 0) AS avg_order_value,
    ROUND(revenue_sdow_avg, 0)                        AS revenue_sdow_avg,
    pct_change_vs_sdow_avg
FROM main_marts.mart_daily_revenue
WHERE order_date = (SELECT MAX(order_date) FROM main_marts.mart_daily_revenue)
ORDER BY total_revenue DESC
