WITH max_d AS (SELECT MAX(attendance_date) AS d FROM main_marts.mart_employee_shift_performance)
SELECT
    attendance_date,
    shift_name,
    SUM(overtime_hours) AS total_overtime_hours
FROM main_marts.mart_employee_shift_performance CROSS JOIN max_d
WHERE attendance_date >= d - INTERVAL '29 days'
  AND overtime_hours > 0
GROUP BY attendance_date, shift_name
ORDER BY attendance_date, shift_name
