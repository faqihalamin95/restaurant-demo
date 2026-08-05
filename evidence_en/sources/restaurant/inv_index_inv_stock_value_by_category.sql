WITH max_d AS (SELECT MAX(txn_date)::DATE AS d FROM main_marts.mart_inventory_stok)
SELECT
    category,
    ROUND(SUM(stock_value),0) AS stock_value,
    ROUND(SUM(CASE WHEN stock_status = 'overstock' OR days_remaining > 14 THEN stock_value ELSE 0 END),0) AS overstock_value,
    SUM(CASE WHEN stock_status = 'low' OR days_remaining < 3 THEN 1 ELSE 0 END) AS low_points,
    ROUND(AVG(days_remaining),1) AS avg_days_remaining
FROM main_marts.mart_inventory_stok CROSS JOIN max_d
WHERE txn_date = d
GROUP BY 1
ORDER BY stock_value DESC
