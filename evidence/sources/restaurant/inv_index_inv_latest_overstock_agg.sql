WITH max_d AS (SELECT MAX(txn_date)::DATE AS d FROM main_marts.mart_inventory_stok),
latest AS (
    SELECT *
    FROM main_marts.mart_inventory_stok CROSS JOIN max_d
    WHERE txn_date = d
),
overstock_details AS (
    SELECT
        l.stock_value,
        l.days_remaining,
        ROUND(l.stock_value * GREATEST(l.days_remaining - 14, 0) / NULLIF(l.days_remaining,0),0) AS estimated_idle_value
    FROM latest l
    WHERE l.stock_status = 'overstock' OR l.days_remaining > 14
)
SELECT
    COUNT(*) AS total_overstock_items,
    ROUND(COALESCE(SUM(estimated_idle_value), 0), 0) AS total_idle_value
FROM overstock_details
