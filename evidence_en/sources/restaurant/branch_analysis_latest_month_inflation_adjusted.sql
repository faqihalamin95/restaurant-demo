WITH latest_completed_month AS (
    SELECT DATE_TRUNC('month', MAX(order_date) - INTERVAL '1 month') AS m 
    FROM main_marts.mart_daily_revenue
),
monthly_rev AS (
    SELECT
        DATE_TRUNC('month', order_date) AS order_month,
        branch_name,
        SUM(total_revenue) AS nominal_revenue
    FROM main_marts.mart_daily_revenue
    WHERE order_date < DATE_TRUNC('month', (SELECT MAX(order_date) FROM main_marts.mart_daily_revenue))
    GROUP BY 1, 2
),
months_numbered AS (
    SELECT
        order_month,
        branch_name,
        nominal_revenue,
        DENSE_RANK() OVER (ORDER BY order_month ASC) - 1 AS month_index
    FROM monthly_rev
)
SELECT
    m.branch_name,
    m.nominal_revenue,
    ROUND(m.nominal_revenue / POWER(1.0 + 0.003, m.month_index), 0) AS real_revenue
FROM months_numbered m
JOIN latest_completed_month lcm ON m.order_month = lcm.m
ORDER BY m.nominal_revenue DESC
