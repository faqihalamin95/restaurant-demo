WITH anchor_date AS (SELECT MAX(order_date) AS d FROM main_marts.mart_daily_revenue)
SELECT SUM(gross_revenue) AS gross_revenue, SUM(net_revenue) AS net_revenue,
    ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS net_margin_pct
FROM main_marts.mart_daily_net_revenue
WHERE metric_date >= (SELECT d FROM anchor_date) - INTERVAL '29 days'
  AND metric_date <= (SELECT d FROM anchor_date)
