WITH anchor_date AS (SELECT MAX(order_date) AS d FROM main_marts.mart_daily_revenue),
period_stats AS (
    SELECT
        CASE
            WHEN order_date >= (SELECT d FROM anchor_date) - INTERVAL '29 days' THEN 'current'
            WHEN order_date >= (SELECT d FROM anchor_date) - INTERVAL '59 days'
             AND order_date < (SELECT d FROM anchor_date) - INTERVAL '29 days' THEN 'previous'
        END AS period,
        branch_name,
        SUM(total_revenue) AS branch_rev,
        SUM(total_orders)  AS total_orders
    FROM main_marts.mart_daily_revenue
    WHERE order_date >= (SELECT d FROM anchor_date) - INTERVAL '59 days'
      AND order_date <= (SELECT d FROM anchor_date)
    GROUP BY period, branch_name
),
current_agg AS (
    SELECT
        SUM(total_orders) AS total_orders_all,
        ROUND(SUM(branch_rev) / NULLIF(SUM(total_orders), 0), 0) AS aov_avg,
        ROUND((MAX(branch_rev) - MIN(branch_rev)) / NULLIF(MIN(branch_rev), 0) * 100, 1) AS gap_pct
    FROM period_stats
    WHERE period = 'current'
),
prev_agg AS (
    SELECT
        SUM(total_orders) AS total_orders_prev
    FROM period_stats
    WHERE period = 'previous'
)
SELECT
    c.*,
    p.total_orders_prev,
    ROUND((c.total_orders_all - p.total_orders_prev) / NULLIF(p.total_orders_prev, 0) * 100, 1) AS pct_change_orders_30d
FROM current_agg c, prev_agg p
