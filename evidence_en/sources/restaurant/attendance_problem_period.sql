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
    period, employee_name, role, MAX(branch_name) as branch_name, MAX(shift_name) as shift_name,
    CASE
        WHEN period = '30d' AND (SUM(is_absent) >= 3 OR SUM(is_late) >= 6) THEN '<span style="background-color: #fee2e2; color: #991b1b; padding: 2px 8px; border-radius: 6px; font-weight: 700;">' || employee_name || '</span>'
        WHEN period = '7d'  AND (SUM(is_absent) >= 2 OR SUM(is_late) >= 3) THEN '<span style="background-color: #fee2e2; color: #991b1b; padding: 2px 8px; border-radius: 6px; font-weight: 700;">' || employee_name || '</span>'
        ELSE employee_name
    END AS nama_staf_html,
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
        WHEN SUM(is_absent) >= 3 THEN 'Terbitkan SP1. Panggil untuk investigasi alasan mangkir beruntun.'
        WHEN SUM(is_late) >= 6   THEN 'Terbitkan SP1. Wajibkan lapor absensi 15 menit sebelum shift.'
        WHEN SUM(is_absent) >= 2 THEN 'Peringatan Lisan & Sesi 1-on-1: Cari tahu alasan absensi.'
        WHEN SUM(is_late) >= 4   THEN 'Sesi 1-on-1 Coaching: Evaluasi jadwal shift & akses transportasi.'
        ELSE 'Pantau tren kehadiran minggu berikutnya'
    END AS recommended_action
FROM base
GROUP BY period, employee_name, role
HAVING (period = '30d' AND (SUM(is_absent) >= 2 OR SUM(is_late) >= 4))
    OR (period = '7d'  AND (SUM(is_absent) >= 1 OR SUM(is_late) >= 2))
ORDER BY period, SUM(is_absent) DESC, SUM(is_late) DESC
