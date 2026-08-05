WITH daily_hourly AS (
    SELECT
        order_date,
        CASE DAYNAME(order_date)
            WHEN 'Saturday' THEN 'Weekend'
            WHEN 'Sunday' THEN 'Weekend'
            ELSE 'Weekday'
        END AS tipe_hari,
        order_hour,
        SUM(total_orders) AS total_orders
    FROM main_marts.mart_peak_hours
    WHERE order_date >= (SELECT MAX(order_date) FROM main_marts.mart_peak_hours) - INTERVAL '29 days'
    GROUP BY order_date, DAYNAME(order_date), order_hour
)
SELECT
    tipe_hari,
    order_hour,
    ROUND(AVG(total_orders), 0) AS avg_orders
FROM daily_hourly
GROUP BY tipe_hari, order_hour
ORDER BY CASE tipe_hari WHEN 'Weekday' THEN 1 ELSE 2 END, order_hour
