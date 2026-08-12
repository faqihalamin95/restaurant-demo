WITH detail AS (
    SELECT * FROM (
WITH max_d AS (SELECT MAX(order_date) AS d FROM main_marts.mart_menu_performance),
periods AS (
    SELECT 'y' AS period, d AS start_date, d AS end_date, d - INTERVAL '7 days' AS prev_start, d - INTERVAL '7 days' AS prev_end FROM max_d
    UNION ALL
    SELECT '7d' AS period, d - INTERVAL '6 days' AS start_date, d AS end_date, d - INTERVAL '13 days' AS prev_start, d - INTERVAL '7 days' AS prev_end FROM max_d
    UNION ALL
    SELECT '30d' AS period, d - INTERVAL '29 days' AS start_date, d AS end_date, d - INTERVAL '59 days' AS prev_start, d - INTERVAL '30 days' AS prev_end FROM max_d
),
curr AS (
    SELECT
        p.period,
        mp.branch_name,
        mp.menu_name,
        CASE mp.category WHEN 'main' THEN 'Menu Utama' WHEN 'drink' THEN 'Minuman'
            WHEN 'snack' THEN 'Camilan' WHEN 'dessert' THEN 'Dessert'
            WHEN 'side' THEN 'Pendamping' ELSE mp.category END AS category,
        mp.price_tier,
        SUM(mp.total_qty_sold) AS qty_current,
        SUM(mp.total_revenue) AS revenue_current
    FROM main_marts.mart_menu_performance mp
    JOIN periods p ON mp.order_date BETWEEN p.start_date AND p.end_date
    GROUP BY p.period, mp.branch_name, mp.menu_name, category, mp.price_tier
),
prev AS (
    SELECT
        p.period,
        mp.branch_name,
        mp.menu_name,
        SUM(mp.total_qty_sold) AS qty_previous,
        SUM(mp.total_revenue) AS revenue_previous
    FROM main_marts.mart_menu_performance mp
    JOIN periods p ON mp.order_date BETWEEN p.prev_start AND p.prev_end
    GROUP BY p.period, mp.branch_name, mp.menu_name
)
SELECT
    c.period,
    c.branch_name,
    c.menu_name,
    c.category,
    c.price_tier,
    c.qty_current,
    c.revenue_current,
    ROUND(c.revenue_current / NULLIF(c.qty_current, 0), 0) AS avg_price,
    ROUND(c.revenue_current * 100.0 / NULLIF(SUM(c.revenue_current) OVER (PARTITION BY c.period, c.branch_name), 0), 1) AS revenue_share_pct,
    COALESCE(p.qty_previous, 0) AS qty_previous,
    COALESCE(p.revenue_previous, 0) AS revenue_previous,
    ROUND((c.qty_current - COALESCE(p.qty_previous, 0)) * 100.0 / NULLIF(p.qty_previous, 0), 1) AS pct_change_qty,
    CASE
        WHEN COALESCE(p.qty_previous, 0)=0 AND c.qty_current>0 THEN 'Baru'
        WHEN ROUND((c.qty_current - COALESCE(p.qty_previous, 0)) * 100.0 / NULLIF(p.qty_previous, 0), 1)<=-20 THEN 'Turun'
        WHEN ROUND((c.qty_current - COALESCE(p.qty_previous, 0)) * 100.0 / NULLIF(p.qty_previous, 0), 1)>=20 THEN 'Naik'
        ELSE 'Stabil'
    END AS movement_status
FROM curr c
LEFT JOIN prev p
    ON c.period=p.period
   AND c.branch_name=p.branch_name
   AND c.menu_name=p.menu_name
WHERE c.qty_current > 0
ORDER BY c.period, c.branch_name, c.revenue_current DESC
) AS menu_a_branch_detail
),
branch_ranked AS (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY period, branch_name ORDER BY qty_current DESC, revenue_current DESC) AS rn_qty,
        ROW_NUMBER() OVER (PARTITION BY period, branch_name ORDER BY revenue_current DESC, qty_current DESC) AS rn_rev
    FROM detail
),
branch_rows AS (
    SELECT
        period,
        branch_name,
        SUM(qty_current) AS total_qty,
        SUM(revenue_current) AS total_revenue,
        COUNT(DISTINCT menu_name) AS active_menu_count,
        MAX(CASE WHEN rn_qty=1 THEN menu_name END) AS top_qty_menu,
        MAX(CASE WHEN rn_qty=1 THEN qty_current END) AS top_qty,
        MAX(CASE WHEN rn_rev=1 THEN menu_name END) AS top_revenue_menu,
        MAX(CASE WHEN rn_rev=1 THEN revenue_current END) AS top_revenue
    FROM branch_ranked
    GROUP BY period, branch_name
),
all_menu AS (
    SELECT period, menu_name, MAX(category) AS category,
        SUM(qty_current) AS qty_current,
        SUM(revenue_current) AS revenue_current
    FROM detail
    GROUP BY period, menu_name
),
all_ranked AS (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY period ORDER BY qty_current DESC, revenue_current DESC) AS rn_qty,
        ROW_NUMBER() OVER (PARTITION BY period ORDER BY revenue_current DESC, qty_current DESC) AS rn_rev
    FROM all_menu
),
all_rows AS (
    SELECT
        period,
        'Semua Cabang' AS branch_name,
        SUM(qty_current) AS total_qty,
        SUM(revenue_current) AS total_revenue,
        COUNT(DISTINCT menu_name) AS active_menu_count,
        MAX(CASE WHEN rn_qty=1 THEN menu_name END) AS top_qty_menu,
        MAX(CASE WHEN rn_qty=1 THEN qty_current END) AS top_qty,
        MAX(CASE WHEN rn_rev=1 THEN menu_name END) AS top_revenue_menu,
        MAX(CASE WHEN rn_rev=1 THEN revenue_current END) AS top_revenue
    FROM all_ranked
    GROUP BY period
),
combined AS (
    SELECT * FROM all_rows
    UNION ALL
    SELECT * FROM branch_rows
)
SELECT *,
    CASE
        WHEN top_qty_menu = top_revenue_menu THEN 'Stok: jaga ' || top_qty_menu || '. Kualitas dan availability adalah prioritas utama.'
        ELSE 'Stok: ' || top_qty_menu || '. Upsell: tawarkan ' || top_revenue_menu || ' ke pelanggan yang relevan.'
    END AS recommended_focus
FROM combined
ORDER BY period, branch_name
