WITH max_d AS (
    SELECT MAX(attendance_date) AS d
    FROM main_marts.mart_employee_shift_performance
),
windows AS (
    SELECT
        'y' AS period,
        d AS current_start,
        d AS current_end,
        d - INTERVAL '1 day' AS previous_start,
        d - INTERVAL '1 day' AS previous_end
    FROM max_d
    UNION ALL
    SELECT
        '7d' AS period,
        d - INTERVAL '6 days' AS current_start,
        d AS current_end,
        d - INTERVAL '13 days' AS previous_start,
        d - INTERVAL '7 days' AS previous_end
    FROM max_d
    UNION ALL
    SELECT
        '30d' AS period,
        d - INTERVAL '29 days' AS current_start,
        d AS current_end,
        d - INTERVAL '59 days' AS previous_start,
        d - INTERVAL '30 days' AS previous_end
    FROM max_d
),
base AS (
    SELECT
        e.attendance_date,
        CASE WHEN e.attendance_status IN ('present','late') THEN 1 ELSE 0 END AS is_working,
        CASE WHEN e.attendance_status = 'late' THEN 1 ELSE 0 END AS is_late,
        CASE WHEN e.overtime_hours > 0 AND e.attendance_status IN ('present','late') THEN 1 ELSE 0 END AS is_overtime_session
    FROM main_marts.mart_employee_shift_performance e
),
metrics AS (
    SELECT
        w.period,
        w.current_start,
        w.current_end,
        w.previous_start,
        w.previous_end,
        ROUND(SUM(CASE WHEN b.attendance_date BETWEEN w.current_start AND w.current_end THEN b.is_working ELSE 0 END) * 100.0
            / NULLIF(SUM(CASE WHEN b.attendance_date BETWEEN w.current_start AND w.current_end THEN 1 ELSE 0 END), 0), 1) AS current_attendance_rate,
        ROUND(SUM(CASE WHEN b.attendance_date BETWEEN w.previous_start AND w.previous_end THEN b.is_working ELSE 0 END) * 100.0
            / NULLIF(SUM(CASE WHEN b.attendance_date BETWEEN w.previous_start AND w.previous_end THEN 1 ELSE 0 END), 0), 1) AS previous_attendance_rate,
        ROUND(SUM(CASE WHEN b.attendance_date BETWEEN w.current_start AND w.current_end THEN b.is_late ELSE 0 END) * 100.0
            / NULLIF(SUM(CASE WHEN b.attendance_date BETWEEN w.current_start AND w.current_end THEN b.is_working ELSE 0 END), 0), 1) AS current_late_rate,
        ROUND(SUM(CASE WHEN b.attendance_date BETWEEN w.previous_start AND w.previous_end THEN b.is_late ELSE 0 END) * 100.0
            / NULLIF(SUM(CASE WHEN b.attendance_date BETWEEN w.previous_start AND w.previous_end THEN b.is_working ELSE 0 END), 0), 1) AS previous_late_rate,
        ROUND(SUM(CASE WHEN b.attendance_date BETWEEN w.current_start AND w.current_end THEN b.is_overtime_session ELSE 0 END) * 100.0
            / NULLIF(SUM(CASE WHEN b.attendance_date BETWEEN w.current_start AND w.current_end THEN b.is_working ELSE 0 END), 0), 1) AS current_overtime_rate,
        ROUND(SUM(CASE WHEN b.attendance_date BETWEEN w.previous_start AND w.previous_end THEN b.is_overtime_session ELSE 0 END) * 100.0
            / NULLIF(SUM(CASE WHEN b.attendance_date BETWEEN w.previous_start AND w.previous_end THEN b.is_working ELSE 0 END), 0), 1) AS previous_overtime_rate
    FROM windows w
    CROSS JOIN base b
    GROUP BY w.period, w.current_start, w.current_end, w.previous_start, w.previous_end
)
SELECT
    period,
    CASE
        WHEN period = 'y' THEN strftime('%d %b %Y', current_end)
        ELSE strftime('%d %b %Y', current_start) || ' - ' || strftime('%d %b %Y', current_end)
    END AS active_range,
    CASE
        WHEN period = 'y' THEN 'hari sebelumnya'
        WHEN period = '7d' THEN '7 hari sebelumnya'
        ELSE '30 hari sebelumnya'
    END AS comparison_label,
    current_attendance_rate,
    previous_attendance_rate,
    ROUND((current_attendance_rate - previous_attendance_rate) * 100.0 / NULLIF(previous_attendance_rate, 0), 1) AS attendance_change_pct,
    current_late_rate,
    previous_late_rate,
    ROUND((current_late_rate - previous_late_rate) * 100.0 / NULLIF(previous_late_rate, 0), 1) AS late_change_pct,
    current_overtime_rate,
    previous_overtime_rate,
    ROUND((current_overtime_rate - previous_overtime_rate) * 100.0 / NULLIF(previous_overtime_rate, 0), 1) AS overtime_change_pct
FROM metrics
ORDER BY CASE period WHEN 'y' THEN 1 WHEN '7d' THEN 2 ELSE 3 END
