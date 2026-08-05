WITH max_d AS (SELECT MAX(attendance_date) AS d FROM main_marts.mart_employee_shift_performance)
SELECT
    '7d' AS period,
    shift_name,
    SUM(CASE WHEN attendance_date >= d - INTERVAL '6 days'  AND attendance_status IN ('present','late') THEN orders_handled ELSE 0 END) AS orders_current,
    SUM(CASE WHEN attendance_date >= d - INTERVAL '13 days' AND attendance_date < d - INTERVAL '6 days' AND attendance_status IN ('present','late') THEN orders_handled ELSE 0 END) AS orders_previous,
    ROUND((SUM(CASE WHEN attendance_date >= d - INTERVAL '6 days'  AND attendance_status IN ('present','late') THEN orders_handled ELSE 0 END)
          - SUM(CASE WHEN attendance_date >= d - INTERVAL '13 days' AND attendance_date < d - INTERVAL '6 days' AND attendance_status IN ('present','late') THEN orders_handled ELSE 0 END))
          * 100.0 / NULLIF(SUM(CASE WHEN attendance_date >= d - INTERVAL '13 days' AND attendance_date < d - INTERVAL '6 days' AND attendance_status IN ('present','late') THEN orders_handled ELSE 0 END), 0), 1) AS orders_change_pct,
    SUM(CASE WHEN attendance_date >= d - INTERVAL '6 days'  AND attendance_status IN ('present','late') THEN total_revenue ELSE 0 END) AS revenue_current,
    SUM(CASE WHEN attendance_date >= d - INTERVAL '13 days' AND attendance_date < d - INTERVAL '6 days' AND attendance_status IN ('present','late') THEN total_revenue ELSE 0 END) AS revenue_previous,
    ROUND((SUM(CASE WHEN attendance_date >= d - INTERVAL '6 days'  AND attendance_status IN ('present','late') THEN total_revenue ELSE 0 END)
          - SUM(CASE WHEN attendance_date >= d - INTERVAL '13 days' AND attendance_date < d - INTERVAL '6 days' AND attendance_status IN ('present','late') THEN total_revenue ELSE 0 END))
          * 100.0 / NULLIF(SUM(CASE WHEN attendance_date >= d - INTERVAL '13 days' AND attendance_date < d - INTERVAL '6 days' AND attendance_status IN ('present','late') THEN total_revenue ELSE 0 END), 0), 1) AS revenue_change_pct,
    SUM(CASE WHEN attendance_date >= d - INTERVAL '6 days'  AND attendance_status IN ('present','late') THEN overtime_hours ELSE 0 END) AS overtime_current,
    SUM(CASE WHEN attendance_date >= d - INTERVAL '13 days' AND attendance_date < d - INTERVAL '6 days' AND attendance_status IN ('present','late') THEN overtime_hours ELSE 0 END) AS overtime_previous,
    ROUND((SUM(CASE WHEN attendance_date >= d - INTERVAL '6 days'  AND attendance_status IN ('present','late') THEN overtime_hours ELSE 0 END)
          - SUM(CASE WHEN attendance_date >= d - INTERVAL '13 days' AND attendance_date < d - INTERVAL '6 days' AND attendance_status IN ('present','late') THEN overtime_hours ELSE 0 END))
          * 100.0 / NULLIF(SUM(CASE WHEN attendance_date >= d - INTERVAL '13 days' AND attendance_date < d - INTERVAL '6 days' AND attendance_status IN ('present','late') THEN overtime_hours ELSE 0 END), 0), 1) AS overtime_change_pct,
    CASE
        WHEN ROUND((SUM(CASE WHEN attendance_date >= d - INTERVAL '6 days'  AND attendance_status IN ('present','late') THEN orders_handled ELSE 0 END)
          - SUM(CASE WHEN attendance_date >= d - INTERVAL '13 days' AND attendance_date < d - INTERVAL '6 days' AND attendance_status IN ('present','late') THEN orders_handled ELSE 0 END))
          * 100.0 / NULLIF(SUM(CASE WHEN attendance_date >= d - INTERVAL '13 days' AND attendance_date < d - INTERVAL '6 days' AND attendance_status IN ('present','late') THEN orders_handled ELSE 0 END), 0), 1) >= 10 THEN 'Naik'
        WHEN ROUND((SUM(CASE WHEN attendance_date >= d - INTERVAL '6 days'  AND attendance_status IN ('present','late') THEN orders_handled ELSE 0 END)
          - SUM(CASE WHEN attendance_date >= d - INTERVAL '13 days' AND attendance_date < d - INTERVAL '6 days' AND attendance_status IN ('present','late') THEN orders_handled ELSE 0 END))
          * 100.0 / NULLIF(SUM(CASE WHEN attendance_date >= d - INTERVAL '13 days' AND attendance_date < d - INTERVAL '6 days' AND attendance_status IN ('present','late') THEN orders_handled ELSE 0 END), 0), 1) <= -10 THEN 'Turun'
        ELSE 'Stabil'
    END AS movement_status
FROM main_marts.mart_employee_shift_performance CROSS JOIN max_d
WHERE attendance_date >= d - INTERVAL '13 days'
GROUP BY shift_name
ORDER BY shift_name
