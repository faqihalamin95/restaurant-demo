WITH max_d AS (SELECT MAX(attendance_date) AS d FROM main_marts.mart_employee_shift_performance),
base AS (
    SELECT
        attendance_date,
        date_trunc('week', attendance_date) AS week_start,
        CASE WHEN attendance_status IN ('present','late') THEN 1 ELSE 0 END AS is_working,
        CASE WHEN attendance_status = 'absent' THEN 1 ELSE 0 END AS is_absent,
        CASE WHEN attendance_status = 'leave' THEN 1 ELSE 0 END AS is_leave,
        CASE WHEN attendance_status = 'late' THEN 1 ELSE 0 END AS is_late,
        overtime_hours
    FROM main_marts.mart_employee_shift_performance CROSS JOIN max_d
    WHERE attendance_date >= d - INTERVAL '29 days'
)
SELECT
    strftime('%d %b %Y', MIN(attendance_date)) || ' - ' || strftime('%d %b %Y', MAX(attendance_date)) AS periode,
    week_start,
    SUM(overtime_hours) AS total_overtime_hours,
    SUM(CASE WHEN overtime_hours > 0 AND is_working = 1 THEN 1 ELSE 0 END) AS overtime_sessions,
    ROUND(SUM(CASE WHEN overtime_hours > 0 AND is_working = 1 THEN 1 ELSE 0 END) * 100.0 / NULLIF(SUM(is_working), 0), 1) AS overtime_session_pct,
    SUM(is_absent) AS absent,
    SUM(is_leave) AS leave_count,
    SUM(is_late) AS late,
    ROUND((SUM(is_absent) + SUM(is_leave)) * 4 + SUM(is_late) * 2 + SUM(CASE WHEN overtime_hours > 0 AND is_working = 1 THEN 1 ELSE 0 END), 1) AS pressure_score
FROM base
GROUP BY week_start
ORDER BY week_start DESC
