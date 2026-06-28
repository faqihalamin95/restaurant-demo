SELECT COUNT(*) AS jumlah_absent FROM main_marts.mart_employee_shift_performance
WHERE attendance_date = (SELECT MAX(attendance_date) FROM main_marts.mart_employee_shift_performance)
  AND attendance_status = 'absent'
