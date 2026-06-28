WITH max_d AS (SELECT MAX(attendance_date) AS d FROM main_marts.mart_employee_shift_performance),
base AS (
    SELECT e.*, p AS period,
        CASE WHEN e.attendance_status IN ('present','late') THEN 1 ELSE 0 END AS is_working
    FROM main_marts.mart_employee_shift_performance e CROSS JOIN max_d m
    CROSS JOIN (SELECT '7d' AS p UNION ALL SELECT '30d') periods
    WHERE (p = '7d'  AND e.attendance_date >= m.d - INTERVAL '6 days')
       OR (p = '30d' AND e.attendance_date >= m.d - INTERVAL '29 days')
)
SELECT
    period, employee_name, role, branch_name, shift_name,
    SUM(overtime_hours) AS total_overtime_hours,
    COUNT(CASE WHEN overtime_hours > 0 AND is_working = 1 THEN 1 END) AS overtime_days,
    ROUND(AVG(CASE WHEN overtime_hours > 0 AND is_working = 1 THEN overtime_hours END), 1) AS avg_hours_per_overtime_session,
    CASE
        WHEN SUM(overtime_hours) >= 20 THEN 'Cek risiko burnout — beban overtime sangat tinggi'
        WHEN SUM(overtime_hours) >= 10 THEN 'Pantau kesehatan dan kepuasan kerja — koordinasikan dengan roster manager'
        ELSE 'Monitor — pastikan overtime tidak menjadi pola permanen'
    END AS recommended_action
FROM base
WHERE is_working = 1
GROUP BY period, employee_name, role, branch_name, shift_name
HAVING SUM(overtime_hours) > 0
ORDER BY period, total_overtime_hours DESC
