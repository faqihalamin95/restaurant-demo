WITH anchor_date AS (SELECT MAX(order_date) AS d FROM main_marts.mart_daily_revenue)
SELECT
    ROUND(SUM(CASE WHEN rn = 1 THEN total_revenue END) * 100.0 / NULLIF(SUM(total_revenue), 0), 1) AS kontribusi_pct,
    COUNT(DISTINCT menu_name) AS total_menu,
    COUNT(DISTINCT CASE WHEN hari_aktif >= 4 THEN menu_name END) AS menu_aktif,
    ROUND(COUNT(DISTINCT CASE WHEN hari_aktif >= 4 THEN menu_name END) * 100.0 / NULLIF(COUNT(DISTINCT menu_name), 0), 1) AS pct_menu_aktif,
    COUNT(DISTINCT CASE WHEN hari_aktif >= 4 THEN menu_name END) || ' dari ' || COUNT(DISTINCT menu_name) || ' menu' AS menu_aktif_label
FROM (
    SELECT menu_name,
        SUM(total_revenue) AS total_revenue,
        COUNT(DISTINCT order_date) AS hari_aktif,
        ROW_NUMBER() OVER (ORDER BY SUM(total_revenue) DESC) AS rn
    FROM main_marts.mart_menu_performance
    WHERE order_date >= (SELECT d FROM anchor_date) - INTERVAL '6 days'
      AND order_date <= (SELECT d FROM anchor_date)
    GROUP BY menu_name
)
