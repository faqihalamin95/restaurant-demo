SELECT 
    metric_date as Tanggal,
    branch_name as Cabang,
    gross_revenue as Omzet,
    inventory_usage_cost as HPP,
    labor_total_cost as SDM,
    operational_total_cost as Opex,
    net_revenue as Laba_Bersih,
    ROUND(net_revenue / NULLIF(gross_revenue, 0) * 100, 1) / 100 as Margin
FROM main_marts.mart_daily_net_revenue
ORDER BY metric_date DESC, branch_name ASC
