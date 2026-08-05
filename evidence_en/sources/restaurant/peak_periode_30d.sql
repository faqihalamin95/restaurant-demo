SELECT
    strftime('%d %b %Y', MAX(order_date) - INTERVAL '29 days') AS tgl_awal,
    strftime('%d %b %Y', MAX(order_date))                       AS tgl_akhir
FROM main_marts.mart_peak_hours
