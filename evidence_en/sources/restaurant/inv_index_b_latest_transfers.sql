WITH base AS (
WITH low AS (
    SELECT *
    FROM (
WITH max_d AS (SELECT MAX(txn_date)::DATE AS d FROM main_marts.mart_inventory_stok),
movement AS (
    SELECT
        branch_name,
        item_name,
        ROUND(SUM(usage_qty)/30.0,2) AS avg_daily_usage,
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
    CASE
        WHEN l.days_remaining < 1.5 THEN '🚨 Kritis (Hari Ini)'
        WHEN l.days_remaining < 3 THEN '⚠️ Reorder Sekarang'
        ELSE '📋 Pantau'
    END AS reorder_status
FROM latest l
LEFT JOIN movement m ON l.branch_name = m.branch_name AND l.item_name = m.item_name
WHERE l.stock_status = 'low' OR l.days_remaining <= 5
ORDER BY l.days_remaining ASC, m.usage_cost_30d DESC
) AS inv_index_a_latest_reorder
    WHERE days_remaining < 3
),
over AS (
    SELECT *
    FROM (
WITH max_d AS (SELECT MAX(txn_date)::DATE AS d FROM main_marts.mart_inventory_stok),
movement AS (
    SELECT
        branch_name,
        item_name,
        SUM(usage_cost) AS usage_cost_30d,
        SUM(purchase_cost) AS purchase_cost_30d,
        ROUND(SUM(purchase_cost)/NULLIF(SUM(usage_cost),0),2) AS purchase_usage_ratio_30d
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
    ROUND(l.stock_value * GREATEST(l.days_remaining - 14, 0) / NULLIF(l.days_remaining,0),0) AS estimated_idle_value,
    ROUND(GREATEST(l.days_remaining - 14, 0),1) AS days_to_normal,
    COALESCE(m.purchase_usage_ratio_30d,0) AS purchase_usage_ratio_30d,
    CASE
        WHEN l.days_remaining >= 30 THEN 'Sangat Berlebih'
        WHEN l.days_remaining >= 21 THEN 'Berlebih Tinggi'
        ELSE 'Berlebih'
    END AS overstock_status,
    CASE
        WHEN l.days_remaining >= 30 THEN 'Tahan PO dan cari transfer/push menu'
        WHEN l.days_remaining >= 21 THEN 'Tahan pembelian sampai coverage turun'
        ELSE 'Pantau jadwal pembelian berikutnya'
    END AS recommended_action
FROM latest l
LEFT JOIN movement m ON l.branch_name = m.branch_name AND l.item_name = m.item_name
WHERE l.stock_status = 'overstock' OR l.days_remaining > 14
ORDER BY estimated_idle_value DESC, l.days_remaining DESC
) AS inv_index_a_latest_overstock
    WHERE days_remaining > 14
)
SELECT
    low.item_name,
    low.category,
    low.branch_name AS branch_need,
    low.days_remaining AS need_days,
    over.branch_name AS branch_source,
    over.days_remaining AS source_days,
    over.stock_on_hand AS source_stock,
    over.stock_value AS source_stock_value
FROM low
JOIN over ON low.item_name = over.item_name AND low.branch_name <> over.branch_name
ORDER BY low.days_remaining ASC, over.stock_value DESC
),
dummy AS (
    SELECT 
        CAST(NULL AS VARCHAR) AS item_name,
        CAST(NULL AS VARCHAR) AS category,
        CAST(NULL AS VARCHAR) AS branch_need,
        CAST(NULL AS DECIMAL(18,2)) AS need_days,
        CAST(NULL AS VARCHAR) AS branch_source,
        CAST(NULL AS DECIMAL(18,2)) AS source_days,
        CAST(NULL AS DECIMAL(18,2)) AS source_stock,
        CAST(NULL AS DOUBLE) AS source_stock_value
    WHERE NOT EXISTS (SELECT 1 FROM base)
)
SELECT * FROM base
UNION ALL
SELECT * FROM dummy
