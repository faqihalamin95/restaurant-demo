WITH max_d AS (SELECT MAX(attendance_date) AS d FROM main_marts.mart_employee_shift_performance),
today AS (
    SELECT e.*,
        CASE WHEN e.attendance_status IN ('present','late') THEN 1 ELSE 0 END AS is_working,
        CASE WHEN e.attendance_status = 'absent' THEN 1 ELSE 0 END AS is_absent,
        CASE WHEN e.attendance_status = 'leave'  THEN 1 ELSE 0 END AS is_leave,
        CASE WHEN e.attendance_status = 'late'   THEN 1 ELSE 0 END AS is_late
    FROM main_marts.mart_employee_shift_performance e CROSS JOIN max_d m
    WHERE e.attendance_date = m.d
),
branch_shift AS (
    SELECT
        branch_name,
        shift_name,
        COUNT(*) AS scheduled,
        SUM(is_working) AS working,
        SUM(is_absent) AS absent_cnt,
        SUM(is_leave) AS leave_cnt,
        SUM(is_late) AS late_cnt,
        ROUND(SUM(is_working) * 100.0 / NULLIF(COUNT(*), 0), 1) AS coverage_rate
    FROM today
    GROUP BY branch_name, shift_name
),
coverage_actions AS (
    SELECT
        1 AS priority,
        CASE WHEN coverage_rate < 85 OR scheduled - working >= 3 THEN 'Kritis' ELSE 'Tinggi' END AS severity,
        'Kekurangan Orang Hari Ini' AS action_type,
        branch_name || ' · ' || shift_name AS subject_name,
        'Cabang & Shift' AS subject_type,
        branch_name,
        shift_name,
        'Hadir ' || coverage_rate || '% · ' || leave_cnt || ' cuti · ' || absent_cnt || ' absent' AS metric_value,
        'Shift hari ini kekurangan orang aktif. Cuti tetap hak pegawai, tapi operasional tetap perlu pengganti.' AS impact_text,
        'Cari staf pengganti untuk shift ini, lalu pisahkan review absensi dari cuti yang sudah disetujui.' AS recommended_action
    FROM branch_shift
    WHERE scheduled - working >= 2 OR coverage_rate < 90
),
late_actions AS (
    SELECT
        2 AS priority,
        'Sedang' AS severity,
        'Keterlambatan Hari Ini' AS action_type,
        employee_name AS subject_name,
        'Pegawai' AS subject_type,
        branch_name,
        shift_name,
        'Terlambat pada shift terbaru' AS metric_value,
        'Keterlambatan hari ini bisa mengganggu opening, prep, atau handover shift.' AS impact_text,
        'Konfirmasi penyebabnya hari ini. Jika berulang, lanjutkan ke pola 7/30 hari sebelum coaching formal.' AS recommended_action
    FROM today
    WHERE is_late = 1
    ORDER BY employee_name
    LIMIT 3
),
ot_actions AS (
    SELECT
        3 AS priority,
        CASE WHEN ROUND(SUM(CASE WHEN overtime_hours > 0 AND is_working = 1 THEN 1 ELSE 0 END) * 100.0 / NULLIF(SUM(is_working), 0), 1) >= 35 THEN 'Tinggi' ELSE 'Sedang' END AS severity,
        'Overtime Hari Ini' AS action_type,
        shift_name AS subject_name,
        'Shift' AS subject_type,
        NULL AS branch_name,
        shift_name,
        ROUND(SUM(CASE WHEN overtime_hours > 0 AND is_working = 1 THEN 1 ELSE 0 END) * 100.0 / NULLIF(SUM(is_working), 0), 1) || '% sesi overtime' AS metric_value,
        'Overtime hari ini adalah sinyal kapasitas. Jangan dibaca sebagai prestasi tanpa melihat coverage.' AS impact_text,
        'Cek apakah overtime muncul karena jam ramai, absent, cuti, atau roster yang kurang tepat.' AS recommended_action
    FROM today
    GROUP BY shift_name
    HAVING ROUND(SUM(CASE WHEN overtime_hours > 0 AND is_working = 1 THEN 1 ELSE 0 END) * 100.0 / NULLIF(SUM(is_working), 0), 1) >= 25
)
SELECT priority, severity, action_type, subject_name, subject_type, branch_name, shift_name, metric_value, impact_text, recommended_action
FROM (
    SELECT * FROM coverage_actions
    UNION ALL
    SELECT * FROM late_actions
    UNION ALL
    SELECT * FROM ot_actions
)
ORDER BY priority, severity
LIMIT 6
