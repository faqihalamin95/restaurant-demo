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
