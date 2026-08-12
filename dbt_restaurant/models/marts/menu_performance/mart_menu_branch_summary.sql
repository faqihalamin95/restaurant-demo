{{ config(materialized='table') }}

WITH detail AS (
    SELECT * FROM {{ ref('mart_menu_branch_detail') }}
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