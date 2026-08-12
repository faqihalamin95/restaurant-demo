SELECT menu_name,
    CASE category WHEN 'main' THEN 'Menu Utama' WHEN 'drink' THEN 'Minuman' WHEN 'snack' THEN 'Camilan' WHEN 'dessert' THEN 'Dessert' WHEN 'side' THEN 'Pendamping' ELSE category END AS category,
    SUM(total_qty_sold) AS total_qty
FROM main_marts.mart_menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM main_marts.mart_menu_performance) - INTERVAL '6 days'
GROUP BY menu_name, category ORDER BY total_qty DESC LIMIT 5
