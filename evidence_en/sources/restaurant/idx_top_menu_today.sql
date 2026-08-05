WITH anchor_date AS (SELECT MAX(order_date) AS d FROM main_marts.mart_daily_revenue)
SELECT menu_name FROM main_marts.mart_menu_performance
WHERE order_date = (SELECT d FROM anchor_date)
ORDER BY total_qty_sold DESC LIMIT 1
