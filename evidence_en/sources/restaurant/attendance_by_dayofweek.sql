WITH max_d AS (SELECT MAX(attendance_date) AS d FROM main_marts.mart_employee_shift_performance)
SELECT
    DAYNAME(attendance_date)   AS nama_hari,
    DAYOFWEEK(attendance_date) AS urutan_hari,
    ROUND(AVG(CASE WHEN attendance_status = 'absent' THEN 1.0 ELSE 0.0 END) * 100, 1) AS avg_pct_absent,
    ROUND(AVG(CASE WHEN attendance_status = 'late'   THEN 1.0 ELSE 0.0 END) * 100, 1) AS avg_pct_late
FROM main_marts.mart_employee_shift_performance CROSS JOIN max_d
WHERE attendance_date >= d - INTERVAL '29 days'
GROUP BY DAYNAME(attendance_date), DAYOFWEEK(attendance_date)
ORDER BY urutan_hari
