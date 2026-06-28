SELECT
    strftime('%d %b %Y', MAX(order_date)) AS tgl_akhir,
    strftime('%d %b %Y', MAX(order_date) - INTERVAL '6 days') AS tgl_7_awal,
    strftime('%d %b %Y', MAX(order_date) - INTERVAL '29 days') AS tgl_30_awal,
    strftime('%d %b %Y', MAX(order_date) - INTERVAL '89 days') AS tgl_90_awal,
    strftime('%d %b %Y', DATE_TRUNC('month', MAX(order_date))) AS tgl_mtd_awal,
    strftime('%d %b %Y', MIN(order_date)) AS tgl_historis_awal
FROM main_marts.mart_daily_revenue
