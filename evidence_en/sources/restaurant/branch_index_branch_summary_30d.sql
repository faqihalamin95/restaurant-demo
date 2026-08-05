SELECT
    dr.branch_name,
    SUM(dr.total_revenue) AS total_revenue,
    SUM(dr.total_orders) AS total_orders,
    ROUND(SUM(dr.total_revenue) / NULLIF(SUM(dr.total_orders), 0), 0) AS avg_order_value,
    ROUND(AVG(dr.pct_change_vs_sdow_avg) * 100, 1) AS avg_pct_vs_sdow,
    SUM(nr.net_revenue) AS net_revenue,
    ROUND(SUM(nr.net_revenue) / NULLIF(SUM(nr.gross_revenue), 0) * 100, 1) AS net_margin_pct
FROM main_marts.mart_daily_revenue dr
LEFT JOIN main_marts.mart_daily_net_revenue nr
    ON dr.order_date = nr.metric_date AND dr.branch_id = nr.branch_id
WHERE dr.order_date >= (SELECT MAX(order_date) FROM main_marts.mart_daily_revenue) - INTERVAL '29 days'
GROUP BY dr.branch_name
ORDER BY total_revenue DESC
