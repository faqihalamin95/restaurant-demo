WITH max_n AS (SELECT MAX(metric_date) AS d FROM main_marts.mart_daily_net_revenue),
p30 AS (
    SELECT
        branch_name,
        SUM(gross_revenue) AS gross_30d,
        SUM(net_revenue) AS net_30d,
        ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS margin_30d,
        ROUND(SUM(inventory_usage_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS ingredients_30d,
        ROUND(SUM(labor_total_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS labor_30d,
        ROUND(SUM(operational_total_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS overhead_30d
    FROM main_marts.mart_daily_net_revenue CROSS JOIN max_n
    WHERE metric_date >= d - INTERVAL '29 days'
    GROUP BY branch_name
),
p90 AS (
    SELECT
        branch_name,
        ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS margin_90d
    FROM main_marts.mart_daily_net_revenue CROSS JOIN max_n
    WHERE metric_date >= d - INTERVAL '89 days'
    GROUP BY branch_name
),
hist AS (
    SELECT
        branch_name,
        ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS margin_historical
    FROM main_marts.mart_daily_net_revenue
    GROUP BY branch_name
)
SELECT
    p30.branch_name,
    p30.gross_30d,
    p30.net_30d,
    p30.margin_30d,
    p90.margin_90d,
    hist.margin_historical,
    ROUND(p30.margin_30d - p90.margin_90d, 1) AS margin_gap_30_vs_90,
    p30.ingredients_30d,
    p30.labor_30d,
    p30.overhead_30d
FROM p30
LEFT JOIN p90 ON p30.branch_name = p90.branch_name
LEFT JOIN hist ON p30.branch_name = hist.branch_name
ORDER BY p30.margin_30d ASC
