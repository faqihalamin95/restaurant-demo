---
title: Branch Performance
---

<style>
.over-container {
  display: none !important;
}

/* ── Base accordion ── */
details {
  border: 1px solid rgba(128, 128, 128, 0.18);
  border-radius: 12px;
  margin: 10px 0;
  overflow: hidden;
  background: rgba(255,255,255,0.55);
}

details > summary {
  padding: 14px 16px;
  cursor: pointer;
  background: rgba(128, 128, 128, 0.04);
  font-weight: 700;
  list-style: none;
  display: flex;
  align-items: center;
  gap: 8px;
}

details > summary::-webkit-details-marker { display: none; }

details[open] > summary {
  border-bottom: 1px solid rgba(128, 128, 128, 0.14);
}

.acc-body {
  padding: 16px;
  font-size: 0.9em;
  line-height: 1.75;
}

/* ── Strategic accordion ── */
details.acc-strategic {
  border-radius: 20px;
  border: 1.5px solid rgba(99, 102, 241, 0.18);
  background: linear-gradient(135deg, rgba(99,102,241,0.04), rgba(139,92,246,0.03));
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
}

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
details.acc-strategic .acc-body { padding: 20px; }

/* ── Page layout ── */
.branch-page {
  display: flex;
  flex-direction: column;
  gap: 24px;
  margin-top: 10px;
}

.page-intro {
  font-size: 0.92rem;
  line-height: 1.75;
  color: var(--color-text-secondary);
  max-width: 70ch;
}

/* ── Period strip ── */
.period-strip {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 10px;
}

.period-pill {
  padding: 14px 16px;
  border-radius: 16px;
  border: 1.5px solid var(--color-border-tertiary);
  background: var(--color-background-secondary);
  position: relative;
  overflow: hidden;
}

.period-pill.healthy {
  border-color: rgba(22, 163, 74, 0.28);
  background: linear-gradient(135deg, rgba(22,163,74,0.09) 0%, rgba(16,185,129,0.05) 100%);
}

.period-pill.watch {
  border-color: rgba(245, 158, 11, 0.32);
  background: linear-gradient(135deg, rgba(245,158,11,0.1) 0%, rgba(251,191,36,0.05) 100%);
}

.period-pill.critical {
  border-color: rgba(239, 68, 68, 0.28);
  background: linear-gradient(135deg, rgba(239,68,68,0.09) 0%, rgba(220,38,38,0.05) 100%);
}

.period-pill-label {
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: var(--color-text-tertiary);
  margin-bottom: 5px;
}

.period-pill-value {
  font-size: 1.02rem;
  font-weight: 800;
  letter-spacing: -0.02em;
  color: var(--color-text-primary);
  display: flex;
  align-items: center;
  gap: 6px;
}

.pill-badge {
  display: inline-block;
  padding: 2px 8px;
  border-radius: 999px;
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 0.04em;
}

.pill-badge.healthy { background: rgba(22,163,74,0.15); color: #15803d; }
.pill-badge.watch   { background: rgba(245,158,11,0.18); color: #b45309; }
.pill-badge.critical { background: rgba(239,68,68,0.15); color: #b91c1c; }

.period-pill-copy {
  margin-top: 4px;
  font-size: 0.82rem;
  line-height: 1.55;
  color: var(--color-text-secondary);
}

/* ── Hero ── */
.hero {
  display: grid;
  grid-template-columns: minmax(0, 1.7fr) minmax(280px, 1fr);
  gap: 18px;
  padding: 24px;
  border-radius: 22px;
  border: 1px solid rgba(37, 99, 235, 0.12);
  background:
    radial-gradient(circle at top right, rgba(69, 161, 191, 0.18), transparent 35%),
    radial-gradient(circle at bottom left, rgba(99,102,241,0.08), transparent 40%),
    linear-gradient(135deg, rgba(37, 99, 235, 0.06), rgba(194, 65, 12, 0.04)),
    var(--color-background-secondary);
}

.hero-eyebrow {
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 0.13em;
  text-transform: uppercase;
  color: var(--color-text-tertiary);
  margin-bottom: 8px;
  display: flex;
  align-items: center;
  gap: 6px;
}

.hero-title {
  margin: 0 0 10px;
  font-size: 1.9rem;
  line-height: 1.1;
  letter-spacing: -0.035em;
  color: var(--color-text-primary);
}

.hero-copy {
  margin: 0;
  font-size: 0.95rem;
  line-height: 1.75;
  color: var(--color-text-secondary);
  max-width: 62ch;
}

.hero-side {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.hero-side-card {
  padding: 14px 15px;
  border-radius: 14px;
  border: 1px solid var(--color-border-tertiary);
  background: rgba(255,255,255,0.72);
}

.hero-side-label {
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: var(--color-text-tertiary);
  margin-bottom: 4px;
}

.hero-side-value {
  font-size: 1.05rem;
  font-weight: 800;
  letter-spacing: -0.02em;
  color: var(--color-text-primary);
}

.hero-side-note {
  margin-top: 4px;
  font-size: 0.82rem;
  line-height: 1.6;
  color: var(--color-text-secondary);
}

/* ── KPI grid ── */
.kpi-grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 12px;
}

.kpi-card {
  padding: 17px;
  border-radius: 18px;
  border: 1.5px solid var(--color-border-tertiary);
  background: var(--color-background-secondary);
  box-shadow: 0 1px 4px rgba(0,0,0,0.05);
  position: relative;
  overflow: hidden;
}

.kpi-card.revenue {
  border-color: rgba(37,99,235,0.18);
  background: linear-gradient(145deg, rgba(37,99,235,0.06), rgba(99,102,241,0.03));
}

.kpi-card.net {
  border-color: rgba(16,185,129,0.22);
  background: linear-gradient(145deg, rgba(16,185,129,0.07), rgba(22,163,74,0.03));
}

.kpi-card.margin {
  border-color: rgba(245,158,11,0.22);
  background: linear-gradient(145deg, rgba(245,158,11,0.07), rgba(251,191,36,0.03));
}

.kpi-card.orders {
  border-color: rgba(99,102,241,0.18);
  background: linear-gradient(145deg, rgba(99,102,241,0.06), rgba(139,92,246,0.02));
}

.kpi-label {
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: var(--color-text-tertiary);
  margin-bottom: 8px;
  display: flex;
  align-items: center;
  gap: 5px;
}

.kpi-value {
  font-size: 1.05rem;
  font-weight: 800;
  letter-spacing: -0.03em;
  color: var(--color-text-primary);
}

.kpi-meta {
  margin-top: 6px;
  font-size: 0.82rem;
  line-height: 1.6;
  color: var(--color-text-secondary);
}

/* ── Signal grid ── */
.signal-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 14px;
}

.signal-card {
  padding: 18px;
  border-radius: 16px;
  border: 1px solid var(--color-border-tertiary);
  background: var(--color-background-secondary);
}

.signal-card.safe {
  border-color: rgba(22, 163, 74, 0.25);
  background: linear-gradient(135deg, rgba(22,163,74,0.08), rgba(16,185,129,0.03));
}

.signal-card.warn {
  border-color: rgba(245, 158, 11, 0.3);
  background: linear-gradient(135deg, rgba(245,158,11,0.09), rgba(251,191,36,0.03));
}

.signal-card.critical {
  border-color: rgba(239, 68, 68, 0.25);
  background: linear-gradient(135deg, rgba(239,68,68,0.09), rgba(220,38,38,0.03));
}

.signal-card.neutral {
  border-color: rgba(99, 102, 241, 0.2);
  background: linear-gradient(135deg, rgba(99,102,241,0.07), rgba(139,92,246,0.03));
}

.signal-label {
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 0.09em;
  text-transform: uppercase;
  color: var(--color-text-tertiary);
  margin-bottom: 6px;
  display: flex;
  align-items: center;
  gap: 5px;
}

.signal-title {
  font-size: 1rem;
  font-weight: 800;
  letter-spacing: -0.02em;
  color: var(--color-text-primary);
  margin-bottom: 6px;
}

.signal-copy {
  font-size: 0.9rem;
  line-height: 1.7;
  color: var(--color-text-secondary);
}

/* ── Section card ── */
.section-card {
  padding: 20px;
  border-radius: 20px;
  border: 1px solid var(--color-border-tertiary);
  background: var(--color-background-secondary);
  box-shadow: 0 1px 3px rgba(0,0,0,0.04);
}

.section-head {
  display: flex;
  justify-content: space-between;
  align-items: end;
  gap: 16px;
  flex-wrap: wrap;
  margin-bottom: 14px;
}

.section-head.tight { margin-bottom: 10px; }

.section-eyebrow {
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 0.11em;
  text-transform: uppercase;
  color: var(--color-text-tertiary);
  margin-bottom: 4px;
  display: flex;
  align-items: center;
  gap: 5px;
}

.section-title {
  margin: 0;
  font-size: 1.12rem;
  font-weight: 800;
  letter-spacing: -0.02em;
  color: var(--color-text-primary);
}

.section-copy {
  margin: 4px 0 0;
  font-size: 0.88rem;
  line-height: 1.7;
  color: var(--color-text-secondary);
  max-width: 70ch;
}

/* ── Cost grid ── */
.cost-grid {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 12px;
}

.cost-card {
  padding: 16px;
  border-radius: 16px;
  border: 1px solid var(--color-border-tertiary);
  background: linear-gradient(180deg, rgba(255,255,255,0.82), rgba(255,255,255,0.6));
}

.cost-label {
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: var(--color-text-tertiary);
  margin-bottom: 8px;
  display: flex;
  align-items: center;
  gap: 5px;
}

.cost-value {
  font-size: 1.9rem;
  font-weight: 800;
  letter-spacing: -0.03em;
}

.cost-target {
  margin-top: 3px;
  font-size: 0.8rem;
  color: var(--color-text-secondary);
}

.progress-track {
  position: relative;
  margin-top: 12px;
  height: 8px;
  border-radius: 999px;
  background: rgba(0,0,0,0.08);
  overflow: hidden;
}

.progress-fill {
  height: 100%;
  border-radius: inherit;
}

.progress-target {
  position: absolute;
  top: -2px;
  bottom: -2px;
  width: 2px;
  background: rgba(0,0,0,0.22);
}

.progress-scale {
  display: flex;
  justify-content: space-between;
  margin-top: 6px;
  font-size: 10px;
  color: var(--color-text-tertiary);
}

.cost-note {
  margin-top: 10px;
  font-size: 0.83rem;
  line-height: 1.65;
  color: var(--color-text-secondary);
}

/* ── Mini grid ── */
.mini-grid {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 12px;
}

.mini-card {
  padding: 14px 15px;
  border-radius: 14px;
  border: 1px solid var(--color-border-tertiary);
  background: rgba(255,255,255,0.6);
}

.mini-value {
  font-size: 1.2rem;
  font-weight: 800;
  letter-spacing: -0.02em;
  color: var(--color-text-primary);
}

.mini-note {
  margin-top: 4px;
  font-size: 0.8rem;
  line-height: 1.55;
  color: var(--color-text-secondary);
}

/* ── Alert row ── */
.alert-row {
  display: flex;
  align-items: flex-start;
  gap: 10px;
  padding: 10px 12px;
  border-radius: 10px;
  font-size: 0.88rem;
  line-height: 1.6;
}

.alert-row.alert-green {
  background: rgba(22,163,74,0.06);
  border: 1px solid rgba(22,163,74,0.16);
  color: var(--color-text-secondary);
}

.alert-row.alert-yellow {
  background: rgba(245,158,11,0.06);
  border: 1px solid rgba(245,158,11,0.2);
  color: var(--color-text-secondary);
}

.alert-row.alert-red {
  background: rgba(239,68,68,0.06);
  border: 1px solid rgba(239,68,68,0.16);
  color: var(--color-text-secondary);
}

.alert-dot {
  width: 7px;
  height: 7px;
  border-radius: 50%;
  flex-shrink: 0;
  margin-top: 5px;
}

/* ── Chart insight ── */
.chart-insight {
  margin-top: 14px;
  padding: 14px 16px;
  border-radius: 14px;
  border: 1px solid rgba(99,102,241,0.15);
  background: linear-gradient(135deg, rgba(99,102,241,0.05), rgba(139,92,246,0.03));
  font-size: 0.88rem;
  line-height: 1.7;
  color: var(--color-text-secondary);
}

.chart-insight strong { color: var(--color-text-primary); }

/* ── Strategic section wrapper ── */
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

/* ── Scorecard table ── */
.scorecard-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 0.9em;
  overflow-x: auto;
}

.scorecard-table thead tr {
  border-bottom: 2px solid var(--color-border-tertiary);
}

.scorecard-table th {
  text-align: left;
  padding: 10px 12px;
  color: var(--color-text-tertiary);
  font-weight: 600;
  font-size: 11px;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.scorecard-table th:not(:first-child) { text-align: right; }

.scorecard-table td {
  padding: 10px 12px;
  border-bottom: 1px solid var(--color-border-tertiary);
}

.scorecard-table td:not(:first-child) { text-align: right; }

.scorecard-table tr.highlighted { background: rgba(0,0,0,0.02); }

.delta-up   { font-size: 11px; margin-left: 4px; color: #16a34a; }
.delta-down { font-size: 11px; margin-left: 4px; color: #dc2626; }

/* ── Inline link ── */
.inline-link {
  color: var(--color-primary);
  text-decoration: none;
}

.inline-link:hover { text-decoration: underline; }

/* ── Responsive ── */
@media (max-width: 1100px) {
  .hero,
  .kpi-grid,
  .period-strip,
  .cost-grid,
  .mini-grid,
  .signal-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 720px) {
  .hero,
  .kpi-grid,
  .period-strip,
  .cost-grid,
  .mini-grid,
  .signal-grid {
    grid-template-columns: 1fr;
  }

  .hero-title { font-size: 1.6rem; }
  .kpi-value, .cost-value { font-size: 1.5rem; }
}
</style>

```sql branch_list
SELECT DISTINCT branch_name
FROM restaurant_en.daily_revenue
ORDER BY branch_name
```

<ButtonGroup name=branch>
  <ButtonGroupItem valueLabel="All Locations" value="all" default />
  {#each branch_list as b}
  <ButtonGroupItem valueLabel={b.branch_name} value={b.branch_name} />
  {/each}
</ButtonGroup>

{#if inputs.branch === 'all'}

<!-- ════════════════════════════════════════════════
     ALL LOCATIONS VIEW
════════════════════════════════════════════════ -->

```sql health_branches
WITH max_d AS (SELECT MAX(order_date) AS d FROM restaurant_en.daily_revenue),
period AS (
    SELECT
        branch_name,
        SUM(total_revenue)                                                         AS revenue_30d,
        ROUND(AVG(pct_change_vs_sdow_avg) * 100, 1)                               AS avg_pct_vs_sdow
    FROM restaurant_en.daily_revenue CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '29 days'
    GROUP BY branch_name
),
margin AS (
    SELECT
        branch_name,
        ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1)          AS net_margin_pct
    FROM restaurant_en.daily_net_revenue CROSS JOIN (SELECT MAX(metric_date) AS d FROM restaurant_en.daily_net_revenue)
    WHERE metric_date >= d - INTERVAL '29 days'
    GROUP BY branch_name
),
gap AS (
    SELECT
        ROUND((MAX(revenue_30d) - MIN(revenue_30d)) / NULLIF(MIN(revenue_30d), 0) * 100, 1) AS gap_pct,
        MAX(CASE WHEN revenue_30d = (SELECT MAX(revenue_30d) FROM period) THEN branch_name END) AS top_branch,
        MIN(CASE WHEN revenue_30d = (SELECT MIN(revenue_30d) FROM period) THEN branch_name END) AS bottom_branch
    FROM period
)
SELECT
    SUM(p.revenue_30d)                                                             AS total_revenue_30d,
    ROUND(SUM(m.net_margin_pct * p.revenue_30d) / NULLIF(SUM(p.revenue_30d), 0), 1) AS avg_margin,
    g.gap_pct,
    g.top_branch,
    g.bottom_branch,
    COUNT(CASE WHEN m.net_margin_pct < 10 THEN 1 END)                             AS branches_critical,
    COUNT(CASE WHEN p.avg_pct_vs_sdow < -15 THEN 1 END)                           AS branches_declining,
    COUNT(DISTINCT p.branch_name)                                                  AS total_branches
FROM period p
LEFT JOIN margin m ON p.branch_name = m.branch_name
CROSS JOIN gap g
GROUP BY g.gap_pct, g.top_branch, g.bottom_branch
```

```sql kpi_all_30d
SELECT
    SUM(total_revenue)                                                            AS total_revenue,
    SUM(total_orders)                                                             AS total_orders,
    ROUND(SUM(total_revenue) / NULLIF(SUM(total_orders), 0), 2)                  AS avg_order_value,
    COUNT(DISTINCT branch_id)                                                     AS total_locations
FROM restaurant_en.daily_revenue
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant_en.daily_revenue) - INTERVAL '29 days'
```

```sql net_all_30d
SELECT
    SUM(net_revenue)                                                              AS net_revenue,
    ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1)            AS net_margin_pct
FROM restaurant_en.daily_net_revenue
WHERE metric_date >= (SELECT MAX(metric_date) FROM restaurant_en.daily_net_revenue) - INTERVAL '29 days'
```

```sql branch_summary_30d
SELECT
    dr.branch_name,
    SUM(dr.total_revenue)                                                         AS total_revenue,
    SUM(dr.total_orders)                                                          AS total_orders,
    ROUND(SUM(dr.total_revenue) / NULLIF(SUM(dr.total_orders), 0), 2)            AS avg_order_value,
    ROUND(AVG(dr.pct_change_vs_sdow_avg) * 100, 1)                               AS avg_pct_vs_sdow,
    SUM(nr.net_revenue)                                                           AS net_revenue,
    ROUND(SUM(nr.net_revenue) / NULLIF(SUM(nr.gross_revenue), 0) * 100, 1)       AS net_margin_pct
FROM restaurant_en.daily_revenue dr
LEFT JOIN restaurant_en.daily_net_revenue nr
    ON dr.order_date = nr.metric_date AND dr.branch_id = nr.branch_id
WHERE dr.order_date >= (SELECT MAX(order_date) FROM restaurant_en.daily_revenue) - INTERVAL '29 days'
GROUP BY dr.branch_name
ORDER BY total_revenue DESC
```

```sql branch_alert_30d
SELECT branch_name, ROUND(AVG(pct_change_vs_sdow_avg) * 100, 1) AS avg_pct_change
FROM restaurant_en.daily_revenue
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant_en.daily_revenue) - INTERVAL '29 days'
GROUP BY branch_name
HAVING AVG(pct_change_vs_sdow_avg) < -0.15
ORDER BY avg_pct_change ASC
```

```sql branch_daily_30d
SELECT order_date, branch_name, total_revenue,
    ROUND(revenue_sdow_avg, 2) AS revenue_sdow_avg
FROM restaurant_en.daily_revenue
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant_en.daily_revenue) - INTERVAL '29 days'
ORDER BY order_date, branch_name
```

```sql profitability_30d
SELECT
    branch_name,
    SUM(gross_revenue)          AS gross_revenue,
    SUM(net_revenue)            AS net_revenue,
    SUM(inventory_usage_cost)   AS cost_ingredients,
    SUM(labor_total_cost)       AS cost_labor,
    SUM(operational_total_cost) AS cost_overhead,
    ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS net_margin_pct
FROM restaurant_en.daily_net_revenue
WHERE metric_date >= (SELECT MAX(metric_date) FROM restaurant_en.daily_net_revenue) - INTERVAL '29 days'
GROUP BY branch_name
ORDER BY net_revenue DESC
```

```sql branch_wow
WITH max_date AS (SELECT MAX(order_date) AS d FROM restaurant_en.daily_revenue)
SELECT
    branch_name,
    SUM(CASE WHEN order_date >= (SELECT d FROM max_date) - INTERVAL '6 days'
        THEN total_revenue END)                                                   AS revenue_this_week,
    SUM(CASE WHEN order_date < (SELECT d FROM max_date) - INTERVAL '6 days'
         AND  order_date >= (SELECT d FROM max_date) - INTERVAL '13 days'
        THEN total_revenue END)                                                   AS revenue_last_week,
    ROUND(
        (SUM(CASE WHEN order_date >= (SELECT d FROM max_date) - INTERVAL '6 days'
            THEN total_revenue END)
        - SUM(CASE WHEN order_date < (SELECT d FROM max_date) - INTERVAL '6 days'
             AND   order_date >= (SELECT d FROM max_date) - INTERVAL '13 days'
            THEN total_revenue END))
        / NULLIF(SUM(CASE WHEN order_date < (SELECT d FROM max_date) - INTERVAL '6 days'
             AND  order_date >= (SELECT d FROM max_date) - INTERVAL '13 days'
            THEN total_revenue END), 0) * 100
    , 1) AS pct_change
FROM restaurant_en.daily_revenue
GROUP BY branch_name
ORDER BY branch_name
```

```sql branch_monthly
SELECT
    DATE_TRUNC('month', order_date) AS month,
    branch_name,
    SUM(total_revenue)              AS total_revenue,
    SUM(total_orders)               AS total_orders
FROM restaurant_en.daily_revenue
GROUP BY 1, 2
ORDER BY 1, 2
```

```sql branch_alltime
SELECT
    dr.branch_name,
    SUM(dr.total_revenue)                                               AS total_revenue,
    SUM(dr.total_orders)                                                AS total_orders,
    ROUND(SUM(dr.total_revenue) / NULLIF(SUM(dr.total_orders), 0), 2)  AS avg_order_value,
    SUM(nr.net_revenue)                                                 AS net_revenue,
    ROUND(SUM(nr.net_revenue) / NULLIF(SUM(nr.gross_revenue), 0) * 100, 1) AS net_margin_pct,
    MIN(dr.order_date)                                                  AS first_date,
    MAX(dr.order_date)                                                  AS last_date
FROM restaurant_en.daily_revenue dr
LEFT JOIN restaurant_en.daily_net_revenue nr
    ON dr.order_date = nr.metric_date AND dr.branch_id = nr.branch_id
GROUP BY dr.branch_name
ORDER BY total_revenue DESC
```

<div class="branch-page">

  <div class="page-intro">
    Branch performance brings together revenue, margin, and cost signals across every location. Financial totals are on the <a class="inline-link" href="/01-laporan-keuangan">Financial Report</a> page — this page focuses on which locations are driving results, where gaps are widening, and which branches need attention first.
  </div>

  <!-- ── Portfolio health strip ── -->
  <div class="period-strip">
    <div class="period-pill {health_branches[0].avg_margin >= 15 ? 'healthy' : health_branches[0].avg_margin >= 10 ? 'watch' : 'critical'}">
      <div class="period-pill-label">💰 Blended Margin</div>
      <div class="period-pill-value">
        <span class="pill-badge {health_branches[0].avg_margin >= 15 ? 'healthy' : health_branches[0].avg_margin >= 10 ? 'watch' : 'critical'}">
          {health_branches[0].avg_margin >= 15 ? '✅ Healthy' : health_branches[0].avg_margin >= 10 ? '⚠️ Watch' : '🚨 Critical'}
        </span>
        {net_all_30d[0].net_margin_pct}%
      </div>
      <div class="period-pill-copy">
        {#if health_branches[0].avg_margin >= 15}
          🟢 Portfolio margin above 15% target.
        {:else if health_branches[0].avg_margin >= 10}
          🟡 Below 15% — cost structure needs review.
        {:else}
          🔴 Critical — below 10% across portfolio.
        {/if}
      </div>
    </div>

    <div class="period-pill {health_branches[0].gap_pct < 50 ? 'healthy' : health_branches[0].gap_pct <= 100 ? 'watch' : 'critical'}">
      <div class="period-pill-label">🏪 Revenue Gap</div>
      <div class="period-pill-value">
        <span class="pill-badge {health_branches[0].gap_pct < 50 ? 'healthy' : health_branches[0].gap_pct <= 100 ? 'watch' : 'critical'}">
          {health_branches[0].gap_pct < 50 ? '✅ Balanced' : health_branches[0].gap_pct <= 100 ? '⚠️ Gap' : '🚨 Wide Gap'}
        </span>
        {health_branches[0].gap_pct}%
      </div>
      <div class="period-pill-copy">
        Top: {health_branches[0].top_branch} · Bottom: {health_branches[0].bottom_branch}
      </div>
    </div>

    <div class="period-pill {health_branches[0].branches_critical === 0 && health_branches[0].branches_declining === 0 ? 'healthy' : health_branches[0].branches_critical > 0 ? 'critical' : 'watch'}">
      <div class="period-pill-label">🚦 Alert Count</div>
      <div class="period-pill-value">
        <span class="pill-badge {health_branches[0].branches_critical === 0 && health_branches[0].branches_declining === 0 ? 'healthy' : health_branches[0].branches_critical > 0 ? 'critical' : 'watch'}">
          {health_branches[0].branches_critical === 0 && health_branches[0].branches_declining === 0 ? '✅ All Clear' : '⚠️ Alerts'}
        </span>
        {health_branches[0].branches_critical + health_branches[0].branches_declining} active
      </div>
      <div class="period-pill-copy">
        {health_branches[0].branches_critical} critical margin · {health_branches[0].branches_declining} underperforming
      </div>
    </div>
  </div>

  <!-- ── Hero ── -->
  <div class="hero">
    <div>
      <div class="hero-eyebrow">🏪 Branch Performance · Last 30 Days</div>
      {#if health_branches[0].branches_critical === 0 && health_branches[0].branches_declining === 0 && health_branches[0].avg_margin >= 15}
        <h2 class="hero-title">All {health_branches[0].total_branches} locations healthy — portfolio operating on solid ground. ✅</h2>
      {:else if health_branches[0].branches_critical > 0}
        <h2 class="hero-title">{health_branches[0].branches_critical} location{health_branches[0].branches_critical > 1 ? 's' : ''} below critical margin threshold. 🚨</h2>
      {:else if health_branches[0].branches_declining > 0}
        <h2 class="hero-title">{health_branches[0].branches_declining} location{health_branches[0].branches_declining > 1 ? 's' : ''} underperforming vs same-day benchmarks. ⚠️</h2>
      {:else}
        <h2 class="hero-title">Portfolio margin at {health_branches[0].avg_margin}% — below 15% target across {health_branches[0].total_branches} locations. ⚠️</h2>
      {/if}
      <p class="hero-copy">
        {#if health_branches[0].gap_pct >= 100}
          Revenue concentration is the main structural concern: <strong>{health_branches[0].top_branch}</strong> is pulling well ahead while <strong>{health_branches[0].bottom_branch}</strong> lags far behind. Select that location to investigate what's driving the gap.
        {:else if health_branches[0].branches_critical > 0}
          Critical margin signals aren't always a revenue problem — more often they point to a cost structure that outpaced sales. Use the Evidence Matrix below to identify which locations sit in the optimization zone.
        {:else if health_branches[0].branches_declining > 0}
          Revenue trends are weakening in some locations relative to their own same-day-of-week baseline. This often signals early-stage demand softening before it shows up in margin.
        {:else}
          The portfolio is performing within healthy parameters. The priority now is maintaining cost discipline and tracking whether the top locations are sustaining their lead or starting to plateau.
        {/if}
      </p>
    </div>
    <div class="hero-side">
      <div class="hero-side-card">
        <div class="hero-side-label">🏪 Active Locations</div>
        <div class="hero-side-value">{health_branches[0].total_branches} branches</div>
        <div class="hero-side-note">Select a branch from the tabs above for a detailed multi-period breakdown including margin, cost, and trend analysis.</div>
      </div>
      <div class="hero-side-card">
        <div class="hero-side-label">💵 Gross Revenue · 30 Days</div>
        <div class="hero-side-value">${kpi_all_30d[0].total_revenue?.toLocaleString('en-US', {minimumFractionDigits:0, maximumFractionDigits:0})}</div>
        <div class="hero-side-note">Net revenue: ${net_all_30d[0].net_revenue?.toLocaleString('en-US', {minimumFractionDigits:0, maximumFractionDigits:0})} · Avg order: ${kpi_all_30d[0].avg_order_value}</div>
      </div>
    </div>
  </div>

  <!-- ── KPI Grid ── -->
  <div class="kpi-grid">
    <div class="kpi-card revenue">
      <div class="kpi-label">💵 Gross Revenue</div>
      <div class="kpi-value">${kpi_all_30d[0].total_revenue?.toLocaleString('en-US', {minimumFractionDigits:0, maximumFractionDigits:0})}</div>
      <div class="kpi-meta">Combined across all {health_branches[0].total_branches} locations, last 30 days.</div>
    </div>
    <div class="kpi-card net">
      <div class="kpi-label">💰 Net Revenue</div>
      <div class="kpi-value">${net_all_30d[0].net_revenue?.toLocaleString('en-US', {minimumFractionDigits:0, maximumFractionDigits:0})}</div>
      <div class="kpi-meta">What remains after ingredients, labor, and overhead.</div>
    </div>
    <div class="kpi-card margin">
      <div class="kpi-label">📈 Net Margin</div>
      <div class="kpi-value">{net_all_30d[0].net_margin_pct}%</div>
      <div class="kpi-meta">
        {net_all_30d[0].net_margin_pct >= 15 ? '✅ Above 15% target.' : net_all_30d[0].net_margin_pct >= 10 ? '⚠️ Below 15% target.' : '🚨 Below 10% — critical.'}
      </div>
    </div>
    <div class="kpi-card orders">
      <div class="kpi-label">🛒 Total Orders</div>
      <div class="kpi-value">{kpi_all_30d[0].total_orders?.toLocaleString()}</div>
      <div class="kpi-meta">Avg order value: ${kpi_all_30d[0].avg_order_value} across all locations.</div>
    </div>
  </div>

  <!-- ── Signal cards ── -->
  <div class="signal-grid">
    <div class="signal-card {health_branches[0].avg_margin >= 15 ? 'safe' : health_branches[0].avg_margin >= 10 ? 'warn' : 'critical'}">
      <div class="signal-label">
        {health_branches[0].avg_margin >= 15 ? '✅' : health_branches[0].avg_margin >= 10 ? '⚠️' : '🚨'} What is driving performance?
      </div>
      <div class="signal-title">
        {#if health_branches[0].avg_margin >= 15 && health_branches[0].gap_pct < 50}
          Strong margin and balanced revenue — portfolio is well-distributed.
        {:else if health_branches[0].avg_margin >= 15}
          Margin is healthy but revenue concentration is creating portfolio risk.
        {:else if health_branches[0].avg_margin >= 10}
          Revenue is holding up; it's cost structure that's compressing margin.
        {:else}
          Both revenue softness and cost pressure are active simultaneously.
        {/if}
      </div>
      <div class="signal-copy">
        {#if health_branches[0].avg_margin >= 15 && health_branches[0].gap_pct < 50}
          No single location is disproportionately carrying the portfolio. This is the most resilient configuration — losses at one branch don't collapse the whole picture.
        {:else if health_branches[0].avg_margin >= 15}
          <strong>{health_branches[0].top_branch}</strong> is likely carrying an outsized share of total revenue. If that location underperforms in any period, it pulls the whole portfolio down with it.
        {:else}
          The gap between gross and net revenue is wider than it should be at this sales level. Cost breakdown per branch (below) will show which location is the biggest drag.
        {/if}
      </div>
    </div>
    <div class="signal-card {health_branches[0].branches_critical > 0 ? 'critical' : health_branches[0].branches_declining > 0 ? 'warn' : 'neutral'}">
      <div class="signal-label">
        {health_branches[0].branches_critical > 0 ? '🎯' : health_branches[0].branches_declining > 0 ? '📉' : '💡'} Where should leadership focus?
      </div>
      <div class="signal-title">
        {#if health_branches[0].branches_critical > 0}
          {health_branches[0].branches_critical} branch{health_branches[0].branches_critical > 1 ? 'es need' : ' needs'} immediate cost structure review.
        {:else if health_branches[0].branches_declining > 0}
          {health_branches[0].branches_declining} location{health_branches[0].branches_declining > 1 ? 's are' : ' is'} trending below their own baselines.
        {:else if health_branches[0].gap_pct >= 50}
          Revenue gap between top and bottom location warrants investigation.
        {:else}
          No urgent signals — focus on sustaining current performance quality.
        {/if}
      </div>
      <div class="signal-copy">
        {#if health_branches[0].branches_critical > 0}
          Critical margin doesn't always mean low sales. It often means costs scaled faster than revenue — typically in labor or overhead. Use the Evidence Matrix to locate which quadrant each branch sits in.
        {:else if health_branches[0].branches_declining > 0}
          Same-day-of-week comparisons filter out day-type noise. Sustained negative variance over 30 days is a reliable early signal that a location is losing consistent demand.
        {:else if health_branches[0].gap_pct >= 50}
          A gap above 50% means the bottom location is generating less than two-thirds of what the top location does. Select <strong>{health_branches[0].bottom_branch}</strong> to investigate whether this is a capacity, demand, or efficiency issue.
        {:else}
          This is the ideal condition to run strategic experiments: pilot pricing changes, test new service formats, or invest in the locations showing the strongest upward trend.
        {/if}
      </div>
    </div>
  </div>

  <!-- ── Evidence Matrix ── -->
  <div class="section-card">
    <div class="section-head">
      <div>
        <div class="section-eyebrow">🔬 Evidence Matrix</div>
        <h3 class="section-title">Where does each branch sit: volume vs. efficiency?</h3>
        <p class="section-copy">Plot every location on two axes — how much revenue they generate and how efficiently they convert it to net profit. This instantly reveals which branches are strategic assets and which need intervention.</p>
      </div>
    </div>
    <ScatterPlot
      data={branch_summary_30d}
      x="total_revenue"
      y="net_margin_pct"
      series="branch_name"
      title="Branch Evidence Matrix — Revenue vs Net Margin (30 Days)"
      xFmt="$#,##0"
      yFmt="0.0\%"
      xAxisTitle="Gross Revenue ($) →  Volume"
      yAxisTitle="Net Margin (%) →  Efficiency"
    >
      <ReferenceLine y={15} label="15% Margin Target" lineType="dashed" color="green" />
      <ReferenceLine y={10} label="10% Critical" lineType="dashed" color="red" />
    </ScatterPlot>
    <div class="chart-insight">
      📌 <strong>How to read this matrix:</strong>
      Locations in the <strong>top-right</strong> (high revenue + high margin) are your strategic assets — protect their cost structure.
      Locations in the <strong>top-left</strong> (low revenue + high margin) are scalable opportunities — they run efficiently, they just need more volume.
      Locations in the <strong>bottom-right</strong> (high revenue + low margin) are optimization targets — the sales are there, but costs are eroding profit.
      Locations in the <strong>bottom-left</strong> require the most urgent attention — both revenue and efficiency need work.
    </div>
  </div>

  <!-- ── Location rankings table ── -->
  <div class="section-card">
    <div class="section-head">
      <div>
        <div class="section-eyebrow">🏪 Location Rankings</div>
        <h3 class="section-title">Which locations are leading, which are lagging?</h3>
        <p class="section-copy">Sorted by gross revenue. The <em>vs Same-Day Avg</em> column is the most important trend signal — it compares each day's revenue against that location's own rolling average for the same day of week.</p>
      </div>
    </div>
    <DataTable data={branch_summary_30d}>
        <Column id="branch_name"     title="Location"/>
        <Column id="total_revenue"   title="Gross Revenue"   fmt="$#,##0.00"/>
        <Column id="total_orders"    title="Orders"          fmt="#,##0"/>
        <Column id="avg_order_value" title="Avg Order"       fmt="$#,##0.00"/>
        <Column id="avg_pct_vs_sdow" title="vs Same-Day Avg" fmt="+0.0;-0.0" contentType="delta"/>
        <Column id="net_revenue"     title="Net Revenue"     fmt="$#,##0.00"/>
        <Column id="net_margin_pct"  title="Margin"          fmt="0.0\%"/>
    </DataTable>
    <div class="chart-insight">
      📌 <strong>Alert signals:</strong>
      {#each branch_alert_30d as row}
        <strong>{row.branch_name}</strong> is averaging {row.avg_pct_change}% vs its own same-day benchmark — select this location for a closer look. &nbsp;
      {/each}
      {#if branch_alert_30d.length === 0}
        No locations are significantly underperforming their own same-day-of-week baseline this period.
      {/if}
    </div>
  </div>

  <!-- ── Revenue trend section ── -->
  <div class="section-card">
    <div class="section-head tight">
      <div>
        <div class="section-eyebrow">📈 Revenue Trends</div>
        <h3 class="section-title">Are locations moving together or diverging?</h3>
        <p class="section-copy">When lines diverge, it signals location-specific factors — not portfolio-wide conditions. Sustained divergence for 2+ weeks usually warrants a branch-level investigation.</p>
      </div>
    </div>
    <LineChart
        data={branch_daily_30d}
        x="order_date"
        y="total_revenue"
        series="branch_name"
        title="Daily Gross Revenue by Location ($)"
        yFmt="$#,##0"
        xAxisTitle="Date"
        yAxisTitle="Revenue ($)"
    />
    <div class="chart-insight">
      📌 <strong>What to look for:</strong> Lines that trend downward while others stay flat indicate location-specific demand loss — not a market-wide slowdown. Sudden drops on specific dates often point to operational issues (closures, staffing). Consistent underperformance vs the cluster points to a structural gap.
    </div>
  </div>

  <!-- ── Cost structure section ── -->
  <div class="section-card">
    <div class="section-head">
      <div>
        <div class="section-eyebrow">💸 Cost Structure</div>
        <h3 class="section-title">Which locations carry the heaviest cost burden?</h3>
        <p class="section-copy">Gross revenue minus net revenue reveals how much each location is spending on ingredients, labor, and overhead. High costs relative to peers at similar revenue levels signal an efficiency gap.</p>
      </div>
    </div>
    <Grid cols=2>
      <div>
        <BarChart
            data={profitability_30d}
            x="branch_name"
            y={["gross_revenue", "net_revenue"]}
            type="grouped"
            title="Gross vs Net Revenue — 30 Days ($)"
            yFmt="$#,##0"
            xAxisTitle="Location"
            yAxisTitle="Revenue ($)"
        />
      </div>
      <div>
        <BarChart
            data={profitability_30d}
            x="branch_name"
            y={["cost_ingredients", "cost_labor", "cost_overhead"]}
            type="stacked"
            title="Cost Breakdown by Location — 30 Days ($)"
            yFmt="$#,##0"
            xAxisTitle="Location"
            yAxisTitle="Total Cost ($)"
        />
      </div>
    </Grid>
    <div class="chart-insight">
      📌 <strong>Reading the cost bar:</strong> A location with a tall cost bar but average revenue is operating at below-market efficiency. The split between ingredients, labor, and overhead shows <em>where</em> the leak is — ingredient-heavy locations may need menu pricing or supplier review; labor-heavy ones may have scheduling inefficiencies.
    </div>
  </div>

  <!-- ══════════════════════════════════════════
       STRATEGIC ACCORDIONS
  ══════════════════════════════════════════ -->
  <div class="strategic-stack">
    <div class="strategic-header">
      <div class="strategic-eyebrow">🔭 Deeper Analysis</div>
      <h2 class="strategic-title">Expand to explore longer-horizon signals</h2>
      <p class="strategic-copy">Week-over-week momentum, monthly trajectory, and all-time context — use these to validate whether what you're seeing in 30 days is a blip or a pattern.</p>
    </div>

    <details class="acc-strategic">
      <summary>📊 Week-over-Week · Momentum Check</summary>
      <div class="acc-body">
        <div class="section-card" style="margin-bottom:0;box-shadow:none;border:none;padding:0;">
          <p class="section-copy" style="margin-bottom:14px;">
            WoW is a leading indicator, not a lagging one. A location declining two weeks in a row is sending a signal worth acting on before it shows up in the 30-day average.
          </p>
          <DataTable data={branch_wow}>
              <Column id="branch_name"        title="Location"/>
              <Column id="revenue_this_week"  title="This Week"  fmt="$#,##0.00"/>
              <Column id="revenue_last_week"  title="Last Week"  fmt="$#,##0.00"/>
              <Column id="pct_change"         title="Change"     fmt="+0.0;-0.0" contentType="delta"/>
          </DataTable>
        </div>
      </div>
    </details>

    <details class="acc-strategic">
      <summary>📅 Monthly Revenue · Trajectory View</summary>
      <div class="acc-body">
        <p class="section-copy" style="margin-bottom:14px;">
          Monthly stacked bars reveal whether the portfolio is growing in aggregate, and whether individual location contributions are shifting. A branch that was a smaller slice three months ago and is now larger is gaining relative share — and vice versa.
        </p>
        <BarChart
            data={branch_monthly}
            x="month"
            y="total_revenue"
            series="branch_name"
            type="stacked"
            title="Monthly Revenue by Location ($)"
            yFmt="$#,##0"
            xAxisTitle="Month"
            yAxisTitle="Revenue ($)"
        />
        <div class="chart-insight" style="margin-top:12px;">
          📌 <strong>What to watch:</strong> If the total bar height stays flat or declines while individual slices shift, it means market share is redistributing across locations — not growing. A rising total with stable slices means the whole portfolio is scaling.
        </div>
      </div>
    </details>

    <details class="acc-strategic">
      <summary>🗂 All-Time Summary · Foundational Context</summary>
      <div class="acc-body">
        <p class="section-copy" style="margin-bottom:14px;">
          All-time numbers put current performance in context. A location with a strong all-time margin but a weak recent period is likely experiencing a temporary dip, not a fundamental shift. A location with consistently weak margins across its entire history may have a structural problem that short-term fixes won't resolve.
        </p>
        <DataTable data={branch_alltime}>
            <Column id="branch_name"     title="Location"/>
            <Column id="total_revenue"   title="Gross Revenue"   fmt="$#,##0.00"/>
            <Column id="total_orders"    title="Total Orders"    fmt="#,##0"/>
            <Column id="avg_order_value" title="Avg Order Value" fmt="$#,##0.00"/>
            <Column id="net_revenue"     title="Net Revenue"     fmt="$#,##0.00"/>
            <Column id="net_margin_pct"  title="Margin"          fmt="0.0\%"/>
            <Column id="first_date"      title="Since"/>
            <Column id="last_date"       title="Last Data"/>
        </DataTable>
      </div>
    </details>
  </div>

</div>

{:else}

<!-- ════════════════════════════════════════════════
     SINGLE BRANCH VIEW
════════════════════════════════════════════════ -->

```sql branch_scorecard
WITH b AS (SELECT '{inputs.branch}' AS branch_name),
max_d AS (SELECT MAX(order_date) AS d FROM restaurant_en.daily_revenue),
max_nr AS (SELECT MAX(metric_date) AS d FROM restaurant_en.daily_net_revenue),
rev AS (
    SELECT
        SUM(CASE WHEN order_date = (SELECT d FROM max_d) THEN total_revenue END)                   AS rev_yesterday,
        SUM(CASE WHEN order_date >= (SELECT d FROM max_d) - INTERVAL '6 days' THEN total_revenue END)  AS rev_7d,
        SUM(CASE WHEN order_date >= (SELECT d FROM max_d) - INTERVAL '29 days' THEN total_revenue END) AS rev_30d,
        SUM(CASE WHEN order_date >= (SELECT d FROM max_d) - INTERVAL '89 days' THEN total_revenue END) AS rev_90d,
        SUM(CASE WHEN order_date >= (SELECT d FROM max_d) - INTERVAL '13 days' AND order_date < (SELECT d FROM max_d) - INTERVAL '6 days' THEN total_revenue END) AS rev_prev7d,
        SUM(CASE WHEN order_date >= (SELECT d FROM max_d) - INTERVAL '59 days' AND order_date < (SELECT d FROM max_d) - INTERVAL '29 days' THEN total_revenue END) AS rev_prev30d,
        SUM(CASE WHEN order_date >= (SELECT d FROM max_d) - INTERVAL '179 days' AND order_date < (SELECT d FROM max_d) - INTERVAL '89 days' THEN total_revenue END) AS rev_prev90d
    FROM restaurant_en.daily_revenue
    WHERE branch_name = (SELECT branch_name FROM b)
),
ord AS (
    SELECT
        SUM(CASE WHEN order_date = (SELECT d FROM max_d) THEN total_orders END)                   AS ord_yesterday,
        SUM(CASE WHEN order_date >= (SELECT d FROM max_d) - INTERVAL '6 days' THEN total_orders END)  AS ord_7d,
        SUM(CASE WHEN order_date >= (SELECT d FROM max_d) - INTERVAL '29 days' THEN total_orders END) AS ord_30d,
        SUM(CASE WHEN order_date >= (SELECT d FROM max_d) - INTERVAL '89 days' THEN total_orders END) AS ord_90d
    FROM restaurant_en.daily_revenue
    WHERE branch_name = (SELECT branch_name FROM b)
),
net AS (
    SELECT
        SUM(CASE WHEN metric_date = (SELECT d FROM max_nr) THEN net_revenue END)                   AS net_yesterday,
        SUM(CASE WHEN metric_date >= (SELECT d FROM max_nr) - INTERVAL '6 days' THEN net_revenue END)  AS net_7d,
        SUM(CASE WHEN metric_date >= (SELECT d FROM max_nr) - INTERVAL '29 days' THEN net_revenue END) AS net_30d,
        SUM(CASE WHEN metric_date >= (SELECT d FROM max_nr) - INTERVAL '89 days' THEN net_revenue END) AS net_90d,
        SUM(CASE WHEN metric_date = (SELECT d FROM max_nr) THEN gross_revenue END)                  AS gross_yesterday,
        SUM(CASE WHEN metric_date >= (SELECT d FROM max_nr) - INTERVAL '6 days' THEN gross_revenue END)  AS gross_7d,
        SUM(CASE WHEN metric_date >= (SELECT d FROM max_nr) - INTERVAL '29 days' THEN gross_revenue END) AS gross_30d,
        SUM(CASE WHEN metric_date >= (SELECT d FROM max_nr) - INTERVAL '89 days' THEN gross_revenue END) AS gross_90d,
        SUM(CASE WHEN metric_date >= (SELECT d FROM max_nr) - INTERVAL '13 days' AND metric_date < (SELECT d FROM max_nr) - INTERVAL '6 days' THEN net_revenue END) AS net_prev7d,
        SUM(CASE WHEN metric_date >= (SELECT d FROM max_nr) - INTERVAL '13 days' AND metric_date < (SELECT d FROM max_nr) - INTERVAL '6 days' THEN gross_revenue END) AS gross_prev7d,
        SUM(CASE WHEN metric_date >= (SELECT d FROM max_nr) - INTERVAL '59 days' AND metric_date < (SELECT d FROM max_nr) - INTERVAL '29 days' THEN net_revenue END) AS net_prev30d,
        SUM(CASE WHEN metric_date >= (SELECT d FROM max_nr) - INTERVAL '59 days' AND metric_date < (SELECT d FROM max_nr) - INTERVAL '29 days' THEN gross_revenue END) AS gross_prev30d,
        SUM(CASE WHEN metric_date >= (SELECT d FROM max_nr) - INTERVAL '179 days' AND metric_date < (SELECT d FROM max_nr) - INTERVAL '89 days' THEN net_revenue END) AS net_prev90d,
        SUM(CASE WHEN metric_date >= (SELECT d FROM max_nr) - INTERVAL '179 days' AND metric_date < (SELECT d FROM max_nr) - INTERVAL '89 days' THEN gross_revenue END) AS gross_prev90d
    FROM restaurant_en.daily_net_revenue
    WHERE branch_name = (SELECT branch_name FROM b)
)
SELECT
    rev_yesterday, rev_7d, rev_30d, rev_90d,
    ROUND((rev_7d  - rev_prev7d)  / NULLIF(rev_prev7d,  0) * 100, 1) AS rev_pct_7d,
    ROUND((rev_30d - rev_prev30d) / NULLIF(rev_prev30d, 0) * 100, 1) AS rev_pct_30d,
    ROUND((rev_90d - rev_prev90d) / NULLIF(rev_prev90d, 0) * 100, 1) AS rev_pct_90d,
    ord_yesterday, ord_7d, ord_30d, ord_90d,
    ROUND(rev_yesterday / NULLIF(ord_yesterday, 0), 2)                AS aov_yesterday,
    ROUND(rev_7d        / NULLIF(ord_7d,        0), 2)                AS aov_7d,
    ROUND(rev_30d       / NULLIF(ord_30d,       0), 2)                AS aov_30d,
    ROUND(rev_90d       / NULLIF(ord_90d,       0), 2)                AS aov_90d,
    net_yesterday, net_7d, net_30d, net_90d,
    ROUND(net_yesterday / NULLIF(gross_yesterday, 0) * 100, 1)        AS margin_yesterday,
    ROUND(net_7d        / NULLIF(gross_7d,        0) * 100, 1)        AS margin_7d,
    ROUND(net_30d       / NULLIF(gross_30d,       0) * 100, 1)        AS margin_30d,
    ROUND(net_90d       / NULLIF(gross_90d,       0) * 100, 1)        AS margin_90d,
    ROUND(net_prev7d    / NULLIF(gross_prev7d,    0) * 100, 1)        AS margin_prev7d,
    ROUND(net_prev30d   / NULLIF(gross_prev30d,   0) * 100, 1)        AS margin_prev30d,
    ROUND(net_prev90d   / NULLIF(gross_prev90d,   0) * 100, 1)        AS margin_prev90d
FROM rev, ord, net
```

```sql branch_cost_periods
WITH max_d AS (SELECT MAX(metric_date) AS d FROM restaurant_en.daily_net_revenue)
SELECT
    SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN inventory_usage_cost END) AS ingr_30d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN labor_total_cost END)     AS labor_30d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN operational_total_cost END) AS overhead_30d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN gross_revenue END)         AS gross_30d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN inventory_usage_cost END) AS ingr_90d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN labor_total_cost END)     AS labor_90d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN operational_total_cost END) AS overhead_90d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN gross_revenue END)         AS gross_90d
FROM restaurant_en.daily_net_revenue CROSS JOIN max_d
WHERE branch_name = '{inputs.branch}'
```

```sql branch_daily_trend
SELECT order_date, total_revenue, ROUND(revenue_sdow_avg, 2) AS revenue_sdow_avg,
    ROUND(pct_change_vs_sdow_avg * 100, 1) AS pct_vs_sdow
FROM restaurant_en.daily_revenue
WHERE branch_name = '{inputs.branch}'
  AND order_date >= (SELECT MAX(order_date) FROM restaurant_en.daily_revenue) - INTERVAL '89 days'
ORDER BY order_date
```

```sql branch_net_trend
SELECT metric_date, net_revenue, gross_revenue,
    ROUND(net_revenue / NULLIF(gross_revenue, 0) * 100, 1) AS margin_pct
FROM restaurant_en.daily_net_revenue
WHERE branch_name = '{inputs.branch}'
  AND metric_date >= (SELECT MAX(metric_date) FROM restaurant_en.daily_net_revenue) - INTERVAL '89 days'
ORDER BY metric_date
```

```sql branch_cost_trend
SELECT metric_date, inventory_usage_cost, labor_total_cost, operational_total_cost
FROM restaurant_en.daily_net_revenue
WHERE branch_name = '{inputs.branch}'
  AND metric_date >= (SELECT MAX(metric_date) FROM restaurant_en.daily_net_revenue) - INTERVAL '89 days'
ORDER BY metric_date
```

```sql branch_order_type
SELECT
    order_date,
    SUM(delivery_orders)  AS delivery,
    SUM(dine_in_orders)   AS dine_in,
    SUM(takeaway_orders)  AS takeaway
FROM restaurant_en.daily_revenue
WHERE branch_name = '{inputs.branch}'
  AND order_date >= (SELECT MAX(order_date) FROM restaurant_en.daily_revenue) - INTERVAL '29 days'
GROUP BY order_date
ORDER BY order_date
```

<div class="branch-page">

  <!-- ── Hero ── -->
  <div class="hero">
    <div>
      <div class="hero-eyebrow">🏪 Branch Deep Dive · {inputs.branch}</div>
      {#if branch_scorecard[0].margin_30d >= 15 && branch_scorecard[0].rev_pct_30d >= 0}
        <h2 class="hero-title">{inputs.branch} is operating in a healthy state — margin and revenue both trending positive. ✅</h2>
      {:else if branch_scorecard[0].margin_30d >= 15}
        <h2 class="hero-title">{inputs.branch} margin is healthy at {branch_scorecard[0].margin_30d}%, though revenue momentum has softened. ⚠️</h2>
      {:else if branch_scorecard[0].margin_30d >= 10}
        <h2 class="hero-title">{inputs.branch} has entered the watch zone — margin at {branch_scorecard[0].margin_30d}%, below the 15% target. ⚠️</h2>
      {:else}
        <h2 class="hero-title">{inputs.branch} requires immediate action — margin at {branch_scorecard[0].margin_30d}%, critically below 10%. 🚨</h2>
      {/if}
      <p class="hero-copy">
        {#if branch_scorecard[0].margin_30d >= 15 && branch_scorecard[0].rev_pct_30d >= 0}
          Revenue is up {branch_scorecard[0].rev_pct_30d}% vs the prior 30-day period and margin is holding above target. The main task here is sustaining cost discipline so this performance doesn't erode as volume grows.
        {:else if branch_scorecard[0].margin_30d >= 15}
          Despite revenue softening {Math.abs(branch_scorecard[0].rev_pct_30d)}%, the cost structure at this location is efficient enough to maintain healthy margins. Watch whether volume decline continues — a further drop would eventually pull margin below target even with good cost control.
        {:else if branch_scorecard[0].margin_30d >= 10}
          The gap between this location's margin ({branch_scorecard[0].margin_30d}%) and the 15% target is around {(15 - branch_scorecard[0].margin_30d).toFixed(1)}pp. The cost breakdown below will show which component is creating the most pressure.
        {:else}
          At {branch_scorecard[0].margin_30d}% margin, every dollar of revenue is being consumed by costs before meaningful profit can accumulate. This requires a structural review — not just operational adjustments.
        {/if}
      </p>
    </div>
    <div class="hero-side">
      <div class="hero-side-card">
        <div class="hero-side-label">📊 30-Day Revenue</div>
        <div class="hero-side-value">${branch_scorecard[0].rev_30d?.toLocaleString('en-US', {minimumFractionDigits:0, maximumFractionDigits:0})}</div>
        <div class="hero-side-note">
          {#if branch_scorecard[0].rev_pct_30d !== null}
            {branch_scorecard[0].rev_pct_30d >= 0 ? '▲' : '▼'} {Math.abs(branch_scorecard[0].rev_pct_30d)}% vs prior 30-day period.
          {/if}
          Avg order: ${branch_scorecard[0].aov_30d}
        </div>
      </div>
      <div class="hero-side-card">
        <div class="hero-side-label">📈 30-Day Net Margin</div>
        <div class="hero-side-value" style="color:{branch_scorecard[0].margin_30d >= 15 ? '#16a34a' : branch_scorecard[0].margin_30d >= 10 ? '#ca8a04' : '#dc2626'};">{branch_scorecard[0].margin_30d}%</div>
        <div class="hero-side-note">
          {#if branch_scorecard[0].margin_prev30d !== null}
            {branch_scorecard[0].margin_30d >= branch_scorecard[0].margin_prev30d ? '▲ Up' : '▼ Down'} {Math.abs(branch_scorecard[0].margin_30d - branch_scorecard[0].margin_prev30d).toFixed(1)}pp vs prior period.
          {/if}
        </div>
      </div>
    </div>
  </div>

  <!-- ── KPI Grid ── -->
  <div class="kpi-grid">
    <div class="kpi-card revenue">
      <div class="kpi-label">💵 Gross · 30 Days</div>
      <div class="kpi-value">${branch_scorecard[0].rev_30d?.toLocaleString('en-US', {minimumFractionDigits:0, maximumFractionDigits:0})}</div>
      <div class="kpi-meta">
        7d: ${branch_scorecard[0].rev_7d?.toLocaleString('en-US', {minimumFractionDigits:0, maximumFractionDigits:0})} ·
        90d: ${branch_scorecard[0].rev_90d?.toLocaleString('en-US', {minimumFractionDigits:0, maximumFractionDigits:0})}
      </div>
    </div>
    <div class="kpi-card net">
      <div class="kpi-label">💰 Net Revenue · 30 Days</div>
      <div class="kpi-value">${branch_scorecard[0].net_30d?.toLocaleString('en-US', {minimumFractionDigits:0, maximumFractionDigits:0})}</div>
      <div class="kpi-meta">90d: ${branch_scorecard[0].net_90d?.toLocaleString('en-US', {minimumFractionDigits:0, maximumFractionDigits:0})}</div>
    </div>
    <div class="kpi-card margin">
      <div class="kpi-label">📈 Net Margin</div>
      <div class="kpi-value" style="color:{branch_scorecard[0].margin_30d >= 15 ? '#16a34a' : branch_scorecard[0].margin_30d >= 10 ? '#ca8a04' : '#dc2626'};">
        {branch_scorecard[0].margin_30d}%
      </div>
      <div class="kpi-meta">7d: {branch_scorecard[0].margin_7d}% · 90d: {branch_scorecard[0].margin_90d}%</div>
    </div>
    <div class="kpi-card orders">
      <div class="kpi-label">🛒 Orders · 30 Days</div>
      <div class="kpi-value">{branch_scorecard[0].ord_30d?.toLocaleString()}</div>
      <div class="kpi-meta">Avg order value: ${branch_scorecard[0].aov_30d}</div>
    </div>
  </div>

  <!-- ── Signal cards ── -->
  <div class="signal-grid">
    <div class="signal-card {branch_scorecard[0].margin_30d >= 15 ? 'safe' : branch_scorecard[0].margin_30d >= 10 ? 'warn' : 'critical'}">
      <div class="signal-label">
        {branch_scorecard[0].margin_30d >= 15 ? '✅' : branch_scorecard[0].margin_30d >= 10 ? '⚠️' : '🚨'} Margin signal — 30 days
      </div>
      <div class="signal-title">
        {#if branch_scorecard[0].margin_30d >= 15 && branch_scorecard[0].margin_30d >= branch_scorecard[0].margin_prev30d}
          Healthy margin and improving vs prior period.
        {:else if branch_scorecard[0].margin_30d >= 15}
          Margin healthy, but efficiency is softening slightly.
        {:else if branch_scorecard[0].margin_30d >= 10}
          Revenue is keeping this location out of critical — barely.
        {:else}
          Cost structure is consuming revenue faster than it can accumulate.
        {/if}
      </div>
      <div class="signal-copy">
        {#if branch_scorecard[0].margin_30d >= 15 && branch_scorecard[0].margin_30d >= branch_scorecard[0].margin_prev30d}
          Not only is the result healthy — the direction is right. The task now is maintaining cost discipline as the location scales.
        {:else if branch_scorecard[0].margin_30d >= 15}
          A {Math.abs(branch_scorecard[0].margin_30d - (branch_scorecard[0].margin_prev30d ?? branch_scorecard[0].margin_30d)).toFixed(1)}pp softening from the prior period doesn't yet require alarm, but it warrants watching which cost line is growing faster than revenue.
        {:else}
          With margin already in the watch zone at 30 days, this isn't a noise-level variation. The evidence below points to which cost component is most responsible.
        {/if}
      </div>
    </div>
    <div class="signal-card {branch_scorecard[0].rev_pct_30d >= 0 ? 'safe' : branch_scorecard[0].rev_pct_30d >= -10 ? 'warn' : 'critical'}">
      <div class="signal-label">
        {branch_scorecard[0].rev_pct_30d >= 0 ? '📈' : '📉'} Revenue momentum — 30 vs prior 30
      </div>
      <div class="signal-title">
        {#if branch_scorecard[0].rev_pct_30d >= 5}
          Revenue growing solidly — {branch_scorecard[0].rev_pct_30d}% above prior period.
        {:else if branch_scorecard[0].rev_pct_30d >= 0}
          Revenue stable — marginal growth of {branch_scorecard[0].rev_pct_30d}%.
        {:else if branch_scorecard[0].rev_pct_30d >= -10}
          Revenue down {Math.abs(branch_scorecard[0].rev_pct_30d)}% — watch if trend continues.
        {:else}
          Revenue declined {Math.abs(branch_scorecard[0].rev_pct_30d)}% — significant drop vs prior period.
        {/if}
      </div>
      <div class="signal-copy">
        {#if branch_scorecard[0].rev_pct_30d >= 0}
          Positive revenue momentum means the cost pressure (if any) needs to be solved on the efficiency side — not by reducing output. The trend chart below shows whether this growth is consistent or driven by a few strong days.
        {:else}
          Revenue decline paired with fixed or growing costs is a double-compression on margin. Check the daily trend to see if the drop is concentrated (specific days/weeks) or broadly distributed across the full 30 days.
        {/if}
      </div>
    </div>
  </div>

  <!-- ── Cost breakdown ── -->
  <div class="section-card">
    <div class="section-head">
      <div>
        <div class="section-eyebrow">💸 Cost Breakdown</div>
        <h3 class="section-title">Which cost component is compressing margin the most?</h3>
        <p class="section-copy">Per $100 of gross revenue at {inputs.branch} — how much is consumed by ingredients, labor, and overhead in the last 30 and 90 days.</p>
      </div>
    </div>
    <div class="cost-grid">
      <div class="cost-card">
        <div class="cost-label">🥩 Ingredients</div>
        <div class="cost-value" style="color:{branch_cost_periods[0].ingr_30d / branch_cost_periods[0].gross_30d * 100 <= 32 ? '#16a34a' : '#dc2626'};">
          {(branch_cost_periods[0].ingr_30d / branch_cost_periods[0].gross_30d * 100).toFixed(1)}%
        </div>
        <div class="cost-target">🎯 Target max 32%</div>
        <div class="progress-track">
          <div class="progress-fill" style="width:{Math.min(branch_cost_periods[0].ingr_30d / branch_cost_periods[0].gross_30d * 100 / 40 * 100, 100)}%; background:{branch_cost_periods[0].ingr_30d / branch_cost_periods[0].gross_30d * 100 > 32 ? 'linear-gradient(90deg,#ef4444,#fca5a5)' : 'linear-gradient(90deg,#16a34a,#86efac)'};"></div>
          <div class="progress-target" style="left:{32 / 40 * 100}%;"></div>
        </div>
        <div class="progress-scale"><span>0%</span><span>32%</span><span>40%</span></div>
        <div class="cost-note">90-day rate: {(branch_cost_periods[0].ingr_90d / branch_cost_periods[0].gross_90d * 100).toFixed(1)}%</div>
      </div>
      <div class="cost-card">
        <div class="cost-label">👨‍💼 Labor</div>
        <div class="cost-value" style="color:{branch_cost_periods[0].labor_30d / branch_cost_periods[0].gross_30d * 100 <= 30 ? '#16a34a' : '#f59e0b'};">
          {(branch_cost_periods[0].labor_30d / branch_cost_periods[0].gross_30d * 100).toFixed(1)}%
        </div>
        <div class="cost-target">🎯 Target max 30%</div>
        <div class="progress-track">
          <div class="progress-fill" style="width:{Math.min(branch_cost_periods[0].labor_30d / branch_cost_periods[0].gross_30d * 100 / 40 * 100, 100)}%; background:{branch_cost_periods[0].labor_30d / branch_cost_periods[0].gross_30d * 100 > 30 ? 'linear-gradient(90deg,#f59e0b,#fde68a)' : 'linear-gradient(90deg,#16a34a,#86efac)'};"></div>
          <div class="progress-target" style="left:{30 / 40 * 100}%;"></div>
        </div>
        <div class="progress-scale"><span>0%</span><span>30%</span><span>40%</span></div>
        <div class="cost-note">90-day rate: {(branch_cost_periods[0].labor_90d / branch_cost_periods[0].gross_90d * 100).toFixed(1)}%</div>
      </div>
      <div class="cost-card">
        <div class="cost-label">🏢 Overhead</div>
        <div class="cost-value" style="color:{branch_cost_periods[0].overhead_30d / branch_cost_periods[0].gross_30d * 100 <= 15 ? '#16a34a' : '#dc2626'};">
          {(branch_cost_periods[0].overhead_30d / branch_cost_periods[0].gross_30d * 100).toFixed(1)}%
        </div>
        <div class="cost-target">🎯 Target max 15%</div>
        <div class="progress-track">
          <div class="progress-fill" style="width:{Math.min(branch_cost_periods[0].overhead_30d / branch_cost_periods[0].gross_30d * 100 / 25 * 100, 100)}%; background:{branch_cost_periods[0].overhead_30d / branch_cost_periods[0].gross_30d * 100 > 15 ? 'linear-gradient(90deg,#ef4444,#fca5a5)' : 'linear-gradient(90deg,#16a34a,#86efac)'};"></div>
          <div class="progress-target" style="left:{15 / 25 * 100}%;"></div>
        </div>
        <div class="progress-scale"><span>0%</span><span>15%</span><span>25%</span></div>
        <div class="cost-note">90-day rate: {(branch_cost_periods[0].overhead_90d / branch_cost_periods[0].gross_90d * 100).toFixed(1)}%</div>
      </div>
    </div>
    <details style="margin-top:14px;">
      <summary>🔧 Recommended actions based on this cost profile</summary>
      <div class="acc-body">
        {#if branch_cost_periods[0].ingr_30d / branch_cost_periods[0].gross_30d * 100 > 32}
          <p><strong>🥩 Ingredients above target.</strong> Review which menu items are highest in COGS, check for waste patterns, and assess whether supplier pricing has changed. High ingredient costs are often solvable through portioning, purchasing consolidation, or menu mix adjustment.</p>
        {/if}
        {#if branch_cost_periods[0].labor_30d / branch_cost_periods[0].gross_30d * 100 > 30}
          <p><strong>👨‍💼 Labor above target.</strong> Look at shift scheduling relative to transaction density. If labor is high during low-traffic periods, there may be optimization potential without affecting service quality during peak hours.</p>
        {/if}
        {#if branch_cost_periods[0].overhead_30d / branch_cost_periods[0].gross_30d * 100 > 15}
          <p><strong>🏢 Overhead above target.</strong> Overhead often includes fixed costs (rent, utilities) that don't scale with volume. This means the path to fixing overhead ratio is usually growing revenue, not cutting costs — unless there are discretionary line items that can be trimmed.</p>
        {/if}
        {#if branch_cost_periods[0].ingr_30d / branch_cost_periods[0].gross_30d * 100 <= 32 && branch_cost_periods[0].labor_30d / branch_cost_periods[0].gross_30d * 100 <= 30 && branch_cost_periods[0].overhead_30d / branch_cost_periods[0].gross_30d * 100 <= 15}
          ✅ All three cost categories are within benchmarks. If margin is still below target, the issue is likely in revenue mix (discounting, low-margin items) rather than operational costs. Review the order type breakdown and average order value trends.
        {/if}
      </div>
    </details>
  </div>

  <!-- ── Revenue trend section ── -->
  <div class="section-card">
    <div class="section-head tight">
      <div>
        <div class="section-eyebrow">📈 Revenue Trend — 90 Days</div>
        <h3 class="section-title">Is {inputs.branch} consistently outperforming or underperforming its baseline?</h3>
        <p class="section-copy">The baseline is this location's own rolling same-day-of-week average — Monday vs Mondays, Saturday vs Saturdays. When actual revenue consistently trails it, the location has a structural demand issue, not just bad luck on specific days.</p>
      </div>
    </div>
    <LineChart
        data={branch_daily_trend}
        x="order_date"
        y={["total_revenue", "revenue_sdow_avg"]}
        title="Daily Revenue vs Same-Day-of-Week Average ($)"
        yFmt="$#,##0"
        xAxisTitle="Date"
        yAxisTitle="Revenue ($)"
    />
    <div class="chart-insight">
      📌 <strong>Reading the gap:</strong> When the actual line (solid) is consistently below the baseline (dashed) for more than 2–3 consecutive weeks, that's a structural signal — not noise. When it's above, the location is outperforming its own history. Sudden single-day drops are operational (staffing, closures). Gradual widening gaps are market signals.
    </div>
  </div>

  <!-- ── Margin trend section ── -->
  <div class="section-card">
    <div class="section-head tight">
      <div>
        <div class="section-eyebrow">📉 Net Margin Trend — 90 Days</div>
        <h3 class="section-title">Is margin recovering, stable, or gradually eroding?</h3>
        <p class="section-copy">Daily margin volatility is normal. What matters is the directional trend over weeks. A margin that's been declining slowly for 60+ days is a structural story, not a one-period blip.</p>
      </div>
    </div>
    <LineChart
        data={branch_net_trend}
        x="metric_date"
        y="margin_pct"
        title="Net Margin % — Daily (90 Days)"
        yFmt="0.0\%"
        xAxisTitle="Date"
        yAxisTitle="Net Margin (%)"
    >
      <ReferenceLine y={15} label="15% Target" lineType="dashed" color="green" />
      <ReferenceLine y={10} label="10% Critical" lineType="dashed" color="red" />
    </LineChart>
    <div class="chart-insight">
      📌 <strong>What the reference lines mean:</strong> Days below the green line (15%) are normal in most restaurants — what matters is the proportion. If more than half the days in 90 days are below 15%, cost structure is working against margin systematically. Days below the red line (10%) should be rare — if they cluster in one period, that period needs investigation.
    </div>
  </div>

  <!-- ══════════════════════════════════════════
       STRATEGIC ACCORDIONS
  ══════════════════════════════════════════ -->
  <div class="strategic-stack">
    <div class="strategic-header">
      <div class="strategic-eyebrow">🔭 Supporting Evidence</div>
      <h2 class="strategic-title">Expand for deeper operational detail</h2>
      <p class="strategic-copy">Cost daily breakdown and order type mix — use these when the summary-level signals point to a specific problem and you need granular confirmation.</p>
    </div>

    <details class="acc-strategic">
      <summary>💸 Daily Cost Breakdown — 90 Days</summary>
      <div class="acc-body">
        <p class="section-copy" style="margin-bottom:14px;">
          This chart shows how ingredient, labor, and overhead costs have stacked day by day. When a particular cost type grows taller in one period, it indicates that category outpaced revenue during those days — a useful signal for pinpointing when a cost spike began.
        </p>
        <BarChart
            data={branch_cost_trend}
            x="metric_date"
            y={["inventory_usage_cost", "labor_total_cost", "operational_total_cost"]}
            type="stacked"
            title="Daily Cost Breakdown ($) — 90 Days"
            yFmt="$#,##0"
            xAxisTitle="Date"
            yAxisTitle="Cost ($)"
        />
        <div class="chart-insight" style="margin-top:12px;">
          📌 Look for periods where the total bar height grows without a corresponding revenue increase — that's when costs started compressing margin. Cross-reference with the revenue trend chart above for the same date range.
        </div>
      </div>
    </details>

    <details class="acc-strategic">
      <summary>🛵 Order Type Mix — Last 30 Days</summary>
      <div class="acc-body">
        <p class="section-copy" style="margin-bottom:14px;">
          Order type mix affects both revenue and cost structure. Delivery orders typically carry higher revenue per transaction but also higher overhead (platform fees, packaging). A shift in mix — more delivery, less dine-in — can quietly erode margins even when total order count stays flat.
        </p>
        <BarChart
            data={branch_order_type}
            x="order_date"
            y={["dine_in", "delivery", "takeaway"]}
            type="stacked"
            title="Daily Orders by Type — Last 30 Days"
            xAxisTitle="Date"
            yAxisTitle="Orders"
        />
        <div class="chart-insight" style="margin-top:12px;">
          📌 If delivery is growing as a share of orders while margin is declining, the delivery platform cost may be outweighing the AOV advantage. Compare the dine-in vs delivery contribution to understand the true margin per channel.
        </div>
      </div>
    </details>
  </div>

</div>

{/if}