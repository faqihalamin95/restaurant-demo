WITH max_d AS (SELECT MAX(order_date) AS d FROM main_marts.mart_menu_performance),
periods AS (
    SELECT '7d' AS period, d - INTERVAL '6 days' AS start_date, d AS end_date, d - INTERVAL '13 days' AS prev_start, d - INTERVAL '7 days' AS prev_end FROM max_d
    UNION ALL
    SELECT '30d' AS period, d - INTERVAL '29 days' AS start_date, d AS end_date, d - INTERVAL '59 days' AS prev_start, d - INTERVAL '30 days' AS prev_end FROM max_d
),
source_rows AS (
    SELECT order_date, branch_name, menu_name,
        CASE category WHEN 'main' THEN 'Menu Utama' WHEN 'drink' THEN 'Minuman'
            WHEN 'snack' THEN 'Camilan' WHEN 'dessert' THEN 'Dessert'
            WHEN 'side' THEN 'Pendamping' ELSE category END AS category,
        total_qty_sold,
        total_revenue
    FROM main_marts.mart_menu_performance
    UNION ALL
    SELECT order_date, 'Semua Cabang' AS branch_name, menu_name,
        CASE category WHEN 'main' THEN 'Menu Utama' WHEN 'drink' THEN 'Minuman'
            WHEN 'snack' THEN 'Camilan' WHEN 'dessert' THEN 'Dessert'
            WHEN 'side' THEN 'Pendamping' ELSE category END AS category,
        total_qty_sold,
        total_revenue
    FROM main_marts.mart_menu_performance
),
curr AS (
    SELECT p.period, s.branch_name, s.menu_name, MAX(s.category) AS category,
        SUM(s.total_qty_sold) AS qty_current,
        SUM(s.total_revenue) AS revenue_current
    FROM source_rows s
    JOIN periods p ON s.order_date BETWEEN p.start_date AND p.end_date
    GROUP BY p.period, s.branch_name, s.menu_name
),
prev AS (
    SELECT p.period, s.branch_name, s.menu_name, MAX(s.category) AS category,
        SUM(s.total_qty_sold) AS qty_previous,
        SUM(s.total_revenue) AS revenue_previous
    FROM source_rows s
    JOIN periods p ON s.order_date BETWEEN p.prev_start AND p.prev_end
    GROUP BY p.period, s.branch_name, s.menu_name
)
SELECT
    COALESCE(c.period, p.period) AS period,
    COALESCE(c.branch_name, p.branch_name) AS branch_name,
    COALESCE(c.menu_name, p.menu_name) AS menu_name,
    COALESCE(c.category, p.category) AS category,
    COALESCE(c.qty_current, 0) AS qty_current,
    COALESCE(p.qty_previous, 0) AS qty_previous,
    ROUND((COALESCE(c.qty_current, 0) - COALESCE(p.qty_previous, 0)) * 100.0 / NULLIF(p.qty_previous, 0), 1) AS pct_change_qty,
    COALESCE(c.revenue_current, 0) AS revenue_current,
    COALESCE(p.revenue_previous, 0) AS revenue_previous,
    ROUND((COALESCE(c.revenue_current, 0) - COALESCE(p.revenue_previous, 0)) * 100.0 / NULLIF(p.revenue_previous, 0), 1) AS pct_change_revenue,
    CASE
        WHEN COALESCE(p.qty_previous, 0)=0 AND COALESCE(c.qty_current, 0)>0 THEN 'Baru'
        WHEN COALESCE(c.qty_current, 0)=0 AND COALESCE(p.qty_previous, 0)>0 THEN 'Tidak Aktif'
        WHEN ROUND((COALESCE(c.qty_current, 0) - COALESCE(p.qty_previous, 0)) * 100.0 / NULLIF(p.qty_previous, 0), 1)<=-20 THEN 'Turun'
        WHEN ROUND((COALESCE(c.qty_current, 0) - COALESCE(p.qty_previous, 0)) * 100.0 / NULLIF(p.qty_previous, 0), 1)>=20 THEN 'Naik'
        ELSE 'Stabil'
    END AS movement_status
FROM curr c
FULL OUTER JOIN prev p
    ON c.period=p.period
   AND c.branch_name=p.branch_name
   AND c.menu_name=p.menu_name
ORDER BY period, branch_name, pct_change_qty ASC NULLS FIRST
