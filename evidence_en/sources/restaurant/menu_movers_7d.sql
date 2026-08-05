WITH max_d AS (SELECT MAX(order_date) AS d FROM main_marts.mart_menu_performance),
curr AS (
    SELECT menu_name,
        CASE category WHEN 'main' THEN 'Menu Utama' WHEN 'drink' THEN 'Minuman' WHEN 'snack' THEN 'Camilan' WHEN 'dessert' THEN 'Dessert' WHEN 'side' THEN 'Pendamping' ELSE category END AS category,
        SUM(total_qty_sold) AS qty_current, SUM(total_revenue) AS revenue_current
    FROM main_marts.mart_menu_performance CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '6 days' GROUP BY menu_name, category
),
prev AS (
    SELECT menu_name,
        CASE category WHEN 'main' THEN 'Menu Utama' WHEN 'drink' THEN 'Minuman' WHEN 'snack' THEN 'Camilan' WHEN 'dessert' THEN 'Dessert' WHEN 'side' THEN 'Pendamping' ELSE category END AS category,
        SUM(total_qty_sold) AS qty_previous, SUM(total_revenue) AS revenue_previous
    FROM main_marts.mart_menu_performance CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '13 days' AND order_date < d - INTERVAL '6 days' GROUP BY menu_name, category
)
SELECT COALESCE(c.menu_name,p.menu_name) AS menu_name, COALESCE(c.category,p.category) AS category,
    COALESCE(c.qty_current,0) AS qty_current, COALESCE(p.qty_previous,0) AS qty_previous,
    ROUND((COALESCE(c.qty_current,0)-COALESCE(p.qty_previous,0))*100.0/NULLIF(p.qty_previous,0),1) AS pct_change_qty,
    COALESCE(c.revenue_current,0) AS revenue_current,
    ROUND((COALESCE(c.revenue_current,0)-COALESCE(p.revenue_previous,0))*100.0/NULLIF(p.revenue_previous,0),1) AS pct_change_revenue,
    CASE
        WHEN COALESCE(p.qty_previous,0)=0 AND COALESCE(c.qty_current,0)>0 THEN 'Baru'
        WHEN COALESCE(c.qty_current,0)=0 AND COALESCE(p.qty_previous,0)>0 THEN 'Tidak Aktif'
        WHEN ROUND((COALESCE(c.qty_current,0)-COALESCE(p.qty_previous,0))*100.0/NULLIF(p.qty_previous,0),1)<=-20 THEN 'Turun'
        WHEN ROUND((COALESCE(c.qty_current,0)-COALESCE(p.qty_previous,0))*100.0/NULLIF(p.qty_previous,0),1)>=20  THEN 'Naik'
        ELSE 'Stabil'
    END AS movement_status
FROM curr c FULL OUTER JOIN prev p ON c.menu_name=p.menu_name ORDER BY pct_change_qty ASC NULLS FIRST
