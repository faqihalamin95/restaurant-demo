WITH max_d AS (
    SELECT MAX(attendance_date) AS d FROM main_marts.mart_employee_shift_performance
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
)
SELECT
    -- Kemarin (y)
    ROUND(SUM(CASE WHEN attendance_date = m.d THEN is_working ELSE 0 END) * 100.0
         / NULLIF(SUM(CASE WHEN attendance_date = m.d THEN 1 ELSE 0 END), 0), 1) AS attendance_y,
    ROUND(SUM(CASE WHEN attendance_date = m.d THEN is_late ELSE 0 END) * 100.0
         / NULLIF(SUM(CASE WHEN attendance_date = m.d THEN is_working ELSE 0 END), 0), 1) AS late_y,
    SUM(CASE WHEN attendance_date = m.d THEN is_absent ELSE 0 END) AS absent_y,
    ROUND(SUM(CASE WHEN attendance_date = m.d AND overtime_hours > 0 AND is_working = 1 THEN 1 ELSE 0 END) * 100.0
         / NULLIF(SUM(CASE WHEN attendance_date = m.d THEN is_working ELSE 0 END), 0), 1) AS overtime_pct_y,
    SUM(CASE WHEN attendance_date = m.d AND is_working = 1 THEN overtime_hours ELSE 0 END) AS overtime_hours_y,
    SUM(CASE WHEN attendance_date = m.d THEN is_late ELSE 0 END) AS late_count_y,
    ROUND(SUM(CASE WHEN attendance_date = m.d AND is_working = 1 THEN total_revenue ELSE 0 END)
         / NULLIF(SUM(CASE WHEN attendance_date = m.d AND is_working = 1 THEN shift_dur ELSE 0 END), 0), 0) AS rev_per_hour_y,
    CASE
        WHEN ROUND(SUM(CASE WHEN attendance_date = m.d THEN is_working ELSE 0 END) * 100.0 / NULLIF(SUM(CASE WHEN attendance_date = m.d THEN 1 ELSE 0 END),0), 1) >= 92
          AND ROUND(SUM(CASE WHEN attendance_date = m.d THEN is_late ELSE 0 END) * 100.0 / NULLIF(SUM(CASE WHEN attendance_date = m.d THEN is_working ELSE 0 END),0), 1) < 10
          AND SUM(CASE WHEN attendance_date = m.d THEN is_absent ELSE 0 END) < 3
          AND ROUND(SUM(CASE WHEN attendance_date = m.d AND overtime_hours > 0 AND is_working = 1 THEN 1 ELSE 0 END) * 100.0 / NULLIF(SUM(CASE WHEN attendance_date = m.d THEN is_working ELSE 0 END),0), 1) < 35
        THEN 'Sehat'
        WHEN (ROUND(SUM(CASE WHEN attendance_date = m.d THEN is_working ELSE 0 END) * 100.0 / NULLIF(SUM(CASE WHEN attendance_date = m.d THEN 1 ELSE 0 END),0), 1) < 85 AND ROUND(SUM(CASE WHEN attendance_date = m.d THEN is_late ELSE 0 END) * 100.0 / NULLIF(SUM(CASE WHEN attendance_date = m.d THEN is_working ELSE 0 END),0), 1) >= 10)
          OR (ROUND(SUM(CASE WHEN attendance_date = m.d THEN is_working ELSE 0 END) * 100.0 / NULLIF(SUM(CASE WHEN attendance_date = m.d THEN 1 ELSE 0 END),0), 1) < 92 AND ROUND(SUM(CASE WHEN attendance_date = m.d THEN is_late ELSE 0 END) * 100.0 / NULLIF(SUM(CASE WHEN attendance_date = m.d THEN is_working ELSE 0 END),0), 1) >= 20)
        THEN 'Kritis'
        ELSE 'Waspada'
    END AS status_y,
    CASE
        WHEN SUM(CASE WHEN attendance_date = m.d THEN is_absent ELSE 0 END) >= 3
          OR ROUND(SUM(CASE WHEN attendance_date = m.d THEN is_working ELSE 0 END)*100.0/NULLIF(SUM(CASE WHEN attendance_date=m.d THEN 1 ELSE 0 END),0),1) < 88
        THEN 'Coverage risk'
        WHEN ROUND(SUM(CASE WHEN attendance_date = m.d THEN is_late ELSE 0 END)*100.0/NULLIF(SUM(CASE WHEN attendance_date=m.d THEN is_working ELSE 0 END),0),1) >= 15
        THEN 'Keterlambatan'
        ELSE 'Workforce sehat'
    END AS focus_y,

    -- 7 Hari (7d)
    ROUND(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '6 days' THEN is_working ELSE 0 END) * 100.0
         / NULLIF(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '6 days' THEN 1 ELSE 0 END), 0), 1) AS attendance_7d,
    ROUND(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '6 days' THEN is_late ELSE 0 END) * 100.0
         / NULLIF(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '6 days' THEN is_working ELSE 0 END), 0), 1) AS late_7d,
    SUM(CASE WHEN attendance_date >= m.d - INTERVAL '6 days' THEN is_absent ELSE 0 END) AS absent_7d,
    ROUND(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '6 days' AND overtime_hours > 0 AND is_working = 1 THEN 1 ELSE 0 END) * 100.0
         / NULLIF(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '6 days' THEN is_working ELSE 0 END), 0), 1) AS overtime_pct_7d,
    ROUND(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '6 days' AND is_working = 1 THEN total_revenue ELSE 0 END)
         / NULLIF(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '6 days' AND is_working = 1 THEN shift_dur ELSE 0 END), 0), 0) AS rev_per_hour_7d,
    CASE
        WHEN ROUND(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '6 days' THEN is_working ELSE 0 END) * 100.0 / NULLIF(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '6 days' THEN 1 ELSE 0 END),0), 1) >= 92
          AND ROUND(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '6 days' THEN is_late ELSE 0 END) * 100.0 / NULLIF(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '6 days' THEN is_working ELSE 0 END),0), 1) < 10
          AND SUM(CASE WHEN attendance_date >= m.d - INTERVAL '6 days' THEN is_absent ELSE 0 END) < 5
          AND ROUND(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '6 days' AND overtime_hours > 0 AND is_working = 1 THEN 1 ELSE 0 END) * 100.0 / NULLIF(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '6 days' THEN is_working ELSE 0 END),0), 1) < 35
        THEN 'Sehat'
        WHEN (ROUND(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '6 days' THEN is_working ELSE 0 END) * 100.0 / NULLIF(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '6 days' THEN 1 ELSE 0 END),0), 1) < 85 AND ROUND(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '6 days' THEN is_late ELSE 0 END) * 100.0 / NULLIF(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '6 days' THEN is_working ELSE 0 END),0), 1) >= 10)
          OR (ROUND(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '6 days' THEN is_working ELSE 0 END) * 100.0 / NULLIF(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '6 days' THEN 1 ELSE 0 END),0), 1) < 92 AND ROUND(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '6 days' THEN is_late ELSE 0 END) * 100.0 / NULLIF(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '6 days' THEN is_working ELSE 0 END),0), 1) >= 20)
        THEN 'Kritis'
        ELSE 'Waspada'
    END AS status_7d,
    CASE
        WHEN SUM(CASE WHEN attendance_date >= m.d - INTERVAL '6 days' THEN is_absent ELSE 0 END) >= 5
          OR ROUND(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '6 days' THEN is_working ELSE 0 END)*100.0/NULLIF(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '6 days' THEN 1 ELSE 0 END),0),1) < 88
        THEN 'Coverage risk'
        WHEN ROUND(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '6 days' THEN is_late ELSE 0 END)*100.0/NULLIF(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '6 days' THEN is_working ELSE 0 END),0),1) >= 15
        THEN 'Keterlambatan'
        WHEN ROUND(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '6 days' AND overtime_hours>0 AND is_working=1 THEN 1 ELSE 0 END)*100.0/NULLIF(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '6 days' THEN is_working ELSE 0 END),0),1) >= 25
        THEN 'Overtime pressure'
        ELSE 'Workforce sehat'
    END AS focus_7d,
    (SELECT branch_name FROM main_marts.mart_employee_shift_performance CROSS JOIN max_d WHERE attendance_date >= max_d.d - INTERVAL '6 days' GROUP BY branch_name ORDER BY SUM(CASE WHEN attendance_status='absent' THEN 1 ELSE 0 END) DESC LIMIT 1) AS pressure_branch_7d,
    (SELECT shift_name FROM main_marts.mart_employee_shift_performance CROSS JOIN max_d WHERE attendance_date >= max_d.d - INTERVAL '6 days' GROUP BY shift_name ORDER BY SUM(CASE WHEN attendance_status='absent' THEN 1 ELSE 0 END) DESC LIMIT 1) AS pressure_shift_7d,

    -- 30 Hari (30d)
    ROUND(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '29 days' THEN is_working ELSE 0 END) * 100.0
         / NULLIF(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '29 days' THEN 1 ELSE 0 END), 0), 1) AS attendance_30d,
    ROUND(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '29 days' THEN is_late ELSE 0 END) * 100.0
         / NULLIF(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '29 days' THEN is_working ELSE 0 END), 0), 1) AS late_30d,
    SUM(CASE WHEN attendance_date >= m.d - INTERVAL '29 days' THEN is_absent ELSE 0 END) AS absent_30d,
    ROUND(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '29 days' AND overtime_hours > 0 AND is_working = 1 THEN 1 ELSE 0 END) * 100.0
         / NULLIF(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '29 days' THEN is_working ELSE 0 END), 0), 1) AS overtime_pct_30d,
    SUM(CASE WHEN attendance_date >= m.d - INTERVAL '29 days' AND is_working = 1 THEN overtime_hours ELSE 0 END) AS overtime_hours_30d,
    SUM(CASE WHEN attendance_date >= m.d - INTERVAL '29 days' THEN is_late ELSE 0 END) AS late_count_30d,
    ROUND(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '29 days' AND is_working = 1 THEN total_revenue ELSE 0 END)
         / NULLIF(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '29 days' AND is_working = 1 THEN shift_dur ELSE 0 END), 0), 0) AS rev_per_hour_30d,
    (SELECT COUNT(*) FROM (SELECT e2.employee_id FROM main_marts.mart_employee_shift_performance e2 CROSS JOIN max_d m2 WHERE e2.attendance_date >= m2.d - INTERVAL '29 days' GROUP BY e2.employee_id HAVING SUM(CASE WHEN e2.attendance_status='absent' THEN 1 ELSE 0 END) >= 2 OR SUM(CASE WHEN e2.attendance_status='late' THEN 1 ELSE 0 END) >= 4)) AS problem_employees_30d,
    CASE
        WHEN ROUND(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '29 days' THEN is_working ELSE 0 END) * 100.0 / NULLIF(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '29 days' THEN 1 ELSE 0 END),0), 1) >= 92
          AND ROUND(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '29 days' THEN is_late ELSE 0 END) * 100.0 / NULLIF(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '29 days' THEN is_working ELSE 0 END),0), 1) < 10
          AND SUM(CASE WHEN attendance_date >= m.d - INTERVAL '29 days' THEN is_absent ELSE 0 END) < 5
          AND ROUND(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '29 days' AND overtime_hours > 0 AND is_working = 1 THEN 1 ELSE 0 END) * 100.0 / NULLIF(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '29 days' THEN is_working ELSE 0 END),0), 1) < 35
        THEN 'Sehat'
        WHEN (ROUND(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '29 days' THEN is_working ELSE 0 END) * 100.0 / NULLIF(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '29 days' THEN 1 ELSE 0 END),0), 1) < 85 AND ROUND(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '29 days' THEN is_late ELSE 0 END) * 100.0 / NULLIF(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '29 days' THEN is_working ELSE 0 END),0), 1) >= 10)
          OR (ROUND(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '29 days' THEN is_working ELSE 0 END) * 100.0 / NULLIF(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '29 days' THEN 1 ELSE 0 END),0), 1) < 92 AND ROUND(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '29 days' THEN is_late ELSE 0 END) * 100.0 / NULLIF(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '29 days' THEN is_working ELSE 0 END),0), 1) >= 20)
        THEN 'Kritis'
        ELSE 'Waspada'
    END AS status_30d,
    CASE
        WHEN SUM(CASE WHEN attendance_date >= m.d - INTERVAL '29 days' THEN is_absent ELSE 0 END) >= 5
          OR ROUND(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '29 days' THEN is_working ELSE 0 END)*100.0/NULLIF(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '29 days' THEN 1 ELSE 0 END),0),1) < 88
        THEN 'Coverage risk'
        WHEN ROUND(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '29 days' THEN is_late ELSE 0 END)*100.0/NULLIF(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '29 days' THEN is_working ELSE 0 END),0),1) >= 15
        THEN 'Keterlambatan'
        WHEN ROUND(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '29 days' AND overtime_hours>0 AND is_working=1 THEN 1 ELSE 0 END)*100.0/NULLIF(SUM(CASE WHEN attendance_date >= m.d - INTERVAL '29 days' THEN is_working ELSE 0 END),0),1) >= 25
        THEN 'Overtime pressure'
        ELSE 'Workforce sehat'
    END AS focus_30d,
    (SELECT branch_name FROM main_marts.mart_employee_shift_performance CROSS JOIN max_d WHERE attendance_date >= max_d.d - INTERVAL '29 days' GROUP BY branch_name ORDER BY SUM(CASE WHEN attendance_status='absent' THEN 1 ELSE 0 END)*10 + SUM(CASE WHEN attendance_status='late' THEN 1 ELSE 0 END) DESC LIMIT 1) AS pressure_branch_30d,
    (SELECT shift_name FROM main_marts.mart_employee_shift_performance CROSS JOIN max_d WHERE attendance_date >= max_d.d - INTERVAL '29 days' GROUP BY shift_name ORDER BY SUM(CASE WHEN attendance_status='absent' THEN 1 ELSE 0 END)*10 + SUM(CASE WHEN attendance_status='late' THEN 1 ELSE 0 END) DESC LIMIT 1) AS pressure_shift_30d
FROM base CROSS JOIN max_d m
