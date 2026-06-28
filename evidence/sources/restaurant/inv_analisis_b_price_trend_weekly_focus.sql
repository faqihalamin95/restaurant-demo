WITH max_d AS (SELECT MAX(txn_date)::DATE AS d FROM main_marts.mart_inventory_stok),
top_items AS (
    SELECT item_name
    FROM (
WITH max_d AS (SELECT MAX(txn_date)::DATE AS d FROM main_marts.mart_inventory_stok)
SELECT
    item_name,
    category,
    ROUND(AVG(base_unit_cost),0) AS base_unit_cost,
    ROUND(AVG(avg_unit_cost),0) AS avg_unit_cost,
    ROUND((AVG(avg_unit_cost)-AVG(base_unit_cost))/NULLIF(AVG(base_unit_cost),0)*100,1) AS price_variance_pct,
    SUM(usage_cost) AS usage_cost_30d,
    ROUND(SUM(usage_cost) * GREATEST((AVG(avg_unit_cost)-AVG(base_unit_cost))/NULLIF(AVG(base_unit_cost),0),0),0) AS estimated_price_impact,
    CASE
        WHEN (AVG(avg_unit_cost)-AVG(base_unit_cost))/NULLIF(AVG(base_unit_cost),0)*100 >= 20 THEN 'Kritis'
        ELSE 'Waspada'
    END AS severity
FROM main_marts.mart_inventory_stok CROSS JOIN max_d
WHERE txn_date >= d - INTERVAL '29 days'
GROUP BY 1, 2
    HAVING (AVG(avg_unit_cost)-AVG(base_unit_cost))/NULLIF(AVG(base_unit_cost),0)*100 > 10
ORDER BY estimated_price_impact DESC, price_variance_pct DESC
) AS inv_analisis_a_supplier_alerts
    ORDER BY estimated_price_impact DESC
    LIMIT 5
)
SELECT
    DATE_TRUNC('week', txn_date) AS minggu,
    i.item_name,
    i.category,
    ROUND(AVG(avg_unit_cost),0) AS harga_rata_beli,
    ROUND(AVG(base_unit_cost),0) AS harga_dasar
FROM main_marts.mart_inventory_stok i
CROSS JOIN max_d
INNER JOIN top_items t ON i.item_name = t.item_name
WHERE txn_date >= d - INTERVAL '89 days'
GROUP BY 1, 2, 3
ORDER BY 1, 2
