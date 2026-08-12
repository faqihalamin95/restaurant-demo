WITH daily_total AS (
    SELECT order_date, SUM(total_revenue) AS daily_rev
    FROM main_marts.mart_daily_revenue
    GROUP BY order_date
),
max_d AS (SELECT MAX(order_date) AS d FROM main_marts.mart_daily_revenue)
SELECT
    (SELECT daily_rev FROM daily_total WHERE order_date = (SELECT d FROM max_d)) AS gross_yesterday,
    ROUND(AVG(daily_rev), 0)                                                      AS sdow_avg,
    ROUND(
        ((SELECT daily_rev FROM daily_total WHERE order_date = (SELECT d FROM max_d)) - AVG(daily_rev))
        / NULLIF(AVG(daily_rev), 0) * 100
    , 1)                                                                           AS pct_change_sdow
FROM daily_total, max_d
WHERE order_date < d
  AND DAYOFWEEK(order_date) = DAYOFWEEK(d)
  AND order_date >= d - INTERVAL '30 days'
