SELECT branch_name,
    MAX(CASE WHEN rn_qty=1 THEN menu_name END) AS top_volume_menu,
    MAX(CASE WHEN rn_qty=1 THEN total_qty END)  AS top_volume_qty,
    MAX(CASE WHEN rn_rev=1 THEN menu_name END)  AS top_revenue_menu,
    MAX(CASE WHEN rn_rev=1 THEN total_rev END)  AS top_revenue_value,
    CASE
        WHEN MAX(CASE WHEN rn_qty=1 THEN menu_name END) = MAX(CASE WHEN rn_rev=1 THEN menu_name END)
        THEN 'Stok: jaga ' || MAX(CASE WHEN rn_qty=1 THEN menu_name END) || '. Kualitas adalah prioritas utama.'
        ELSE 'Stok: ' || MAX(CASE WHEN rn_qty=1 THEN menu_name END) || '. Upsell: tawarkan ' || MAX(CASE WHEN rn_rev=1 THEN menu_name END) || ' ke setiap meja.'
    END AS recommended_focus
FROM (
    SELECT branch_name, menu_name,
        SUM(total_qty_sold) AS total_qty, SUM(total_revenue) AS total_rev,
        ROW_NUMBER() OVER (PARTITION BY branch_name ORDER BY SUM(total_qty_sold) DESC) AS rn_qty,
        ROW_NUMBER() OVER (PARTITION BY branch_name ORDER BY SUM(total_revenue) DESC)  AS rn_rev
    FROM main_marts.mart_menu_performance
    WHERE order_date >= (SELECT MAX(order_date) FROM main_marts.mart_menu_performance) - INTERVAL '6 days'
    GROUP BY branch_name, menu_name
)
GROUP BY branch_name ORDER BY branch_name
