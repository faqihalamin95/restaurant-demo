WITH order_item_details AS (
  SELECT 
    o.order_id,
    m.menu_name
  FROM main_staging.stg_order_items o
  JOIN main_foundation.dim_menu_items m ON o.menu_id = m.menu_id
),
menu_pairs AS (
  SELECT 
    a.menu_name AS menu_name,
    b.menu_name AS paired_menu,
    a.order_id
  FROM order_item_details a
  JOIN order_item_details b ON a.order_id = b.order_id
  WHERE a.menu_name != b.menu_name
),
pair_counts AS (
  SELECT 
    menu_name,
    paired_menu,
    COUNT(DISTINCT order_id) AS paired_orders
  FROM menu_pairs
  GROUP BY 1, 2
),
target_counts AS (
  SELECT 
    menu_name,
    COUNT(DISTINCT order_id) AS total_orders
  FROM order_item_details
  GROUP BY 1
)
SELECT 
  p.menu_name,
  p.paired_menu,
  (p.paired_orders * 100.0 / NULLIF(t.total_orders, 0)) AS match_pct
FROM pair_counts p
JOIN target_counts t ON p.menu_name = t.menu_name
ORDER BY p.menu_name, match_pct DESC
