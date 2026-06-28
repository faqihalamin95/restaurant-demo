WITH max_d AS (
    SELECT MAX(attendance_date) AS d FROM main_marts.mart_employee_shift_performance
),
shift_dur AS (
    SELECT DISTINCT shift_id, shift_name,
        CASE shift_id WHEN 'S1' THEN 7 WHEN 'S2' THEN 8 WHEN 'S3' THEN 7 ELSE 7 END AS dur
    FROM main_marts.mart_employee_shift_performance
),
base AS (
    SELECT
        e.*,
        CASE e.shift_id WHEN 'S1' THEN 7 WHEN 'S2' THEN 8 WHEN 'S3' THEN 7 ELSE 7 END AS shift_dur,
        CASE WHEN e.attendance_status IN ('present','late') THEN 1 ELSE 0 END AS is_working,
        CASE WHEN e.attendance_status = 'late'   THEN 1 ELSE 0 END AS is_late,
        CASE WHEN e.attendance_status = 'absent' THEN 1 ELSE 0 END AS is_absent,
        CASE WHEN e.attendance_status = 'leave'  THEN 1 ELSE 0 END AS is_leave
    FROM main_marts.mart_employee_shift_performance e CROSS JOIN max_d m
    WHERE e.attendance_date <= m.d
),
agg_y AS (
    SELECT
        'y' AS period,
        COUNT(*) AS scheduled,
        SUM(is_working) AS working,
        SUM(is_late) AS late_cnt,
        SUM(is_absent) AS absent_cnt,
        SUM(is_leave) AS leave_cnt,
        SUM(CASE WHEN overtime_hours > 0 AND is_working = 1 THEN 1 ELSE 0 END) AS ot_sessions,
        SUM(overtime_hours) AS tot_ot,
        SUM(CASE WHEN is_working = 1 THEN orders_handled ELSE 0 END) AS tot_orders,
        SUM(CASE WHEN is_working = 1 THEN total_revenue ELSE 0 END) AS tot_rev,
        SUM(CASE WHEN is_working = 1 THEN shift_dur ELSE 0 END) AS labor_hrs,
        COUNT(DISTINCT employee_id) AS tot_emp
    FROM base CROSS JOIN max_d m
    WHERE attendance_date = m.d
),
agg_7 AS (
    SELECT
        '7d' AS period,
        COUNT(*) AS scheduled,
        SUM(is_working) AS working,
        SUM(is_late) AS late_cnt,
        SUM(is_absent) AS absent_cnt,
        SUM(is_leave) AS leave_cnt,
        SUM(CASE WHEN overtime_hours > 0 AND is_working = 1 THEN 1 ELSE 0 END) AS ot_sessions,
        SUM(overtime_hours) AS tot_ot,
        SUM(CASE WHEN is_working = 1 THEN orders_handled ELSE 0 END) AS tot_orders,
        SUM(CASE WHEN is_working = 1 THEN total_revenue ELSE 0 END) AS tot_rev,
        SUM(CASE WHEN is_working = 1 THEN shift_dur ELSE 0 END) AS labor_hrs,
        COUNT(DISTINCT employee_id) AS tot_emp
    FROM base CROSS JOIN max_d m
    WHERE attendance_date >= m.d - INTERVAL '6 days'
),
agg_30 AS (
    SELECT
        '30d' AS period,
        COUNT(*) AS scheduled,
        SUM(is_working) AS working,
        SUM(is_late) AS late_cnt,
        SUM(is_absent) AS absent_cnt,
        SUM(is_leave) AS leave_cnt,
        SUM(CASE WHEN overtime_hours > 0 AND is_working = 1 THEN 1 ELSE 0 END) AS ot_sessions,
        SUM(overtime_hours) AS tot_ot,
        SUM(CASE WHEN is_working = 1 THEN orders_handled ELSE 0 END) AS tot_orders,
        SUM(CASE WHEN is_working = 1 THEN total_revenue ELSE 0 END) AS tot_rev,
        SUM(CASE WHEN is_working = 1 THEN shift_dur ELSE 0 END) AS labor_hrs,
        COUNT(DISTINCT employee_id) AS tot_emp
    FROM base CROSS JOIN max_d m
    WHERE attendance_date >= m.d - INTERVAL '29 days'
),
prob_30 AS (
    SELECT COUNT(DISTINCT employee_id) AS cnt
    FROM (
        SELECT employee_id
        FROM base CROSS JOIN max_d m
        WHERE attendance_date >= m.d - INTERVAL '29 days'
        GROUP BY employee_id
        HAVING SUM(is_absent) >= 2 OR SUM(is_late) >= 4
    )
),
prob_7 AS (
    SELECT COUNT(DISTINCT employee_id) AS cnt
    FROM (
        SELECT employee_id
        FROM base CROSS JOIN max_d m
        WHERE attendance_date >= m.d - INTERVAL '6 days'
        GROUP BY employee_id
        HAVING SUM(is_absent) >= 2 OR SUM(is_late) >= 4
    )
),
prob_y AS (
    SELECT COUNT(DISTINCT employee_id) AS cnt
    FROM (
        SELECT employee_id
        FROM base CROSS JOIN max_d m
        WHERE attendance_date = m.d
        GROUP BY employee_id
        HAVING SUM(is_absent) >= 1 OR SUM(is_late) >= 2
    )
),
pressure_30 AS (
    SELECT
        MAX(CASE WHEN rn_b=1 THEN branch_name END) AS top_branch,
        MAX(CASE WHEN rn_s=1 THEN shift_name END)  AS top_shift,
        MAX(CASE WHEN rn_r=1 THEN role END)         AS top_role
    FROM (
        SELECT branch_name, shift_name, role,
            ROW_NUMBER() OVER (ORDER BY SUM(is_absent)*10 + SUM(is_late)*5 + SUM(CASE WHEN overtime_hours>0 AND is_working=1 THEN 1 ELSE 0 END) DESC) AS rn_b,
            ROW_NUMBER() OVER (PARTITION BY shift_name ORDER BY SUM(is_absent)*10 + SUM(is_late)*5 DESC) AS rn_s,
            ROW_NUMBER() OVER (PARTITION BY role ORDER BY SUM(is_absent)*10 + SUM(is_late)*5 DESC) AS rn_r
        FROM base CROSS JOIN max_d m
        WHERE attendance_date >= m.d - INTERVAL '29 days'
        GROUP BY branch_name, shift_name, role
    )
),
pressure_7 AS (
    SELECT
        MAX(CASE WHEN rn_b=1 THEN branch_name END) AS top_branch,
        MAX(CASE WHEN rn_s=1 THEN shift_name END)  AS top_shift
    FROM (
        SELECT branch_name, shift_name,
            ROW_NUMBER() OVER (ORDER BY SUM(is_absent)*10 + SUM(is_late)*5 DESC) AS rn_b,
            ROW_NUMBER() OVER (PARTITION BY shift_name ORDER BY SUM(is_absent)*10 + SUM(is_late)*5 DESC) AS rn_s
        FROM base CROSS JOIN max_d m
        WHERE attendance_date >= m.d - INTERVAL '6 days'
        GROUP BY branch_name, shift_name
    )
)
SELECT
    a.period,
    a.tot_emp AS total_employees,
    a.scheduled AS scheduled_sessions,
    a.working AS working_sessions,
    ROUND(a.working * 100.0 / NULLIF(a.scheduled, 0), 1) AS attendance_rate,
    ROUND(a.late_cnt * 100.0 / NULLIF(a.working, 0), 1)  AS late_rate,
    a.absent_cnt,
    a.leave_cnt,
    a.ot_sessions,
    ROUND(a.ot_sessions * 100.0 / NULLIF(a.working, 0), 1) AS overtime_session_pct,
    a.tot_ot AS total_overtime_hours,
    a.tot_orders AS total_orders,
    a.tot_rev AS total_revenue,
    ROUND(a.tot_rev / NULLIF(a.labor_hrs, 0), 0)    AS revenue_per_labor_hour,
    ROUND(a.tot_orders * 1.0 / NULLIF(a.labor_hrs, 0), 2) AS orders_per_labor_hour,
    CASE a.period
        WHEN '30d' THEN (SELECT cnt FROM prob_30)
        WHEN '7d'  THEN (SELECT cnt FROM prob_7)
        ELSE            (SELECT cnt FROM prob_y)
    END AS problem_employee_count,
    CASE a.period
        WHEN '30d' THEN (SELECT top_branch FROM pressure_30)
        WHEN '7d'  THEN (SELECT top_branch FROM pressure_7)
        ELSE NULL
    END AS top_pressure_branch,
    CASE a.period
        WHEN '30d' THEN (SELECT top_shift FROM pressure_30)
        WHEN '7d'  THEN (SELECT top_shift FROM pressure_7)
        ELSE NULL
    END AS top_pressure_shift,
    CASE a.period
        WHEN '30d' THEN (SELECT top_role FROM pressure_30)
        ELSE NULL
    END AS top_pressure_role,
    CASE
        WHEN ROUND(a.working * 100.0 / NULLIF(a.scheduled, 0), 1) >= 92
          AND ROUND(a.late_cnt * 100.0 / NULLIF(a.working, 0), 1) < 10
          AND NOT ((a.period = 'y' AND a.absent_cnt >= 3) OR (a.period IN ('7d','30d') AND a.absent_cnt >= 5))
          AND ROUND(a.ot_sessions * 100.0 / NULLIF(a.working, 0), 1) < 35
        THEN 'Sehat'
        WHEN (ROUND(a.working * 100.0 / NULLIF(a.scheduled, 0), 1) < 85 AND ROUND(a.late_cnt * 100.0 / NULLIF(a.working, 0), 1) >= 10)
          OR (ROUND(a.working * 100.0 / NULLIF(a.scheduled, 0), 1) < 92 AND ROUND(a.late_cnt * 100.0 / NULLIF(a.working, 0), 1) >= 20)
        THEN 'Kritis'
        ELSE 'Waspada'
    END AS status,
    CASE
        WHEN a.absent_cnt >= 5 OR ROUND(a.working * 100.0 / NULLIF(a.scheduled, 0), 1) < 88 THEN 'Coverage risk'
        WHEN ROUND(a.late_cnt * 100.0 / NULLIF(a.working, 0), 1) >= 15 THEN 'Keterlambatan'
        WHEN ROUND(a.ot_sessions * 100.0 / NULLIF(a.working, 0), 1) >= 25 THEN 'Overtime pressure'
        ELSE 'Workforce sehat'
    END AS focus
FROM (
    SELECT * FROM agg_y
    UNION ALL SELECT * FROM agg_7
    UNION ALL SELECT * FROM agg_30
) a
