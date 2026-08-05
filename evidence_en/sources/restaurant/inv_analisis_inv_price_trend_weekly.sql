WITH max_d AS (SELECT MAX(txn_date)::DATE AS d FROM main_marts.mart_inventory_stok)
SELECT
    DATE_TRUNC('week', txn_date) AS minggu,
    item_name,
    category,
    ROUND(AVG(avg_unit_cost),0) AS harga_rata_beli,
    ROUND(AVG(base_unit_cost),0) AS harga_dasar
FROM main_marts.mart_inventory_stok CROSS JOIN max_d
WHERE txn_date >= d - INTERVAL '89 days'
GROUP BY 1, 2, 3
ORDER BY 1, 2
