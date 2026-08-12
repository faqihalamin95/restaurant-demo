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
    period, employee_name, role, branch_name, shift_name,
    SUM(is_working) AS hari_hadir,
    SUM(CASE WHEN is_working = 1 THEN orders_handled ELSE 0 END) AS total_orders,
    SUM(CASE WHEN is_working = 1 THEN total_revenue ELSE 0 END) AS total_revenue,
    ROUND(AVG(CASE WHEN is_working = 1 THEN avg_ticket END), 0) AS avg_ticket,
    SUM(CASE WHEN is_working = 1 THEN shift_dur ELSE 0 END) AS estimated_labor_hours,
    ROUND(SUM(CASE WHEN is_working = 1 THEN total_revenue ELSE 0 END) / NULLIF(SUM(CASE WHEN is_working = 1 THEN shift_dur ELSE 0 END), 0), 0) AS revenue_per_hour,
    ROUND(SUM(CASE WHEN is_working = 1 THEN orders_handled ELSE 0 END) * 1.0 / NULLIF(SUM(CASE WHEN is_working = 1 THEN shift_dur ELSE 0 END), 0), 2) AS orders_per_hour,
    SUM(overtime_hours) AS total_overtime_hours,
    SUM(is_late) AS late_count,
    SUM(is_absent) AS absent_count,
    CASE
        WHEN ROUND(SUM(CASE WHEN is_working=1 THEN total_revenue ELSE 0 END)/NULLIF(SUM(CASE WHEN is_working=1 THEN shift_dur ELSE 0 END),0),0)
             >= AVG(ROUND(SUM(CASE WHEN is_working=1 THEN total_revenue ELSE 0 END)/NULLIF(SUM(CASE WHEN is_working=1 THEN shift_dur ELSE 0 END),0),0)) OVER (PARTITION BY period, role) * 1.2
             AND SUM(is_absent) = 0 AND SUM(overtime_hours) < 10
        THEN 'Benchmark'
        WHEN SUM(overtime_hours) >= 10 AND ROUND(SUM(CASE WHEN is_working=1 THEN total_revenue ELSE 0 END)/NULLIF(SUM(CASE WHEN is_working=1 THEN shift_dur ELSE 0 END),0),0) > 0
        THEN 'Beban tinggi'
        WHEN ROUND(SUM(CASE WHEN is_working=1 THEN total_revenue ELSE 0 END)/NULLIF(SUM(CASE WHEN is_working=1 THEN shift_dur ELSE 0 END),0),0)
             < AVG(ROUND(SUM(CASE WHEN is_working=1 THEN total_revenue ELSE 0 END)/NULLIF(SUM(CASE WHEN is_working=1 THEN shift_dur ELSE 0 END),0),0)) OVER (PARTITION BY period, role) * 0.75
             AND SUM(is_working) >= 3
        THEN 'Perlu coaching'
        ELSE 'Pantau'
    END AS productivity_label
FROM base
GROUP BY period, employee_name, role, branch_name, shift_name
HAVING SUM(is_working) > 0
ORDER BY period, revenue_per_hour DESC
