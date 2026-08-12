WITH max_d AS (SELECT MAX(txn_date)::DATE AS d FROM main_marts.mart_inventory_stok),
latest AS (
    SELECT *
    FROM main_marts.mart_inventory_stok CROSS JOIN max_d
    WHERE txn_date = d
)
SELECT
    COUNT(CASE WHEN days_remaining < 3 THEN 1 END) AS critical_reorder_count,
    COUNT(*) AS total_low_stock_items
FROM latest
WHERE stock_status = 'low' OR days_remaining <= 5
