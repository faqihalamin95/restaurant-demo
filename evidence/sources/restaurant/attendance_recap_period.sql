WITH max_d AS (
    SELECT MAX(attendance_date) AS d FROM main_marts.mart_employee_shift_performance
),
base AS (
    SELECT
        e.*,
        CASE WHEN e.attendance_status IN ('present','late') THEN 1 ELSE 0 END AS is_working,
        CASE WHEN e.attendance_status = 'present' THEN 1 ELSE 0 END AS is_present,
        CASE WHEN e.attendance_status = 'late'   THEN 1 ELSE 0 END AS is_late,
        CASE WHEN e.attendance_status = 'absent' THEN 1 ELSE 0 END AS is_absent,
        CASE WHEN e.attendance_status = 'leave'  THEN 1 ELSE 0 END AS is_leave
    FROM main_marts.mart_employee_shift_performance e
    CROSS JOIN max_d m
    WHERE e.attendance_date <= m.d
),
periodized AS (
    SELECT *, 'y' AS period
    FROM base CROSS JOIN max_d m
    WHERE attendance_date = m.d

    UNION ALL
    SELECT *, '7d' AS period
    FROM base CROSS JOIN max_d m
    WHERE attendance_date >= m.d - INTERVAL '6 days'

    UNION ALL
    SELECT *, '30d' AS period
    FROM base CROSS JOIN max_d m
    WHERE attendance_date >= m.d - INTERVAL '29 days'

    UNION ALL
    SELECT *, 'month' AS period
    FROM base CROSS JOIN max_d m
    WHERE m.d > date_trunc('month', m.d)
      AND attendance_date >= date_trunc('month', m.d)
),
agg AS (
    SELECT
        period,
        CASE
            WHEN period = 'y' THEN strftime('%d %b %Y', MAX(attendance_date))
            ELSE strftime('%d %b %Y', MIN(attendance_date)) || ' - ' || strftime('%d %b %Y', MAX(attendance_date))
        END AS rentang,
        employee_name,
        MIN(role) AS role,
        CASE
            WHEN COUNT(DISTINCT branch_name) = 1 THEN MIN(branch_name)
            ELSE CAST(COUNT(DISTINCT branch_name) AS VARCHAR) || ' cabang'
        END AS branch_name,
        COUNT(*) AS scheduled_days,
        SUM(is_working) AS hadir_count,
        SUM(is_present) AS tepat_waktu_count,
        SUM(is_absent) AS absent_count,
        SUM(is_leave) AS leave_count,
        SUM(is_late) AS late_count,
        ROUND(SUM(is_working) * 100.0 / NULLIF(COUNT(*) - SUM(is_leave), 0), 1) AS attendance_rate,
        ROUND(SUM(is_late) * 100.0 / NULLIF(SUM(is_working), 0), 1) AS late_rate
    FROM periodized
    GROUP BY period, employee_name
),
scored AS (
    SELECT
        *,
        CASE
            WHEN absent_count >= CASE WHEN period = 'y' THEN 2 WHEN period = '7d' THEN 3 ELSE 5 END
              OR COALESCE(late_rate, 0) >= 20 THEN 'Perlu Follow-up'
            WHEN absent_count >= 1 OR COALESCE(late_rate, 0) >= 10 THEN 'Pantau'
            ELSE 'Normal'
        END AS status_label,
        CASE
            WHEN absent_count >= CASE WHEN period = 'y' THEN 2 WHEN period = '7d' THEN 3 ELSE 5 END THEN 'Absent melewati batas follow-up periode ini'
            WHEN COALESCE(late_rate, 0) >= 20 THEN 'Late rate masuk area kritis'
            WHEN absent_count >= 1 THEN 'Ada absent yang perlu divalidasi'
            WHEN COALESCE(late_rate, 0) >= 10 THEN 'Late rate masuk area waspada'
            ELSE 'Absent 0 dan late rate sehat'
        END AS status_basis
    FROM agg
),
ranked AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY period ORDER BY absent_count DESC, late_count DESC, scheduled_days DESC, employee_name) AS absent_rank,
        ROW_NUMBER() OVER (PARTITION BY period ORDER BY late_count DESC, absent_count DESC, scheduled_days DESC, employee_name) AS late_rank
    FROM scored
)
SELECT *
FROM ranked
ORDER BY
    period,
    CASE status_label WHEN 'Perlu Follow-up' THEN 1 WHEN 'Pantau' THEN 2 ELSE 3 END,
    absent_count DESC,
    late_count DESC,
    employee_name
