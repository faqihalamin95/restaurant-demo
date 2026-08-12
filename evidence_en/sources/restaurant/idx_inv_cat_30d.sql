SELECT category, SUM(usage_cost) AS biaya_pakai, SUM(purchase_cost) AS biaya_beli
FROM main_marts.mart_inventory_stok
WHERE txn_date >= (SELECT MAX(txn_date) FROM main_marts.mart_inventory_stok) - INTERVAL '29 days'
GROUP BY category ORDER BY biaya_pakai DESC
