SELECT
    strftime('%d %b %Y', MAX(order_date)) AS tgl_akhir,
    strftime('%d %b %Y', MAX(order_date) - INTERVAL '6 days') AS tgl_7_awal,
    strftime('%d %b %Y', MAX(order_date) - INTERVAL '29 days') AS tgl_30_awal,
    strftime('%d %b %Y', MAX(order_date) - INTERVAL '89 days') AS tgl_90_awal,
    strftime('%d %b %Y', DATE_TRUNC('month', MAX(order_date))) AS tgl_mtd_awal,
    strftime('%d %b %Y', MIN(order_date)) AS tgl_historis_awal,
    CASE strftime('%m', MAX(order_date))
        WHEN '01' THEN 'Januari'
        WHEN '02' THEN 'Februari'
        WHEN '03' THEN 'Maret'
        WHEN '04' THEN 'April'
        WHEN '05' THEN 'Mei'
        WHEN '06' THEN 'Juni'
        WHEN '07' THEN 'Juli'
        WHEN '08' THEN 'Agustus'
        WHEN '09' THEN 'September'
        WHEN '10' THEN 'Oktober'
        WHEN '11' THEN 'November'
        WHEN '12' THEN 'Desember'
    END AS nama_bulan
FROM main_marts.mart_daily_revenue
