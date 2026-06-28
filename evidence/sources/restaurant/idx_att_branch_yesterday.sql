SELECT
    branch_name,
    ROUND(SUM(is_present+is_late)*100.0/NULLIF(SUM(is_present+is_late+is_absent),0),1) AS pct_hadir
FROM main_marts.mart_employee_shift_performance
WHERE attendance_date = (SELECT MAX(attendance_date) FROM main_marts.mart_employee_shift_performance)
GROUP BY branch_name ORDER BY pct_hadir DESC
