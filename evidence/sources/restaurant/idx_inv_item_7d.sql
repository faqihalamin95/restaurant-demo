SELECT
    item_name,
    category,
    ROUND(SUM(usage_cost), 0)                              AS biaya_pakai,
    ROUND(SUM(purchase_cost), 0)                           AS biaya_beli,
    ROUND(SUM(purchase_cost)/NULLIF(SUM(usage_cost),0), 2) AS rasio
FROM main_marts.mart_inventory_stok
WHERE txn_date >= (SELECT MAX(txn_date) FROM main_marts.mart_inventory_stok) - INTERVAL '6 days'
GROUP BY item_name, category
ORDER BY rasio DESC
