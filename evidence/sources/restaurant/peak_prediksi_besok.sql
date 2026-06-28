SELECT
    CASE DAYNAME(CURRENT_DATE + INTERVAL '1 day')
        WHEN 'Monday' THEN 'Senin' WHEN 'Tuesday' THEN 'Selasa' WHEN 'Wednesday' THEN 'Rabu'
        WHEN 'Thursday' THEN 'Kamis' WHEN 'Friday' THEN 'Jumat'
        WHEN 'Saturday' THEN 'Sabtu' WHEN 'Sunday' THEN 'Minggu'
    END AS nama_hari,
    CASE DAYNAME(CURRENT_DATE + INTERVAL '1 day')
        WHEN 'Saturday' THEN 'Weekend' WHEN 'Sunday' THEN 'Weekend' ELSE 'Weekday'
    END AS tipe_hari,
    ph.order_hour,
    ph.branch_name,
    ROUND(AVG(ph.daily_total), 0) AS prediksi_order
FROM (
    SELECT order_date, order_hour, branch_name, SUM(total_orders) AS daily_total
    FROM main_marts.mart_peak_hours
    WHERE DAYNAME(order_date) = DAYNAME(CURRENT_DATE + INTERVAL '1 day')
      AND order_date >= (SELECT MAX(order_date) FROM main_marts.mart_peak_hours) - INTERVAL '29 days'
    GROUP BY order_date, order_hour, branch_name
) ph
GROUP BY ph.order_hour, ph.branch_name
ORDER BY ph.order_hour, ph.branch_name
