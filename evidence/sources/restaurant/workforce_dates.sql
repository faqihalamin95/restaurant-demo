SELECT
    strftime('%d %b %Y', MAX(attendance_date))                       AS tgl_akhir,
    strftime('%d %b %Y', MAX(attendance_date) - INTERVAL '6 days')  AS tgl_7_awal,
    strftime('%d %b %Y', MAX(attendance_date) - INTERVAL '29 days') AS tgl_30_awal
FROM main_marts.mart_employee_shift_performance
