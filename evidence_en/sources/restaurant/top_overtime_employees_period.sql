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
    period, employee_name, role, MAX(branch_name) as branch_name,
    SUM(overtime_hours) AS total_overtime_hours,
    CASE 
        WHEN SUM(overtime_hours) >= 20 THEN '<span style="background-color: #fee2e2; color: #991b1b; padding: 2px 8px; border-radius: 6px; font-weight: 700;">' || CAST(SUM(overtime_hours) AS INTEGER) || '</span>'
        WHEN SUM(overtime_hours) >= 10 THEN '<span style="background-color: #fef08a; color: #854d0e; padding: 2px 8px; border-radius: 6px; font-weight: 700;">' || CAST(SUM(overtime_hours) AS INTEGER) || '</span>'
        ELSE CAST(CAST(SUM(overtime_hours) AS INTEGER) AS VARCHAR)
    END AS jam_lembur_html,
    COUNT(CASE WHEN overtime_hours > 0 AND is_working = 1 THEN 1 END) AS overtime_days,
    ROUND(AVG(CASE WHEN overtime_hours > 0 AND is_working = 1 THEN overtime_hours END), 1) AS avg_hours_per_overtime_session,
    CASE
        WHEN SUM(overtime_hours) >= 20 THEN 'Cek risiko burnout — beban overtime sangat tinggi'
        WHEN SUM(overtime_hours) >= 10 THEN 'Pantau kesehatan dan kepuasan kerja — koordinasikan dengan roster manager'
        ELSE 'Monitor — pastikan overtime tidak menjadi pola permanen'
    END AS recommended_action
FROM base
WHERE is_working = 1
GROUP BY period, employee_name, role
HAVING SUM(overtime_hours) > 0
ORDER BY period, total_overtime_hours DESC
