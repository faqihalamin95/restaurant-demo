WITH anchor_date AS (SELECT MAX(order_date) AS d FROM main_marts.mart_daily_revenue)
SELECT menu_name,
    CASE category WHEN 'main' THEN 'Menu Utama' WHEN 'drink' THEN 'Minuman'
        WHEN 'snack' THEN 'Camilan' WHEN 'dessert' THEN 'Dessert' ELSE category END AS category,
    SUM(total_qty_sold) AS total_qty, SUM(total_revenue) AS total_revenue
FROM main_marts.mart_menu_performance
WHERE order_date = (SELECT d FROM anchor_date)
GROUP BY menu_name, category ORDER BY total_qty DESC LIMIT 5
