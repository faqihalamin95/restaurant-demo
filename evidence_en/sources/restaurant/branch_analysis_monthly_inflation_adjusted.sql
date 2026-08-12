WITH monthly_rev AS (
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
    order_month,
    branch_name,
    nominal_revenue,
    ROUND(nominal_revenue / POWER(1.0 + 0.003, month_index), 0) AS real_revenue,
    ROUND(nominal_revenue - (nominal_revenue / POWER(1.0 + 0.003, month_index)), 0) AS inflation_loss
FROM months_numbered
ORDER BY order_month, branch_name
