WITH max_d AS (SELECT MAX(metric_date)::DATE AS d FROM main_marts.mart_daily_net_revenue)
SELECT
    metric_date,
    ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS margin_pct
FROM main_marts.mart_daily_net_revenue CROSS JOIN max_d
WHERE metric_date >= DATE_TRUNC('month', d)
GROUP BY metric_date
ORDER BY metric_date
