WITH max_d AS (SELECT MAX(attendance_date) AS d FROM main_marts.mart_employee_shift_performance),
base AS (
    SELECT e.*,
        CASE e.shift_id WHEN 'S1' THEN 7 WHEN 'S2' THEN 8 WHEN 'S3' THEN 7 ELSE 7 END AS shift_dur,
        CASE WHEN e.attendance_status IN ('present','late') THEN 1 ELSE 0 END AS is_working,
        CASE WHEN e.attendance_status = 'absent' THEN 1 ELSE 0 END AS is_absent,
        CASE WHEN e.attendance_status = 'leave' THEN 1 ELSE 0 END AS is_leave,
        CASE WHEN e.attendance_status = 'late' THEN 1 ELSE 0 END AS is_late
    FROM main_marts.mart_employee_shift_performance e CROSS JOIN max_d m
    WHERE e.attendance_date >= m.d - INTERVAL '29 days'
),
base_7d AS (
    SELECT b.*
    FROM base b CROSS JOIN max_d m
    WHERE b.attendance_date >= m.d - INTERVAL '6 days'
),
branch_pressure_7d AS (
    SELECT branch_name,
        SUM(is_absent) AS absent_cnt,
        SUM(is_leave) AS leave_cnt,
        SUM(is_late) AS late_cnt,
        ROUND(SUM(is_working)*100.0/NULLIF(COUNT(*),0),1) AS att_rate,
        ROUND(SUM(CASE WHEN overtime_hours > 0 AND is_working=1 THEN 1 ELSE 0 END)*100.0/NULLIF(SUM(is_working),0),1) AS ot_pct
    FROM base_7d
    GROUP BY branch_name
    HAVING SUM(is_absent) + SUM(is_leave) >= 2
        OR ROUND(SUM(is_working)*100.0/NULLIF(COUNT(*),0),1) < 90
        OR ROUND(SUM(CASE WHEN overtime_hours > 0 AND is_working=1 THEN 1 ELSE 0 END)*100.0/NULLIF(SUM(is_working),0),1) >= 25
    ORDER BY (SUM(is_absent) + SUM(is_leave)) DESC, ot_pct DESC
    LIMIT 2
),
emp_recent_7d AS (
    SELECT employee_name, role, branch_name, shift_name,
        SUM(is_absent) AS tot_absent,
        SUM(is_late) AS tot_late
    FROM base_7d
    GROUP BY employee_name, role, branch_name, shift_name
    HAVING SUM(is_absent) >= 1 OR SUM(is_late) >= 2
    ORDER BY SUM(is_absent) DESC, SUM(is_late) DESC
    LIMIT 2
),
branch_pressure_30d AS (
    SELECT branch_name,
        SUM(is_absent) AS absent_cnt,
        SUM(is_leave) AS leave_cnt,
        SUM(is_late) AS late_cnt,
        ROUND(SUM(is_working)*100.0/NULLIF(COUNT(*),0),1) AS att_rate,
        ROUND(SUM(CASE WHEN overtime_hours > 0 AND is_working=1 THEN 1 ELSE 0 END)*100.0/NULLIF(SUM(is_working),0),1) AS ot_pct,
        COUNT(*) AS scheduled
    FROM base
    GROUP BY branch_name
    HAVING SUM(is_absent) >= 3 OR ROUND(SUM(is_working)*100.0/NULLIF(COUNT(*),0),1) < 88
    ORDER BY SUM(is_absent) DESC, att_rate ASC
    LIMIT 3
),
emp_absent_30d AS (
    SELECT employee_name, role, branch_name, shift_name,
        SUM(is_absent) AS tot_absent,
        SUM(is_late) AS tot_late
    FROM base
    GROUP BY employee_name, role, branch_name, shift_name
    HAVING SUM(is_absent) >= 2
    ORDER BY SUM(is_absent) DESC, SUM(is_late) DESC
    LIMIT 3
),
emp_late_30d AS (
    SELECT employee_name, role, branch_name, shift_name,
        SUM(is_absent) AS tot_absent,
        SUM(is_late) AS tot_late
    FROM base
    GROUP BY employee_name, role, branch_name, shift_name
    HAVING SUM(is_late) >= 4 AND SUM(is_absent) < 2
    ORDER BY SUM(is_late) DESC
    LIMIT 2
),
shift_ot_30d AS (
    SELECT shift_name,
        ROUND(SUM(CASE WHEN overtime_hours > 0 AND is_working=1 THEN 1 ELSE 0 END)*100.0/NULLIF(SUM(is_working),0),1) AS ot_pct,
        SUM(overtime_hours) AS tot_ot
    FROM base
    GROUP BY shift_name
    HAVING ROUND(SUM(CASE WHEN overtime_hours > 0 AND is_working=1 THEN 1 ELSE 0 END)*100.0/NULLIF(SUM(is_working),0),1) >= 25
    ORDER BY ot_pct DESC
    LIMIT 2
),
emp_prod_30d AS (
    SELECT e.employee_name, e.role, e.branch_name, e.shift_name,
        ROUND(SUM(e.total_revenue)/NULLIF(SUM(e.is_working * e.shift_dur),0),0) AS rev_hr,
        SUM(e.orders_handled) AS tot_orders
    FROM base e
    GROUP BY e.employee_name, e.role, e.branch_name, e.shift_name
    HAVING SUM(e.is_working) >= 5
       AND ROUND(SUM(e.total_revenue)/NULLIF(SUM(e.is_working * e.shift_dur),0),0) > 0
    ORDER BY rev_hr DESC
    LIMIT 2
)
SELECT priority, action_group, evidence_window, severity, action_type, subject_name, subject_type, branch_name, shift_name, metric_value, impact_text, recommended_action, first_step, guardrail
FROM (
    SELECT 10 AS priority, 'Masalah Operasional' AS action_group, '7H' AS evidence_window,
        CASE WHEN absent_cnt + leave_cnt >= 4 OR att_rate < 85 THEN 'Tinggi' ELSE 'Sedang' END AS severity,
        'Backup Shift Minggu Ini' AS action_type,
        branch_name AS subject_name, 'Cabang' AS subject_type, branch_name, NULL AS shift_name,
        'Hadir ' || att_rate || '% · absent ' || absent_cnt || 'x · cuti ' || leave_cnt || 'x · OT ' || ot_pct || '%' AS metric_value,
        'Cabang ini punya sinyal kapasitas pendek yang bisa mengganggu operasional minggu ini.' AS impact_text,
        'Siapkan backup shift dan cek apakah cuti/absent sudah tertutup roster.' AS recommended_action,
        'Cek roster 7H dan hubungi kandidat backup sebelum shift rawan berikutnya.' AS first_step,
        'Jangan ubah struktur roster permanen dari sinyal 7H saja; validasi lagi di pola 30H.' AS guardrail
    FROM branch_pressure_7d

    UNION ALL
    SELECT 20, 'Masalah Kehadiran', '7H', 'Sedang', 'Validasi Kehadiran Terbaru', employee_name, 'Pegawai', branch_name, shift_name,
        'Absent ' || tot_absent || 'x · terlambat ' || tot_late || 'x dalam 7 hari' AS metric_value,
        'Kejadian terbaru bisa mengganggu shift, tapi belum otomatis pola personal.' AS impact_text,
        'Lakukan follow-up ringan untuk memahami penyebab dan pastikan jadwal berikutnya jelas.' AS recommended_action,
        'Cek Rekap Kehadiran 7H, lalu validasi jadwal, transportasi, atau kendala personal.' AS first_step,
        'Jangan jadikan sinyal 7H sebagai hukuman; pakai untuk validasi awal.' AS guardrail
    FROM emp_recent_7d

    UNION ALL
    SELECT 30, 'Masalah Operasional', '30H', 'Kritis', 'Review Roster Cabang', branch_name, 'Cabang', branch_name, NULL,
        'Hadir ' || att_rate || '% · absent ' || absent_cnt || 'x · cuti ' || leave_cnt || 'x' AS metric_value,
        'Kapasitas shift berulang terancam dan rekan satu cabang berpotensi menanggung beban tambahan.' AS impact_text,
        'Atur staf pengganti dan review roster cabang ini. Cek apakah jadwal realistis dengan ketersediaan tim.' AS recommended_action,
        'Bandingkan Rekap Kehadiran 30H dengan Pola Risiko Shift untuk melihat cabang/shift yang berulang.' AS first_step,
        'Validasi cuti sebagai hak pegawai; masalahnya adalah penutup roster, bukan cutinya.' AS guardrail
    FROM branch_pressure_30d

    UNION ALL
    SELECT 40, 'Masalah Kehadiran', '30H', 'Tinggi', 'Coaching Absent Berulang', employee_name, 'Pegawai', branch_name, shift_name,
        'Absent ' || tot_absent || 'x · terlambat ' || tot_late || 'x dalam 30 hari' AS metric_value,
        'Absensi berulang memberatkan rekan satu shift dan membuat roster sulit stabil.' AS impact_text,
        'Jadwalkan percakapan coaching untuk memahami penyebab. Cek jadwal, transportasi, atau kendala personal.' AS recommended_action,
        'Buka Rekap Kehadiran 30H pegawai ini, lalu siapkan percakapan validasi.' AS first_step,
        'Jangan putuskan sanksi hanya dari dashboard; gunakan sebagai awal percakapan.' AS guardrail
    FROM emp_absent_30d

    UNION ALL
    SELECT 50, 'Masalah Kehadiran', '30H', 'Sedang', 'Review Keterlambatan', employee_name, 'Pegawai', branch_name, shift_name,
        'Terlambat ' || tot_late || 'x dalam 30 hari' AS metric_value,
        'Keterlambatan berulang bisa mengganggu persiapan opening dan kualitas servis awal.' AS impact_text,
        'Diskusikan penyebab keterlambatan dan pertimbangkan penyesuaian jadwal bila kendalanya struktural.' AS recommended_action,
        'Cek apakah keterlambatan terkonsentrasi di shift, cabang, atau hari tertentu.' AS first_step,
        'Bedakan disiplin dari kendala jadwal/transportasi sebelum mengambil tindakan personal.' AS guardrail
    FROM emp_late_30d

    UNION ALL
    SELECT 60, 'Masalah Operasional', '30H', 'Sedang', 'Pantau Overtime Shift', shift_name, 'Shift', NULL, shift_name,
        ot_pct || '% sesi overtime · ' || tot_ot || ' jam OT' AS metric_value,
        'Overtime berulang di shift ini kemungkinan sinyal kekurangan staf atau beban ramai.' AS impact_text,
        'Audit kapasitas staf di shift ini. Jika konsisten, pertimbangkan tambah orang atau atur ulang roster.' AS recommended_action,
        'Cek subpage Overtime 30H dan bandingkan dengan Pola Risiko Shift.' AS first_step,
        'Overtime bukan otomatis prestasi; pastikan tidak ada pegawai yang terus menjadi penutup kekurangan orang.' AS guardrail
    FROM shift_ot_30d

    UNION ALL
    SELECT 70, 'Peluang Positif', '30H', 'Info', 'Apresiasi Benchmark', employee_name, 'Pegawai', branch_name, shift_name,
        'Rev/jam tertinggi — Rp ' || rev_hr AS metric_value,
        'Pegawai produktif bisa menjadi contoh praktik kerja baik atau kandidat mentor.' AS impact_text,
        'Apresiasi kontribusinya dan pertimbangkan sebagai mentor untuk membantu pegawai lain.' AS recommended_action,
        'Cek Produktivitas 30H, lalu validasi overtime dan absensi sebelum reward/mentor.' AS first_step,
        'Jangan terus menaruh benchmark di shift berat sampai beban kerjanya timpang.' AS guardrail
    FROM emp_prod_30d
)
ORDER BY priority ASC
LIMIT 12
