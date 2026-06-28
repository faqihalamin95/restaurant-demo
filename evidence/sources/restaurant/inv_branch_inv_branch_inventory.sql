WITH max_d AS (SELECT MAX(txn_date)::DATE AS d FROM main_marts.mart_inventory_stok),
latest AS (
    SELECT *
    FROM main_marts.mart_inventory_stok CROSS JOIN max_d
    WHERE txn_date = d
),
movement AS (
    SELECT
        branch_name,
        SUM(CASE WHEN txn_date >= d - INTERVAL '6 days' THEN usage_cost ELSE 0 END) AS usage_cost_7d,
        SUM(CASE WHEN txn_date >= d - INTERVAL '6 days' THEN purchase_cost ELSE 0 END) AS purchase_cost_7d,
        SUM(CASE WHEN txn_date >= d - INTERVAL '29 days' THEN usage_cost ELSE 0 END) AS usage_cost_30d,
        SUM(CASE WHEN txn_date >= d - INTERVAL '29 days' THEN purchase_cost ELSE 0 END) AS purchase_cost_30d
    FROM main_marts.mart_inventory_stok CROSS JOIN max_d
    GROUP BY 1
)
SELECT
    l.branch_name,
    ROUND(SUM(l.stock_value),0) AS stock_value,
    SUM(CASE WHEN l.stock_status = 'low' OR l.days_remaining < 3 THEN 1 ELSE 0 END) AS low_points,
    SUM(CASE WHEN l.stock_status = 'overstock' OR l.days_remaining > 14 THEN 1 ELSE 0 END) AS overstock_points,
    ROUND(SUM(CASE WHEN l.stock_status = 'overstock' OR l.days_remaining > 14 THEN l.stock_value ELSE 0 END),0) AS overstock_value,
    ROUND(MIN(l.days_remaining),1) AS min_days_remaining,
    m.usage_cost_7d,
    m.purchase_cost_7d,
    m.usage_cost_30d,
    m.purchase_cost_30d,
    ROUND(m.purchase_cost_30d/NULLIF(m.usage_cost_30d,0),2) AS purchase_usage_ratio_30d,
    CASE
        WHEN SUM(CASE WHEN l.stock_status = 'low' OR l.days_remaining < 3 THEN 1 ELSE 0 END) > 0 THEN 'Kritis'
        WHEN SUM(CASE WHEN l.stock_status = 'overstock' OR l.days_remaining > 14 THEN l.stock_value ELSE 0 END)/NULLIF(SUM(l.stock_value),0) > 0.25 THEN 'Waspada'
        WHEN ROUND(m.purchase_cost_30d/NULLIF(m.usage_cost_30d,0),2) > 1.3 THEN 'Waspada'
        ELSE 'Sehat'
    END AS branch_status
FROM latest l
LEFT JOIN movement m ON l.branch_name = m.branch_name
GROUP BY l.branch_name, m.usage_cost_7d, m.purchase_cost_7d, m.usage_cost_30d, m.purchase_cost_30d
ORDER BY
    CASE branch_status WHEN 'Kritis' THEN 1 WHEN 'Waspada' THEN 2 ELSE 3 END,
    overstock_value DESC
