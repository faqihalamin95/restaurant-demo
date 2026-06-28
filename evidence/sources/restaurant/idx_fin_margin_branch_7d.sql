SELECT branch_name,
    ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS net_margin_pct,
    CASE WHEN ROUND(SUM(net_revenue)/NULLIF(SUM(gross_revenue),0)*100,1) >= 15 THEN ROUND(SUM(net_revenue)/NULLIF(SUM(gross_revenue),0)*100,1) ELSE NULL END AS margin_sehat,
    CASE WHEN ROUND(SUM(net_revenue)/NULLIF(SUM(gross_revenue),0)*100,1) >= 10 AND ROUND(SUM(net_revenue)/NULLIF(SUM(gross_revenue),0)*100,1) < 15 THEN ROUND(SUM(net_revenue)/NULLIF(SUM(gross_revenue),0)*100,1) ELSE NULL END AS margin_waspada,
    CASE WHEN ROUND(SUM(net_revenue)/NULLIF(SUM(gross_revenue),0)*100,1) < 10 THEN ROUND(SUM(net_revenue)/NULLIF(SUM(gross_revenue),0)*100,1) ELSE NULL END AS margin_kritis
FROM main_marts.mart_daily_net_revenue
WHERE metric_date >= (SELECT MAX(metric_date) FROM main_marts.mart_daily_net_revenue) - INTERVAL '6 days'
GROUP BY branch_name ORDER BY net_margin_pct DESC
