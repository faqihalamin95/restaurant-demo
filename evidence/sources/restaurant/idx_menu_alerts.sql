SELECT menu_name, ROUND(qty_wow_change * 100, 1) AS pct_change
FROM main_marts.mart_menu_performance
WHERE order_date = (SELECT MAX(order_date) FROM main_marts.mart_menu_performance)
  AND qty_wow_change < -0.20
ORDER BY qty_wow_change ASC LIMIT 3
