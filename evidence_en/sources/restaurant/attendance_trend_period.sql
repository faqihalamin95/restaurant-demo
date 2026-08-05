WITH max_d AS (SELECT MAX(attendance_date) AS d FROM main_marts.mart_employee_shift_performance),
base AS (
    SELECT e.*, p AS period
    FROM main_marts.mart_employee_shift_performance e CROSS JOIN max_d m
    CROSS JOIN (SELECT '7d' AS p UNION ALL SELECT '30d') periods
    WHERE (p = '7d'  AND e.attendance_date >= m.d - INTERVAL '6 days')
       OR (p = '30d' AND e.attendance_date >= m.d - INTERVAL '29 days')
)
SELECT
    period,
    attendance_date,
    strftime('%d %b %Y', attendance_date) AS tanggal,
    SUM(CASE WHEN attendance_status = 'present' THEN 1 ELSE 0 END) AS present,
    SUM(CASE WHEN attendance_status = 'late'    THEN 1 ELSE 0 END) AS late,
    SUM(CASE WHEN attendance_status = 'absent'  THEN 1 ELSE 0 END) AS absent,
    SUM(CASE WHEN attendance_status = 'leave'   THEN 1 ELSE 0 END) AS leave_count,
    ROUND(SUM(CASE WHEN attendance_status IN ('absent','leave') THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(*), 0), 1) AS pct_tidak_hadir,
    ROUND(SUM(CASE WHEN attendance_status = 'late' THEN 1 ELSE 0 END) * 100.0 / NULLIF(SUM(CASE WHEN attendance_status IN ('present','late') THEN 1 ELSE 0 END), 0), 1) AS late_rate,
    SUM(CASE WHEN overtime_hours > 0 AND attendance_status IN ('present','late') THEN 1 ELSE 0 END) AS overtime_sessions,
    SUM(overtime_hours) AS overtime_hours
FROM base
GROUP BY period, attendance_date
ORDER BY period, attendance_date
