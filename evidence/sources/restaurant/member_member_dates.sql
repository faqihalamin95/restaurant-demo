SELECT
    strftime('%d %b %Y', MAX(order_date))                        AS tgl_akhir,
    strftime('%d %b %Y', MAX(order_date) - INTERVAL '29 days')  AS tgl_30_awal,
    strftime('%d %b %Y', MAX(order_date) - INTERVAL '89 days')  AS tgl_90_awal,
    strftime('%d %b %Y', MAX(order_date) - INTERVAL '179 days') AS tgl_180_awal
FROM main_marts.mart_member_purchase_behavior
