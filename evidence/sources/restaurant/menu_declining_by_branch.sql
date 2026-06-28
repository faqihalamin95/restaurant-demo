SELECT branch_name, menu_name,
    SUM(CASE WHEN order_date < (SELECT MAX(order_date) FROM main_marts.mart_menu_performance) - INTERVAL '59 days'  THEN total_qty_sold ELSE 0 END) AS qty_30_awal,
    SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM main_marts.mart_menu_performance) - INTERVAL '29 days' THEN total_qty_sold ELSE 0 END) AS qty_30_akhir,
    ROUND(
        (SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM main_marts.mart_menu_performance) - INTERVAL '29 days' THEN total_qty_sold ELSE 0 END)
        - SUM(CASE WHEN order_date < (SELECT MAX(order_date) FROM main_marts.mart_menu_performance) - INTERVAL '59 days'  THEN total_qty_sold ELSE 0 END))
        / NULLIF(SUM(CASE WHEN order_date < (SELECT MAX(order_date) FROM main_marts.mart_menu_performance) - INTERVAL '59 days' THEN total_qty_sold ELSE 0 END),0) * 100
    ,1) AS pct_change
FROM main_marts.mart_menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM main_marts.mart_menu_performance) - INTERVAL '89 days'
GROUP BY branch_name, menu_name HAVING pct_change < 0 ORDER BY pct_change ASC
