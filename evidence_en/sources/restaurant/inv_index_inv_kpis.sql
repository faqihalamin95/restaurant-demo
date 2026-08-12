SELECT
    'yesterday' AS period,
    ROUND(i.total_biaya_bahan / NULLIF(f.gross_revenue, 0) * 100, 1) AS pct_dari_revenue,
    ROUND(i.total_beli / NULLIF(i.total_pakai, 0), 2)                AS rasio_beli_pakai,
    i.kategori_tertinggi
FROM (
    SELECT
        SUM(usage_cost)    AS total_pakai,
        SUM(purchase_cost) AS total_beli,
        SUM(usage_cost)    AS total_biaya_bahan,
        (SELECT category FROM main_marts.mart_inventory_stok
         WHERE txn_date = (SELECT MAX(txn_date) FROM main_marts.mart_inventory_stok)
         GROUP BY category ORDER BY SUM(usage_cost) DESC LIMIT 1) AS kategori_tertinggi
    FROM main_marts.mart_inventory_stok
    WHERE txn_date = (SELECT MAX(txn_date) FROM main_marts.mart_inventory_stok)
) i
CROSS JOIN (
    SELECT SUM(gross_revenue) AS gross_revenue
    FROM main_marts.mart_daily_net_revenue
    WHERE metric_date = (SELECT MAX(metric_date) FROM main_marts.mart_daily_net_revenue)
) f
UNION ALL
SELECT
    '7d' AS period,
    ROUND(i.total_biaya_bahan / NULLIF(f.gross_revenue, 0) * 100, 1) AS pct_dari_revenue,
    ROUND(i.total_beli / NULLIF(i.total_pakai, 0), 2)                AS rasio_beli_pakai,
    i.kategori_tertinggi
FROM (
    SELECT
        SUM(usage_cost)    AS total_pakai,
        SUM(purchase_cost) AS total_beli,
        SUM(usage_cost)    AS total_biaya_bahan,
        (SELECT category FROM main_marts.mart_inventory_stok
         WHERE txn_date >= (SELECT MAX(txn_date) FROM main_marts.mart_inventory_stok) - INTERVAL '6 days'
         GROUP BY category ORDER BY SUM(usage_cost) DESC LIMIT 1) AS kategori_tertinggi
    FROM main_marts.mart_inventory_stok
    WHERE txn_date >= (SELECT MAX(txn_date) FROM main_marts.mart_inventory_stok) - INTERVAL '6 days'
) i
CROSS JOIN (
    SELECT SUM(gross_revenue) AS gross_revenue
    FROM main_marts.mart_daily_net_revenue
    WHERE metric_date >= (SELECT MAX(metric_date) FROM main_marts.mart_daily_net_revenue) - INTERVAL '6 days'
) f
UNION ALL
SELECT
    '30d' AS period,
    ROUND(i.total_biaya_bahan / NULLIF(f.gross_revenue, 0) * 100, 1) AS pct_dari_revenue,
    ROUND(i.total_beli / NULLIF(i.total_pakai, 0), 2)                AS rasio_beli_pakai,
    i.kategori_tertinggi
FROM (
    SELECT
        SUM(usage_cost)    AS total_pakai,
        SUM(purchase_cost) AS total_beli,
        SUM(usage_cost)    AS total_biaya_bahan,
        (SELECT category FROM main_marts.mart_inventory_stok
         WHERE txn_date >= (SELECT MAX(txn_date) FROM main_marts.mart_inventory_stok) - INTERVAL '29 days'
         GROUP BY category ORDER BY SUM(usage_cost) DESC LIMIT 1) AS kategori_tertinggi
    FROM main_marts.mart_inventory_stok
    WHERE txn_date >= (SELECT MAX(txn_date) FROM main_marts.mart_inventory_stok) - INTERVAL '29 days'
) i
CROSS JOIN (
    SELECT SUM(gross_revenue) AS gross_revenue
    FROM main_marts.mart_daily_net_revenue
    WHERE metric_date >= (SELECT MAX(metric_date) FROM main_marts.mart_daily_net_revenue) - INTERVAL '29 days'
) f
