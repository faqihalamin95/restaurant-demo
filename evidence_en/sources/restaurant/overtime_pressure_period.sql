WITH max_d AS (SELECT MAX(attendance_date) AS d FROM main_marts.mart_employee_shift_performance),
base AS (
    SELECT e.*, p AS period,
        CASE WHEN e.attendance_status IN ('present','late') THEN 1 ELSE 0 END AS is_working
    FROM main_marts.mart_employee_shift_performance e CROSS JOIN max_d m
    CROSS JOIN (SELECT 'y' AS p UNION ALL SELECT '7d' UNION ALL SELECT '30d') periods
    WHERE (p = 'y'   AND e.attendance_date = m.d)
       OR (p = '7d'  AND e.attendance_date >= m.d - INTERVAL '6 days')
       OR (p = '30d' AND e.attendance_date >= m.d - INTERVAL '29 days')
)
SELECT
    period, shift_name,
    COUNT(DISTINCT employee_id) AS total_employees,
    SUM(overtime_hours) AS total_overtime_hours,
    ROUND(AVG(CASE WHEN overtime_hours > 0 AND is_working = 1 THEN overtime_hours END), 1) AS avg_overtime_per_person,
    SUM(CASE WHEN overtime_hours > 0 AND is_working = 1 THEN 1 ELSE 0 END) AS overtime_sessions,
    ROUND(SUM(CASE WHEN overtime_hours > 0 AND is_working = 1 THEN 1 ELSE 0 END) * 100.0 / NULLIF(SUM(is_working), 0), 1) AS overtime_session_pct
FROM base
GROUP BY period, shift_name
ORDER BY period, total_overtime_hours DESC
