WITH latest_completed_month AS (
    SELECT DATE_TRUNC('month', MAX(order_date) - INTERVAL '1 month') AS m 
    FROM main_marts.mart_daily_revenue
),
monthly_metrics AS (
    SELECT
        DATE_TRUNC('month', order_date) AS order_month,
        branch_name,
        SUM(total_revenue) AS total_revenue,
        SUM(total_orders) AS total_orders,
        ROUND(SUM(total_revenue) / NULLIF(SUM(total_orders), 0), 0) AS avg_order_value
    FROM main_marts.mart_daily_revenue
    WHERE order_date < DATE_TRUNC('month', (SELECT MAX(order_date) FROM main_marts.mart_daily_revenue))
    GROUP BY 1, 2
),
monthly_lag AS (
    SELECT
        order_month,
        branch_name,
        total_revenue,
        total_orders,
        avg_order_value,
        LAG(total_revenue) OVER (PARTITION BY branch_name ORDER BY order_month) AS prev_revenue,
        LAG(total_orders) OVER (PARTITION BY branch_name ORDER BY order_month) AS prev_orders,
        LAG(avg_order_value) OVER (PARTITION BY branch_name ORDER BY order_month) AS prev_aov
    FROM monthly_metrics
),
growth_driver AS (
    SELECT
        order_month,
        branch_name,
        ROUND((total_revenue - prev_revenue) / NULLIF(prev_revenue, 0) * 100, 1) AS revenue_growth_pct,
        ROUND((total_orders - prev_orders) / NULLIF(prev_orders, 0) * 100, 1) AS order_growth_pct,
        ROUND((avg_order_value - prev_aov) / NULLIF(prev_aov, 0) * 100, 1) AS aov_growth_pct
    FROM monthly_lag
    WHERE prev_revenue IS NOT NULL
)
SELECT gd.* 
FROM growth_driver gd
JOIN latest_completed_month lcm ON gd.order_month = lcm.m
ORDER BY gd.revenue_growth_pct DESC
