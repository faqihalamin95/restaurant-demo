SELECT SUM(total_qty_sold) AS total_qty, SUM(total_revenue) AS total_revenue,
    COUNT(DISTINCT menu_name) AS active_menu_count,
    ROUND(SUM(total_revenue)/NULLIF(COUNT(DISTINCT menu_name),0),0) AS avg_revenue_per_menu,
    MAX(CASE WHEN rn_q=1 THEN menu_name END) AS top_volume_menu,
    MAX(CASE WHEN rn_q=1 THEN total_qty_sold END) AS top_volume_qty,
    MAX(CASE WHEN rn_r=1 THEN menu_name END) AS top_revenue_menu,
    MAX(CASE WHEN rn_r=1 THEN total_revenue END) AS top_revenue_value,
    ROUND(SUM(CASE WHEN rn_r<=5 THEN total_revenue ELSE 0 END)*100.0/NULLIF(SUM(total_revenue),0),1) AS top5_revenue_share
FROM (
    SELECT menu_name, SUM(total_qty_sold) AS total_qty_sold, SUM(total_revenue) AS total_revenue,
        ROW_NUMBER() OVER (ORDER BY SUM(total_qty_sold) DESC) AS rn_q,
        ROW_NUMBER() OVER (ORDER BY SUM(total_revenue) DESC) AS rn_r
    FROM main_marts.mart_menu_performance
    WHERE order_date >= (SELECT MAX(order_date) FROM main_marts.mart_menu_performance) - INTERVAL '6 days'
    GROUP BY menu_name HAVING SUM(total_qty_sold)>0
)
