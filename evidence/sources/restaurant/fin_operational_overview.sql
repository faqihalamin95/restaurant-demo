WITH max_d AS (SELECT MAX(metric_date)::DATE AS d FROM main_marts.mart_daily_net_revenue),
mtd AS (
    SELECT
        ROUND(SUM(CASE WHEN metric_date >= DATE_TRUNC('month', d) AND metric_date <= d THEN net_revenue ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= DATE_TRUNC('month', d) AND metric_date <= d THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS margin_mtd,
        ROUND(SUM(CASE WHEN metric_date >= DATE_TRUNC('month', d) AND metric_date <= d THEN inventory_usage_cost ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= DATE_TRUNC('month', d) AND metric_date <= d THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS bahan_mtd,
        ROUND(SUM(CASE WHEN metric_date >= DATE_TRUNC('month', d) AND metric_date <= d THEN labor_total_cost ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= DATE_TRUNC('month', d) AND metric_date <= d THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS sdm_mtd,
        ROUND(SUM(CASE WHEN metric_date >= DATE_TRUNC('month', d) AND metric_date <= d THEN operational_total_cost ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= DATE_TRUNC('month', d) AND metric_date <= d THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS ops_mtd
    FROM main_marts.mart_daily_net_revenue CROSS JOIN max_d
),
rolling AS (
    SELECT
        ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN net_revenue ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS margin_30d,
        ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN inventory_usage_cost ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS bahan_30d,
        ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN labor_total_cost ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS sdm_30d,
        ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN operational_total_cost ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS ops_30d,
        ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN net_revenue ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS margin_90d,
        ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN inventory_usage_cost ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS bahan_90d,
        ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN labor_total_cost ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS sdm_90d,
        ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN operational_total_cost ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS ops_90d
    FROM main_marts.mart_daily_net_revenue CROSS JOIN max_d
)
SELECT
    CASE WHEN m.margin_mtd >= 15 THEN 'Sehat' WHEN m.margin_mtd >= 10 THEN 'Waspada' ELSE 'Kritis' END AS status_mtd,
    CASE
        WHEN m.bahan_mtd <= 32 AND m.sdm_mtd <= 22 AND m.ops_mtd <= 15 THEN 'Semua biaya dalam batas'
        WHEN m.bahan_mtd - 32 >= m.sdm_mtd - 22 AND m.bahan_mtd - 32 >= m.ops_mtd - 15 THEN 'Biaya bahan'
        WHEN m.sdm_mtd - 22 >= m.ops_mtd - 15 THEN 'Biaya SDM'
        ELSE 'Biaya operasional'
    END AS fokus_mtd,
    CASE
        WHEN m.bahan_mtd <= 32 AND m.sdm_mtd <= 22 AND m.ops_mtd <= 15 THEN 0
        WHEN m.bahan_mtd - 32 >= m.sdm_mtd - 22 AND m.bahan_mtd - 32 >= m.ops_mtd - 15 THEN ROUND(m.bahan_mtd - 32, 1)
        WHEN m.sdm_mtd - 22 >= m.ops_mtd - 15 THEN ROUND(m.sdm_mtd - 22, 1)
        ELSE ROUND(m.ops_mtd - 15, 1)
    END AS fokus_gap_mtd,
    CASE WHEN r.margin_30d >= 15 THEN 'Sehat' WHEN r.margin_30d >= 10 THEN 'Waspada' ELSE 'Kritis' END AS status_30d,
    CASE
        WHEN r.bahan_30d <= 32 AND r.sdm_30d <= 22 AND r.ops_30d <= 15 THEN 'Semua biaya dalam batas'
        WHEN r.bahan_30d - 32 >= r.sdm_30d - 22 AND r.bahan_30d - 32 >= r.ops_30d - 15 THEN 'Biaya bahan'
        WHEN r.sdm_30d - 22 >= r.ops_30d - 15 THEN 'Biaya SDM'
        ELSE 'Biaya operasional'
    END AS fokus_30d,
    CASE
        WHEN r.bahan_30d <= 32 AND r.sdm_30d <= 22 AND r.ops_30d <= 15 THEN 0
        WHEN r.bahan_30d - 32 >= r.sdm_30d - 22 AND r.bahan_30d - 32 >= r.ops_30d - 15 THEN ROUND(r.bahan_30d - 32, 1)
        WHEN r.sdm_30d - 22 >= r.ops_30d - 15 THEN ROUND(r.sdm_30d - 22, 1)
        ELSE ROUND(r.ops_30d - 15, 1)
    END AS fokus_gap_30d,
    CASE WHEN r.margin_90d >= 15 THEN 'Sehat' WHEN r.margin_90d >= 10 THEN 'Waspada' ELSE 'Kritis' END AS status_90d,
    CASE
        WHEN r.bahan_90d <= 32 AND r.sdm_90d <= 22 AND r.ops_90d <= 15 THEN 'Semua biaya dalam batas'
        WHEN r.bahan_90d - 32 >= r.sdm_90d - 22 AND r.bahan_90d - 32 >= r.ops_90d - 15 THEN 'Biaya bahan'
        WHEN r.sdm_90d - 22 >= r.ops_90d - 15 THEN 'Biaya SDM'
        ELSE 'Biaya operasional'
    END AS fokus_90d,
    CASE
        WHEN r.bahan_90d <= 32 AND r.sdm_90d <= 22 AND r.ops_90d <= 15 THEN 0
        WHEN r.bahan_90d - 32 >= r.sdm_90d - 22 AND r.bahan_90d - 32 >= r.ops_90d - 15 THEN ROUND(r.bahan_90d - 32, 1)
        WHEN r.sdm_90d - 22 >= r.ops_90d - 15 THEN ROUND(r.sdm_90d - 22, 1)
        ELSE ROUND(r.ops_90d - 15, 1)
    END AS fokus_gap_90d
FROM mtd m
CROSS JOIN rolling r
