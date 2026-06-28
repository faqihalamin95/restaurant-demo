WITH anchor_date AS (SELECT MAX(order_date) AS d FROM main_marts.mart_daily_revenue)
SELECT branch_name, total_revenue FROM main_marts.mart_daily_revenue
WHERE order_date = (SELECT d FROM anchor_date)
ORDER BY total_revenue DESC LIMIT 1
