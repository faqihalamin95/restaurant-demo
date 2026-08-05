WITH max_d AS (SELECT MAX(order_date) AS d FROM main_marts.mart_daily_revenue),
max_n AS (SELECT MAX(metric_date) AS d FROM main_marts.mart_daily_net_revenue),
-- Card 1: Revenue Concentration (last 30d)
rev_30d AS (
    SELECT branch_name, SUM(total_revenue) as rev
    FROM main_marts.mart_daily_revenue CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '29 days'
    GROUP BY branch_name
),
total_rev AS (SELECT SUM(rev) as tot FROM rev_30d),
top_rev AS (
    SELECT branch_name, rev, ROUND(rev / NULLIF((SELECT tot FROM total_rev), 0) * 100, 1) as share_pct
    FROM rev_30d ORDER BY rev DESC LIMIT 1
),
-- Card 2 & 4: Network Traffic & Network AOV (30d vs prev 30d)
traffic AS (
    SELECT 
        SUM(CASE WHEN order_date >= d - INTERVAL '29 days' THEN total_orders ELSE 0 END) as orders_30d,
        SUM(CASE WHEN order_date < d - INTERVAL '29 days' AND order_date >= d - INTERVAL '59 days' THEN total_orders ELSE 0 END) as orders_prev_30d,
        SUM(CASE WHEN order_date >= d - INTERVAL '29 days' THEN total_revenue ELSE 0 END) as rev_30d,
        SUM(CASE WHEN order_date < d - INTERVAL '29 days' AND order_date >= d - INTERVAL '59 days' THEN total_revenue ELSE 0 END) as rev_prev_30d
    FROM main_marts.mart_daily_revenue CROSS JOIN max_d
),
-- Card 5: Resilience Index (Margin > 15% for last 3 separate 30-day windows)
-- W1: 0-29 days ago, W2: 30-59 days ago, W3: 60-89 days ago
resilience_calc AS (
    SELECT branch_name,
        SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN net_revenue ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN gross_revenue ELSE 0 END), 0) * 100 as margin_w1,
        SUM(CASE WHEN metric_date < d - INTERVAL '29 days' AND metric_date >= d - INTERVAL '59 days' THEN net_revenue ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date < d - INTERVAL '29 days' AND metric_date >= d - INTERVAL '59 days' THEN gross_revenue ELSE 0 END), 0) * 100 as margin_w2,
        SUM(CASE WHEN metric_date < d - INTERVAL '59 days' AND metric_date >= d - INTERVAL '89 days' THEN net_revenue ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date < d - INTERVAL '59 days' AND metric_date >= d - INTERVAL '89 days' THEN gross_revenue ELSE 0 END), 0) * 100 as margin_w3
    FROM main_marts.mart_daily_net_revenue CROSS JOIN max_n
    GROUP BY branch_name
),
resilient_branches AS (
    SELECT COUNT(*) as resilient_count
    FROM resilience_calc
    WHERE margin_w1 >= 10 AND margin_w2 >= 10 AND margin_w3 >= 10
)
SELECT 
    (SELECT share_pct FROM top_rev) as top_branch_share_pct,
    (SELECT branch_name FROM top_rev) as top_branch_name,
    (SELECT orders_30d FROM traffic) as network_orders_30d,
    (SELECT ROUND((orders_30d - orders_prev_30d) / NULLIF(orders_prev_30d, 0) * 100, 1) FROM traffic) as network_orders_pct_change,
    (SELECT ROUND(rev_30d / NULLIF(orders_30d, 0), 0) FROM traffic) as network_aov_30d,
    (SELECT ROUND(((rev_30d / NULLIF(orders_30d, 0)) - (rev_prev_30d / NULLIF(orders_prev_30d, 0))) / NULLIF((rev_prev_30d / NULLIF(orders_prev_30d, 0)), 0) * 100, 1) FROM traffic) as network_aov_pct_change,
    (SELECT resilient_count FROM resilient_branches) as resilient_count
