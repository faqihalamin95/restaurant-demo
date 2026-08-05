WITH max_d AS (SELECT MAX(attendance_date) AS d FROM main_marts.mart_employee_shift_performance)
SELECT
    attendance_date,
    SUM(CASE WHEN attendance_status = 'present' THEN 1 ELSE 0 END) AS present,
    SUM(CASE WHEN attendance_status = 'late'    THEN 1 ELSE 0 END) AS late,
    SUM(CASE WHEN attendance_status = 'absent'  THEN 1 ELSE 0 END) AS absent,
    SUM(CASE WHEN attendance_status = 'leave'   THEN 1 ELSE 0 END) AS leave_count,
    ROUND(SUM(CASE WHEN attendance_status IN ('absent','leave') THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(*), 0), 1) AS pct_tidak_hadir,
    ROUND(SUM(CASE WHEN attendance_status = 'late' THEN 1 ELSE 0 END) * 100.0 / NULLIF(SUM(CASE WHEN attendance_status IN ('present','late') THEN 1 ELSE 0 END), 0), 1) AS late_rate
FROM main_marts.mart_employee_shift_performance CROSS JOIN max_d
WHERE attendance_date >= d - INTERVAL '29 days'
GROUP BY attendance_date
ORDER BY attendance_date
