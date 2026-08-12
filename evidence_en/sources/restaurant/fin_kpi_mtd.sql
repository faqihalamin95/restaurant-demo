WITH max_d AS (SELECT MAX(metric_date)::DATE AS d FROM main_marts.mart_daily_net_revenue),
bulan_ini AS (
    SELECT DATE_TRUNC('month', d) AS bln_awal, d AS bln_akhir FROM max_d
),
bulan_lalu AS (
    SELECT
        DATE_TRUNC('month', d - INTERVAL '1 month') AS bln_awal,
        LAST_DAY(d - INTERVAL '1 month') AS bln_akhir
    FROM max_d
)
SELECT
    SUM(CASE WHEN metric_date >= b.bln_awal AND metric_date <= b.bln_akhir THEN gross_revenue ELSE 0 END) AS gross_mtd,
    SUM(CASE WHEN metric_date >= b.bln_awal AND metric_date <= b.bln_akhir THEN net_revenue ELSE 0 END) AS net_mtd,
    ROUND(
        SUM(CASE WHEN metric_date >= b.bln_awal AND metric_date <= b.bln_akhir THEN net_revenue ELSE 0 END)
        / NULLIF(SUM(CASE WHEN metric_date >= b.bln_awal AND metric_date <= b.bln_akhir THEN gross_revenue ELSE 0 END), 0) * 100
    , 1) AS margin_mtd,
    SUM(CASE WHEN metric_date >= b.bln_awal AND metric_date <= b.bln_akhir THEN inventory_usage_cost + labor_total_cost + operational_total_cost ELSE 0 END) AS biaya_mtd,
    ANY_VALUE(DAY(b.bln_akhir)) AS hari_berjalan,
    ANY_VALUE(DAY(LAST_DAY(b.bln_akhir))) AS total_hari_bulan,
    
    SUM(CASE WHEN metric_date >= l.bln_awal AND metric_date <= l.bln_akhir THEN gross_revenue ELSE 0 END) AS gross_bulan_lalu,
    SUM(CASE WHEN metric_date >= l.bln_awal AND metric_date <= l.bln_akhir THEN net_revenue ELSE 0 END) AS net_bulan_lalu,
    ROUND(
        SUM(CASE WHEN metric_date >= l.bln_awal AND metric_date <= l.bln_akhir THEN net_revenue ELSE 0 END)
        / NULLIF(SUM(CASE WHEN metric_date >= l.bln_awal AND metric_date <= l.bln_akhir THEN gross_revenue ELSE 0 END), 0) * 100
    , 1) AS margin_bulan_lalu,
    SUM(CASE WHEN metric_date >= l.bln_awal AND metric_date <= l.bln_akhir THEN inventory_usage_cost + labor_total_cost + operational_total_cost ELSE 0 END) AS biaya_bulan_lalu,
    
    ROUND(
        (SUM(CASE WHEN metric_date >= b.bln_awal AND metric_date <= b.bln_akhir THEN gross_revenue ELSE 0 END) - SUM(CASE WHEN metric_date >= l.bln_awal AND metric_date <= l.bln_akhir THEN gross_revenue ELSE 0 END))
        / NULLIF(SUM(CASE WHEN metric_date >= l.bln_awal AND metric_date <= l.bln_akhir THEN gross_revenue ELSE 0 END), 0) * 100
    , 1) AS pct_change_gross_mtd,
    ROUND(
        (SUM(CASE WHEN metric_date >= b.bln_awal AND metric_date <= b.bln_akhir THEN net_revenue ELSE 0 END) - SUM(CASE WHEN metric_date >= l.bln_awal AND metric_date <= l.bln_akhir THEN net_revenue ELSE 0 END))
        / NULLIF(SUM(CASE WHEN metric_date >= l.bln_awal AND metric_date <= l.bln_akhir THEN net_revenue ELSE 0 END), 0) * 100
    , 1) AS pct_change_net_mtd,
    ROUND(
        (SUM(CASE WHEN metric_date >= b.bln_awal AND metric_date <= b.bln_akhir THEN inventory_usage_cost + labor_total_cost + operational_total_cost ELSE 0 END) - SUM(CASE WHEN metric_date >= l.bln_awal AND metric_date <= l.bln_akhir THEN inventory_usage_cost + labor_total_cost + operational_total_cost ELSE 0 END))
        / NULLIF(SUM(CASE WHEN metric_date >= l.bln_awal AND metric_date <= l.bln_akhir THEN inventory_usage_cost + labor_total_cost + operational_total_cost ELSE 0 END), 0) * 100
    , 1) AS pct_change_biaya_mtd,

    ROUND(
        SUM(CASE WHEN metric_date >= b.bln_awal AND metric_date <= b.bln_akhir THEN gross_revenue ELSE 0 END)
        / NULLIF(ANY_VALUE(DAY(b.bln_akhir)), 0) * ANY_VALUE(DAY(LAST_DAY(b.bln_akhir)))
    , 0) AS proyeksi_gross,
    ROUND(
        SUM(CASE WHEN metric_date >= b.bln_awal AND metric_date <= b.bln_akhir THEN net_revenue ELSE 0 END)
        / NULLIF(ANY_VALUE(DAY(b.bln_akhir)), 0) * ANY_VALUE(DAY(LAST_DAY(b.bln_akhir)))
    , 0) AS proyeksi_net
FROM main_marts.mart_daily_net_revenue
CROSS JOIN bulan_ini b
CROSS JOIN bulan_lalu l
