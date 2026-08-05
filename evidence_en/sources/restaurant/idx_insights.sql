WITH base AS (
SELECT branch_name, ROUND(pct_change_vs_sdow_avg * 100, 1) AS pct_change
FROM main_marts.mart_daily_revenue
WHERE order_date = (SELECT MAX(order_date) FROM main_marts.mart_daily_revenue)
  AND pct_change_vs_sdow_avg < -0.15
ORDER BY pct_change_vs_sdow_avg ASC LIMIT 3
),
dummy AS (
    SELECT 
        CAST(NULL AS VARCHAR) AS branch_name,
        CAST(NULL AS DOUBLE) AS pct_change
    WHERE NOT EXISTS (SELECT 1 FROM base)
)
SELECT * FROM base
UNION ALL
SELECT * FROM dummy
