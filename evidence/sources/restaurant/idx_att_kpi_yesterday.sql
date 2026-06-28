WITH anchor_date AS (SELECT MAX(order_date) AS d FROM main_marts.mart_daily_revenue)
SELECT
    SUM(is_present + is_late)                                                                    AS hadir,
    SUM(is_absent)                                                                               AS absent,
    SUM(is_late)                                                                                 AS terlambat,
    ROUND(SUM(is_present + is_late)*100.0/NULLIF(SUM(is_present+is_late+is_absent),0),1)        AS pct_hadir,
    ROUND(SUM(is_late)*100.0/NULLIF(SUM(is_present+is_late),0),1)                               AS pct_terlambat,
    (SELECT shift_name FROM main_marts.mart_employee_shift_performance
     WHERE attendance_date = (SELECT d FROM anchor_date)
     GROUP BY shift_name ORDER BY SUM(total_revenue) DESC LIMIT 1)                              AS shift_tersibuk
FROM main_marts.mart_employee_shift_performance
WHERE attendance_date = (SELECT d FROM anchor_date)
