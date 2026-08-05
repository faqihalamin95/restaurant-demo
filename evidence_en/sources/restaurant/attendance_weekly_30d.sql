WITH max_d AS (SELECT MAX(attendance_date) AS d FROM main_marts.mart_employee_shift_performance),
base AS (
    SELECT
        e.*,
        date_trunc('week', e.attendance_date) AS week_start
    FROM main_marts.mart_employee_shift_performance e CROSS JOIN max_d m
    WHERE e.attendance_date >= m.d - INTERVAL '29 days'
)
SELECT
    strftime('%d %b %Y', MIN(attendance_date)) || ' - ' || strftime('%d %b %Y', MAX(attendance_date)) AS periode,
    week_start,
    COUNT(*) AS scheduled_sessions,
    SUM(CASE WHEN attendance_status IN ('present','late') THEN 1 ELSE 0 END) AS working_sessions,
    SUM(CASE WHEN attendance_status = 'absent' THEN 1 ELSE 0 END) AS absent,
    SUM(CASE WHEN attendance_status = 'leave' THEN 1 ELSE 0 END) AS leave_count,
    SUM(CASE WHEN attendance_status = 'late' THEN 1 ELSE 0 END) AS late,
    SUM(CASE WHEN overtime_hours > 0 AND attendance_status IN ('present','late') THEN 1 ELSE 0 END) AS overtime_sessions,
    ROUND(SUM(CASE WHEN attendance_status IN ('absent','leave') THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(*), 0), 1) AS pct_tidak_hadir,
    ROUND(SUM(CASE WHEN attendance_status = 'late' THEN 1 ELSE 0 END) * 100.0 / NULLIF(SUM(CASE WHEN attendance_status IN ('present','late') THEN 1 ELSE 0 END), 0), 1) AS late_rate,
    ROUND(
        SUM(CASE WHEN attendance_status IN ('absent','leave') THEN 1 ELSE 0 END) * 4
        + SUM(CASE WHEN attendance_status = 'late' THEN 1 ELSE 0 END) * 2
        + SUM(CASE WHEN overtime_hours > 0 AND attendance_status IN ('present','late') THEN 1 ELSE 0 END),
        1
    ) AS risk_score
FROM base
GROUP BY week_start
ORDER BY week_start
