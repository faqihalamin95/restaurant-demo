WITH max_d AS (SELECT MAX(order_date) AS d FROM main_marts.mart_daily_revenue),
sdow_avg AS (
    SELECT branch_name,
        ROUND(AVG(total_revenue), 0) AS sdow_avg
    FROM main_marts.mart_daily_revenue, max_d
    WHERE order_date < d
      AND DAYOFWEEK(order_date) = DAYOFWEEK(d)
      AND order_date >= d - INTERVAL '30 days'
    GROUP BY branch_name
),
today AS (
    SELECT branch_name, total_revenue AS gross_yesterday
    FROM main_marts.mart_daily_revenue, max_d
    WHERE order_date = d
)
SELECT
    t.branch_name,
    t.gross_yesterday,
    s.sdow_avg,
    ROUND((t.gross_yesterday - s.sdow_avg) / NULLIF(s.sdow_avg, 0) * 100, 1) AS pct_change_sdow
FROM today t
LEFT JOIN sdow_avg s ON t.branch_name = s.branch_name
ORDER BY pct_change_sdow DESC
