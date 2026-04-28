---
title: Laporan Keuangan
---

<style>
details {
  border: 1px solid rgba(128,128,128,0.2);
  border-radius: 8px;
  margin: 10px 0;
  overflow: hidden;
}
details > summary {
  padding: 14px 16px;
  cursor: pointer;
  background: rgba(128,128,128,0.04);
  font-weight: 600;
  list-style: none;
  display: flex;
  align-items: center;
  gap: 8px;
}
details > summary::-webkit-details-marker { display: none; }
details[open] > summary { border-bottom: 1px solid rgba(128,128,128,0.15); }
.acc-body { padding: 16px; font-size: 0.9em; line-height: 1.7; }

/* Cost card progress bar */
.cost-bar-wrap {
  height: 7px;
  background: rgba(0,0,0,0.07);
  border-radius: 4px;
  overflow: hidden;
  position: relative;
  margin: 6px 0 2px;
}
.cost-bar-fill {
  height: 100%;
  border-radius: 4px;
  transition: width 0.8s ease;
}
.cost-bar-target {
  position: absolute;
  top: 0;
  bottom: 0;
  width: 2px;
  background: rgba(0,0,0,0.25);
}
</style>

```sql fin_dates
SELECT
    strftime('%d %b %Y', MAX(metric_date))                      AS tgl_akhir,
    strftime('%d %b %Y', MAX(metric_date) - INTERVAL '6 days')  AS tgl_7d_awal,
    strftime('%d %b %Y', MAX(metric_date) - INTERVAL '29 days') AS tgl_30d_awal,
    strftime('%d %b %Y', MAX(metric_date) - INTERVAL '89 days') AS tgl_90d_awal,
    DAY(MAX(metric_date)) || ' ' ||
    CASE MONTH(MAX(metric_date))
        WHEN 1 THEN 'Januari' WHEN 2 THEN 'Februari' WHEN 3 THEN 'Maret'
        WHEN 4 THEN 'April'   WHEN 5 THEN 'Mei'      WHEN 6 THEN 'Juni'
        WHEN 7 THEN 'Juli'    WHEN 8 THEN 'Agustus'  WHEN 9 THEN 'September'
        WHEN 10 THEN 'Oktober' WHEN 11 THEN 'November' WHEN 12 THEN 'Desember'
    END || ' ' || YEAR(MAX(metric_date))                        AS tgl_display,
    CASE DAYNAME(MAX(metric_date))
        WHEN 'Monday' THEN 'Senin' WHEN 'Tuesday' THEN 'Selasa'
        WHEN 'Wednesday' THEN 'Rabu' WHEN 'Thursday' THEN 'Kamis'
        WHEN 'Friday' THEN 'Jumat' WHEN 'Saturday' THEN 'Sabtu'
        WHEN 'Sunday' THEN 'Minggu'
    END                                                         AS nama_hari
FROM restaurant.daily_net_revenue
```

```sql fin_kpi
WITH max_d AS (SELECT MAX(metric_date)::DATE AS d FROM restaurant.daily_net_revenue)
SELECT
    SUM(CASE WHEN metric_date = d THEN gross_revenue ELSE 0 END)                                    AS gross_yesterday,
    SUM(CASE WHEN metric_date = d THEN net_revenue ELSE 0 END)                                      AS net_yesterday,
    ROUND(SUM(CASE WHEN metric_date = d THEN net_revenue ELSE 0 END)
        / NULLIF(SUM(CASE WHEN metric_date = d THEN gross_revenue ELSE 0 END), 0) * 100, 1)        AS margin_yesterday,
    SUM(CASE WHEN metric_date = d
        THEN inventory_usage_cost + labor_total_cost + operational_total_cost ELSE 0 END)           AS biaya_yesterday,
    AVG(CASE WHEN metric_date < d AND DAYOFWEEK(metric_date) = DAYOFWEEK(d)
             AND metric_date >= d - INTERVAL '30 days' THEN gross_revenue END)                      AS gross_sdow,
    ROUND(AVG(CASE WHEN metric_date < d AND DAYOFWEEK(metric_date) = DAYOFWEEK(d)
             AND metric_date >= d - INTERVAL '30 days' THEN net_revenue END)
        / NULLIF(AVG(CASE WHEN metric_date < d AND DAYOFWEEK(metric_date) = DAYOFWEEK(d)
             AND metric_date >= d - INTERVAL '30 days' THEN gross_revenue END), 0) * 100, 1)       AS margin_sdow,
    SUM(CASE WHEN metric_date >= d - INTERVAL '6 days' THEN gross_revenue ELSE 0 END)              AS gross_7d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '6 days' THEN net_revenue ELSE 0 END)                AS net_7d,
    ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '6 days' THEN net_revenue ELSE 0 END)
        / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '6 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS margin_7d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '6 days'
        THEN inventory_usage_cost + labor_total_cost + operational_total_cost ELSE 0 END)           AS biaya_7d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '13 days' AND metric_date < d - INTERVAL '6 days'
        THEN gross_revenue ELSE 0 END)                                                              AS gross_prev7d,
    ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '13 days' AND metric_date < d - INTERVAL '6 days' THEN net_revenue ELSE 0 END)
        / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '13 days' AND metric_date < d - INTERVAL '6 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS margin_prev7d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '13 days' AND metric_date < d - INTERVAL '6 days'
        THEN inventory_usage_cost + labor_total_cost + operational_total_cost ELSE 0 END)           AS biaya_prev7d,
    ROUND(
        ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '6 days' THEN net_revenue ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '6 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1)
        - ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '13 days' AND metric_date < d - INTERVAL '6 days' THEN net_revenue ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '13 days' AND metric_date < d - INTERVAL '6 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1)
    , 1)                                                                                            AS delta_margin_7d,
    ROUND((SUM(CASE WHEN metric_date >= d - INTERVAL '6 days' THEN gross_revenue ELSE 0 END)
        - SUM(CASE WHEN metric_date >= d - INTERVAL '13 days' AND metric_date < d - INTERVAL '6 days' THEN gross_revenue ELSE 0 END))
        / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '13 days' AND metric_date < d - INTERVAL '6 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS pct_change_gross_7d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN gross_revenue ELSE 0 END)             AS gross_30d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN net_revenue ELSE 0 END)               AS net_30d,
    ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN net_revenue ELSE 0 END)
        / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS margin_30d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '29 days'
        THEN inventory_usage_cost + labor_total_cost + operational_total_cost ELSE 0 END)           AS biaya_30d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '59 days' AND metric_date < d - INTERVAL '29 days'
        THEN gross_revenue ELSE 0 END)                                                              AS gross_prev30d,
    ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '59 days' AND metric_date < d - INTERVAL '29 days' THEN net_revenue ELSE 0 END)
        / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '59 days' AND metric_date < d - INTERVAL '29 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS margin_prev30d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '59 days' AND metric_date < d - INTERVAL '29 days'
        THEN inventory_usage_cost + labor_total_cost + operational_total_cost ELSE 0 END)           AS biaya_prev30d,
    ROUND(
        ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN net_revenue ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1)
        - ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '59 days' AND metric_date < d - INTERVAL '29 days' THEN net_revenue ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '59 days' AND metric_date < d - INTERVAL '29 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1)
    , 1)                                                                                            AS delta_margin_30d,
    ROUND((SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN gross_revenue ELSE 0 END)
        - SUM(CASE WHEN metric_date >= d - INTERVAL '59 days' AND metric_date < d - INTERVAL '29 days' THEN gross_revenue ELSE 0 END))
        / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '59 days' AND metric_date < d - INTERVAL '29 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS pct_change_gross_30d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN gross_revenue ELSE 0 END)             AS gross_90d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN net_revenue ELSE 0 END)               AS net_90d,
    ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN net_revenue ELSE 0 END)
        / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS margin_90d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '89 days'
        THEN inventory_usage_cost + labor_total_cost + operational_total_cost ELSE 0 END)           AS biaya_90d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '179 days' AND metric_date < d - INTERVAL '89 days'
        THEN gross_revenue ELSE 0 END)                                                              AS gross_prev90d,
    ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '179 days' AND metric_date < d - INTERVAL '89 days' THEN net_revenue ELSE 0 END)
        / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '179 days' AND metric_date < d - INTERVAL '89 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS margin_prev90d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '179 days' AND metric_date < d - INTERVAL '89 days'
        THEN inventory_usage_cost + labor_total_cost + operational_total_cost ELSE 0 END)           AS biaya_prev90d,
    ROUND(
        ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN net_revenue ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1)
        - ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '179 days' AND metric_date < d - INTERVAL '89 days' THEN net_revenue ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '179 days' AND metric_date < d - INTERVAL '89 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1)
    , 1)                                                                                            AS delta_margin_90d,
    ROUND((SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN gross_revenue ELSE 0 END)
        - SUM(CASE WHEN metric_date >= d - INTERVAL '179 days' AND metric_date < d - INTERVAL '89 days' THEN gross_revenue ELSE 0 END))
        / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '179 days' AND metric_date < d - INTERVAL '89 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS pct_change_gross_90d

FROM restaurant.daily_net_revenue CROSS JOIN max_d
```

```sql fin_cost_pct
WITH max_d AS (SELECT MAX(metric_date)::DATE AS d FROM restaurant.daily_net_revenue),
periods AS (
    SELECT
        d,
        ROUND(SUM(CASE WHEN metric_date = d THEN inventory_usage_cost ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date = d THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS bahan_y,
        ROUND(SUM(CASE WHEN metric_date = d THEN labor_total_cost ELSE 0 END)      / NULLIF(SUM(CASE WHEN metric_date = d THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS sdm_y,
        ROUND(SUM(CASE WHEN metric_date = d THEN operational_total_cost ELSE 0 END)/ NULLIF(SUM(CASE WHEN metric_date = d THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS ops_y,
        ROUND(AVG(CASE WHEN metric_date < d AND DAYOFWEEK(metric_date) = DAYOFWEEK(d) AND metric_date >= d - INTERVAL '30 days' THEN inventory_usage_cost END) / NULLIF(AVG(CASE WHEN metric_date < d AND DAYOFWEEK(metric_date) = DAYOFWEEK(d) AND metric_date >= d - INTERVAL '30 days' THEN gross_revenue END), 0) * 100, 1) AS bahan_sdow,
        ROUND(AVG(CASE WHEN metric_date < d AND DAYOFWEEK(metric_date) = DAYOFWEEK(d) AND metric_date >= d - INTERVAL '30 days' THEN labor_total_cost END)      / NULLIF(AVG(CASE WHEN metric_date < d AND DAYOFWEEK(metric_date) = DAYOFWEEK(d) AND metric_date >= d - INTERVAL '30 days' THEN gross_revenue END), 0) * 100, 1) AS sdm_sdow,
        ROUND(AVG(CASE WHEN metric_date < d AND DAYOFWEEK(metric_date) = DAYOFWEEK(d) AND metric_date >= d - INTERVAL '30 days' THEN operational_total_cost END) / NULLIF(AVG(CASE WHEN metric_date < d AND DAYOFWEEK(metric_date) = DAYOFWEEK(d) AND metric_date >= d - INTERVAL '30 days' THEN gross_revenue END), 0) * 100, 1) AS ops_sdow,
        ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '6 days' THEN inventory_usage_cost ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '6 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS bahan_7d,
        ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '6 days' THEN labor_total_cost ELSE 0 END)      / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '6 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS sdm_7d,
        ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '6 days' THEN operational_total_cost ELSE 0 END)/ NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '6 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS ops_7d,
        ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '13 days' AND metric_date < d - INTERVAL '6 days' THEN inventory_usage_cost ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '13 days' AND metric_date < d - INTERVAL '6 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS bahan_p7d,
        ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '13 days' AND metric_date < d - INTERVAL '6 days' THEN labor_total_cost ELSE 0 END)      / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '13 days' AND metric_date < d - INTERVAL '6 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS sdm_p7d,
        ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '13 days' AND metric_date < d - INTERVAL '6 days' THEN operational_total_cost ELSE 0 END)/ NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '13 days' AND metric_date < d - INTERVAL '6 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS ops_p7d,
        ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN inventory_usage_cost ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS bahan_30d,
        ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN labor_total_cost ELSE 0 END)      / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS sdm_30d,
        ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN operational_total_cost ELSE 0 END)/ NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS ops_30d,
        ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '59 days' AND metric_date < d - INTERVAL '29 days' THEN inventory_usage_cost ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '59 days' AND metric_date < d - INTERVAL '29 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS bahan_p30d,
        ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '59 days' AND metric_date < d - INTERVAL '29 days' THEN labor_total_cost ELSE 0 END)      / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '59 days' AND metric_date < d - INTERVAL '29 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS sdm_p30d,
        ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '59 days' AND metric_date < d - INTERVAL '29 days' THEN operational_total_cost ELSE 0 END)/ NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '59 days' AND metric_date < d - INTERVAL '29 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS ops_p30d,
        ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN inventory_usage_cost ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS bahan_90d,
        ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN labor_total_cost ELSE 0 END)      / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS sdm_90d,
        ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN operational_total_cost ELSE 0 END)/ NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS ops_90d,
        ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '179 days' AND metric_date < d - INTERVAL '89 days' THEN inventory_usage_cost ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '179 days' AND metric_date < d - INTERVAL '89 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS bahan_p90d,
        ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '179 days' AND metric_date < d - INTERVAL '89 days' THEN labor_total_cost ELSE 0 END)      / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '179 days' AND metric_date < d - INTERVAL '89 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS sdm_p90d,
        ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '179 days' AND metric_date < d - INTERVAL '89 days' THEN operational_total_cost ELSE 0 END)/ NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '179 days' AND metric_date < d - INTERVAL '89 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS ops_p90d
    FROM restaurant.daily_net_revenue CROSS JOIN max_d
    GROUP BY d
)
SELECT
    bahan_y, sdm_y, ops_y,
    bahan_sdow, sdm_sdow, ops_sdow,
    bahan_7d, sdm_7d, ops_7d, bahan_p7d, sdm_p7d, ops_p7d,
    ROUND(bahan_7d - bahan_p7d, 1) AS delta_bahan_7d,
    ROUND(sdm_7d  - sdm_p7d,  1) AS delta_sdm_7d,
    ROUND(ops_7d  - ops_p7d,  1) AS delta_ops_7d,
    bahan_30d, sdm_30d, ops_30d, bahan_p30d, sdm_p30d, ops_p30d,
    ROUND(bahan_30d - bahan_p30d, 1) AS delta_bahan_30d,
    ROUND(sdm_30d  - sdm_p30d,  1) AS delta_sdm_30d,
    ROUND(ops_30d  - ops_p30d,  1) AS delta_ops_30d,
    bahan_90d, sdm_90d, ops_90d, bahan_p90d, sdm_p90d, ops_p90d,
    ROUND(bahan_90d - bahan_p90d, 1) AS delta_bahan_90d,
    ROUND(sdm_90d  - sdm_p90d,  1) AS delta_sdm_90d,
    ROUND(ops_90d  - ops_p90d,  1) AS delta_ops_90d
FROM periods
```

```sql fin_kpi_mtd
WITH max_d AS (SELECT MAX(metric_date)::DATE AS d FROM restaurant.daily_net_revenue),
bulan_ini AS (
    SELECT DATE_TRUNC('month', d) AS bln_awal, d AS bln_akhir FROM max_d
),
bulan_lalu AS (
    SELECT
        DATE_TRUNC('month', d - INTERVAL '1 month') AS bln_awal,
        LAST_DAY(d - INTERVAL '1 month')             AS bln_akhir
    FROM max_d
)
SELECT
    -- Bulan ini (MTD)
    SUM(CASE WHEN metric_date >= b.bln_awal AND metric_date <= b.bln_akhir
        THEN gross_revenue ELSE 0 END)                                          AS gross_mtd,
    SUM(CASE WHEN metric_date >= b.bln_awal AND metric_date <= b.bln_akhir
        THEN net_revenue ELSE 0 END)                                            AS net_mtd,
    ROUND(SUM(CASE WHEN metric_date >= b.bln_awal AND metric_date <= b.bln_akhir
        THEN net_revenue ELSE 0 END)
        / NULLIF(SUM(CASE WHEN metric_date >= b.bln_awal AND metric_date <= b.bln_akhir
        THEN gross_revenue ELSE 0 END), 0) * 100, 1)                           AS margin_mtd,
    SUM(CASE WHEN metric_date >= b.bln_awal AND metric_date <= b.bln_akhir
        THEN inventory_usage_cost + labor_total_cost + operational_total_cost
        ELSE 0 END)                                                             AS biaya_mtd,
    DAY(b.bln_akhir)                                                            AS hari_berjalan,
    DAY(LAST_DAY(b.bln_akhir))                                                  AS total_hari_bulan,
    -- Bulan lalu (full month untuk komparasi fair)
    SUM(CASE WHEN metric_date >= l.bln_awal AND metric_date <= l.bln_akhir
        THEN gross_revenue ELSE 0 END)                                          AS gross_bulan_lalu,
    ROUND(SUM(CASE WHEN metric_date >= l.bln_awal AND metric_date <= l.bln_akhir
        THEN net_revenue ELSE 0 END)
        / NULLIF(SUM(CASE WHEN metric_date >= l.bln_awal AND metric_date <= l.bln_akhir
        THEN gross_revenue ELSE 0 END), 0) * 100, 1)                           AS margin_bulan_lalu,
    SUM(CASE WHEN metric_date >= l.bln_awal AND metric_date <= l.bln_akhir
        THEN inventory_usage_cost + labor_total_cost + operational_total_cost
        ELSE 0 END)                                                             AS biaya_bulan_lalu,
    -- Proyeksi akhir bulan (pace saat ini)
    ROUND(SUM(CASE WHEN metric_date >= b.bln_awal AND metric_date <= b.bln_akhir
        THEN gross_revenue ELSE 0 END)
        / NULLIF(DAY(b.bln_akhir), 0) * DAY(LAST_DAY(b.bln_akhir)), 0)        AS proyeksi_gross,
    ROUND(SUM(CASE WHEN metric_date >= b.bln_awal AND metric_date <= b.bln_akhir
        THEN net_revenue ELSE 0 END)
        / NULLIF(DAY(b.bln_akhir), 0) * DAY(LAST_DAY(b.bln_akhir)), 0)        AS proyeksi_net
FROM restaurant.daily_net_revenue
CROSS JOIN bulan_ini b
CROSS JOIN bulan_lalu l
```

```sql fin_cost_mtd
WITH max_d AS (SELECT MAX(metric_date)::DATE AS d FROM restaurant.daily_net_revenue),
bulan_ini AS (SELECT DATE_TRUNC('month', d) AS awal, d AS akhir FROM max_d),
bulan_lalu AS (
    SELECT DATE_TRUNC('month', d - INTERVAL '1 month') AS awal,
           LAST_DAY(d - INTERVAL '1 month') AS akhir FROM max_d
)
SELECT
    ROUND(SUM(CASE WHEN metric_date >= b.awal AND metric_date <= b.akhir
        THEN inventory_usage_cost ELSE 0 END)
        / NULLIF(SUM(CASE WHEN metric_date >= b.awal AND metric_date <= b.akhir
        THEN gross_revenue ELSE 0 END), 0) * 100, 1)                           AS bahan_mtd,
    ROUND(SUM(CASE WHEN metric_date >= b.awal AND metric_date <= b.akhir
        THEN labor_total_cost ELSE 0 END)
        / NULLIF(SUM(CASE WHEN metric_date >= b.awal AND metric_date <= b.akhir
        THEN gross_revenue ELSE 0 END), 0) * 100, 1)                           AS sdm_mtd,
    ROUND(SUM(CASE WHEN metric_date >= b.awal AND metric_date <= b.akhir
        THEN operational_total_cost ELSE 0 END)
        / NULLIF(SUM(CASE WHEN metric_date >= b.awal AND metric_date <= b.akhir
        THEN gross_revenue ELSE 0 END), 0) * 100, 1)                           AS ops_mtd,
    ROUND(SUM(CASE WHEN metric_date >= l.awal AND metric_date <= l.akhir
        THEN inventory_usage_cost ELSE 0 END)
        / NULLIF(SUM(CASE WHEN metric_date >= l.awal AND metric_date <= l.akhir
        THEN gross_revenue ELSE 0 END), 0) * 100, 1)                           AS bahan_lalu,
    ROUND(SUM(CASE WHEN metric_date >= l.awal AND metric_date <= l.akhir
        THEN labor_total_cost ELSE 0 END)
        / NULLIF(SUM(CASE WHEN metric_date >= l.awal AND metric_date <= l.akhir
        THEN gross_revenue ELSE 0 END), 0) * 100, 1)                           AS sdm_lalu,
    ROUND(SUM(CASE WHEN metric_date >= l.awal AND metric_date <= l.akhir
        THEN operational_total_cost ELSE 0 END)
        / NULLIF(SUM(CASE WHEN metric_date >= l.awal AND metric_date <= l.akhir
        THEN gross_revenue ELSE 0 END), 0) * 100, 1)                           AS ops_lalu,
    ROUND(SUM(CASE WHEN metric_date >= b.awal AND metric_date <= b.akhir
        THEN inventory_usage_cost ELSE 0 END)
        / NULLIF(SUM(CASE WHEN metric_date >= b.awal AND metric_date <= b.akhir
        THEN gross_revenue ELSE 0 END), 0) * 100, 1)
    - ROUND(SUM(CASE WHEN metric_date >= l.awal AND metric_date <= l.akhir
        THEN inventory_usage_cost ELSE 0 END)
        / NULLIF(SUM(CASE WHEN metric_date >= l.awal AND metric_date <= l.akhir
        THEN gross_revenue ELSE 0 END), 0) * 100, 1)                           AS delta_bahan,
    ROUND(SUM(CASE WHEN metric_date >= b.awal AND metric_date <= b.akhir
        THEN labor_total_cost ELSE 0 END)
        / NULLIF(SUM(CASE WHEN metric_date >= b.awal AND metric_date <= b.akhir
        THEN gross_revenue ELSE 0 END), 0) * 100, 1)
    - ROUND(SUM(CASE WHEN metric_date >= l.awal AND metric_date <= l.akhir
        THEN labor_total_cost ELSE 0 END)
        / NULLIF(SUM(CASE WHEN metric_date >= l.awal AND metric_date <= l.akhir
        THEN gross_revenue ELSE 0 END), 0) * 100, 1)                           AS delta_sdm,
    ROUND(SUM(CASE WHEN metric_date >= b.awal AND metric_date <= b.akhir
        THEN operational_total_cost ELSE 0 END)
        / NULLIF(SUM(CASE WHEN metric_date >= b.awal AND metric_date <= b.akhir
        THEN gross_revenue ELSE 0 END), 0) * 100, 1)
    - ROUND(SUM(CASE WHEN metric_date >= l.awal AND metric_date <= l.akhir
        THEN operational_total_cost ELSE 0 END)
        / NULLIF(SUM(CASE WHEN metric_date >= l.awal AND metric_date <= l.akhir
        THEN gross_revenue ELSE 0 END), 0) * 100, 1)                           AS delta_ops
FROM restaurant.daily_net_revenue
CROSS JOIN bulan_ini b
CROSS JOIN bulan_lalu l
```

```sql fin_branch_mtd
WITH max_d AS (SELECT MAX(metric_date)::DATE AS d FROM restaurant.daily_net_revenue),
bulan_ini AS (SELECT DATE_TRUNC('month', d) AS awal, d AS akhir FROM max_d),
bulan_lalu AS (
    SELECT DATE_TRUNC('month', d - INTERVAL '1 month') AS awal,
           LAST_DAY(d - INTERVAL '1 month') AS akhir FROM max_d
),
curr AS (
    SELECT branch_name,
        SUM(gross_revenue) AS gross, SUM(net_revenue) AS net,
        ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS margin_pct
    FROM restaurant.daily_net_revenue CROSS JOIN bulan_ini b
    WHERE metric_date >= b.awal AND metric_date <= b.akhir
    GROUP BY branch_name
),
prev AS (
    SELECT branch_name,
        ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS margin_pct
    FROM restaurant.daily_net_revenue CROSS JOIN bulan_lalu l
    WHERE metric_date >= l.awal AND metric_date <= l.akhir
    GROUP BY branch_name
)
SELECT c.branch_name, c.gross, c.net, c.margin_pct,
    p.margin_pct AS margin_prev,
    ROUND(c.margin_pct - p.margin_pct, 1) AS delta,
    CASE WHEN c.margin_pct >= 15 THEN '✅ Sehat'
         WHEN c.margin_pct >= 10 THEN '⚠️ Perhatian'
         ELSE '🔴 Kritis' END AS status
FROM curr c LEFT JOIN prev p ON c.branch_name = p.branch_name
ORDER BY c.margin_pct DESC
```

```sql fin_margin_daily_mtd
WITH max_d AS (SELECT MAX(metric_date)::DATE AS d FROM restaurant.daily_net_revenue)
SELECT
    metric_date,
    ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS margin_pct
FROM restaurant.daily_net_revenue CROSS JOIN max_d
WHERE metric_date >= DATE_TRUNC('month', d)
GROUP BY metric_date
ORDER BY metric_date
```

```sql fin_nama_bulan
SELECT
    CASE MONTH(DATE_TRUNC('month', MAX(metric_date)))
        WHEN 1 THEN 'Januari' WHEN 2 THEN 'Februari' WHEN 3 THEN 'Maret'
        WHEN 4 THEN 'April'   WHEN 5 THEN 'Mei'      WHEN 6 THEN 'Juni'
        WHEN 7 THEN 'Juli'    WHEN 8 THEN 'Agustus'  WHEN 9 THEN 'September'
        WHEN 10 THEN 'Oktober' WHEN 11 THEN 'November' WHEN 12 THEN 'Desember'
    END AS nama_bulan,
    CASE MONTH(DATE_TRUNC('month', MAX(metric_date)) - INTERVAL '1 month')
        WHEN 1 THEN 'Januari' WHEN 2 THEN 'Februari' WHEN 3 THEN 'Maret'
        WHEN 4 THEN 'April'   WHEN 5 THEN 'Mei'      WHEN 6 THEN 'Juni'
        WHEN 7 THEN 'Juli'    WHEN 8 THEN 'Agustus'  WHEN 9 THEN 'September'
        WHEN 10 THEN 'Oktober' WHEN 11 THEN 'November' WHEN 12 THEN 'Desember'
    END AS nama_bulan_lalu
FROM restaurant.daily_net_revenue
```

```sql fin_branch_30d
WITH max_d AS (SELECT MAX(metric_date)::DATE AS d FROM restaurant.daily_net_revenue),
curr AS (
    SELECT branch_name,
        SUM(gross_revenue) AS gross, SUM(net_revenue) AS net,
        ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS margin_pct
    FROM restaurant.daily_net_revenue CROSS JOIN max_d
    WHERE metric_date >= d - INTERVAL '29 days'
    GROUP BY branch_name
),
prev AS (
    SELECT branch_name,
        ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS margin_pct
    FROM restaurant.daily_net_revenue CROSS JOIN max_d
    WHERE metric_date >= d - INTERVAL '59 days' AND metric_date < d - INTERVAL '29 days'
    GROUP BY branch_name
)
SELECT c.branch_name, c.gross, c.net, c.margin_pct,
    p.margin_pct AS margin_prev,
    ROUND(c.margin_pct - p.margin_pct, 1) AS delta,
    CASE WHEN c.margin_pct >= 15 THEN '✅ Sehat'
         WHEN c.margin_pct >= 10 THEN '⚠️ Perhatian'
         ELSE '🔴 Kritis' END AS status
FROM curr c LEFT JOIN prev p ON c.branch_name = p.branch_name
ORDER BY c.margin_pct DESC
```

```sql fin_branch_30d_gap
WITH max_d AS (SELECT MAX(metric_date)::DATE AS d FROM restaurant.daily_net_revenue),
m AS (
    SELECT branch_name,
        ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS margin_pct
    FROM restaurant.daily_net_revenue CROSS JOIN max_d
    WHERE metric_date >= d - INTERVAL '29 days'
    GROUP BY branch_name
)
SELECT
    ROUND(MAX(margin_pct) - MIN(margin_pct), 1)                                AS gap,
    MAX(CASE WHEN margin_pct = (SELECT MAX(margin_pct) FROM m) THEN branch_name END) AS cabang_terbaik,
    MAX(CASE WHEN margin_pct = (SELECT MIN(margin_pct) FROM m) THEN branch_name END) AS cabang_terlemah,
    MAX(margin_pct)                                                             AS margin_max,
    MIN(margin_pct)                                                             AS margin_min,
    COUNT(CASE WHEN margin_pct < 10 THEN 1 END)                                AS jumlah_kritis
FROM m
```

```sql fin_branch_90d
WITH max_d AS (SELECT MAX(metric_date)::DATE AS d FROM restaurant.daily_net_revenue),
curr AS (
    SELECT branch_name,
        SUM(gross_revenue) AS gross, SUM(net_revenue) AS net,
        ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS margin_pct
    FROM restaurant.daily_net_revenue CROSS JOIN max_d
    WHERE metric_date >= d - INTERVAL '89 days'
    GROUP BY branch_name
),
prev AS (
    SELECT branch_name,
        ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS margin_pct
    FROM restaurant.daily_net_revenue CROSS JOIN max_d
    WHERE metric_date >= d - INTERVAL '179 days' AND metric_date < d - INTERVAL '89 days'
    GROUP BY branch_name
)
SELECT c.branch_name, c.gross, c.net, c.margin_pct,
    p.margin_pct AS margin_prev,
    ROUND(c.margin_pct - p.margin_pct, 1) AS delta,
    CASE WHEN c.margin_pct >= 15 THEN '✅ Sehat'
         WHEN c.margin_pct >= 10 THEN '⚠️ Perhatian'
         ELSE '🔴 Kritis' END AS status
FROM curr c LEFT JOIN prev p ON c.branch_name = p.branch_name
ORDER BY c.margin_pct DESC
```

```sql fin_branch_monthly
WITH max_d AS (SELECT MAX(metric_date)::DATE AS d FROM restaurant.daily_net_revenue)
SELECT
    DATE_TRUNC('month', metric_date) AS bulan,
    branch_name,
    ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS margin_pct
FROM restaurant.daily_net_revenue CROSS JOIN max_d
WHERE metric_date >= d - INTERVAL '89 days'
GROUP BY 1, 2
ORDER BY 1, 2
```

```sql fin_quarter
SELECT
    YEAR(metric_date)                             AS tahun,
    CEIL(MONTH(metric_date) / 3.0)                AS qnum,
    'Q' || CAST(CEIL(MONTH(metric_date) / 3.0) AS VARCHAR) || ' ' || CAST(YEAR(metric_date) AS VARCHAR) AS quarter_label,
    YEAR(metric_date) * 10 + CEIL(MONTH(metric_date) / 3.0) AS qsort,
    SUM(gross_revenue)                            AS gross,
    SUM(net_revenue)                              AS net,
    ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS margin_pct,
    SUM(inventory_usage_cost + labor_total_cost + operational_total_cost) AS total_biaya,
    ROUND(SUM(inventory_usage_cost)    / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS bahan_pct,
    ROUND(SUM(labor_total_cost)        / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS sdm_pct,
    ROUND(SUM(operational_total_cost)  / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS ops_pct
FROM restaurant.daily_net_revenue
GROUP BY 1, 2, 3, 4
ORDER BY qsort DESC
LIMIT 8
```

```sql fin_yoy
SELECT
    YEAR(metric_date)                             AS tahun,
    SUM(gross_revenue)                            AS gross,
    SUM(net_revenue)                              AS net,
    ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS margin_pct,
    SUM(inventory_usage_cost + labor_total_cost + operational_total_cost) AS total_biaya,
    ROUND(SUM(inventory_usage_cost)    / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS bahan_pct,
    ROUND(SUM(labor_total_cost)        / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS sdm_pct,
    ROUND(SUM(operational_total_cost)  / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS ops_pct
FROM restaurant.daily_net_revenue
GROUP BY 1
ORDER BY 1 DESC
```

---

_Kesehatan finansial bisnis — profitabilitas, struktur biaya, dan margin per periode._

<ButtonGroup name=period>
  <ButtonGroupItem valueLabel="Bulan Ini" value="mtd" />
  <ButtonGroupItem valueLabel="30 Hari"  value="30d" default />
  <ButtonGroupItem valueLabel="90 Hari"  value="90d" />
  <ButtonGroupItem valueLabel="Quarter"  value="quarter" />
  <ButtonGroupItem valueLabel="YoY"      value="yoy" />
</ButtonGroup>

---

{#if inputs.period === 'mtd'}

<!-- HEADER -->
<div style="margin:28px 0 20px;">
  <div style="font-size:10.5px;font-weight:700;letter-spacing:0.13em;text-transform:uppercase;color:var(--color-text-tertiary);margin-bottom:5px;">Laporan Keuangan · Bulan Berjalan</div>
  <div style="font-size:1.35em;font-weight:800;color:var(--color-text-primary);letter-spacing:-0.01em;">{fin_nama_bulan[0].nama_bulan} {fin_kpi_mtd[0].hari_berjalan}/{fin_kpi_mtd[0].total_hari_bulan} hari</div>
  <div style="font-size:0.82em;color:var(--color-text-tertiary);margin-top:3px;">{fin_kpi_mtd[0].hari_berjalan} hari berjalan dari {fin_kpi_mtd[0].total_hari_bulan} hari — dibandingkan bulan {fin_nama_bulan[0].nama_bulan_lalu} secara keseluruhan.</div>
</div>

<!-- HEADLINE METRICS -->
<BigValue data={fin_kpi_mtd} value="gross_mtd"   title="Gross Revenue MTD (Rp)"  fmt="#,##0"  comparison="gross_bulan_lalu"  comparisonTitle="Bulan {fin_nama_bulan[0].nama_bulan_lalu} (full)" />
<BigValue data={fin_kpi_mtd} value="net_mtd"     title="Net Revenue MTD (Rp)"    fmt="#,##0" />
<BigValue data={fin_kpi_mtd} value="margin_mtd"  title="Net Margin MTD"          fmt="0.0\%"  comparison="margin_bulan_lalu" comparisonTitle="Bulan {fin_nama_bulan[0].nama_bulan_lalu} (full)" />
<BigValue data={fin_kpi_mtd} value="biaya_mtd"   title="Total Biaya MTD (Rp)"    fmt="#,##0"  comparison="biaya_bulan_lalu"  comparisonTitle="Bulan {fin_nama_bulan[0].nama_bulan_lalu} (full)" />

<!-- PROYEKSI CARD -->
<div style="background:linear-gradient(135deg,rgba(99,102,241,0.06),rgba(139,92,246,0.03));border:1px solid rgba(99,102,241,0.18);border-radius:10px;padding:14px 18px;margin:16px 0 20px;display:flex;align-items:center;gap:20px;flex-wrap:wrap;">
  <div style="width:28px;height:28px;background:rgba(99,102,241,0.12);border-radius:7px;display:flex;align-items:center;justify-content:center;font-size:14px;flex-shrink:0;">📈</div>
  <div style="flex:1;">
    <div style="font-size:10.5px;font-weight:700;letter-spacing:0.08em;text-transform:uppercase;color:#6366f1;margin-bottom:4px;">Proyeksi Akhir {fin_nama_bulan[0].nama_bulan} (jika pace saat ini berlanjut)</div>
    <div style="display:flex;gap:24px;flex-wrap:wrap;">
      <div>
        <span style="font-size:0.82em;color:var(--color-text-tertiary);">Gross Revenue</span><br/>
        <span style="font-size:1.1em;font-weight:800;color:var(--color-text-primary);">Rp {(fin_kpi_mtd[0].proyeksi_gross / 1000000).toFixed(1)}jt</span>
        <span style="font-size:0.8em;color:{fin_kpi_mtd[0].proyeksi_gross > fin_kpi_mtd[0].gross_bulan_lalu ? '#10b981' : '#ef4444'};margin-left:6px;">{fin_kpi_mtd[0].proyeksi_gross > fin_kpi_mtd[0].gross_bulan_lalu ? '▲' : '▼'} vs {fin_nama_bulan[0].nama_bulan_lalu}</span>
      </div>
      <div>
        <span style="font-size:0.82em;color:var(--color-text-tertiary);">Net Revenue</span><br/>
        <span style="font-size:1.1em;font-weight:800;color:var(--color-text-primary);">Rp {(fin_kpi_mtd[0].proyeksi_net / 1000000).toFixed(1)}jt</span>
      </div>
    </div>
  </div>
  <div style="font-size:0.78em;color:var(--color-text-tertiary);max-width:200px;line-height:1.6;">Proyeksi linear berdasarkan rata-rata harian bulan ini. Tidak memperhitungkan pola weekend/weekday.</div>
</div>

<!-- STATUS BANNER -->
{#if fin_kpi_mtd[0].margin_mtd >= 15}
  {#if fin_kpi_mtd[0].margin_mtd < fin_kpi_mtd[0].margin_bulan_lalu - 1}
<div style="background:linear-gradient(135deg,rgba(245,158,11,0.07),rgba(245,158,11,0.03));border:1px solid rgba(245,158,11,0.3);border-left:4px solid #f59e0b;border-radius:10px;padding:14px 18px;margin:16px 0;display:flex;align-items:flex-start;gap:12px;">
  <span style="font-size:1.2em;flex-shrink:0;margin-top:1px;">⚠️</span>
  <div>
    <div style="font-weight:700;font-size:0.93em;color:#92400e;margin-bottom:3px;">Margin {fin_kpi_mtd[0].margin_mtd}% — Sehat, tapi turun {Math.abs(fin_kpi_mtd[0].margin_mtd - fin_kpi_mtd[0].margin_bulan_lalu)}pp dibanding {fin_nama_bulan[0].nama_bulan_lalu}</div>
    <div style="font-size:0.85em;color:#78350f;line-height:1.65;">Masih aman, tapi tren menurun perlu diperhatikan. Cek komponen biaya mana yang mulai merayap naik.</div>
  </div>
</div>
  {:else}
<div style="background:linear-gradient(135deg,rgba(16,185,129,0.07),rgba(16,185,129,0.03));border:1px solid rgba(16,185,129,0.22);border-left:4px solid #10b981;border-radius:10px;padding:14px 18px;margin:16px 0;display:flex;align-items:flex-start;gap:12px;">
  <span style="font-size:1.2em;flex-shrink:0;margin-top:1px;">✅</span>
  <div>
    <div style="font-weight:700;font-size:0.93em;color:#065f46;margin-bottom:3px;">Margin {fin_kpi_mtd[0].margin_mtd}% — Sehat ({fin_kpi_mtd[0].margin_mtd >= fin_kpi_mtd[0].margin_bulan_lalu ? '+' : ''}{Math.round((fin_kpi_mtd[0].margin_mtd - fin_kpi_mtd[0].margin_bulan_lalu) * 10) / 10}pp vs {fin_nama_bulan[0].nama_bulan_lalu})</div>
    <div style="font-size:0.85em;color:#064e3b;line-height:1.65;">Berjalan baik di bulan {fin_nama_bulan[0].nama_bulan}. Pantau komponen biaya agar tren ini terjaga sampai akhir bulan.</div>
  </div>
</div>
  {/if}
{:else if fin_kpi_mtd[0].margin_mtd >= 10}
<div style="background:linear-gradient(135deg,rgba(245,158,11,0.07),rgba(245,158,11,0.03));border:1px solid rgba(245,158,11,0.3);border-left:4px solid #f59e0b;border-radius:10px;padding:14px 18px;margin:16px 0;display:flex;align-items:flex-start;gap:12px;">
  <span style="font-size:1.2em;flex-shrink:0;margin-top:1px;">⚠️</span>
  <div>
    <div style="font-weight:700;font-size:0.93em;color:#92400e;margin-bottom:3px;">Margin {fin_kpi_mtd[0].margin_mtd}% — Di bawah target bulan {fin_nama_bulan[0].nama_bulan}</div>
    <div style="font-size:0.85em;color:#78350f;line-height:1.65;">Masih ada {fin_kpi_mtd[0].total_hari_bulan - fin_kpi_mtd[0].hari_berjalan} hari tersisa di bulan ini. Identifikasi komponen penyebab sekarang sebelum terlambat.</div>
  </div>
</div>
{:else}
<div style="background:linear-gradient(135deg,rgba(239,68,68,0.07),rgba(239,68,68,0.03));border:1px solid rgba(239,68,68,0.25);border-left:4px solid #ef4444;border-radius:10px;padding:14px 18px;margin:16px 0;display:flex;align-items:flex-start;gap:12px;">
  <span style="font-size:1.2em;flex-shrink:0;margin-top:1px;">🔴</span>
  <div>
    <div style="font-weight:700;font-size:0.93em;color:#7f1d1d;margin-bottom:3px;">Margin {fin_kpi_mtd[0].margin_mtd}% — Kritis di bulan {fin_nama_bulan[0].nama_bulan}</div>
    <div style="font-size:0.85em;color:#7f1d1d;line-height:1.65;">Masih ada {fin_kpi_mtd[0].total_hari_bulan - fin_kpi_mtd[0].hari_berjalan} hari untuk memperbaiki — tapi perlu tindakan segera sekarang.</div>
  </div>
</div>
{/if}

---

<!-- EARLY WARNING -->
{#if fin_cost_mtd[0].ops_mtd > 15 || fin_cost_mtd[0].bahan_mtd > 32 || fin_cost_mtd[0].sdm_mtd > 22}
<div style="background:linear-gradient(135deg,rgba(99,102,241,0.06),rgba(139,92,246,0.03));border:1px solid rgba(99,102,241,0.2);border-radius:12px;padding:20px 22px;margin:4px 0 24px;">
  <div style="display:flex;align-items:center;gap:10px;margin-bottom:14px;">
    <div style="width:30px;height:30px;background:rgba(99,102,241,0.12);border-radius:8px;display:flex;align-items:center;justify-content:center;font-size:15px;flex-shrink:0;">🔍</div>
    <div>
      <div style="font-size:10.5px;font-weight:700;letter-spacing:0.1em;text-transform:uppercase;color:#6366f1;">Early Warning — Komponen yang Sudah Melampaui Target</div>
      <div style="font-size:0.8em;color:var(--color-text-tertiary);margin-top:1px;">{fin_kpi_mtd[0].hari_berjalan} hari data sudah cukup untuk tindakan</div>
    </div>
  </div>
  <div style="display:flex;flex-direction:column;gap:7px;margin-bottom:16px;">
    {#if fin_cost_mtd[0].ops_mtd > 15}
    <div style="display:flex;align-items:center;gap:10px;padding:10px 13px;background:rgba(239,68,68,0.05);border:1px solid rgba(239,68,68,0.18);border-radius:8px;font-size:0.86em;">
      <span>🏢</span>
      <div style="flex:1;line-height:1.5;">
        <strong>Biaya Operasional {fin_cost_mtd[0].ops_mtd}%</strong> — target ≤15%, sudah +{Math.round((fin_cost_mtd[0].ops_mtd - 15) * 10) / 10}pp di atas batas
        {#if fin_cost_mtd[0].delta_ops > 0}<span style="color:#ef4444;font-size:0.9em;"> · naik {fin_cost_mtd[0].delta_ops}pp vs {fin_nama_bulan[0].nama_bulan_lalu}</span>{/if}
      </div>
    </div>
    {/if}
    {#if fin_cost_mtd[0].bahan_mtd > 32}
    <div style="display:flex;align-items:center;gap:10px;padding:10px 13px;background:rgba(245,158,11,0.05);border:1px solid rgba(245,158,11,0.22);border-radius:8px;font-size:0.86em;">
      <span>🥩</span>
      <div style="flex:1;line-height:1.5;">
        <strong>Biaya Bahan {fin_cost_mtd[0].bahan_mtd}%</strong> — target ≤32%, sudah +{Math.round((fin_cost_mtd[0].bahan_mtd - 32) * 10) / 10}pp di atas batas
        {#if fin_cost_mtd[0].delta_bahan > 0}<span style="color:#f59e0b;font-size:0.9em;"> · naik {fin_cost_mtd[0].delta_bahan}pp vs {fin_nama_bulan[0].nama_bulan_lalu}</span>{/if}
      </div>
    </div>
    {/if}
    {#if fin_cost_mtd[0].sdm_mtd > 22}
    <div style="display:flex;align-items:center;gap:10px;padding:10px 13px;background:rgba(245,158,11,0.05);border:1px solid rgba(245,158,11,0.22);border-radius:8px;font-size:0.86em;">
      <span>👤</span>
      <div style="flex:1;line-height:1.5;">
        <strong>Biaya SDM {fin_cost_mtd[0].sdm_mtd}%</strong> — target ≤22%, sudah +{Math.round((fin_cost_mtd[0].sdm_mtd - 22) * 10) / 10}pp di atas batas
        {#if fin_cost_mtd[0].delta_sdm > 0}<span style="color:#f59e0b;font-size:0.9em;"> · naik {fin_cost_mtd[0].delta_sdm}pp vs {fin_nama_bulan[0].nama_bulan_lalu}</span>{/if}
      </div>
    </div>
    {/if}
  </div>
  <div style="background:rgba(99,102,241,0.07);border-radius:8px;padding:12px 15px;">
    <div style="font-size:10.5px;font-weight:700;letter-spacing:0.08em;text-transform:uppercase;color:#4338ca;margin-bottom:6px;">📐 Estimasi dampak ke akhir bulan</div>
    <div style="font-size:0.84em;color:var(--color-text-secondary);line-height:1.7;">
      Kalau struktur biaya ini tidak berubah, margin proyeksi akhir {fin_nama_bulan[0].nama_bulan} sekitar
      <strong>~{Math.round((fin_kpi_mtd[0].proyeksi_net / fin_kpi_mtd[0].proyeksi_gross) * 1000) / 10}%</strong> —
      {#if Math.round((fin_kpi_mtd[0].proyeksi_net / fin_kpi_mtd[0].proyeksi_gross) * 1000) / 10 >= 15}
      masih sehat, tapi komponen yang lewat target perlu diperbaiki bulan ini juga.
      {:else if Math.round((fin_kpi_mtd[0].proyeksi_net / fin_kpi_mtd[0].proyeksi_gross) * 1000) / 10 >= 10}
      akan masuk <strong>zona waspada</strong>. Ada {fin_kpi_mtd[0].total_hari_bulan - fin_kpi_mtd[0].hari_berjalan} hari tersisa untuk memperbaiki.
      {:else}
      akan masuk <strong>zona kritis</strong>. Perlu tindakan sekarang.
      {/if}
    </div>
  </div>
</div>
{/if}

<!-- KOMPOSISI BIAYA — 3 CARDS -->
<div style="margin:0 0 8px;">
  <div style="font-size:10.5px;font-weight:700;letter-spacing:0.13em;text-transform:uppercase;color:var(--color-text-tertiary);margin-bottom:2px;">Komposisi Biaya</div>
  <div style="font-size:0.8em;color:var(--color-text-tertiary);">Dari setiap Rp100 gross revenue bulan {fin_nama_bulan[0].nama_bulan} — berapa yang habis di tiap pos?</div>
</div>

<div style="display:grid;grid-template-columns:repeat(3,1fr);gap:12px;margin:10px 0 28px;">

  <!-- CARD BAHAN -->
  <div style="background:var(--color-background-secondary);border:1px solid {fin_cost_mtd[0].bahan_mtd > 32 ? 'rgba(239,68,68,0.3)' : 'var(--color-border-tertiary)'};border-radius:12px;padding:18px 18px 14px;position:relative;overflow:hidden;">
    <div style="position:absolute;top:0;left:0;right:0;height:3px;background:{fin_cost_mtd[0].bahan_mtd > 32 ? 'linear-gradient(90deg,#ef4444,#fca5a5)' : 'linear-gradient(90deg,#10b981,#6ee7b7)'};"></div>
    <div style="font-size:10px;font-weight:700;letter-spacing:0.08em;text-transform:uppercase;color:var(--color-text-tertiary);margin-bottom:10px;">🥩 Biaya Bahan</div>
    <div style="font-size:2.1em;font-weight:900;letter-spacing:-0.03em;color:{fin_cost_mtd[0].bahan_mtd > 32 ? '#ef4444' : '#10b981'};margin-bottom:2px;">{fin_cost_mtd[0].bahan_mtd}%</div>
    <div style="font-size:11px;color:var(--color-text-tertiary);margin-bottom:10px;">target ≤32%</div>
    <div style="height:6px;background:rgba(0,0,0,0.07);border-radius:3px;position:relative;overflow:visible;margin-bottom:3px;">
      <div style="height:100%;border-radius:3px;background:{fin_cost_mtd[0].bahan_mtd > 32 ? 'linear-gradient(90deg,#ef4444,#fca5a5)' : 'linear-gradient(90deg,#10b981,#6ee7b7)'};width:{Math.min(fin_cost_mtd[0].bahan_mtd / 40 * 100, 100)}%;"></div>
      <div style="position:absolute;top:-2px;bottom:-2px;left:{32/40*100}%;width:2px;background:rgba(0,0,0,0.18);border-radius:1px;"></div>
    </div>
    <div style="display:flex;justify-content:space-between;font-size:10px;color:var(--color-text-tertiary);margin-bottom:12px;"><span>0%</span><span>⬆ 32%</span><span>40%</span></div>
    <div style="display:flex;justify-content:space-between;align-items:center;padding-top:10px;border-top:1px solid var(--color-border-tertiary);">
      <span style="font-size:10.5px;padding:2px 8px;border-radius:10px;font-weight:700;background:{fin_cost_mtd[0].bahan_mtd > 32 ? 'rgba(239,68,68,0.1)' : 'rgba(16,185,129,0.1)'};color:{fin_cost_mtd[0].bahan_mtd > 32 ? '#ef4444' : '#10b981'};">{fin_cost_mtd[0].bahan_mtd > 32 ? '⚠ Lewat target' : '✓ Normal'}</span>
      <span style="font-size:10.5px;color:{fin_cost_mtd[0].delta_bahan > 0 ? '#ef4444' : fin_cost_mtd[0].delta_bahan < 0 ? '#10b981' : 'var(--color-text-tertiary)'};">
        {fin_cost_mtd[0].delta_bahan > 0 ? '▲' : fin_cost_mtd[0].delta_bahan < 0 ? '▼' : '—'} {Math.abs(fin_cost_mtd[0].delta_bahan)}pp vs {fin_nama_bulan[0].nama_bulan_lalu}
      </span>
    </div>
  </div>

  <!-- CARD SDM -->
  <div style="background:var(--color-background-secondary);border:1px solid {fin_cost_mtd[0].sdm_mtd > 22 ? 'rgba(245,158,11,0.35)' : 'var(--color-border-tertiary)'};border-radius:12px;padding:18px 18px 14px;position:relative;overflow:hidden;">
    <div style="position:absolute;top:0;left:0;right:0;height:3px;background:{fin_cost_mtd[0].sdm_mtd > 22 ? 'linear-gradient(90deg,#f59e0b,#fde68a)' : 'linear-gradient(90deg,#10b981,#6ee7b7)'};"></div>
    <div style="font-size:10px;font-weight:700;letter-spacing:0.08em;text-transform:uppercase;color:var(--color-text-tertiary);margin-bottom:10px;">👤 Biaya SDM</div>
    <div style="font-size:2.1em;font-weight:900;letter-spacing:-0.03em;color:{fin_cost_mtd[0].sdm_mtd > 22 ? '#f59e0b' : '#10b981'};margin-bottom:2px;">{fin_cost_mtd[0].sdm_mtd}%</div>
    <div style="font-size:11px;color:var(--color-text-tertiary);margin-bottom:10px;">target ≤22%</div>
    <div style="height:6px;background:rgba(0,0,0,0.07);border-radius:3px;position:relative;overflow:visible;margin-bottom:3px;">
      <div style="height:100%;border-radius:3px;background:{fin_cost_mtd[0].sdm_mtd > 22 ? 'linear-gradient(90deg,#f59e0b,#fde68a)' : 'linear-gradient(90deg,#10b981,#6ee7b7)'};width:{Math.min(fin_cost_mtd[0].sdm_mtd / 30 * 100, 100)}%;"></div>
      <div style="position:absolute;top:-2px;bottom:-2px;left:{22/30*100}%;width:2px;background:rgba(0,0,0,0.18);border-radius:1px;"></div>
    </div>
    <div style="display:flex;justify-content:space-between;font-size:10px;color:var(--color-text-tertiary);margin-bottom:12px;"><span>0%</span><span>⬆ 22%</span><span>30%</span></div>
    <div style="display:flex;justify-content:space-between;align-items:center;padding-top:10px;border-top:1px solid var(--color-border-tertiary);">
      <span style="font-size:10.5px;padding:2px 8px;border-radius:10px;font-weight:700;background:{fin_cost_mtd[0].sdm_mtd > 22 ? 'rgba(245,158,11,0.1)' : 'rgba(16,185,129,0.1)'};color:{fin_cost_mtd[0].sdm_mtd > 22 ? '#f59e0b' : '#10b981'};">{fin_cost_mtd[0].sdm_mtd > 22 ? '⚠ Lewat target' : '✓ Normal'}</span>
      <span style="font-size:10.5px;color:{fin_cost_mtd[0].delta_sdm > 0 ? '#ef4444' : fin_cost_mtd[0].delta_sdm < 0 ? '#10b981' : 'var(--color-text-tertiary)'};">
        {fin_cost_mtd[0].delta_sdm > 0 ? '▲' : fin_cost_mtd[0].delta_sdm < 0 ? '▼' : '—'} {Math.abs(fin_cost_mtd[0].delta_sdm)}pp vs {fin_nama_bulan[0].nama_bulan_lalu}
      </span>
    </div>
  </div>

  <!-- CARD OPERASIONAL -->
  <div style="background:var(--color-background-secondary);border:1px solid {fin_cost_mtd[0].ops_mtd > 15 ? 'rgba(239,68,68,0.3)' : 'var(--color-border-tertiary)'};border-radius:12px;padding:18px 18px 14px;position:relative;overflow:hidden;">
    <div style="position:absolute;top:0;left:0;right:0;height:3px;background:{fin_cost_mtd[0].ops_mtd > 15 ? 'linear-gradient(90deg,#ef4444,#fca5a5)' : 'linear-gradient(90deg,#10b981,#6ee7b7)'};"></div>
    <div style="font-size:10px;font-weight:700;letter-spacing:0.08em;text-transform:uppercase;color:var(--color-text-tertiary);margin-bottom:10px;">🏢 Biaya Ops</div>
    <div style="font-size:2.1em;font-weight:900;letter-spacing:-0.03em;color:{fin_cost_mtd[0].ops_mtd > 15 ? '#ef4444' : '#10b981'};margin-bottom:2px;">{fin_cost_mtd[0].ops_mtd}%</div>
    <div style="font-size:11px;color:var(--color-text-tertiary);margin-bottom:10px;">target ≤15%</div>
    <div style="height:6px;background:rgba(0,0,0,0.07);border-radius:3px;position:relative;overflow:visible;margin-bottom:3px;">
      <div style="height:100%;border-radius:3px;background:{fin_cost_mtd[0].ops_mtd > 15 ? 'linear-gradient(90deg,#ef4444,#fca5a5)' : 'linear-gradient(90deg,#10b981,#6ee7b7)'};width:{Math.min(fin_cost_mtd[0].ops_mtd / 25 * 100, 100)}%;"></div>
      <div style="position:absolute;top:-2px;bottom:-2px;left:{15/25*100}%;width:2px;background:rgba(0,0,0,0.18);border-radius:1px;"></div>
    </div>
    <div style="display:flex;justify-content:space-between;font-size:10px;color:var(--color-text-tertiary);margin-bottom:12px;"><span>0%</span><span>⬆ 15%</span><span>25%</span></div>
    <div style="display:flex;justify-content:space-between;align-items:center;padding-top:10px;border-top:1px solid var(--color-border-tertiary);">
      <span style="font-size:10.5px;padding:2px 8px;border-radius:10px;font-weight:700;background:{fin_cost_mtd[0].ops_mtd > 15 ? 'rgba(239,68,68,0.1)' : 'rgba(16,185,129,0.1)'};color:{fin_cost_mtd[0].ops_mtd > 15 ? '#ef4444' : '#10b981'};">{fin_cost_mtd[0].ops_mtd > 15 ? '⚠ Lewat target' : '✓ Normal'}</span>
      <span style="font-size:10.5px;color:{fin_cost_mtd[0].delta_ops > 0 ? '#ef4444' : fin_cost_mtd[0].delta_ops < 0 ? '#10b981' : 'var(--color-text-tertiary)'};">
        {fin_cost_mtd[0].delta_ops > 0 ? '▲' : fin_cost_mtd[0].delta_ops < 0 ? '▼' : '—'} {Math.abs(fin_cost_mtd[0].delta_ops)}pp vs {fin_nama_bulan[0].nama_bulan_lalu}
      </span>
    </div>
  </div>

</div>

{#if fin_cost_mtd[0].bahan_mtd > 32 || fin_cost_mtd[0].sdm_mtd > 22 || fin_cost_mtd[0].ops_mtd > 15}
<details>
<summary>📋 Langkah konkret untuk komponen yang melampaui target</summary>
<div class="acc-body">

{#if fin_cost_mtd[0].bahan_mtd > 32}
**🥩 Bahan {fin_cost_mtd[0].bahan_mtd}% — di atas target 32%**

{fin_kpi_mtd[0].hari_berjalan} hari data bulan ini adalah leverage negosiasi yang kuat. Buka halaman [Inventori](/03-inventori-stok) untuk tahu item mana yang paling mahal, negosiasi ulang harga supplier, dan cek rasio beli/pakai per cabang.
{/if}

{#if fin_cost_mtd[0].sdm_mtd > 22}
**👤 SDM {fin_cost_mtd[0].sdm_mtd}% — di atas target 22%**

SDM% tinggi di awal bulan biasanya scheduling tidak efisien atau overtime menumpuk. Buka halaman [Performa Pegawai](/07-employee-performance) dan cek distribusi jam kerja per shift dan per cabang.
{/if}

{#if fin_cost_mtd[0].ops_mtd > 15}
**🏢 Operasional {fin_cost_mtd[0].ops_mtd}% — di atas target 15%**

Biaya ops sebagian besar fixed. Bandingkan ops% antar cabang di halaman [Performa Cabang](/02-branch-performance) — cabang dengan ops% jauh di atas rata-rata mungkin punya kontrak yang tidak efisien.
{/if}

</div>
</details>
{/if}

---

<!-- TREN NET MARGIN HARIAN MTD -->
<div style="margin:0 0 8px;">
  <div style="font-size:10.5px;font-weight:700;letter-spacing:0.13em;text-transform:uppercase;color:var(--color-text-tertiary);margin-bottom:2px;">Tren Net Margin Harian — {fin_nama_bulan[0].nama_bulan}</div>
  <div style="font-size:0.8em;color:var(--color-text-tertiary);">Apakah margin konsisten sepanjang bulan, atau ada minggu tertentu yang jadi outlier?</div>
</div>

<LineChart
    data={fin_margin_daily_mtd}
    x="metric_date"
    y="margin_pct"
    title="Net Margin Harian — {fin_nama_bulan[0].nama_bulan} (%)"
    yFmt="0.0\%"
    xAxisTitle="Tanggal"
    yAxisTitle="Net Margin (%)"
>
    <ReferenceLine y={15} label="Target 15%" lineType="dashed" color="green" />
    <ReferenceLine y={10} label="Kritis 10%" lineType="dashed" color="red" />
</LineChart>

---

<!-- MARGIN PER CABANG MTD -->
<div style="margin:0 0 8px;">
  <div style="font-size:10.5px;font-weight:700;letter-spacing:0.13em;text-transform:uppercase;color:var(--color-text-tertiary);margin-bottom:2px;">Margin per Cabang — {fin_nama_bulan[0].nama_bulan}</div>
  <div style="font-size:0.8em;color:var(--color-text-tertiary);">Dibandingkan bulan {fin_nama_bulan[0].nama_bulan_lalu} — detail ada di halaman <a href="/02-branch-performance">Performa Cabang</a>.</div>
</div>

<DataTable data={fin_branch_mtd}>
    <Column id="branch_name"  title="Cabang"/>
    <Column id="gross"        title="Gross Rev (Rp)"   fmt="#,##0"/>
    <Column id="net"          title="Net Rev (Rp)"     fmt="#,##0"/>
    <Column id="margin_pct"   title="Margin (%)"       fmt="0.0\%"/>
    <Column id="margin_prev"  title="{fin_nama_bulan[0].nama_bulan_lalu} (%)" fmt="0.0\%"/>
    <Column id="delta"        title="Δ (pp)"           fmt="+0.0;-0.0" contentType="delta"/>
    <Column id="status"       title="Status"/>
</DataTable>

<div style="text-align:right;font-size:0.82em;margin-top:8px;color:var(--color-text-tertiary);">
  → <a href="/02-branch-performance">Lihat analisis lengkap per cabang (revenue, AOV, tren)</a>
</div>

---

{:else if inputs.period === '30d'}

```sql fin_margin_daily_30d
WITH max_d AS (SELECT MAX(metric_date)::DATE AS d FROM restaurant.daily_net_revenue)
SELECT
    metric_date,
    ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS margin_pct
FROM restaurant.daily_net_revenue CROSS JOIN max_d
WHERE metric_date >= d - INTERVAL '29 days'
GROUP BY metric_date
ORDER BY metric_date
```

<!-- ════════════════════════════════════════════════ -->
<!-- HEADER -->
<!-- ════════════════════════════════════════════════ -->

<div style="margin:28px 0 20px;">
  <div style="font-size:10.5px;font-weight:700;letter-spacing:0.13em;text-transform:uppercase;color:var(--color-text-tertiary);margin-bottom:5px;">Laporan Keuangan · 30 Hari Terakhir</div>
  <div style="font-size:1.35em;font-weight:800;color:var(--color-text-primary);letter-spacing:-0.01em;">{fin_dates[0].tgl_30d_awal} – {fin_dates[0].tgl_akhir}</div>
  <div style="font-size:0.82em;color:var(--color-text-tertiary);margin-top:3px;">Dari setiap Rp100 yang masuk — berapa yang benar-benar tersisa?</div>
</div>

<!-- ════════════════════════════════════════════════ -->
<!-- HEADLINE METRICS -->
<!-- ════════════════════════════════════════════════ -->

<BigValue data={fin_kpi} value="gross_30d"    title="Gross Revenue (Rp)"  fmt="#,##0"  comparison="gross_prev30d"  comparisonTitle="30 hari sebelumnya" />
<BigValue data={fin_kpi} value="net_30d"      title="Net Revenue (Rp)"    fmt="#,##0" />
<BigValue data={fin_kpi} value="margin_30d"   title="Net Margin"          fmt="0.0\%"  comparison="margin_prev30d" comparisonTitle="30 hari sebelumnya" />
<BigValue data={fin_kpi} value="biaya_30d"    title="Total Biaya (Rp)"    fmt="#,##0"  comparison="biaya_prev30d"  comparisonTitle="30 hari sebelumnya" />

<!-- STATUS BANNER -->
{#if fin_kpi[0].margin_30d >= 15}
  {#if fin_kpi[0].pct_change_gross_30d > 3 && fin_kpi[0].delta_margin_30d < -1}
<div style="background:linear-gradient(135deg,rgba(245,158,11,0.07),rgba(245,158,11,0.03));border:1px solid rgba(245,158,11,0.3);border-left:4px solid #f59e0b;border-radius:10px;padding:14px 18px;margin:16px 0;display:flex;align-items:flex-start;gap:12px;">
<span style="font-size:1.2em;flex-shrink:0;margin-top:1px;">⚠️</span>
<div>
<div style="font-weight:700;font-size:0.93em;color:#92400e;margin-bottom:3px;">Margin {fin_kpi[0].margin_30d}% — Sehat, tapi ada paradoks yang perlu dicermati</div>
<div style="font-size:0.85em;color:#78350f;line-height:1.65;">Revenue naik <strong>{fin_kpi[0].pct_change_gross_30d}%</strong> tapi margin justru turun <strong>{Math.abs(fin_kpi[0].delta_margin_30d)}pp</strong>. Margin terjaga bukan karena efisiensi — biaya tumbuh lebih cepat dari omset. Lihat breakdown komponen biaya di bawah.</div>
</div>
</div>
  {:else if fin_kpi[0].delta_margin_30d >= 1}
<div style="background:linear-gradient(135deg,rgba(16,185,129,0.07),rgba(16,185,129,0.03));border:1px solid rgba(16,185,129,0.22);border-left:4px solid #10b981;border-radius:10px;padding:14px 18px;margin:16px 0;display:flex;align-items:flex-start;gap:12px;">
<span style="font-size:1.2em;flex-shrink:0;margin-top:1px;">✅</span>
<div>
<div style="font-weight:700;font-size:0.93em;color:#065f46;margin-bottom:3px;">Margin {fin_kpi[0].margin_30d}% — Sehat dan membaik (+{fin_kpi[0].delta_margin_30d}pp vs bulan lalu)</div>
<div style="font-size:0.85em;color:#064e3b;line-height:1.65;">Tren positif. Scroll ke bawah untuk memastikan tidak ada komponen biaya yang mulai merayap naik diam-diam.</div>
</div>
</div>
  {:else}
<div style="background:linear-gradient(135deg,rgba(16,185,129,0.07),rgba(16,185,129,0.03));border:1px solid rgba(16,185,129,0.22);border-left:4px solid #10b981;border-radius:10px;padding:14px 18px;margin:16px 0;display:flex;align-items:flex-start;gap:12px;">
<span style="font-size:1.2em;flex-shrink:0;margin-top:1px;">✅</span>
<div>
<div style="font-weight:700;font-size:0.93em;color:#065f46;margin-bottom:3px;">Margin {fin_kpi[0].margin_30d}% — Sehat ({fin_kpi[0].delta_margin_30d > 0 ? '+' : ''}{fin_kpi[0].delta_margin_30d}pp vs bulan lalu)</div>
<div style="font-size:0.85em;color:#064e3b;line-height:1.65;">Stabil dalam target 15–20%. Cek komponen biaya di bawah untuk deteksi risiko lebih awal.</div>
</div>
</div>
  {/if}
{:else if fin_kpi[0].margin_30d >= 10}
<div style="background:linear-gradient(135deg,rgba(245,158,11,0.07),rgba(245,158,11,0.03));border:1px solid rgba(245,158,11,0.3);border-left:4px solid #f59e0b;border-radius:10px;padding:14px 18px;margin:16px 0;display:flex;align-items:flex-start;gap:12px;">
<span style="font-size:1.2em;flex-shrink:0;margin-top:1px;">⚠️</span>
<div>
<div style="font-weight:700;font-size:0.93em;color:#92400e;margin-bottom:3px;">Margin {fin_kpi[0].margin_30d}% — Di bawah target selama 30 hari penuh</div>
<div style="font-size:0.85em;color:#78350f;line-height:1.65;">Ini sudah bukan fluktuasi harian. Ada pola struktural yang menekan margin — identifikasi komponen penyebab di bawah dan ambil langkah konkret.</div>
</div>
</div>
{:else}
<div style="background:linear-gradient(135deg,rgba(239,68,68,0.07),rgba(239,68,68,0.03));border:1px solid rgba(239,68,68,0.25);border-left:4px solid #ef4444;border-radius:10px;padding:14px 18px;margin:16px 0;display:flex;align-items:flex-start;gap:12px;">
<span style="font-size:1.2em;flex-shrink:0;margin-top:1px;">🔴</span>
<div>
<div style="font-weight:700;font-size:0.93em;color:#7f1d1d;margin-bottom:3px;">Margin {fin_kpi[0].margin_30d}% — Kritis secara struktural</div>
<div style="font-size:0.85em;color:#7f1d1d;line-height:1.65;">30 hari margin di bawah 10% adalah bukti yang tidak bisa diabaikan. Perlu evaluasi menyeluruh — bukan optimasi kecil.</div>
</div>
</div>
{/if}

---

<!-- ════════════════════════════════════════════════ -->
<!-- EARLY WARNING (hanya muncul jika ada yg melebihi target) -->
<!-- ════════════════════════════════════════════════ -->

{#if fin_cost_pct[0].ops_30d > 15 || fin_cost_pct[0].bahan_30d > 32 || fin_cost_pct[0].sdm_30d > 22}

<div style="background:linear-gradient(135deg,rgba(99,102,241,0.06),rgba(139,92,246,0.03));border:1px solid rgba(99,102,241,0.2);border-radius:12px;padding:20px 22px;margin:4px 0 24px;">

  <div style="display:flex;align-items:center;gap:10px;margin-bottom:14px;">
    <div style="width:30px;height:30px;background:rgba(99,102,241,0.12);border-radius:8px;display:flex;align-items:center;justify-content:center;font-size:15px;flex-shrink:0;">🔍</div>
    <div>
      <div style="font-size:10.5px;font-weight:700;letter-spacing:0.1em;text-transform:uppercase;color:#6366f1;">Early Warning — Deteksi Sebelum Margin Bermasalah</div>
      <div style="font-size:0.8em;color:var(--color-text-tertiary);margin-top:1px;">Komponen biaya berikut sudah melampaui batas target industri F&B</div>
    </div>
  </div>

  <div style="display:flex;flex-direction:column;gap:7px;margin-bottom:16px;">
    {#if fin_cost_pct[0].ops_30d > 15}
    <div style="display:flex;align-items:center;gap:10px;padding:10px 13px;background:rgba(239,68,68,0.05);border:1px solid rgba(239,68,68,0.18);border-radius:8px;font-size:0.86em;">
      <span style="font-size:1em;flex-shrink:0;">🏢</span>
      <div style="flex:1;line-height:1.5;">
        <strong>Biaya Operasional {fin_cost_pct[0].ops_30d}%</strong> — target ≤15%, sudah +{Math.round((fin_cost_pct[0].ops_30d - 15) * 10) / 10}pp di atas batas
        {#if fin_cost_pct[0].delta_ops_30d > 0}<span style="color:#ef4444;font-size:0.9em;"> · naik {fin_cost_pct[0].delta_ops_30d}pp vs bulan lalu</span>{/if}
      </div>
    </div>
    {/if}
    {#if fin_cost_pct[0].bahan_30d > 32}
    <div style="display:flex;align-items:center;gap:10px;padding:10px 13px;background:rgba(245,158,11,0.05);border:1px solid rgba(245,158,11,0.22);border-radius:8px;font-size:0.86em;">
      <span style="font-size:1em;flex-shrink:0;">🥩</span>
      <div style="flex:1;line-height:1.5;">
        <strong>Biaya Bahan {fin_cost_pct[0].bahan_30d}%</strong> — target ≤32%, sudah +{Math.round((fin_cost_pct[0].bahan_30d - 32) * 10) / 10}pp di atas batas
        {#if fin_cost_pct[0].delta_bahan_30d > 0}<span style="color:#f59e0b;font-size:0.9em;"> · naik {fin_cost_pct[0].delta_bahan_30d}pp vs bulan lalu</span>{/if}
      </div>
    </div>
    {/if}
    {#if fin_cost_pct[0].sdm_30d > 22}
    <div style="display:flex;align-items:center;gap:10px;padding:10px 13px;background:rgba(245,158,11,0.05);border:1px solid rgba(245,158,11,0.22);border-radius:8px;font-size:0.86em;">
      <span style="font-size:1em;flex-shrink:0;">👤</span>
      <div style="flex:1;line-height:1.5;">
        <strong>Biaya SDM {fin_cost_pct[0].sdm_30d}%</strong> — target ≤22%, sudah +{Math.round((fin_cost_pct[0].sdm_30d - 22) * 10) / 10}pp di atas batas
        {#if fin_cost_pct[0].delta_sdm_30d > 0}<span style="color:#f59e0b;font-size:0.9em;"> · naik {fin_cost_pct[0].delta_sdm_30d}pp vs bulan lalu</span>{/if}
      </div>
    </div>
    {/if}
  </div>

  <div style="background:rgba(99,102,241,0.07);border-radius:8px;padding:12px 15px;">
    <div style="font-size:10.5px;font-weight:700;letter-spacing:0.08em;text-transform:uppercase;color:#4338ca;margin-bottom:6px;">📐 Skenario: Jika gross revenue turun 10% bulan depan</div>
    <div style="font-size:0.84em;color:var(--color-text-secondary);line-height:1.7;">
      Dengan struktur biaya saat ini (Rp {Math.round(fin_kpi[0].biaya_30d / 1000000 * 10) / 10}jt), margin akan turun ke sekitar
      <strong>~{Math.round((fin_kpi[0].gross_30d * 0.9 - fin_kpi[0].biaya_30d) / (fin_kpi[0].gross_30d * 0.9) * 100 * 10) / 10}%</strong>.
      {#if Math.round((fin_kpi[0].gross_30d * 0.9 - fin_kpi[0].biaya_30d) / (fin_kpi[0].gross_30d * 0.9) * 100 * 10) / 10 >= 15}
      Masih sehat — tapi makin tipis. Perbaiki struktur biaya sebelum butuh diperbaiki terpaksa.
      {:else if Math.round((fin_kpi[0].gross_30d * 0.9 - fin_kpi[0].biaya_30d) / (fin_kpi[0].gross_30d * 0.9) * 100 * 10) / 10 >= 10}
      Masuk <strong>zona waspada</strong>. Ini momentum yang tepat untuk mulai efisiensi — sebelum situasinya memaksa.
      {:else}
      Masuk <strong>zona kritis</strong>. Bisnis tidak punya buffer yang cukup menghadapi penurunan revenue. Perlu tindakan sekarang.
      {/if}
    </div>
  </div>

</div>

{/if}

<!-- ════════════════════════════════════════════════ -->
<!-- KOMPOSISI BIAYA — 3 CARDS -->
<!-- ════════════════════════════════════════════════ -->

<div style="margin:0 0 8px;">
  <div style="font-size:10.5px;font-weight:700;letter-spacing:0.13em;text-transform:uppercase;color:var(--color-text-tertiary);margin-bottom:2px;">Komposisi Biaya</div>
  <div style="font-size:0.8em;color:var(--color-text-tertiary);">Dari setiap Rp100 gross revenue — berapa yang habis di tiap pos?</div>
</div>

<div style="display:grid;grid-template-columns:repeat(3,1fr);gap:12px;margin:10px 0 28px;">

  <!-- ── CARD BAHAN ── -->
  <div style="background:var(--color-background-secondary);border:1px solid {fin_cost_pct[0].bahan_30d > 32 ? 'rgba(239,68,68,0.3)' : 'var(--color-border-tertiary)'};border-radius:12px;padding:18px 18px 14px;position:relative;overflow:hidden;">
    <div style="position:absolute;top:0;left:0;right:0;height:3px;background:{fin_cost_pct[0].bahan_30d > 32 ? 'linear-gradient(90deg,#ef4444,#fca5a5)' : 'linear-gradient(90deg,#10b981,#6ee7b7)'};"></div>

    <div style="font-size:10px;font-weight:700;letter-spacing:0.08em;text-transform:uppercase;color:var(--color-text-tertiary);margin-bottom:10px;display:flex;align-items:center;gap:5px;">🥩 Biaya Bahan</div>

    <div style="display:flex;align-items:baseline;gap:5px;margin-bottom:2px;">
      <span style="font-size:2.1em;font-weight:900;letter-spacing:-0.03em;color:{fin_cost_pct[0].bahan_30d > 32 ? '#ef4444' : '#10b981'};">{fin_cost_pct[0].bahan_30d}%</span>
    </div>
    <div style="font-size:11px;color:var(--color-text-tertiary);margin-bottom:10px;">target ≤32%</div>

    <!-- progress bar -->
    <div style="height:6px;background:rgba(0,0,0,0.07);border-radius:3px;position:relative;overflow:visible;margin-bottom:3px;">
      <div style="height:100%;border-radius:3px;background:{fin_cost_pct[0].bahan_30d > 32 ? 'linear-gradient(90deg,#ef4444,#fca5a5)' : 'linear-gradient(90deg,#10b981,#6ee7b7)'};width:{Math.min(fin_cost_pct[0].bahan_30d / 40 * 100, 100)}%;"></div>
      <div style="position:absolute;top:-2px;bottom:-2px;left:{32/40*100}%;width:2px;background:rgba(0,0,0,0.18);border-radius:1px;"></div>
    </div>
    <div style="display:flex;justify-content:space-between;font-size:10px;color:var(--color-text-tertiary);margin-bottom:12px;"><span>0%</span><span>⬆ target 32%</span><span>40%</span></div>

    <div style="display:flex;justify-content:space-between;align-items:center;padding-top:10px;border-top:1px solid var(--color-border-tertiary);">
      <span style="font-size:10.5px;padding:2px 8px;border-radius:10px;font-weight:700;background:{fin_cost_pct[0].bahan_30d > 32 ? 'rgba(239,68,68,0.1)' : 'rgba(16,185,129,0.1)'};color:{fin_cost_pct[0].bahan_30d > 32 ? '#ef4444' : '#10b981'};">{fin_cost_pct[0].bahan_30d > 32 ? '⚠ Lewat target' : '✓ Normal'}</span>
      <span style="font-size:10.5px;color:{fin_cost_pct[0].delta_bahan_30d > 0 ? '#ef4444' : fin_cost_pct[0].delta_bahan_30d < 0 ? '#10b981' : 'var(--color-text-tertiary)'};">
        {fin_cost_pct[0].delta_bahan_30d > 0 ? '▲' : fin_cost_pct[0].delta_bahan_30d < 0 ? '▼' : '—'} {Math.abs(fin_cost_pct[0].delta_bahan_30d)}pp
      </span>
    </div>
  </div>

  <!-- ── CARD SDM ── -->
  <div style="background:var(--color-background-secondary);border:1px solid {fin_cost_pct[0].sdm_30d > 22 ? 'rgba(245,158,11,0.35)' : 'var(--color-border-tertiary)'};border-radius:12px;padding:18px 18px 14px;position:relative;overflow:hidden;">
    <div style="position:absolute;top:0;left:0;right:0;height:3px;background:{fin_cost_pct[0].sdm_30d > 22 ? 'linear-gradient(90deg,#f59e0b,#fde68a)' : 'linear-gradient(90deg,#10b981,#6ee7b7)'};"></div>

    <div style="font-size:10px;font-weight:700;letter-spacing:0.08em;text-transform:uppercase;color:var(--color-text-tertiary);margin-bottom:10px;display:flex;align-items:center;gap:5px;">👤 Biaya SDM</div>

    <div style="display:flex;align-items:baseline;gap:5px;margin-bottom:2px;">
      <span style="font-size:2.1em;font-weight:900;letter-spacing:-0.03em;color:{fin_cost_pct[0].sdm_30d > 22 ? '#f59e0b' : '#10b981'};">{fin_cost_pct[0].sdm_30d}%</span>
    </div>
    <div style="font-size:11px;color:var(--color-text-tertiary);margin-bottom:10px;">target ≤22%</div>

    <div style="height:6px;background:rgba(0,0,0,0.07);border-radius:3px;position:relative;overflow:visible;margin-bottom:3px;">
      <div style="height:100%;border-radius:3px;background:{fin_cost_pct[0].sdm_30d > 22 ? 'linear-gradient(90deg,#f59e0b,#fde68a)' : 'linear-gradient(90deg,#10b981,#6ee7b7)'};width:{Math.min(fin_cost_pct[0].sdm_30d / 30 * 100, 100)}%;"></div>
      <div style="position:absolute;top:-2px;bottom:-2px;left:{22/30*100}%;width:2px;background:rgba(0,0,0,0.18);border-radius:1px;"></div>
    </div>
    <div style="display:flex;justify-content:space-between;font-size:10px;color:var(--color-text-tertiary);margin-bottom:12px;"><span>0%</span><span>⬆ target 22%</span><span>30%</span></div>

    <div style="display:flex;justify-content:space-between;align-items:center;padding-top:10px;border-top:1px solid var(--color-border-tertiary);">
      <span style="font-size:10.5px;padding:2px 8px;border-radius:10px;font-weight:700;background:{fin_cost_pct[0].sdm_30d > 22 ? 'rgba(245,158,11,0.1)' : 'rgba(16,185,129,0.1)'};color:{fin_cost_pct[0].sdm_30d > 22 ? '#f59e0b' : '#10b981'};">{fin_cost_pct[0].sdm_30d > 22 ? '⚠ Lewat target' : '✓ Normal'}</span>
      <span style="font-size:10.5px;color:{fin_cost_pct[0].delta_sdm_30d > 0 ? '#ef4444' : fin_cost_pct[0].delta_sdm_30d < 0 ? '#10b981' : 'var(--color-text-tertiary)'};">
        {fin_cost_pct[0].delta_sdm_30d > 0 ? '▲' : fin_cost_pct[0].delta_sdm_30d < 0 ? '▼' : '—'} {Math.abs(fin_cost_pct[0].delta_sdm_30d)}pp
      </span>
    </div>
  </div>

  <!-- ── CARD OPERASIONAL ── -->
  <div style="background:var(--color-background-secondary);border:1px solid {fin_cost_pct[0].ops_30d > 15 ? 'rgba(239,68,68,0.3)' : 'var(--color-border-tertiary)'};border-radius:12px;padding:18px 18px 14px;position:relative;overflow:hidden;">
    <div style="position:absolute;top:0;left:0;right:0;height:3px;background:{fin_cost_pct[0].ops_30d > 15 ? 'linear-gradient(90deg,#ef4444,#fca5a5)' : 'linear-gradient(90deg,#10b981,#6ee7b7)'};"></div>

    <div style="font-size:10px;font-weight:700;letter-spacing:0.08em;text-transform:uppercase;color:var(--color-text-tertiary);margin-bottom:10px;display:flex;align-items:center;gap:5px;">🏢 Biaya Ops</div>

    <div style="display:flex;align-items:baseline;gap:5px;margin-bottom:2px;">
      <span style="font-size:2.1em;font-weight:900;letter-spacing:-0.03em;color:{fin_cost_pct[0].ops_30d > 15 ? '#ef4444' : '#10b981'};">{fin_cost_pct[0].ops_30d}%</span>
    </div>
    <div style="font-size:11px;color:var(--color-text-tertiary);margin-bottom:10px;">target ≤15%</div>

    <div style="height:6px;background:rgba(0,0,0,0.07);border-radius:3px;position:relative;overflow:visible;margin-bottom:3px;">
      <div style="height:100%;border-radius:3px;background:{fin_cost_pct[0].ops_30d > 15 ? 'linear-gradient(90deg,#ef4444,#fca5a5)' : 'linear-gradient(90deg,#10b981,#6ee7b7)'};width:{Math.min(fin_cost_pct[0].ops_30d / 25 * 100, 100)}%;"></div>
      <div style="position:absolute;top:-2px;bottom:-2px;left:{15/25*100}%;width:2px;background:rgba(0,0,0,0.18);border-radius:1px;"></div>
    </div>
    <div style="display:flex;justify-content:space-between;font-size:10px;color:var(--color-text-tertiary);margin-bottom:12px;"><span>0%</span><span>⬆ target 15%</span><span>25%</span></div>

    <div style="display:flex;justify-content:space-between;align-items:center;padding-top:10px;border-top:1px solid var(--color-border-tertiary);">
      <span style="font-size:10.5px;padding:2px 8px;border-radius:10px;font-weight:700;background:{fin_cost_pct[0].ops_30d > 15 ? 'rgba(239,68,68,0.1)' : 'rgba(16,185,129,0.1)'};color:{fin_cost_pct[0].ops_30d > 15 ? '#ef4444' : '#10b981'};">{fin_cost_pct[0].ops_30d > 15 ? '⚠ Lewat target' : '✓ Normal'}</span>
      <span style="font-size:10.5px;color:{fin_cost_pct[0].delta_ops_30d > 0 ? '#ef4444' : fin_cost_pct[0].delta_ops_30d < 0 ? '#10b981' : 'var(--color-text-tertiary)'};">
        {fin_cost_pct[0].delta_ops_30d > 0 ? '▲' : fin_cost_pct[0].delta_ops_30d < 0 ? '▼' : '—'} {Math.abs(fin_cost_pct[0].delta_ops_30d)}pp
      </span>
    </div>
  </div>

</div>

<!-- Langkah konkret per komponen yang bermasalah -->
{#if fin_cost_pct[0].bahan_30d > 32 || fin_cost_pct[0].sdm_30d > 22 || fin_cost_pct[0].ops_30d > 15}
<details>
<summary>📋 Langkah konkret untuk komponen yang melampaui target</summary>
<div class="acc-body">

{#if fin_cost_pct[0].bahan_30d > 32}
**🥩 Bahan {fin_cost_pct[0].bahan_30d}% — di atas target 32%**

30 hari data adalah leverage yang kuat. Tiga langkah: (1) buka halaman [Inventori](/03-inventori-stok) untuk tahu item mana yang paling mahal, (2) negosiasi ulang harga supplier — tunjukkan data tren 30 hari ini, (3) cek rasio beli/pakai per cabang — mana yang paling boros?

{/if}
{#if fin_cost_pct[0].sdm_30d > 22}
**👤 SDM {fin_cost_pct[0].sdm_30d}% — di atas target 22%**

SDM% tinggi selama sebulan bukan soal gaji terlalu besar — melainkan scheduling tidak efisien. Buka halaman [Performa Pegawai](/07-employee-performance) dan cek: apakah ada shift yang konsisten overtime? Apakah staf di hari sepi sama jumlahnya dengan hari ramai?

{/if}
{#if fin_cost_pct[0].ops_30d > 15}
**🏢 Operasional {fin_cost_pct[0].ops_30d}% — di atas target 15%**

Biaya ops sebagian besar fixed — sulit ditekan instan. Tapi 30 hari data ini adalah argumen renegosiasi: (1) review kontrak sewa dengan track record ini, (2) audit konsumsi listrik di luar jam operasional, (3) bandingkan ops% antar cabang di halaman [Performa Cabang](/02-branch-performance) — ada yang boros kontrak.

{/if}
</div>
</details>
{/if}

---

<!-- ════════════════════════════════════════════════ -->
<!-- TREN NET MARGIN HARIAN -->
<!-- ════════════════════════════════════════════════ -->

<div style="margin:0 0 8px;">
  <div style="font-size:10.5px;font-weight:700;letter-spacing:0.13em;text-transform:uppercase;color:var(--color-text-tertiary);margin-bottom:2px;">Tren Net Margin Harian</div>
  <div style="font-size:0.8em;color:var(--color-text-tertiary);">Apakah margin bergerak konsisten atau fluktuatif? Garis merah putus-putus = target 15%.</div>
</div>

<LineChart
    data={fin_margin_daily_30d}
    x="metric_date"
    y="margin_pct"
    title="Net Margin Harian — 30 Hari (%)"
    yFmt="0.0\%"
    xAxisTitle="Tanggal"
    yAxisTitle="Net Margin (%)"
>
    <ReferenceLine y={15} label="Target 15%" lineType="dashed" color="green" />
    <ReferenceLine y={10} label="Kritis 10%" lineType="dashed" color="red" />
</LineChart>

---

<!-- ════════════════════════════════════════════════ -->
<!-- PERFORMA CABANG — RINGKAS -->
<!-- ════════════════════════════════════════════════ -->

<div style="margin:0 0 8px;">
  <div style="font-size:10.5px;font-weight:700;letter-spacing:0.13em;text-transform:uppercase;color:var(--color-text-tertiary);margin-bottom:2px;">Margin per Cabang</div>
  <div style="font-size:0.8em;color:var(--color-text-tertiary);">Ringkasan 30 hari — detail ada di halaman <a href="/02-branch-performance">Performa Cabang</a>.</div>
</div>

{#if fin_branch_30d_gap[0].gap > 5}
<div style="background:rgba(245,158,11,0.05);border:1px solid rgba(245,158,11,0.22);border-radius:8px;padding:11px 14px;margin:8px 0 12px;font-size:0.86em;display:flex;align-items:center;gap:10px;">
  <span>📊</span>
  <span>Gap margin antar cabang <strong>{fin_branch_30d_gap[0].gap}pp</strong> — {fin_branch_30d_gap[0].cabang_terbaik} ({fin_branch_30d_gap[0].margin_max}%) vs {fin_branch_30d_gap[0].cabang_terlemah} ({fin_branch_30d_gap[0].margin_min}%). Gap di atas 5pp biasanya sinyal inefisiensi struktural di cabang terlemah.</span>
</div>
{:else}
<div style="background:rgba(16,185,129,0.05);border:1px solid rgba(16,185,129,0.2);border-radius:8px;padding:11px 14px;margin:8px 0 12px;font-size:0.86em;display:flex;align-items:center;gap:10px;">
  <span>✅</span>
  <span>Gap margin antar cabang hanya <strong>{fin_branch_30d_gap[0].gap}pp</strong> — performa merata, tidak ada yang jauh tertinggal.</span>
</div>
{/if}

{#if fin_branch_30d_gap[0].jumlah_kritis > 0}
<div style="background:rgba(239,68,68,0.05);border:1px solid rgba(239,68,68,0.2);border-radius:8px;padding:11px 14px;margin:8px 0 12px;font-size:0.86em;display:flex;align-items:center;gap:10px;">
  <span>🔴</span>
  <strong>{fin_branch_30d_gap[0].jumlah_kritis} cabang kritis</strong>&nbsp;(margin di bawah 10%) — perlu evaluasi biaya segera.
</div>
{/if}

<DataTable data={fin_branch_30d}>
    <Column id="branch_name"  title="Cabang"/>
    <Column id="gross"        title="Gross Rev (Rp)"    fmt="#,##0"/>
    <Column id="net"          title="Net Rev (Rp)"      fmt="#,##0"/>
    <Column id="margin_pct"   title="Margin (%)"        fmt="0.0\%"/>
    <Column id="margin_prev"  title="Bln Lalu (%)"      fmt="0.0\%"/>
    <Column id="delta"        title="Δ (pp)"            fmt="+0.0;-0.0" contentType="delta"/>
    <Column id="status"       title="Status"/>
</DataTable>

<div style="text-align:right;font-size:0.82em;margin-top:8px;color:var(--color-text-tertiary);">
  → <a href="/02-branch-performance">Lihat analisis lengkap per cabang (revenue, AOV, tren)</a>
</div>

---

{:else if inputs.period === '90d'}

## 90 Hari Terakhir (3 Bulan) — {fin_dates[0].tgl_90d_awal} – {fin_dates[0].tgl_akhir}

_Sudut pandang strategis. Bukan lagi "kenapa kemarin turun?" — tapi "apakah bisnis ini bergerak ke arah yang benar?"_

### Lapis 1 — Headline Margin

<BigValue data={fin_kpi} value="margin_90d"   title="Net Margin 90 Hari (%)"  fmt="0.0\%"  comparison="margin_prev90d" comparisonTitle="90 hari sebelumnya" />
<BigValue data={fin_kpi} value="gross_90d"    title="Gross Revenue (Rp)"      fmt="#,##0"  comparison="gross_prev90d"  comparisonTitle="90 hari sebelumnya" />
<BigValue data={fin_kpi} value="net_90d"      title="Net Revenue (Rp)"        fmt="#,##0" />
<BigValue data={fin_kpi} value="biaya_90d"    title="Total Biaya (Rp)"        fmt="#,##0"  comparison="biaya_prev90d"  comparisonTitle="90 hari sebelumnya" />

{#if fin_kpi[0].margin_90d >= 15}
  {#if fin_kpi[0].pct_change_gross_90d > 5 && -1 > fin_kpi[0].delta_margin_90d}
<div style="background:rgba(248,201,0,0.1);border-left:4px solid #f8c900;padding:12px 16px;border-radius:6px;margin:16px 0;">
✅ Margin {fin_kpi[0].margin_90d}% — masih sehat, tapi ada paradoks penting.<br/>
<strong>Revenue tumbuh {fin_kpi[0].pct_change_gross_90d}% dalam 3 bulan, tapi margin turun {fin_kpi[0].delta_margin_90d}pp.</strong> Bisnis tumbuh tapi semakin tidak efisien — biaya tumbuh lebih cepat dari omset. Masalah struktural yang perlu diaddress.
</div>
  {:else if fin_kpi[0].delta_margin_90d >= 1}
<div style="background:rgba(22,163,74,0.08);border-left:4px solid #16a34a;padding:12px 16px;border-radius:6px;margin:16px 0;">
✅ <strong>Margin {fin_kpi[0].margin_90d}% — sehat dan ada perbaikan struktural</strong> (+{fin_kpi[0].delta_margin_90d}pp vs 3 bulan sebelumnya). Tren positif yang konsisten.
</div>
  {:else}
<div style="background:rgba(22,163,74,0.08);border-left:4px solid #16a34a;padding:12px 16px;border-radius:6px;margin:16px 0;">
✅ <strong>Margin {fin_kpi[0].margin_90d}% — sehat</strong> ({fin_kpi[0].delta_margin_90d}pp vs 3 bulan sebelumnya). Stabil dalam target.
</div>
  {/if}
{:else if fin_kpi[0].margin_90d >= 10}
<div style="background:rgba(248,201,0,0.1);border-left:4px solid #f8c900;padding:12px 16px;border-radius:6px;margin:16px 0;">
⚠️ <strong>Margin {fin_kpi[0].margin_90d}% — perhatian selama 3 bulan berturut-turut.</strong><br/>
Ini bukan fluktuasi. Ada masalah struktural — entah di sisi biaya atau di sisi pricing.
</div>
{:else}
<div style="background:rgba(220,38,38,0.08);border-left:4px solid #dc2626;padding:12px 16px;border-radius:6px;margin:16px 0;">
🔴 <strong>Margin {fin_kpi[0].margin_90d}% — kritis secara struktural.</strong> 3 bulan data adalah bukti yang tidak bisa diabaikan.
</div>
{/if}

---

### Lapis 2 — Bedah Komponen Biaya

<details>
<summary>🥩 Biaya Bahan — {fin_cost_pct[0].bahan_90d}% dari gross revenue (target ≤32%)</summary>
<div class="acc-body">

{#if fin_cost_pct[0].bahan_90d > 32}
<div style="background:rgba(220,38,38,0.08);border-left:4px solid #dc2626;padding:10px 14px;border-radius:6px;margin-bottom:12px;">
⚠️ Di atas target selama 3 bulan ({fin_cost_pct[0].delta_bahan_90d > 0 ? 'naik' : 'turun'} {Math.abs(fin_cost_pct[0].delta_bahan_90d)}pp vs 3 bulan sebelumnya). Pola struktural.
</div>
{:else}
<div style="background:rgba(22,163,74,0.08);border-left:4px solid #16a34a;padding:10px 14px;border-radius:6px;margin-bottom:12px;">
✅ Dalam target. vs 3 bulan sebelumnya: {fin_cost_pct[0].bahan_p90d}% → {fin_cost_pct[0].bahan_90d}% ({fin_cost_pct[0].delta_bahan_90d > 0 ? '+' : ''}{fin_cost_pct[0].delta_bahan_90d}pp)
</div>
{/if}

Lever strategis: renegosiasi kontrak supplier (volume 3 bulan = leverage kuat), review pricing menu, standardisasi resep antar cabang.

</div>
</details>

<details>
<summary>👨‍💼 Biaya SDM — {fin_cost_pct[0].sdm_90d}% dari gross revenue (target ≤22%)</summary>
<div class="acc-body">

{#if fin_cost_pct[0].sdm_90d > 22}
<div style="background:rgba(220,38,38,0.08);border-left:4px solid #dc2626;padding:10px 14px;border-radius:6px;margin-bottom:12px;">
⚠️ Di atas target secara konsisten 3 bulan ({fin_cost_pct[0].delta_sdm_90d > 0 ? 'naik' : 'turun'} {Math.abs(fin_cost_pct[0].delta_sdm_90d)}pp vs 3 bulan sebelumnya).
</div>
{:else}
<div style="background:rgba(22,163,74,0.08);border-left:4px solid #16a34a;padding:10px 14px;border-radius:6px;margin-bottom:12px;">
✅ Dalam target. vs 3 bulan sebelumnya: {fin_cost_pct[0].sdm_p90d}% → {fin_cost_pct[0].sdm_90d}% ({fin_cost_pct[0].delta_sdm_90d > 0 ? '+' : ''}{fin_cost_pct[0].delta_sdm_90d}pp)
</div>
{/if}

Lever strategis: audit rasio supervisor:staf, evaluasi hari sepi yang konsisten, cek pola lembur 3 bulan.

</div>
</details>

<details>
<summary>🏢 Biaya Operasional — {fin_cost_pct[0].ops_90d}% dari gross revenue (target ≤15%)</summary>
<div class="acc-body">

{#if fin_cost_pct[0].ops_90d > 15}
<div style="background:rgba(220,38,38,0.08);border-left:4px solid #dc2626;padding:10px 14px;border-radius:6px;margin-bottom:12px;">
⚠️ Di atas target secara konsisten 3 bulan ({fin_cost_pct[0].delta_ops_90d > 0 ? 'naik' : 'turun'} {Math.abs(fin_cost_pct[0].delta_ops_90d)}pp vs 3 bulan sebelumnya).
</div>
{:else}
<div style="background:rgba(22,163,74,0.08);border-left:4px solid #16a34a;padding:10px 14px;border-radius:6px;margin-bottom:12px;">
✅ Dalam target. vs 3 bulan sebelumnya: {fin_cost_pct[0].ops_p90d}% → {fin_cost_pct[0].ops_90d}% ({fin_cost_pct[0].delta_ops_90d > 0 ? '+' : ''}{fin_cost_pct[0].delta_ops_90d}pp)
</div>
{/if}

Lever strategis: renegosiasi kontrak sewa (3 bulan data = track record), audit energi, evaluasi lokasi cabang ops% tinggi.

</div>
</details>

---

### Lapis 3 — Performa per Cabang

<DataTable data={fin_branch_90d}>
    <Column id="branch_name"  title="Cabang"/>
    <Column id="gross"        title="Gross Revenue (Rp)"         fmt="#,##0"/>
    <Column id="net"          title="Net Revenue (Rp)"           fmt="#,##0"/>
    <Column id="margin_pct"   title="Net Margin (%)"             fmt="0.0\%"/>
    <Column id="margin_prev"  title="Margin 3 Bln Lalu (%)"      fmt="0.0\%"/>
    <Column id="delta"        title="Perubahan (pp)"             fmt="+0.0;-0.0" contentType="delta"/>
    <Column id="status"       title="Status"/>
</DataTable>

### Tren Margin Bulanan per Cabang (3 Bulan Terakhir)

<LineChart
    data={fin_branch_monthly}
    x="bulan"
    y="margin_pct"
    series="branch_name"
    title="Tren Net Margin per Cabang — 3 Bulan (%)"
    yFmt="0.0\%"
    xAxisTitle="Bulan"
    yAxisTitle="Net Margin (%)"
/>

_Garis yang terus turun selama 3 bulan berturut-turut di satu cabang adalah sinyal masalah struktural — bukan musiman._

---

{:else if inputs.period === 'quarter'}

## Laporan Quarter

_Perbandingan antar quarter untuk melihat pola musiman dan pertumbuhan jangka menengah._

```sql fin_quarter_comparison
SELECT
    quarter_label, gross, net, margin_pct, total_biaya, bahan_pct, sdm_pct, ops_pct,
    LAG(net) OVER (ORDER BY qsort) AS net_prev_q,
    LAG(margin_pct) OVER (ORDER BY qsort) AS margin_prev_q,
    ROUND(margin_pct - LAG(margin_pct) OVER (ORDER BY qsort), 1) AS delta_margin_q,
    ROUND((net - LAG(net) OVER (ORDER BY qsort)) / NULLIF(LAG(net) OVER (ORDER BY qsort), 0) * 100, 1) AS pct_change_net_q
FROM fin_quarter
ORDER BY qsort DESC
```

{#each fin_quarter_comparison.slice(0, 1) as q}
{#if q.margin_pct >= 15}
<div style="background:rgba(22,163,74,0.08);border-left:4px solid #16a34a;padding:12px 16px;border-radius:6px;margin:16px 0;">
✅ <strong>Quarter terkini ({q.quarter_label}): Margin {q.margin_pct}%</strong>
{#if q.delta_margin_q !== null} — {q.delta_margin_q > 0 ? '+' : ''}{q.delta_margin_q}pp vs quarter sebelumnya.{/if}
</div>
{:else if q.margin_pct >= 10}
<div style="background:rgba(248,201,0,0.1);border-left:4px solid #f8c900;padding:12px 16px;border-radius:6px;margin:16px 0;">
⚠️ <strong>Quarter terkini ({q.quarter_label}): Margin {q.margin_pct}%</strong> — di bawah target 15%.
{#if q.delta_margin_q !== null} {q.delta_margin_q > 0 ? 'Membaik' : 'Memburuk'} {q.delta_margin_q > 0 ? '+' : ''}{q.delta_margin_q}pp vs quarter sebelumnya.{/if}
</div>
{:else}
<div style="background:rgba(220,38,38,0.08);border-left:4px solid #dc2626;padding:12px 16px;border-radius:6px;margin:16px 0;">
🔴 <strong>Quarter terkini ({q.quarter_label}): Margin {q.margin_pct}%</strong> — kritis.
</div>
{/if}
{/each}

### Ringkasan per Quarter

<DataTable data={fin_quarter_comparison}>
    <Column id="quarter_label"   title="Quarter"/>
    <Column id="gross"           title="Gross Revenue (Rp)"  fmt="#,##0"/>
    <Column id="net"             title="Net Revenue (Rp)"    fmt="#,##0"/>
    <Column id="margin_pct"      title="Net Margin (%)"      fmt="0.0\%"/>
    <Column id="delta_margin_q"  title="vs Q Sebelumnya (pp)" fmt="+0.0;-0.0" contentType="delta"/>
    <Column id="bahan_pct"       title="Bahan (%)"           fmt="0.0\%"/>
    <Column id="sdm_pct"         title="SDM (%)"             fmt="0.0\%"/>
    <Column id="ops_pct"         title="Ops (%)"             fmt="0.0\%"/>
</DataTable>

### Tren Net Margin per Quarter

<LineChart
    data={fin_quarter}
    x="quarter_label"
    y="margin_pct"
    title="Net Margin % per Quarter"
    yFmt="0.0\%"
    xAxisTitle="Quarter"
    yAxisTitle="Net Margin (%)"
/>

---

{:else if inputs.period === 'yoy'}

## Year-over-Year

_Perbandingan antar tahun untuk melihat apakah bisnis secara fundamental membaik._

{#if fin_yoy.length >= 2}

{#each fin_yoy.slice(0, 1) as yr}
{#each fin_yoy.slice(1, 2) as yr_prev}
{#if yr.margin_pct > yr_prev.margin_pct}
<div style="background:rgba(22,163,74,0.08);border-left:4px solid #16a34a;padding:12px 16px;border-radius:6px;margin:16px 0;">
✅ <strong>Margin {yr.tahun}: {yr.margin_pct}%</strong> — naik {Math.round((yr.margin_pct - yr_prev.margin_pct) * 10) / 10}pp vs {yr_prev.tahun} ({yr_prev.margin_pct}%). Perbaikan struktural terkonfirmasi.
</div>
{:else if yr_prev.margin_pct > yr.margin_pct}
<div style="background:rgba(220,38,38,0.08);border-left:4px solid #dc2626;padding:12px 16px;border-radius:6px;margin:16px 0;">
⚠️ <strong>Margin {yr.tahun}: {yr.margin_pct}%</strong> — turun {Math.round((yr_prev.margin_pct - yr.margin_pct) * 10) / 10}pp vs {yr_prev.tahun} ({yr_prev.margin_pct}%). Tren memburuk — perlu investigasi struktural.
</div>
{:else}
<div style="background:rgba(100,116,139,0.08);border-left:4px solid #888;padding:12px 16px;border-radius:6px;margin:16px 0;">
➡️ <strong>Margin {yr.tahun}: {yr.margin_pct}%</strong> — sama dengan {yr_prev.tahun}. Stabil secara YoY.
</div>
{/if}
{/each}
{/each}

{/if}

### Ringkasan per Tahun

<DataTable data={fin_yoy}>
    <Column id="tahun"      title="Tahun"/>
    <Column id="gross"      title="Gross Revenue (Rp)"  fmt="#,##0"/>
    <Column id="net"        title="Net Revenue (Rp)"    fmt="#,##0"/>
    <Column id="margin_pct" title="Net Margin (%)"      fmt="0.0\%"/>
    <Column id="bahan_pct"  title="Bahan (%)"           fmt="0.0\%"/>
    <Column id="sdm_pct"    title="SDM (%)"             fmt="0.0\%"/>
    <Column id="ops_pct"    title="Ops (%)"             fmt="0.0\%"/>
</DataTable>

### Tren Net Margin per Tahun

<LineChart
    data={fin_yoy}
    x="tahun"
    y="margin_pct"
    title="Net Margin % per Tahun"
    yFmt="0.0\%"
    xAxisTitle="Tahun"
    yAxisTitle="Net Margin (%)"
/>

### Tren Struktur Biaya per Tahun

<BarChart
    data={fin_yoy}
    x="tahun"
    y={["bahan_pct", "sdm_pct", "ops_pct"]}
    type="stacked"
    title="Struktur Biaya % per Tahun"
    yFmt="0.0\%"
    xAxisTitle="Tahun"
    yAxisTitle="% dari Gross Revenue"
/>

_Kalau struktur biaya membaik (% turun) sementara gross revenue naik — bisnis semakin efisien. Sebaliknya adalah inflasi biaya yang tidak terkontrol._

---

{/if}