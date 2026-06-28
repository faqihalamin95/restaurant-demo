WITH max_d AS (SELECT MAX(attendance_date) AS d FROM main_marts.mart_employee_shift_performance),
base AS (
    SELECT e.*, p AS period,
        CASE WHEN e.attendance_status IN ('present','late') THEN 1 ELSE 0 END AS is_working,
        CASE WHEN e.attendance_status = 'absent' THEN 1 ELSE 0 END AS is_absent,
        CASE WHEN e.attendance_status = 'leave' THEN 1 ELSE 0 END AS is_leave,
        CASE WHEN e.attendance_status = 'late' THEN 1 ELSE 0 END AS is_late
    FROM main_marts.mart_employee_shift_performance e CROSS JOIN max_d m
    CROSS JOIN (SELECT 'y' AS p UNION ALL SELECT '7d' UNION ALL SELECT '30d') periods
    WHERE (p = 'y'   AND e.attendance_date = m.d)
       OR (p = '7d'  AND e.attendance_date >= m.d - INTERVAL '6 days')
       OR (p = '30d' AND e.attendance_date >= m.d - INTERVAL '29 days')
)
SELECT
    period, branch_name,
    SUM(overtime_hours) AS total_overtime_hours,
    ROUND(AVG(CASE WHEN overtime_hours > 0 AND is_working = 1 THEN overtime_hours END), 1) AS avg_overtime_per_person,
    SUM(CASE WHEN overtime_hours > 0 AND is_working = 1 THEN 1 ELSE 0 END) AS overtime_sessions,
    ROUND(SUM(CASE WHEN overtime_hours > 0 AND is_working = 1 THEN 1 ELSE 0 END) * 100.0 / NULLIF(SUM(is_working), 0), 1) AS overtime_session_pct,
    SUM(is_absent) AS absent_count,
    SUM(is_leave) AS leave_count,
    SUM(is_late) AS late_count,
    ROUND((SUM(is_absent) + SUM(is_leave)) * 4 + SUM(is_late) * 2 + SUM(CASE WHEN overtime_hours > 0 AND is_working = 1 THEN 1 ELSE 0 END), 1) AS pressure_score
FROM base
GROUP BY period, branch_name
ORDER BY period, pressure_score DESC
