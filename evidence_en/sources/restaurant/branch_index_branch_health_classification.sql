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
        -- Bandingkan rata-rata order harian aktif (30h) vs baseline 90h
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
        r.active_revenue,
        r.active_orders,
        r.active_aov,
        r.baseline_change_pct,
        a.active_margin_pct,
        n.recent_margin_pct,
        h.historical_margin_pct,
        CASE
            WHEN a.active_margin_pct >= 10 AND n.recent_margin_pct >= 10 THEN 'Healthy'
            WHEN a.active_margin_pct >= 5 AND a.active_margin_pct < 10 AND n.recent_margin_pct >= 10 THEN 'Warning'
            WHEN a.active_margin_pct < 5 AND n.recent_margin_pct >= 10 THEN 'Early Warning'
            WHEN a.active_margin_pct >= 10 AND n.recent_margin_pct < 10 THEN 'Recovering'
            WHEN a.active_margin_pct >= 5 AND a.active_margin_pct < 10 AND n.recent_margin_pct < 5 THEN 'Recovering'
            WHEN a.active_margin_pct >= 5 AND a.active_margin_pct < 10 AND n.recent_margin_pct >= 5 AND n.recent_margin_pct < 10 THEN 'Stagnant'
            WHEN a.active_margin_pct < 5 AND n.recent_margin_pct < 10 THEN 'Distressed'
            ELSE 'Warning'
        END AS health_status
    FROM active_rev r
    LEFT JOIN active_net a ON r.branch_name = a.branch_name
    LEFT JOIN recent_net n ON r.branch_name = n.branch_name
    LEFT JOIN historical_net h ON r.branch_name = h.branch_name
)
SELECT *,
    CASE health_status
        WHEN 'Healthy' THEN '30D and 90D margins are strong (>= 10%). Use as operational benchmark.'
        WHEN 'Warning' THEN '30D margin softening (5-10%), but 90D baseline is still healthy (>= 10%). Monitor closely.'
        WHEN 'Early Warning' THEN '30D margin dropped sharply (< 5%) despite healthy 90D baseline (>= 10%). Audit last 30 days.'
        WHEN 'Recovering' THEN '30D margin is healthy (>= 10%) or improving from a weak 90D baseline. Maintain this momentum.'
        WHEN 'Stagnant' THEN '30D and 90D margins are moderate (5-10%). Not a crisis, but not yet optimal.'
        WHEN 'Distressed' THEN '30D and 90D margins are both weak (< 5%). Structural improvements needed.'
        ELSE 'Monitor margin developments over the next few days.'
    END AS diagnosis,
    CASE health_status
        WHEN 'Healthy' THEN 'Further Analysis'
        WHEN 'Warning' THEN 'Further Analysis'
        WHEN 'Early Warning' THEN 'Further Analysis / Deep Dive'
        WHEN 'Recovering' THEN 'Deep Dive'
        WHEN 'Stagnant' THEN 'Further Analysis'
        WHEN 'Distressed' THEN 'Action Center / Deep Dive'
        ELSE 'Summary'
    END AS recommended_next_page,
    CASE health_status
        WHEN 'Distressed' THEN 1
        WHEN 'Early Warning' THEN 2
        WHEN 'Stagnant' THEN 3
        WHEN 'Recovering' THEN 4
        WHEN 'Warning' THEN 5
        WHEN 'Healthy' THEN 7
        ELSE 7
    END AS sort_priority
FROM classified
ORDER BY sort_priority ASC, active_margin_pct ASC
