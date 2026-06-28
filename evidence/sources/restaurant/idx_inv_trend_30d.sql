SELECT
    txn_date,
    category,
    ROUND(AVG(avg_unit_cost), 0) AS avg_harga
FROM main_marts.mart_inventory_stok
WHERE txn_date >= (SELECT MAX(txn_date) FROM main_marts.mart_inventory_stok) - INTERVAL '29 days'
GROUP BY txn_date, category
ORDER BY txn_date
