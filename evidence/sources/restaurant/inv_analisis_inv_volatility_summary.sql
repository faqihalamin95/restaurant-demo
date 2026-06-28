WITH max_d AS (SELECT MAX(txn_date)::DATE AS d FROM main_marts.mart_inventory_stok)
SELECT
    item_name,
    category,
    ROUND(MIN(avg_unit_cost),0) AS harga_min,
    ROUND(MAX(avg_unit_cost),0) AS harga_maks,
    ROUND(AVG(avg_unit_cost),0) AS harga_rata,
    ROUND(AVG(base_unit_cost),0) AS harga_dasar,
    ROUND((MAX(avg_unit_cost)-MIN(avg_unit_cost))/NULLIF(MIN(avg_unit_cost),0)*100,1) AS volatilitas_pct,
    ROUND((AVG(avg_unit_cost)-AVG(base_unit_cost))/NULLIF(AVG(base_unit_cost),0)*100,1) AS selisih_vs_dasar_pct,
    CASE
        WHEN ROUND((MAX(avg_unit_cost)-MIN(avg_unit_cost))/NULLIF(MIN(avg_unit_cost),0)*100,1) >= 30 THEN 'Sangat Volatil'
        WHEN ROUND((MAX(avg_unit_cost)-MIN(avg_unit_cost))/NULLIF(MIN(avg_unit_cost),0)*100,1) >= 15 THEN 'Volatil'
        WHEN ROUND((MAX(avg_unit_cost)-MIN(avg_unit_cost))/NULLIF(MIN(avg_unit_cost),0)*100,1) >= 5 THEN 'Moderat'
        ELSE 'Stabil'
    END AS kategori_volatilitas
FROM main_marts.mart_inventory_stok CROSS JOIN max_d
WHERE txn_date >= d - INTERVAL '89 days'
GROUP BY 1, 2
ORDER BY volatilitas_pct DESC
