WITH base AS (
WITH max_d AS (SELECT MAX(txn_date)::DATE AS d FROM main_marts.mart_inventory_stok),
latest AS (
    SELECT days_remaining
    FROM main_marts.mart_inventory_stok CROSS JOIN max_d
    WHERE txn_date = d AND (stock_status = 'low' OR days_remaining <= 5)
)
SELECT
    CASE
        WHEN days_remaining < 1.5 THEN '1. Kritis (<1.5 Hari)'
        WHEN days_remaining < 3 THEN '2. Reorder (<3 Hari)'
        ELSE '3. Pantau (<=5 Hari)'
    END AS status,
    COUNT(*) AS item_count
FROM latest
GROUP BY 1
ORDER BY status
),
dummy AS (
    SELECT 
        CAST(NULL AS VARCHAR) AS status,
        CAST(NULL AS BIGINT) AS item_count
    WHERE NOT EXISTS (SELECT 1 FROM base)
)
SELECT * FROM base
UNION ALL
SELECT * FROM dummy
