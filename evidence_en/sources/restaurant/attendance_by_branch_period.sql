WITH max_d AS (SELECT MAX(attendance_date) AS d FROM main_marts.mart_employee_shift_performance)
SELECT period, branch_name, attendance_status,
    COUNT(*) AS sessions,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY period, branch_name), 1) AS pct,
    ROUND(SUM(CASE WHEN attendance_status IN ('present','late') THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(*), 0), 1) AS attendance_rate,
    ROUND(SUM(CASE WHEN attendance_status = 'late'   THEN 1 ELSE 0 END) * 100.0 / NULLIF(SUM(CASE WHEN attendance_status IN ('present','late') THEN 1 ELSE 0 END), 0), 1) AS late_rate,
    SUM(CASE WHEN attendance_status = 'absent' THEN 1 ELSE 0 END) AS absent_count
FROM (
    SELECT attendance_status, branch_name, 'y'   AS period FROM main_marts.mart_employee_shift_performance CROSS JOIN max_d WHERE attendance_date = d
    UNION ALL
    SELECT attendance_status, branch_name, '7d'  AS period FROM main_marts.mart_employee_shift_performance CROSS JOIN max_d WHERE attendance_date >= d - INTERVAL '6 days'
    UNION ALL
    SELECT attendance_status, branch_name, '30d' AS period FROM main_marts.mart_employee_shift_performance CROSS JOIN max_d WHERE attendance_date >= d - INTERVAL '29 days'
)
GROUP BY period, branch_name, attendance_status
ORDER BY period, branch_name, pct DESC
