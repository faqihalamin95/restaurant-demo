WITH max_date AS (SELECT MAX(order_date) AS d FROM main_marts.mart_daily_revenue)
SELECT
    branch_name,
    SUM(CASE WHEN order_date >= (SELECT d FROM max_date) - INTERVAL '6 days' THEN total_revenue END) AS revenue_this_week,
    SUM(CASE WHEN order_date <  (SELECT d FROM max_date) - INTERVAL '6 days'
          AND order_date >= (SELECT d FROM max_date) - INTERVAL '13 days' THEN total_revenue END) AS revenue_last_week,
    ROUND(
        (
            SUM(CASE WHEN order_date >= (SELECT d FROM max_date) - INTERVAL '6 days' THEN total_revenue END)
            -
            SUM(CASE WHEN order_date < (SELECT d FROM max_date) - INTERVAL '6 days'
                  AND order_date >= (SELECT d FROM max_date) - INTERVAL '13 days' THEN total_revenue END)
        ) /
        NULLIF(
            SUM(CASE WHEN order_date < (SELECT d FROM max_date) - INTERVAL '6 days'
                  AND order_date >= (SELECT d FROM max_date) - INTERVAL '13 days' THEN total_revenue END)
        , 0) * 100
    , 1) AS pct_change
FROM main_marts.mart_daily_revenue
GROUP BY branch_name
ORDER BY pct_change DESC
