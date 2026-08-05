WITH max_d AS (SELECT MAX(txn_date)::DATE AS d FROM main_marts.mart_inventory_stok)
SELECT
    branch_name,
    category,
    ROUND(SUM(stock_value),0) AS stock_value,
    SUM(CASE WHEN stock_status = 'low' OR days_remaining < 3 THEN 1 ELSE 0 END) AS low_points,
    SUM(CASE WHEN stock_status = 'overstock' OR days_remaining > 14 THEN 1 ELSE 0 END) AS overstock_points,
    ROUND(SUM(CASE WHEN stock_status = 'overstock' OR days_remaining > 14 THEN stock_value ELSE 0 END),0) AS overstock_value,
    ROUND(AVG(days_remaining),1) AS avg_days_remaining
FROM main_marts.mart_inventory_stok CROSS JOIN max_d
WHERE txn_date = d
GROUP BY 1, 2
ORDER BY branch_name, stock_value DESC
