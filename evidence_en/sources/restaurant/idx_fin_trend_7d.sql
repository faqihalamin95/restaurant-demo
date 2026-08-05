SELECT metric_date, SUM(gross_revenue) AS gross_revenue, SUM(net_revenue) AS net_revenue
FROM main_marts.mart_daily_net_revenue
WHERE metric_date >= (SELECT MAX(metric_date) FROM main_marts.mart_daily_net_revenue) - INTERVAL '6 days'
GROUP BY metric_date ORDER BY metric_date
