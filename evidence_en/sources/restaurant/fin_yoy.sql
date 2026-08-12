SELECT
    YEAR(metric_date) AS tahun,
    SUM(gross_revenue) AS gross,
    SUM(net_revenue) AS net,
    ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS margin_pct,
    SUM(inventory_usage_cost + labor_total_cost + operational_total_cost) AS total_biaya,
    ROUND(SUM(inventory_usage_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS bahan_pct,
    ROUND(SUM(labor_total_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS sdm_pct,
    ROUND(SUM(operational_total_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS ops_pct
FROM main_marts.mart_daily_net_revenue
GROUP BY 1
ORDER BY 1 DESC
