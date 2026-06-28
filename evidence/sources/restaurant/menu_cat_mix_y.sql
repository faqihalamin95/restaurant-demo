SELECT
    CASE category WHEN 'main' THEN 'Menu Utama' WHEN 'drink' THEN 'Minuman' WHEN 'snack' THEN 'Camilan' WHEN 'dessert' THEN 'Dessert' WHEN 'side' THEN 'Pendamping' ELSE category END AS category,
    COUNT(DISTINCT menu_name) AS total_menu, SUM(total_qty_sold) AS total_qty, SUM(total_revenue) AS total_revenue,
    ROUND(SUM(total_revenue)/NULLIF(SUM(total_qty_sold),0),0) AS avg_price_realisasi,
    ROUND(SUM(total_revenue)/NULLIF(SUM(SUM(total_revenue)) OVER (),0)*100,1) AS pct_revenue
FROM main_marts.mart_menu_performance
WHERE order_date = (SELECT MAX(order_date) FROM main_marts.mart_menu_performance)
GROUP BY category ORDER BY total_revenue DESC
