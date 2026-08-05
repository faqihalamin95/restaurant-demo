WITH base AS (
WITH max_d AS (SELECT MAX(txn_date)::DATE AS d FROM main_marts.mart_inventory_stok),
movement AS (
    SELECT
        branch_name,
        item_name,
        ROUND(SUM(usage_qty)/30,2) AS avg_daily_usage,
        SUM(usage_cost) AS usage_cost_30d
    FROM main_marts.mart_inventory_stok CROSS JOIN max_d
    WHERE txn_date >= d - INTERVAL '29 days'
    GROUP BY 1, 2
),
latest AS (
    SELECT *
    FROM main_marts.mart_inventory_stok CROSS JOIN max_d
    WHERE txn_date = d
)
SELECT
    l.branch_name,
    l.item_name,
    l.category,
    l.unit,
    l.stock_on_hand,
    l.days_remaining,
    l.stock_value,
    COALESCE(m.avg_daily_usage,0) AS avg_daily_usage,
    COALESCE(m.usage_cost_30d,0) AS usage_cost_30d,
    7 AS target_coverage_days,
    ROUND(GREATEST(COALESCE(m.avg_daily_usage,0) * 7 - l.stock_on_hand, 0),1) AS suggested_reorder_qty,
    CASE
        WHEN l.days_remaining < 1.5 THEN 'Kritis Hari Ini'
        WHEN l.days_remaining < 3 THEN 'Reorder Sekarang'
        ELSE 'Pantau Minggu Ini'
    END AS reorder_status
FROM latest l
LEFT JOIN movement m ON l.branch_name = m.branch_name AND l.item_name = m.item_name
WHERE l.stock_status = 'low' OR l.days_remaining <= 5
ORDER BY l.days_remaining ASC, m.usage_cost_30d DESC
),
dummy AS (
    SELECT 
        CAST(NULL AS VARCHAR) AS branch_name,
        CAST(NULL AS VARCHAR) AS item_name,
        CAST(NULL AS VARCHAR) AS category,
        CAST(NULL AS VARCHAR) AS unit,
        CAST(NULL AS DECIMAL(18,2)) AS stock_on_hand,
        CAST(NULL AS DECIMAL(18,2)) AS days_remaining,
        CAST(NULL AS DOUBLE) AS stock_value,
        CAST(NULL AS DOUBLE) AS avg_daily_usage,
        CAST(NULL AS DECIMAL(38,2)) AS usage_cost_30d,
        CAST(NULL AS INTEGER) AS target_coverage_days,
        CAST(NULL AS DOUBLE) AS suggested_reorder_qty,
        CAST(NULL AS VARCHAR) AS reorder_status
    WHERE NOT EXISTS (SELECT 1 FROM base)
)
SELECT * FROM base
UNION ALL
SELECT * FROM dummy
