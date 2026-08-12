SELECT
    branch_name,
    DATE_TRUNC('quarter', metric_date) AS qtr_date,
    'Q' || date_part('quarter', metric_date) || ' ' || date_part('year', metric_date) AS quarter_name,
    SUM(gross_revenue) AS gross_revenue,
    SUM(net_revenue) AS net_revenue,
    ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS net_margin_pct
FROM main_marts.mart_daily_net_revenue
GROUP BY branch_name, qtr_date, quarter_name
ORDER BY branch_name, qtr_date DESC
