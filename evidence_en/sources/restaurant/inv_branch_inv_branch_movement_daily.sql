WITH max_d AS (SELECT MAX(txn_date)::DATE AS d FROM main_marts.mart_inventory_stok)
SELECT
    branch_name,
    txn_date,
    SUM(usage_cost) AS usage_cost,
    SUM(purchase_cost) AS purchase_cost
FROM main_marts.mart_inventory_stok CROSS JOIN max_d
WHERE txn_date >= d - INTERVAL '29 days'
GROUP BY 1, 2
ORDER BY branch_name, txn_date
