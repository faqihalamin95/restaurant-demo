{{ config(materialized='table') }}

WITH detail AS (
    SELECT * FROM {{ ref('mart_menu_branch_detail') }}
),
branch_category AS (
    SELECT
        period,
        branch_name,
        'Kategori' AS mix_type,
        category AS segment,
        COUNT(DISTINCT menu_name) AS total_menu,
        SUM(qty_current) AS total_qty,
        SUM(revenue_current) AS total_revenue,
        ROUND(SUM(revenue_current) / NULLIF(SUM(qty_current), 0), 0) AS avg_price,
        ROUND(SUM(revenue_current) * 100.0 / NULLIF(SUM(SUM(revenue_current)) OVER (PARTITION BY period, branch_name), 0), 1) AS pct_revenue
    FROM detail
    GROUP BY period, branch_name, category
),
branch_tier AS (
    SELECT
        period,
        branch_name,
        'Segmen Harga' AS mix_type,
        COALESCE(price_tier, 'Tanpa Segmen') AS segment,
        COUNT(DISTINCT menu_name) AS total_menu,
        SUM(qty_current) AS total_qty,
        SUM(revenue_current) AS total_revenue,
        ROUND(SUM(revenue_current) / NULLIF(SUM(qty_current), 0), 0) AS avg_price,
        ROUND(SUM(revenue_current) * 100.0 / NULLIF(SUM(SUM(revenue_current)) OVER (PARTITION BY period, branch_name), 0), 1) AS pct_revenue
    FROM detail
    GROUP BY period, branch_name, COALESCE(price_tier, 'Tanpa Segmen')
),
all_category AS (
    SELECT
        period,
        'Semua Cabang' AS branch_name,
        'Kategori' AS mix_type,
        category AS segment,
        COUNT(DISTINCT menu_name) AS total_menu,
        SUM(qty_current) AS total_qty,
        SUM(revenue_current) AS total_revenue,
        ROUND(SUM(revenue_current) / NULLIF(SUM(qty_current), 0), 0) AS avg_price,
        ROUND(SUM(revenue_current) * 100.0 / NULLIF(SUM(SUM(revenue_current)) OVER (PARTITION BY period), 0), 1) AS pct_revenue
    FROM detail
    GROUP BY period, category
),
all_tier AS (
    SELECT
        period,
        'Semua Cabang' AS branch_name,
        'Segmen Harga' AS mix_type,
        COALESCE(price_tier, 'Tanpa Segmen') AS segment,
        COUNT(DISTINCT menu_name) AS total_menu,
        SUM(qty_current) AS total_qty,
        SUM(revenue_current) AS total_revenue,
        ROUND(SUM(revenue_current) / NULLIF(SUM(qty_current), 0), 0) AS avg_price,
        ROUND(SUM(revenue_current) * 100.0 / NULLIF(SUM(SUM(revenue_current)) OVER (PARTITION BY period), 0), 1) AS pct_revenue
    FROM detail
    GROUP BY period, COALESCE(price_tier, 'Tanpa Segmen')
)
SELECT * FROM all_category
UNION ALL SELECT * FROM all_tier
UNION ALL SELECT * FROM branch_category
UNION ALL SELECT * FROM branch_tier
ORDER BY period, branch_name, mix_type, total_revenue DESC