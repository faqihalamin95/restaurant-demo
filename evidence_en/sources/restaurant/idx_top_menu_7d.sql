SELECT menu_name FROM main_marts.mart_menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM main_marts.mart_menu_performance) - INTERVAL '6 days'
GROUP BY menu_name ORDER BY SUM(total_qty_sold) DESC LIMIT 1
