WITH max_d AS (SELECT MAX(order_date) AS d FROM main_marts.mart_daily_revenue),
max_n AS (SELECT MAX(metric_date) AS d FROM main_marts.mart_daily_net_revenue),
current_year AS (SELECT EXTRACT(YEAR FROM d) as y FROM max_d),
active_rev AS (
    SELECT branch_name,
        SUM(total_orders) AS active_orders
    FROM main_marts.mart_daily_revenue CROSS JOIN current_year
    WHERE EXTRACT(YEAR FROM order_date) = y
    GROUP BY branch_name
),
active_net AS (
    SELECT branch_name,
        ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS active_margin_pct
    FROM main_marts.mart_daily_net_revenue CROSS JOIN current_year
    WHERE EXTRACT(YEAR FROM metric_date) = y
    GROUP BY branch_name
),
prev_rev AS (
    SELECT branch_name,
        SUM(total_orders) AS prev_orders
    FROM main_marts.mart_daily_revenue CROSS JOIN current_year CROSS JOIN max_d
    WHERE EXTRACT(YEAR FROM order_date) = y - 1
      AND order_date <= max_d.d - INTERVAL '1 year'
    GROUP BY branch_name
),
prev_net AS (
    SELECT branch_name,
        ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS prev_margin_pct
    FROM main_marts.mart_daily_net_revenue CROSS JOIN current_year CROSS JOIN max_n
    WHERE EXTRACT(YEAR FROM metric_date) = y - 1
      AND metric_date <= max_n.d - INTERVAL '1 year'
    GROUP BY branch_name
),
historical_net AS (
    SELECT branch_name,
        ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS historical_margin_pct
    FROM main_marts.mart_daily_net_revenue
    GROUP BY branch_name
)
SELECT 
    a.branch_name,
    a.active_orders,
    pr.prev_orders,
    n.active_margin_pct,
    pn.prev_margin_pct,
    h.historical_margin_pct,
    ROUND((a.active_orders - pr.prev_orders) / CAST(NULLIF(pr.prev_orders, 0) AS FLOAT) * 100, 1) as baseline_change_pct,
    CASE 
        WHEN n.active_margin_pct >= 10 AND pn.prev_margin_pct >= 10 THEN 'Sehat (YTD)'
        WHEN n.active_margin_pct < 5 AND pn.prev_margin_pct < 5 THEN 'Turnaround (YTD)'
        WHEN n.active_margin_pct < 5 AND pn.prev_margin_pct >= 10 THEN 'Waspada (YTD)'
        WHEN n.active_margin_pct >= 10 AND pn.prev_margin_pct < 10 THEN 'Recovery (YTD)'
        ELSE 'Stabil Rendah (YTD)'
    END as health_status
FROM active_rev a
LEFT JOIN active_net n ON a.branch_name = n.branch_name
LEFT JOIN prev_rev pr ON a.branch_name = pr.branch_name
LEFT JOIN prev_net pn ON a.branch_name = pn.branch_name
LEFT JOIN historical_net h ON a.branch_name = h.branch_name
ORDER BY a.active_orders DESC
