WITH max_d AS (SELECT MAX(txn_date)::DATE AS d FROM main_marts.mart_inventory_stok),
movement AS (
    SELECT
        branch_name,
        item_name,
        ROUND(SUM(usage_qty)/30,2) AS avg_daily_usage,
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
    l.stock_status,
    COALESCE(m.avg_daily_usage,0) AS avg_daily_usage,
    COALESCE(m.usage_cost_30d,0) AS usage_cost_30d,
    COALESCE(m.purchase_cost_30d,0) AS purchase_cost_30d,
    COALESCE(m.purchase_usage_ratio_30d,0) AS purchase_usage_ratio_30d,
    CASE
        WHEN l.stock_status = 'low' OR l.days_remaining < 3 THEN 'Low Stock'
        WHEN l.stock_status = 'overstock' OR l.days_remaining > 14 THEN 'Overstock'
        ELSE 'Normal'
    END AS item_status
FROM latest l
LEFT JOIN movement m ON l.branch_name = m.branch_name AND l.item_name = m.item_name
ORDER BY
    CASE
        WHEN l.stock_status = 'low' OR l.days_remaining < 3 THEN 1
        WHEN l.stock_status = 'overstock' OR l.days_remaining > 14 THEN 2
        ELSE 3
    END,
    l.days_remaining ASC,
    l.stock_value DESC
