WITH daily AS (
    SELECT
        branch_name,
        order_date,
        DAYNAME(order_date) AS day_name,
        SUM(total_orders)   AS daily_orders
    FROM main_marts.mart_peak_hours
    WHERE order_date >= (SELECT MAX(order_date) FROM main_marts.mart_peak_hours) - INTERVAL '29 days'
    GROUP BY branch_name, order_date, DAYNAME(order_date)
)
SELECT
    branch_name,
    CASE day_name
        WHEN 'Monday' THEN 'Senin' WHEN 'Tuesday' THEN 'Selasa' WHEN 'Wednesday' THEN 'Rabu'
        WHEN 'Thursday' THEN 'Kamis' WHEN 'Friday' THEN 'Jumat'
        WHEN 'Saturday' THEN 'Sabtu' WHEN 'Sunday' THEN 'Minggu'
    END AS hari,
    CASE day_name
        WHEN 'Monday' THEN 1 WHEN 'Tuesday' THEN 2 WHEN 'Wednesday' THEN 3
        WHEN 'Thursday' THEN 4 WHEN 'Friday' THEN 5 WHEN 'Saturday' THEN 6 WHEN 'Sunday' THEN 7
    END AS hari_urut,
    ROUND(AVG(daily_orders), 0) AS rata_order
FROM daily
GROUP BY branch_name, day_name
ORDER BY hari_urut, branch_name
