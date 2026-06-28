WITH max_d AS (SELECT MAX(attendance_date) AS d FROM main_marts.mart_employee_shift_performance),
base AS (
    SELECT e.*, p AS period,
        CASE e.shift_id WHEN 'S1' THEN 7 WHEN 'S2' THEN 8 WHEN 'S3' THEN 7 ELSE 7 END AS shift_dur,
        CASE WHEN e.attendance_status IN ('present','late') THEN 1 ELSE 0 END AS is_working,
        CASE WHEN e.attendance_status = 'absent' THEN 1 ELSE 0 END AS is_absent,
        CASE WHEN e.attendance_status = 'late'   THEN 1 ELSE 0 END AS is_late
    FROM main_marts.mart_employee_shift_performance e CROSS JOIN max_d m
    CROSS JOIN (SELECT '7d' AS p UNION ALL SELECT '30d') periods
    WHERE (p = '7d'  AND e.attendance_date >= m.d - INTERVAL '6 days')
       OR (p = '30d' AND e.attendance_date >= m.d - INTERVAL '29 days')
)
SELECT
    period, role,
    COUNT(DISTINCT employee_id) AS total_employees,
    SUM(CASE WHEN is_working=1 THEN orders_handled ELSE 0 END) AS total_orders,
    SUM(CASE WHEN is_working=1 THEN total_revenue ELSE 0 END) AS total_revenue,
    ROUND(AVG(CASE WHEN is_working=1 THEN avg_ticket END), 0) AS avg_order_value,
    ROUND(SUM(CASE WHEN is_working=1 THEN orders_handled ELSE 0 END) * 1.0 / NULLIF(COUNT(DISTINCT employee_id), 0), 1) AS orders_per_employee,
    ROUND(SUM(is_working) * 100.0 / NULLIF(COUNT(*), 0), 1) AS attendance_rate,
    ROUND(SUM(is_late) * 100.0 / NULLIF(SUM(is_working), 0), 1) AS late_rate,
    ROUND(SUM(is_absent) * 100.0 / NULLIF(COUNT(*), 0), 1) AS absent_rate,
    ROUND(SUM(CASE WHEN overtime_hours > 0 AND is_working=1 THEN 1 ELSE 0 END) * 100.0 / NULLIF(SUM(is_working), 0), 1) AS overtime_session_pct,
    ROUND(SUM(CASE WHEN is_working=1 THEN total_revenue ELSE 0 END) / NULLIF(SUM(CASE WHEN is_working=1 THEN shift_dur ELSE 0 END), 0), 0) AS revenue_per_hour,
    ROUND(SUM(CASE WHEN is_working=1 THEN orders_handled ELSE 0 END) * 1.0 / NULLIF(SUM(CASE WHEN is_working=1 THEN shift_dur ELSE 0 END), 0), 2) AS orders_per_hour
FROM base
GROUP BY period, role
ORDER BY period, revenue_per_hour DESC
