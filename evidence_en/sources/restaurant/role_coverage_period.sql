WITH max_d AS (SELECT MAX(attendance_date) AS d FROM main_marts.mart_employee_shift_performance),
base AS (
    SELECT e.*, p AS period,
        CASE WHEN e.attendance_status IN ('present','late') THEN 1 ELSE 0 END AS is_working,
        CASE WHEN e.attendance_status = 'late'   THEN 1 ELSE 0 END AS is_late,
        CASE WHEN e.attendance_status = 'absent' THEN 1 ELSE 0 END AS is_absent,
        CASE WHEN e.attendance_status = 'leave'  THEN 1 ELSE 0 END AS is_leave
    FROM main_marts.mart_employee_shift_performance e CROSS JOIN max_d m
    CROSS JOIN (SELECT 'y' AS p UNION ALL SELECT '7d' UNION ALL SELECT '30d') periods
    WHERE (p = 'y'   AND e.attendance_date = m.d)
       OR (p = '7d'  AND e.attendance_date >= m.d - INTERVAL '6 days')
       OR (p = '30d' AND e.attendance_date >= m.d - INTERVAL '29 days')
)
SELECT
    period,
    CASE
        WHEN period = 'y' THEN strftime('%d %b %Y', MAX(attendance_date))
        ELSE strftime('%d %b %Y', MIN(attendance_date)) || ' - ' || strftime('%d %b %Y', MAX(attendance_date))
    END AS rentang,
    branch_name,
    shift_name,
    role,
    COUNT(*) AS scheduled_sessions,
    SUM(is_working) AS working_sessions,
    SUM(is_absent) AS absent_count,
    SUM(is_leave) AS leave_count,
    SUM(is_absent + is_leave) AS gap_sessions,
    ROUND(SUM(is_working) * 100.0 / NULLIF(COUNT(*), 0), 1) AS attendance_rate,
    ROUND(SUM(is_late) * 100.0 / NULLIF(SUM(is_working), 0), 1) AS late_rate,
    SUM(CASE WHEN overtime_hours > 0 AND is_working = 1 THEN 1 ELSE 0 END) AS overtime_sessions,
    CASE
        WHEN SUM(is_absent + is_leave) >= 3 OR ROUND(SUM(is_working) * 100.0 / NULLIF(COUNT(*), 0), 1) < 85 THEN 'Kritis'
        WHEN SUM(is_absent + is_leave) >= 1 OR ROUND(SUM(is_working) * 100.0 / NULLIF(COUNT(*), 0), 1) < 92 THEN 'Perlu Pengganti'
        ELSE 'Siap'
    END AS readiness_label,
    CASE
        WHEN SUM(is_absent + is_leave) > 0 THEN 'Siapkan pengganti role ' || role || ' di ' || branch_name || ' · ' || shift_name
        WHEN ROUND(SUM(is_late) * 100.0 / NULLIF(SUM(is_working), 0), 1) >= 15 THEN 'Cek keterlambatan role ' || role || ' sebelum opening/handover'
        ELSE 'Role siap; lanjut monitor overtime dan produktivitas'
    END AS recommended_action
FROM base
GROUP BY period, branch_name, shift_name, role
ORDER BY period,
    gap_sessions DESC,
    attendance_rate ASC,
    overtime_sessions DESC,
    branch_name,
    shift_name,
    role
