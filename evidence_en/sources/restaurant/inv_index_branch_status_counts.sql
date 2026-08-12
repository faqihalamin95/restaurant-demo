WITH max_d AS (SELECT MAX(txn_date)::DATE AS d FROM main_marts.mart_inventory_stok),
latest AS (
    SELECT * FROM (
        SELECT *, ROW_NUMBER() OVER(PARTITION BY branch_name, item_name ORDER BY txn_date DESC) as rn
        FROM main_marts.mart_inventory_stok
    ) WHERE rn = 1
),
movement_item AS (
    SELECT branch_name, item_name, ROUND(SUM(usage_qty)/30,2) AS avg_daily_usage
    FROM main_marts.mart_inventory_stok CROSS JOIN max_d
    WHERE txn_date >= d - INTERVAL '29 days'
    GROUP BY 1, 2
),
branch_issues AS (
    SELECT 
        l.branch_name,
        SUM(CASE WHEN COALESCE(l.stock_on_hand / NULLIF(m.avg_daily_usage, 0), l.days_remaining) < 3 THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(l.item_name), 0) AS low_pct,
        SUM(CASE WHEN COALESCE(l.stock_on_hand / NULLIF(m.avg_daily_usage, 0), l.days_remaining) < 2 AND (LOWER(l.item_name) LIKE '%ayam%' OR LOWER(l.item_name) LIKE '%daging%' OR LOWER(l.item_name) LIKE '%beras%' OR LOWER(l.item_name) LIKE '%minyak%' OR LOWER(l.item_name) LIKE '%lpg%') THEN 1 ELSE 0 END) AS core_low_count,
        SUM(CASE WHEN COALESCE(l.stock_on_hand / NULLIF(m.avg_daily_usage, 0), l.days_remaining) > 14 THEN l.stock_value ELSE 0 END) / NULLIF(SUM(l.stock_value), 0) * 100 AS overstock_pct
    FROM latest l
    LEFT JOIN movement_item m ON l.item_name = m.item_name AND l.branch_name = m.branch_name
    GROUP BY 1
),
classified AS (
    SELECT 
        branch_name,
        CASE 
            WHEN COALESCE(core_low_count, 0) > 0 THEN 'Kritis'
            WHEN COALESCE(low_pct, 0) >= 15 THEN 'Kritis'
            WHEN COALESCE(low_pct, 0) > 0 THEN 'Waspada'
            WHEN COALESCE(overstock_pct, 0) > 30 THEN 'Waspada'
            WHEN COALESCE(overstock_pct, 0) > 20 THEN 'Early Warning'
            ELSE 'Sehat'
        END AS health_status
    FROM branch_issues
)
SELECT 
    COUNT(CASE WHEN health_status = 'Sehat' THEN 1 END) AS sehat_count,
    COUNT(CASE WHEN health_status IN ('Waspada', 'Early Warning') THEN 1 END) AS waspada_count,
    COUNT(CASE WHEN health_status = 'Kritis' THEN 1 END) AS kritis_count
FROM classified
