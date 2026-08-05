WITH max_d AS (SELECT MAX(attendance_date) AS d FROM main_marts.mart_employee_shift_performance),
base AS (
    SELECT e.*,
        CASE e.shift_id WHEN 'S1' THEN 7 WHEN 'S2' THEN 8 WHEN 'S3' THEN 7 ELSE 7 END AS shift_dur,
        CASE WHEN e.attendance_status IN ('present','late') THEN 1 ELSE 0 END AS is_working,
        CASE WHEN e.attendance_status = 'late'   THEN 1 ELSE 0 END AS is_late,
        CASE WHEN e.attendance_status = 'absent' THEN 1 ELSE 0 END AS is_absent,
        CASE WHEN e.attendance_status = 'leave'  THEN 1 ELSE 0 END AS is_leave
    FROM main_marts.mart_employee_shift_performance e CROSS JOIN max_d m
    WHERE e.attendance_date <= m.d
)
SELECT
    period,
    COUNT(DISTINCT employee_id) AS total_employees,
    ROUND(SUM(is_working) * 100.0 / NULLIF(COUNT(*), 0), 1) AS attendance_rate,
    ROUND(SUM(is_late) * 100.0 / NULLIF(SUM(is_working), 0), 1) AS late_rate,
    SUM(is_absent) AS absent_count,
    SUM(is_leave) AS leave_count,
    SUM(is_absent + is_leave) AS unavailable_count,
    SUM(overtime_hours) AS total_overtime_hours,
    ROUND(SUM(CASE WHEN overtime_hours > 0 AND is_working = 1 THEN 1 ELSE 0 END) * 100.0 / NULLIF(SUM(is_working), 0), 1) AS overtime_session_pct,
    SUM(CASE WHEN is_working = 1 THEN orders_handled ELSE 0 END) AS total_orders,
    SUM(CASE WHEN is_working = 1 THEN total_revenue ELSE 0 END) AS total_revenue,
    ROUND(SUM(CASE WHEN is_working = 1 THEN total_revenue ELSE 0 END) / NULLIF(SUM(CASE WHEN is_working = 1 THEN shift_dur ELSE 0 END), 0), 0) AS revenue_per_labor_hour,
    ROUND(SUM(CASE WHEN is_working = 1 THEN orders_handled ELSE 0 END) * 1.0 / NULLIF(SUM(CASE WHEN is_working = 1 THEN shift_dur ELSE 0 END), 0), 2) AS orders_per_labor_hour,
    0 AS problem_employee_count
FROM (
    SELECT *, 'y'  AS period FROM base CROSS JOIN max_d m WHERE attendance_date = m.d
    UNION ALL
    SELECT *, '7d' AS period FROM base CROSS JOIN max_d m WHERE attendance_date >= m.d - INTERVAL '6 days'
    UNION ALL
    SELECT *, '30d' AS period FROM base CROSS JOIN max_d m WHERE attendance_date >= m.d - INTERVAL '29 days'
)
GROUP BY period
