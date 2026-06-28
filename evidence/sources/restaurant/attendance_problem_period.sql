WITH max_d AS (SELECT MAX(attendance_date) AS d FROM main_marts.mart_employee_shift_performance),
base AS (
    SELECT e.*, p AS period,
        CASE WHEN e.attendance_status = 'absent' THEN 1 ELSE 0 END AS is_absent,
        CASE WHEN e.attendance_status = 'late'   THEN 1 ELSE 0 END AS is_late,
        CASE WHEN e.attendance_status = 'leave'  THEN 1 ELSE 0 END AS is_leave
    FROM main_marts.mart_employee_shift_performance e CROSS JOIN max_d m
    CROSS JOIN (SELECT '7d' AS p UNION ALL SELECT '30d') periods
    WHERE (p = '7d'  AND e.attendance_date >= m.d - INTERVAL '6 days')
       OR (p = '30d' AND e.attendance_date >= m.d - INTERVAL '29 days')
)
SELECT
    period, employee_name, role, branch_name, shift_name,
    COUNT(*) AS total_workdays,
    SUM(is_absent) AS total_absent,
    SUM(is_late) AS total_late,
    SUM(is_leave) AS total_leave,
    SUM(overtime_hours) AS total_overtime_hours,
    CASE
        WHEN period = '30d' AND (SUM(is_absent) >= 3 OR SUM(is_late) >= 6) THEN 'Kritis'
        WHEN period = '30d' AND (SUM(is_absent) >= 2 OR SUM(is_late) >= 4) THEN 'Tinggi'
        WHEN period = '7d'  AND (SUM(is_absent) >= 2 OR SUM(is_late) >= 3) THEN 'Kritis'
        WHEN period = '7d'  AND (SUM(is_absent) >= 1 OR SUM(is_late) >= 2) THEN 'Sedang'
        ELSE 'Pantau'
    END AS risk_label,
    CASE
        WHEN SUM(is_absent) >= 3 THEN 'Coaching dan review jadwal — pola absent perlu dipahami penyebabnya'
        WHEN SUM(is_late) >= 6   THEN 'Diskusi keterlambatan — cek transportasi, jadwal, atau beban kerja'
        WHEN SUM(is_absent) >= 2 THEN 'Percakapan coaching untuk pahami penyebab absensi'
        WHEN SUM(is_late) >= 4   THEN 'Coaching keterlambatan — pertimbangkan penyesuaian jadwal shift'
        ELSE 'Pantau tren kehadiran minggu berikutnya'
    END AS recommended_action
FROM base
GROUP BY period, employee_name, role, branch_name, shift_name
HAVING (period = '30d' AND (SUM(is_absent) >= 2 OR SUM(is_late) >= 4))
    OR (period = '7d'  AND (SUM(is_absent) >= 1 OR SUM(is_late) >= 2))
ORDER BY period, SUM(is_absent) DESC, SUM(is_late) DESC
