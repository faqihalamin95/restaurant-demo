---
title: Laporan Keuangan
---

<style>
.over-container {
  display: none !important;
}

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

details > summary::-webkit-details-marker {
  display: none;
}

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

details.acc-strategic[open] > summary::after {
  transform: rotate(90deg);
}

details.acc-strategic[open] > summary {
  border-bottom: 1.5px solid rgba(99,102,241,0.14);
}

details.acc-strategic .acc-body {
  padding: 20px;
}

/* ── Page layout ── */
.finance-page {
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

.period-pill.sehat {
  border-color: rgba(22, 163, 74, 0.28);
  background: linear-gradient(135deg, rgba(22,163,74,0.09) 0%, rgba(16,185,129,0.05) 100%);
}

.period-pill.waspada {
  border-color: rgba(245, 158, 11, 0.32);
  background: linear-gradient(135deg, rgba(245,158,11,0.1) 0%, rgba(251,191,36,0.05) 100%);
}

.period-pill.kritis {
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

.pill-badge.sehat { background: rgba(22,163,74,0.15); color: #15803d; }
.pill-badge.waspada { background: rgba(245,158,11,0.18); color: #b45309; }
.pill-badge.kritis { background: rgba(239,68,68,0.15); color: #b91c1c; }

.period-pill-copy {
  margin-top: 4px;
  font-size: 0.82rem;
  line-height: 1.55;
  color: var(--color-text-secondary);
}

/* ── Hero ── */
.hero {
  display: flex;
  flex-direction: column;
  gap: 16px;
  padding: 24px;
  border-radius: 22px;
  border: 1px solid rgba(37, 99, 235, 0.12);
  background:
    radial-gradient(circle at top right, rgba(69, 161, 191, 0.18), transparent 35%),
    radial-gradient(circle at bottom left, rgba(99,102,241,0.08), transparent 40%),
    linear-gradient(135deg, rgba(37, 99, 235, 0.06), rgba(194, 65, 12, 0.04)),
    var(--color-background-secondary);
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.02), 0 1px 3px rgba(0, 0, 0, 0.01);
}

.hero-grid {
  display: grid;
  grid-template-columns: minmax(0, 1.7fr) minmax(280px, 1fr);
  gap: 18px;
}

.hero-eyebrow {
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 0.13em;
  text-transform: uppercase;
  color: var(--color-text-tertiary);
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

.hero-main-card {
  padding: 24px;
  border-radius: 16px;
  border: 1.5px solid transparent;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  text-align: center;
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.03), 0 1px 3px rgba(0, 0, 0, 0.02);
}

.hero-main-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.05), 0 2px 5px rgba(0, 0, 0, 0.03);
}

.hero-main-card.status-sehat {
  background: rgba(22, 163, 74, 0.08);
  border-color: rgba(22, 163, 74, 0.22);
}

.hero-main-card.status-waspada {
  background: rgba(245, 158, 11, 0.09);
  border-color: rgba(245, 158, 11, 0.24);
}

.hero-main-card.status-kritis {
  background: rgba(220, 38, 38, 0.08);
  border-color: rgba(239, 68, 68, 0.22);
}

.hero-stat-number {
  font-size: 3.8rem;
  font-weight: 900;
  letter-spacing: -0.04em;
  line-height: 1;
  margin-top: 8px;
  margin-bottom: 12px;
}

.hero-main-card.status-sehat .hero-stat-number {
  color: #15803d;
}

.hero-main-card.status-waspada .hero-stat-number {
  color: #b45309;
}

.hero-main-card.status-kritis .hero-stat-number {
  color: #b91c1c;
}

.hero-subtitle {
  font-size: 1.15rem;
  font-weight: 700;
  letter-spacing: -0.02em;
  color: var(--color-text-primary);
  margin-bottom: 0;
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
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.02), 0 1px 2px rgba(0, 0, 0, 0.01);
}

.hero-side-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.04), 0 2px 4px rgba(0, 0, 0, 0.02);
  background: rgba(255, 255, 255, 0.9);
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
  padding: 18px 16px;
  border-radius: 18px;
  border: 1.5px solid var(--color-border-tertiary);
  background: var(--color-background-secondary);
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.02), 0 1px 3px rgba(0, 0, 0, 0.01);
  position: relative;
  overflow: hidden;
  transition: all 0.22s ease;
}

.kpi-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.04), 0 2px 4px rgba(0, 0, 0, 0.02);
}

.trend-indicator {
  font-size: 0.82rem;
  font-weight: 700;
  display: inline-flex;
  align-items: center;
  gap: 3px;
}

.trend-indicator.up {
  color: #16a34a;
}

.trend-indicator.down {
  color: #dc2626;
}

.trend-indicator.neutral {
  color: var(--color-text-tertiary);
}

.kpi-prev {
  margin-top: 6px;
  font-size: 0.78rem;
  color: var(--color-text-secondary);
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

.kpi-card.cost {
  border-color: rgba(239,68,68,0.18);
  background: linear-gradient(145deg, rgba(239,68,68,0.06), rgba(220,38,38,0.02));
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
  font-size: 1.15rem;
  font-weight: 800;
  letter-spacing: -0.03em;
  color: var(--color-text-primary);
}

.kpi-meta {
  margin-top: 6px;
  font-size: 0.82rem;
  line-height: 1;
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

.section-head.tight {
  margin-bottom: 10px;
}

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
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
}

.signal-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.04), 0 2px 4px rgba(0, 0, 0, 0.02);
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
  line-height: 1.4;
  color: var(--color-text-secondary);
  display: flex;
  flex-direction: column;
  gap: 2px;
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

/* ── Chart insight box ── */
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

.chart-insight strong {
  color: var(--color-text-primary);
}

/* ── Inline link ── */
.inline-link {
  color: var(--color-primary);
  text-decoration: none;
}

.inline-link:hover {
  text-decoration: underline;
}

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

  .hero-title {
    font-size: 1.6rem;
  }

  .kpi-value {
    font-size: 1.05rem;
  }
  .cost-value {
    font-size: 1.5rem;
  }
}

/* ── Combined Accordion Layout ── */
.acc-grid {
  display: grid;
  grid-template-columns: 1fr 1.2fr;
  gap: 20px;
  width: 100%;
}

.acc-title-sub {
  font-weight: 800;
  font-size: 0.92rem;
  color: var(--color-text-primary);
  margin-bottom: 8px;
  display: flex;
  align-items: center;
  gap: 6px;
}

.acc-text-block {
  background: var(--color-background-primary);
  border-radius: 12px;
  padding: 14px;
  border: 1px solid var(--color-border-tertiary);
  font-size: 0.85rem;
  color: var(--color-text-secondary);
  line-height: 1.6;
}

.acc-alert-list {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.acc-alert-item {
  padding: 12px;
  border-radius: 10px;
  background: rgba(239, 68, 68, 0.05);
  border-left: 4px solid #dc2626;
  font-size: 0.85rem;
  color: var(--color-text-secondary);
  line-height: 1.6;
}

.acc-alert-item strong {
  color: var(--color-text-primary);
}

@media (max-width: 768px) {
  .acc-grid {
    grid-template-columns: 1fr;
    gap: 16px;
  }
}

/* ── Diagnostics section wrapper ── */
.diagnostics-stack {
  display: flex;
  flex-direction: column;
  gap: 16px;
  margin-top: 14px;
}

.diagnostics-header {
  padding: 0 2px;
  margin-bottom: 2px;
}

.diagnostics-eyebrow {
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

.diagnostics-title {
  font-size: 1.3rem;
  font-weight: 800;
  letter-spacing: -0.025em;
  color: var(--color-text-primary);
  margin: 0 0 4px;
}

.diagnostics-copy {
  font-size: 0.9rem;
  line-height: 1.7;
  color: var(--color-text-secondary);
  max-width: 68ch;
  margin: 0;
}

.table-scroll-container {
  overflow-x: auto;
  width: 100%;
  -webkit-overflow-scrolling: touch;
  margin: 14px 0;
  border-radius: 8px;
}

.table-scroll-container table {
  width: 100%;
  min-width: 760px;
}

.table-scroll-container th,
.table-scroll-container td {
  white-space: nowrap;
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
    SUM(CASE WHEN metric_date = d THEN gross_revenue ELSE 0 END) AS gross_yesterday,
    SUM(CASE WHEN metric_date = d THEN net_revenue ELSE 0 END) AS net_yesterday,
    ROUND(
        SUM(CASE WHEN metric_date = d THEN net_revenue ELSE 0 END)
        / NULLIF(SUM(CASE WHEN metric_date = d THEN gross_revenue ELSE 0 END), 0) * 100
    , 1) AS margin_yesterday,
    SUM(CASE WHEN metric_date = d THEN inventory_usage_cost + labor_total_cost + operational_total_cost ELSE 0 END) AS biaya_yesterday,
    
    SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN gross_revenue ELSE 0 END) AS gross_30d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN net_revenue ELSE 0 END) AS net_30d,
    ROUND(
        SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN net_revenue ELSE 0 END)
        / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN gross_revenue ELSE 0 END), 0) * 100
    , 1) AS margin_30d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN inventory_usage_cost + labor_total_cost + operational_total_cost ELSE 0 END) AS biaya_30d,
    
    SUM(CASE WHEN metric_date >= d - INTERVAL '59 days' AND metric_date < d - INTERVAL '29 days' THEN gross_revenue ELSE 0 END) AS gross_prev30d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '59 days' AND metric_date < d - INTERVAL '29 days' THEN net_revenue ELSE 0 END) AS net_prev30d,
    ROUND(
        SUM(CASE WHEN metric_date >= d - INTERVAL '59 days' AND metric_date < d - INTERVAL '29 days' THEN net_revenue ELSE 0 END)
        / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '59 days' AND metric_date < d - INTERVAL '29 days' THEN gross_revenue ELSE 0 END), 0) * 100
    , 1) AS margin_prev30d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '59 days' AND metric_date < d - INTERVAL '29 days' THEN inventory_usage_cost + labor_total_cost + operational_total_cost ELSE 0 END) AS biaya_prev30d,
    
    ROUND(
        ROUND(
            SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN net_revenue ELSE 0 END)
            / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN gross_revenue ELSE 0 END), 0) * 100
        , 1)
        -
        ROUND(
            SUM(CASE WHEN metric_date >= d - INTERVAL '59 days' AND metric_date < d - INTERVAL '29 days' THEN net_revenue ELSE 0 END)
            / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '59 days' AND metric_date < d - INTERVAL '29 days' THEN gross_revenue ELSE 0 END), 0) * 100
        , 1)
    , 1) AS delta_margin_30d,
    ROUND(
        (SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN gross_revenue ELSE 0 END)
        - SUM(CASE WHEN metric_date >= d - INTERVAL '59 days' AND metric_date < d - INTERVAL '29 days' THEN gross_revenue ELSE 0 END))
        / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '59 days' AND metric_date < d - INTERVAL '29 days' THEN gross_revenue ELSE 0 END), 0) * 100
    , 1) AS pct_change_gross_30d,
    ROUND(
        (SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN net_revenue ELSE 0 END)
        - SUM(CASE WHEN metric_date >= d - INTERVAL '59 days' AND metric_date < d - INTERVAL '29 days' THEN net_revenue ELSE 0 END))
        / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '59 days' AND metric_date < d - INTERVAL '29 days' THEN net_revenue ELSE 0 END), 0) * 100
    , 1) AS pct_change_net_30d,
    ROUND(
        (SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN inventory_usage_cost + labor_total_cost + operational_total_cost ELSE 0 END)
        - SUM(CASE WHEN metric_date >= d - INTERVAL '59 days' AND metric_date < d - INTERVAL '29 days' THEN inventory_usage_cost + labor_total_cost + operational_total_cost ELSE 0 END))
        / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '59 days' AND metric_date < d - INTERVAL '29 days' THEN inventory_usage_cost + labor_total_cost + operational_total_cost ELSE 0 END), 0) * 100
    , 1) AS pct_change_biaya_30d,
    
    SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN gross_revenue ELSE 0 END) AS gross_90d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN net_revenue ELSE 0 END) AS net_90d,
    ROUND(
        SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN net_revenue ELSE 0 END)
        / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN gross_revenue ELSE 0 END), 0) * 100
    , 1) AS margin_90d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN inventory_usage_cost + labor_total_cost + operational_total_cost ELSE 0 END) AS biaya_90d,
    
    SUM(CASE WHEN metric_date >= d - INTERVAL '179 days' AND metric_date < d - INTERVAL '89 days' THEN gross_revenue ELSE 0 END) AS gross_prev90d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '179 days' AND metric_date < d - INTERVAL '89 days' THEN net_revenue ELSE 0 END) AS net_prev90d,
    ROUND(
        SUM(CASE WHEN metric_date >= d - INTERVAL '179 days' AND metric_date < d - INTERVAL '89 days' THEN net_revenue ELSE 0 END)
        / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '179 days' AND metric_date < d - INTERVAL '89 days' THEN gross_revenue ELSE 0 END), 0) * 100
    , 1) AS margin_prev90d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '179 days' AND metric_date < d - INTERVAL '89 days' THEN inventory_usage_cost + labor_total_cost + operational_total_cost ELSE 0 END) AS biaya_prev90d,
    
    ROUND(
        ROUND(
            SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN net_revenue ELSE 0 END)
            / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN gross_revenue ELSE 0 END), 0) * 100
        , 1)
        -
        ROUND(
            SUM(CASE WHEN metric_date >= d - INTERVAL '179 days' AND metric_date < d - INTERVAL '89 days' THEN net_revenue ELSE 0 END)
            / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '179 days' AND metric_date < d - INTERVAL '89 days' THEN gross_revenue ELSE 0 END), 0) * 100
        , 1)
    , 1) AS delta_margin_90d,
    ROUND(
        (SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN gross_revenue ELSE 0 END)
        - SUM(CASE WHEN metric_date >= d - INTERVAL '179 days' AND metric_date < d - INTERVAL '89 days' THEN gross_revenue ELSE 0 END))
        / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '179 days' AND metric_date < d - INTERVAL '89 days' THEN gross_revenue ELSE 0 END), 0) * 100
    , 1) AS pct_change_gross_90d,
    ROUND(
        (SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN net_revenue ELSE 0 END)
        - SUM(CASE WHEN metric_date >= d - INTERVAL '179 days' AND metric_date < d - INTERVAL '89 days' THEN net_revenue ELSE 0 END))
        / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '179 days' AND metric_date < d - INTERVAL '89 days' THEN net_revenue ELSE 0 END), 0) * 100
    , 1) AS pct_change_net_90d,
    ROUND(
        (SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN inventory_usage_cost + labor_total_cost + operational_total_cost ELSE 0 END)
        - SUM(CASE WHEN metric_date >= d - INTERVAL '179 days' AND metric_date < d - INTERVAL '89 days' THEN inventory_usage_cost + labor_total_cost + operational_total_cost ELSE 0 END))
        / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '179 days' AND metric_date < d - INTERVAL '89 days' THEN inventory_usage_cost + labor_total_cost + operational_total_cost ELSE 0 END), 0) * 100
    , 1) AS pct_change_biaya_90d
FROM restaurant.daily_net_revenue CROSS JOIN max_d
```

```sql fin_cost_pct
WITH max_d AS (SELECT MAX(metric_date)::DATE AS d FROM restaurant.daily_net_revenue),
periods AS (
    SELECT
        d,
        ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN inventory_usage_cost ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS bahan_30d,
        ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN labor_total_cost ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS sdm_30d,
        ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN operational_total_cost ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS ops_30d,
        ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '59 days' AND metric_date < d - INTERVAL '29 days' THEN inventory_usage_cost ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '59 days' AND metric_date < d - INTERVAL '29 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS bahan_p30d,
        ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '59 days' AND metric_date < d - INTERVAL '29 days' THEN labor_total_cost ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '59 days' AND metric_date < d - INTERVAL '29 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS sdm_p30d,
        ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '59 days' AND metric_date < d - INTERVAL '29 days' THEN operational_total_cost ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '59 days' AND metric_date < d - INTERVAL '29 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS ops_p30d,
        ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN inventory_usage_cost ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS bahan_90d,
        ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN labor_total_cost ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS sdm_90d,
        ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN operational_total_cost ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS ops_90d,
        ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '179 days' AND metric_date < d - INTERVAL '89 days' THEN inventory_usage_cost ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '179 days' AND metric_date < d - INTERVAL '89 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS bahan_p90d,
        ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '179 days' AND metric_date < d - INTERVAL '89 days' THEN labor_total_cost ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '179 days' AND metric_date < d - INTERVAL '89 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS sdm_p90d,
        ROUND(SUM(CASE WHEN metric_date >= d - INTERVAL '179 days' AND metric_date < d - INTERVAL '89 days' THEN operational_total_cost ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '179 days' AND metric_date < d - INTERVAL '89 days' THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS ops_p90d
    FROM restaurant.daily_net_revenue CROSS JOIN max_d
    GROUP BY d
)
SELECT
    bahan_30d, sdm_30d, ops_30d,
    bahan_p30d, sdm_p30d, ops_p30d,
    ROUND(bahan_30d - bahan_p30d, 1) AS delta_bahan_30d,
    ROUND(sdm_30d - sdm_p30d, 1) AS delta_sdm_30d,
    ROUND(ops_30d - ops_p30d, 1) AS delta_ops_30d,
    bahan_90d, sdm_90d, ops_90d,
    bahan_p90d, sdm_p90d, ops_p90d,
    ROUND(bahan_90d - bahan_p90d, 1) AS delta_bahan_90d,
    ROUND(sdm_90d - sdm_p90d, 1) AS delta_sdm_90d,
    ROUND(ops_90d - ops_p90d, 1) AS delta_ops_90d
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
FROM restaurant.daily_net_revenue
CROSS JOIN bulan_ini b
CROSS JOIN bulan_lalu l
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

```sql fin_margin_daily_90d
WITH max_d AS (SELECT MAX(metric_date)::DATE AS d FROM restaurant.daily_net_revenue)
SELECT
    metric_date,
    ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS margin_pct
FROM restaurant.daily_net_revenue CROSS JOIN max_d
WHERE metric_date >= d - INTERVAL '89 days'
GROUP BY metric_date
ORDER BY metric_date
```

```sql fin_quarter
SELECT * FROM (
    SELECT
        YEAR(metric_date) AS tahun,
        CEIL(MONTH(metric_date) / 3.0) AS qnum,
        CAST(YEAR(metric_date) AS VARCHAR) || ' Q' || CAST(CAST(CEIL(MONTH(metric_date) / 3.0) AS INTEGER) AS VARCHAR) AS quarter_label,
        YEAR(metric_date) * 10 + CEIL(MONTH(metric_date) / 3.0) AS qsort,
        SUM(gross_revenue) AS gross,
        SUM(net_revenue) AS net,
        ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS margin_pct,
        SUM(inventory_usage_cost + labor_total_cost + operational_total_cost) AS total_biaya,
        ROUND(SUM(inventory_usage_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS bahan_pct,
        ROUND(SUM(labor_total_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS sdm_pct,
        ROUND(SUM(operational_total_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS ops_pct
    FROM restaurant.daily_net_revenue
    GROUP BY 1, 2, 3, 4
    ORDER BY qsort DESC  -- ambil 8 terbaru
    LIMIT 8
) ORDER BY qsort ASC    -- lalu urutkan untuk chart
```

```sql fin_quarter_comparison
WITH fin_quarter AS (
    SELECT
        YEAR(metric_date) AS tahun,
        CEIL(MONTH(metric_date) / 3.0) AS qnum,
        CAST(YEAR(metric_date) AS VARCHAR) || ' Q' || CAST(CAST(CEIL(MONTH(metric_date) / 3.0) AS INTEGER) AS VARCHAR) AS quarter_label,
        YEAR(metric_date) * 10 + CEIL(MONTH(metric_date) / 3.0) AS qsort,
        SUM(gross_revenue) AS gross,
        SUM(net_revenue) AS net,
        ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS margin_pct,
        SUM(inventory_usage_cost + labor_total_cost + operational_total_cost) AS total_biaya,
        ROUND(SUM(inventory_usage_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS bahan_pct,
        ROUND(SUM(labor_total_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS sdm_pct,
        ROUND(SUM(operational_total_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS ops_pct
    FROM restaurant.daily_net_revenue
    GROUP BY 1, 2, 3, 4
)
SELECT
    quarter_label, gross, net, margin_pct, total_biaya, bahan_pct, sdm_pct, ops_pct,
    LAG(net) OVER (ORDER BY qsort) AS net_prev_q,
    LAG(margin_pct) OVER (ORDER BY qsort) AS margin_prev_q,
    ROUND(margin_pct - LAG(margin_pct) OVER (ORDER BY qsort), 1) AS delta_margin_q,
    ROUND((net - LAG(net) OVER (ORDER BY qsort)) / NULLIF(LAG(net) OVER (ORDER BY qsort), 0) * 100, 1) AS pct_change_net_q
FROM fin_quarter
ORDER BY qsort DESC
```

```sql fin_yoy
SELECT
    YEAR(metric_date) AS tahun,
    SUM(gross_revenue) AS gross,
    SUM(net_revenue) AS net,
    ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS margin_pct,
    SUM(inventory_usage_cost + labor_total_cost + operational_total_cost) AS total_biaya,
    ROUND(SUM(inventory_usage_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS bahan_pct,
    ROUND(SUM(labor_total_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS sdm_pct,
    ROUND(SUM(operational_total_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS ops_pct
FROM restaurant.daily_net_revenue
GROUP BY 1
ORDER BY 1 DESC
```

```sql fin_operational_overview
WITH max_d AS (SELECT MAX(metric_date)::DATE AS d FROM restaurant.daily_net_revenue),
mtd AS (
    SELECT
        ROUND(SUM(CASE WHEN metric_date >= DATE_TRUNC('month', d) AND metric_date <= d THEN net_revenue ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= DATE_TRUNC('month', d) AND metric_date <= d THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS margin_mtd,
        ROUND(SUM(CASE WHEN metric_date >= DATE_TRUNC('month', d) AND metric_date <= d THEN inventory_usage_cost ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= DATE_TRUNC('month', d) AND metric_date <= d THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS bahan_mtd,
        ROUND(SUM(CASE WHEN metric_date >= DATE_TRUNC('month', d) AND metric_date <= d THEN labor_total_cost ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= DATE_TRUNC('month', d) AND metric_date <= d THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS sdm_mtd,
        ROUND(SUM(CASE WHEN metric_date >= DATE_TRUNC('month', d) AND metric_date <= d THEN operational_total_cost ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= DATE_TRUNC('month', d) AND metric_date <= d THEN gross_revenue ELSE 0 END), 0) * 100, 1) AS ops_mtd
    FROM restaurant.daily_net_revenue CROSS JOIN max_d
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
    FROM restaurant.daily_net_revenue CROSS JOIN max_d
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
```

_Kesehatan finansial bisnis: margin, tekanan biaya, dan konteks musiman dalam satu halaman._

<ButtonGroup name=period>
  <ButtonGroupItem valueLabel="📅 Bulan Ini" value="mtd" />
  <ButtonGroupItem valueLabel="📊 30 Hari" value="30d" default />
  <ButtonGroupItem valueLabel="🔭 90 Hari" value="90d" />
</ButtonGroup>

{#if fin_operational_overview.length > 0}
<div class="finance-page">




  <!-- ══════════════════════════════════════════
       MTD VIEW
  ══════════════════════════════════════════ -->
  {#if inputs.period === 'mtd'}
    <div class="hero">
      <div class="hero-eyebrow">💰 Laporan Keuangan · Bulan Berjalan</div>
      <div class="hero-grid">
        <div class="hero-main-card {fin_kpi_mtd[0].margin_mtd >= 15 ? 'status-sehat' : fin_kpi_mtd[0].margin_mtd >= 10 ? 'status-waspada' : 'status-kritis'}">
          <div class="hero-stat-number">{fin_kpi_mtd[0].margin_mtd}%</div>
          <div class="hero-subtitle">
            {#if fin_kpi_mtd[0].margin_mtd >= 15}
              Margin masih sehat di bulan {fin_nama_bulan[0].nama_bulan}.
            {:else if fin_kpi_mtd[0].margin_mtd >= 10}
              Margin masuk zona waspada bulan {fin_nama_bulan[0].nama_bulan}.
            {:else}
              Margin sudah kritis di bulan {fin_nama_bulan[0].nama_bulan}.
            {/if}
          </div>
        </div>
        <div class="hero-side">
          <div class="hero-side-card">
            <div class="hero-side-label">📅 Periode Aktif</div>
            <div class="hero-side-value">{fin_nama_bulan[0].nama_bulan} · {fin_kpi_mtd[0].hari_berjalan}/{fin_kpi_mtd[0].total_hari_bulan} hari</div>
            <div class="hero-side-note">Masih ada {fin_kpi_mtd[0].total_hari_bulan - fin_kpi_mtd[0].hari_berjalan} hari tersisa untuk mengubah arah margin bulan ini.</div>
          </div>
          <div class="hero-side-card">
            <div class="hero-side-label">🔮 Proyeksi Pace Saat Ini</div>
            <div class="hero-side-value" style="font-size: 1.15rem; font-weight: 800;">Rp {(fin_kpi_mtd[0].proyeksi_gross / 1000000).toFixed(1)}jt gross</div>
            <div class="hero-side-note" style="margin-bottom: 6px;">Net revenue terproyeksi Rp {(fin_kpi_mtd[0].proyeksi_net / 1000000).toFixed(1)}jt.</div>
            <div class="progress-track" style="margin-bottom: 4px;">
              <div class="progress-fill" style="width:{(fin_kpi_mtd[0].hari_berjalan / fin_kpi_mtd[0].total_hari_bulan * 100).toFixed(1)}%; background: linear-gradient(90deg, #3b82f6, #60a5fa);"></div>
            </div>
            <div class="progress-scale">
              <span>0 hari</span>
              <span>{fin_kpi_mtd[0].hari_berjalan} hari</span>
              <span>{fin_kpi_mtd[0].total_hari_bulan} hari</span>
            </div>
            <div class="hero-side-note" style="margin-top: 6px;">Proyeksi ini linear, cukup untuk baca arah, bukan angka final.</div>
          </div>
        </div>
      </div>
    </div>

    <div class="kpi-grid">
      <div class="kpi-card revenue">
        <div class="kpi-label">💵 Gross Revenue</div>
        <div class="kpi-value">Rp {fin_kpi_mtd[0].gross_mtd.toLocaleString('id-ID', { maximumFractionDigits: 0 })}</div>
        <div class="kpi-meta">
          {#if fin_kpi_mtd[0].pct_change_gross_mtd > 0}
            <span class="trend-indicator up">▲ +{fin_kpi_mtd[0].pct_change_gross_mtd}%</span>
          {:else if fin_kpi_mtd[0].pct_change_gross_mtd < 0}
            <span class="trend-indicator down">▼ {Math.abs(fin_kpi_mtd[0].pct_change_gross_mtd)}%</span>
          {:else}
            <span class="trend-indicator neutral">0.0%</span>
          {/if}
        </div>
        <div class="kpi-prev">vs bulan lalu penuh: Rp {fin_kpi_mtd[0].gross_bulan_lalu.toLocaleString('id-ID', { maximumFractionDigits: 0 })}</div>
      </div>
      <div class="kpi-card net">
        <div class="kpi-label">💰 Net Revenue</div>
        <div class="kpi-value">Rp {fin_kpi_mtd[0].net_mtd.toLocaleString('id-ID', { maximumFractionDigits: 0 })}</div>
        <div class="kpi-meta">
          {#if fin_kpi_mtd[0].pct_change_net_mtd > 0}
            <span class="trend-indicator up">▲ +{fin_kpi_mtd[0].pct_change_net_mtd}%</span>
          {:else if fin_kpi_mtd[0].pct_change_net_mtd < 0}
            <span class="trend-indicator down">▼ {Math.abs(fin_kpi_mtd[0].pct_change_net_mtd)}%</span>
          {:else}
            <span class="trend-indicator neutral">0.0%</span>
          {/if}
        </div>
        <div class="kpi-prev">vs bulan lalu penuh: Rp {fin_kpi_mtd[0].net_bulan_lalu.toLocaleString('id-ID', { maximumFractionDigits: 0 })}</div>
      </div>
      <div class="kpi-card margin">
        <div class="kpi-label">📈 Net Margin</div>
        <div class="kpi-value">{fin_kpi_mtd[0].margin_mtd}%</div>
        <div class="kpi-meta">
          {#if (fin_kpi_mtd[0].margin_mtd - fin_kpi_mtd[0].margin_bulan_lalu) > 0}
            <span class="trend-indicator up">▲ +{(fin_kpi_mtd[0].margin_mtd - fin_kpi_mtd[0].margin_bulan_lalu).toFixed(1)}pp</span>
          {:else if (fin_kpi_mtd[0].margin_mtd - fin_kpi_mtd[0].margin_bulan_lalu) < 0}
            <span class="trend-indicator down">▼ {Math.abs(fin_kpi_mtd[0].margin_mtd - fin_kpi_mtd[0].margin_bulan_lalu).toFixed(1)}pp</span>
          {:else}
            <span class="trend-indicator neutral">0.0pp</span>
          {/if}
        </div>
        <div class="kpi-prev">vs bulan lalu penuh: {fin_kpi_mtd[0].margin_bulan_lalu}%</div>
      </div>
      <div class="kpi-card cost">
        <div class="kpi-label">💸 Total Biaya</div>
        <div class="kpi-value">Rp {fin_kpi_mtd[0].biaya_mtd.toLocaleString('id-ID', { maximumFractionDigits: 0 })}</div>
        <div class="kpi-meta">
          {#if fin_kpi_mtd[0].pct_change_biaya_mtd > 0}
            <span class="trend-indicator down">▲ +{fin_kpi_mtd[0].pct_change_biaya_mtd}%</span>
          {:else if fin_kpi_mtd[0].pct_change_biaya_mtd < 0}
            <span class="trend-indicator up">▼ {Math.abs(fin_kpi_mtd[0].pct_change_biaya_mtd)}%</span>
          {:else}
            <span class="trend-indicator neutral">0.0%</span>
          {/if}
        </div>
        <div class="kpi-prev">vs bulan lalu penuh: Rp {fin_kpi_mtd[0].biaya_bulan_lalu.toLocaleString('id-ID', { maximumFractionDigits: 0 })}</div>
      </div>
    </div>

    <!-- Outer Diagnostics Container -->
    <div class="diagnostics-stack">
      <div class="diagnostics-header">
        <div class="diagnostics-eyebrow">🔬 Operasional & Diagnostik</div>
        <h2 class="diagnostics-title">Bedah performa & detail biaya</h2>
        <p class="diagnostics-copy">Gunakan instrumen di bawah ini untuk menganalisis detail pengeluaran, radar peringatan operasional harian, serta tren perkembangan margin.</p>
      </div>

      <details class="acc-strategic" open>
        <summary>📊 Detail Analisis Operasional & Tren</summary>
        <div class="acc-body" style="padding: 20px 16px 16px 16px; display: flex; flex-direction: column; gap: 24px;">
          <div class="signal-grid">
            <div class="signal-card {fin_kpi_mtd[0].margin_mtd >= 15 ? 'safe' : fin_kpi_mtd[0].margin_mtd >= 10 ? 'warn' : 'critical'}">
              <div class="signal-label">
                {fin_kpi_mtd[0].margin_mtd >= 15 ? '✅' : fin_kpi_mtd[0].margin_mtd >= 10 ? '⚠️' : '🚨'} Apa Yang Sehat
              </div>
              <div class="signal-title">
                {#if fin_kpi_mtd[0].margin_mtd >= 15}
                  Margin bulan berjalan masih berada di zona sehat.
                {:else if fin_kpi_mtd[0].margin_mtd >= 10}
                  Revenue masih cukup menahan margin agar tidak jatuh lebih dalam.
                {:else}
                  Sinyal sehat sangat tipis, perlu recovery cepat.
                {/if}
              </div>
              <div class="signal-copy">
                {#if fin_kpi_mtd[0].margin_mtd >= 15}
                  Artinya bisnis masih menyisakan ruang laba yang sehat. Fokusnya bukan cari pertumbuhan baru dulu, tapi jaga supaya komponen biaya tidak merayap naik di sisa bulan.
                {:else if fin_operational_overview[0].fokus_mtd !== 'Semua biaya dalam batas'}
                  Walau masih tertekan, bulan ini belum sepenuhnya lepas kendali. Masih ada waktu untuk menekan komponen yang paling boros sebelum tutup buku.
                {:else}
                  Revenue belum runtuh, tapi struktur biaya sekarang terlalu berat untuk level penjualan saat ini.
                {/if}
              </div>
            </div>
            <div class="signal-card {fin_operational_overview[0].fokus_mtd === 'Semua biaya dalam batas' ? 'neutral' : 'warn'}">
              <div class="signal-label">
                {fin_operational_overview[0].fokus_mtd === 'Semua biaya dalam batas' ? '💡' : '🎯'} Yang Perlu Perhatian
              </div>
              <div class="signal-title">
                {#if fin_operational_overview[0].fokus_mtd === 'Semua biaya dalam batas'}
                  Belum ada komponen yang melewati target.
                {:else}
                  {fin_operational_overview[0].fokus_mtd} jadi pressure point utama.
                {/if}
              </div>
              <div class="signal-copy">
                {#if fin_operational_overview[0].fokus_mtd === 'Semua biaya dalam batas'}
                  Risiko terbesar justru ada di konsistensi pace. Pastikan sisa hari bulan ini tidak diisi diskon, waste, atau lembur berlebih yang menggerus margin.
                {:else}
                  Selisih sekitar {fin_operational_overview[0].fokus_gap_mtd}pp di atas ambang normal sudah cukup untuk mengubah hasil akhir bulan kalau dibiarkan berlanjut beberapa hari lagi.
                {/if}
              </div>
            </div>
          </div>

          <div class="section-card">
            <div class="section-head">
              <div>
                <div class="section-eyebrow">💸 Breakdown Biaya</div>
                <h3 class="section-title">Bedah komponen biaya bulan berjalan</h3>
                <p class="section-copy">Dari setiap Rp100 gross revenue bulan {fin_nama_bulan[0].nama_bulan}, berapa yang habis untuk bahan, SDM, dan operasional.</p>
              </div>
            </div>
            <div class="cost-grid">
              <div class="cost-card">
                <div class="cost-label">🥩 Biaya Bahan</div>
                <div class="cost-value" style="color:{fin_cost_mtd[0].bahan_mtd > 32 ? '#dc2626' : '#16a34a'};">{fin_cost_mtd[0].bahan_mtd}%</div>
                <div class="cost-target">🎯 Target normal maks 32%</div>
                <div class="progress-track">
                  <div class="progress-fill" style="width:{Math.min(fin_cost_mtd[0].bahan_mtd / 40 * 100, 100)}%; background:{fin_cost_mtd[0].bahan_mtd > 32 ? 'linear-gradient(90deg,#ef4444,#fca5a5)' : 'linear-gradient(90deg,#16a34a,#86efac)'};"></div>
                  <div class="progress-target" style="left:{32 / 40 * 100}%;"></div>
                </div>
                <div class="progress-scale"><span>0%</span><span>32%</span><span>40%</span></div>
                <div class="cost-note">
                  <div>
                    {#if fin_cost_mtd[0].delta_bahan > 0}
                      <span class="trend-indicator down">▲ +{fin_cost_mtd[0].delta_bahan}pp</span>
                    {:else if fin_cost_mtd[0].delta_bahan < 0}
                      <span class="trend-indicator up">▼ {fin_cost_mtd[0].delta_bahan}pp</span>
                    {:else}
                      <span class="trend-indicator neutral">0.0pp</span>
                    {/if}
                  </div>
                  <div style="font-size: 0.78rem; color: var(--color-text-secondary);">vs {fin_nama_bulan[0].nama_bulan_lalu}</div>
                </div>
              </div>
              <div class="cost-card">
                <div class="cost-label">👥 Biaya SDM</div>
                <div class="cost-value" style="color:{fin_cost_mtd[0].sdm_mtd > 22 ? '#f59e0b' : '#16a34a'};">{fin_cost_mtd[0].sdm_mtd}%</div>
                <div class="cost-target">🎯 Target normal maks 22%</div>
                <div class="progress-track">
                  <div class="progress-fill" style="width:{Math.min(fin_cost_mtd[0].sdm_mtd / 30 * 100, 100)}%; background:{fin_cost_mtd[0].sdm_mtd > 22 ? 'linear-gradient(90deg,#f59e0b,#fde68a)' : 'linear-gradient(90deg,#16a34a,#86efac)'};"></div>
                  <div class="progress-target" style="left:{22 / 30 * 100}%;"></div>
                </div>
                <div class="progress-scale"><span>0%</span><span>22%</span><span>30%</span></div>
                <div class="cost-note">
                  <div>
                    {#if fin_cost_mtd[0].delta_sdm > 0}
                      <span class="trend-indicator down">▲ +{fin_cost_mtd[0].delta_sdm}pp</span>
                    {:else if fin_cost_mtd[0].delta_sdm < 0}
                      <span class="trend-indicator up">▼ {fin_cost_mtd[0].delta_sdm}pp</span>
                    {:else}
                      <span class="trend-indicator neutral">0.0pp</span>
                    {/if}
                  </div>
                  <div style="font-size: 0.78rem; color: var(--color-text-secondary);">vs {fin_nama_bulan[0].nama_bulan_lalu}</div>
                </div>
              </div>
              <div class="cost-card">
                <div class="cost-label">⚙️ Biaya Operasional</div>
                <div class="cost-value" style="color:{fin_cost_mtd[0].ops_mtd > 15 ? '#dc2626' : '#16a34a'};">{fin_cost_mtd[0].ops_mtd}%</div>
                <div class="cost-target">🎯 Target normal maks 15%</div>
                <div class="progress-track">
                  <div class="progress-fill" style="width:{Math.min(fin_cost_mtd[0].ops_mtd / 25 * 100, 100)}%; background:{fin_cost_mtd[0].ops_mtd > 15 ? 'linear-gradient(90deg,#ef4444,#fca5a5)' : 'linear-gradient(90deg,#16a34a,#86efac)'};"></div>
                  <div class="progress-target" style="left:{15 / 25 * 100}%;"></div>
                </div>
                <div class="progress-scale"><span>0%</span><span>15%</span><span>25%</span></div>
                <div class="cost-note">
                  <div>
                    {#if fin_cost_mtd[0].delta_ops > 0}
                      <span class="trend-indicator down">▲ +{fin_cost_mtd[0].delta_ops}pp</span>
                    {:else if fin_cost_mtd[0].delta_ops < 0}
                      <span class="trend-indicator up">▼ {fin_cost_mtd[0].delta_ops}pp</span>
                    {:else}
                      <span class="trend-indicator neutral">0.0pp</span>
                    {/if}
                  </div>
                  <div style="font-size: 0.78rem; color: var(--color-text-secondary);">vs {fin_nama_bulan[0].nama_bulan_lalu}</div>
                </div>
              </div>
            </div>
          </div>

          <div class="section-card">
            <div class="section-head tight">
              <div>
                <div class="section-eyebrow">📈 Tren Margin</div>
                <h3 class="section-title">Apakah bulan ini membaik atau hanya bertahan?</h3>
                <p class="section-copy">Chart ini dipakai untuk melihat apakah margin harian konsisten, atau sehat hanya karena beberapa hari yang sangat kuat.</p>
              </div>
            </div>
            <LineChart
              data={fin_margin_daily_mtd}
              x="metric_date"
              y="margin_pct"
              title="Net Margin Harian MTD (%)"
              yFmt="0.0\%"
              xAxisTitle="Tanggal"
              yAxisTitle="Net Margin (%)"
            >
              <ReferenceLine y={15} label="Target 15%" lineType="dashed" color="green" />
              <ReferenceLine y={10} label="Kritis 10%" lineType="dashed" color="red" />
            </LineChart>
          </div>

          <details>
            <summary>💡 Analisis & Langkah Konkret (Bulan Ini)</summary>
            <div class="acc-body">
              <div class="acc-grid">
                <div>
                  <div class="acc-title-sub">📊 Konteks Analisis</div>
                  <div class="acc-text-block">
                    Net margin bulan berjalan paling berguna sebagai radar cepat. Ia belum seadil 30 hari, tapi cukup tajam untuk mendeteksi pressure lebih awal. Kalau margin masih sehat sementara satu komponen biaya sudah naik, itu sinyal untuk bertindak sebelum masalah menjadi hasil akhir bulan.
                  </div>
                  <div style="margin-top: 16px; font-size: 0.8rem; color: var(--color-text-secondary); line-height: 1.5;">
                    Untuk mendalami performa per lokasi, gunakan menu <a class="inline-link" href="/02-branch-performance">Performa Cabang</a>. Fokus halaman laporan ini adalah konsolidasi finansial utama.
                  </div>
                </div>
                <div>
                  <div class="acc-title-sub">🎯 Rekomendasi Tindakan</div>
                  <div class="acc-alert-list">
                    {#if fin_cost_mtd[0].bahan_mtd > 32}
                      <div class="acc-alert-item">
                        <strong>🥩 Bahan di atas target ({fin_cost_mtd[0].bahan_mtd}% vs maks 32%):</strong> Cek item yang paling banyak mendorong COGS, pola pembelian besar di awal bulan, dan waste yang tidak tertutup kenaikan revenue.
                      </div>
                    {/if}
                    {#if fin_cost_mtd[0].sdm_mtd > 22}
                      <div class="acc-alert-item" style="border-left-color: #f59e0b; background: rgba(245, 158, 11, 0.05);">
                        <strong>👥 SDM di atas target ({fin_cost_mtd[0].sdm_mtd}% vs maks 22%):</strong> Lihat distribusi shift, lembur, dan apakah revenue harian cukup padat untuk menutup biaya tenaga kerja sekarang.
                      </div>
                    {/if}
                    {#if fin_cost_mtd[0].ops_mtd > 15}
                      <div class="acc-alert-item">
                        <strong>⚙️ Operasional di atas target ({fin_cost_mtd[0].ops_mtd}% vs maks 15%):</strong> Biasanya lebih lambat berubah, jadi periksa beban fixed cost, promosi yang tidak efisien, atau hari-hari revenue lemah yang memperbesar rasio biaya.
                      </div>
                    {/if}
                    {#if fin_cost_mtd[0].bahan_mtd <= 32 && fin_cost_mtd[0].sdm_mtd <= 22 && fin_cost_mtd[0].ops_mtd <= 15}
                      <div class="acc-alert-item" style="border-left-color: #16a34a; background: rgba(22, 163, 74, 0.05);">
                        <strong>✅ Aman:</strong> Tidak ada komponen yang melewati target. Fokus terbaik sekarang adalah menjaga disiplin diskon, menjaga pace transaksi, dan memastikan penutupan bulan tidak rusak oleh beberapa hari buruk di akhir periode.
                      </div>
                    {/if}
                  </div>
                </div>
              </div>
            </div>
          </details>
        </div>
      </details>
    </div>

  <!-- ══════════════════════════════════════════
       90D VIEW
  ══════════════════════════════════════════ -->
  {:else if inputs.period === '90d'}
    <div class="hero">
      <div class="hero-eyebrow">🔭 Laporan Keuangan · 90 Hari Terakhir</div>
      <div class="hero-grid">
        <div class="hero-main-card {fin_kpi[0].margin_90d >= 15 ? 'status-sehat' : fin_kpi[0].margin_90d >= 10 ? 'status-waspada' : 'status-kritis'}">
          <div class="hero-stat-number">{fin_kpi[0].margin_90d}%</div>
          <div class="hero-subtitle">
            {#if fin_kpi[0].margin_90d >= 15}
              Margin masih sehat untuk horizon 3 bulan.
            {:else if fin_kpi[0].margin_90d >= 10}
              Margin menunjukkan tekanan struktural ringan.
            {:else}
              Margin sudah kritis secara struktural.
            {/if}
          </div>
        </div>
        <div class="hero-side">
          <div class="hero-side-card">
            <div class="hero-side-label">📅 Periode Aktif</div>
            <div class="hero-side-value">{fin_dates[0].tgl_90d_awal} - {fin_dates[0].tgl_akhir}</div>
            <div class="hero-side-note">Cakupan ini cocok untuk menangkap pola biaya yang sudah berulang, bukan anomali beberapa hari.</div>
          </div>
          <div class="hero-side-card">
            <div class="hero-side-label">💵 Rata-rata Harian</div>
            <div class="hero-side-value" style="font-size: 1.15rem; font-weight: 800;">Rp {Math.round(fin_kpi[0].gross_90d / 90).toLocaleString('id-ID', { maximumFractionDigits: 0 })} / hari</div>
            <div class="hero-side-note" style="margin-top: 4px;">Total penjualan terkumpul: Rp {fin_kpi[0].gross_90d.toLocaleString('id-ID', { maximumFractionDigits: 0 })}</div>
          </div>
        </div>
      </div>
    </div>

    <div class="kpi-grid">
      <div class="kpi-card revenue">
        <div class="kpi-label">💵 Gross Revenue</div>
        <div class="kpi-value">Rp {fin_kpi[0].gross_90d.toLocaleString('id-ID', { maximumFractionDigits: 0 })}</div>
        <div class="kpi-meta">
          {#if fin_kpi[0].pct_change_gross_90d > 0}
            <span class="trend-indicator up">▲ +{fin_kpi[0].pct_change_gross_90d}%</span>
          {:else if fin_kpi[0].pct_change_gross_90d < 0}
            <span class="trend-indicator down">▼ {Math.abs(fin_kpi[0].pct_change_gross_90d)}%</span>
          {:else}
            <span class="trend-indicator neutral">0.0%</span>
          {/if}
        </div>
        <div class="kpi-prev">vs 90 hari sebelumnya: Rp {fin_kpi[0].gross_prev90d.toLocaleString('id-ID', { maximumFractionDigits: 0 })}</div>
      </div>
      <div class="kpi-card net">
        <div class="kpi-label">💰 Net Revenue</div>
        <div class="kpi-value">Rp {fin_kpi[0].net_90d.toLocaleString('id-ID', { maximumFractionDigits: 0 })}</div>
        <div class="kpi-meta">
          {#if fin_kpi[0].pct_change_net_90d > 0}
            <span class="trend-indicator up">▲ +{fin_kpi[0].pct_change_net_90d}%</span>
          {:else if fin_kpi[0].pct_change_net_90d < 0}
            <span class="trend-indicator down">▼ {Math.abs(fin_kpi[0].pct_change_net_90d)}%</span>
          {:else}
            <span class="trend-indicator neutral">0.0%</span>
          {/if}
        </div>
        <div class="kpi-prev">vs 90 hari sebelumnya: Rp {fin_kpi[0].net_prev90d.toLocaleString('id-ID', { maximumFractionDigits: 0 })}</div>
      </div>
      <div class="kpi-card margin">
        <div class="kpi-label">📈 Net Margin</div>
        <div class="kpi-value">{fin_kpi[0].margin_90d}%</div>
        <div class="kpi-meta">
          {#if fin_kpi[0].delta_margin_90d > 0}
            <span class="trend-indicator up">▲ +{fin_kpi[0].delta_margin_90d}pp</span>
          {:else if fin_kpi[0].delta_margin_90d < 0}
            <span class="trend-indicator down">▼ {Math.abs(fin_kpi[0].delta_margin_90d)}pp</span>
          {:else}
            <span class="trend-indicator neutral">0.0pp</span>
          {/if}
        </div>
        <div class="kpi-prev">vs 90 hari sebelumnya: {fin_kpi[0].margin_prev90d}%</div>
      </div>
      <div class="kpi-card cost">
        <div class="kpi-label">💸 Total Biaya</div>
        <div class="kpi-value">Rp {fin_kpi[0].biaya_90d.toLocaleString('id-ID', { maximumFractionDigits: 0 })}</div>
        <div class="kpi-meta">
          {#if fin_kpi[0].pct_change_biaya_90d > 0}
            <span class="trend-indicator down">▲ +{fin_kpi[0].pct_change_biaya_90d}%</span>
          {:else if fin_kpi[0].pct_change_biaya_90d < 0}
            <span class="trend-indicator up">▼ {Math.abs(fin_kpi[0].pct_change_biaya_90d)}%</span>
          {:else}
            <span class="trend-indicator neutral">0.0%</span>
          {/if}
        </div>
        <div class="kpi-prev">vs 90 hari sebelumnya: Rp {fin_kpi[0].biaya_prev90d.toLocaleString('id-ID', { maximumFractionDigits: 0 })}</div>
      </div>
    </div>

    <!-- Outer Diagnostics Container -->
    <div class="diagnostics-stack">
      <div class="diagnostics-header">
        <div class="diagnostics-eyebrow">🔬 Operasional & Diagnostik</div>
        <h2 class="diagnostics-title">Bedah performa & detail biaya</h2>
        <p class="diagnostics-copy">Gunakan instrumen di bawah ini untuk menganalisis detail pengeluaran, radar peringatan operasional harian, serta tren perkembangan margin.</p>
      </div>

      <details class="acc-strategic" open>
        <summary>📊 Detail Analisis Operasional & Tren</summary>
        <div class="acc-body" style="padding: 20px 16px 16px 16px; display: flex; flex-direction: column; gap: 24px;">
          <div class="signal-grid">
            <div class="signal-card {fin_kpi[0].margin_90d >= 15 ? 'safe' : fin_kpi[0].margin_90d >= 10 ? 'warn' : 'critical'}">
              <div class="signal-label">
                {fin_kpi[0].margin_90d >= 15 ? '✅' : fin_kpi[0].margin_90d >= 10 ? '⚠️' : '🚨'} Apa Yang Sehat
              </div>
              <div class="signal-title">
                {#if fin_kpi[0].margin_90d >= 15 && fin_kpi[0].delta_margin_90d >= 0}
                  Margin sehat dan tidak menunjukkan erosi struktural.
                {:else if fin_kpi[0].margin_90d >= 15}
                  Margin masih sehat, tapi kualitas efisiensinya mulai melunak.
                {:else}
                  Masalahnya bukan lagi hari buruk, tapi pola 3 bulan.
                {/if}
              </div>
              <div class="signal-copy">
                {#if fin_kpi[0].margin_90d >= 15 && fin_kpi[0].delta_margin_90d >= 0}
                  Ini pertanda bisnis tidak hanya menjual lebih banyak, tetapi juga masih menyisakan laba yang sehat setelah menutup seluruh biaya utama.
                {:else if fin_kpi[0].margin_90d >= 15}
                  Revenue masih kuat, namun margin belum naik seiring volume. Artinya ada biaya yang tumbuh lebih cepat daripada omset.
                {:else}
                  Horizon 90 hari memberi bukti yang lebih tebal. Perlu pembenahan model biaya, bukan hanya reaksi mingguan.
                {/if}
              </div>
            </div>
            <div class="signal-card {fin_operational_overview[0].fokus_90d === 'Semua biaya dalam batas' ? 'neutral' : 'warn'}">
              <div class="signal-label">
                {fin_operational_overview[0].fokus_90d === 'Semua biaya dalam batas' ? '💡' : '🎯'} Yang Perlu Perhatian
              </div>
              <div class="signal-title">
                {#if fin_operational_overview[0].fokus_90d === 'Semua biaya dalam batas'}
                  Tidak ada komponen yang konsisten melewati target.
                {:else}
                  {fin_operational_overview[0].fokus_90d} paling banyak menekan margin 90 hari.
                {/if}
              </div>
              <div class="signal-copy">
                {#if fin_operational_overview[0].fokus_90d === 'Semua biaya dalam batas'}
                  Risiko utama ada di sustainability: apakah revenue growth ke depan masih cukup untuk menjaga margin, terutama saat masuk periode musiman yang lebih lemah.
                {:else}
                  Karena pressure ini bertahan hingga 3 bulan, ada kemungkinan penyebabnya bersifat sistemik: supplier, pricing, staffing mix, atau beban operasional tetap yang terlalu besar.
                {/if}
              </div>
            </div>
          </div>

          <div class="section-card">
            <div class="section-head">
              <div>
                <div class="section-eyebrow">💸 Breakdown Biaya</div>
                <h3 class="section-title">Biaya 90 hari: mana yang paling menggerus margin?</h3>
                <p class="section-copy">Gunakan view ini untuk membaca masalah yang sudah cukup berulang untuk dianggap struktural.</p>
              </div>
            </div>
            <div class="cost-grid">
              <div class="cost-card">
                <div class="cost-label">🥩 Biaya Bahan</div>
                <div class="cost-value" style="color:{fin_cost_pct[0].bahan_90d > 32 ? '#dc2626' : '#16a34a'};">{fin_cost_pct[0].bahan_90d}%</div>
                <div class="cost-target">🎯 Target normal maks 32%</div>
                <div class="progress-track">
                  <div class="progress-fill" style="width:{Math.min(fin_cost_pct[0].bahan_90d / 40 * 100, 100)}%; background:{fin_cost_pct[0].bahan_90d > 32 ? 'linear-gradient(90deg,#ef4444,#fca5a5)' : 'linear-gradient(90deg,#16a34a,#86efac)'};"></div>
                  <div class="progress-target" style="left:{32 / 40 * 100}%;"></div>
                </div>
                <div class="progress-scale"><span>0%</span><span>32%</span><span>40%</span></div>
                <div class="cost-note">
                  <div>
                    {#if fin_cost_pct[0].delta_bahan_90d > 0}
                      <span class="trend-indicator down">▲ +{fin_cost_pct[0].delta_bahan_90d}pp</span>
                    {:else if fin_cost_pct[0].delta_bahan_90d < 0}
                      <span class="trend-indicator up">▼ {fin_cost_pct[0].delta_bahan_90d}pp</span>
                    {:else}
                      <span class="trend-indicator neutral">0.0pp</span>
                    {/if}
                  </div>
                  <div style="font-size: 0.78rem; color: var(--color-text-secondary);">vs 90 hari sebelumnya</div>
                </div>
              </div>
              <div class="cost-card">
                <div class="cost-label">👥 Biaya SDM</div>
                <div class="cost-value" style="color:{fin_cost_pct[0].sdm_90d > 22 ? '#f59e0b' : '#16a34a'};">{fin_cost_pct[0].sdm_90d}%</div>
                <div class="cost-target">🎯 Target normal maks 22%</div>
                <div class="progress-track">
                  <div class="progress-fill" style="width:{Math.min(fin_cost_pct[0].sdm_90d / 30 * 100, 100)}%; background:{fin_cost_pct[0].sdm_90d > 22 ? 'linear-gradient(90deg,#f59e0b,#fde68a)' : 'linear-gradient(90deg,#16a34a,#86efac)'};"></div>
                  <div class="progress-target" style="left:{22 / 30 * 100}%;"></div>
                </div>
                <div class="progress-scale"><span>0%</span><span>22%</span><span>30%</span></div>
                <div class="cost-note">
                  <div>
                    {#if fin_cost_pct[0].delta_sdm_90d > 0}
                      <span class="trend-indicator down">▲ +{fin_cost_pct[0].delta_sdm_90d}pp</span>
                    {:else if fin_cost_pct[0].delta_sdm_90d < 0}
                      <span class="trend-indicator up">▼ {fin_cost_pct[0].delta_sdm_90d}pp</span>
                    {:else}
                      <span class="trend-indicator neutral">0.0pp</span>
                    {/if}
                  </div>
                  <div style="font-size: 0.78rem; color: var(--color-text-secondary);">vs 90 hari sebelumnya</div>
                </div>
              </div>
              <div class="cost-card">
                <div class="cost-label">⚙️ Biaya Operasional</div>
                <div class="cost-value" style="color:{fin_cost_pct[0].ops_90d > 15 ? '#dc2626' : '#16a34a'};">{fin_cost_pct[0].ops_90d}%</div>
                <div class="cost-target">🎯 Target normal maks 15%</div>
                <div class="progress-track">
                  <div class="progress-fill" style="width:{Math.min(fin_cost_pct[0].ops_90d / 25 * 100, 100)}%; background:{fin_cost_pct[0].ops_90d > 15 ? 'linear-gradient(90deg,#ef4444,#fca5a5)' : 'linear-gradient(90deg,#16a34a,#86efac)'};"></div>
                  <div class="progress-target" style="left:{15 / 25 * 100}%;"></div>
                </div>
                <div class="progress-scale"><span>0%</span><span>15%</span><span>25%</span></div>
                <div class="cost-note">
                  <div>
                    {#if fin_cost_pct[0].delta_ops_90d > 0}
                      <span class="trend-indicator down">▲ +{fin_cost_pct[0].delta_ops_90d}pp</span>
                    {:else if fin_cost_pct[0].delta_ops_90d < 0}
                      <span class="trend-indicator up">▼ {fin_cost_pct[0].delta_ops_90d}pp</span>
                    {:else}
                      <span class="trend-indicator neutral">0.0pp</span>
                    {/if}
                  </div>
                  <div style="font-size: 0.78rem; color: var(--color-text-secondary);">vs 90 hari sebelumnya</div>
                </div>
              </div>
            </div>
          </div>

          <div class="section-card">
            <div class="section-head tight">
              <div>
                <div class="section-eyebrow">📈 Tren Margin</div>
                <h3 class="section-title">Tren margin harian 90 hari</h3>
                <p class="section-copy">Semakin sering garis margin menyentuh area di bawah 15%, semakin besar kemungkinan tekanan biaya bukan sekadar kejadian sesaat.</p>
              </div>
            </div>
            <LineChart
              data={fin_margin_daily_90d}
              x="metric_date"
              y="margin_pct"
              title="Net Margin Harian 90 Hari (%)"
              yFmt="0.0\%"
              xAxisTitle="Tanggal"
              yAxisTitle="Net Margin (%)"
            >
              <ReferenceLine y={15} label="Target 15%" lineType="dashed" color="green" />
              <ReferenceLine y={10} label="Kritis 10%" lineType="dashed" color="red" />
            </LineChart>
          </div>

          <details>
            <summary>💡 Analisis & Langkah Konkret (90 Hari)</summary>
            <div class="acc-body">
              <div class="acc-grid">
                <div>
                  <div class="acc-title-sub">📊 Konteks Analisis</div>
                  <div class="acc-text-block">
                    View 90 hari berguna saat kamu ingin memisahkan noise dari pola. Kalau margin sehat di 30 hari tapi melemah di 90 hari, itu biasanya tanda revenue baru saja membaik namun pondasi biayanya belum benar-benar pulih.
                  </div>
                  <div style="margin-top: 16px; font-size: 0.8rem; color: var(--color-text-secondary); line-height: 1.5;">
                    Untuk melihat variasi antar cabang, buka halaman <a class="inline-link" href="/02-branch-performance">Performa Cabang</a>. Di halaman keuangan ini fokusnya tetap menjaga kesehatan margin total bisnis.
                  </div>
                </div>
                <div>
                  <div class="acc-title-sub">🎯 Rekomendasi Tindakan</div>
                  <div class="acc-alert-list">
                    {#if fin_cost_pct[0].bahan_90d > 32}
                      <div class="acc-alert-item">
                        <strong>🥩 Bahan di atas target ({fin_cost_pct[0].bahan_90d}% vs maks 32%):</strong> Analisis vendor supplier utama, cari kontrak jangka panjang untuk item volume tinggi, dan batasi waste bahan baku.
                      </div>
                    {/if}
                    {#if fin_cost_pct[0].sdm_90d > 22}
                      <div class="acc-alert-item" style="border-left-color: #f59e0b; background: rgba(245, 158, 11, 0.05);">
                        <strong>👥 SDM di atas target ({fin_cost_pct[0].sdm_90d}% vs maks 22%):</strong> Tinjau produktivitas shift bulanan, pastikan rasio jam lembur dalam kendali, dan sesuaikan kapasitas tim dengan tren penjualan.
                      </div>
                    {/if}
                    {#if fin_cost_pct[0].ops_90d > 15}
                      <div class="acc-alert-item">
                        <strong>⚙️ Operasional di atas target ({fin_cost_pct[0].ops_90d}% vs maks 15%):</strong> Evaluasi biaya sewa utilitas rutin, optimalkan pengeluaran promosi, and pastikan biaya pemeliharaan berkala berjalan efisien.
                      </div>
                    {/if}
                    {#if fin_cost_pct[0].bahan_90d <= 32 && fin_cost_pct[0].sdm_90d <= 22 && fin_cost_pct[0].ops_90d <= 15}
                      <div class="acc-alert-item" style="border-left-color: #16a34a; background: rgba(22, 163, 74, 0.05);">
                        <strong>✅ Aman:</strong> Tidak ada komponen yang melewati target selama 90 hari terakhir.
                      </div>
                    {/if}
                  </div>
                </div>
              </div>
            </div>
          </details>
        </div>
      </details>
    </div>

  <!-- ══════════════════════════════════════════
       30D VIEW (default)
  ══════════════════════════════════════════ -->
  {:else}
    <div class="hero">
      <div class="hero-eyebrow">📊 Laporan Keuangan · 30 Hari Terakhir</div>
      <div class="hero-grid">
        <div class="hero-main-card {fin_kpi[0].margin_30d >= 15 ? 'status-sehat' : fin_kpi[0].margin_30d >= 10 ? 'status-waspada' : 'status-kritis'}">
          <div class="hero-stat-number">{fin_kpi[0].margin_30d}%</div>
          <div class="hero-subtitle">
            {#if fin_kpi[0].margin_30d >= 15}
              Margin masih sehat untuk basis operasional utama.
            {:else if fin_kpi[0].margin_30d >= 10}
              Margin sudah masuk zona waspada dalam 30 hari.
            {:else}
              Margin sudah kritis secara operasional.
            {/if}
          </div>
        </div>
        <div class="hero-side">
          <div class="hero-side-card">
            <div class="hero-side-label">📅 Periode Aktif</div>
            <div class="hero-side-value">{fin_dates[0].tgl_30d_awal} - {fin_dates[0].tgl_akhir}</div>
            <div class="hero-side-note">Ini window paling stabil untuk keputusan operasional: cukup panjang untuk melihat pola, cukup dekat untuk bereaksi.</div>
          </div>
          <div class="hero-side-card">
            <div class="hero-side-label">💵 Rata-rata Harian</div>
            <div class="hero-side-value" style="font-size: 1.15rem; font-weight: 800;">Rp {Math.round(fin_kpi[0].gross_30d / 30).toLocaleString('id-ID', { maximumFractionDigits: 0 })} / hari</div>
            <div class="hero-side-note" style="margin-top: 4px;">Total penjualan terkumpul: Rp {fin_kpi[0].gross_30d.toLocaleString('id-ID', { maximumFractionDigits: 0 })}</div>
          </div>
        </div>
      </div>
    </div>

    <div class="kpi-grid">
      <div class="kpi-card revenue">
        <div class="kpi-label">💵 Gross Revenue</div>
        <div class="kpi-value">Rp {fin_kpi[0].gross_30d.toLocaleString('id-ID', { maximumFractionDigits: 0 })}</div>
        <div class="kpi-meta">
          {#if fin_kpi[0].pct_change_gross_30d > 0}
            <span class="trend-indicator up">▲ +{fin_kpi[0].pct_change_gross_30d}%</span>
          {:else if fin_kpi[0].pct_change_gross_30d < 0}
            <span class="trend-indicator down">▼ {Math.abs(fin_kpi[0].pct_change_gross_30d)}%</span>
          {:else}
            <span class="trend-indicator neutral">0.0%</span>
          {/if}
        </div>
        <div class="kpi-prev">vs 30 hari sebelumnya: Rp {fin_kpi[0].gross_prev30d.toLocaleString('id-ID', { maximumFractionDigits: 0 })}</div>
      </div>
      <div class="kpi-card net">
        <div class="kpi-label">💰 Net Revenue</div>
        <div class="kpi-value">Rp {fin_kpi[0].net_30d.toLocaleString('id-ID', { maximumFractionDigits: 0 })}</div>
        <div class="kpi-meta">
          {#if fin_kpi[0].pct_change_net_30d > 0}
            <span class="trend-indicator up">▲ +{fin_kpi[0].pct_change_net_30d}%</span>
          {:else if fin_kpi[0].pct_change_net_30d < 0}
            <span class="trend-indicator down">▼ {Math.abs(fin_kpi[0].pct_change_net_30d)}%</span>
          {:else}
            <span class="trend-indicator neutral">0.0%</span>
          {/if}
        </div>
        <div class="kpi-prev">vs 30 hari sebelumnya: Rp {fin_kpi[0].net_prev30d.toLocaleString('id-ID', { maximumFractionDigits: 0 })}</div>
      </div>
      <div class="kpi-card margin">
        <div class="kpi-label">📈 Net Margin</div>
        <div class="kpi-value">{fin_kpi[0].margin_30d}%</div>
        <div class="kpi-meta">
          {#if fin_kpi[0].delta_margin_30d > 0}
            <span class="trend-indicator up">▲ +{fin_kpi[0].delta_margin_30d}pp</span>
          {:else if fin_kpi[0].delta_margin_30d < 0}
            <span class="trend-indicator down">▼ {Math.abs(fin_kpi[0].delta_margin_30d)}pp</span>
          {:else}
            <span class="trend-indicator neutral">0.0pp</span>
          {/if}
        </div>
        <div class="kpi-prev">vs 30 hari sebelumnya: {fin_kpi[0].margin_prev30d}%</div>
      </div>
      <div class="kpi-card cost">
        <div class="kpi-label">💸 Total Biaya</div>
        <div class="kpi-value">Rp {fin_kpi[0].biaya_30d.toLocaleString('id-ID', { maximumFractionDigits: 0 })}</div>
        <div class="kpi-meta">
          {#if fin_kpi[0].pct_change_biaya_30d > 0}
            <span class="trend-indicator down">▲ +{fin_kpi[0].pct_change_biaya_30d}%</span>
          {:else if fin_kpi[0].pct_change_biaya_30d < 0}
            <span class="trend-indicator up">▼ {Math.abs(fin_kpi[0].pct_change_biaya_30d)}%</span>
          {:else}
            <span class="trend-indicator neutral">0.0%</span>
          {/if}
        </div>
        <div class="kpi-prev">vs 30 hari sebelumnya: Rp {fin_kpi[0].biaya_prev30d.toLocaleString('id-ID', { maximumFractionDigits: 0 })}</div>
      </div>
    </div>

    <!-- Outer Diagnostics Container -->
    <div class="diagnostics-stack">
      <div class="diagnostics-header">
        <div class="diagnostics-eyebrow">🔬 Operasional & Diagnostik</div>
        <h2 class="diagnostics-title">Bedah performa & detail biaya</h2>
        <p class="diagnostics-copy">Gunakan instrumen di bawah ini untuk menganalisis detail pengeluaran, radar peringatan operasional harian, serta tren perkembangan margin.</p>
      </div>

      <details class="acc-strategic" open>
        <summary>📊 Detail Analisis Operasional & Tren</summary>
        <div class="acc-body" style="padding: 20px 16px 16px 16px; display: flex; flex-direction: column; gap: 24px;">
          <div class="signal-grid">
            <div class="signal-card {fin_kpi[0].margin_30d >= 15 ? 'safe' : fin_kpi[0].margin_30d >= 10 ? 'warn' : 'critical'}">
              <div class="signal-label">
                {fin_kpi[0].margin_30d >= 15 ? '✅' : fin_kpi[0].margin_30d >= 10 ? '⚠️' : '🚨'} Apa Yang Sehat
              </div>
              <div class="signal-title">
                {#if fin_kpi[0].margin_30d >= 15}
                  Margin operasional 30 hari terakhir dalam kondisi aman.
                {:else if fin_kpi[0].margin_30d >= 10}
                  Revenue masih cukup menahan margin agar tidak jatuh lebih dalam.
                {:else}
                  Tekanan margin sudah sangat tinggi, perlu intervensi biaya segera.
                {/if}
              </div>
              <div class="signal-copy">
                {#if fin_kpi[0].margin_30d >= 15}
                  Artinya bisnis masih menyisakan ruang laba yang sehat. Fokusnya bukan cari pertumbuhan baru dulu, tapi jaga supaya komponen biaya tidak merayap naik.
                {:else if fin_operational_overview[0].fokus_30d !== 'Semua biaya dalam batas'}
                  Walau masih tertekan, bulan ini belum sepenuhnya lepas kendali. Masih ada waktu untuk menekan komponen yang paling boros sebelum tutup buku.
                {:else}
                  Revenue belum runtuh, tapi struktur biaya sekarang terlalu berat untuk level penjualan saat ini.
                {/if}
              </div>
            </div>
            <div class="signal-card {fin_operational_overview[0].fokus_30d === 'Semua biaya dalam batas' ? 'neutral' : 'warn'}">
              <div class="signal-label">
                {fin_operational_overview[0].fokus_30d === 'Semua biaya dalam batas' ? '💡' : '🎯'} Yang Perlu Perhatian
              </div>
              <div class="signal-title">
                {#if fin_operational_overview[0].fokus_30d === 'Semua biaya dalam batas'}
                  Belum ada komponen biaya utama yang melewati target.
                {:else}
                  {fin_operational_overview[0].fokus_30d} jadi pressure point utama.
                {/if}
              </div>
              <div class="signal-copy">
                {#if fin_operational_overview[0].fokus_30d === 'Semua biaya dalam batas'}
                  Risiko terbesar justru ada di konsistensi pace. Pastikan sisa hari bulan ini tidak diisi diskon, waste, atau lembur berlebih yang menggerus margin.
                {:else}
                  Selisih sekitar {fin_operational_overview[0].fokus_gap_30d}pp di atas ambang normal sudah cukup untuk mengubah hasil akhir bulan kalau dibiarkan berlanjut beberapa hari lagi.
                {/if}
              </div>
            </div>
          </div>

          <div class="section-card">
            <div class="section-head">
              <div>
                <div class="section-eyebrow">💸 Breakdown Biaya</div>
                <h3 class="section-title">Bedah komponen biaya 30 hari terakhir</h3>
                <p class="section-copy">Dari setiap Rp100 gross revenue 30 hari terakhir, berapa yang habis untuk bahan, SDM, dan operasional.</p>
              </div>
            </div>
            <div class="cost-grid">
              <div class="cost-card">
                <div class="cost-label">🥩 Biaya Bahan</div>
                <div class="cost-value" style="color:{fin_cost_pct[0].bahan_30d > 32 ? '#dc2626' : '#16a34a'};">{fin_cost_pct[0].bahan_30d}%</div>
                <div class="cost-target">🎯 Target normal maks 32%</div>
                <div class="progress-track">
                  <div class="progress-fill" style="width:{Math.min(fin_cost_pct[0].bahan_30d / 40 * 100, 100)}%; background:{fin_cost_pct[0].bahan_30d > 32 ? 'linear-gradient(90deg,#ef4444,#fca5a5)' : 'linear-gradient(90deg,#16a34a,#86efac)'};"></div>
                  <div class="progress-target" style="left:{32 / 40 * 100}%;"></div>
                </div>
                <div class="progress-scale"><span>0%</span><span>32%</span><span>40%</span></div>
                <div class="cost-note">
                  <div>
                    {#if fin_cost_pct[0].delta_bahan_30d > 0}
                      <span class="trend-indicator down">▲ +{fin_cost_pct[0].delta_bahan_30d}pp</span>
                    {:else if fin_cost_pct[0].delta_bahan_30d < 0}
                      <span class="trend-indicator up">▼ {fin_cost_pct[0].delta_bahan_30d}pp</span>
                    {:else}
                      <span class="trend-indicator neutral">0.0pp</span>
                    {/if}
                  </div>
                  <div style="font-size: 0.78rem; color: var(--color-text-secondary);">vs 30 hari sebelumnya</div>
                </div>
              </div>
              <div class="cost-card">
                <div class="cost-label">👥 Biaya SDM</div>
                <div class="cost-value" style="color:{fin_cost_pct[0].sdm_30d > 22 ? '#f59e0b' : '#16a34a'};">{fin_cost_pct[0].sdm_30d}%</div>
                <div class="cost-target">🎯 Target normal maks 22%</div>
                <div class="progress-track">
                  <div class="progress-fill" style="width:{Math.min(fin_cost_pct[0].sdm_30d / 30 * 100, 100)}%; background:{fin_cost_pct[0].sdm_30d > 22 ? 'linear-gradient(90deg,#f59e0b,#fde68a)' : 'linear-gradient(90deg,#16a34a,#86efac)'};"></div>
                  <div class="progress-target" style="left:{22 / 30 * 100}%;"></div>
                </div>
                <div class="progress-scale"><span>0%</span><span>22%</span><span>30%</span></div>
                <div class="cost-note">
                  <div>
                    {#if fin_cost_pct[0].delta_sdm_30d > 0}
                      <span class="trend-indicator down">▲ +{fin_cost_pct[0].delta_sdm_30d}pp</span>
                    {:else if fin_cost_pct[0].delta_sdm_30d < 0}
                      <span class="trend-indicator up">▼ {fin_cost_pct[0].delta_sdm_30d}pp</span>
                    {:else}
                      <span class="trend-indicator neutral">0.0pp</span>
                    {/if}
                  </div>
                  <div style="font-size: 0.78rem; color: var(--color-text-secondary);">vs 30 hari sebelumnya</div>
                </div>
              </div>
              <div class="cost-card">
                <div class="cost-label">⚙️ Biaya Operasional</div>
                <div class="cost-value" style="color:{fin_cost_pct[0].ops_30d > 15 ? '#dc2626' : '#16a34a'};">{fin_cost_pct[0].ops_30d}%</div>
                <div class="cost-target">🎯 Target normal maks 15%</div>
                <div class="progress-track">
                  <div class="progress-fill" style="width:{Math.min(fin_cost_pct[0].ops_30d / 25 * 100, 100)}%; background:{fin_cost_pct[0].ops_30d > 15 ? 'linear-gradient(90deg,#ef4444,#fca5a5)' : 'linear-gradient(90deg,#16a34a,#86efac)'};"></div>
                  <div class="progress-target" style="left:{15 / 25 * 100}%;"></div>
                </div>
                <div class="progress-scale"><span>0%</span><span>15%</span><span>25%</span></div>
                <div class="cost-note">
                  <div>
                    {#if fin_cost_pct[0].delta_ops_30d > 0}
                      <span class="trend-indicator down">▲ +{fin_cost_pct[0].delta_ops_30d}pp</span>
                    {:else if fin_cost_pct[0].delta_ops_30d < 0}
                      <span class="trend-indicator up">▼ {fin_cost_pct[0].delta_ops_30d}pp</span>
                    {:else}
                      <span class="trend-indicator neutral">0.0pp</span>
                    {/if}
                  </div>
                  <div style="font-size: 0.78rem; color: var(--color-text-secondary);">vs 30 hari sebelumnya</div>
                </div>
              </div>
            </div>
          </div>

          <div class="section-card">
            <div class="section-head tight">
              <div>
                <div class="section-eyebrow">📈 Tren Margin</div>
                <h3 class="section-title">Apakah bulan ini membaik atau hanya bertahan?</h3>
                <p class="section-copy">Chart ini dipakai untuk melihat apakah margin harian konsisten, atau sehat hanya karena beberapa hari yang sangat kuat.</p>
              </div>
            </div>
            <LineChart
              data={fin_margin_daily_30d}
              x="metric_date"
              y="margin_pct"
              title="Net Margin Harian 30 Hari (%)"
              yFmt="0.0\%"
              xAxisTitle="Tanggal"
              yAxisTitle="Net Margin (%)"
            >
              <ReferenceLine y={15} label="Target 15%" lineType="dashed" color="green" />
              <ReferenceLine y={10} label="Kritis 10%" lineType="dashed" color="red" />
            </LineChart>
          </div>

          <details>
            <summary>💡 Analisis & Langkah Konkret (30 Hari Terakhir)</summary>
            <div class="acc-body">
              <div class="acc-grid">
                <div>
                  <div class="acc-title-sub">📊 Konteks Analisis</div>
                  <div class="acc-text-block">
                    Tiga puluh hari adalah sweet spot untuk owner. Ia cukup panjang untuk mengurangi bias hari tertentu, tapi masih cukup dekat untuk mengarahkan tindakan operasional seperti pembelian, penjadwalan staf, pricing, dan promo.
                  </div>
                  <div style="margin-top: 16px; font-size: 0.8rem; color: var(--color-text-secondary); line-height: 1.5;">
                    Untuk melihat variasi antar cabang, buka halaman <a class="inline-link" href="/02-branch-performance">Performa Cabang</a>. Di halaman keuangan ini fokusnya tetap menjaga kesehatan margin total bisnis.
                  </div>
                </div>
                <div>
                  <div class="acc-title-sub">🎯 Rekomendasi Tindakan</div>
                  <div class="acc-alert-list">
                    {#if fin_cost_pct[0].bahan_30d > 32}
                      <div class="acc-alert-item">
                        <strong>🥩 Bahan di atas target ({fin_cost_pct[0].bahan_30d}% vs maks 32%):</strong> Prioritas pertama: cek item yang paling mendorong COGS, waste, dan pricing menu yang margin-nya tipis.
                      </div>
                    {/if}
                    {#if fin_cost_pct[0].sdm_30d > 22}
                      <div class="acc-alert-item" style="border-left-color: #f59e0b; background: rgba(245, 158, 11, 0.05);">
                        <strong>👥 SDM di atas target ({fin_cost_pct[0].sdm_30d}% vs maks 22%):</strong> Cek overtime, keselarasan shift schedule dengan volume transaksi harian.
                      </div>
                    {/if}
                    {#if fin_cost_pct[0].ops_30d > 15}
                      <div class="acc-alert-item">
                        <strong>⚙️ Operasional di atas target ({fin_cost_pct[0].ops_30d}% vs maks 15%):</strong> Ini sering berarti fixed cost terlalu berat untuk skala penjualan saat ini atau ada biaya rutin yang tidak lagi efisien.
                      </div>
                    {/if}
                    {#if fin_cost_pct[0].bahan_30d <= 32 && fin_cost_pct[0].sdm_30d <= 22 && fin_cost_pct[0].ops_30d <= 15}
                      <div class="acc-alert-item" style="border-left-color: #16a34a; background: rgba(22, 163, 74, 0.05);">
                        <strong>✅ Aman:</strong> Tidak ada komponen yang melewati target.
                      </div>
                    {/if}
                  </div>
                </div>
              </div>
            </div>
          </details>
        </div>
      </details>
    </div>
  {/if}

  <!-- ══════════════════════════════════════════
       PERSPEKTIF STRATEGIS (Accordion)
  ══════════════════════════════════════════ -->
  <div class="strategic-stack">
    <div class="strategic-header">
      <div class="strategic-eyebrow">🔭 Perspektif Strategis</div>
      <h2 class="strategic-title">Baca pola jangka panjang</h2>
      <p class="strategic-copy">Dua lens di bawah ini dirancang untuk pertanyaan yang lebih besar: apakah ada pola musiman yang perlu diantisipasi, dan apakah bisnis benar-benar membaik secara fundamental dari tahun ke tahun?</p>
    </div>

    <!-- Quarter Report Accordion -->
    <details class="acc-strategic">
      <summary>📊 Quarter Report · Baca Fenomena Musiman</summary>
      <div class="acc-body">

        {#each fin_quarter_comparison.slice(0, 1) as q}
          <div class="signal-card {q.margin_pct >= 15 ? 'safe' : q.margin_pct >= 10 ? 'warn' : 'critical'}" style="margin-bottom:16px;">
            <div class="signal-label">
              {q.margin_pct >= 15 ? '✅' : q.margin_pct >= 10 ? '⚠️' : '🚨'} Quarter Terkini
            </div>
            <div class="signal-title">{q.quarter_label} mencatat margin {q.margin_pct}%.</div>
            <div class="signal-copy">
              {#if q.delta_margin_q !== null}
                Margin bergerak {q.delta_margin_q > 0 ? 'naik' : 'turun'} {Math.abs(q.delta_margin_q)}pp dibanding quarter sebelumnya.
              {/if}
              {#if q.margin_pct >= 15}
                Ini memberi sinyal bahwa kualitas laba di level kuartal masih sehat.
              {:else if q.margin_pct >= 10}
                Masih bisa ditoleransi, tapi struktur biaya perlu dijaga sebelum masuk quarter berikutnya.
              {:else}
                Ini sinyal kuat bahwa masalahnya bukan lagi fluktuasi musiman biasa.
              {/if}
            </div>
          </div>
        {/each}

        <div class="mini-grid" style="margin-bottom:16px;">
          {#each fin_quarter_comparison.slice(0, 1) as q}
            <div class="mini-card">
              <div class="kpi-label">💰 Net Revenue</div>
              <div class="mini-value">Rp {q.net.toLocaleString('id-ID', { maximumFractionDigits: 0 })}</div>
              <div class="mini-note">{q.pct_change_net_q !== null ? `${q.pct_change_net_q > 0 ? '+' : ''}${q.pct_change_net_q}% vs quarter lalu` : 'Belum ada pembanding quarter sebelumnya.'}</div>
            </div>
            <div class="mini-card">
              <div class="kpi-label">🥩 Bahan</div>
              <div class="mini-value">{q.bahan_pct}%</div>
              <div class="mini-note">Porsi bahan terhadap gross revenue quarter terkini.</div>
            </div>
            <div class="mini-card">
              <div class="kpi-label">⚙️ Operasional</div>
              <div class="mini-value">{q.ops_pct}%</div>
              <div class="mini-note">Cocok untuk melihat apakah fixed cost mulai terasa berat saat musim berganti.</div>
            </div>
          {/each}
        </div>

        <div class="table-scroll-container">
          <table class="markdown">
            <thead>
              <tr>
                <th class="markdown">Quarter</th>
                <th class="markdown" style="text-align: right;">Gross Revenue (Rp)</th>
                <th class="markdown" style="text-align: right;">Net Revenue (Rp)</th>
                <th class="markdown" style="text-align: right;">Net Margin (%)</th>
                <th class="markdown" style="text-align: right;">vs Quarter Lalu</th>
                <th class="markdown" style="text-align: right;">Bahan (%)</th>
                <th class="markdown" style="text-align: right;">SDM (%)</th>
                <th class="markdown" style="text-align: right;">Ops (%)</th>
              </tr>
            </thead>
            <tbody>
              {#each fin_quarter_comparison || [] as row}
              <tr>
                <td class="markdown" style="font-weight: 500;">{row.quarter_label || ''}</td>
                <td class="markdown" style="text-align: right;">{row.gross !== undefined && row.gross !== null ? row.gross.toLocaleString('id-ID') : '0'}</td>
                <td class="markdown" style="text-align: right;">{row.net !== undefined && row.net !== null ? row.net.toLocaleString('id-ID') : '0'}</td>
                <td class="markdown" style="text-align: right; font-weight: 600;">{row.margin_pct !== undefined && row.margin_pct !== null ? row.margin_pct.toFixed(1) + '%' : '0.0%'}</td>
                <td class="markdown" style="text-align: right; font-weight: 600; color: {row.delta_margin_q > 0 ? '#16a34a' : row.delta_margin_q < 0 ? '#dc2626' : 'var(--color-text-tertiary)'}">
                  {row.delta_margin_q !== undefined && row.delta_margin_q !== null ? (row.delta_margin_q > 0 ? '+' : '') + row.delta_margin_q.toFixed(1) + 'pp ' + (row.delta_margin_q > 0 ? '▲' : row.delta_margin_q < 0 ? '▼' : '') : '—'}
                </td>
                <td class="markdown" style="text-align: right;">{row.bahan_pct !== undefined && row.bahan_pct !== null ? row.bahan_pct.toFixed(1) + '%' : '0.0%'}</td>
                <td class="markdown" style="text-align: right;">{row.sdm_pct !== undefined && row.sdm_pct !== null ? row.sdm_pct.toFixed(1) + '%' : '0.0%'}</td>
                <td class="markdown" style="text-align: right;">{row.ops_pct !== undefined && row.ops_pct !== null ? row.ops_pct.toFixed(1) + '%' : '0.0%'}</td>
              </tr>
              {/each}
            </tbody>
          </table>
        </div>

        <div style="margin-top:18px;">
          <LineChart
            data={fin_quarter}
            x="quarter_label"
            y="margin_pct"
            sort=false
            title="Net Margin per Quarter (%)"
            yFmt="0.0\%"
            xAxisTitle="Quarter"
            yAxisTitle="Net Margin (%)"
          />
          <div class="chart-insight">
            📌 <strong>Cara membaca chart ini:</strong> Perhatikan apakah ada quarter tertentu yang selalu lebih lemah — itu sinyal musiman. Kalau pola margin turun konsisten di Q1 atau Q3, misalnya, itu bukan kesalahan operasional tetapi ritme kalender yang bisa diantisipasi dengan manajemen biaya lebih ketat di periode tersebut.
          </div>
        </div>

        <div style="margin-top:18px;">
          <BarChart
            data={fin_quarter}
            x="quarter_label"
            y={["bahan_pct","sdm_pct","ops_pct"]}
            sort=false
            type="stacked"
            title="Struktur Biaya per Quarter (%)"
            yFmt="0.0\%"
            xAxisTitle="Quarter"
            yAxisTitle="% dari Gross Revenue"
          />
          <div class="chart-insight">
            📌 <strong>Cara membaca chart ini:</strong> Stacked bar memperlihatkan komposisi total beban biaya di tiap quarter. Kalau total bar makin tinggi tapi margin makin turun, artinya biaya tumbuh lebih cepat dari revenue. Fokus pada komponen mana yang "tumbuh" paling cepat antar quarter — bahan, SDM, atau operasional.
          </div>
        </div>

      </div>
    </details>

    <!-- YoY Accordion -->
    <details class="acc-strategic">
      <summary>📅 Year-over-Year · Baca Tren Fundamental</summary>
      <div class="acc-body">

        {#if fin_yoy.length >= 2}
          {#each fin_yoy.slice(0, 1) as yr}
            {#each fin_yoy.slice(1, 2) as yr_prev}
              <div class="signal-card {yr.margin_pct > yr_prev.margin_pct ? 'safe' : yr.margin_pct < yr_prev.margin_pct ? 'warn' : 'neutral'}" style="margin-bottom:16px;">
                <div class="signal-label">
                  {yr.margin_pct > yr_prev.margin_pct ? '📈' : yr.margin_pct < yr_prev.margin_pct ? '📉' : '➡️'} Tahun Terkini
                </div>
                <div class="signal-title">Margin {yr.tahun}: {yr.margin_pct}%.</div>
                <div class="signal-copy">
                  {#if yr.margin_pct > yr_prev.margin_pct}
                    Naik {Math.round((yr.margin_pct - yr_prev.margin_pct) * 10) / 10}pp dibanding {yr_prev.tahun}. Ini tanda baik bahwa perbaikan tidak hanya musiman, tetapi mulai terasa di level fundamental.
                  {:else if yr.margin_pct < yr_prev.margin_pct}
                    Turun {Math.round((yr_prev.margin_pct - yr.margin_pct) * 10) / 10}pp dibanding {yr_prev.tahun}. Artinya pertumbuhan belum otomatis membuat bisnis lebih efisien.
                  {:else}
                    Margin setara dengan {yr_prev.tahun}. Stabil, tetapi belum menunjukkan pergeseran kualitas laba.
                  {/if}
                </div>
              </div>
            {/each}
          {/each}
        {/if}

        <div class="table-scroll-container">
          <table class="markdown">
            <thead>
              <tr>
                <th class="markdown">Tahun</th>
                <th class="markdown" style="text-align: right;">Gross Revenue (Rp)</th>
                <th class="markdown" style="text-align: right;">Net Revenue (Rp)</th>
                <th class="markdown" style="text-align: right;">Net Margin (%)</th>
                <th class="markdown" style="text-align: right;">Bahan (%)</th>
                <th class="markdown" style="text-align: right;">SDM (%)</th>
                <th class="markdown" style="text-align: right;">Ops (%)</th>
              </tr>
            </thead>
            <tbody>
              {#each fin_yoy || [] as row}
              <tr>
                <td class="markdown" style="font-weight: 500;">{row.tahun || ''}</td>
                <td class="markdown" style="text-align: right;">{row.gross !== undefined && row.gross !== null ? row.gross.toLocaleString('id-ID') : '0'}</td>
                <td class="markdown" style="text-align: right;">{row.net !== undefined && row.net !== null ? row.net.toLocaleString('id-ID') : '0'}</td>
                <td class="markdown" style="text-align: right; font-weight: 600;">{row.margin_pct !== undefined && row.margin_pct !== null ? row.margin_pct.toFixed(1) + '%' : '0.0%'}</td>
                <td class="markdown" style="text-align: right;">{row.bahan_pct !== undefined && row.bahan_pct !== null ? row.bahan_pct.toFixed(1) + '%' : '0.0%'}</td>
                <td class="markdown" style="text-align: right;">{row.sdm_pct !== undefined && row.sdm_pct !== null ? row.sdm_pct.toFixed(1) + '%' : '0.0%'}</td>
                <td class="markdown" style="text-align: right;">{row.ops_pct !== undefined && row.ops_pct !== null ? row.ops_pct.toFixed(1) + '%' : '0.0%'}</td>
              </tr>
              {/each}
            </tbody>
          </table>
        </div>

        <LineChart
          data={fin_yoy}
          x="tahun"
          y="margin_pct"
          title="Net Margin per Tahun (%)"
          yFmt="0.0\%"
          xAxisTitle="Tahun"
          yAxisTitle="Net Margin (%)"
        />
        <div class="chart-insight">
          📌 <strong>Cara membaca chart ini:</strong> Tren naik yang konsisten berarti bisnis secara fundamental makin efisien. Tren turun — walaupun revenue naik — biasanya berarti struktur biaya tumbuh lebih cepat dari omset, atau ada beban baru (ekspansi, inflasi SDM, kenaikan harga bahan) yang belum terimbangi oleh kenaikan harga jual.
        </div>

        <div style="margin-top:18px;">
          <BarChart
            data={fin_yoy}
            x="tahun"
            y={["bahan_pct","sdm_pct","ops_pct"]}
            type="stacked"
            title="Struktur Biaya per Tahun (%)"
            yFmt="0.0\%"
            xAxisTitle="Tahun"
            yAxisTitle="% dari Gross Revenue"
          />
          <div class="chart-insight">
            📌 <strong>Cara membaca chart ini:</strong> Kalau total stacked bar naik dari tahun ke tahun, artinya beban biaya makin besar relatif terhadap revenue — sinyal bahwa efisiensi operasional perlu diperhatikan lebih serius. Sebaliknya, total yang menyusut menandakan bisnis makin lean tanpa mengorbankan kualitas.
          </div>
        </div>

      </div>
    </details>

  </div>

</div>
{/if}