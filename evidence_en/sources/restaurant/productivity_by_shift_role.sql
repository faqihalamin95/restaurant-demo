WITH max_d AS (SELECT MAX(attendance_date) AS d FROM main_marts.mart_employee_shift_performance),
base AS (
    SELECT e.*, p AS period,
        CASE e.shift_id WHEN 'S1' THEN 7 WHEN 'S2' THEN 8 WHEN 'S3' THEN 7 ELSE 7 END AS shift_dur,
        CASE WHEN e.attendance_status IN ('present','late') THEN 1 ELSE 0 END AS is_working
    FROM main_marts.mart_employee_shift_performance e CROSS JOIN max_d m
    CROSS JOIN (SELECT '7d' AS p UNION ALL SELECT '30d') periods
    WHERE (p = '7d'  AND e.attendance_date >= m.d - INTERVAL '6 days')
       OR (p = '30d' AND e.attendance_date >= m.d - INTERVAL '29 days')
)
SELECT
    period, shift_name, role,
    ROUND(SUM(CASE WHEN is_working=1 THEN total_revenue ELSE 0 END) / NULLIF(SUM(CASE WHEN is_working=1 THEN shift_dur ELSE 0 END), 0), 0) AS revenue_per_hour,
    ROUND(SUM(CASE WHEN is_working=1 THEN orders_handled ELSE 0 END) * 1.0 / NULLIF(SUM(CASE WHEN is_working=1 THEN shift_dur ELSE 0 END), 0), 2) AS orders_per_hour
FROM base
GROUP BY period, shift_name, role
HAVING SUM(is_working) > 0
ORDER BY period, revenue_per_hour DESC, shift_name
