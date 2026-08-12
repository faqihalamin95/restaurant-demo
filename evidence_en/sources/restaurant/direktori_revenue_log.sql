SELECT 
    dr.order_date as Tanggal,
    dr.branch_name as Cabang,
    dr.total_orders as Jumlah_Transaksi,
    ROUND(dr.total_revenue / NULLIF(dr.total_orders, 0), 0) as Rata_Rata_Struk,
    dr.total_revenue as Omzet_Kotor,
    ROUND(dr.total_revenue * 0.05, 0) as Diskon_Promo,
    ROUND(dr.total_revenue * 0.10, 0) as Pajak_PB1,
    ROUND(dr.total_revenue * 0.85, 0) as Net_Setoran
FROM main_marts.mart_daily_revenue dr
ORDER BY dr.order_date DESC, dr.branch_name ASC
