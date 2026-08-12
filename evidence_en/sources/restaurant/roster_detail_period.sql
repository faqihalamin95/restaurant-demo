WITH max_d AS (SELECT MAX(attendance_date) AS d FROM main_marts.mart_employee_shift_performance),
base AS (
    SELECT e.*, p AS period
    FROM main_marts.mart_employee_shift_performance e CROSS JOIN max_d m
    CROSS JOIN (SELECT 'y' AS p UNION ALL SELECT '7d' UNION ALL SELECT '30d') periods
    WHERE (p = 'y'   AND e.attendance_date = m.d)
       OR (p = '7d'  AND e.attendance_date >= m.d - INTERVAL '6 days')
       OR (p = '30d' AND e.attendance_date >= m.d - INTERVAL '29 days')
)
SELECT
    period,
    attendance_date,
    strftime('%d %b %Y', attendance_date) AS tanggal,
    employee_name,
    role,
    branch_name,
    shift_name,
    CASE shift_name
        WHEN 'Morning' THEN '08:00-15:00'
        WHEN 'Afternoon' THEN '12:00-20:00'
        WHEN 'Night' THEN '16:00-23:00'
        ELSE 'Jadwal tercatat'
    END AS jam_shift,
    CASE shift_name WHEN 'Afternoon' THEN 8 ELSE 7 END AS planned_hours,
    CASE
        WHEN attendance_status = 'present' THEN 'Hadir'
        WHEN attendance_status = 'late' THEN 'Terlambat'
        WHEN attendance_status = 'leave' THEN 'Cuti'
        WHEN attendance_status = 'absent' THEN 'Absent'
        ELSE attendance_status
    END AS status_label,
    overtime_hours,
    orders_handled,
    total_revenue,
    CASE
        WHEN attendance_status = 'absent' THEN 'Butuh validasi alasan dan pengganti shift'
        WHEN attendance_status = 'leave' THEN 'Cuti tercatat; pastikan role tertutup pengganti'
        WHEN attendance_status = 'late' THEN 'Konfirmasi penyebab terlambat dan cek pola 7/30 hari'
        WHEN overtime_hours > 0 THEN 'Hadir dengan overtime; cek apakah karena kekurangan orang'
        ELSE 'Shift berjalan normal'
    END AS roster_action,
    CASE
        WHEN attendance_status IN ('absent','leave') THEN 'Butuh pengganti'
        WHEN attendance_status = 'late' THEN 'Aktif terlambat'
        ELSE 'Aktif'
    END AS readiness_status
FROM base
ORDER BY period,
    attendance_date DESC,
    branch_name,
    shift_name,
    CASE attendance_status WHEN 'absent' THEN 1 WHEN 'leave' THEN 2 WHEN 'late' THEN 3 ELSE 4 END,
    employee_name
