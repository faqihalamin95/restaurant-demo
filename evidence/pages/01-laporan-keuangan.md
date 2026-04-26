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
    -- KEMARIN
    SUM(CASE WHEN metric_date = d THEN gross_revenue ELSE 0 END)                                    AS gross_yesterday,
    SUM(CASE WHEN metric_date = d THEN net_revenue ELSE 0 END)                                      AS net_yesterday,
    ROUND(SUM(CASE WHEN metric_date = d THEN net_revenue ELSE 0 END)
        / NULLIF(SUM(CASE WHEN metric_date = d THEN gross_revenue ELSE 0 END), 0) * 100, 1)        AS margin_yesterday,
    SUM(CASE WHEN metric_date = d
        THEN inventory_usage_cost + labor_total_cost + operational_total_cost ELSE 0 END)           AS biaya_yesterday,
    -- SDOW comparison untuk kemarin
    AVG(CASE WHEN metric_date < d AND DAYOFWEEK(metric_date) = DAYOFWEEK(d)
             AND metric_date >= d - INTERVAL '30 days' THEN gross_revenue END)                      AS gross_sdow,
    ROUND(AVG(CASE WHEN metric_date < d AND DAYOFWEEK(metric_date) = DAYOFWEEK(d)
             AND metric_date >= d - INTERVAL '30 days' THEN net_revenue END)
        / NULLIF(AVG(CASE WHEN metric_date < d AND DAYOFWEEK(metric_date) = DAYOFWEEK(d)
             AND metric_date >= d - INTERVAL '30 days' THEN gross_revenue END), 0) * 100, 1)       AS margin_sdow,

    -- 7 HARI
    SUM(CASE WHEN metric_date >= d - INTERVAL '6 days' THEN gross_revenue ELSE 0 END)              AS gross_7d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '6 days' THEN net_revenue ELSE 0 END)                AS net_7d,
    ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '6 days' THEN net_revenue ELSE 0 END)
        / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '6 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS margin_7d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '6 days'
        THEN inventory_usage_cost + labor_total_cost + operational_total_cost ELSE 0 END)           AS biaya_7d,
    -- 7d prev
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

    -- 30 HARI
    SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN gross_revenue ELSE 0 END)             AS gross_30d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN net_revenue ELSE 0 END)               AS net_30d,
    ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN net_revenue ELSE 0 END)
        / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS margin_30d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '29 days'
        THEN inventory_usage_cost + labor_total_cost + operational_total_cost ELSE 0 END)           AS biaya_30d,
    -- 30d prev
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

    -- 90 HARI
    SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN gross_revenue ELSE 0 END)             AS gross_90d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN net_revenue ELSE 0 END)               AS net_90d,
    ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN net_revenue ELSE 0 END)
        / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS margin_90d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '89 days'
        THEN inventory_usage_cost + labor_total_cost + operational_total_cost ELSE 0 END)           AS biaya_90d,
    -- 90d prev
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
        -- KEMARIN
        ROUND(SUM(CASE WHEN metric_date = d THEN inventory_usage_cost ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date = d THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS bahan_y,
        ROUND(SUM(CASE WHEN metric_date = d THEN labor_total_cost ELSE 0 END)      / NULLIF(SUM(CASE WHEN metric_date = d THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS sdm_y,
        ROUND(SUM(CASE WHEN metric_date = d THEN operational_total_cost ELSE 0 END)/ NULLIF(SUM(CASE WHEN metric_date = d THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS ops_y,
        -- SDOW comparison
        ROUND(AVG(CASE WHEN metric_date < d AND DAYOFWEEK(metric_date) = DAYOFWEEK(d) AND metric_date >= d - INTERVAL '30 days' THEN inventory_usage_cost END) / NULLIF(AVG(CASE WHEN metric_date < d AND DAYOFWEEK(metric_date) = DAYOFWEEK(d) AND metric_date >= d - INTERVAL '30 days' THEN gross_revenue END), 0) * 100, 1) AS bahan_sdow,
        ROUND(AVG(CASE WHEN metric_date < d AND DAYOFWEEK(metric_date) = DAYOFWEEK(d) AND metric_date >= d - INTERVAL '30 days' THEN labor_total_cost END)      / NULLIF(AVG(CASE WHEN metric_date < d AND DAYOFWEEK(metric_date) = DAYOFWEEK(d) AND metric_date >= d - INTERVAL '30 days' THEN gross_revenue END), 0) * 100, 1) AS sdm_sdow,
        ROUND(AVG(CASE WHEN metric_date < d AND DAYOFWEEK(metric_date) = DAYOFWEEK(d) AND metric_date >= d - INTERVAL '30 days' THEN operational_total_cost END) / NULLIF(AVG(CASE WHEN metric_date < d AND DAYOFWEEK(metric_date) = DAYOFWEEK(d) AND metric_date >= d - INTERVAL '30 days' THEN gross_revenue END), 0) * 100, 1) AS ops_sdow,
        -- 7D
        ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '6 days' THEN inventory_usage_cost ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '6 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS bahan_7d,
        ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '6 days' THEN labor_total_cost ELSE 0 END)      / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '6 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS sdm_7d,
        ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '6 days' THEN operational_total_cost ELSE 0 END)/ NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '6 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS ops_7d,
        ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '13 days' AND metric_date < d - INTERVAL '6 days' THEN inventory_usage_cost ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '13 days' AND metric_date < d - INTERVAL '6 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS bahan_p7d,
        ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '13 days' AND metric_date < d - INTERVAL '6 days' THEN labor_total_cost ELSE 0 END)      / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '13 days' AND metric_date < d - INTERVAL '6 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS sdm_p7d,
        ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '13 days' AND metric_date < d - INTERVAL '6 days' THEN operational_total_cost ELSE 0 END)/ NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '13 days' AND metric_date < d - INTERVAL '6 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS ops_p7d,
        -- 30D
        ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN inventory_usage_cost ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS bahan_30d,
        ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN labor_total_cost ELSE 0 END)      / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS sdm_30d,
        ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN operational_total_cost ELSE 0 END)/ NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS ops_30d,
        ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '59 days' AND metric_date < d - INTERVAL '29 days' THEN inventory_usage_cost ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '59 days' AND metric_date < d - INTERVAL '29 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS bahan_p30d,
        ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '59 days' AND metric_date < d - INTERVAL '29 days' THEN labor_total_cost ELSE 0 END)      / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '59 days' AND metric_date < d - INTERVAL '29 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS sdm_p30d,
        ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '59 days' AND metric_date < d - INTERVAL '29 days' THEN operational_total_cost ELSE 0 END)/ NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '59 days' AND metric_date < d - INTERVAL '29 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS ops_p30d,
        -- 90D
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

```sql fin_branch_yesterday
WITH max_d AS (SELECT MAX(metric_date)::DATE AS d FROM restaurant.daily_net_revenue)
SELECT
    branch_name,
    SUM(gross_revenue)                                                          AS gross,
    SUM(net_revenue)                                                            AS net,
    ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1)           AS margin_pct,
    CASE
        WHEN ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) >= 15 THEN '✅ Sehat'
        WHEN ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) >= 10 THEN '⚠️ Perhatian'
        ELSE '🔴 Kritis'
    END AS status
FROM restaurant.daily_net_revenue CROSS JOIN max_d
WHERE metric_date = d
GROUP BY branch_name
ORDER BY margin_pct DESC
```

```sql fin_branch_7d
WITH max_d AS (SELECT MAX(metric_date)::DATE AS d FROM restaurant.daily_net_revenue),
curr AS (
    SELECT branch_name,
        SUM(gross_revenue) AS gross, SUM(net_revenue) AS net,
        ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS margin_pct
    FROM restaurant.daily_net_revenue CROSS JOIN max_d
    WHERE metric_date >= d - INTERVAL '6 days'
    GROUP BY branch_name
),
prev AS (
    SELECT branch_name,
        ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS margin_pct
    FROM restaurant.daily_net_revenue CROSS JOIN max_d
    WHERE metric_date >= d - INTERVAL '13 days' AND metric_date < d - INTERVAL '6 days'
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
  <ButtonGroupItem valueLabel="Kemarin"  value="yesterday" />
  <ButtonGroupItem valueLabel="7 Hari"   value="7d" />
  <ButtonGroupItem valueLabel="30 Hari"  value="30d" default />
  <ButtonGroupItem valueLabel="90 Hari"  value="90d" />
  <ButtonGroupItem valueLabel="Quarter"  value="quarter" />
  <ButtonGroupItem valueLabel="YoY"      value="yoy" />
</ButtonGroup>

---

{#if inputs.period === 'yesterday'}

## Kemarin — {fin_dates[0].nama_hari}, {fin_dates[0].tgl_display}

_Snapshot satu hari. Data ini bisa berfluktuasi — gunakan sebagai sinyal awal, bukan dasar keputusan._

### Lapis 1 — Headline Margin

<BigValue data={fin_kpi} value="margin_yesterday" title="Net Margin Kemarin (%)"  fmt="0.0\%"  comparison="margin_sdow" comparisonTitle="Rata-rata hari serupa (30h)" />
<BigValue data={fin_kpi} value="gross_yesterday"  title="Gross Revenue (Rp)"      fmt="#,##0" />
<BigValue data={fin_kpi} value="net_yesterday"    title="Net Revenue (Rp)"        fmt="#,##0"  comparison="gross_sdow" comparisonTitle="Rata-rata hari serupa (30h)" />

{#if fin_kpi[0].margin_yesterday >= 15}
<div style="background:rgba(22,163,74,0.08);border-left:4px solid #16a34a;padding:12px 16px;border-radius:6px;margin:16px 0;">
✅ <strong>Margin {fin_kpi[0].margin_yesterday}% — sehat</strong>, di atas target 15%.<br/>
vs rata-rata {fin_dates[0].nama_hari} 30 hari terakhir: {fin_kpi[0].margin_sdow}% ({fin_kpi[0].margin_yesterday > fin_kpi[0].margin_sdow ? '+' : ''}{Math.round((fin_kpi[0].margin_yesterday - fin_kpi[0].margin_sdow) * 10) / 10}pp)
</div>
{:else if fin_kpi[0].margin_yesterday >= 10}
<div style="background:rgba(248,201,0,0.1);border-left:4px solid #f8c900;padding:12px 16px;border-radius:6px;margin:16px 0;">
⚠️ <strong>Margin {fin_kpi[0].margin_yesterday}% — perhatian</strong>, di bawah target 15%.<br/>
Ini baru satu hari — cek apakah pola ini berlanjut. Lihat breakdown biaya di bawah untuk petunjuk awal.
</div>
{:else}
<div style="background:rgba(220,38,38,0.08);border-left:4px solid #dc2626;padding:12px 16px;border-radius:6px;margin:16px 0;">
🔴 <strong>Margin {fin_kpi[0].margin_yesterday}% — kritis</strong>. Revenue kemarin tidak cukup menutup biaya secara memadai.<br/>
Satu hari buruk bisa jadi noise — tapi kalau ini berulang, cek struktur biaya cabang per cabang.
</div>
{/if}

---

### Lapis 2 — Bedah Komponen Biaya

_Target industri F&B: Bahan ≤32% · SDM ≤22% · Operasional ≤15%_

<details>
<summary>🥩 Biaya Bahan — {fin_cost_pct[0].bahan_y}% dari gross revenue (target ≤32%)</summary>
<div class="acc-body">

{#if fin_cost_pct[0].bahan_y > 32}
<div style="background:rgba(220,38,38,0.08);border-left:4px solid #dc2626;padding:10px 14px;border-radius:6px;margin-bottom:12px;">
⚠️ Di atas target. vs rata-rata hari serupa: {fin_cost_pct[0].bahan_sdow}% ({fin_cost_pct[0].bahan_y > fin_cost_pct[0].bahan_sdow ? '+' : ''}{Math.round((fin_cost_pct[0].bahan_y - fin_cost_pct[0].bahan_sdow) * 10) / 10}pp)
</div>
{:else}
<div style="background:rgba(22,163,74,0.08);border-left:4px solid #16a34a;padding:10px 14px;border-radius:6px;margin-bottom:12px;">
✅ Dalam target. vs rata-rata hari serupa: {fin_cost_pct[0].bahan_sdow}% ({fin_cost_pct[0].bahan_y > fin_cost_pct[0].bahan_sdow ? '+' : ''}{Math.round((fin_cost_pct[0].bahan_y - fin_cost_pct[0].bahan_sdow) * 10) / 10}pp)
</div>
{/if}

Dari setiap **Rp100 gross revenue** kemarin, **Rp{fin_cost_pct[0].bahan_y}** habis untuk bahan baku. Ini bisa berfluktuasi harian tergantung menu mix dan jumlah tamu. Kalau angka ini konsisten tinggi selama 7+ hari, baru perlu diinvestigasi.

</div>
</details>

<details>
<summary>👨‍💼 Biaya SDM — {fin_cost_pct[0].sdm_y}% dari gross revenue (target ≤22%)</summary>
<div class="acc-body">

{#if fin_cost_pct[0].sdm_y > 22}
<div style="background:rgba(220,38,38,0.08);border-left:4px solid #dc2626;padding:10px 14px;border-radius:6px;margin-bottom:12px;">
⚠️ Di atas target. vs rata-rata hari serupa: {fin_cost_pct[0].sdm_sdow}%
</div>
{:else}
<div style="background:rgba(22,163,74,0.08);border-left:4px solid #16a34a;padding:10px 14px;border-radius:6px;margin-bottom:12px;">
✅ Dalam target. vs rata-rata hari serupa: {fin_cost_pct[0].sdm_sdow}%
</div>
{/if}

Biaya SDM harian mencakup gaji harian yang dialokasikan, tunjangan makan, dan lembur. Angka ini relatif tetap — karena gaji tidak berubah harian. Kalau SDM% tinggi di hari sepi, itu normal (fixed cost dibagi revenue kecil). Yang perlu dicermati adalah SDM% tinggi saat hari ramai.

</div>
</details>

<details>
<summary>🏢 Biaya Operasional — {fin_cost_pct[0].ops_y}% dari gross revenue (target ≤15%)</summary>
<div class="acc-body">

{#if fin_cost_pct[0].ops_y > 15}
<div style="background:rgba(220,38,38,0.08);border-left:4px solid #dc2626;padding:10px 14px;border-radius:6px;margin-bottom:12px;">
⚠️ Di atas target. vs rata-rata hari serupa: {fin_cost_pct[0].ops_sdow}%
</div>
{:else}
<div style="background:rgba(22,163,74,0.08);border-left:4px solid #16a34a;padding:10px 14px;border-radius:6px;margin-bottom:12px;">
✅ Dalam target. vs rata-rata hari serupa: {fin_cost_pct[0].ops_sdow}%
</div>
{/if}

Biaya operasional (sewa, listrik, air) juga fixed — mirip SDM. Satu hari dengan revenue rendah akan terlihat inefficient. Gunakan data 30 hari untuk menilai efisiensi operasional secara fair.

</div>
</details>

---

### Lapis 3 — Performa per Cabang

<DataTable data={fin_branch_yesterday}>
    <Column id="branch_name" title="Cabang"/>
    <Column id="gross"       title="Gross Revenue (Rp)" fmt="#,##0"/>
    <Column id="net"         title="Net Revenue (Rp)"   fmt="#,##0"/>
    <Column id="margin_pct"  title="Net Margin (%)"     fmt="0.0\%"/>
    <Column id="status"      title="Status"/>
</DataTable>

<div style="background:rgba(100,116,139,0.08);border-left:4px solid #888;padding:10px 14px;border-radius:6px;margin-top:12px;font-size:0.85em;">
ℹ️ Data kemarin adalah snapshot satu hari — bisa sangat berfluktuasi. Untuk keputusan strategis, gunakan periode 30 hari atau 90 hari.
</div>

---

{:else if inputs.period === '7d'}

## 7 Hari Terakhir — {fin_dates[0].tgl_7d_awal} – {fin_dates[0].tgl_akhir}

_7 hari sudah cukup untuk melihat pola. Satu hari buruk tidak lagi bikin panik — yang kita cari: apakah tren ini konsisten?_

### Lapis 1 — Headline Margin

<BigValue data={fin_kpi} value="margin_7d"    title="Net Margin 7 Hari (%)"   fmt="0.0\%"  comparison="margin_prev7d"  comparisonTitle="7 hari sebelumnya" />
<BigValue data={fin_kpi} value="gross_7d"     title="Gross Revenue (Rp)"      fmt="#,##0"  comparison="gross_prev7d"   comparisonTitle="7 hari sebelumnya" />
<BigValue data={fin_kpi} value="net_7d"       title="Net Revenue (Rp)"        fmt="#,##0" />
<BigValue data={fin_kpi} value="biaya_7d"     title="Total Biaya (Rp)"        fmt="#,##0"  comparison="biaya_prev7d"   comparisonTitle="7 hari sebelumnya" />

{#if fin_kpi[0].margin_7d >= 15}
  {#if fin_kpi[0].delta_margin_7d >= 0}
<div style="background:rgba(22,163,74,0.08);border-left:4px solid #16a34a;padding:12px 16px;border-radius:6px;margin:16px 0;">
✅ <strong>Margin {fin_kpi[0].margin_7d}% — sehat dan membaik</strong> (+{fin_kpi[0].delta_margin_7d}pp vs 7 hari sebelumnya). Tren positif dan konsisten.
</div>
  {:else if fin_kpi[0].pct_change_gross_7d > 3 && 0 > fin_kpi[0].delta_margin_7d}
<div style="background:rgba(248,201,0,0.1);border-left:4px solid #f8c900;padding:12px 16px;border-radius:6px;margin:16px 0;">
✅ Margin {fin_kpi[0].margin_7d}% — masih sehat, tapi perlu perhatian.<br/>
Revenue naik {fin_kpi[0].pct_change_gross_7d}% tapi margin turun {fin_kpi[0].delta_margin_7d}pp — <strong>biaya tumbuh lebih cepat dari omset</strong>. Cek komponen biaya di bawah — pola ini berbahaya kalau berlanjut.
</div>
  {:else}
<div style="background:rgba(22,163,74,0.08);border-left:4px solid #16a34a;padding:12px 16px;border-radius:6px;margin:16px 0;">
✅ <strong>Margin {fin_kpi[0].margin_7d}% — sehat</strong> ({fin_kpi[0].delta_margin_7d}pp vs 7 hari sebelumnya).
</div>
  {/if}
{:else if fin_kpi[0].margin_7d >= 10}
<div style="background:rgba(248,201,0,0.1);border-left:4px solid #f8c900;padding:12px 16px;border-radius:6px;margin:16px 0;">
⚠️ <strong>Margin {fin_kpi[0].margin_7d}% — perhatian</strong>, di bawah target 15% selama 7 hari.<br/>
Ini bukan lagi noise harian — ada pola yang perlu dicek. Lihat breakdown biaya di bawah untuk identifikasi penyebab.
</div>
{:else}
<div style="background:rgba(220,38,38,0.08);border-left:4px solid #dc2626;padding:12px 16px;border-radius:6px;margin:16px 0;">
🔴 <strong>Margin {fin_kpi[0].margin_7d}% — kritis</strong> selama 7 hari berturut-turut. Perlu tindakan segera — jangan tunggu laporan bulanan.
</div>
{/if}

---

### Lapis 2 — Bedah Komponen Biaya

_Target industri F&B: Bahan ≤32% · SDM ≤22% · Operasional ≤15%_

<details>
<summary>🥩 Biaya Bahan — {fin_cost_pct[0].bahan_7d}% dari gross revenue (target ≤32%)</summary>
<div class="acc-body">

{#if fin_cost_pct[0].bahan_7d > 32}
<div style="background:rgba(220,38,38,0.08);border-left:4px solid #dc2626;padding:10px 14px;border-radius:6px;margin-bottom:12px;">
⚠️ Di atas target — dan sudah berlangsung 7 hari. vs minggu lalu: {fin_cost_pct[0].bahan_p7d}% ({fin_cost_pct[0].delta_bahan_7d > 0 ? '+' : ''}{fin_cost_pct[0].delta_bahan_7d}pp)
</div>
{:else}
<div style="background:rgba(22,163,74,0.08);border-left:4px solid #16a34a;padding:10px 14px;border-radius:6px;margin-bottom:12px;">
✅ Dalam target. vs minggu lalu: {fin_cost_pct[0].bahan_p7d}% ({fin_cost_pct[0].delta_bahan_7d > 0 ? '+' : ''}{fin_cost_pct[0].delta_bahan_7d}pp)
</div>
{/if}

7 hari sudah cukup untuk membedakan apakah kenaikan bahan ini pola atau kebetulan. Kalau konsisten di atas target: cek hari mana yang paling boros, apakah ada menu baru dengan food cost tinggi, atau ada perubahan volume yang tidak proporsional.

</div>
</details>

<details>
<summary>👨‍💼 Biaya SDM — {fin_cost_pct[0].sdm_7d}% dari gross revenue (target ≤22%)</summary>
<div class="acc-body">

{#if fin_cost_pct[0].sdm_7d > 22}
<div style="background:rgba(220,38,38,0.08);border-left:4px solid #dc2626;padding:10px 14px;border-radius:6px;margin-bottom:12px;">
⚠️ Di atas target. vs minggu lalu: {fin_cost_pct[0].sdm_p7d}% ({fin_cost_pct[0].delta_sdm_7d > 0 ? '+' : ''}{fin_cost_pct[0].delta_sdm_7d}pp)
</div>
{:else}
<div style="background:rgba(22,163,74,0.08);border-left:4px solid #16a34a;padding:10px 14px;border-radius:6px;margin-bottom:12px;">
✅ Dalam target. vs minggu lalu: {fin_cost_pct[0].sdm_p7d}% ({fin_cost_pct[0].delta_sdm_7d > 0 ? '+' : ''}{fin_cost_pct[0].delta_sdm_7d}pp)
</div>
{/if}

SDM% yang tinggi 7 hari berturut-turut biasanya bukan soal gaji — melainkan scheduling yang tidak efisien atau overtime yang menumpuk. Cek halaman Performa Pegawai untuk melihat distribusi jam kerja per shift.

</div>
</details>

<details>
<summary>🏢 Biaya Operasional — {fin_cost_pct[0].ops_7d}% dari gross revenue (target ≤15%)</summary>
<div class="acc-body">

{#if fin_cost_pct[0].ops_7d > 15}
<div style="background:rgba(220,38,38,0.08);border-left:4px solid #dc2626;padding:10px 14px;border-radius:6px;margin-bottom:12px;">
⚠️ Di atas target. vs minggu lalu: {fin_cost_pct[0].ops_p7d}% ({fin_cost_pct[0].delta_ops_7d > 0 ? '+' : ''}{fin_cost_pct[0].delta_ops_7d}pp)
</div>
{:else}
<div style="background:rgba(22,163,74,0.08);border-left:4px solid #16a34a;padding:10px 14px;border-radius:6px;margin-bottom:12px;">
✅ Dalam target. vs minggu lalu: {fin_cost_pct[0].ops_p7d}% ({fin_cost_pct[0].delta_ops_7d > 0 ? '+' : ''}{fin_cost_pct[0].delta_ops_7d}pp)
</div>
{/if}

Biaya operasional (sewa, listrik, air) bersifat fixed — relatif tidak bisa ditekan jangka pendek. Tapi kalau ops% naik signifikan dalam 7 hari, kemungkinan revenue yang turun (bukan biaya yang naik) adalah penyebabnya.

</div>
</details>

---

### Lapis 3 — Performa per Cabang

<DataTable data={fin_branch_7d}>
    <Column id="branch_name"  title="Cabang"/>
    <Column id="gross"        title="Gross Revenue (Rp)"      fmt="#,##0"/>
    <Column id="net"          title="Net Revenue (Rp)"        fmt="#,##0"/>
    <Column id="margin_pct"   title="Net Margin (%)"          fmt="0.0\%"/>
    <Column id="margin_prev"  title="Margin Minggu Lalu (%)"  fmt="0.0\%"/>
    <Column id="delta"        title="Perubahan (pp)"          fmt="+0.0;-0.0" contentType="delta"/>
    <Column id="status"       title="Status"/>
</DataTable>

<div style="background:rgba(100,116,139,0.08);border-left:4px solid #888;padding:10px 14px;border-radius:6px;margin-top:12px;font-size:0.85em;">
ℹ️ 7 hari cukup untuk melihat pola mingguan. Untuk keputusan biaya struktural, gunakan 30 hari atau 90 hari.
</div>

---

{:else if inputs.period === '30d'}

## 30 Hari Terakhir — {fin_dates[0].tgl_30d_awal} – {fin_dates[0].tgl_akhir}

_Sweet spot untuk keputusan operasional — cukup panjang untuk melihat pola stabil, cukup pendek untuk bereaksi._

### Lapis 1 — Headline Margin

<BigValue data={fin_kpi} value="margin_30d"   title="Net Margin 30 Hari (%)"  fmt="0.0\%"  comparison="margin_prev30d" comparisonTitle="30 hari sebelumnya" />
<BigValue data={fin_kpi} value="gross_30d"    title="Gross Revenue (Rp)"      fmt="#,##0"  comparison="gross_prev30d"  comparisonTitle="30 hari sebelumnya" />
<BigValue data={fin_kpi} value="net_30d"      title="Net Revenue (Rp)"        fmt="#,##0" />
<BigValue data={fin_kpi} value="biaya_30d"    title="Total Biaya (Rp)"        fmt="#,##0"  comparison="biaya_prev30d"  comparisonTitle="30 hari sebelumnya" />

{#if fin_kpi[0].margin_30d >= 15}
  {#if fin_kpi[0].pct_change_gross_30d > 3 && -1 > fin_kpi[0].delta_margin_30d}
<div style="background:rgba(248,201,0,0.1);border-left:4px solid #f8c900;padding:12px 16px;border-radius:6px;margin:16px 0;">
✅ Margin {fin_kpi[0].margin_30d}% — masih sehat, tapi ada sinyal yang perlu diperhatikan.<br/>
<strong>Revenue naik {fin_kpi[0].pct_change_gross_30d}% tapi margin justru turun {fin_kpi[0].delta_margin_30d}pp</strong> — margin terjaga bukan karena efisiensi, tapi karena omset ikut naik. Kalau omset stagnasi, margin akan tertekan. Cek komponen biaya mana yang tumbuh lebih cepat dari revenue.
</div>
  {:else if fin_kpi[0].delta_margin_30d >= 1}
<div style="background:rgba(22,163,74,0.08);border-left:4px solid #16a34a;padding:12px 16px;border-radius:6px;margin:16px 0;">
✅ <strong>Margin {fin_kpi[0].margin_30d}% — sehat dan membaik</strong> (+{fin_kpi[0].delta_margin_30d}pp vs 30 hari sebelumnya). Efisiensi biaya tren positif — pertahankan.
</div>
  {:else}
<div style="background:rgba(22,163,74,0.08);border-left:4px solid #16a34a;padding:12px 16px;border-radius:6px;margin:16px 0;">
✅ <strong>Margin {fin_kpi[0].margin_30d}% — sehat</strong> ({fin_kpi[0].delta_margin_30d}pp vs 30 hari sebelumnya). Stabil dalam target.
</div>
  {/if}
{:else if fin_kpi[0].margin_30d >= 10}
<div style="background:rgba(248,201,0,0.1);border-left:4px solid #f8c900;padding:12px 16px;border-radius:6px;margin:16px 0;">
⚠️ <strong>Margin {fin_kpi[0].margin_30d}% — perhatian</strong>, di bawah target 15% selama 30 hari.<br/>
Ini sudah cukup lama untuk dianggap serius. Identifikasi komponen biaya mana yang paling menekan margin dan ambil langkah konkret.
</div>
{:else}
<div style="background:rgba(220,38,38,0.08);border-left:4px solid #dc2626;padding:12px 16px;border-radius:6px;margin:16px 0;">
🔴 <strong>Margin {fin_kpi[0].margin_30d}% — kritis</strong> selama 30 hari. Bisnis sedang merugi secara struktural. Perlu evaluasi menyeluruh — tidak cukup dengan optimasi kecil.
</div>
{/if}

---

### Lapis 2 — Bedah Komponen Biaya

_Target industri F&B: Bahan ≤32% · SDM ≤22% · Operasional ≤15% · Dari setiap Rp100 revenue, berapa yang habis di masing-masing pos?_

<details>
<summary>🥩 Biaya Bahan — {fin_cost_pct[0].bahan_30d}% dari gross revenue (target ≤32%)</summary>
<div class="acc-body">

{#if fin_cost_pct[0].bahan_30d > 32 && fin_cost_pct[0].delta_bahan_30d > 0}
<div style="background:rgba(220,38,38,0.08);border-left:4px solid #dc2626;padding:10px 14px;border-radius:6px;margin-bottom:12px;">
⚠️ Di atas target dan naik {fin_cost_pct[0].delta_bahan_30d}pp vs 30 hari sebelumnya ({fin_cost_pct[0].bahan_p30d}% → {fin_cost_pct[0].bahan_30d}%). Tren memburuk — perlu tindakan.
</div>
{:else if fin_cost_pct[0].bahan_30d > 32}
<div style="background:rgba(248,201,0,0.1);border-left:4px solid #f8c900;padding:10px 14px;border-radius:6px;margin-bottom:12px;">
⚠️ Di atas target, tapi sudah turun {Math.abs(fin_cost_pct[0].delta_bahan_30d)}pp vs 30 hari sebelumnya ({fin_cost_pct[0].bahan_p30d}% → {fin_cost_pct[0].bahan_30d}%). Tren membaik — pertahankan.
</div>
{:else}
<div style="background:rgba(22,163,74,0.08);border-left:4px solid #16a34a;padding:10px 14px;border-radius:6px;margin-bottom:12px;">
✅ Dalam target. vs 30 hari sebelumnya: {fin_cost_pct[0].bahan_p30d}% → {fin_cost_pct[0].bahan_30d}% ({fin_cost_pct[0].delta_bahan_30d > 0 ? '+' : ''}{fin_cost_pct[0].delta_bahan_30d}pp)
</div>
{/if}

Dari setiap **Rp100 gross revenue** bulan ini, **Rp{fin_cost_pct[0].bahan_30d}** habis untuk bahan baku. Benchmark F&B Indonesia: 28–35%.

**Bisa ditekan?**

{#if fin_cost_pct[0].bahan_30d > 32}
Angka ini sudah melebihi batas target — 30 hari data cukup untuk membuktikan ini bukan fluktuasi. Langkah konkret:

<ul style="margin:8px 0 0 0;padding-left:20px;">
<li><strong>Audit menu food cost tertinggi</strong> → buka halaman Performa Menu, urutkan berdasarkan revenue tapi cek juga berapa biaya bahannya</li>
<li><strong>Tanya ke supplier</strong> → apakah ada kenaikan harga yang belum dikomunikasikan? 30 hari data = leverage negosiasi yang kuat</li>
<li><strong>Bandingkan waste per cabang</strong> → buka halaman Inventori, cek rasio beli/pakai — cabang mana yang paling boros?</li>
</ul>
{:else}
Masih dalam target. Kalau mendekati 32%, mulai pantau: apakah ada pergeseran menu mix ke item food cost tinggi? Atau ada kenaikan harga supplier yang bertahap?
{/if}

</div>
</details>

<details>
<summary>👨‍💼 Biaya SDM — {fin_cost_pct[0].sdm_30d}% dari gross revenue (target ≤22%)</summary>
<div class="acc-body">

{#if fin_cost_pct[0].sdm_30d > 22 && fin_cost_pct[0].delta_sdm_30d > 0}
<div style="background:rgba(220,38,38,0.08);border-left:4px solid #dc2626;padding:10px 14px;border-radius:6px;margin-bottom:12px;">
⚠️ Di atas target dan naik {fin_cost_pct[0].delta_sdm_30d}pp vs 30 hari sebelumnya. Investigasi lebih lanjut.
</div>
{:else if fin_cost_pct[0].sdm_30d > 22}
<div style="background:rgba(248,201,0,0.1);border-left:4px solid #f8c900;padding:10px 14px;border-radius:6px;margin-bottom:12px;">
⚠️ Di atas target, tapi sudah turun {Math.abs(fin_cost_pct[0].delta_sdm_30d)}pp vs 30 hari sebelumnya. Tren membaik.
</div>
{:else}
<div style="background:rgba(22,163,74,0.08);border-left:4px solid #16a34a;padding:10px 14px;border-radius:6px;margin-bottom:12px;">
✅ Dalam target. vs 30 hari sebelumnya: {fin_cost_pct[0].sdm_p30d}% → {fin_cost_pct[0].sdm_30d}% ({fin_cost_pct[0].delta_sdm_30d > 0 ? '+' : ''}{fin_cost_pct[0].delta_sdm_30d}pp)
</div>
{/if}

Dari setiap **Rp100 gross revenue**, **Rp{fin_cost_pct[0].sdm_30d}** habis untuk biaya SDM (gaji, tunjangan makan, lembur). Benchmark F&B Indonesia: 18–25%.

**Bisa ditekan?**

{#if fin_cost_pct[0].sdm_30d > 22}
SDM% tinggi di atas 22% selama 30 hari biasanya bukan soal gaji terlalu besar — melainkan scheduling yang tidak efisien. Langkah konkret:

<ul style="margin:8px 0 0 0;padding-left:20px;">
<li><strong>Cek pola overtime</strong> → buka halaman Performa Pegawai, lihat apakah ada shift yang konsisten lembur (sinyal understaffing)</li>
<li><strong>Evaluasi hari sepi</strong> → apakah jumlah staf di hari Senin–Rabu sama dengan Jumat–Minggu? SDM bisa dioptimasi dengan jadwal fleksibel</li>
<li><strong>Bandingkan SDM% per cabang</strong> → cabang dengan SDM% jauh di atas rata-rata kemungkinan punya masalah scheduling</li>
</ul>
{:else}
Masih dalam target. Kalau mendekati 22%, evaluasi apakah ada lembur yang tidak perlu atau penempatan staf yang tidak efisien di hari sepi.
{/if}

</div>
</details>

<details>
<summary>🏢 Biaya Operasional — {fin_cost_pct[0].ops_30d}% dari gross revenue (target ≤15%)</summary>
<div class="acc-body">

{#if fin_cost_pct[0].ops_30d > 15 && fin_cost_pct[0].delta_ops_30d > 0}
<div style="background:rgba(220,38,38,0.08);border-left:4px solid #dc2626;padding:10px 14px;border-radius:6px;margin-bottom:12px;">
⚠️ Di atas target dan naik {fin_cost_pct[0].delta_ops_30d}pp vs 30 hari sebelumnya. Cek komponen mana yang naik.
</div>
{:else if fin_cost_pct[0].ops_30d > 15}
<div style="background:rgba(248,201,0,0.1);border-left:4px solid #f8c900;padding:10px 14px;border-radius:6px;margin-bottom:12px;">
⚠️ Di atas target, tapi turun {Math.abs(fin_cost_pct[0].delta_ops_30d)}pp vs 30 hari sebelumnya. Tren membaik.
</div>
{:else}
<div style="background:rgba(22,163,74,0.08);border-left:4px solid #16a34a;padding:10px 14px;border-radius:6px;margin-bottom:12px;">
✅ Dalam target. vs 30 hari sebelumnya: {fin_cost_pct[0].ops_p30d}% → {fin_cost_pct[0].ops_30d}% ({fin_cost_pct[0].delta_ops_30d > 0 ? '+' : ''}{fin_cost_pct[0].delta_ops_30d}pp)
</div>
{/if}

Dari setiap **Rp100 gross revenue**, **Rp{fin_cost_pct[0].ops_30d}** habis untuk biaya operasional (sewa, listrik, air, utilitas). Biaya ini sebagian besar fixed — sulit ditekan jangka pendek.

**Bisa ditekan?**

Biaya operasional yang tinggi biasanya bukan masalah efisiensi harian, melainkan masalah negosiasi kontrak. Langkah yang realistis:

<ul style="margin:8px 0 0 0;padding-left:20px;">
<li><strong>Review kontrak sewa</strong> → apakah ada klausa renegosiasi? 30 hari data dengan margin terkanan adalah argumen yang kuat</li>
<li><strong>Audit konsumsi listrik</strong> → AC dan peralatan dapur adalah pengonsumsi terbesar. Apakah ada yang menyala di luar jam operasional?</li>
<li><strong>Bandingkan ops% antar cabang</strong> → cabang dengan ops% jauh di atas rata-rata mungkin punya kontrak yang tidak efisien</li>
</ul>

</div>
</details>

---

### Lapis 3 — Performa per Cabang

{#if fin_branch_30d_gap[0].gap > 5}
<div style="background:rgba(248,201,0,0.1);border-left:4px solid #f8c900;padding:12px 16px;border-radius:6px;margin-bottom:16px;">
📊 <strong>Gap margin antar cabang: {fin_branch_30d_gap[0].gap}pp</strong> — {fin_branch_30d_gap[0].cabang_terbaik} ({fin_branch_30d_gap[0].margin_max}%) vs {fin_branch_30d_gap[0].cabang_terlemah} ({fin_branch_30d_gap[0].margin_min}%).<br/>
Gap di atas 5pp biasanya sinyal ada inefisiensi struktural di cabang terlemah — bukan sekadar perbedaan lokasi. Detail ada di halaman <a href="/02-branch-performance">Performa Cabang</a>.
</div>
{:else}
<div style="background:rgba(22,163,74,0.08);border-left:4px solid #16a34a;padding:12px 16px;border-radius:6px;margin-bottom:16px;">
✅ <strong>Gap margin antar cabang: {fin_branch_30d_gap[0].gap}pp</strong> — semua cabang relatif setara. Operasional konsisten antar lokasi.
</div>
{/if}

{#if fin_branch_30d_gap[0].jumlah_kritis > 0}
<div style="background:rgba(220,38,38,0.08);border-left:4px solid #dc2626;padding:12px 16px;border-radius:6px;margin-bottom:16px;">
🔴 <strong>{fin_branch_30d_gap[0].jumlah_kritis} cabang kritis</strong> (margin di bawah 10%). Perlu evaluasi biaya segera — lihat detail di halaman Performa Cabang.
</div>
{/if}

<DataTable data={fin_branch_30d}>
    <Column id="branch_name"  title="Cabang"/>
    <Column id="gross"        title="Gross Revenue (Rp)"      fmt="#,##0"/>
    <Column id="net"          title="Net Revenue (Rp)"        fmt="#,##0"/>
    <Column id="margin_pct"   title="Net Margin (%)"          fmt="0.0\%"/>
    <Column id="margin_prev"  title="Margin Bulan Lalu (%)"   fmt="0.0\%"/>
    <Column id="delta"        title="Perubahan (pp)"          fmt="+0.0;-0.0" contentType="delta"/>
    <Column id="status"       title="Status"/>
</DataTable>

_Detail breakdown biaya dan tren per cabang ada di halaman **Performa Cabang**._

---

### Tren Margin Bulanan per Cabang

```sql fin_branch_monthly_30
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

<LineChart
    data={fin_branch_monthly_30}
    x="bulan"
    y="margin_pct"
    series="branch_name"
    title="Tren Net Margin Bulanan per Cabang (%)"
    yFmt="0.0\%"
    xAxisTitle="Bulan"
    yAxisTitle="Net Margin (%)"
/>

<div style="background:rgba(100,116,139,0.08);border-left:4px solid #888;padding:10px 14px;border-radius:6px;margin-top:12px;font-size:0.85em;">
ℹ️ 30 hari adalah basis yang solid untuk keputusan operasional — negosiasi supplier, evaluasi menu, penyesuaian jadwal staf. Untuk keputusan struktural (ekspansi, renovasi, kontrak jangka panjang), lihat periode 90 hari.
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
<strong>Revenue tumbuh {fin_kpi[0].pct_change_gross_90d}% dalam 3 bulan, tapi margin turun {fin_kpi[0].delta_margin_90d}pp.</strong> Bisnis tumbuh tapi semakin tidak efisien — biaya tumbuh lebih cepat dari omset. Ini masalah struktural yang perlu diaddress sebelum margin jatuh lebih dalam.
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
Ini bukan fluktuasi. Ada masalah struktural — entah di sisi biaya atau di sisi pricing. Gunakan accordion di bawah untuk mengidentifikasi komponen mana yang paling bermasalah, lalu ambil keputusan strategis.
</div>
{:else}
<div style="background:rgba(220,38,38,0.08);border-left:4px solid #dc2626;padding:12px 16px;border-radius:6px;margin:16px 0;">
🔴 <strong>Margin {fin_kpi[0].margin_90d}% — kritis secara struktural.</strong> 3 bulan data adalah bukti yang tidak bisa diabaikan. Perlu evaluasi model bisnis — pricing, cost structure, atau pilihan cabang yang perlu ditutup/direstrukturisasi.
</div>
{/if}

---

### Lapis 2 — Bedah Komponen Biaya

_Di level 90 hari, pertanyaannya bukan "kenapa hari ini begini?" — tapi "lever strategis mana yang bisa ditarik?"_

<details>
<summary>🥩 Biaya Bahan — {fin_cost_pct[0].bahan_90d}% dari gross revenue (target ≤32%)</summary>
<div class="acc-body">

{#if fin_cost_pct[0].bahan_90d > 32}
<div style="background:rgba(220,38,38,0.08);border-left:4px solid #dc2626;padding:10px 14px;border-radius:6px;margin-bottom:12px;">
⚠️ Di atas target selama 3 bulan ({fin_cost_pct[0].delta_bahan_90d > 0 ? 'naik' : 'turun'} {Math.abs(fin_cost_pct[0].delta_bahan_90d)}pp vs 3 bulan sebelumnya). Ini pola struktural — bukan fluktuasi.
</div>
{:else}
<div style="background:rgba(22,163,74,0.08);border-left:4px solid #16a34a;padding:10px 14px;border-radius:6px;margin-bottom:12px;">
✅ Dalam target. vs 3 bulan sebelumnya: {fin_cost_pct[0].bahan_p90d}% → {fin_cost_pct[0].bahan_90d}% ({fin_cost_pct[0].delta_bahan_90d > 0 ? '+' : ''}{fin_cost_pct[0].delta_bahan_90d}pp)
</div>
{/if}

**Lever strategis yang realistis di level 90 hari:**

<ul style="margin:8px 0 0 0;padding-left:20px;">
<li><strong>Renegosiasi kontrak supplier</strong> → volume 3 bulan adalah leverage yang kuat. Minta komitmen harga tetap atau diskon volume</li>
<li><strong>Review pricing menu</strong> → apakah harga jual sudah merefleksikan kenaikan biaya bahan dalam 3 bulan terakhir?</li>
<li><strong>Standardisasi resep antar cabang</strong> → variansi food cost antar cabang sering terjadi karena tidak ada standar porsi yang konsisten</li>
</ul>

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

**Lever strategis di level 90 hari:**

<ul style="margin:8px 0 0 0;padding-left:20px;">
<li><strong>Audit struktur jabatan</strong> → apakah rasio supervisor:staf sudah optimal? Terlalu banyak supervisor = SDM% tinggi</li>
<li><strong>Evaluasi hari-hari sepi</strong> → 3 bulan data cukup untuk identifikasi hari/shift yang konsisten sepi — pertimbangkan pengurangan headcount di jam-jam tersebut</li>
<li><strong>Cek pola lembur</strong> → lembur yang konsisten selama 3 bulan berarti ada gap struktural dalam perencanaan SDM</li>
</ul>

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

**Lever strategis di level 90 hari:**

<ul style="margin:8px 0 0 0;padding-left:20px;">
<li><strong>Renegosiasi kontrak sewa</strong> → 3 bulan track record profitabilitas adalah argumen untuk minta perpanjangan kontrak dengan harga lebih baik</li>
<li><strong>Audit konsumsi energi</strong> → investasi di peralatan hemat energi (AC, lampu LED) bisa ROI dalam 6–12 bulan</li>
<li><strong>Evaluasi lokasi</strong> → cabang dengan ops% tinggi secara konsisten perlu dievaluasi apakah lokasi masih strategis</li>
</ul>

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

_Garis yang terus turun selama 3 bulan berturut-turut di satu cabang adalah sinyal bahwa ada masalah struktural — bukan musiman. Detail ada di halaman **Performa Cabang**._

<div style="background:rgba(100,116,139,0.08);border-left:4px solid #888;padding:10px 14px;border-radius:6px;margin-top:12px;font-size:0.85em;">
ℹ️ 90 hari adalah basis untuk keputusan strategis — renegosiasi kontrak, review pricing, evaluasi cabang. Data di sini adalah sinyal jangka panjang.
</div>

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

### Tren Gross vs Net Revenue per Quarter

<BarChart
    data={fin_quarter}
    x="quarter_label"
    y={["gross", "net"]}
    type="grouped"
    title="Gross vs Net Revenue per Quarter (Rp)"
    yFmt="#,##0"
    xAxisTitle="Quarter"
    yAxisTitle="Revenue (Rp)"
/>

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

_Pola musiman yang berulang di quarter yang sama (misal Q2 selalu turun karena Lebaran) adalah informasi berharga untuk perencanaan stok dan SDM di tahun berikutnya._

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

_Kalau struktur biaya membaik setiap tahun (% turun) sementara gross revenue naik, itu tanda bisnis yang semakin efisien. Sebaliknya — semua % naik — adalah sinyal inflasi biaya yang tidak terkontrol._

---

{/if}