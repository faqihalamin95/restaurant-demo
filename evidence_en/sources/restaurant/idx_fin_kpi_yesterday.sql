SELECT SUM(gross_revenue) AS gross_revenue, SUM(net_revenue) AS net_revenue,
    ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS net_margin_pct
FROM main_marts.mart_daily_net_revenue
WHERE metric_date = (SELECT MAX(metric_date) FROM main_marts.mart_daily_net_revenue)
