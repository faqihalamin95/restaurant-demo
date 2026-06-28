WITH max_d AS (SELECT MAX(metric_date)::DATE AS d FROM main_marts.mart_daily_net_revenue),
bulan_ini AS (SELECT DATE_TRUNC('month', d) AS awal, d AS akhir FROM max_d),
bulan_lalu AS (
    SELECT DATE_TRUNC('month', d - INTERVAL '1 month') AS awal,
           LAST_DAY(d - INTERVAL '1 month') AS akhir FROM max_d
)
SELECT
    ROUND(SUM(CASE WHEN metric_date >= b.awal AND metric_date <= b.akhir THEN inventory_usage_cost ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= b.awal AND metric_date <= b.akhir THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS bahan_mtd,
    ROUND(SUM(CASE WHEN metric_date >= b.awal AND metric_date <= b.akhir THEN labor_total_cost ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= b.awal AND metric_date <= b.akhir THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS sdm_mtd,
    ROUND(SUM(CASE WHEN metric_date >= b.awal AND metric_date <= b.akhir THEN operational_total_cost ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= b.awal AND metric_date <= b.akhir THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS ops_mtd,
    ROUND(SUM(CASE WHEN metric_date >= l.awal AND metric_date <= l.akhir THEN inventory_usage_cost ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= l.awal AND metric_date <= l.akhir THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS bahan_lalu,
    ROUND(SUM(CASE WHEN metric_date >= l.awal AND metric_date <= l.akhir THEN labor_total_cost ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= l.awal AND metric_date <= l.akhir THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS sdm_lalu,
    ROUND(SUM(CASE WHEN metric_date >= l.awal AND metric_date <= l.akhir THEN operational_total_cost ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= l.awal AND metric_date <= l.akhir THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS ops_lalu,
    ROUND(SUM(CASE WHEN metric_date >= b.awal AND metric_date <= b.akhir THEN inventory_usage_cost ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= b.awal AND metric_date <= b.akhir THEN gross_revenue ELSE 0 END), 0) * 100, 1)
    - ROUND(SUM(CASE WHEN metric_date >= l.awal AND metric_date <= l.akhir THEN inventory_usage_cost ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= l.awal AND metric_date <= l.akhir THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS delta_bahan,
    ROUND(SUM(CASE WHEN metric_date >= b.awal AND metric_date <= b.akhir THEN labor_total_cost ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= b.awal AND metric_date <= b.akhir THEN gross_revenue ELSE 0 END), 0) * 100, 1)
    - ROUND(SUM(CASE WHEN metric_date >= l.awal AND metric_date <= l.akhir THEN labor_total_cost ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= l.awal AND metric_date <= l.akhir THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS delta_sdm,
    ROUND(SUM(CASE WHEN metric_date >= b.awal AND metric_date <= b.akhir THEN operational_total_cost ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= b.awal AND metric_date <= b.akhir THEN gross_revenue ELSE 0 END), 0) * 100, 1)
    - ROUND(SUM(CASE WHEN metric_date >= l.awal AND metric_date <= l.akhir THEN operational_total_cost ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= l.awal AND metric_date <= l.akhir THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS delta_ops
FROM main_marts.mart_daily_net_revenue
CROSS JOIN bulan_ini b
CROSS JOIN bulan_lalu l
