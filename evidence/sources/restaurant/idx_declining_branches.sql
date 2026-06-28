SELECT COUNT(*) AS jumlah_cabang, MIN(branch_name) AS cabang_terparah
FROM main_marts.mart_daily_revenue
WHERE order_date = (SELECT MAX(order_date) FROM main_marts.mart_daily_revenue)
  AND pct_change_vs_sdow_avg < -0.20
