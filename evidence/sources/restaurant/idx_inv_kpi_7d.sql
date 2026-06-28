WITH anchor_date AS (SELECT MAX(order_date) AS d FROM main_marts.mart_daily_revenue)
SELECT
    i.total_biaya_bahan,
    ROUND(i.total_biaya_bahan / NULLIF(f.gross_revenue, 0) * 100, 1) AS pct_dari_revenue,
    ROUND(i.total_beli / NULLIF(i.total_pakai, 0), 2)                AS rasio_beli_pakai,
    i.kategori_tertinggi
FROM (
    SELECT
        SUM(usage_cost)    AS total_pakai,
        SUM(purchase_cost) AS total_beli,
        SUM(usage_cost)    AS total_biaya_bahan,
        (SELECT category FROM main_marts.mart_inventory_stok
         WHERE txn_date >= (SELECT d FROM anchor_date) - INTERVAL '6 days'
           AND txn_date <= (SELECT d FROM anchor_date)
         GROUP BY category ORDER BY SUM(usage_cost) DESC LIMIT 1) AS kategori_tertinggi
    FROM main_marts.mart_inventory_stok
    WHERE txn_date >= (SELECT d FROM anchor_date) - INTERVAL '6 days'
      AND txn_date <= (SELECT d FROM anchor_date)
) i
CROSS JOIN (
    SELECT SUM(gross_revenue) AS gross_revenue
    FROM main_marts.mart_daily_net_revenue
    WHERE metric_date >= (SELECT d FROM anchor_date) - INTERVAL '6 days'
      AND metric_date <= (SELECT d FROM anchor_date)
) f
