SELECT
    branch_name,
    ROUND(MIN(total_revenue), 0) AS min_daily_revenue,
    ROUND(AVG(total_revenue), 0) AS avg_daily_revenue,
    ROUND(MAX(total_revenue), 0) AS max_daily_revenue,
    ROUND(MAX(total_revenue) - MIN(total_revenue), 0) AS daily_range_revenue,
    ROUND((MAX(total_revenue) - MIN(total_revenue)) / NULLIF(AVG(total_revenue), 0), 4) AS fluctuation_pct
FROM main_marts.mart_daily_revenue
WHERE order_date >= (SELECT MAX(order_date) FROM main_marts.mart_daily_revenue) - INTERVAL '29 days'
GROUP BY branch_name
ORDER BY avg_daily_revenue DESC
