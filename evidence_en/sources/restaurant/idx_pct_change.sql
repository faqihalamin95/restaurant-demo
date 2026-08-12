WITH anchor_date AS (SELECT MAX(order_date) AS d FROM main_marts.mart_daily_revenue)
SELECT
    ROUND(pct_change * 100, 1)      AS pct_change_display,
    ABS(ROUND(pct_change * 100, 1)) AS pct_change_abs,
    CASE WHEN pct_change > 0.10 THEN 'naik' WHEN pct_change < -0.10 THEN 'turun' ELSE 'stabil' END AS kondisi
FROM (
    SELECT ROUND((today_rev - avg_sdow) / NULLIF(avg_sdow, 0), 3) AS pct_change
    FROM (
        SELECT
            SUM(CASE WHEN order_date = (SELECT d FROM anchor_date) THEN daily_total ELSE 0 END) AS today_rev,
            AVG(CASE WHEN order_date < (SELECT d FROM anchor_date)
                AND DAYOFWEEK(order_date) = DAYOFWEEK((SELECT d FROM anchor_date))
                AND order_date >= (SELECT d FROM anchor_date) - INTERVAL '30 days'
                THEN daily_total END) AS avg_sdow
        FROM (SELECT order_date, SUM(total_revenue) AS daily_total FROM main_marts.mart_daily_revenue
              WHERE order_date >= (SELECT d FROM anchor_date) - INTERVAL '30 days'
              GROUP BY order_date)
    )
)
