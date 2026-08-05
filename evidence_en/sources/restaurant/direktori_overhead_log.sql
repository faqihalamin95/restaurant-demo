SELECT 
    metric_date as Tanggal,
    branch_name as Cabang,
    operational_total_cost as Total_Overhead,
    ROUND(operational_total_cost * 0.40, 0) as Sewa_Gedung,
    ROUND(operational_total_cost * 0.30, 0) as Tagihan_Listrik,
    ROUND(operational_total_cost * 0.10, 0) as Tagihan_Air,
    ROUND(operational_total_cost * 0.05, 0) as Internet_Telekomunikasi,
    ROUND(operational_total_cost * 0.15, 0) as Maintenance_Lainnya
FROM main_marts.mart_daily_net_revenue
ORDER BY metric_date DESC, branch_name ASC
