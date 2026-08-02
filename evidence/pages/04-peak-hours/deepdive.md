---
title: Permintaan & Traffic
sidebar: hide
---

<script>
  import PremiumTable from '$lib/PremiumTable.svelte';
  import SectionHeader from '$lib/SectionHeader.svelte';
import SectionCard from '$lib/SectionCard.svelte';
</script>


<PeakTabs activeTab="deepdive" />

<style>
.crisis-btn {
  font-weight: 600; 
  color: #1e293b; 
  background: linear-gradient(to right, #ffffff, #f8fafc);
  border: 1px solid #e2e8f0; 
  border-left: 4px solid #f59e0b;
  border-radius: 6px; 
  padding: 10px 14px; 
  cursor: pointer; 
  transition: all 0.2s;
  box-shadow: 0 1px 2px rgba(0,0,0,0.02);
  list-style: none;
}
.crisis-btn:hover {
  background: #f8fafc;
  border-color: #cbd5e1;
  box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);
  transform: translateY(-1px);
}
.crisis-card {
  border-radius: 8px; 
  padding: 14px 16px; 
  display: flex; 
  gap: 16px; 
  align-items: flex-start;
  box-shadow: 0 1px 2px rgba(0,0,0,0.02);
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
}
.crisis-card-1 { background: #fffbeb; border: 1px solid #fde68a; }
.crisis-card-1:hover {
  background: #fef3c7; border-color: #fcd34d;
  transform: translateX(6px);
  box-shadow: -4px 4px 8px -2px rgba(245,158,11,0.15);
}
.crisis-card-1 .crisis-emoji { background: #fef3c7; border-color: #fde68a; }
.crisis-card-2 { background: #fff1f2; border: 1px solid #fecdd3; }
.crisis-card-2:hover {
  background: #ffe4e6; border-color: #fda4af;
  transform: translateX(6px);
  box-shadow: -4px 4px 8px -2px rgba(225,29,72,0.15);
}
.crisis-card-2 .crisis-emoji { background: #ffe4e6; border-color: #fecdd3; }
.crisis-card-3 { background: #eff6ff; border: 1px solid #bfdbfe; }
.crisis-card-3:hover {
  background: #dbeafe; border-color: #93c5fd;
  transform: translateX(6px);
  box-shadow: -4px 4px 8px -2px rgba(59,130,246,0.15);
}
.crisis-card-3 .crisis-emoji { background: #dbeafe; border-color: #bfdbfe; }
.crisis-emoji {
  font-size: 1.25rem; 
  line-height: 1; 
  padding: 10px; 
  border-radius: 8px;
  border: 1px solid transparent;
  transition: all 0.2s ease;
}
.crisis-chevron {
  transition: transform 0.25s ease;
}
details[open] .crisis-chevron {
  transform: rotate(90deg);
}
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
.support-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px; }
.support-item { padding: 16px; border-radius: 12px; background: rgba(0,0,0,0.02); border: 1px solid var(--color-border-tertiary); transition: all 0.2s; box-shadow: 0 1px 2px rgba(0,0,0,0.02); cursor: default; }
.support-item:hover { background: #ffffff; border-color: rgba(99,102,241,0.3); box-shadow: 0 6px 12px -2px rgba(0,0,0,0.08); transform: translateY(-2px); }
.support-item-label { font-size: 9px; font-weight: 800; letter-spacing: 0.1em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 6px; }
.support-item-title { font-size: 0.95rem; font-weight: 800; color: var(--color-text-primary); margin-bottom: 4px; }
.support-item-desc  { font-size: 0.85rem; line-height: 1.55; color: var(--color-text-secondary); }

.q-card { padding: 16px; border-radius: 12px; transition: all 0.2s; box-shadow: 0 1px 2px rgba(0,0,0,0.02); cursor: default; }
.q-card:hover { box-shadow: 0 6px 12px -2px rgba(0,0,0,0.08); transform: translateY(-2px); }
.q-card.q1 { background: rgba(99,102,241,0.06); border: 1px solid rgba(99,102,241,0.18); }
.q-card.q1:hover { background: rgba(99,102,241,0.1); border-color: rgba(99,102,241,0.4); }
.q-card.q2 { background: rgba(20,184,166,0.06); border: 1px solid rgba(20,184,166,0.18); }
.q-card.q2:hover { background: rgba(20,184,166,0.1); border-color: rgba(20,184,166,0.4); }
.q-card.q3 { background: rgba(245,158,11,0.06); border: 1px solid rgba(245,158,11,0.18); }
.q-card.q3:hover { background: rgba(245,158,11,0.1); border-color: rgba(245,158,11,0.4); }
.q-card.q4 { background: rgba(239,68,68,0.06); border: 1px solid rgba(239,68,68,0.18); }
.q-card.q4:hover { background: rgba(239,68,68,0.1); border-color: rgba(239,68,68,0.4); }

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

.warning-banner {
  background: linear-gradient(135deg, rgba(245, 158, 11, 0.12), rgba(251, 191, 36, 0.04));
  border: 1px solid rgba(245, 158, 11, 0.3);
  border-left: 4px solid #f59e0b;
  border-radius: 12px;
  padding: 16px 20px;
  margin-top: 16px;
  margin-bottom: 24px;
  display: flex;
  gap: 16px;
  align-items: flex-start;
  box-shadow: 0 4px 12px rgba(0,0,0,0.02);
  transition: all 0.22s ease;
}
.warning-banner:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 16px rgba(0,0,0,0.04), 0 2px 4px rgba(0,0,0,0.02);
}
.warning-banner-title {
  margin: 0 0 6px 0;
  color: #b45309;
  font-size: 0.95rem;
  font-weight: 700;
  letter-spacing: 0.02em;
}
.warning-banner-desc {
  margin: 0;
  color: var(--color-text-secondary);
  font-size: 0.85rem;
  line-height: 1.6;
}
:global([data-theme='dark']) .warning-banner {
  background: linear-gradient(135deg, rgba(245, 158, 11, 0.15), rgba(251, 191, 36, 0.05));
  border-color: rgba(245, 158, 11, 0.4);
}
:global([data-theme='dark']) .warning-banner-title {
  color: #fbbf24;
}

/* ── Responsive ── */
@media (max-width: 1100px) { .kpi-row-4 { grid-template-columns: repeat(2,1fr); } }
@media (max-width: 900px)  { .kpi-row-3 { grid-template-columns: 1fr; } }
@media (max-width: 700px)  { .kpi-row-4 { grid-template-columns: 1fr; } .exec-headline { font-size: 1.25rem; } .exec-banner, .rec-block { padding: 20px; } }
.persona-card {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 16px;
  background: var(--color-background-secondary, #f9fafb);
  border: 1px solid var(--color-border-tertiary, #e5e7eb);
  border-radius: 12px;
  padding: 16px;
  margin-bottom: 24px;
}
.persona-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px;
  background: white;
  border-radius: 8px;
  box-shadow: 0 1px 2px rgba(0,0,0,0.05);
}
.p-icon {
  font-size: 1.5rem;
  background: var(--color-background-tertiary, #f3f4f6);
  padding: 8px;
  border-radius: 8px;
}
.p-label {
  font-size: 0.75rem;
  font-weight: 600;
  text-transform: uppercase;
  color: var(--color-text-secondary, #6b7280);
  letter-spacing: 0.05em;
}
.p-value {
  font-size: 1.1rem;
  font-weight: 700;
  color: var(--color-text-primary, #111827);
  margin-top: 2px;
}



.exec-summary-box {
  background: linear-gradient(135deg, rgba(16, 185, 129, 0.05), rgba(5, 150, 105, 0.1));
  border: 1px solid rgba(16, 185, 129, 0.3);
  border-left: 4px solid #10b981;
  border-radius: 8px;
  padding: 16px 20px;
  margin-top: 8px;
  margin-bottom: 24px;
}
.exec-summary-title {
  font-weight: 800;
  font-size: 0.95rem;
  color: #065f46;
  margin-bottom: 8px;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}
.exec-summary-content {
  font-size: 1rem;
  color: var(--color-text-primary);
  line-height: 1.5;
}

.theory-box {
  display: flex; gap: 12px; margin-top: 24px; padding: 16px;
  background: #f8fafc; border-radius: 12px; border: 1px dashed #cbd5e1;
}
.theory-icon { font-size: 1.5rem; }
.theory-text { font-size: 0.9rem; color: #475569; line-height: 1.5; }
.rec-block h4 { margin: 0 0 12px 0; font-size: 1.05rem; color: #1e293b; }
.rec-block p { font-size: 0.9rem; color: #475569; line-height: 1.5; margin-bottom: 12px; }
.rec-pro { color: #059669 !important; font-weight: 500; }
.rec-con { color: #d97706 !important; font-weight: 500; }

</style>


```sql branch_list
SELECT DISTINCT branch_name 
FROM restaurant.peak_hours 
ORDER BY branch_name
```

```sql branch_peak_metrics
WITH base_data AS (
    SELECT branch_name, order_hour, day_part, SUM(total_orders) AS total_orders
    FROM restaurant.peak_hours
    WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '29 days'
    GROUP BY branch_name, order_hour, day_part
),
hourly AS (
    SELECT branch_name, order_hour, SUM(total_orders) AS total_orders FROM base_data GROUP BY branch_name, order_hour
),
stats AS (
    SELECT branch_name, ROUND(AVG(total_orders),1) AS avg_orders, MAX(total_orders) AS max_orders, SUM(total_orders) AS grand_total
    FROM hourly
    GROUP BY branch_name
),
thresholded AS (
    SELECT
        h.branch_name,
        h.order_hour,
        h.total_orders,
        s.avg_orders,
        s.grand_total,
        ROUND(s.avg_orders * 1.15, 1) AS peak_threshold,
        CASE WHEN h.total_orders >= s.avg_orders * 1.15 THEN 1 ELSE 0 END AS is_peak
    FROM hourly h JOIN stats s ON h.branch_name = s.branch_name
),
peak_candidates AS (
    SELECT
        branch_name,
        CAST(order_hour AS INTEGER) AS order_hour,
        total_orders,
        grand_total,
        CAST(order_hour AS INTEGER) - ROW_NUMBER() OVER (PARTITION BY branch_name ORDER BY order_hour) AS grp,
        total_orders / NULLIF(avg_orders, 0) AS demand_surge_ratio
    FROM thresholded
    WHERE is_peak = 1
),
detected_windows AS (
    SELECT
        branch_name,
        MIN(order_hour) AS start_hour,
        MAX(order_hour) AS end_hour,
        MAX(demand_surge_ratio) AS surge_ratio,
        SUM(total_orders) AS window_orders,
        MAX(grand_total) AS grand_total
    FROM peak_candidates
    GROUP BY branch_name, grp
)
SELECT
    branch_name,
    ROUND(SUM(window_orders) / MAX(grand_total) * 100, 1) AS peak_share_pct,
    ROUND(MAX(surge_ratio), 1) AS max_demand_surge,
    string_agg(
        CASE
            WHEN start_hour = end_hour THEN CAST(start_hour AS VARCHAR) || ':00'
            ELSE CAST(start_hour AS VARCHAR) || ':00-' || CAST(end_hour AS VARCHAR) || ':00'
        END,
        ' & ' ORDER BY start_hour
    ) AS peak_windows_label
FROM detected_windows
GROUP BY branch_name
```

```sql day_analysis
SELECT
    branch_name,
    CASE dayofweek(order_date)
        WHEN 0 THEN 7
        ELSE dayofweek(order_date)
    END AS sort_order,
    CASE dayofweek(order_date)
        WHEN 0 THEN 'Minggu'
        WHEN 1 THEN 'Senin'
        WHEN 2 THEN 'Selasa'
        WHEN 3 THEN 'Rabu'
        WHEN 4 THEN 'Kamis'
        WHEN 5 THEN 'Jumat'
        WHEN 6 THEN 'Sabtu'
    END AS hari,
    CASE order_type
        WHEN 'dine_in' THEN '🍽️ Dine-In'
        WHEN 'takeaway' THEN '🥡 Takeaway'
        WHEN 'online' THEN '🛵 Online'
        WHEN 'delivery' THEN '🛵 Delivery'
        ELSE REPLACE(order_type, '_', ' ')
    END AS order_type,
    SUM(total_orders) AS total_orders
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '29 days'
GROUP BY branch_name, sort_order, hari, order_type
ORDER BY branch_name, sort_order
```

```sql weekend_analysis
SELECT
    branch_name,
    CASE 
        WHEN EXTRACT(DOW FROM order_date) IN (0, 5, 6) THEN 'Weekend (Jum-Min)' 
        ELSE 'Weekday (Sen-Kam)' 
    END AS period_type,
    SUM(total_orders) as total_orders
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '29 days'
GROUP BY branch_name, period_type
ORDER BY period_type
```

```sql heatmap_data
WITH base AS (
    SELECT
        branch_name,
        order_hour,
        CASE dayofweek(order_date)
            WHEN 0 THEN 7
            ELSE dayofweek(order_date)
        END AS sort_order,
        CASE dayofweek(order_date)
            WHEN 0 THEN 'Minggu'
            WHEN 1 THEN 'Senin'
            WHEN 2 THEN 'Selasa'
            WHEN 3 THEN 'Rabu'
            WHEN 4 THEN 'Kamis'
            WHEN 5 THEN 'Jumat'
            WHEN 6 THEN 'Sabtu'
        END AS hari,
        CASE order_type
            WHEN 'dine_in' THEN '🍽️ Dine-In'
            WHEN 'takeaway' THEN '🥡 Takeaway'
            WHEN 'online' THEN '🛵 Online'
            WHEN 'delivery' THEN '🛵 Delivery'
            ELSE REPLACE(order_type, '_', ' ')
        END AS order_type,
        SUM(total_orders) AS total_orders
    FROM restaurant.peak_hours
    WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '29 days'
    GROUP BY branch_name, order_hour, sort_order, hari, order_type
)
SELECT
    branch_name,
    order_hour,
    sort_order,
    hari,
    SUM(total_orders) AS total_orders,
    string_agg(order_type || ': ' || CAST(CAST(total_orders AS INTEGER) AS VARCHAR), ' • ') AS rincian_tipe
FROM base
GROUP BY branch_name, order_hour, sort_order, hari
ORDER BY branch_name, sort_order, order_hour
```

```sql hourly_ordertype_breakdown
SELECT
    branch_name,
    order_hour,
    CASE dayofweek(order_date)
        WHEN 0 THEN 7
        ELSE dayofweek(order_date)
    END AS sort_order,
    CASE dayofweek(order_date)
        WHEN 0 THEN 'Minggu'
        WHEN 1 THEN 'Senin'
        WHEN 2 THEN 'Selasa'
        WHEN 3 THEN 'Rabu'
        WHEN 4 THEN 'Kamis'
        WHEN 5 THEN 'Jumat'
        WHEN 6 THEN 'Sabtu'
    END AS hari,
    CASE 
        WHEN order_type = 'dine_in' THEN '🍽️ Dine-In'
        WHEN order_type = 'takeaway' THEN '🥡 Takeaway'
        ELSE '🛵 Delivery'
    END AS order_type,
    SUM(total_orders) AS total_orders
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '29 days'
GROUP BY branch_name, order_hour, sort_order, hari, 
    CASE 
        WHEN order_type = 'dine_in' THEN '🍽️ Dine-In'
        WHEN order_type = 'takeaway' THEN '🥡 Takeaway'
        ELSE '🛵 Delivery'
    END
ORDER BY branch_name, sort_order, order_hour
```

```sql daypart_data
SELECT
    branch_name,
    day_part,
    CASE day_part
        WHEN 'Pagi' THEN 'Pagi (08-10)'
        WHEN 'Makan Siang' THEN 'Makan Siang (11-13)'
        WHEN 'Sore' THEN 'Sore (14-16)'
        WHEN 'Makan Malam' THEN 'Makan Malam (17-20)'
        WHEN 'Larut Malam' THEN 'Larut Malam (21-22)'
        ELSE day_part
    END AS day_part_full,
    CASE day_part
        WHEN 'Pagi' THEN 1
        WHEN 'Makan Siang' THEN 2
        WHEN 'Sore' THEN 3
        WHEN 'Makan Malam' THEN 4
        WHEN 'Larut Malam' THEN 5
        ELSE 6
    END AS sort_order,
    CASE order_type
        WHEN 'dine_in' THEN '🍽️ Dine-In'
        WHEN 'takeaway' THEN '🥡 Takeaway'
        WHEN 'online' THEN '🛵 Online'
        WHEN 'delivery' THEN '🛵 Delivery'
        ELSE REPLACE(order_type, '_', ' ')
    END AS order_type,
    SUM(total_orders) AS total_orders
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '29 days'
GROUP BY branch_name, day_part, sort_order, order_type
ORDER BY sort_order
```

```sql periode_30d
SELECT * FROM restaurant.peak_periode_30d
```

```sql jam_metrics
SELECT * FROM restaurant.peak_jam_metrics
```

```sql hourly_trend
SELECT * FROM restaurant.peak_hourly_trend
```

```sql weekday_weekend_hourly
SELECT * FROM restaurant.peak_weekday_weekend_hourly
```

```sql weekday_weekend_peaks
SELECT * FROM restaurant.peak_weekday_weekend_peaks
```

```sql branch_peak_matrix
SELECT * FROM restaurant.peak_branch_peak_matrix
```

```sql prediksi_besok
SELECT * FROM restaurant.peak_prediksi_besok
```

```sql hari_metrics
SELECT * FROM restaurant.peak_hari_metrics
```

```sql daily_avg
SELECT * FROM restaurant.peak_daily_avg
```

```sql branch_daily
SELECT * FROM restaurant.peak_branch_daily
```

```sql volatility_metrics
SELECT * FROM restaurant.peak_volatility_metrics
```

```sql daily_trend
SELECT * FROM restaurant.peak_daily_trend
```

```sql anomaly_detail
SELECT * FROM restaurant.peak_anomaly_detail
```

```sql seasonal_metrics
WITH monthly_by_year AS (
    SELECT
        branch_name,
        YEAR(order_date)  AS tahun,
        MONTH(order_date) AS bulan_num,
        CASE WHEN MONTH(order_date) IN (1,2,3)   THEN 'Q1'
             WHEN MONTH(order_date) IN (4,5,6)   THEN 'Q2'
             WHEN MONTH(order_date) IN (7,8,9)   THEN 'Q3'
             ELSE 'Q4' END AS kuartal,
        SUM(total_orders)  AS monthly_orders,
        SUM(total_revenue) AS monthly_revenue
    FROM restaurant.peak_hours
    WHERE DATE_TRUNC('month', order_date) < (SELECT DATE_TRUNC('month', MAX(order_date)) FROM restaurant.peak_hours)
    GROUP BY branch_name, YEAR(order_date), MONTH(order_date)
),
monthly_avg AS (
    SELECT
        branch_name, bulan_num, kuartal,
        ROUND(AVG(monthly_orders),  0) AS avg_monthly_orders,
        ROUND(AVG(monthly_revenue), 0) AS avg_monthly_revenue
    FROM monthly_by_year
    GROUP BY branch_name, bulan_num, kuartal
),
quarterly AS (
    SELECT branch_name, kuartal, ROUND(AVG(avg_monthly_orders), 0) AS q_avg_orders
    FROM monthly_avg GROUP BY branch_name, kuartal
),
strongest AS (
    SELECT branch_name, kuartal AS strongest_q, q_avg_orders AS max_q_orders 
    FROM (
        SELECT branch_name, kuartal, q_avg_orders, ROW_NUMBER() OVER (PARTITION BY branch_name ORDER BY q_avg_orders DESC) as rn FROM quarterly
    ) WHERE rn = 1
),
weakest AS (
    SELECT branch_name, kuartal AS weakest_q, q_avg_orders AS min_q_orders 
    FROM (
        SELECT branch_name, kuartal, q_avg_orders, ROW_NUMBER() OVER (PARTITION BY branch_name ORDER BY q_avg_orders ASC) as rn FROM quarterly
    ) WHERE rn = 1
),
calendar_dim AS (
    SELECT 
        CAST(unnest(generate_series(DATE '2022-01-01', DATE '2025-12-31', INTERVAL 1 DAY)) AS DATE) AS cal_date
),
calendar_flags AS (
    SELECT 
        cal_date,
        CASE 
            WHEN cal_date BETWEEN DATE '2022-04-02' AND DATE '2022-05-01' THEN 1
            WHEN cal_date BETWEEN DATE '2023-03-23' AND DATE '2023-04-20' THEN 1
            WHEN cal_date BETWEEN DATE '2024-03-11' AND DATE '2024-04-09' THEN 1
            ELSE 0 
        END AS is_ramadan,
        CASE WHEN MONTH(cal_date) IN (6, 7, 12) THEN 1 ELSE 0 END AS is_school_holiday
    FROM calendar_dim
),
daily_orders AS (
    SELECT 
        branch_name,
        order_date,
        SUM(total_orders) AS daily_orders
    FROM restaurant.peak_hours
    GROUP BY branch_name, order_date
),
daily_with_flags AS (
    SELECT 
        d.branch_name,
        d.order_date,
        d.daily_orders,
        c.is_ramadan,
        c.is_school_holiday,
        CASE WHEN c.is_ramadan = 1 OR c.is_school_holiday = 1 THEN 1 ELSE 0 END AS is_holiday_season
    FROM daily_orders d
    JOIN calendar_flags c ON d.order_date = c.cal_date
),
holiday_avg AS (SELECT branch_name, AVG(daily_orders) * 30 AS avg_h FROM daily_with_flags WHERE is_holiday_season = 1 GROUP BY branch_name),
non_holiday_avg AS (SELECT branch_name, AVG(daily_orders) * 30 AS avg_n FROM daily_with_flags WHERE is_holiday_season = 0 GROUP BY branch_name)
SELECT
    s.branch_name,
    s.strongest_q, s.max_q_orders,
    w.weakest_q,   w.min_q_orders,
    h.avg_h AS avg_holiday_orders,
    n.avg_n AS avg_regular_orders,
    ROUND((h.avg_h - n.avg_n) * 100.0 / NULLIF(n.avg_n, 0), 1) AS holiday_effect_pct,
    ROUND((s.max_q_orders - w.min_q_orders) * 100.0 / NULLIF(w.min_q_orders, 0), 0) AS seasonal_gap_pct,
    CASE
        WHEN ROUND((s.max_q_orders - w.min_q_orders) * 100.0 / NULLIF(w.min_q_orders, 0), 0) >= 40 THEN 'kuat'
        WHEN ROUND((s.max_q_orders - w.min_q_orders) * 100.0 / NULLIF(w.min_q_orders, 0), 0) >= 20 THEN 'moderat'
        ELSE 'lemah'
    END AS seasonal_strength
FROM strongest s
JOIN weakest w ON s.branch_name = w.branch_name
LEFT JOIN holiday_avg h ON s.branch_name = h.branch_name
LEFT JOIN non_holiday_avg n ON s.branch_name = n.branch_name
```

```sql monthly_trend
WITH max_d AS (
    SELECT MAX(order_date) AS max_date
    FROM restaurant.peak_hours
),
monthly AS (
SELECT
    branch_name,
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
    CASE WHEN MONTH(order_date) IN (1,2,3) THEN 'Q1'
         WHEN MONTH(order_date) IN (4,5,6) THEN 'Q2'
         WHEN MONTH(order_date) IN (7,8,9) THEN 'Q3'
         ELSE 'Q4' END AS kuartal,
    SUM(total_orders)  AS monthly_orders,
    SUM(total_revenue) AS monthly_revenue,
    COUNT(DISTINCT order_date) AS days_recorded,
    MAX(order_date) AS max_order_date
FROM restaurant.peak_hours
GROUP BY branch_name, DATE_TRUNC('month', order_date), MONTH(order_date), YEAR(order_date)
)
SELECT
    m.*,
    CASE WHEN DATE_TRUNC('month', m.bulan) = DATE_TRUNC('month', max_d.max_date) THEN 1 ELSE 0 END AS is_current_month
FROM monthly m
CROSS JOIN max_d
ORDER BY m.branch_name, m.bulan DESC
```

```sql quarterly_trend
WITH q_data AS (
    SELECT
        branch_name,
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
    WHERE DATE_TRUNC('month', order_date) < (SELECT DATE_TRUNC('month', MAX(order_date)) FROM restaurant.peak_hours)
    GROUP BY 1, 2, 3, 4
),
all_q AS (
    SELECT 'Q1' AS kuartal, 1 AS kuartal_urut UNION ALL
    SELECT 'Q2', 2 UNION ALL
    SELECT 'Q3', 3 UNION ALL
    SELECT 'Q4', 4
),
all_y AS (
    SELECT DISTINCT YEAR(order_date) AS tahun FROM restaurant.peak_hours
),
all_b AS (
    SELECT DISTINCT branch_name FROM restaurant.peak_hours
),
skeleton AS (
    SELECT b.branch_name, q.kuartal, q.kuartal_urut, y.tahun
    FROM all_b b CROSS JOIN all_q q CROSS JOIN all_y y
)
SELECT 
    s.branch_name, 
    s.kuartal, 
    s.kuartal_urut, 
    CAST(s.tahun AS VARCHAR) AS tahun,
    COALESCE(d.q_orders, 0) AS q_orders,
    COALESCE(d.q_revenue, 0) AS q_revenue
FROM skeleton s
LEFT JOIN q_data d 
    ON s.branch_name = d.branch_name 
    AND s.kuartal = d.kuartal 
    AND s.tahun = d.tahun
ORDER BY s.branch_name, s.kuartal_urut, s.tahun
```

```sql quarterly_avg_summary
WITH q_totals AS (
    SELECT 
        branch_name,
        YEAR(order_date) AS tahun,
        CASE WHEN MONTH(order_date) IN (1,2,3) THEN 'Q1'
             WHEN MONTH(order_date) IN (4,5,6) THEN 'Q2'
             WHEN MONTH(order_date) IN (7,8,9) THEN 'Q3'
             ELSE 'Q4' END AS kuartal,
        SUM(total_orders) AS q_orders,
        SUM(total_revenue) AS q_revenue
    FROM restaurant.peak_hours
    WHERE DATE_TRUNC('month', order_date) < (SELECT DATE_TRUNC('month', MAX(order_date)) FROM restaurant.peak_hours)
    GROUP BY 1, 2, 3
),
q_avgs AS (
    SELECT 
        branch_name,
        kuartal,
        ROUND(AVG(q_orders), 0) AS avg_q_orders,
        ROUND(AVG(q_revenue), 0) AS avg_q_revenue
    FROM q_totals
    GROUP BY branch_name, kuartal
)
SELECT 
    branch_name,
    kuartal,
    avg_q_orders,
    avg_q_orders::DOUBLE / SUM(avg_q_orders) OVER(PARTITION BY branch_name) AS pct_orders,
    avg_q_revenue,
    avg_q_revenue::DOUBLE / SUM(avg_q_revenue) OVER(PARTITION BY branch_name) AS pct_revenue
FROM q_avgs
ORDER BY branch_name, kuartal
```

```sql quarterly_areas
WITH quarters AS (
    SELECT 
        branch_name,
        YEAR(order_date) as thn,
        CASE WHEN MONTH(order_date) IN (1,2,3) THEN 'Q1'
             WHEN MONTH(order_date) IN (4,5,6) THEN 'Q2'
             WHEN MONTH(order_date) IN (7,8,9) THEN 'Q3'
             ELSE 'Q4' END as kuartal,
        MIN(DATE_TRUNC('month', order_date)) as start_date,
        MAX(DATE_TRUNC('month', order_date)) as end_date
    FROM restaurant.peak_hours
    GROUP BY 1, 2, 3
)
SELECT 
    branch_name,
    start_date,
    end_date + INTERVAL 1 MONTH AS end_date,
    kuartal,
    CASE kuartal 
      WHEN 'Q1' THEN 'rgba(67, 56, 202, 0.08)' 
      WHEN 'Q2' THEN 'rgba(15, 118, 110, 0.08)' 
      WHEN 'Q3' THEN 'rgba(180, 83, 9, 0.08)' 
      WHEN 'Q4' THEN 'rgba(185, 28, 28, 0.08)' 
    END as color
FROM quarters
ORDER BY branch_name, start_date
```


{#if branch_list.length > 0}
  {@const branchValue = String(inputs.pilih_cabang?.value ?? inputs.pilih_cabang ?? '')}
  {@const isBranchSelected = branchValue !== '' && !branchValue.includes('SELECT NULL') && !branchValue.includes('undefined')}
  {@const selectedBranch = isBranchSelected ? branchValue : null}

  <div style="margin-top: 24px; margin-bottom: 24px;">
    <SectionCard 
      eyebrow="<span style='font-size: 12px;'>🏪 Pilih Cabang</span>" 
      title="Pusat Kendali Jam & Hari Sibuk" 
      description="Pilih cabang tertentu untuk memfokuskan analisis kepadatan traffic, jam sibuk harian, dan tren akhir pekan."
    >
      <ButtonGroup name="pilih_cabang">
        {#each branch_list as branch, i}
          <ButtonGroupItem value={branch.branch_name} valueLabel={branch.branch_name} default={i === 0} />
        {/each}
      </ButtonGroup>
    </SectionCard>
  </div>




  {#if isBranchSelected}

  <Tabs fullWidth=true>
    <Tab label="⏰ Jam Sibuk">
      <div class="tab-content-wrapper">
        {#if true}

  {@const activeBranchData = branch_peak_metrics.find(row => row.branch_name === selectedBranch)}
  {@const branchDayData = day_analysis.filter(row => row.branch_name === selectedBranch)}
  {@const branchWeekendData = weekend_analysis.filter(row => row.branch_name === selectedBranch)}
  {@const totalWeekday = branchWeekendData.find(r => r.period_type.includes('Weekday'))?.total_orders || 0}
  {@const totalWeekend = branchWeekendData.find(r => r.period_type.includes('Weekend'))?.total_orders || 0}
  {@const avgWeekday = totalWeekday / 4}
  {@const avgWeekend = totalWeekend / 3}
  {@const ratio = avgWeekday > 0 ? avgWeekend / avgWeekday : 99}
  {@const badgeText = ratio > 1.4 ? '🔥 Akhir Pekan Ekstrem' : ratio > 1.1 ? '🎉 Cenderung Akhir Pekan' : ratio > 0.9 ? '⚖️ Merata Stabil' : ratio > 0.7 ? '👔 Cenderung Hari Kerja' : '🏢 Hari Kerja Ekstrem'}
  {@const badgeBg = ratio > 1.4 ? '#fee2e2' : ratio > 1.1 ? '#fef3c7' : ratio > 0.9 ? '#dcfce7' : ratio > 0.7 ? '#eff6ff' : '#f3f4f6'}
  {@const badgeBorder = ratio > 1.4 ? '#fca5a5' : ratio > 1.1 ? '#fcd34d' : ratio > 0.9 ? '#86efac' : ratio > 0.7 ? '#bfdbfe' : '#d1d5db'}
  {@const badgeColor = ratio > 1.4 ? '#991b1b' : ratio > 1.1 ? '#92400e' : ratio > 0.9 ? '#166534' : ratio > 0.7 ? '#1e40af' : '#374151'}
  {@const badgeDesc = ratio > 1.4 ? 'Akhir pekan mendominasi telak. Maksimalkan stok Jumat-Minggu, tekan biaya operasional hari kerja.' : ratio > 1.1 ? 'Lebih ramai di akhir pekan. Geser jadwal libur staf inti ke awal minggu (Senin/Selasa).' : ratio > 0.9 ? 'Volume pesanan sangat konsisten tiap hari. Terapkan jadwal shift dan stok yang merata.' : ratio > 0.7 ? 'Ditopang pekerja kantoran. Jam makan siang krusial, siapkan promo keluarga di akhir pekan.' : 'Sangat bergantung jam kantor. Tekan drastis jumlah staf saat akhir pekan untuk efisiensi.'}
  {@const branchHeatmap = heatmap_data.filter(row => row.branch_name === selectedBranch)}
  {@const branchDaypart = daypart_data.filter(row => row.branch_name === selectedBranch)}
  {@const heatmapLookup = Object.fromEntries(branchHeatmap.map(row => [row.order_hour + '_' + row.hari, row.rincian_tipe]))}
    



<SectionHeader 
  eyebrow="📈 Distribusi Demand Harian"
  title="Peta Kurva Nadi Operasional"
  description="Bentuk kurva demand dari buka hingga tutup. Analisis pergeseran pola jam sibuk antara awal minggu hingga akhir pekan."
/>

{#if activeBranchData && activeBranchData.peak_share_pct !== null}
  {@const share = activeBranchData.peak_share_pct}
  {@const surge = activeBranchData.max_demand_surge}
  {@const windows = activeBranchData.peak_windows_label}

  {@const shareStatus = share > 65 ? 'kritis' : share > 50 ? 'waspada' : 'sehat'}
  {@const surgeStatus = surge > 2.5 ? 'kritis' : surge > 1.5 ? 'waspada' : 'sehat'}

  <div class="period-strip" style="grid-template-columns: repeat(3, minmax(0, 1fr)); margin-bottom: 32px;">
    
    <div class="period-pill {shareStatus}">
      <div class="period-pill-label">📊 Konsentrasi Jam Sibuk</div>
      <div class="period-pill-value" style="font-size: 1.05rem; font-weight: 700; color: #1e293b;">
        {share}%
      </div>
      <div class="period-pill-copy" style="font-size: 0.76rem; line-height: 1.45;">
        Persentase total transaksi harian yang terjadi di jam-jam puncak.
      </div>
    </div>
    
    <div class="period-pill {surgeStatus}">
      <div class="period-pill-label">⚡ Lonjakan Kesibukan</div>
      <div class="period-pill-value" style="font-size: 1.05rem; font-weight: 700; color: #1e293b;">
        {surge}x Lipat
      </div>
      <div class="period-pill-copy" style="font-size: 0.76rem; line-height: 1.45;">
        Perbandingan volume transaksi saat jam sibuk melawan rata-rata harian.
      </div>
    </div>
    
    <div class="period-pill">
      <div class="period-pill-label">🕐 Zona Waktu Kritis</div>
      <div class="period-pill-value" style="font-size: 1.05rem;">
        {windows}
      </div>
      <div class="period-pill-copy" style="font-size: 0.76rem; line-height: 1.45;">
        Periode krusial di mana staf dan bahan baku harus siap kapasitas 100%.
      </div>
    </div>

  </div>

  <div style="margin-top: 32px;">
    <Tabs fullWidth=true>
      <Tab label="📈 Perbandingan Jam Sibuk Antar Hari">
        <div style="padding-top: 8px;">
          <div class="section-head tight" style="margin-bottom: 20px;">
          <div>
            <div class="section-eyebrow">📈 KURVA NADI DEMAND</div>
            <h3 class="section-title">Bagaimana bentuk lonjakan pesanan di setiap hari pada jam operasional?</h3>
            <p class="section-copy">Perbandingan kurva lonjakan jam kerja (08:00–22:00). Garis Biru Putus-putus (Senin–Kamis) mewakili hari kerja, sedangkan Garis Oranye/Amber Tebal (Jumat–Minggu) mewakili akhir pekan.</p>
          </div>
        </div>

        <div style="width: 100%; height: 420px; margin-top: 12px;">
          <ECharts config={{
            tooltip: {
              trigger: 'axis',
              axisPointer: { type: 'cross' },
              formatter: function(params) {
                if (!params || params.length === 0) return '';
                let hour = params[0].axisValue;
                let html = "<div style='font-weight:700;margin-bottom:6px;border-bottom:1px solid rgba(0,0,0,0.1);padding-bottom:4px;'>⏰ Jam " + hour + "</div>";
                params.forEach(function(item) {
                  const isWeekend = ['Jumat', 'Sabtu', 'Minggu'].includes(item.seriesName);
                  const icon = isWeekend ? '🟧' : '🟦';
                  html += "<div style='display:flex;justify-content:space-between;gap:16px;font-size:12px;margin:3px 0;'>" +
                    "<span>" + icon + " " + item.seriesName + "</span>" +
                    "<span style='font-weight:700;'>" + Math.round(item.value[1]).toLocaleString('id-ID') + " order</span></div>";
                });
                return html;
              }
            },
            legend: {
              data: ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'],
              top: 0,
              textStyle: { fontSize: 12 }
            },
            grid: { top: 40, right: 20, bottom: 30, left: 50 },
            xAxis: {
              type: 'category',
              data: Array.from({length: 15}, (_, i) => (i + 8) + ':00'),
              boundaryGap: false,
              axisLabel: { interval: 0 }
            },
            yAxis: { type: 'value', name: 'Total Order' },
            color: ['#93c5fd', '#60a5fa', '#3b82f6', '#1d4ed8', '#fbbf24', '#f97316', '#dc2626'],
            series: ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'].map(function(day) {
              const isWknd = ['Jumat', 'Sabtu', 'Minggu'].includes(day);
              const dayRows = branchHeatmap.filter(function(r) { return r.hari === day; });
              const rowMap = Object.fromEntries(dayRows.map(function(r) { return [r.order_hour, r.total_orders]; }));
              const points = Array.from({length: 15}, (_, i) => {
                const h = i + 8;
                return [`${h}:00`, rowMap[h] || 0];
              });
              return {
                name: day,
                type: 'line',
                smooth: true,
                symbol: 'circle',
                symbolSize: isWknd ? 6 : 4,
                lineStyle: {
                  width: isWknd ? 3 : 2,
                  type: isWknd ? 'solid' : 'dashed'
                },
                data: points
              };
            })
          }} />
        </div>
        </div>
      </Tab>

      <Tab label="📊 Komposisi Tipe Pesanan">
        <div style="padding-top: 8px;">
          <div class="section-head tight" style="margin-bottom: 16px;">
          <div>
            <div class="section-eyebrow">📊 KOMPOSISI TIPE PESANAN PER JAM</div>
            <h3 class="section-title">Bagaimana pergeseran proporsi Dine-In vs Takeaway vs Delivery di setiap jam?</h3>
            <p class="section-copy">Pilih hari tertentu untuk membedah rincian persentase tipe pesanan (08:00–22:00). Gunakan data ini untuk mengantisipasi kebutuhan piring/meja vs kantong pembungkus.</p>
          </div>
        </div>

        <div style="margin-bottom: 20px;">
          <ButtonGroup name="pilih_hari_breakdown">
            <ButtonGroupItem value="Semua Hari" valueLabel="🌐 Rata-rata Semua Hari" default />
            <ButtonGroupItem value="Senin" valueLabel="Senin" />
            <ButtonGroupItem value="Selasa" valueLabel="Selasa" />
            <ButtonGroupItem value="Rabu" valueLabel="Rabu" />
            <ButtonGroupItem value="Kamis" valueLabel="Kamis" />
            <ButtonGroupItem value="Jumat" valueLabel="Jumat" />
            <ButtonGroupItem value="Sabtu" valueLabel="Sabtu" />
            <ButtonGroupItem value="Minggu" valueLabel="Minggu" />
          </ButtonGroup>
        </div>

        {#if true}
        {@const selectedHari = String(inputs.pilih_hari_breakdown?.value ?? inputs.pilih_hari_breakdown ?? 'Semua Hari')}
        {@const branchBreakdownData = hourly_ordertype_breakdown.filter(r => r.branch_name === selectedBranch)}
        {@const activeDayData = selectedHari === 'Semua Hari' || selectedHari.includes('SELECT NULL') ? branchBreakdownData : branchBreakdownData.filter(r => r.hari === selectedHari)}

        {@const tDineIn = activeDayData.filter(r => r.order_type.includes('Dine-In')).reduce((a,b) => a + Number(b.total_orders), 0)}
        {@const tTakeaway = activeDayData.filter(r => r.order_type.includes('Takeaway')).reduce((a,b) => a + Number(b.total_orders), 0)}
        {@const tDelivery = activeDayData.filter(r => r.order_type.includes('Delivery')).reduce((a,b) => a + Number(b.total_orders), 0)}
        {@const tTotal = tDineIn + tTakeaway + tDelivery}

        {@const pctDineIn = tTotal > 0 ? ((tDineIn / tTotal) * 100).toFixed(1) : '0.0'}
        {@const pctTakeaway = tTotal > 0 ? ((tTakeaway / tTotal) * 100).toFixed(1) : '0.0'}
        {@const pctDelivery = tTotal > 0 ? ((tDelivery / tTotal) * 100).toFixed(1) : '0.0'}

        <div class="period-strip" style="grid-template-columns: repeat(3, minmax(0, 1fr)); margin-bottom: 24px;">
          <div class="period-pill sehat">
            <div class="period-pill-label">🍽️ Dine-In ({selectedHari.includes('SELECT NULL') ? 'Semua Hari' : selectedHari})</div>
            <div class="period-pill-value" style="font-size: 1.05rem; font-weight: 700; color: #1e293b;">
              {pctDineIn}%
            </div>
            <div class="period-pill-copy" style="font-size: 0.76rem; line-height: 1.45;">
              {tDineIn.toLocaleString('id-ID')} order total
            </div>
          </div>

          <div class="period-pill waspada">
            <div class="period-pill-label">🥡 Takeaway ({selectedHari.includes('SELECT NULL') ? 'Semua Hari' : selectedHari})</div>
            <div class="period-pill-value" style="font-size: 1.05rem; font-weight: 700; color: #1e293b;">
              {pctTakeaway}%
            </div>
            <div class="period-pill-copy" style="font-size: 0.76rem; line-height: 1.45;">
              {tTakeaway.toLocaleString('id-ID')} order total
            </div>
          </div>

          <div class="period-pill kritis">
            <div class="period-pill-label">🛵 Delivery / Ojol ({selectedHari.includes('SELECT NULL') ? 'Semua Hari' : selectedHari})</div>
            <div class="period-pill-value" style="font-size: 1.05rem; font-weight: 700; color: #1e293b;">
              {pctDelivery}%
            </div>
            <div class="period-pill-copy" style="font-size: 0.76rem; line-height: 1.45;">
              {tDelivery.toLocaleString('id-ID')} order total
            </div>
          </div>
        </div>

        <div style="width: 100%; height: 380px; margin-top: 12px;">
          <ECharts config={{
            tooltip: {
              trigger: 'axis',
              axisPointer: { type: 'shadow' },
              formatter: function(params) {
                if (!params || params.length === 0) return '';
                let hour = params[0].axisValue;
                let total = params.reduce(function(acc, p) { 
                  let v = Array.isArray(p.value) ? p.value[1] : p.value;
                  return acc + Number(v || 0); 
                }, 0);
                let dayLabel = selectedHari.includes('SELECT NULL') ? 'Semua Hari' : selectedHari;
                let html = "<div style='font-weight:700;margin-bottom:6px;border-bottom:1px solid rgba(0,0,0,0.1);padding-bottom:4px;'>⏰ Jam " + hour + " — " + dayLabel + "</div>";
                params.forEach(function(p) {
                  let v = Array.isArray(p.value) ? p.value[1] : p.value;
                  let val = Number(v || 0);
                  let pct = total > 0 ? ((val / total) * 100).toFixed(1) : '0.0';
                  let marker = "<span style='display:inline-block;margin-right:4px;border-radius:10px;width:10px;height:10px;background-color:" + p.color + ";'></span>";
                  html += "<div style='display:flex;justify-content:space-between;gap:16px;font-size:12px;margin:3px 0;'>" +
                    "<span>" + marker + " " + p.seriesName + "</span>" +
                    "<span style='font-weight:700;'>" + Math.round(val).toLocaleString('id-ID') + " order (" + pct + "%)</span></div>";
                });
                return html;
              }
            },
            legend: {
              data: ['🍽️ Dine-In', '🥡 Takeaway', '🛵 Delivery'],
              top: 0,
              textStyle: { fontSize: 12 }
            },
            grid: { top: 40, right: 20, bottom: 30, left: 50 },
            xAxis: {
              type: 'category',
              data: Array.from({length: 15}, (_, i) => (i + 8) + ':00'),
              boundaryGap: true
            },
            yAxis: {
              type: 'value',
              name: 'Total Order',
              axisLabel: { formatter: '{value}' }
            },
            color: ['#3b82f6', '#10b981', '#f97316'],
            series: ['🍽️ Dine-In', '🥡 Takeaway', '🛵 Delivery'].map(function(type) {
              const hours = Array.from({length: 15}, (_, i) => i + 8);
              const points = hours.map(function(h) {
                const typeRows = activeDayData.filter(function(r) { return r.order_hour === h && r.order_type === type; });
                const val = typeRows.reduce(function(a, b) { return a + Number(b.total_orders); }, 0);
                return [`${h}:00`, val];
              });
              return {
                name: type,
                type: 'bar',
                stack: 'total',
                data: points
              };
            })
          }} />
        </div>

        <div class="chart-insight-bar" style="margin-top: -12px; margin-bottom: 8px;">
          💡 <strong>Panduan Membaca ({selectedHari.includes('SELECT NULL') ? 'Semua Hari' : selectedHari}):</strong> Area hijau (Takeaway) dan oranye (Delivery) yang membesar menandakan pergeseran perilaku pelanggan. Data ini bisa digunakan untuk antisipasi stok kemasan (dus/plastik).
        </div>
        {/if}
        </div>
      </Tab>
    </Tabs>
  </div>
{:else}
  <div style="padding: 60px 20px; text-align: center; background: var(--color-background-secondary); border: 1px dashed var(--color-border-tertiary); border-radius: 12px; margin-top: 24px;">
    <h3 style="margin: 0 0 8px 0; color: var(--color-text-primary);">Data Tidak Ditemukan</h3>
    <p style="color: var(--color-text-secondary); margin: 0;">Silakan pilih minimal satu cabang yang valid di kotak filter di atas.</p>
  </div>
{/if}
        {/if}
      </div>
    </Tab>
    <Tab label="📅 Hari Sibuk">
      <div class="tab-content-wrapper">
        {#if true}
        {@const activeBranchData = branch_peak_metrics.find(row => row.branch_name === selectedBranch)}
        {@const branchDayData = day_analysis.filter(row => row.branch_name === selectedBranch)}
        {@const branchWeekendData = weekend_analysis.filter(row => row.branch_name === selectedBranch)}
        {@const totalWeekday = branchWeekendData.find(r => r.period_type.includes('Weekday'))?.total_orders || 0}
        {@const totalWeekend = branchWeekendData.find(r => r.period_type.includes('Weekend'))?.total_orders || 0}
        {@const avgWeekday = totalWeekday / 4}
        {@const avgWeekend = totalWeekend / 3}
        {@const ratio = avgWeekday > 0 ? avgWeekend / avgWeekday : 99}
        {@const badgeText = ratio > 1.4 ? '🔥 Akhir Pekan Ekstrem' : ratio > 1.1 ? '🎉 Cenderung Akhir Pekan' : ratio > 0.9 ? '⚖️ Merata Stabil' : ratio > 0.7 ? '👔 Cenderung Hari Kerja' : '🏢 Hari Kerja Ekstrem'}
        {@const badgeBg = ratio > 1.4 ? '#fee2e2' : ratio > 1.1 ? '#fef3c7' : ratio > 0.9 ? '#dcfce7' : ratio > 0.7 ? '#eff6ff' : '#f3f4f6'}
        {@const badgeBorder = ratio > 1.4 ? '#fca5a5' : ratio > 1.1 ? '#fcd34d' : ratio > 0.9 ? '#86efac' : ratio > 0.7 ? '#bfdbfe' : '#d1d5db'}
        {@const badgeColor = ratio > 1.4 ? '#991b1b' : ratio > 1.1 ? '#92400e' : ratio > 0.9 ? '#166534' : ratio > 0.7 ? '#1e40af' : '#374151'}
        {@const badgeDesc = ratio > 1.4 ? 'Akhir pekan mendominasi telak. Maksimalkan stok Jumat-Minggu, tekan biaya operasional hari kerja.' : ratio > 1.1 ? 'Lebih ramai di akhir pekan. Geser jadwal libur staf inti ke awal minggu (Senin/Selasa).' : ratio > 0.9 ? 'Volume pesanan sangat konsisten tiap hari. Terapkan jadwal shift dan stok yang merata.' : ratio > 0.7 ? 'Ditopang pekerja kantoran. Jam makan siang krusial, siapkan promo keluarga di akhir pekan.' : 'Sangat bergantung jam kantor. Tekan drastis jumlah staf saat akhir pekan untuk efisiensi.'}

  <div style="margin-top: 32px; margin-bottom: 32px;">
    
    <DiagnosticsHeader 
      marginTop="24px"
      eyebrow="📅 MAKRO"
      title="Analisis Volume Hari Sibuk"
      description="Gunakan instrumen di bawah ini untuk menganalisis beban operasional harian dan mengekstrak profil karakteristik mingguan."
    />
    

        <div style="display: flex; flex-direction: column; align-items: flex-start; justify-content: flex-start; margin-top: 32px; margin-bottom: 24px; gap: 16px; text-align: left;">
          <div style="width: 100%;">
            <div class="section-head tight" style="margin-bottom: 0px;">
              <div>
                <div class="section-eyebrow">🧬 Karakteristik Demografi</div>
                <h3 class="section-title">Siapa yang mendominasi pesanan di cabang ini?</h3>
                <p class="section-copy">Memecah proporsi pengunjung berdasarkan rasio aktivitas hari kerja vs akhir pekan.</p>
              </div>
            </div>
          </div>

          <div style="display: flex; flex-direction: column; align-items: center; justify-content: center; width: 100%; text-align: center; margin-top: 16px;">
            <div style="max-width: 600px;">
              <div style="background: {badgeBg}; border: 1px solid {badgeBorder}; color: {badgeColor}; padding: 6px 16px; border-radius: 20px; font-size: 0.85rem; font-weight: 700; display: inline-block; margin-bottom: 12px;">
                {badgeText}
              </div>
              <div style="font-size: 0.85rem; color: #475569; line-height: 1.5;">
                {badgeDesc}
              </div>
            </div>
            
            <div style="width: 100%; max-width: 600px; height: 260px; margin-top: 16px;">
              <ECharts config={{
                tooltip: { trigger: 'item' },
                color: ['#3b82f6', '#f59e0b'],
                legend: { show: false },
                series: [
                  {
                    type: 'pie',
                    radius: ['40%', '70%'],
                    center: ['50%', '50%'],
                    itemStyle: { borderRadius: 8, borderColor: '#fff', borderWidth: 2 },
                    data: branchWeekendData.map(row => ({ value: row.total_orders, name: row.period_type })),
                    label: { show: true, formatter: '{b}\n{d}%' }
                  }
                ]
              }} 
            />
          </div>

          <div class="chart-insight-bar" style="margin-top: 8px; width: 100%; max-width: 650px; text-align: left;">
            📌 <strong>Panduan Aksi (Profil Cabang):</strong> Gunakan rasio karakteristik cabang ini sebagai acuan utama (<i>baseline</i>) untuk merancang strategi <i>marketing</i> spesifik (kapan menebar promo diskon) dan menentukan kebijakan dasar alokasi hari libur mingguan bagi staf inti Anda.
          </div>
        </div>
      </div>

        <div class="section-head tight" style="margin-top: 40px; margin-bottom: 12px;">
          <div>
            <div class="section-eyebrow">📊 Agregasi Volume Harian (30 Hari)</div>
            <h3 class="section-title">Kapan beban dapur mencapai titik puncaknya?</h3>
            <p class="section-copy">Mendeteksi hari-hari dalam seminggu yang secara historis memiliki volume pesanan tertinggi.</p>
          </div>
        </div>
        <BarChart 
          data={branchDayData} 
          x=hari 
          y=total_orders
          series=order_type
          type="stacked"
          sort=false
          yAxisTitle="Total Order (30 Hari)" 
          xAxisTitle="Hari dalam Seminggu" 
        />
        <div class="chart-insight-bar" style="margin-top: 16px;">
          📌 <strong>Panduan Aksi (Makro):</strong> Jadwalkan <i>Prep-Day</i> (persiapan bahan baku masif) satu hari sebelum batang grafik memuncak. Gunakan hari-hari paling lesu untuk meluncurkan diskon <i>Flash Sale</i> guna meratakan beban dapur mingguan.
        </div>

  </div>


        {:else}
          <div style="padding: 60px 20px; text-align: center; background: var(--color-background-secondary); border: 1px dashed var(--color-border-tertiary); border-radius: 12px; margin-top: 24px;">
            <h3 style="margin: 0 0 8px 0; color: var(--color-text-primary);">Data Tidak Ditemukan</h3>
            <p style="color: var(--color-text-secondary); margin: 0;">Silakan pilih minimal satu cabang yang valid di kotak filter di atas.</p>
          </div>
        {/if}
      </div>
    </Tab>
    <Tab label="🔁 Tren Musiman">
      <div class="tab-content-wrapper">
        {#if true}
        {@const selectedBranch = inputs.pilih_cabang?.value ?? inputs.pilih_cabang}
  {@const isValidBranch = branch_list.some(b => b.branch_name === selectedBranch)}
	<div class="pt-page">

  <div class="warning-banner">
    <div style="font-size: 1.5rem; line-height: 1.1;">📢</div>
    <div>
      <div class="warning-banner-title">Informasi Penting: Data Bulan Berjalan Dikecualikan</div>
      <div class="warning-banner-desc">
        Untuk menjaga akurasi perbandingan, seluruh perhitungan kuartal dan grafik musiman di halaman ini hanya memproses bulan operasional yang sudah selesai penuh. Data bulan berjalan sengaja <strong>dikecualikan</strong> agar tidak memicu bias tren yang dapat merusak akurasi rekomendasi strategi.
      </div>
    </div>
  </div>

  
{#if isValidBranch}
  {@const activeMonthly = monthly_trend.filter(r => r.branch_name === selectedBranch)}
  {@const isDataSufficient = activeMonthly.length >= 12}

{#if isDataSufficient}
  {@const activeSeasonal = seasonal_metrics.filter(r => r.branch_name === selectedBranch)[0] || {}}
  {@const activeQuarterly = quarterly_trend.filter(r => r.branch_name === selectedBranch)}
  {@const activeQuarterlyAvg = quarterly_avg_summary.filter(r => r.branch_name === selectedBranch)}
  {@const activeAreas = quarterly_areas.filter(r => r.branch_name === selectedBranch)}
  {@const sq  = activeSeasonal.strongest_q}
  {@const wq  = activeSeasonal.weakest_q}
  {@const hep = activeSeasonal.holiday_effect_pct}
  {@const ho  = activeSeasonal.avg_holiday_orders}
  {@const ro  = activeSeasonal.avg_regular_orders}
  {@const sgp = activeSeasonal.seasonal_gap_pct}
  {@const ss  = activeSeasonal.seasonal_strength}
  {@const cm  = Array.from(activeMonthly).find(r => r.is_current_month === 1)}
  <div style="margin-top: 0px; margin-bottom: 32px;">
    <details class="guide-acc" style="margin-bottom:0px;">
      <summary>💡 Cara Membaca Musiman</summary>
      <div class="guide-body" style="padding: 16px;">
        <p style="margin-top: 0px; margin-bottom: 20px; font-weight: 500; color: var(--color-text-secondary); line-height: 1.6;">
          Melacak <strong>siklus tren jangka panjang (tahunan)</strong> untuk melihat apakah ada bulan atau kuartal tertentu yang secara konsisten selalu lebih ramai, sehingga Anda bisa merencanakan kapasitas staf dan stok jauh-jauh hari.
        </p>
        <div style="font-size:10px;font-weight:700;letter-spacing:0.1em;text-transform:uppercase;color:var(--color-text-tertiary);margin-bottom:12px;">🗓️ Pembagian Kuartal</div>
        <div style="display:grid;grid-template-columns:repeat(4,1fr);gap:12px;margin-bottom:24px;">
          <div class="q-card q1">
            <div style="font-size:1.1rem;font-weight:900;color:#4338ca;margin-bottom:4px;">Q1</div>
            <div style="font-size:0.9rem;font-weight:700;color:var(--color-text-primary);margin-bottom:6px;">Januari-Maret</div>
            <div style="font-size:0.8rem;color:var(--color-text-secondary);line-height:1.5;">Awal tahun; sering dipengaruhi efek setelah libur akhir tahun.</div>
          </div>
          <div class="q-card q2">
            <div style="font-size:1.1rem;font-weight:900;color:#0f766e;margin-bottom:4px;">Q2</div>
            <div style="font-size:0.9rem;font-weight:700;color:var(--color-text-primary);margin-bottom:6px;">April-Juni</div>
            <div style="font-size:0.8rem;color:var(--color-text-secondary);line-height:1.5;">Pertengahan pertama; bisa terpengaruh libur sekolah awal.</div>
          </div>
          <div class="q-card q3">
            <div style="font-size:1.1rem;font-weight:900;color:#b45309;margin-bottom:4px;">Q3</div>
            <div style="font-size:0.9rem;font-weight:700;color:var(--color-text-primary);margin-bottom:6px;">Juli-September</div>
            <div style="font-size:0.8rem;color:var(--color-text-secondary);line-height:1.5;">Pertengahan kedua; sering membaca dampak libur sekolah dan normalisasi setelahnya.</div>
          </div>
          <div class="q-card q4">
            <div style="font-size:1.1rem;font-weight:900;color:#b91c1c;margin-bottom:4px;">Q4</div>
            <div style="font-size:0.9rem;font-weight:700;color:var(--color-text-primary);margin-bottom:6px;">Oktober-Desember</div>
            <div style="font-size:0.8rem;color:var(--color-text-secondary);line-height:1.5;">Akhir tahun; biasanya menangkap periode libur akhir bulan Desember, dan budget akhir tahun.</div>
          </div>
        </div>
        <div style="font-size:10px;font-weight:700;letter-spacing:0.1em;text-transform:uppercase;color:var(--color-text-tertiary);margin-bottom:12px;">📊 Metodologi Kalkulasi</div>
        <div class="support-grid">
          <div class="support-item">
            <div class="support-item-label">Gap Musiman</div>
            <div class="support-item-title">Selisih kuartal kuat vs lemah</div>
            <div class="support-item-desc">Gap besar berarti kapasitas tidak bisa dibuat rata sepanjang tahun. Gap kecil berarti demand stabil dan planning bisa memakai baseline umum.</div>
          </div>
          <div class="support-item">
            <div class="support-item-label">Efek Libur</div>
            <div class="support-item-title">Bulan liburan vs Bulan reguler</div>
            <div class="support-item-desc">Membaca apakah musim liburan sekolah & akhir tahun menaikkan demand secara nyata dibanding bulan biasa.</div>
          </div>
          <div class="support-item">
            <div class="support-item-label">Metodologi</div>
            <div class="support-item-title">Rata-rata bulanan per kuartal</div>
            <div class="support-item-desc">Perbandingan kuartal memakai rata-rata order bulanan agar kuartal dengan data tidak lengkap tidak otomatis kalah.</div>
          </div>
        </div>
      </div>
    </details>
  </div>

<SectionHeader 
  eyebrow="🗓️ Pergeseran Musiman"
  title="Pola Historis Seluruh Periode"
  description="Analisis pola permintaan jangka panjang untuk mengidentifikasi pergeseran musiman dan efek liburan sepanjang tahun."
/>

<div class="kpi-row-3" style="margin-bottom: 32px;">
  <div class="kpi-card strong">
    <div class="kpi-label">🌟 Kuartal Puncak</div>
    <div class="kpi-number">{sq}</div>
    <div class="kpi-interp">Kuartal dengan rata-rata order bulanan tertinggi. Kapasitas operasional (staf & stok) harus siap maksimal di periode ini.</div>
  </div>
  <div class="kpi-card growth">
    <div class="kpi-label">📏 Gap Musiman</div>
    <div class="kpi-number">{sgp}%</div>
    <div class="kpi-interp">
      Selisih volume demand antara kuartal puncak ({sq}) dan terendah ({wq}).
      {#if sgp >= 40} Gap ekstrem, butuh penyesuaian kapasitas yang signifikan.
      {:else if sgp >= 20} Gap moderat, siapkan shift fleksibel.
      {:else} Demand relatif stabil sepanjang tahun.{/if}
    </div>
  </div>
  <div class="kpi-card holiday">
    <div class="kpi-label">🎉 Efek Musim Liburan</div>
    <div class="kpi-number">{#if hep > 0}+{hep}%{:else}{hep}%{/if}</div>
    <div class="kpi-interp">
      Perbandingan rata-rata pesanan pada bulan libur sekolah & akhir tahun dibanding bulan reguler.
    </div>
  </div>
</div>


	  <div class="strategic-stack">
	    <div class="strategic-header">
	      <div class="strategic-eyebrow">🔭 Perspektif Musiman</div>
	      <h2 class="strategic-title">Baca pola tahunan untuk perencanaan kapasitas</h2>
	      <p class="strategic-copy">Analisis di bawah ini merangkum perbandingan langsung performa restoran saat musim liburan melawan hari-hari reguler, serta rekomendasi kapasitas yang dapat Anda ambil.</p>
	    </div>
	

            <div style="display: flex; gap: 16px; align-items: center; justify-content: center; margin-bottom: 24px;">
              <!-- Holiday Card -->
              <div style="flex: 1; padding: 24px; border-radius: 16px; background: linear-gradient(135deg, rgba(245,158,11,0.1) 0%, rgba(245,158,11,0.02) 100%); border: 1px solid rgba(245,158,11,0.2); text-align: center; position: relative; transition: all 0.3s ease; cursor: default;" onmouseover="this.style.transform='translateY(-4px)'; this.style.boxShadow='0 10px 15px -3px rgba(245,158,11,0.2)'" onmouseout="this.style.transform='none'; this.style.boxShadow='none'">
                <div style="font-size: 2.5rem; margin-bottom: 12px;">🎉</div>
                <div style="font-size: 0.9rem; font-weight: 700; color: #b45309; text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 4px;">Musim Liburan</div>
                <div style="font-size: 0.8rem; color: var(--color-text-tertiary); margin-bottom: 16px;">Juli, Desember & Musim Ramadan/Lebaran</div>
                <div style="font-size: 2rem; font-weight: 800; color: var(--color-text-primary);">{#if ho}{Math.round(ho).toLocaleString('id-ID')}{:else}0{/if}</div>
                <div style="font-size: 0.9rem; color: var(--color-text-secondary); margin-top: 4px;">Rata-rata Order / Bulan</div>
              </div>
  
              <!-- Gap Badge -->
              <div style="display: flex; flex-direction: column; align-items: center; justify-content: center; z-index: 10;">
                <div style="background: white; border: 1px solid var(--color-border); border-radius: 30px; padding: 12px 24px; font-weight: 800; font-size: 1.1rem; color: {hep > 0 ? '#16a34a' : '#dc2626'}; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1);">
                  {#if hep > 0}+{hep}%{:else}{hep}%{/if}
                </div>
                <div style="font-size: 0.75rem; color: var(--color-text-tertiary); margin-top: 8px; font-weight: 600; text-transform: uppercase;">Selisih Traffic</div>
              </div>

              <!-- Regular Card -->
              <div style="flex: 1; padding: 24px; border-radius: 16px; background: rgba(0,0,0,0.02); border: 1px solid rgba(0,0,0,0.08); text-align: center; transition: all 0.3s ease; cursor: default;" onmouseover="this.style.transform='translateY(-4px)'; this.style.boxShadow='0 10px 15px -3px rgba(0,0,0,0.1)'" onmouseout="this.style.transform='none'; this.style.boxShadow='none'">
                <div style="font-size: 2.5rem; margin-bottom: 12px;">📅</div>
                <div style="font-size: 0.9rem; font-weight: 700; color: var(--color-text-secondary); text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 4px;">Bulan Reguler</div>
                <div style="font-size: 0.8rem; color: var(--color-text-tertiary); margin-bottom: 16px;">Hari Operasional Standar</div>
                <div style="font-size: 2rem; font-weight: 800; color: var(--color-text-primary);">{#if ro}{Math.round(ro).toLocaleString('id-ID')}{:else}0{/if}</div>
                <div style="font-size: 0.9rem; color: var(--color-text-secondary); margin-top: 4px;">Rata-rata Order / Bulan</div>
              </div>
            </div>
            <div style="background: var(--color-bg-secondary); padding: 16px; border-radius: 12px; font-size: 0.9rem; color: var(--color-text-secondary); line-height: 1.6;">
              💡 <strong>Insight:</strong> Selama musim tinggi (<i>Peak Season</i>) yang mencakup <strong>Libur Sekolah, Akhir Tahun, dan Periode Ramadan/Lebaran</strong>, restoran Anda mengalami perubahan traffic sebesar <strong>{#if hep > 0}+{hep}%{:else}{hep}%{/if}</strong> dibandingkan hari-hari biasa. Gunakan angka ini sebagai patokan penambahan atau pengurangan staf temporer.
            </div>

        <details class="guide-acc" style="margin-top: 24px;">
          <summary>🎯 Perencanaan Kapasitas · Baca Staf, Stok, dan Marketing</summary>
          <div class="acc-body">
            
            <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; margin-top: 8px;">
              <!-- Card 1: Staf -->
              <div style="background: linear-gradient(135deg, rgba(59,130,246,0.1), rgba(59,130,246,0.02)); border: 1px solid rgba(59,130,246,0.2); border-radius: 12px; padding: 20px; text-align: center; transition: all 0.3s ease; cursor: default;" onmouseover="this.style.transform='translateY(-4px)'; this.style.boxShadow='0 10px 15px -3px rgba(59,130,246,0.2)'" onmouseout="this.style.transform='none'; this.style.boxShadow='none'">
                <div style="font-size: 2.5rem; margin-bottom: 12px;">👥</div>
                <div style="font-size: 0.95rem; font-weight: 700; color: #1d4ed8; margin-bottom: 8px; text-transform: uppercase; letter-spacing: 0.05em;">Kapasitas Staf</div>
                <div style="font-size: 0.85rem; color: var(--color-text-secondary); line-height: 1.5;">

                  {#if ss === 'kuat'}
                    <strong>Mulai rekrutmen atau pelatihan staf 6–8 minggu sebelum {sq}.</strong> Dengan selisih musiman {sgp}%, kapasitas staf reguler tidak cukup di kuartal puncak. Rekrut staf paruh waktu atau intensifkan training sebelum musim ramai.
                  {:else if ss === 'moderat'}
                    <strong>Review kebutuhan staf 4–6 minggu sebelum {sq}.</strong> Selisih {sgp}% membutuhkan antisipasi ringan. Identifikasi apakah kapasitas saat ini bisa dioptimasi dengan rotasi shift sebelum memutuskan rekrutmen tambahan.
                  {:else}
                    <strong>Pertahankan kapasitas staf yang konsisten.</strong> Tidak ada pergeseran musiman signifikan — rotasi staf bisa dijadwalkan kapan saja tanpa mengganggu momen ramai.
                  {/if}

                </div>
              </div>

              <!-- Card 2: Stok -->
              <div style="background: linear-gradient(135deg, rgba(16,185,129,0.1), rgba(16,185,129,0.02)); border: 1px solid rgba(16,185,129,0.2); border-radius: 12px; padding: 20px; text-align: center; transition: all 0.3s ease; cursor: default;" onmouseover="this.style.transform='translateY(-4px)'; this.style.boxShadow='0 10px 15px -3px rgba(16,185,129,0.2)'" onmouseout="this.style.transform='none'; this.style.boxShadow='none'">
                <div style="font-size: 2.5rem; margin-bottom: 12px;">📦</div>
                <div style="font-size: 0.95rem; font-weight: 700; color: #047857; margin-bottom: 8px; text-transform: uppercase; letter-spacing: 0.05em;">Logistik & Pengadaan</div>
                <div style="font-size: 0.85rem; color: var(--color-text-secondary); line-height: 1.5;">

                  {#if hep > 10}
                    <strong>Sesuaikan timeline pengadaan liburan.</strong> Efek libur {hep}% di atas normal berarti kebutuhan bahan baku lebih tinggi. Koordinasikan dengan supplier minimal 3–4 minggu sebelumnya.
                  {:else}
                    <strong>Rencanakan pengadaan berbasis rata-rata.</strong> Tidak ada lonjakan musiman yang memerlukan buffer stok ekstra secara rutin.
                  {/if}

                </div>
              </div>

              <!-- Card 3: Marketing -->
              <div style="background: linear-gradient(135deg, rgba(139,92,246,0.1), rgba(139,92,246,0.02)); border: 1px solid rgba(139,92,246,0.2); border-radius: 12px; padding: 20px; text-align: center; transition: all 0.3s ease; cursor: default;" onmouseover="this.style.transform='translateY(-4px)'; this.style.boxShadow='0 10px 15px -3px rgba(139,92,246,0.2)'" onmouseout="this.style.transform='none'; this.style.boxShadow='none'">
                <div style="font-size: 2.5rem; margin-bottom: 12px;">📣</div>
                <div style="font-size: 0.95rem; font-weight: 700; color: #6d28d9; margin-bottom: 8px; text-transform: uppercase; letter-spacing: 0.05em;">Fokus Pemasaran</div>
                <div style="font-size: 0.85rem; color: var(--color-text-secondary); line-height: 1.5;">

                  {#if ss === 'kuat' || ss === 'moderat'}
                    <strong>Alokasikan porsi promosi ekstra di {wq}.</strong> Untuk menambal kelesuan <em>traffic</em> organik di kuartal terlemah, berikan porsi <em>budget marketing</em> lebih agresif. Sebaliknya saat kuartal puncak ({sq}), hemat <em>budget</em> akuisisi dan fokus maksimalkan profit.
                  {:else}
                    <strong>Distribusikan anggaran promosi merata.</strong> Tren order sangat stabil sepanjang tahun. Manuver <em>budget</em> drastis tidak diperlukan, cukup fokuskan pada program retensi reguler.
                  {/if}

                </div>
              </div>
            </div>

          </div>
        </details>

    <hr style="border: none; border-top: 2px dashed rgba(0,0,0,0.1); margin: 32px 0;">
    
    <div class="section-head tight" style="margin-bottom: 16px;">
      <div>
        <div class="section-eyebrow">📊 Distribusi Kuartal Historis</div>
        <div class="section-title" style="font-size: 1.3rem; font-weight: 800; margin: 4px 0;">Bagaimana tren kuartalan terbentuk dari tahun ke tahun?</div>
        <div class="section-copy">Bukti data mentah pergeseran tren kuartalan yang mendasari rekomendasi kapasitas dan marketing di atas.</div>
      </div>
    </div>

    <BarChart data={activeQuarterly} x=kuartal y=q_orders series=tahun type="grouped" title="Total Order per Kuartal — per Tahun" xAxisTitle="Kuartal" yAxisTitle="Total Order" yFmt='#,##0 "Order"' />

    <div class="section-head tight" style="margin-top: 32px; margin-bottom: 16px;">
      <div>
        <div class="section-eyebrow">📋 Rata-Rata Historis per Kuartal</div>
        <div class="section-title" style="font-size: 1.3rem; font-weight: 800; margin: 4px 0;">Kuartal mana yang paling dominan secara historis?</div>
        <div class="section-copy">Ringkasan murni rata-rata performa antar kuartal (menghaluskan efek anomali lonjakan di tahun tertentu).</div>
      </div>
    </div>
    
    <PremiumTable 
      data={activeQuarterlyAvg} 
      pageSize={4} 
      columns={[
        { title: "Kuartal", key: "kuartal", align: "center", bold: true },
        { title: "Rata-rata Order", key: "avg_q_orders", align: "right", type: "currency_raw" },
        { title: "Porsi Order", key: "pct_orders", align: "right", type: "pct_ratio" },
        { title: "Rata-rata Revenue (Rp)", key: "avg_q_revenue", align: "right", type: "currency_raw" },
        { title: "Porsi Revenue", key: "pct_revenue", align: "right", type: "pct_ratio" }
      ]} 
    />

    <div class="chart-interp" style="margin-top: 16px;">
      📌 <strong>Gunakan data kuartalan untuk validasi pola:</strong> pastikan lonjakan atau penurunan di suatu kuartal terjadi secara konsisten dari tahun ke tahun. Pola yang berulang (bukan anomali satu tahun) adalah fondasi paling aman untuk merencanakan rekrutmen staf dan anggaran <em>marketing</em>.
    </div>




  </div>
{:else}
  <div style="margin-top: 32px; padding: 48px 24px; text-align: center; background: rgba(0,0,0,0.02); border: 1px dashed rgba(245,158,11,0.3); border-radius: 16px;">
    <div style="font-size: 2rem; margin-bottom: 12px;">⏳</div>
    <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--color-text-primary); margin-bottom: 8px;">Data Historis Belum Cukup</h3>
    <p style="font-size: 0.95rem; color: var(--color-text-secondary); max-width: 480px; margin: 0 auto;">Cabang <strong>{selectedBranch}</strong> tercatat baru beroperasi selama {activeMonthly.length} bulan. Analisis pergeseran musiman memerlukan minimal 12 bulan (1 siklus tahunan) data historis penuh agar tren jangka panjang yang dibaca akurat dan tidak menyesatkan.</p>
  </div>
{/if}
{:else}
  <div style="margin-top: 32px; padding: 48px 24px; text-align: center; background: rgba(0,0,0,0.02); border: 1px dashed rgba(0,0,0,0.1); border-radius: 16px;">
    <div style="font-size: 2rem; margin-bottom: 12px;">🏪</div>
    <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--color-text-primary); margin-bottom: 8px;">Silakan Pilih Cabang</h3>
    <p style="font-size: 0.95rem; color: var(--color-text-secondary); max-width: 400px; margin: 0 auto;">Pilih salah satu cabang di Pusat Kendali Musiman untuk memulai analisis data historisnya.</p>
  </div>
{/if}
</div>
        {/if}
      </div>
    </Tab>
  </Tabs>


  {:else}
    <div style="text-align: center; padding: 60px 20px; background: #f9fafb; border-radius: 12px; margin-top: 32px; border: 1px dashed #cbd5e1;">
      <h3 style="margin-bottom: 12px; color: #475569;">☝️ Silakan Pilih Cabang Terlebih Dahulu</h3>
      <p style="color: #64748b; font-size: 1.05rem;">Gunakan menu pilihan cabang di atas untuk memuat diagnosis pola traffic, jam sibuk harian, dan tren musiman secara spesifik.</p>
    </div>
  {/if}
{/if}
