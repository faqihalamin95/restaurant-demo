WITH max_d AS (SELECT MAX(attendance_date) AS d FROM main_marts.mart_employee_shift_performance)
SELECT
    strftime('%d %b %Y', attendance_date) AS tanggal,
    employee_name,
    role,
    branch_name,
    shift_name,
    CASE
        WHEN attendance_status = 'absent' THEN 'Absent'
        WHEN attendance_status = 'late' THEN 'Terlambat'
        WHEN attendance_status = 'leave' THEN 'Cuti'
        ELSE 'Hadir'
    END AS status_label,
    CASE
        WHEN attendance_status = 'absent' THEN 'Tidak hadir di shift terbaru'
        WHEN attendance_status = 'late' THEN 'Datang terlambat di shift terbaru'
        WHEN attendance_status = 'leave' THEN 'Cuti tercatat; perlu pengganti bila shift kekurangan orang'
        ELSE 'Hadir'
    END AS catatan
FROM main_marts.mart_employee_shift_performance CROSS JOIN max_d
WHERE attendance_date = d
  AND attendance_status IN ('absent','late','leave')
ORDER BY
    CASE attendance_status WHEN 'absent' THEN 1 WHEN 'late' THEN 2 WHEN 'leave' THEN 3 ELSE 4 END,
    branch_name, shift_name, employee_name
