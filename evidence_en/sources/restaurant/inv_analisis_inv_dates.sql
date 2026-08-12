SELECT
    strftime('%d %b %Y', MAX(txn_date))                       AS tgl_akhir,
    strftime('%d %b %Y', MAX(txn_date) - INTERVAL '6 days')  AS tgl_7d_awal,
    strftime('%d %b %Y', MAX(txn_date) - INTERVAL '29 days') AS tgl_30d_awal,
    strftime('%d %b %Y', MAX(txn_date) - INTERVAL '89 days') AS tgl_90d_awal
FROM main_marts.mart_inventory_stok
