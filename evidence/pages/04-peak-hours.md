---
title: Permintaan & Traffic
---

<style>
.over-container { display: none !important; }
.pt-page { display: flex; flex-direction: column; gap: 22px; margin-top: 10px; }

/* ── Executive Banner ── */
.exec-banner {
  padding: 24px;
  border-radius: 22px;
  border: 1px solid rgba(37,99,235,0.12);
  background:
    radial-gradient(circle at top right, rgba(69,161,191,0.18), transparent 35%),
    radial-gradient(circle at bottom left, rgba(99,102,241,0.08), transparent 40%),
    linear-gradient(135deg, rgba(37,99,235,0.06), rgba(194,65,12,0.04)),
    var(--color-background-secondary);
}
.exec-eyebrow { font-size: 11px; font-weight: 700; letter-spacing: 0.13em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 8px; }
.exec-headline { font-size: 1.75rem; font-weight: 900; letter-spacing: -0.035em; color: var(--color-text-primary); line-height: 1.12; margin: 0 0 8px; max-width: 76ch; }
.exec-body { font-size: 0.95rem; line-height: 1.75; color: var(--color-text-secondary); max-width: 72ch; margin: 0; }
.exec-tag { display: inline-flex; align-items: center; width: fit-content; margin-top: 14px; padding: 6px 13px; border-radius: 999px; font-size: 0.8rem; font-weight: 700; border: 1.5px solid rgba(37,99,235,0.2); background: rgba(37,99,235,0.06); color: #1d4ed8; }
.exec-tag.warn { border-color: rgba(245,158,11,0.32); background: rgba(245,158,11,0.08); color: #b45309; }
.exec-tag.ok   { border-color: rgba(22,163,74,0.28);  background: rgba(22,163,74,0.07);  color: #15803d; }
.exec-tag.kritis { border-color: rgba(239,68,68,0.28); background: rgba(239,68,68,0.07);  color: #b91c1c; }

/* ── KPI rows ── */
.kpi-row-3 { display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px; }
.kpi-row-4 { display: grid; grid-template-columns: repeat(4, 1fr); gap: 12px; }
.kpi-card { padding: 18px; border-radius: 16px; border: 1.5px solid var(--color-border-tertiary); background: var(--color-background-secondary); display: flex; flex-direction: column; gap: 8px; min-height: 176px; }
/* jam sibuk */
.kpi-card.share  { border-color: rgba(99,102,241,0.22);  background: linear-gradient(145deg, rgba(99,102,241,0.07), rgba(139,92,246,0.02)); }
.kpi-card.surge  { border-color: rgba(245,158,11,0.22);  background: linear-gradient(145deg, rgba(245,158,11,0.07), rgba(251,191,36,0.02)); }
.kpi-card.window { border-color: rgba(20,184,166,0.22);  background: linear-gradient(145deg, rgba(20,184,166,0.07), rgba(16,185,129,0.02)); }
/* hari ramai */
.kpi-card.busiest  { border-color: rgba(239,68,68,0.22);   background: linear-gradient(145deg, rgba(239,68,68,0.07),   rgba(220,38,38,0.02)); }
.kpi-card.quietest { border-color: rgba(148,163,184,0.22); background: linear-gradient(145deg, rgba(148,163,184,0.07), rgba(100,116,139,0.02)); }
.kpi-card.gap-card { border-color: rgba(245,158,11,0.22);  background: linear-gradient(145deg, rgba(245,158,11,0.07),  rgba(251,191,36,0.02)); }
.kpi-card.weekend  { border-color: rgba(99,102,241,0.22);  background: linear-gradient(145deg, rgba(99,102,241,0.07),  rgba(139,92,246,0.02)); }
/* volatilitas */
.kpi-card.stability { border-color: rgba(20,184,166,0.22);  background: linear-gradient(145deg, rgba(20,184,166,0.07),  rgba(16,185,129,0.02)); }
.kpi-card.spike     { border-color: rgba(239,68,68,0.22);   background: linear-gradient(145deg, rgba(239,68,68,0.07),   rgba(220,38,38,0.02)); }
.kpi-card.drop      { border-color: rgba(99,102,241,0.22);  background: linear-gradient(145deg, rgba(99,102,241,0.07),  rgba(139,92,246,0.02)); }
.kpi-card.anomaly   { border-color: rgba(245,158,11,0.22);  background: linear-gradient(145deg, rgba(245,158,11,0.07),  rgba(251,191,36,0.02)); }
/* musiman */
.kpi-card.strong  { border-color: rgba(22,163,74,0.22);  background: linear-gradient(145deg, rgba(22,163,74,0.07),  rgba(16,185,129,0.02)); }
.kpi-card.weak    { border-color: rgba(239,68,68,0.22);  background: linear-gradient(145deg, rgba(239,68,68,0.07),  rgba(220,38,38,0.02)); }
.kpi-card.growth  { border-color: rgba(99,102,241,0.22); background: linear-gradient(145deg, rgba(99,102,241,0.07), rgba(139,92,246,0.02)); }
.kpi-card.holiday { border-color: rgba(245,158,11,0.22); background: linear-gradient(145deg, rgba(245,158,11,0.07), rgba(251,191,36,0.02)); }

.kpi-label  { font-size: 10px; font-weight: 800; letter-spacing: 0.09em; text-transform: uppercase; color: var(--color-text-tertiary); }
.kpi-number { font-size: 1.9rem; font-weight: 900; letter-spacing: -0.04em; color: var(--color-text-primary); line-height: 1; }
.kpi-interp { font-size: 0.85rem; line-height: 1.65; color: var(--color-text-secondary); }

/* ── Chart section ── */
.chart-section { padding: 20px; border-radius: 20px; border: 1px solid var(--color-border-tertiary); background: var(--color-background-secondary); box-shadow: 0 1px 3px rgba(0,0,0,0.04); }
.chart-eyebrow { font-size: 10px; font-weight: 800; letter-spacing: 0.09em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 4px; }
.chart-title   { font-size: 1.1rem; font-weight: 800; letter-spacing: -0.02em; color: var(--color-text-primary); margin: 0 0 18px; }
.chart-interp  { margin-top: 14px; padding: 14px 16px; border-radius: 14px; border: 1px solid rgba(99,102,241,0.15); background: linear-gradient(135deg, rgba(99,102,241,0.05), rgba(139,92,246,0.03)); font-size: 0.88rem; line-height: 1.7; color: var(--color-text-secondary); }
.chart-interp strong { color: var(--color-text-primary); }

/* ── Recommendation Block ── */
.rec-block { padding: 20px; border-radius: 20px; border: 1.5px solid rgba(99,102,241,0.18); background: linear-gradient(135deg, rgba(99,102,241,0.04), rgba(139,92,246,0.03)); }
.rec-eyebrow { font-size: 10px; font-weight: 700; letter-spacing: 0.12em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 6px; }
.rec-title   { font-size: 1rem; font-weight: 850; letter-spacing: -0.015em; color: var(--color-text-primary); margin-bottom: 14px; line-height: 1.35; }
.rec-list    { display: flex; flex-direction: column; gap: 10px; }
.rec-item    { display: grid; grid-template-columns: 28px 1fr; gap: 12px; align-items: start; padding: 14px 16px; border-radius: 12px; background: rgba(255,255,255,0.55); border: 1px solid rgba(99,102,241,0.13); }
.rec-icon    { font-size: 1rem; line-height: 1.6; }
.rec-text    { font-size: 0.88rem; line-height: 1.65; color: var(--color-text-secondary); }
.rec-text strong { color: var(--color-text-primary); }

/* ── Supporting accordion ── */
.support-acc { border: 1px solid rgba(128,128,128,0.18); border-radius: 12px; background: rgba(255,255,255,0.55); overflow: hidden; }
.support-acc summary { padding: 14px 16px; cursor: pointer; list-style: none; display: flex; align-items: center; gap: 8px; background: rgba(128,128,128,0.04); font-size: 0.9rem; font-weight: 700; color: var(--color-text-primary); }
.support-acc summary::-webkit-details-marker { display: none; }
.support-acc[open] summary { border-bottom: 1px solid rgba(128,128,128,0.14); }
.support-body { padding: 16px; display: flex; flex-direction: column; gap: 20px; font-size: 0.9em; line-height: 1.75; color: var(--color-text-secondary); }
.support-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 10px; }
.support-item { padding: 12px 14px; border-radius: 12px; background: rgba(0,0,0,0.03); border: 1px solid var(--color-border-tertiary); }
.support-item-label { font-size: 9px; font-weight: 800; letter-spacing: 0.1em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 4px; }
.support-item-title { font-size: 0.88rem; font-weight: 700; color: var(--color-text-primary); margin-bottom: 3px; }
.support-item-desc  { font-size: 0.8rem; line-height: 1.55; color: var(--color-text-secondary); }

.current-month-callout { display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px; padding: 14px 16px; border-radius: 14px; border: 1px solid rgba(245,158,11,0.28); background: linear-gradient(135deg, rgba(245,158,11,0.13), rgba(251,191,36,0.05)); margin-bottom: 14px; }
.current-month-label { font-size: 9px; font-weight: 800; letter-spacing: 0.1em; text-transform: uppercase; color: #92400e; margin-bottom: 4px; }
.current-month-value { font-size: 0.98rem; font-weight: 850; color: var(--color-text-primary); line-height: 1.35; }
.current-month-note { font-size: 0.8rem; line-height: 1.5; color: var(--color-text-secondary); margin-top: 4px; }

/* ── Strategic lens sections ── */
.strategic-stack {
  display: flex;
  flex-direction: column;
  gap: 12px;
}
.strategic-header {
  padding: 0 2px;
  margin-bottom: 4px;
}
.strategic-eyebrow {
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: var(--color-text-tertiary);
  margin-bottom: 6px;
  display: flex;
  align-items: center;
  gap: 6px;
}
.strategic-title {
  font-size: 1.3rem;
  font-weight: 800;
  letter-spacing: -0.025em;
  color: var(--color-text-primary);
  margin: 0 0 4px;
}
.strategic-copy {
  font-size: 0.9rem;
  line-height: 1.7;
  color: var(--color-text-secondary);
  max-width: 68ch;
  margin: 0;
}
details.acc-strategic {
  border-radius: 20px;
  border: 1.5px solid rgba(99, 102, 241, 0.18);
  background: linear-gradient(135deg, rgba(99,102,241,0.04), rgba(139,92,246,0.03));
  overflow: hidden;
}
details.acc-strategic > summary {
  padding: 18px 20px;
  background: transparent;
  font-size: 1rem;
  font-weight: 800;
  letter-spacing: -0.015em;
  color: var(--color-text-primary);
  display: flex;
  align-items: center;
  gap: 10px;
  cursor: pointer;
  list-style: none;
}
details.acc-strategic > summary::-webkit-details-marker { display: none; }
details.acc-strategic > summary::after {
  content: '›';
  margin-left: auto;
  font-size: 1.3rem;
  font-weight: 400;
  color: var(--color-text-tertiary);
  transition: transform 0.2s;
  display: inline-block;
}
details.acc-strategic[open] > summary::after { transform: rotate(90deg); }
details.acc-strategic[open] > summary { border-bottom: 1.5px solid rgba(99,102,241,0.14); }
details.acc-strategic .acc-body {
  padding: 20px;
  display: flex;
  flex-direction: column;
  gap: 16px;
}

/* ── Responsive ── */
@media (max-width: 1100px) { .kpi-row-4 { grid-template-columns: repeat(2,1fr); } }
@media (max-width: 900px)  { .kpi-row-3 { grid-template-columns: 1fr; } }
@media (max-width: 700px)  { .kpi-row-4 { grid-template-columns: 1fr; } .exec-headline { font-size: 1.25rem; } .exec-banner, .rec-block { padding: 20px; } }
</style>

<!-- ══════════════════════════════════════
     SQL — SHARED
══════════════════════════════════════ -->

```sql periode_30d
SELECT
    strftime('%d %b %Y', MAX(order_date) - INTERVAL '29 days') AS tgl_awal,
    strftime('%d %b %Y', MAX(order_date))                       AS tgl_akhir
FROM restaurant.peak_hours
```

<!-- ══════════════════════════════════════
     SQL — JAM SIBUK
══════════════════════════════════════ -->

```sql jam_metrics
WITH base_data AS (
    SELECT order_hour, day_part, SUM(total_orders) AS total_orders
    FROM restaurant.peak_hours
    WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '29 days'
    GROUP BY order_hour, day_part
),
hourly AS (
    SELECT order_hour, SUM(total_orders) AS total_orders FROM base_data GROUP BY order_hour
),
daypart AS (
    SELECT day_part, SUM(total_orders) AS total_orders FROM base_data GROUP BY day_part
),
stats AS (
    SELECT ROUND(AVG(total_orders),1) AS avg_orders, MAX(total_orders) AS max_orders, SUM(total_orders) AS grand_total
    FROM hourly
),
top3 AS (
    SELECT SUM(total_orders) AS top3_total
    FROM (SELECT total_orders FROM hourly ORDER BY total_orders DESC LIMIT 3)
),
thresholded AS (
    SELECT
        h.order_hour,
        h.total_orders,
        s.avg_orders,
        ROUND(s.avg_orders * 1.15, 1) AS peak_threshold,
        CASE WHEN h.total_orders >= s.avg_orders * 1.15 THEN 1 ELSE 0 END AS is_peak
    FROM hourly h CROSS JOIN stats s
),
busiest AS (SELECT day_part AS peak_daypart FROM daypart ORDER BY total_orders DESC LIMIT 1),
peak_candidates AS (
    SELECT
        CAST(order_hour AS INTEGER) AS order_hour,
        total_orders,
        CAST(order_hour AS INTEGER) - ROW_NUMBER() OVER (ORDER BY order_hour) AS grp
    FROM thresholded
    WHERE is_peak = 1
),
detected_windows AS (
    SELECT
        MIN(order_hour) AS start_hour,
        MAX(order_hour) AS end_hour,
        arg_max(order_hour, total_orders) AS peak_hour,
        MAX(total_orders) AS peak_orders,
        SUM(total_orders) AS window_orders
    FROM peak_candidates
    GROUP BY grp
),
fallback_window AS (
    SELECT
        CAST(order_hour AS INTEGER) AS start_hour,
        CAST(order_hour AS INTEGER) AS end_hour,
        CAST(order_hour AS INTEGER) AS peak_hour,
        total_orders AS peak_orders,
        total_orders AS window_orders
    FROM hourly
    ORDER BY total_orders DESC
    LIMIT 1
),
peak_windows AS (
    SELECT * FROM detected_windows
    UNION ALL
    SELECT * FROM fallback_window
    WHERE NOT EXISTS (SELECT 1 FROM detected_windows)
),
ranked_windows AS (
    SELECT
        *,
        ROW_NUMBER() OVER (ORDER BY start_hour) AS peak_rank
    FROM peak_windows
),
window_summary AS (
    SELECT
        COUNT(*) AS peak_count,
        MIN(start_hour) AS peak_window_start,
        MAX(end_hour) AS peak_window_end,
        MAX(CASE WHEN peak_rank = 1 THEN peak_hour END) AS primary_peak_hour,
        MAX(CASE WHEN peak_rank = 2 THEN peak_hour END) AS secondary_peak_hour,
        string_agg(CAST(peak_hour AS VARCHAR) || ':00', ' & ' ORDER BY start_hour) AS peak_hours_label,
        string_agg(
            CASE
                WHEN start_hour = end_hour THEN CAST(start_hour AS VARCHAR) || ':00'
                ELSE CAST(start_hour AS VARCHAR) || ':00-' || CAST(end_hour AS VARCHAR) || ':00'
            END,
            ', ' ORDER BY start_hour
        ) AS peak_windows_label
    FROM ranked_windows
)
SELECT
    ROUND(top3.top3_total * 100.0 / NULLIF(stats.grand_total, 0), 1) AS peak_share_pct,
    ROUND(stats.max_orders * 1.0   / NULLIF(stats.avg_orders,  0), 2) AS demand_surge,
    ws.peak_window_start,
    ws.peak_window_end,
    b.peak_daypart,
    ws.primary_peak_hour AS lunch_hour,
    ws.secondary_peak_hour AS dinner_hour,
    ws.peak_count,
    ws.peak_hours_label,
    ws.peak_windows_label,
    ROUND(stats.avg_orders * 1.15, 1) AS peak_threshold,
    CASE WHEN ws.peak_count = 2 THEN 1 ELSE 0 END AS is_bimodal,
    CASE
        WHEN ws.peak_count = 1 THEN 'single'
        WHEN ws.peak_count = 2 THEN 'dual'
        ELSE 'multi'
    END AS peak_pattern,
    CASE
        WHEN ROUND(top3.top3_total * 100.0 / NULLIF(stats.grand_total, 0), 1) > 65
          OR ROUND(stats.max_orders * 1.0   / NULLIF(stats.avg_orders,  0), 2) > 2.5 THEN 'kritis'
        WHEN ROUND(top3.top3_total * 100.0 / NULLIF(stats.grand_total, 0), 1) > 50
          OR ROUND(stats.max_orders * 1.0   / NULLIF(stats.avg_orders,  0), 2) > 1.5 THEN 'waspada'
        ELSE 'normal'
    END AS severity
FROM stats, top3, busiest b, window_summary ws
```

```sql hourly_trend
SELECT
    order_hour,
    SUM(total_orders)  AS total_orders,
    SUM(total_revenue) AS total_revenue
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '29 days'
GROUP BY order_hour ORDER BY order_hour
```

```sql weekday_weekend_hourly
WITH daily_hourly AS (
    SELECT
        order_date,
        CASE DAYNAME(order_date)
            WHEN 'Saturday' THEN 'Weekend'
            WHEN 'Sunday' THEN 'Weekend'
            ELSE 'Weekday'
        END AS tipe_hari,
        order_hour,
        SUM(total_orders) AS total_orders
    FROM restaurant.peak_hours
    WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '29 days'
    GROUP BY order_date, DAYNAME(order_date), order_hour
)
SELECT
    tipe_hari,
    order_hour,
    ROUND(AVG(total_orders), 0) AS avg_orders
FROM daily_hourly
GROUP BY tipe_hari, order_hour
ORDER BY CASE tipe_hari WHEN 'Weekday' THEN 1 ELSE 2 END, order_hour
```

```sql weekday_weekend_peaks
WITH daily_hourly AS (
    SELECT
        order_date,
        CASE DAYNAME(order_date)
            WHEN 'Saturday' THEN 'Weekend'
            WHEN 'Sunday' THEN 'Weekend'
            ELSE 'Weekday'
        END AS tipe_hari,
        order_hour,
        SUM(total_orders) AS total_orders
    FROM restaurant.peak_hours
    WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '29 days'
    GROUP BY order_date, DAYNAME(order_date), order_hour
),
hourly AS (
    SELECT tipe_hari, order_hour, ROUND(AVG(total_orders), 0) AS avg_orders
    FROM daily_hourly
    GROUP BY tipe_hari, order_hour
),
stats AS (
    SELECT tipe_hari, AVG(avg_orders) AS baseline_orders
    FROM hourly
    GROUP BY tipe_hari
),
peak_candidates AS (
    SELECT
        h.tipe_hari,
        CAST(h.order_hour AS INTEGER) AS order_hour,
        h.avg_orders,
        CAST(h.order_hour AS INTEGER) - ROW_NUMBER() OVER (PARTITION BY h.tipe_hari ORDER BY h.order_hour) AS grp
    FROM hourly h
    JOIN stats s USING (tipe_hari)
    WHERE h.avg_orders >= s.baseline_orders * 1.15
),
detected_windows AS (
    SELECT
        tipe_hari,
        MIN(order_hour) AS start_hour,
        MAX(order_hour) AS end_hour,
        arg_max(order_hour, avg_orders) AS peak_hour,
        MAX(avg_orders) AS peak_orders
    FROM peak_candidates
    GROUP BY tipe_hari, grp
),
fallback_window AS (
    SELECT tipe_hari, order_hour AS start_hour, order_hour AS end_hour, order_hour AS peak_hour, avg_orders AS peak_orders
    FROM (
        SELECT
            tipe_hari,
            CAST(order_hour AS INTEGER) AS order_hour,
            avg_orders,
            ROW_NUMBER() OVER (PARTITION BY tipe_hari ORDER BY avg_orders DESC) AS rn
        FROM hourly
    )
    WHERE rn = 1
),
peak_windows AS (
    SELECT * FROM detected_windows
    UNION ALL
    SELECT f.*
    FROM fallback_window f
    WHERE NOT EXISTS (
        SELECT 1 FROM detected_windows d WHERE d.tipe_hari = f.tipe_hari
    )
),
summary AS (
    SELECT
        tipe_hari,
        COUNT(*) AS peak_count,
        string_agg(CAST(peak_hour AS VARCHAR) || ':00', ' & ' ORDER BY start_hour) AS peak_hours,
        string_agg(
            CASE
                WHEN start_hour = end_hour THEN CAST(start_hour AS VARCHAR) || ':00'
                ELSE CAST(start_hour AS VARCHAR) || ':00-' || CAST(end_hour AS VARCHAR) || ':00'
            END,
            ', ' ORDER BY start_hour
        ) AS peak_windows
    FROM peak_windows
    GROUP BY tipe_hari
),
pivoted AS (
    SELECT
        MAX(CASE WHEN tipe_hari = 'Weekday' THEN peak_hours END) AS weekday_peak,
        MAX(CASE WHEN tipe_hari = 'Weekend' THEN peak_hours END) AS weekend_peak,
        MAX(CASE WHEN tipe_hari = 'Weekday' THEN peak_windows END) AS weekday_windows,
        MAX(CASE WHEN tipe_hari = 'Weekend' THEN peak_windows END) AS weekend_windows,
        MAX(CASE WHEN tipe_hari = 'Weekday' THEN peak_count END) AS weekday_peak_count,
        MAX(CASE WHEN tipe_hari = 'Weekend' THEN peak_count END) AS weekend_peak_count
    FROM summary
)
SELECT
    *,
    CASE
        WHEN weekday_peak = weekend_peak THEN 'mirip'
        ELSE 'berbeda'
    END AS pattern_status
FROM pivoted
```

```sql branch_peak_matrix
WITH daily_hourly AS (
    SELECT
        branch_name,
        order_date,
        CASE DAYNAME(order_date)
            WHEN 'Saturday' THEN 'Weekend'
            WHEN 'Sunday' THEN 'Weekend'
            ELSE 'Weekday'
        END AS tipe_hari,
        order_hour,
        SUM(total_orders) AS total_orders
    FROM restaurant.peak_hours
    WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '29 days'
    GROUP BY branch_name, order_date, DAYNAME(order_date), order_hour
),
hourly AS (
    SELECT branch_name, tipe_hari, order_hour, ROUND(AVG(total_orders), 0) AS avg_orders
    FROM daily_hourly
    GROUP BY branch_name, tipe_hari, order_hour
),
stats AS (
    SELECT branch_name, tipe_hari, AVG(avg_orders) AS baseline_orders
    FROM hourly
    GROUP BY branch_name, tipe_hari
),
peak_candidates AS (
    SELECT
        h.branch_name,
        h.tipe_hari,
        CAST(h.order_hour AS INTEGER) AS order_hour,
        h.avg_orders,
        CAST(h.order_hour AS INTEGER) - ROW_NUMBER() OVER (PARTITION BY h.branch_name, h.tipe_hari ORDER BY h.order_hour) AS grp
    FROM hourly h
    JOIN stats s USING (branch_name, tipe_hari)
    WHERE h.avg_orders >= s.baseline_orders * 1.15
),
detected_windows AS (
    SELECT
        branch_name,
        tipe_hari,
        MIN(order_hour) AS start_hour,
        MAX(order_hour) AS end_hour,
        arg_max(order_hour, avg_orders) AS peak_hour,
        MAX(avg_orders) AS peak_orders
    FROM peak_candidates
    GROUP BY branch_name, tipe_hari, grp
),
fallback_window AS (
    SELECT branch_name, tipe_hari, order_hour AS start_hour, order_hour AS end_hour, order_hour AS peak_hour, avg_orders AS peak_orders
    FROM (
        SELECT
            branch_name,
            tipe_hari,
            CAST(order_hour AS INTEGER) AS order_hour,
            avg_orders,
            ROW_NUMBER() OVER (PARTITION BY branch_name, tipe_hari ORDER BY avg_orders DESC) AS rn
        FROM hourly
    )
    WHERE rn = 1
),
peak_windows AS (
    SELECT * FROM detected_windows
    UNION ALL
    SELECT f.*
    FROM fallback_window f
    WHERE NOT EXISTS (
        SELECT 1
        FROM detected_windows d
        WHERE d.branch_name = f.branch_name
          AND d.tipe_hari = f.tipe_hari
    )
),
summary AS (
    SELECT
        branch_name,
        tipe_hari,
        COUNT(*) AS peak_count,
        string_agg(CAST(peak_hour AS VARCHAR) || ':00', ' & ' ORDER BY start_hour) AS peak_hours,
        string_agg(
            CASE
                WHEN start_hour = end_hour THEN CAST(start_hour AS VARCHAR) || ':00'
                ELSE CAST(start_hour AS VARCHAR) || ':00-' || CAST(end_hour AS VARCHAR) || ':00'
            END,
            ', ' ORDER BY start_hour
        ) AS peak_windows
    FROM peak_windows
    GROUP BY branch_name, tipe_hari
),
pivoted AS (
    SELECT
        branch_name,
        MAX(CASE WHEN tipe_hari = 'Weekday' THEN peak_hours END) AS weekday_peak,
        MAX(CASE WHEN tipe_hari = 'Weekend' THEN peak_hours END) AS weekend_peak,
        MAX(CASE WHEN tipe_hari = 'Weekday' THEN peak_windows END) AS weekday_windows,
        MAX(CASE WHEN tipe_hari = 'Weekend' THEN peak_windows END) AS weekend_windows,
        MAX(CASE WHEN tipe_hari = 'Weekday' THEN peak_count END) AS weekday_peak_count,
        MAX(CASE WHEN tipe_hari = 'Weekend' THEN peak_count END) AS weekend_peak_count
    FROM summary
    GROUP BY branch_name
)
SELECT
    branch_name,
    weekday_peak,
    weekend_peak,
    CASE
        WHEN weekday_peak = weekend_peak THEN 'Mirip'
        ELSE 'Berbeda'
    END AS pola,
    CASE
        WHEN weekday_peak_count > 1 AND weekend_peak_count = 1 THEN 'Weekday split shift; weekend fokus satu wave.'
        WHEN weekday_peak_count = 1 AND weekend_peak_count > 1 THEN 'Weekend perlu beberapa wave; weekday cukup satu window.'
        WHEN weekday_peak != weekend_peak THEN 'Buat template roster weekday/weekend berbeda.'
        ELSE 'SOP jam sibuk bisa relatif seragam.'
    END AS rekomendasi
FROM pivoted
ORDER BY branch_name
```

```sql prediksi_besok
SELECT
    CASE DAYNAME(CURRENT_DATE + INTERVAL '1 day')
        WHEN 'Monday' THEN 'Senin' WHEN 'Tuesday' THEN 'Selasa' WHEN 'Wednesday' THEN 'Rabu'
        WHEN 'Thursday' THEN 'Kamis' WHEN 'Friday' THEN 'Jumat'
        WHEN 'Saturday' THEN 'Sabtu' WHEN 'Sunday' THEN 'Minggu'
    END AS nama_hari,
    CASE DAYNAME(CURRENT_DATE + INTERVAL '1 day')
        WHEN 'Saturday' THEN 'Weekend' WHEN 'Sunday' THEN 'Weekend' ELSE 'Weekday'
    END AS tipe_hari,
    ph.order_hour,
    ph.branch_name,
    ROUND(AVG(ph.daily_total), 0) AS prediksi_order
FROM (
    SELECT order_date, order_hour, branch_name, SUM(total_orders) AS daily_total
    FROM restaurant.peak_hours
    WHERE DAYNAME(order_date) = DAYNAME(CURRENT_DATE + INTERVAL '1 day')
      AND order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '29 days'
    GROUP BY order_date, order_hour, branch_name
) ph
GROUP BY ph.order_hour, ph.branch_name
ORDER BY ph.order_hour, ph.branch_name
```

<!-- ══════════════════════════════════════
     SQL — HARI RAMAI
══════════════════════════════════════ -->

```sql hari_metrics
WITH daily AS (
    SELECT
        order_date,
        CASE DAYNAME(order_date)
            WHEN 'Monday' THEN 'Senin' WHEN 'Tuesday' THEN 'Selasa' WHEN 'Wednesday' THEN 'Rabu'
            WHEN 'Thursday' THEN 'Kamis' WHEN 'Friday' THEN 'Jumat'
            WHEN 'Saturday' THEN 'Sabtu' WHEN 'Sunday' THEN 'Minggu'
        END AS hari,
        CASE DAYNAME(order_date) WHEN 'Saturday' THEN 'Weekend' WHEN 'Sunday' THEN 'Weekend' ELSE 'Weekday' END AS tipe_hari,
        SUM(total_orders) AS total_orders
    FROM restaurant.peak_hours
    WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '29 days'
    GROUP BY order_date, DAYNAME(order_date)
),
by_day AS (
    SELECT hari, tipe_hari, ROUND(AVG(total_orders), 0) AS avg_orders, SUM(total_orders) AS sum_orders
    FROM daily GROUP BY hari, tipe_hari
),
totals AS (SELECT SUM(sum_orders) AS grand_total FROM by_day),
busiest  AS (SELECT hari AS busiest_day,  avg_orders AS busiest_orders  FROM by_day ORDER BY avg_orders DESC LIMIT 1),
quietest AS (SELECT hari AS quietest_day, avg_orders AS quietest_orders FROM by_day ORDER BY avg_orders ASC  LIMIT 1),
weekend_t AS (SELECT SUM(sum_orders) AS weekend_orders FROM by_day WHERE tipe_hari = 'Weekend')
SELECT
    b.busiest_day,  b.busiest_orders,
    q.quietest_day, q.quietest_orders,
    ROUND((b.busiest_orders - q.quietest_orders) * 100.0 / NULLIF(q.quietest_orders, 0), 0) AS gap_pct,
    ROUND(w.weekend_orders * 100.0 / NULLIF(t.grand_total, 0), 1) AS weekend_share_pct,
    CASE
        WHEN ROUND(w.weekend_orders * 100.0 / NULLIF(t.grand_total, 0), 1) >= 35 THEN 'weekend_dominan'
        WHEN ROUND((b.busiest_orders - q.quietest_orders) * 100.0 / NULLIF(q.quietest_orders, 0), 0) >= 80 THEN 'gap_besar'
        ELSE 'merata'
    END AS pola
FROM busiest b, quietest q, weekend_t w, totals t
```

```sql daily_avg
WITH daily AS (
    SELECT
        order_date,
        DAYNAME(order_date) AS day_name,
        SUM(total_orders)   AS daily_orders,
        SUM(total_revenue)  AS daily_revenue
    FROM restaurant.peak_hours
    WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '29 days'
    GROUP BY order_date, DAYNAME(order_date)
)
SELECT
    CASE day_name
        WHEN 'Monday' THEN 'Senin' WHEN 'Tuesday' THEN 'Selasa' WHEN 'Wednesday' THEN 'Rabu'
        WHEN 'Thursday' THEN 'Kamis' WHEN 'Friday' THEN 'Jumat'
        WHEN 'Saturday' THEN 'Sabtu' WHEN 'Sunday' THEN 'Minggu'
    END AS hari,
    CASE day_name
        WHEN 'Monday' THEN 1 WHEN 'Tuesday' THEN 2 WHEN 'Wednesday' THEN 3
        WHEN 'Thursday' THEN 4 WHEN 'Friday' THEN 5 WHEN 'Saturday' THEN 6 WHEN 'Sunday' THEN 7
    END AS hari_urut,
    ROUND(AVG(daily_orders),  0) AS rata_order,
    ROUND(AVG(daily_revenue), 0) AS rata_revenue
FROM daily
GROUP BY day_name
ORDER BY hari_urut
```

```sql branch_daily
WITH daily AS (
    SELECT
        branch_name,
        order_date,
        DAYNAME(order_date) AS day_name,
        SUM(total_orders)   AS daily_orders
    FROM restaurant.peak_hours
    WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '29 days'
    GROUP BY branch_name, order_date, DAYNAME(order_date)
)
SELECT
    branch_name,
    CASE day_name
        WHEN 'Monday' THEN 'Senin' WHEN 'Tuesday' THEN 'Selasa' WHEN 'Wednesday' THEN 'Rabu'
        WHEN 'Thursday' THEN 'Kamis' WHEN 'Friday' THEN 'Jumat'
        WHEN 'Saturday' THEN 'Sabtu' WHEN 'Sunday' THEN 'Minggu'
    END AS hari,
    CASE day_name
        WHEN 'Monday' THEN 1 WHEN 'Tuesday' THEN 2 WHEN 'Wednesday' THEN 3
        WHEN 'Thursday' THEN 4 WHEN 'Friday' THEN 5 WHEN 'Saturday' THEN 6 WHEN 'Sunday' THEN 7
    END AS hari_urut,
    ROUND(AVG(daily_orders), 0) AS rata_order
FROM daily
GROUP BY branch_name, day_name
ORDER BY hari_urut, branch_name
```

<!-- ══════════════════════════════════════
     SQL — VOLATILITAS
══════════════════════════════════════ -->

```sql volatility_metrics
WITH daily AS (
    SELECT
        order_date,
        DAYNAME(order_date) AS day_name,
        SUM(total_orders) AS daily_orders
    FROM restaurant.peak_hours
    WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '29 days'
    GROUP BY order_date, DAYNAME(order_date)
),
day_baseline AS (
    SELECT
        day_name,
        AVG(daily_orders) AS expected_orders
    FROM daily
    GROUP BY day_name
),
scored AS (
    SELECT
        d.order_date,
        d.day_name,
        d.daily_orders,
        b.expected_orders,
        ROUND((d.daily_orders - b.expected_orders) * 100.0 / NULLIF(b.expected_orders, 0), 1) AS deviation_pct
    FROM daily d
    JOIN day_baseline b USING (day_name)
),
stats AS (
    SELECT
        AVG(expected_orders) AS avg_orders,
        MAX(daily_orders) AS max_orders,
        MIN(daily_orders) AS min_orders,
        ROUND(AVG(ABS(deviation_pct)), 1) AS avg_abs_deviation_pct,
        COUNT(*) AS total_days
    FROM scored
),
anomalies AS (
    SELECT
        COUNT(CASE WHEN deviation_pct >= 25 THEN 1 END) AS spike_days,
        COUNT(CASE WHEN deviation_pct <= -25 THEN 1 END) AS drop_days
    FROM scored
),
spike_day AS (
    SELECT
        order_date AS spike_date,
        daily_orders AS spike_orders,
        ROUND(expected_orders, 0) AS spike_expected_orders,
        deviation_pct AS spike_deviation_pct
    FROM scored
    ORDER BY deviation_pct DESC
    LIMIT 1
),
drop_day AS (
    SELECT
        order_date AS drop_date,
        daily_orders AS drop_orders,
        ROUND(expected_orders, 0) AS drop_expected_orders,
        deviation_pct AS drop_deviation_pct
    FROM scored
    ORDER BY deviation_pct ASC
    LIMIT 1
)
SELECT
    ROUND(s.avg_orders, 0)  AS avg_orders,
    s.max_orders, s.min_orders, s.avg_abs_deviation_pct, s.total_days,
    a.spike_days, a.drop_days, (a.spike_days + a.drop_days) AS anomaly_days,
    s.avg_abs_deviation_pct AS cv_pct,
    sp.spike_date, sp.spike_orders, sp.spike_expected_orders, sp.spike_deviation_pct,
    dr.drop_date, dr.drop_orders, dr.drop_expected_orders, dr.drop_deviation_pct,
    CASE
        WHEN s.avg_abs_deviation_pct > 20 THEN 'tinggi'
        WHEN s.avg_abs_deviation_pct > 10 THEN 'sedang'
        ELSE 'rendah'
    END AS volatility_level,
    CASE
        WHEN s.avg_abs_deviation_pct > 100 THEN 0
        ELSE ROUND(100 - s.avg_abs_deviation_pct, 0)
    END AS stability_index
FROM stats s, anomalies a, spike_day sp, drop_day dr
```

```sql daily_trend
SELECT order_date, SUM(total_orders) AS daily_orders, SUM(total_revenue) AS daily_revenue
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '29 days'
GROUP BY order_date ORDER BY order_date
```

```sql anomaly_detail
WITH daily AS (
    SELECT
        order_date,
        DAYNAME(order_date) AS day_name,
        SUM(total_orders) AS daily_orders
    FROM restaurant.peak_hours
    WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '29 days'
    GROUP BY order_date, DAYNAME(order_date)
),
day_baseline AS (
    SELECT day_name, AVG(daily_orders) AS expected_orders
    FROM daily
    GROUP BY day_name
),
scored AS (
    SELECT
        d.order_date,
        d.daily_orders,
        ROUND(b.expected_orders, 0) AS expected_orders,
        ROUND((d.daily_orders - b.expected_orders) * 100.0 / NULLIF(b.expected_orders, 0), 1) AS deviation_pct
    FROM daily d
    JOIN day_baseline b USING (day_name)
)
SELECT
    order_date,
    daily_orders,
    expected_orders,
    CASE WHEN deviation_pct >= 25 THEN 'Lonjakan' ELSE 'Penurunan' END AS status,
    deviation_pct AS selisih_pct
FROM scored
WHERE deviation_pct >= 25 OR deviation_pct <= -25
ORDER BY order_date
```

<!-- ══════════════════════════════════════
     SQL — MUSIMAN
══════════════════════════════════════ -->

```sql seasonal_metrics
WITH monthly_by_year AS (
    -- Tahap 1: total per bulan per tahun — jangan SUM lintas tahun
    SELECT
        YEAR(order_date)  AS tahun,
        MONTH(order_date) AS bulan_num,
        CASE WHEN MONTH(order_date) IN (1,2,3)   THEN 'Q1'
             WHEN MONTH(order_date) IN (4,5,6)   THEN 'Q2'
             WHEN MONTH(order_date) IN (7,8,9)   THEN 'Q3'
             ELSE 'Q4' END AS kuartal,
        SUM(total_orders)  AS monthly_orders,
        SUM(total_revenue) AS monthly_revenue
    FROM restaurant.peak_hours
    GROUP BY YEAR(order_date), MONTH(order_date)
),
monthly_avg AS (
    -- Tahap 2: rata-rata tiap bulan lintas tahun
    -- Bulan yang ada data 3 tahun tidak lebih berat dari bulan yang ada 2 tahun
    SELECT
        bulan_num, kuartal,
        ROUND(AVG(monthly_orders),  0) AS avg_monthly_orders,
        ROUND(AVG(monthly_revenue), 0) AS avg_monthly_revenue
    FROM monthly_by_year
    GROUP BY bulan_num, kuartal
),
quarterly AS (
    -- Tahap 3: rata-rata bulanan per kuartal
    SELECT kuartal, ROUND(AVG(avg_monthly_orders), 0) AS q_avg_orders
    FROM monthly_avg GROUP BY kuartal
),
strongest AS (SELECT kuartal AS strongest_q, q_avg_orders AS max_q_orders FROM quarterly ORDER BY q_avg_orders DESC LIMIT 1),
weakest   AS (SELECT kuartal AS weakest_q,   q_avg_orders AS min_q_orders FROM quarterly ORDER BY q_avg_orders ASC  LIMIT 1),
growth AS (
    SELECT ROUND((last_monthly_orders - first_monthly_orders) * 100.0 / NULLIF(first_monthly_orders, 0), 1) AS growth_pct
    FROM (
        SELECT
            MAX(CASE WHEN rn_asc = 1 THEN monthly_orders END) AS first_monthly_orders,
            MAX(CASE WHEN rn_desc = 1 THEN monthly_orders END) AS last_monthly_orders
        FROM (
            SELECT
                monthly_orders,
                ROW_NUMBER() OVER (ORDER BY tahun, bulan_num) AS rn_asc,
                ROW_NUMBER() OVER (ORDER BY tahun DESC, bulan_num DESC) AS rn_desc
            FROM monthly_by_year
        )
    )
),
holiday_avg     AS (SELECT AVG(avg_monthly_orders) AS avg_h FROM monthly_avg WHERE bulan_num IN (12,1,6,7)),
non_holiday_avg AS (SELECT AVG(avg_monthly_orders) AS avg_n FROM monthly_avg WHERE bulan_num NOT IN (12,1,6,7))
SELECT
    s.strongest_q, s.max_q_orders,
    w.weakest_q,   w.min_q_orders,
    g.growth_pct,
    ROUND((h.avg_h - n.avg_n) * 100.0 / NULLIF(n.avg_n, 0), 1) AS holiday_effect_pct,
    ROUND((s.max_q_orders - w.min_q_orders) * 100.0 / NULLIF(w.min_q_orders, 0), 0) AS seasonal_gap_pct,
    CASE
        WHEN ROUND((s.max_q_orders - w.min_q_orders) * 100.0 / NULLIF(w.min_q_orders, 0), 0) >= 40 THEN 'kuat'
        WHEN ROUND((s.max_q_orders - w.min_q_orders) * 100.0 / NULLIF(w.min_q_orders, 0), 0) >= 20 THEN 'moderat'
        ELSE 'lemah'
    END AS seasonal_strength
FROM strongest s, weakest w, growth g, holiday_avg h, non_holiday_avg n
```

```sql monthly_trend
WITH max_d AS (
    SELECT MAX(order_date) AS max_date
    FROM restaurant.peak_hours
),
monthly AS (
SELECT
    DATE_TRUNC('month', order_date) AS bulan,
    YEAR(order_date) AS tahun,
    MONTH(order_date) AS bulan_num,
    CASE MONTH(order_date)
        WHEN 1 THEN 'Jan' WHEN 2 THEN 'Feb' WHEN 3 THEN 'Mar' WHEN 4 THEN 'Apr'
        WHEN 5 THEN 'Mei' WHEN 6 THEN 'Jun' WHEN 7 THEN 'Jul' WHEN 8 THEN 'Agu'
        WHEN 9 THEN 'Sep' WHEN 10 THEN 'Okt' WHEN 11 THEN 'Nov' WHEN 12 THEN 'Des'
    END AS nama_bulan,
    CASE MONTH(order_date)
        WHEN 1 THEN 'Jan' WHEN 2 THEN 'Feb' WHEN 3 THEN 'Mar' WHEN 4 THEN 'Apr'
        WHEN 5 THEN 'Mei' WHEN 6 THEN 'Jun' WHEN 7 THEN 'Jul' WHEN 8 THEN 'Agu'
        WHEN 9 THEN 'Sep' WHEN 10 THEN 'Okt' WHEN 11 THEN 'Nov' WHEN 12 THEN 'Des'
    END || ' ' || CAST(YEAR(order_date) AS VARCHAR) AS bulan_label,
    SUM(total_orders)  AS monthly_orders,
    SUM(total_revenue) AS monthly_revenue,
    COUNT(DISTINCT order_date) AS days_recorded,
    MAX(order_date) AS max_order_date
FROM restaurant.peak_hours
GROUP BY DATE_TRUNC('month', order_date), MONTH(order_date), YEAR(order_date)
),
baseline_same_month AS (
    SELECT
        m.bulan_num,
        ROUND(AVG(m.monthly_orders), 0) AS baseline_orders,
        ROUND(AVG(m.monthly_revenue), 0) AS baseline_revenue
    FROM monthly m
    CROSS JOIN max_d
    WHERE DATE_TRUNC('month', m.bulan) < DATE_TRUNC('month', max_d.max_date)
    GROUP BY m.bulan_num
)
SELECT
    m.*,
    DAY(DATE_TRUNC('month', m.bulan) + INTERVAL '1 month' - INTERVAL '1 day') AS days_in_month,
    ROUND(m.monthly_orders * 1.0 / NULLIF(m.days_recorded, 0), 1) AS daily_order_pace,
    ROUND(m.monthly_revenue * 1.0 / NULLIF(m.days_recorded, 0), 0) AS daily_revenue_pace,
    ROUND((m.monthly_orders * 1.0 / NULLIF(m.days_recorded, 0)) * DAY(DATE_TRUNC('month', m.bulan) + INTERVAL '1 month' - INTERVAL '1 day'), 0) AS projected_orders,
    ROUND((m.monthly_revenue * 1.0 / NULLIF(m.days_recorded, 0)) * DAY(DATE_TRUNC('month', m.bulan) + INTERVAL '1 month' - INTERVAL '1 day'), 0) AS projected_revenue,
    b.baseline_orders,
    b.baseline_revenue,
    ROUND((((m.monthly_orders * 1.0 / NULLIF(m.days_recorded, 0)) * DAY(DATE_TRUNC('month', m.bulan) + INTERVAL '1 month' - INTERVAL '1 day')) - b.baseline_orders) * 100.0 / NULLIF(b.baseline_orders, 0), 1) AS projected_vs_baseline_pct,
    CASE
        WHEN b.baseline_orders IS NULL THEN 'Belum ada baseline historis'
        WHEN ROUND((((m.monthly_orders * 1.0 / NULLIF(m.days_recorded, 0)) * DAY(DATE_TRUNC('month', m.bulan) + INTERVAL '1 month' - INTERVAL '1 day')) - b.baseline_orders) * 100.0 / NULLIF(b.baseline_orders, 0), 1) > 10 THEN 'Di atas ekspektasi'
        WHEN ROUND((((m.monthly_orders * 1.0 / NULLIF(m.days_recorded, 0)) * DAY(DATE_TRUNC('month', m.bulan) + INTERVAL '1 month' - INTERVAL '1 day')) - b.baseline_orders) * 100.0 / NULLIF(b.baseline_orders, 0), 1) < -10 THEN 'Di bawah ekspektasi'
        ELSE 'On track'
    END AS projection_status,
    CASE WHEN DATE_TRUNC('month', m.bulan) = DATE_TRUNC('month', max_d.max_date) THEN 1 ELSE 0 END AS is_current_month,
    CASE
        WHEN DATE_TRUNC('month', m.bulan) = DATE_TRUNC('month', max_d.max_date) THEN '🟡 Bulan berjalan'
        ELSE '✅ Bulan lengkap'
    END AS status_bulan,
    CASE
        WHEN DATE_TRUNC('month', m.bulan) = DATE_TRUNC('month', max_d.max_date)
            THEN 'Data baru sampai ' || strftime('%d %b %Y', m.max_order_date) || ' (' || CAST(m.days_recorded AS VARCHAR) || ' hari tercatat)'
        ELSE 'Data bulan penuh'
    END AS catatan_bulan
FROM monthly m
CROSS JOIN max_d
LEFT JOIN baseline_same_month b USING (bulan_num)
ORDER BY m.bulan DESC
```

```sql quarterly_trend
SELECT
    CASE WHEN MONTH(order_date) IN (1,2,3) THEN 'Q1'
         WHEN MONTH(order_date) IN (4,5,6) THEN 'Q2'
         WHEN MONTH(order_date) IN (7,8,9) THEN 'Q3'
         ELSE 'Q4' END AS kuartal,
    CASE WHEN MONTH(order_date) IN (1,2,3) THEN 1
         WHEN MONTH(order_date) IN (4,5,6) THEN 2
         WHEN MONTH(order_date) IN (7,8,9) THEN 3
         ELSE 4 END AS kuartal_urut,
    YEAR(order_date)       AS tahun,
    SUM(total_orders)      AS q_orders,
    SUM(total_revenue)     AS q_revenue
FROM restaurant.peak_hours
GROUP BY
    CASE WHEN MONTH(order_date) IN (1,2,3) THEN 'Q1'
         WHEN MONTH(order_date) IN (4,5,6) THEN 'Q2'
         WHEN MONTH(order_date) IN (7,8,9) THEN 'Q3'
         ELSE 'Q4' END,
    CASE WHEN MONTH(order_date) IN (1,2,3) THEN 1
         WHEN MONTH(order_date) IN (4,5,6) THEN 2
         WHEN MONTH(order_date) IN (7,8,9) THEN 3
         ELSE 4 END,
    YEAR(order_date)
ORDER BY kuartal_urut, tahun
```

---

_Sistem intelijen demand pelanggan — dari pola harian hingga pergeseran musiman._

<ButtonGroup name=view>
  <ButtonGroupItem valueLabel="⏰ Jam Sibuk"   value="jam"      default />
  <ButtonGroupItem valueLabel="📅 Hari Ramai"  value="hari" />
  <ButtonGroupItem valueLabel="📊 Volatilitas" value="volatilitas" />
  <ButtonGroupItem valueLabel="🗓️ Musiman"     value="musiman" />
</ButtonGroup>

<!-- ══════════════════════════════════════
     VIEW: JAM SIBUK
══════════════════════════════════════ -->
{#if inputs.view === 'jam' && jam_metrics.length > 0}

{@const ps  = jam_metrics[0].peak_share_pct}
{@const ds  = jam_metrics[0].demand_surge}
{@const pws = jam_metrics[0].peak_window_start}
{@const pwe = jam_metrics[0].peak_window_end}
{@const sev = jam_metrics[0].severity}
{@const pdp = jam_metrics[0].peak_daypart}
{@const bim = jam_metrics[0].is_bimodal}
{@const lh  = jam_metrics[0].lunch_hour}
{@const dh  = jam_metrics[0].dinner_hour}
{@const pc  = jam_metrics[0].peak_count}
{@const phl = jam_metrics[0].peak_hours_label}
{@const pwl = jam_metrics[0].peak_windows_label}
{@const pth = jam_metrics[0].peak_threshold}

<div class="pt-page">

  <div class="exec-banner">
    <div class="exec-eyebrow">⏰ Analisis Jam Sibuk · 30 Hari · {periode_30d[0].tgl_awal}–{periode_30d[0].tgl_akhir}</div>
    {#if pc > 2}
      <h2 class="exec-headline">Traffic punya {pc} puncak demand — kapasitas perlu disiapkan dalam beberapa wave.</h2>
      <p class="exec-body">Sistem mendeteksi beberapa peak window: <strong>{pwl}</strong>. Ini bukan satu shift panjang; setiap wave perlu kesiapan staf, bahan, dan service secara terpisah.</p>
      <span class="exec-tag warn">⚠️ Multi-peak demand: {phl}</span>
    {:else if pc === 2}
      <h2 class="exec-headline">Dua gelombang demand — dua puncak membutuhkan dua persiapan kapasitas terpisah.</h2>
      <p class="exec-body">Traffic membentuk pola dua puncak yang jelas: sekitar <strong>{phl}</strong>, dengan penurunan di antaranya. Ini bukan satu window panjang — ini dua lonjakan berbeda yang masing-masing butuh persiapan staf dan bahan secara mandiri.</p>
      <span class="exec-tag warn">⚠️ Dua window staf berbeda: {phl}</span>
    {:else if sev === 'kritis'}
      <h2 class="exec-headline">Lonjakan demand tajam — kapasitas operasional perlu dinaikkan segera.</h2>
      <p class="exec-body">Traffic pelanggan terkonsentrasi kuat di periode <strong>{pdp}</strong>, dengan lonjakan <strong>{ds}×</strong> di atas volume jam normal. Tanpa penambahan staf dan persiapan bahan di window puncak ({pws}:00–{pwe}:00), risiko antrean panjang dan penurunan kualitas servis sangat tinggi.</p>
      <span class="exec-tag kritis">🚨 Tindakan diperlukan sebelum window puncak berikutnya</span>
    {:else if sev === 'waspada'}
      <h2 class="exec-headline">Demand memuncak di periode {pdp} — persiapan kapasitas dianjurkan.</h2>
      <p class="exec-body">Traffic pelanggan secara konsisten paling tinggi di periode <strong>{pdp}</strong>, mencapai <strong>{ds}×</strong> volume jam rata-rata. Jadwal staf perlu disesuaikan dengan window {pws}:00–{pwe}:00 untuk mempertahankan kecepatan servis dan kepuasan pelanggan.</p>
      <span class="exec-tag warn">⚠️ Review jadwal staf untuk window {pws}:00–{pwe}:00</span>
    {:else}
      <h2 class="exec-headline">Pola demand stabil — operasional berjalan dalam batas normal.</h2>
      <p class="exec-body">Traffic pelanggan terdistribusi cukup merata sepanjang hari. Periode tersibuk adalah <strong>{pdp}</strong> dengan lonjakan <strong>{ds}×</strong> di atas rata-rata — masih dalam kapasitas operasional standar.</p>
      <span class="exec-tag ok">✅ Jadwal operasional saat ini sudah memadai</span>
		    {/if}
		  </div>

  <div class="strategic-stack">
			    <div class="strategic-header">
      <div class="strategic-eyebrow">🔭 Perspektif Jam Sibuk</div>
      <h2 class="strategic-title">Baca kapan kapasitas harus berada di level penuh</h2>
      <p class="strategic-copy">Dua lens utama di bawah ini memisahkan pertanyaan kapasitas dan respons: kapan demand benar-benar memuncak, dan apa yang harus disiapkan sebelum window tersebut dimulai?</p>
    </div>

    <details class="acc-strategic" open>
      <summary>⏰ Peak Window · Baca Konsentrasi dan Pola Jam</summary>
      <div class="acc-body">

  <details class="support-acc">
    <summary>📖 Metodologi deteksi puncak demand</summary>
    <div class="support-body">
      <div>
        Puncak dihitung dari data order 30 hari terakhir. Sistem membandingkan total order per jam dengan rata-rata order per jam. Jam dianggap peak jika volumenya minimal <strong>15% di atas rata-rata</strong> atau sekitar <strong>{pth} order</strong> pada data saat ini.
      </div>
      <div>
        Jam peak yang berurutan digabung menjadi satu window. Jika ada jeda di bawah threshold, window dipisah menjadi puncak berbeda. Dengan cara ini halaman bisa membaca single peak, dual peak, atau multi peak tanpa hardcode lunch/dinner.
      </div>
    </div>
  </details>

  <div class="kpi-row-3">
    <div class="kpi-card share">
      <div class="kpi-label">📊 Peak Demand Share</div>
      <div class="kpi-number">{ps}%</div>
      <div class="kpi-interp">
        {ps}% dari total order harian terjadi di 3 jam operasional tersibuk.
        {#if ps > 65} Lebih dari dua pertiga bisnis bergantung pada window sempit — gangguan di jam ini berdampak sangat besar.
        {:else if ps > 50} Lebih dari separuh transaksi terpusat — window puncak adalah tulang punggung pendapatan harian.
        {:else} Demand tersebar cukup merata; tidak ada window yang terlalu mendominasi.{/if}
      </div>
    </div>
    <div class="kpi-card surge">
      <div class="kpi-label">⚡ Demand Surge vs Baseline</div>
      <div class="kpi-number">{ds}×</div>
      <div class="kpi-interp">
        Jam tersibuk mencapai <strong>{ds}×</strong> volume jam normal.
        {#if ds > 2.5} Lonjakan ini membutuhkan kapasitas ekstra yang disiapkan sebelum window puncak dimulai.
        {:else if ds > 1.5} Lonjakan moderat yang bisa diantisipasi dengan penyesuaian jadwal ringan.
        {:else} Tidak ada lonjakan ekstrem; kapasitas standar sudah mencukupi.{/if}
      </div>
    </div>
    <div class="kpi-card window">
      <div class="kpi-label">{#if pc > 2}🕐 Multi Peak Window{:else if pc === 2}🕐 Dual Peak Window{:else}🕐 Critical Staffing Window{/if}</div>
      <div class="kpi-number">{#if pc > 1}{phl}{:else}{pws}:00–{pwe}:00{/if}</div>
      <div class="kpi-interp">
        {#if pc > 2}
          Ada {pc} puncak demand terpisah. Siapkan kapasitas <strong>30 menit sebelum setiap puncak</strong>, lalu gunakan lembah antar wave untuk restock, briefing, dan transisi shift.
        {:else if pc === 2}
          Ada dua puncak demand terpisah. Siapkan kapasitas <strong>30 menit sebelum {phl}</strong>, lalu gunakan lembah di antaranya untuk restock, briefing, dan transisi shift.
        {:else}
          Staf penuh dan bahan buffer harus siap <strong>30 menit sebelum {pws}:00</strong>. Di luar window ini kapasitas dapat dikurangi.
        {/if}
      </div>
    </div>
  </div>

  <div class="chart-section">
    <div class="chart-eyebrow">📈 Distribusi Demand Harian · 30 Hari Terakhir</div>
    <p class="chart-title">Pola volume order per jam — identifikasi kapan operasional harus berada di kapasitas penuh.</p>
    <BarChart data={hourly_trend} x="order_hour" y="total_orders" title="Total Order per Jam (30H)" xAxisTitle="Jam" yAxisTitle="Total Order" />
    <div class="chart-interp">
      {#if pc > 2}
        📌 Grafik menunjukkan <strong>{pc} puncak yang terpisah</strong>: {pwl}. Jangan membaca rentang ini sebagai satu shift penuh; treat sebagai beberapa wave demand, dengan valley antar peak sebagai waktu reset operasional.
      {:else if pc === 2}
        📌 Grafik menunjukkan <strong>dua puncak yang terpisah jelas</strong>: {pwl}. Jangan membaca {pws}:00–{pwe}:00 sebagai satu shift penuh; treat sebagai dua wave demand, dengan valley di antaranya sebagai waktu reset operasional.
      {:else if sev === 'kritis'}
        📌 Demand mulai mengakselerasi sebelum {pws}:00 dan tetap tinggi hingga {pwe}:00 — menciptakan <strong>window tekanan operasional yang panjang</strong>. Keterlambatan persiapan akan langsung terasa sebagai antrean dan penurunan kecepatan servis.
      {:else if sev === 'waspada'}
        📌 Pola demand menunjukkan <strong>akselerasi konsisten</strong> mendekati {pws}:00. Window {pws}:00–{pwe}:00 adalah periode di mana operasional harus berjalan tanpa hambatan.
      {:else}
        📌 Distribusi demand <strong>relatif merata</strong>. Window {pws}:00–{pwe}:00 tetap membutuhkan perhatian, namun tidak ada tekanan ekstrem yang mengharuskan perubahan jadwal mendasar.
      {/if}
    </div>
  </div>

      </div>
    </details>

    <details class="acc-strategic">
      <summary>🎯 Respons Operasional · Baca Staf, Bahan, dan Service</summary>
      <div class="acc-body">

        <div class="rec-title">
          {#if pc > 2}Tiga tindakan untuk mengelola beberapa gelombang demand dalam satu hari.
          {:else if pc === 2}Tiga tindakan untuk mengelola dua gelombang demand.
          {:else}Tiga tindakan untuk memastikan operasional siap di window puncak.{/if}
        </div>
        <div class="rec-list">
          <div class="rec-item">
            <div class="rec-icon">👥</div>
            <div class="rec-text">
              {#if pc > 2}
                <strong>Jadwalkan kapasitas sebagai beberapa wave, bukan satu blok panjang.</strong>
                Peak window terdeteksi di {pwl}. Gunakan split shift, staggered break, atau floating staff agar kapasitas naik hanya saat wave demand benar-benar datang.
              {:else if pc === 2}
                <strong>Jadwalkan dua gelombang staf sesuai dua puncak demand.</strong>
                Jangan jadwalkan kapasitas maksimum terus menerus dari {pws}:00 sampai {pwe}:00. Gunakan split shift atau staggered break agar biaya tenaga kerja tidak membengkak di lembah demand.
              {:else}
                <strong>Naikkan kapasitas staf dari {pws}:00 hingga {pwe}:00.</strong>
                Jadwalkan staf tambahan masuk 30 menit sebelum window dimulai. Di luar rentang ini jadwal standar sudah mencukupi.
              {/if}
            </div>
          </div>
          <div class="rec-item">
            <div class="rec-icon">📦</div>
            <div class="rec-text">
              {#if pc > 2}
                <strong>Pre-stage bahan baku sebelum setiap peak window.</strong>
                Restocking saat wave sedang berjalan memperlambat servis. Gunakan jeda antar puncak untuk refill station dan validasi bahan cepat habis.
              {:else if pc === 2}
                <strong>Pre-stage bahan baku dua kali: sebelum {phl}.</strong>
                Restocking saat jam sibuk memperlambat servis. Manfaatkan lembah antara dua puncak untuk mengisi ulang stok dapur tanpa mengganggu pelanggan aktif.
              {:else}
                <strong>Pre-stage bahan baku sebelum {pws}:00.</strong>
                Siapkan buffer bahan untuk estimasi volume puncak. Restocking di tengah jam sibuk memperlambat servis dan meningkatkan risiko kehabisan item menu.
              {/if}
            </div>
          </div>
          <div class="rec-item">
            <div class="rec-icon">⚡</div>
            <div class="rec-text">
              {#if pc > 2}
                <strong>Gunakan lembah antar wave sebagai reset operasional.</strong>
                Lakukan briefing singkat, refill, cleaning ringan, dan serah terima saat demand turun di bawah threshold peak, bukan saat bar mulai naik lagi.
              {:else if pc === 2}
                <strong>Manfaatkan lembah antara dua puncak untuk briefing, serah terima shift, dan evaluasi cepat.</strong>
                Jam sepi di antara dua puncak adalah waktu terbaik untuk koordinasi tim. Jangan jadwalkan training atau maintenance di jam peak: {phl}.
              {:else if ds > 1.5}
                <strong>Prioritaskan kecepatan servis selama {pws}:00–{pwe}:00.</strong>
                Dengan lonjakan {ds}× di atas normal, jadwalkan briefing, pelatihan, dan maintenance peralatan di luar window puncak.
              {:else}
                <strong>Pertahankan kecepatan servis di window {pws}:00–{pwe}:00.</strong>
                Menjaga kecepatan servis di jam-jam ini memaksimalkan kepuasan dan kapasitas throughput.
              {/if}
            </div>
          </div>
        </div>

      </div>
	    </details>
	
	    <details class="acc-strategic">
	      <summary>📂 Analisis Pendukung · Weekday vs Weekend dan Cabang</summary>
	      <div class="acc-body">

	        <div class="support-body">
	          <div>
	            <div style="font-size:10px;font-weight:700;letter-spacing:0.1em;text-transform:uppercase;color:var(--color-text-tertiary);margin-bottom:8px;">📆 Weekday vs Weekend · Template Jam Sibuk</div>
	            <p style="font-size:0.87rem;color:var(--color-text-secondary);line-height:1.65;margin:0 0 14px;">Pola jam sibuk bisa berbeda antara hari kerja dan akhir pekan. Chart ini memakai rata-rata order per jam per tipe hari, bukan total mentah, supaya weekday tidak terlihat lebih besar hanya karena jumlah harinya lebih banyak.</p>
	            <LineChart data={weekday_weekend_hourly} x="order_hour" y="avg_orders" series="tipe_hari" sort=false title="Rata-rata Order per Jam — Weekday vs Weekend" xAxisTitle="Jam" yAxisTitle="Rata-rata Order" />
	            <div class="chart-interp">
	              {#if weekday_weekend_peaks[0].pattern_status === 'berbeda'}
	                📌 <strong>Pola weekday dan weekend berbeda:</strong> weekday memuncak di <strong>{weekday_weekend_peaks[0].weekday_peak}</strong>, sedangkan weekend di <strong>{weekday_weekend_peaks[0].weekend_peak}</strong>. Jangan pakai satu template roster untuk semua hari; pisahkan template weekday dan weekend.
	              {:else}
	                📌 <strong>Pola weekday dan weekend mirip:</strong> keduanya memuncak di sekitar <strong>{weekday_weekend_peaks[0].weekday_peak}</strong>. SOP jam sibuk bisa relatif seragam, cukup sesuaikan volume staf sesuai traffic aktual.
	              {/if}
	            </div>
	          </div>

	          <div>
	            <div style="font-size:10px;font-weight:700;letter-spacing:0.1em;text-transform:uppercase;color:var(--color-text-tertiary);margin-bottom:8px;">🏪 Matrix Jam Sibuk per Cabang</div>
	            <p style="font-size:0.87rem;color:var(--color-text-secondary);line-height:1.65;margin:0 0 12px;">Gunakan matrix ini untuk melihat apakah tiap cabang butuh template roster berbeda. Ini bukan deep dive cabang, tapi ringkasan cepat agar keputusan staf tidak terlalu rata.</p>
	            <DataTable data={branch_peak_matrix}>
	              <Column id="branch_name" title="Cabang"/>
	              <Column id="weekday_peak" title="Peak Weekday"/>
	              <Column id="weekend_peak" title="Peak Weekend"/>
	              <Column id="pola" title="Pola"/>
	              <Column id="rekomendasi" title="Rekomendasi Roster"/>
	            </DataTable>
	          </div>
	        </div>

	      </div>
	    </details>

	    <details class="acc-strategic">
	      <summary>📂 Analisis Pendukung · Prediksi Besok dan Cara Pakai</summary>
	      <div class="acc-body">

        <div class="support-body">
          <div>
            <div style="font-size:10px;font-weight:700;letter-spacing:0.1em;text-transform:uppercase;color:var(--color-text-tertiary);margin-bottom:8px;">📅 Prediksi Besok · {prediksi_besok[0].nama_hari} ({prediksi_besok[0].tipe_hari})</div>
            <p style="font-size:0.87rem;color:var(--color-text-secondary);line-height:1.65;margin:0 0 14px;">Berdasarkan rata-rata order di hari {prediksi_besok[0].nama_hari} dalam 30 hari terakhir.
              {#if prediksi_besok[0].tipe_hari === 'Weekend'} Weekend umumnya 10–20% lebih ramai — pertimbangkan menaikkan estimasi ini.{/if}
            </p>
            <BarChart data={prediksi_besok} x="order_hour" y="prediksi_order" series="branch_name" type="stacked" title="Prediksi Order per Jam Besok — per Cabang" xAxisTitle="Jam" yAxisTitle="Prediksi Order" />
            <div class="chart-interp">
              📌 <strong>Cara membaca chart ini:</strong> tinggi bar menunjukkan estimasi order per jam besok, sedangkan warna menunjukkan kontribusi cabang. Gunakan puncak bar sebagai jadwal kesiapan staf dan bahan; cabang dengan kontribusi paling besar perlu dipastikan punya kapasitas dapur dan frontliner yang cukup.
            </div>
          </div>
          <div>
            <div style="font-size:10px;font-weight:700;letter-spacing:0.1em;text-transform:uppercase;color:var(--color-text-tertiary);margin-bottom:10px;">📖 Cara Pakai Prediksi</div>
            <div class="support-grid">
              <div class="support-item">
                <div class="support-item-label">Window Besok</div>
                <div class="support-item-title">Siapkan kapasitas sebelum bar tertinggi</div>
                <div class="support-item-desc">Puncak prediksi adalah jam yang perlu dijaga paling ketat. Staf, bahan, kasir, dan prep station sebaiknya siap 30 menit sebelumnya.</div>
              </div>
              <div class="support-item">
                <div class="support-item-label">Cabang Dominan</div>
                <div class="support-item-title">Baca warna terbesar di jam puncak</div>
                <div class="support-item-desc">Jika satu cabang mendominasi bar, fokuskan briefing dan validasi stok ke cabang itu. Jika merata, siapkan SOP puncak untuk semua cabang.</div>
              </div>
            </div>
          </div>
        </div>

      </div>
    </details>
  </div>

</div>

{/if}

<!-- ══════════════════════════════════════
     VIEW: HARI RAMAI
══════════════════════════════════════ -->
{#if inputs.view === 'hari' && hari_metrics.length > 0}

{@const bd   = hari_metrics[0].busiest_day}
{@const bo   = hari_metrics[0].busiest_orders}
{@const qd   = hari_metrics[0].quietest_day}
{@const qo   = hari_metrics[0].quietest_orders}
{@const gap  = hari_metrics[0].gap_pct}
{@const wsp  = hari_metrics[0].weekend_share_pct}
{@const pola = hari_metrics[0].pola}

<div class="pt-page">

  <div class="exec-banner">
    <div class="exec-eyebrow">📅 Pola Hari Ramai · 30 Hari · {periode_30d[0].tgl_awal}–{periode_30d[0].tgl_akhir}</div>
    {#if pola === 'weekend_dominan'}
      <h2 class="exec-headline">{bd} secara konsisten membawa traffic tertinggi — akhir pekan adalah engine pendapatan mingguan.</h2>
      <p class="exec-body">Akhir pekan menyumbang <strong>{wsp}%</strong> dari total order mingguan. Kapasitas weekday standar tidak cukup untuk Sabtu–Minggu. Selisih traffic antara hari tersibuk dan tersepi mencapai <strong>{gap}%</strong>.</p>
      <span class="exec-tag">📋 Optimalkan roster weekend — alokasikan hari sepi untuk training internal</span>
    {:else if pola === 'gap_besar'}
      <h2 class="exec-headline">Gap traffic mingguan sangat lebar — jadwal staf seragam tidak efisien.</h2>
      <p class="exec-body">Selisih antara <strong>{bd}</strong> dan <strong>{qd}</strong> mencapai <strong>{gap}%</strong>. Menjalankan kapasitas yang sama di semua hari berarti kelebihan staf di hari sepi dan kekurangan di hari ramai.</p>
      <span class="exec-tag warn">⚠️ Sesuaikan roster mingguan — jadwal seragam tidak efisien</span>
    {:else}
      <h2 class="exec-headline">Traffic mingguan terdistribusi merata — tidak ada hari yang dominan secara ekstrem.</h2>
      <p class="exec-body">Permintaan pelanggan relatif stabil sepanjang minggu dengan selisih <strong>{gap}%</strong> antara hari tersibuk dan tersepi. Masih dalam jangkauan jadwal operasional standar.</p>
      <span class="exec-tag ok">✅ Jadwal operasional saat ini sudah memadai — pantau pergeseran pola</span>
    {/if}
  </div>

  <div class="strategic-stack">
    <div class="strategic-header">
      <div class="strategic-eyebrow">🔭 Perspektif Hari Ramai</div>
      <h2 class="strategic-title">Baca ritme mingguan dan kebutuhan roster</h2>
      <p class="strategic-copy">Dua lens di bawah ini memisahkan pertanyaan pola dan tindakan: hari mana yang membutuhkan kapasitas lebih besar, dan bagaimana roster, training, serta promosi perlu diarahkan.</p>
    </div>

    <details class="acc-strategic" open>
      <summary>📅 Ritme Mingguan · Baca Hari Ramai dan Hari Sepi</summary>
      <div class="acc-body">

  <details class="support-acc">
    <summary>📖 Metodologi ritme mingguan</summary>
    <div class="support-body">
      <div>
        Hari tersibuk dan tersepi dihitung dari <strong>rata-rata order harian</strong> per nama hari dalam 30 hari terakhir, bukan dari satu tanggal ekstrem. Jadi angka <strong>{bd}</strong> dan <strong>{qd}</strong> membaca ritme mingguan yang berulang, bukan kejadian satu kali.
      </div>
      <div>
        <strong>Selisih traffic mingguan</strong> = (rata-rata hari tersibuk - rata-rata hari tersepi) / rata-rata hari tersepi. <strong>Kontribusi akhir pekan</strong> = total order Sabtu-Minggu dibanding total order dalam window data. Ambang awal: weekend dominan >=35%, gap besar >=80%, gap signifikan >=40%.
      </div>
    </div>
  </details>

  <div class="kpi-row-4">
    <div class="kpi-card busiest">
      <div class="kpi-label">🔴 Hari Tersibuk</div>
      <div class="kpi-number">{bd}</div>
      <div class="kpi-interp">Rata-rata <strong>{bo}</strong> order per {bd}. Hari ini membutuhkan kapasitas staf penuh dan persiapan bahan buffer sebelum operasional dimulai.</div>
    </div>
    <div class="kpi-card quietest">
      <div class="kpi-label">⚪ Hari Tersepi</div>
      <div class="kpi-number">{qd}</div>
      <div class="kpi-interp">Rata-rata <strong>{qo}</strong> order per {qd}. Kandidat terbaik untuk training staf, maintenance peralatan, dan kegiatan non-operasional lainnya.</div>
    </div>
    <div class="kpi-card gap-card">
      <div class="kpi-label">📊 Selisih Traffic Mingguan</div>
      <div class="kpi-number">{gap}%</div>
      <div class="kpi-interp">
        {#if gap >= 80} Selisih ekstrem — roster seragam akan selalu salah di salah satu ujung. Jadwal dinamis wajib diterapkan.
        {:else if gap >= 40} Selisih signifikan — pertimbangkan dua tier roster: hari ramai dan hari normal.
        {:else} Selisih moderat — jadwal standar masih bisa berjalan dengan optimasi minor.{/if}
      </div>
    </div>
    <div class="kpi-card weekend">
      <div class="kpi-label">📅 Kontribusi Akhir Pekan</div>
      <div class="kpi-number">{wsp}%</div>
      <div class="kpi-interp">
        {#if wsp >= 35} Lebih dari sepertiga pendapatan mingguan bergantung pada Sabtu–Minggu. Gangguan di hari ini sangat mahal.
        {:else if wsp >= 25} Kontribusi akhir pekan signifikan — butuh persiapan berbeda dari weekday.
        {:else} Akhir pekan tidak dominan — bisnis kemungkinan di area perkantoran atau transit.{/if}
      </div>
    </div>
  </div>

  <div class="chart-section">
    <div class="chart-eyebrow">📈 Ritme Mingguan · Rata-rata 30 Hari Terakhir</div>
    <p class="chart-title">Perbandingan volume order rata-rata per hari dalam seminggu.</p>
    <BarChart data={daily_avg} x="hari" y="rata_order" sort=false title="Rata-rata Order per Hari" xAxisTitle="Hari" yAxisTitle="Rata-rata Order" />
    <div class="chart-interp">
      {#if pola === 'weekend_dominan'}
        📌 Bar <strong>{bd}</strong> secara konsisten lebih tinggi dari hari lain. Alokasikan kapasitas operasional tertinggi di hari ini. Gunakan <strong>{qd}</strong> untuk aktivitas non-servis seperti inventaris atau pelatihan.
      {:else if pola === 'gap_besar'}
        📌 Perbedaan tinggi bar antara hari ramai dan sepi mencerminkan pola demand yang tidak merata. <strong>Jadwal roster tunggal tidak optimal</strong> — pertimbangkan dua template jadwal berbasis hari di atas dan di bawah rata-rata.
      {:else}
        📌 Tinggi bar relatif seragam — demand mingguan stabil. Tetap perhatikan hari dengan bar tertinggi karena itulah titik risiko kapasitas terbesar.
      {/if}
    </div>
  </div>

      </div>
    </details>

    <details class="acc-strategic">
      <summary>🎯 Respons Mingguan · Baca Roster, Training, dan Promosi</summary>
      <div class="acc-body">

    <div class="rec-title">Tiga tindakan untuk mengoptimalkan roster berbasis ritme demand aktual.</div>
    <div class="rec-list">
      <div class="rec-item">
        <div class="rec-icon">👥</div>
        <div class="rec-text"><strong>Naikkan kapasitas staf pada hari {bd}.</strong> Dengan rata-rata {bo} order, ini adalah hari dengan tekanan operasional tertinggi. Jadwalkan staf senior dan tambahan di hari ini berbasis kebutuhan aktual, bukan rotasi.</div>
      </div>
      <div class="rec-item">
        <div class="rec-icon">🎓</div>
        <div class="rec-text"><strong>Gunakan {qd} untuk training dan aktivitas internal.</strong> Hari tersepi dengan rata-rata {qo} order adalah waktu terbaik untuk onboarding staf baru, evaluasi prosedur, dan maintenance rutin.</div>
      </div>
      <div class="rec-item">
        <div class="rec-icon">📣</div>
        <div class="rec-text">
          <strong>Arahkan promosi ke hari-hari dengan traffic di bawah rata-rata.</strong>
          {#if wsp >= 35} Jangan promosikan akhir pekan — sudah ramai secara organik dan diskon hanya menggerus margin. Dorong traffic {qd} dan weekday lain yang sepi.
          {:else} Identifikasi hari dengan order terendah dan arahkan promosi ke sana. Meningkatkan traffic hari sepi lebih efisien dari mendorong hari yang sudah ramai.{/if}
        </div>
      </div>
    </div>

      </div>
    </details>

    <details class="acc-strategic">
      <summary>📂 Analisis Pendukung · Pola Harian per Cabang</summary>
      <div class="acc-body">

    <div class="support-body">
      <div>
        <div style="font-size:10px;font-weight:700;letter-spacing:0.1em;text-transform:uppercase;color:var(--color-text-tertiary);margin-bottom:8px;">🏪 Pola Harian per Cabang</div>
        <p style="font-size:0.87rem;color:var(--color-text-secondary);line-height:1.65;margin:0 0 14px;">Setiap cabang bisa memiliki ritme mingguan yang berbeda tergantung lokasi dan demografi. Gunakan data ini untuk membuat roster per cabang, bukan roster seragam.</p>
        <BarChart data={branch_daily} x="hari" y="rata_order" series="branch_name" sort=false type="grouped" title="Rata-rata Order per Hari — per Cabang" xAxisTitle="Hari" yAxisTitle="Rata-rata Order" />
        <div class="chart-interp">
          📌 <strong>Cara membaca chart ini:</strong> bandingkan bentuk bar antar cabang, bukan hanya totalnya. Jika satu cabang ramai di weekend sementara cabang lain ramai di weekday, roster dan promosi perlu dibuat per cabang. Jika semua cabang punya pola yang sama, kebijakan mingguan bisa dibuat sebagai SOP portfolio.
        </div>
      </div>
    </div>

      </div>
    </details>
  </div>

</div>

{/if}

<!-- ══════════════════════════════════════
     VIEW: VOLATILITAS
══════════════════════════════════════ -->
{#if inputs.view === 'volatilitas' && volatility_metrics.length > 0}

{@const vl  = volatility_metrics[0].volatility_level}
{@const si  = volatility_metrics[0].stability_index}
{@const cv  = volatility_metrics[0].cv_pct}
{@const ad  = volatility_metrics[0].anomaly_days}
{@const so  = volatility_metrics[0].spike_orders}
{@const dro = volatility_metrics[0].drop_orders}
{@const spd = volatility_metrics[0].spike_deviation_pct}
{@const dpd = volatility_metrics[0].drop_deviation_pct}
{@const sex = volatility_metrics[0].spike_expected_orders}
{@const dex = volatility_metrics[0].drop_expected_orders}
{@const sdt = volatility_metrics[0].spike_date}
{@const ddt = volatility_metrics[0].drop_date}

<div class="pt-page">

	  <div class="exec-banner">
	    <div class="exec-eyebrow">📊 Volatilitas Traffic · 30 Hari · {periode_30d[0].tgl_awal}–{periode_30d[0].tgl_akhir}</div>
	    {#if vl === 'tinggi'}
	      <h2 class="exec-headline">Traffic tidak stabil bahkan setelah ritme mingguan diperhitungkan.</h2>
	      <p class="exec-body">Deviasi rata-rata terhadap baseline hari yang sama mencapai <strong>{cv}%</strong>. Dalam 30 hari terakhir terdapat <strong>{ad} hari</strong> dengan demand menyimpang lebih dari 25% dari pola normalnya. Operasional perlu buffer kapasitas fleksibel, bukan jadwal staf yang kaku.</p>
	      <span class="exec-tag kritis">🚨 Siapkan contingency plan — demand sering meleset dari baseline</span>
	    {:else if vl === 'sedang'}
	      <h2 class="exec-headline">Traffic cukup bisa diprediksi, namun masih ada beberapa hari yang meleset dari baseline.</h2>
	      <p class="exec-body">Deviasi rata-rata terhadap baseline hari yang sama sebesar <strong>{cv}%</strong>. Ada <strong>{ad} hari anomali</strong> dalam 30 hari — cukup rendah untuk dikelola, tapi tetap perlu dibaca penyebabnya.</p>
	      <span class="exec-tag warn">⚠️ Review hari anomali — cari pola untuk antisipasi berikutnya</span>
		    {:else}
		      <h2 class="exec-headline">Traffic relatif stabil — permintaan harian mengikuti pola mingguan dengan baik.</h2>
		      <p class="exec-body">Deviasi rata-rata hanya <strong>{cv}%</strong> terhadap baseline hari yang sama, dengan <strong>{ad} hari anomali</strong> dalam 30 hari. Jadwal berbasis pola mingguan sudah cukup kuat sebagai baseline operasional.</p>
		      <span class="exec-tag ok">✅ Baseline mingguan bisa dipakai untuk planning — pantau anomali berkala</span>
		    {/if}
		  </div>

  <div class="chart-section">
    <div class="chart-eyebrow">📖 Cara Membaca Volatilitas</div>
    <p class="chart-title">Volatilitas membaca seberapa sering demand harian meleset dari pola normalnya.</p>
    <div class="support-body" style="padding:0;">
      <div>
        Subpage ini tidak mencari hari mana yang paling ramai. Itu sudah dijawab di <strong>Hari Ramai</strong>. Di sini pertanyaannya berbeda: setelah ritme mingguan normal diperhitungkan, apakah order aktual masih sering meleset jauh dari ekspektasi?
      </div>
      <div class="support-grid">
        <div class="support-item">
          <div class="support-item-label">Indeks Prediktabilitas</div>
          <div class="support-item-title">Seberapa aman baseline dipakai</div>
          <div class="support-item-desc">Semakin tinggi berarti demand semakin mudah diprediksi. ≥90 sangat stabil, 80–89 cukup stabil, &lt;80 berarti perlu buffer staf dan bahan.</div>
        </div>
        <div class="support-item">
          <div class="support-item-label">Deviasi Rata-rata</div>
          <div class="support-item-title">Jarak aktual dari ekspektasi</div>
          <div class="support-item-desc">Deviasi membaca seberapa jauh order aktual meleset dari baseline hari yang sama. Baseline Senin dibanding Senin, Sabtu dibanding Sabtu.</div>
        </div>
        <div class="support-item">
          <div class="support-item-label">Hari Tidak Normal</div>
          <div class="support-item-title">Hari yang perlu investigasi</div>
          <div class="support-item-desc">Hari yang order aktualnya lebih dari 25% di atas atau di bawah baseline. Makin sering muncul, makin lemah kualitas planning standar.</div>
        </div>
        <div class="support-item">
          <div class="support-item-label">Deviasi Terbesar</div>
          <div class="support-item-title">Lonjakan/drop paling ekstrem</div>
          <div class="support-item-desc">Lonjakan dan penurunan paling ekstrem dibanding baseline. Angka ini membantu menentukan apakah perlu investigasi event, promo, stok, service, atau channel order.</div>
        </div>
      </div>
      <div class="chart-interp" style="margin-top:0;">
        📌 <strong>Contoh baca sederhana:</strong> jika Sabtu biasanya 500 order lalu Sabtu ini 520, itu normal. Tapi jika Sabtu biasanya 500 lalu turun ke 350, itu volatilitas karena meleset jauh dari pola Sabtu yang biasa.
      </div>
    </div>
  </div>

  <div class="strategic-stack">
	    <div class="strategic-header">
	      <div class="strategic-eyebrow">🔭 Perspektif Volatilitas</div>
	      <h2 class="strategic-title">Baca seberapa bisa diprediksi demand harian</h2>
	      <p class="strategic-copy">Dua lens di bawah ini memisahkan stabilitas dan respons: apakah demand masih mengikuti baseline hari yang sama, dan kapan bisnis perlu buffer kapasitas fleksibel.</p>
	    </div>

	    <details class="acc-strategic" open>
	      <summary>📊 Stabilitas Harian · Baca Fluktuasi dan Anomali</summary>
	      <div class="acc-body">

  <div class="kpi-row-4">
    <div class="kpi-card stability">
      <div class="kpi-label">🛡️ Indeks Prediktabilitas</div>
      <div class="kpi-number">{si}</div>
      <div class="kpi-interp">
        Skala 0–100 setelah baseline hari yang sama diperhitungkan.
        {#if si >= 90} Sangat mudah diprediksi — jadwal berbasis pola mingguan sudah cukup kuat.
        {:else if si >= 80} Cukup stabil — gunakan baseline mingguan dengan buffer ringan di hari rawan.
        {:else} Tidak stabil — kapasitas fleksibel dan contingency plan diperlukan setiap minggu.{/if}
      </div>
    </div>
    <div class="kpi-card spike">
      <div class="kpi-label">⬆️ Deviasi Naik Terbesar</div>
      <div class="kpi-number">+{spd}%</div>
      <div class="kpi-interp">
        Pada {sdt}, order aktual <strong>{so}</strong> vs baseline <strong>{sex}</strong>.
        {#if spd >= 50} Lonjakan ekstrem — cari pemicu spesifik seperti event, promo, cuaca, atau order grup.
        {:else if spd >= 25} Lonjakan signifikan — perlu masuk daftar antisipasi operasional.
        {:else} Masih dekat dengan baseline normal hari yang sama.{/if}
      </div>
    </div>
    <div class="kpi-card drop">
      <div class="kpi-label">⬇️ Deviasi Turun Terbesar</div>
      <div class="kpi-number">{dpd}%</div>
      <div class="kpi-interp">
        Pada {ddt}, order aktual <strong>{dro}</strong> vs baseline <strong>{dex}</strong>.
        {#if dpd <= -50} Penurunan ekstrem — audit penyebab eksternal atau gangguan operasional.
        {:else if dpd <= -25} Penurunan signifikan — validasi apakah ada faktor berulang yang bisa diantisipasi.
        {:else} Penurunan masih dalam variasi normal.{/if}
      </div>
    </div>
    <div class="kpi-card anomaly">
      <div class="kpi-label">⚠️ Hari Tidak Normal</div>
      <div class="kpi-number">{ad}</div>
      <div class="kpi-interp">
        {ad} dari 30 hari terakhir menyimpang lebih dari ±25% dari baseline hari yang sama.
        {#if ad >= 6} Frekuensi tinggi — anomali sudah menjadi pola operasional yang perlu dipelajari.
        {:else if ad >= 3} Frekuensi moderat — perlu dipelajari apakah ada pola di balik hari-hari ini.
        {:else} Frekuensi rendah — tidak memerlukan perubahan sistemik.{/if}
      </div>
    </div>
  </div>

	  <div class="chart-section">
	    <div class="chart-eyebrow">📈 Tren Traffic Harian · 30 Hari Terakhir</div>
	    <p class="chart-title">Fluktuasi volume order harian — baca titik yang menyimpang dari pola normal hari yang sama.</p>
	    <LineChart data={daily_trend} x="order_date" y="daily_orders" title="Total Order Harian (30H)" xAxisTitle="Tanggal" yAxisTitle="Total Order" />
	    <div class="chart-interp">
	      {#if vl === 'tinggi'}
	        📌 Garis tren perlu dibaca bersama baseline hari yang sama: masalahnya bukan sekadar weekend naik atau weekday turun, tapi <strong>hari tertentu sering meleset dari ekspektasi normalnya</strong>. Prioritas: cari pemicu anomali yang berulang.
	      {:else if vl === 'sedang'}
	        📌 Tren masih cukup terbaca, tetapi ada <strong>beberapa titik yang meleset dari baseline</strong>. Review tanggal anomali di analisis pendukung untuk membedakan faktor eksternal dan masalah operasional.
	      {:else}
	        📌 Garis tren mengikuti ritme normal dengan deviasi kecil — <strong>permintaan dapat diprediksi</strong>. Gunakan baseline hari yang sama untuk staffing, prep bahan, dan estimasi demand.
	      {/if}
	    </div>
	  </div>

      </div>
    </details>

    <details class="acc-strategic">
      <summary>🎯 Respons Ketidakpastian · Baca Buffer dan Forecasting</summary>
      <div class="acc-body">


	    <div class="rec-title">Tiga tindakan untuk membangun operasional yang tahan terhadap fluktuasi demand.</div>
	    <div class="rec-list">
	      <div class="rec-item">
	        <div class="rec-icon">🔄</div>
	        <div class="rec-text">
	          <strong>Siapkan buffer kapasitas staf yang fleksibel.</strong>
	          {#if vl === 'tinggi'} Dengan deviasi rata-rata {cv}%, jadwal staf kaku akan sering salah. Identifikasi 1–2 staf per shift yang bisa dipanggil saat demand melewati baseline hari yang sama.
	          {:else} Pertahankan opsi buffer ringan untuk hari anomali. Frekuensi {ad} hari per 30 hari menunjukkan risiko masih terbatas dan tidak perlu mengubah seluruh roster.{/if}
	        </div>
	      </div>
	      <div class="rec-item">
	        <div class="rec-icon">🔍</div>
	        <div class="rec-text"><strong>Investigasi penyebab hari anomali sebelum kampanye besar.</strong> Review tanggal dengan deviasi >25% di analisis pendukung. Jika lonjakan terjadi karena event eksternal, jadikan kalender antisipasi. Jika penurunan terjadi tanpa sebab jelas, audit service, stok, atau gangguan channel order.</div>
	      </div>
	      <div class="rec-item">
	        <div class="rec-icon">📐</div>
	        <div class="rec-text">
	          <strong>Gunakan baseline hari yang sama untuk forecasting.</strong>
	          {#if vl === 'rendah'} Dengan prediktabilitas tinggi, rata-rata per nama hari sudah cukup akurat sebagai baseline planning.
	          {:else} Jangan gunakan rata-rata 30H sederhana. Forecast Senin harus dibandingkan dengan baseline Senin, weekend dengan weekend, lalu tambahkan buffer sebesar risiko deviasi {cv}%.{/if}
	        </div>
	      </div>
    </div>

      </div>
    </details>

	    <details class="acc-strategic">
	      <summary>📂 Analisis Pendukung · Hari Anomali vs Baseline</summary>
	      <div class="acc-body">


    <div class="support-body">
	      {#if anomaly_detail.length > 0}
	        <div>
	          <div style="font-size:10px;font-weight:700;letter-spacing:0.1em;text-transform:uppercase;color:var(--color-text-tertiary);margin-bottom:8px;">📋 Daftar Hari Anomali</div>
	          <p style="font-size:0.87rem;color:var(--color-text-secondary);line-height:1.65;margin:0 0 12px;">Hari dengan traffic lebih dari 25% di atas atau di bawah baseline hari yang sama. Cari pola — apakah dipicu event, cuaca, promo, channel order, atau gangguan operasional?</p>
	          <DataTable data={anomaly_detail}>
	            <Column id="order_date"   title="Tanggal"/>
	            <Column id="daily_orders" title="Order Aktual"    fmt="#,##0"/>
	            <Column id="expected_orders" title="Baseline Hari Sama" fmt="#,##0"/>
	            <Column id="status"       title="Status"/>
	            <Column id="selisih_pct"  title="Deviasi (%)" fmt="+0.0;-0.0" contentType="delta"/>
	          </DataTable>
	        </div>
	      {:else}
	        <div style="padding:16px 18px;border-radius:12px;border:1px solid rgba(22,163,74,0.2);background:rgba(22,163,74,0.06);">
	          <div style="font-size:0.9rem;font-weight:700;color:#15803d;margin-bottom:4px;">✅ Tidak ada hari yang menyimpang lebih dari 25%.</div>
	          <div style="font-size:0.85rem;color:var(--color-text-secondary);">Traffic mengikuti baseline hari yang sama. Demand sangat bisa diprediksi untuk planning staf dan bahan.</div>
		        </div>
		      {/if}
	    </div>

      </div>
    </details>
  </div>

</div>

{/if}

<!-- ══════════════════════════════════════
     VIEW: MUSIMAN
══════════════════════════════════════ -->
{#if inputs.view === 'musiman' && seasonal_metrics.length > 0}

{@const sq  = seasonal_metrics[0].strongest_q}
{@const wq  = seasonal_metrics[0].weakest_q}
{@const gp  = seasonal_metrics[0].growth_pct}
{@const hep = seasonal_metrics[0].holiday_effect_pct}
{@const sgp = seasonal_metrics[0].seasonal_gap_pct}
{@const ss  = seasonal_metrics[0].seasonal_strength}
{@const cm  = monthly_trend.find(r => r.is_current_month === 1)}

	<div class="pt-page">
	
	  <div class="exec-banner">
	    <div class="exec-eyebrow">🗓️ Pergeseran Musiman · Data Historis Seluruh Periode</div>
	    {#if ss === 'kuat'}
	      <h2 class="exec-headline">{sq} adalah kuartal terkuat — pergeseran musiman signifikan membutuhkan perencanaan kapasitas jangka panjang.</h2>
      <p class="exec-body">Selisih demand antara kuartal terkuat (<strong>{sq}</strong>) dan terlemah (<strong>{wq}</strong>) mencapai <strong>{sgp}%</strong>. Pola ini cukup konsisten untuk dijadikan dasar perencanaan rekrutmen, pengadaan, dan anggaran operasional sebelum musim ramai tiba.</p>
      <span class="exec-tag">📋 Sesuaikan kapasitas dan pengadaan sebelum {sq} — pergeseran musiman signifikan</span>
    {:else if ss === 'moderat'}
      <h2 class="exec-headline">Ada pergeseran musiman moderat — {sq} cenderung lebih kuat dari kuartal lain.</h2>
      <p class="exec-body">Selisih demand antar kuartal sebesar <strong>{sgp}%</strong> — cukup untuk mempengaruhi kebutuhan staf dan pengadaan, tapi tidak cukup ekstrem untuk restrukturisasi besar. Antisipasi ringan sebelum {sq} sudah memadai.</p>
      <span class="exec-tag warn">⚠️ Antisipasi ringan sebelum {sq} — review kebutuhan staf dan stok</span>
    {:else}
      <h2 class="exec-headline">Pola musiman tidak signifikan — demand relatif konsisten sepanjang tahun.</h2>
      <p class="exec-body">Selisih demand antar kuartal hanya <strong>{sgp}%</strong>. Tidak ada musim yang secara dramatis lebih ramai atau lebih sepi — operasional dapat dijalankan dengan kapasitas yang relatif seragam.</p>
      <span class="exec-tag ok">✅ Tidak diperlukan penyesuaian kapasitas musiman — pantau tren tahunan</span>
	    {/if}
	  </div>

  <div class="chart-section">
    <div class="chart-eyebrow">📖 Cara Membaca Musiman</div>
    <p class="chart-title">Musiman membaca apakah demand berubah karena siklus kalender, bukan karena masalah operasional harian.</p>
    <div class="support-body" style="padding:0;">
      <div>
        Subpage ini menjawab pertanyaan jangka panjang: apakah ada periode dalam setahun yang secara konsisten lebih ramai atau lebih sepi? Ini berbeda dari <strong>Hari Ramai</strong> yang membaca ritme mingguan, dan berbeda dari <strong>Volatilitas</strong> yang membaca penyimpangan harian.
      </div>
      <div>
        <div style="font-size:10px;font-weight:700;letter-spacing:0.1em;text-transform:uppercase;color:var(--color-text-tertiary);margin-bottom:10px;">🗓️ Pembagian Kuartal</div>
        <div style="display:grid;grid-template-columns:repeat(4,1fr);gap:10px;">
          <div style="padding:12px 14px;border-radius:12px;background:rgba(99,102,241,0.06);border:1px solid rgba(99,102,241,0.18);">
            <div style="font-size:1rem;font-weight:900;color:#4338ca;margin-bottom:4px;">Q1</div>
            <div style="font-size:0.88rem;font-weight:700;color:var(--color-text-primary);margin-bottom:3px;">Januari-Maret</div>
            <div style="font-size:0.78rem;color:var(--color-text-secondary);line-height:1.55;">Awal tahun; sering dipengaruhi efek setelah libur akhir tahun.</div>
          </div>
          <div style="padding:12px 14px;border-radius:12px;background:rgba(20,184,166,0.06);border:1px solid rgba(20,184,166,0.18);">
            <div style="font-size:1rem;font-weight:900;color:#0f766e;margin-bottom:4px;">Q2</div>
            <div style="font-size:0.88rem;font-weight:700;color:var(--color-text-primary);margin-bottom:3px;">April-Juni</div>
            <div style="font-size:0.78rem;color:var(--color-text-secondary);line-height:1.55;">Pertengahan pertama; bisa terpengaruh libur sekolah awal.</div>
          </div>
          <div style="padding:12px 14px;border-radius:12px;background:rgba(245,158,11,0.06);border:1px solid rgba(245,158,11,0.18);">
            <div style="font-size:1rem;font-weight:900;color:#b45309;margin-bottom:4px;">Q3</div>
            <div style="font-size:0.88rem;font-weight:700;color:var(--color-text-primary);margin-bottom:3px;">Juli-September</div>
            <div style="font-size:0.78rem;color:var(--color-text-secondary);line-height:1.55;">Pertengahan kedua; sering membaca dampak libur sekolah dan normalisasi setelahnya.</div>
          </div>
          <div style="padding:12px 14px;border-radius:12px;background:rgba(239,68,68,0.06);border:1px solid rgba(239,68,68,0.18);">
            <div style="font-size:1rem;font-weight:900;color:#b91c1c;margin-bottom:4px;">Q4</div>
            <div style="font-size:0.88rem;font-weight:700;color:var(--color-text-primary);margin-bottom:3px;">Oktober-Desember</div>
            <div style="font-size:0.78rem;color:var(--color-text-secondary);line-height:1.55;">Akhir tahun; biasanya menangkap periode libur akhir bulan Desember, dan budget akhir tahun.</div>
          </div>
        </div>
      </div>
      <div class="support-grid">
        <div class="support-item">
          <div class="support-item-label">Gap Musiman</div>
          <div class="support-item-title">Selisih kuartal kuat vs lemah</div>
          <div class="support-item-desc">Gap besar berarti kapasitas tidak bisa dibuat rata sepanjang tahun. Gap kecil berarti demand relatif stabil dan planning bisa memakai baseline umum.</div>
        </div>
        <div class="support-item">
          <div class="support-item-label">Efek Libur</div>
          <div class="support-item-title">Proxy bulan libur vs bulan reguler</div>
          <div class="support-item-desc">Membaca apakah bulan libur seperti akhir tahun, awal tahun, dan libur sekolah menaikkan demand secara nyata dibanding bulan biasa.</div>
        </div>
        <div class="support-item">
          <div class="support-item-label">Metodologi</div>
          <div class="support-item-title">Rata-rata bulanan per kuartal</div>
          <div class="support-item-desc">Perbandingan kuartal memakai rata-rata order bulanan agar kuartal dengan data tidak lengkap tidak otomatis kalah dari kuartal penuh.</div>
        </div>
      </div>
    </div>
  </div>
	
	  <div class="strategic-stack">
	    <div class="strategic-header">
	      <div class="strategic-eyebrow">🔭 Perspektif Musiman</div>
	      <h2 class="strategic-title">Baca pola tahunan untuk perencanaan kapasitas</h2>
	      <p class="strategic-copy">Tiga lens di bawah ini memisahkan pola demand jangka panjang, keputusan kapasitas, dan bukti pendukung: kapan musim ramai terjadi, apa yang harus disiapkan, dan bagaimana polanya terlihat dari data kuartalan/bulanan?</p>
	    </div>
	
	    <details class="acc-strategic" open>
	      <summary>🗓️ Pola Musiman · Baca Kuartal dan Efek Libur</summary>
	      <div class="acc-body">

  <div class="kpi-row-4">
	    <div class="kpi-card strong">
	      <div class="kpi-label">🌟 Kuartal Terkuat</div>
	      <div class="kpi-number">{sq}</div>
	      <div class="kpi-interp">Kuartal dengan rata-rata order bulanan tertinggi. Kapasitas operasional harus berada di titik tertinggi di periode ini — staf, stok, dan kesiapan servis perlu disiapkan jauh sebelumnya.</div>
	    </div>
	    <div class="kpi-card weak">
	      <div class="kpi-label">📉 Kuartal Terlemah</div>
	      <div class="kpi-number">{wq}</div>
	      <div class="kpi-interp">Kuartal dengan rata-rata order bulanan terendah — waktu terbaik untuk pelatihan massal, renovasi minor, atau review sistem operasional tanpa tekanan traffic tinggi.</div>
	    </div>
	    <div class="kpi-card growth">
	      <div class="kpi-label">📏 Gap Musiman</div>
	      <div class="kpi-number">{sgp}%</div>
	      <div class="kpi-interp">
	        Selisih demand antara kuartal terkuat dan terlemah.
	        {#if sgp >= 40} Gap kuat — kapasitas tahunan perlu dibedakan jelas antara musim ramai dan musim lemah.
	        {:else if sgp >= 20} Gap moderat — siapkan penyesuaian ringan sebelum kuartal ramai.
	        {:else} Gap kecil — demand relatif stabil sepanjang tahun.{/if}
	      </div>
	    </div>
    <div class="kpi-card holiday">
      <div class="kpi-label">🎉 Efek Hari Libur</div>
      <div class="kpi-number">
        {#if hep > 0}+{hep}%{:else}{hep}%{/if}
      </div>
      <div class="kpi-interp">
        Selisih rata-rata order bulan libur (Des, Jan, Jun, Jul) vs bulan reguler.
        {#if hep > 20} Efek libur sangat kuat — perlu persiapan kapasitas khusus di bulan-bulan ini.
        {:else if hep > 0} Efek libur ada tapi moderat — antisipasi ringan sudah cukup.
        {:else} Hari libur tidak meningkatkan demand — bisnis tidak sensitif terhadap siklus liburan.{/if}
      </div>
    </div>
  </div>

  <div class="chart-section">
    <div class="chart-eyebrow">📈 Tren Bulanan · Seluruh Periode Data</div>
    <p class="chart-title">Pola permintaan bulanan — identifikasi siklus musiman yang berulang setiap tahun.</p>
    <LineChart data={monthly_trend} x="bulan" y="monthly_orders" title="Total Order per Bulan" xAxisTitle="Bulan" yAxisTitle="Total Order" />
    <div class="chart-interp">
      {#if ss === 'kuat'}
        📌 Garis tren menunjukkan <strong>pola musiman yang jelas</strong> — ada periode di mana garis naik signifikan dan kembali turun secara konsisten. Pola ini bisa dijadikan template perencanaan tahunan.
      {:else if ss === 'moderat'}
        📌 Ada <strong>fluktuasi musiman yang terlihat</strong> meski tidak ekstrem. Perhatikan bulan-bulan dengan bar lebih tinggi dari tren umum — itu sinyal untuk mempersiapkan kapasitas lebih awal.
      {:else}
        📌 Garis relatif datar — <strong>tidak ada siklus musiman yang kuat</strong>. Perencanaan jangka panjang dapat menggunakan rata-rata historis sebagai baseline tanpa penyesuaian musiman besar.
      {/if}
    </div>
  </div>

      </div>
    </details>

    <details class="acc-strategic">
      <summary>🎯 Perencanaan Kapasitas · Baca Staf, Stok, dan Marketing</summary>
      <div class="acc-body">

    <div class="rec-title">Tiga tindakan strategis berbasis pola musiman untuk perencanaan kapasitas tahunan.</div>
    <div class="rec-list">
      <div class="rec-item">
        <div class="rec-icon">👥</div>
        <div class="rec-text">
          {#if ss === 'kuat'}
            <strong>Mulai rekrutmen atau pelatihan staf 6–8 minggu sebelum {sq}.</strong> Dengan selisih musiman {sgp}%, kapasitas staf reguler tidak cukup di kuartal puncak. Rekrut staf paruh waktu atau intensifkan training sebelum musim ramai — bukan saat sudah ramai.
          {:else if ss === 'moderat'}
            <strong>Review kebutuhan staf 4–6 minggu sebelum {sq}.</strong> Selisih {sgp}% membutuhkan antisipasi ringan. Identifikasi apakah kapasitas saat ini bisa dioptimasi dengan rotasi shift sebelum memutuskan rekrutmen tambahan.
          {:else}
            <strong>Pertahankan kapasitas staf yang konsisten sepanjang tahun.</strong> Tidak ada pergeseran musiman signifikan — rotasi dan pengembangan staf bisa dijadwalkan kapan saja tanpa khawatir mengganggu momen ramai.
          {/if}
        </div>
      </div>
      <div class="rec-item">
        <div class="rec-icon">📦</div>
        <div class="rec-text">
          {#if hep > 10}
            <strong>Sesuaikan timeline pengadaan untuk bulan-bulan libur (Des, Jan, Jun, Jul).</strong> Efek libur {hep}% di atas normal berarti kebutuhan bahan baku lebih tinggi. Koordinasikan dengan supplier minimal 3–4 minggu sebelumnya untuk menghindari kehabisan stok.
          {:else if gp > 10}
            <strong>Renegosikan kontrak supplier dengan volume yang mencerminkan tren pertumbuhan {gp}%.</strong> Kebutuhan bahan baku akan terus meningkat — kontrak berbasis volume lama akan menyebabkan kekurangan stok di kemudian hari.
          {:else}
            <strong>Rencanakan pengadaan berbasis rata-rata historis tanpa penyesuaian musiman besar.</strong> Tidak ada lonjakan musiman yang memerlukan buffer stok ekstra secara rutin.
          {/if}
        </div>
      </div>
      <div class="rec-item">
        <div class="rec-icon">📣</div>
        <div class="rec-text">
          {#if ss === 'kuat'}
            <strong>Arahkan kampanye marketing ke {wq} — bukan ke {sq}.</strong> Promosi di kuartal puncak hanya menggerus margin tanpa menambah revenue berarti karena demand sudah tinggi secara organik. Dorong traffic di kuartal lemah untuk meratakan kurva demand tahunan.
          {:else}
            <strong>Gunakan data musiman sebagai input perencanaan anggaran tahunan.</strong> Tren pertumbuhan {gp}% harus tercermin dalam proyeksi pendapatan dan alokasi anggaran operasional untuk tahun berikutnya.
          {/if}
        </div>
      </div>
    </div>

      </div>
    </details>

    <details class="acc-strategic">
      <summary>📂 Analisis Pendukung · Kuartalan dan Detail Bulanan</summary>
      <div class="acc-body">

    <div class="support-body">
	      <div>
	        <div style="font-size:10px;font-weight:700;letter-spacing:0.1em;text-transform:uppercase;color:var(--color-text-tertiary);margin-bottom:8px;">📊 Perbandingan Kuartalan per Tahun</div>
		        <BarChart data={quarterly_trend} x="kuartal" y="q_orders" series="tahun" sort=false type="grouped" title="Total Order per Kuartal — per Tahun" xAxisTitle="Kuartal" yAxisTitle="Total Order" />
	        <div class="chart-interp">
	          📌 <strong>Cara membaca chart ini:</strong> cari apakah kuartal yang sama berulang menjadi lebih tinggi atau lebih rendah di beberapa tahun. Jika {sq} konsisten lebih tinggi, itu sinyal musim ramai yang bisa direncanakan. Jika pola berubah antar tahun, gunakan chart bulanan untuk mencari penyebab spesifik seperti libur, event, atau perubahan cabang.
	        </div>
	      </div>
	      <div>
	        <div style="font-size:10px;font-weight:700;letter-spacing:0.1em;text-transform:uppercase;color:var(--color-text-tertiary);margin-bottom:8px;">📋 Detail Bulanan</div>
	        {#if cm}
	          <div class="current-month-callout">
	            <div>
	              <div class="current-month-label">Bulan Berjalan</div>
	              <div class="current-month-value">{cm.bulan_label}</div>
	              <div class="current-month-note">{cm.catatan_bulan}. Angka ini belum full-month.</div>
	            </div>
	            <div>
	              <div class="current-month-label">Order Sementara</div>
	              <div class="current-month-value">{Number(cm.monthly_orders).toLocaleString('id-ID')}</div>
	              <div class="current-month-note">Pace saat ini: {Number(cm.daily_order_pace).toLocaleString('id-ID')} order/hari.</div>
	            </div>
	            <div>
	              <div class="current-month-label">Revenue Sementara</div>
	              <div class="current-month-value">Rp {Number(cm.monthly_revenue).toLocaleString('id-ID')}</div>
	              <div class="current-month-note">Pace: Rp {Number(cm.daily_revenue_pace).toLocaleString('id-ID')}/hari.</div>
	            </div>
	            <div>
	              <div class="current-month-label">Proyeksi Akhir Bulan</div>
	              <div class="current-month-value">{Number(cm.projected_orders).toLocaleString('id-ID')} order</div>
	              <div class="current-month-note">Jika pace saat ini bertahan sampai akhir bulan.</div>
	            </div>
	            <div>
	              <div class="current-month-label">Baseline Bulan Ini</div>
	              <div class="current-month-value">{cm.baseline_orders ? Number(cm.baseline_orders).toLocaleString('id-ID') : 'Belum ada'} order</div>
	              <div class="current-month-note">Rata-rata bulan yang sama pada periode historis.</div>
	            </div>
	            <div>
	              <div class="current-month-label">Sinyal Awal</div>
	              <div class="current-month-value">{cm.projection_status}</div>
	              <div class="current-month-note">
	                {#if cm.baseline_orders}
	                  Proyeksi saat ini {cm.projected_vs_baseline_pct > 0 ? '+' : ''}{cm.projected_vs_baseline_pct}% vs baseline bulan yang sama.
	                {:else}
	                  Belum cukup histori bulan yang sama untuk pembanding.
	                {/if}
	              </div>
	            </div>
	          </div>
	        {/if}
	        <DataTable data={monthly_trend.filter(r => r.is_current_month !== 1)}>
	          <Column id="bulan_label"     title="Bulan"/>
	          <Column id="monthly_orders"  title="Total Order"    fmt="#,##0"/>
	          <Column id="monthly_revenue" title="Revenue (Rp)"   fmt="#,##0"/>
	        </DataTable>
	        <div class="chart-interp">
	          📌 <strong>Gunakan tabel bulanan untuk eksekusi:</strong> tabel hanya berisi bulan yang sudah lengkap dan diurutkan dari terbaru. Bulan berjalan dipisahkan di atas sebagai <strong>early signal</strong>: proyeksi akhir bulan adalah estimasi jika pace saat ini bertahan, bukan kepastian final.
	        </div>
	      </div>
    </div>

      </div>
    </details>
  </div>

</div>

{/if}
