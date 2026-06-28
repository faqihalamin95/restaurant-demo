-- Cache-breaker comment: force reload 2026-06-22
WITH max_n AS (SELECT MAX(metric_date) AS d FROM main_marts.mart_daily_net_revenue),
max_d AS (SELECT MAX(order_date) AS d FROM main_marts.mart_daily_revenue),
rev_stats AS (
    SELECT branch_name,
        SUM(CASE WHEN order_date >= d - INTERVAL '29 days' THEN total_revenue ELSE 0 END) AS active_revenue,
        SUM(CASE WHEN order_date >= d - INTERVAL '29 days' THEN total_orders ELSE 0 END) AS active_orders,
        SUM(CASE WHEN order_date >= d - INTERVAL '89 days' THEN total_orders ELSE 0 END) AS baseline_orders_90d
    FROM main_marts.mart_daily_revenue CROSS JOIN max_d
    GROUP BY branch_name
),
active_rev AS (
    SELECT branch_name,
        active_revenue,
        active_orders,
        ROUND(active_revenue / NULLIF(active_orders, 0), 0) AS active_aov,
        ROUND(((active_orders / 30.0) - (baseline_orders_90d / 90.0)) / NULLIF(baseline_orders_90d / 90.0, 0) * 100, 1) AS baseline_change_pct
    FROM rev_stats
),
active_net AS (
    SELECT branch_name,
        ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS active_margin_pct
    FROM main_marts.mart_daily_net_revenue CROSS JOIN max_n
    WHERE metric_date >= d - INTERVAL '29 days'
    GROUP BY branch_name
),
recent_net AS (
    SELECT branch_name,
        ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS recent_margin_pct
    FROM main_marts.mart_daily_net_revenue CROSS JOIN max_n
    WHERE metric_date >= d - INTERVAL '89 days'
    GROUP BY branch_name
),
historical_net AS (
    SELECT branch_name,
        ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS historical_margin_pct
    FROM main_marts.mart_daily_net_revenue
    GROUP BY branch_name
),
classified AS (
    SELECT
        r.branch_name,
        a.active_margin_pct,
        n.recent_margin_pct,
        h.historical_margin_pct,
        CASE
            WHEN a.active_margin_pct >= 15 AND n.recent_margin_pct >= 15 THEN 'Sehat'
            WHEN a.active_margin_pct >= 10 AND a.active_margin_pct < 15 AND n.recent_margin_pct >= 15 THEN 'Waspada'
            WHEN a.active_margin_pct < 10 AND n.recent_margin_pct >= 15 THEN 'Early Warning'
            WHEN a.active_margin_pct >= 15 AND n.recent_margin_pct < 15 THEN 'Recovery'
            WHEN a.active_margin_pct >= 10 AND a.active_margin_pct < 15 AND n.recent_margin_pct < 10 THEN 'Membaik'
            WHEN a.active_margin_pct >= 10 AND a.active_margin_pct < 15 AND n.recent_margin_pct >= 10 AND n.recent_margin_pct < 15 THEN 'Stabil Rendah'
            WHEN a.active_margin_pct < 10 AND n.recent_margin_pct >= 10 THEN 'Turnaround'
            WHEN a.active_margin_pct < 10 AND n.recent_margin_pct < 10 THEN 'Turnaround'
            ELSE 'Waspada'
        END AS health_status
    FROM active_rev r
    LEFT JOIN active_net a ON r.branch_name = a.branch_name
    LEFT JOIN recent_net n ON r.branch_name = n.branch_name
    LEFT JOIN historical_net h ON r.branch_name = h.branch_name
)
SELECT
    COUNT(CASE WHEN health_status = 'Sehat' THEN 1 END) AS sehat_count,
    COUNT(CASE WHEN health_status = 'Waspada' THEN 1 END) AS waspada_count,
    COUNT(CASE WHEN health_status = 'Early Warning' THEN 1 END) AS early_warning_count,
    COUNT(CASE WHEN health_status = 'Recovery' THEN 1 END) AS recovery_count,
    COUNT(CASE WHEN health_status = 'Membaik' THEN 1 END) AS membaik_count,
    COUNT(CASE WHEN health_status = 'Stabil Rendah' THEN 1 END) AS stabil_rendah_count,
    COUNT(CASE WHEN health_status = 'Turnaround' THEN 1 END) AS turnaround_count,
    MAX(CASE WHEN health_status IN ('Turnaround', 'Early Warning') THEN branch_name END) AS priority_branch,
    MAX(CASE WHEN health_status IN ('Turnaround', 'Early Warning') THEN health_status END) AS priority_status,
    MIN(CASE WHEN health_status IN ('Turnaround', 'Early Warning') THEN active_margin_pct END) AS priority_active_margin,
    MIN(CASE WHEN health_status IN ('Turnaround', 'Early Warning') THEN recent_margin_pct END) AS priority_recent_margin,
    MIN(CASE WHEN health_status IN ('Turnaround', 'Early Warning') THEN historical_margin_pct END) AS priority_historical_margin
FROM classified

