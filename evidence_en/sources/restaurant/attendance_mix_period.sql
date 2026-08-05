WITH max_d AS (SELECT MAX(attendance_date) AS d FROM main_marts.mart_employee_shift_performance)
SELECT period, attendance_status,
    COUNT(*) AS sessions,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY period), 1) AS pct
FROM (
    SELECT attendance_status, 'y'   AS period FROM main_marts.mart_employee_shift_performance CROSS JOIN max_d WHERE attendance_date = d
    UNION ALL
    SELECT attendance_status, '7d'  AS period FROM main_marts.mart_employee_shift_performance CROSS JOIN max_d WHERE attendance_date >= d - INTERVAL '6 days'
    UNION ALL
    SELECT attendance_status, '30d' AS period FROM main_marts.mart_employee_shift_performance CROSS JOIN max_d WHERE attendance_date >= d - INTERVAL '29 days'
)
GROUP BY period, attendance_status
ORDER BY period, pct DESC
