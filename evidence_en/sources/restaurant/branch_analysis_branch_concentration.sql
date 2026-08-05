WITH s30 AS (
    SELECT branch_name, SUM(total_revenue) AS revenue_30d
    FROM main_marts.mart_daily_revenue
    WHERE order_date >= (SELECT MAX(order_date) FROM main_marts.mart_daily_revenue) - INTERVAL '29 days'
    GROUP BY branch_name
),
a AS (
    SELECT branch_name, SUM(total_revenue) AS revenue_alltime
    FROM main_marts.mart_daily_revenue
    GROUP BY branch_name
),
r30 AS (
    SELECT *, ROW_NUMBER() OVER (ORDER BY revenue_30d DESC) AS rn,
        SUM(revenue_30d) OVER () AS total_rev
    FROM s30
),
ra AS (
    SELECT *, ROW_NUMBER() OVER (ORDER BY revenue_alltime DESC) AS rn,
        SUM(revenue_alltime) OVER () AS total_rev
    FROM a
)
SELECT
    MAX(CASE WHEN r30.rn = 1 THEN r30.branch_name END) AS top_branch_30d,
    MAX(CASE WHEN r30.rn = 1 THEN ROUND(r30.revenue_30d / NULLIF(r30.total_rev, 0) * 100, 1) END) AS top_share_30d,
    MAX(CASE WHEN r30.rn = 2 THEN r30.branch_name END) AS second_branch_30d,
    MAX(CASE WHEN r30.rn = 2 THEN ROUND(r30.revenue_30d / NULLIF(r30.total_rev, 0) * 100, 1) END) AS second_share_30d,
    MAX(CASE WHEN r30.rn = (SELECT MAX(rn) FROM r30) THEN r30.branch_name END) AS bottom_branch_30d,
    MAX(CASE WHEN ra.rn = 1 THEN ra.branch_name END) AS top_branch_alltime,
    MAX(CASE WHEN ra.rn = 1 THEN ROUND(ra.revenue_alltime / NULLIF(ra.total_rev, 0) * 100, 1) END) AS top_share_alltime
FROM r30 CROSS JOIN ra
