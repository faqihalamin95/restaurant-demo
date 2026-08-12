---
title: Financial Report
---

<FinanceTabs activeTab="overview" />

<style>


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

.cost-cta {
  display: block;
  text-align: center;
  margin-top: 16px;
  padding: 8px;
  background: var(--color-background-primary);
  border: 1px solid var(--color-border-tertiary);
  border-radius: 8px;
  color: var(--color-text-primary);
  font-weight: 700;
  font-size: 0.8rem;
  text-decoration: none;
  transition: all 0.2s ease;
}
.cost-cta:hover {
  background: var(--color-background-tertiary);
  border-color: var(--color-text-tertiary);
}
.trend-indicator.down { color: #dc2626; }

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
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 0 1px 3px rgba(0,0,0,0.05);
  display: flex;
  flex-direction: column;
}
.cost-card:hover {
  transform: translateY(-3px);
  box-shadow: 0 10px 25px -5px rgba(13, 148, 136, 0.15), 0 8px 10px -6px rgba(13, 148, 136, 0.1);
  border-color: rgba(13, 148, 136, 0.4);
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

.cost-cta {
  display: inline-block;
  margin-top: 14px;
  padding: 6px 14px;
  font-size: 0.75rem;
  font-weight: 600;
  color: var(--color-text-secondary);
  text-decoration: none;
  border: 1.5px solid var(--color-border-tertiary);
  border-radius: 8px;
  background: white;
  transition: all 0.2s ease;
  width: max-content;
}
.cost-cta:hover {
  color: #0d9488;
  border-color: #0d9488;
  background: rgba(13, 148, 136, 0.05);
  box-shadow: 0 4px 12px rgba(13, 148, 136, 0.1);
  transform: translateX(3px);
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
  margin-top: 48px;
}

.diagnostics-header {
  padding: 0 2px;
  margin-bottom: 0;
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
        WHEN 1 THEN 'January' WHEN 2 THEN 'February' WHEN 3 THEN 'March'
        WHEN 4 THEN 'April'   WHEN 5 THEN 'May'      WHEN 6 THEN 'June'
        WHEN 7 THEN 'July'    WHEN 8 THEN 'August'  WHEN 9 THEN 'September'
        WHEN 10 THEN 'October' WHEN 11 THEN 'November' WHEN 12 THEN 'December'
    END || ' ' || YEAR(MAX(metric_date))                        AS tgl_display,
    CASE DAYNAME(MAX(metric_date))
        WHEN 'Monday' THEN 'Monday' WHEN 'Tuesday' THEN 'Tuesday'
        WHEN 'Wednesday' THEN 'Wednesday' WHEN 'Thursday' THEN 'Thursday'
        WHEN 'Friday' THEN 'Friday' WHEN 'Saturday' THEN 'Saturday'
        WHEN 'Sunday' THEN 'Sunday'
    END                                                         AS nama_hari
FROM restaurant.daily_net_revenue
```

```sql target_recommendation
WITH max_d AS (SELECT MAX(metric_date)::DATE AS d FROM restaurant.daily_net_revenue),
last_3_months AS (
    SELECT 
        DATE_TRUNC('month', metric_date) AS month_date,
        SUM(gross_revenue) as monthly_gross
    FROM restaurant.daily_net_revenue
    CROSS JOIN max_d
    WHERE metric_date >= DATE_TRUNC('month', d - INTERVAL '3 months')
      AND metric_date < DATE_TRUNC('month', d)
    GROUP BY DATE_TRUNC('month', metric_date)
)
SELECT ROUND(AVG(monthly_gross), 0) AS recommended_target
FROM last_3_months
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
WITH max_d AS (SELECT MAX(metric_date)::DATE AS d FROM restaurant.daily_net_revenue),
bulan_ini AS (SELECT DATE_TRUNC('month', d) AS akhir FROM max_d),
bulan_lalu AS (SELECT LAST_DAY(d - INTERVAL '1 month') AS akhir FROM max_d)
SELECT
    CASE MONTH(b.akhir)
        WHEN 1 THEN 'January' WHEN 2 THEN 'February' WHEN 3 THEN 'March'
        WHEN 4 THEN 'April'   WHEN 5 THEN 'May'      WHEN 6 THEN 'June'
        WHEN 7 THEN 'July'    WHEN 8 THEN 'August'  WHEN 9 THEN 'September'
        WHEN 10 THEN 'October' WHEN 11 THEN 'November' WHEN 12 THEN 'December'
    END AS nama_bulan,
    CASE MONTH(l.akhir)
        WHEN 1 THEN 'January' WHEN 2 THEN 'February' WHEN 3 THEN 'March'
        WHEN 4 THEN 'April'   WHEN 5 THEN 'May'      WHEN 6 THEN 'June'
        WHEN 7 THEN 'July'    WHEN 8 THEN 'August'  WHEN 9 THEN 'September'
        WHEN 10 THEN 'October' WHEN 11 THEN 'November' WHEN 12 THEN 'December'
    END AS nama_bulan_lalu
FROM bulan_ini b, bulan_lalu l
```

```sql target_recommendation
WITH max_d AS (SELECT MAX(metric_date)::DATE AS d FROM restaurant.daily_net_revenue),
last_3_months AS (
    SELECT 
        DATE_TRUNC('month', metric_date) AS month_date,
        SUM(gross_revenue) as monthly_gross
    FROM restaurant.daily_net_revenue
    CROSS JOIN max_d
    WHERE metric_date >= DATE_TRUNC('month', d - INTERVAL '3 months')
      AND metric_date < DATE_TRUNC('month', d)
    GROUP BY DATE_TRUNC('month', metric_date)
)
SELECT ROUND(AVG(monthly_gross), 0) AS recommended_target
FROM last_3_months
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

```sql fin_cost_trend_mtd
WITH max_d AS (SELECT MAX(metric_date)::DATE AS d FROM restaurant.daily_net_revenue)
SELECT metric_date, '1. Material (COGS)' AS cost_type, ROUND(SUM(inventory_usage_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS cost_pct
FROM restaurant.daily_net_revenue CROSS JOIN max_d
WHERE DATE_TRUNC('month', metric_date) = DATE_TRUNC('month', d)
GROUP BY metric_date
UNION ALL
SELECT metric_date, '2. Human Resources (HR)' AS cost_type, ROUND(SUM(labor_total_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS cost_pct
FROM restaurant.daily_net_revenue CROSS JOIN max_d
WHERE DATE_TRUNC('month', metric_date) = DATE_TRUNC('month', d)
GROUP BY metric_date
UNION ALL
SELECT metric_date, '3. Operational (OPEX)' AS cost_type, ROUND(SUM(operational_total_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS cost_pct
FROM restaurant.daily_net_revenue CROSS JOIN max_d
WHERE DATE_TRUNC('month', metric_date) = DATE_TRUNC('month', d)
GROUP BY metric_date
ORDER BY metric_date, cost_type
```

```sql fin_cost_trend_30d
WITH max_d AS (SELECT MAX(metric_date)::DATE AS d FROM restaurant.daily_net_revenue)
SELECT metric_date, '1. Material (COGS)' AS cost_type, ROUND(SUM(inventory_usage_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS cost_pct
FROM restaurant.daily_net_revenue CROSS JOIN max_d
WHERE metric_date >= d - INTERVAL '29 days'
GROUP BY metric_date
UNION ALL
SELECT metric_date, '2. Human Resources (HR)' AS cost_type, ROUND(SUM(labor_total_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS cost_pct
FROM restaurant.daily_net_revenue CROSS JOIN max_d
WHERE metric_date >= d - INTERVAL '29 days'
GROUP BY metric_date
UNION ALL
SELECT metric_date, '3. Operational (OPEX)' AS cost_type, ROUND(SUM(operational_total_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS cost_pct
FROM restaurant.daily_net_revenue CROSS JOIN max_d
WHERE metric_date >= d - INTERVAL '29 days'
GROUP BY metric_date
ORDER BY metric_date, cost_type
```

```sql fin_cost_trend_90d
WITH max_d AS (SELECT MAX(metric_date)::DATE AS d FROM restaurant.daily_net_revenue)
SELECT metric_date, '1. Material (COGS)' AS cost_type, ROUND(SUM(inventory_usage_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS cost_pct
FROM restaurant.daily_net_revenue CROSS JOIN max_d
WHERE metric_date >= d - INTERVAL '89 days'
GROUP BY metric_date
UNION ALL
SELECT metric_date, '2. Human Resources (HR)' AS cost_type, ROUND(SUM(labor_total_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS cost_pct
FROM restaurant.daily_net_revenue CROSS JOIN max_d
WHERE metric_date >= d - INTERVAL '89 days'
GROUP BY metric_date
UNION ALL
SELECT metric_date, '3. Operational (OPEX)' AS cost_type, ROUND(SUM(operational_total_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS cost_pct
FROM restaurant.daily_net_revenue CROSS JOIN max_d
WHERE metric_date >= d - INTERVAL '89 days'
GROUP BY metric_date
ORDER BY metric_date, cost_type
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
    CASE WHEN m.margin_mtd >= 15 THEN 'Healthy' WHEN m.margin_mtd >= 10 THEN 'Warning' ELSE 'Critical' END AS status_mtd,
    CASE
        WHEN m.bahan_mtd <= 32 AND m.sdm_mtd <= 22 AND m.ops_mtd <= 25 THEN 'All costs within limits'
        WHEN m.bahan_mtd - 32 >= m.sdm_mtd - 22 AND m.bahan_mtd - 32 >= m.ops_mtd - 25 THEN 'Ingredient Cost'
        WHEN m.sdm_mtd - 22 >= m.ops_mtd - 25 THEN 'Labor Cost'
        ELSE 'Operational cost'
    END AS fokus_mtd,
    CASE
        WHEN m.bahan_mtd <= 32 AND m.sdm_mtd <= 22 AND m.ops_mtd <= 25 THEN 0
        WHEN m.bahan_mtd - 32 >= m.sdm_mtd - 22 AND m.bahan_mtd - 32 >= m.ops_mtd - 25 THEN ROUND(m.bahan_mtd - 32, 1)
        WHEN m.sdm_mtd - 22 >= m.ops_mtd - 25 THEN ROUND(m.sdm_mtd - 22, 1)
        ELSE ROUND(m.ops_mtd - 25, 1)
    END AS fokus_gap_mtd,
    CASE WHEN r.margin_30d >= 15 THEN 'Healthy' WHEN r.margin_30d >= 10 THEN 'Warning' ELSE 'Critical' END AS status_30d,
    CASE
        WHEN r.bahan_30d <= 32 AND r.sdm_30d <= 22 AND r.ops_30d <= 25 THEN 'All costs within limits'
        WHEN r.bahan_30d - 32 >= r.sdm_30d - 22 AND r.bahan_30d - 32 >= r.ops_30d - 25 THEN 'Ingredient Cost'
        WHEN r.sdm_30d - 22 >= r.ops_30d - 25 THEN 'Labor Cost'
        ELSE 'Operational cost'
    END AS fokus_30d,
    CASE
        WHEN r.bahan_30d <= 32 AND r.sdm_30d <= 22 AND r.ops_30d <= 25 THEN 0
        WHEN r.bahan_30d - 32 >= r.sdm_30d - 22 AND r.bahan_30d - 32 >= r.ops_30d - 25 THEN ROUND(r.bahan_30d - 32, 1)
        WHEN r.sdm_30d - 22 >= r.ops_30d - 25 THEN ROUND(r.sdm_30d - 22, 1)
        ELSE ROUND(r.ops_30d - 25, 1)
    END AS fokus_gap_30d,
    CASE WHEN r.margin_90d >= 15 THEN 'Healthy' WHEN r.margin_90d >= 10 THEN 'Warning' ELSE 'Critical' END AS status_90d,
    CASE
        WHEN r.bahan_90d <= 32 AND r.sdm_90d <= 22 AND r.ops_90d <= 25 THEN 'All costs within limits'
        WHEN r.bahan_90d - 32 >= r.sdm_90d - 22 AND r.bahan_90d - 32 >= r.ops_90d - 25 THEN 'Ingredient Cost'
        WHEN r.sdm_90d - 22 >= r.ops_90d - 25 THEN 'Labor Cost'
        ELSE 'Operational cost'
    END AS fokus_90d,
    CASE
        WHEN r.bahan_90d <= 32 AND r.sdm_90d <= 22 AND r.ops_90d <= 25 THEN 0
        WHEN r.bahan_90d - 32 >= r.sdm_90d - 22 AND r.bahan_90d - 32 >= r.ops_90d - 25 THEN ROUND(r.bahan_90d - 32, 1)
        WHEN r.sdm_90d - 22 >= r.ops_90d - 25 THEN ROUND(r.sdm_90d - 22, 1)
        ELSE ROUND(r.ops_90d - 25, 1)
    END AS fokus_gap_90d
FROM mtd m
CROSS JOIN rolling r
```

_Business financial health: margins, cost pressures, and seasonal context on one page._


{#if fin_operational_overview.length > 0}
<div class="finance-page">




  </div>
    <div class="hero">
      <div class="hero-eyebrow">📊 Financial Health · {fin_dates[0].tgl_30d_awal} - {fin_dates[0].tgl_akhir}</div>
      <div class="hero-grid">
        <div class="hero-main-card {fin_kpi[0].margin_30d >= 10 ? 'status-sehat' : fin_kpi[0].margin_30d >= 5 ? 'status-waspada' : 'status-kritis'}">
          <div class="hero-stat-number">{fin_kpi[0].margin_30d}%</div>
          <div class="hero-subtitle">
            {#if fin_kpi[0].margin_30d >= 10}
              Operating margins remain healthy.
            {:else if fin_kpi[0].margin_30d >= 5}
              30-Day Margin has entered the warning zone.
            {:else}
              Operating margin is critically low.
            {/if}
          </div>
        </div>

        <div class="hero-side">
          <div class="hero-side-card">
            <div class="hero-side-label">💰 Operating Profit</div>
            <div class="hero-side-value" style="font-size: 1.15rem; font-weight: 800;">Rp {fin_kpi[0].net_30d.toLocaleString('en-US', { maximumFractionDigits: 0 })}</div>
            <div class="hero-side-note">Profit after deducting total Ingredient, Labor, & OPEX costs.</div>
          </div>
          <div class="hero-side-card">
            <div class="hero-side-label">💵 Daily Average</div>
            <div class="hero-side-value" style="font-size: 1.15rem; font-weight: 800;">Rp {Math.round(fin_kpi[0].gross_30d / 30).toLocaleString('en-US', { maximumFractionDigits: 0 })} / day</div>
            <div class="hero-side-note" style="margin-top: 4px;">Total accumulated sales: Rp {fin_kpi[0].gross_30d.toLocaleString('en-US', { maximumFractionDigits: 0 })}</div>
          </div>
        </div>
      </div>
    </div>



    <!-- Outer Diagnostics Container -->
    <div class="diagnostics-stack">
      <div class="diagnostics-header">
        <div class="diagnostics-eyebrow">🔬 Operations & Diagnostics</div>
<h2 class="diagnostics-title">Performance breakdown & cost details</h2>
        <p class="diagnostics-copy">Use the tools below to audit expenditure patterns, monitor operational alerts, and track margin trends.</p>
      </div>


      <div style="display: flex; flex-direction: column; gap: 40px; margin-top: 8px;">

          <div class="section-card">
            <div class="section-head" style="margin-bottom: 0;">
      <div>
        <div class="section-eyebrow" style="color: #000000;">🎯 This Month's Revenue Target Achievement</div>
        <h3 class="section-title" style="color: #000000;">Monitor Daily Revenue Pacing</h3>
        <p class="section-copy" style="color: #000000;">Compare the current revenue pace with the proportion of days to ensure the end-of-month target is met.</p>
      </div>

    </div>
    <div style="display: flex; flex-direction: column; gap: 12px; margin-top: 20px; padding: 24px; background: rgba(13, 148, 136, 0.04); border: 1px solid rgba(13, 148, 136, 0.15); border-radius: 16px;">
      <div style="display: flex; justify-content: space-between; align-items: flex-end;">
        <div>
          <div style="font-size: 0.9rem; color: var(--color-text-secondary); margin-bottom: 4px;">Current Revenue</div>
          <div style="font-size: 2.2rem; font-weight: 800; color: var(--color-text-primary); line-height: 1;"><Value data={fin_kpi_mtd} column=gross_mtd fmt=idr /></div>
        </div>
        <div style="text-align: right;">
          <div style="font-size: 0.9rem; color: var(--color-text-secondary); margin-bottom: 4px;">End of Month Target ({fin_nama_bulan[0].nama_bulan})</div>
          <div style="font-size: 1.2rem; font-weight: 700; color: var(--color-text-tertiary);">Rp {(target_recommendation[0]?.recommended_target || 1500000000).toLocaleString('en-US')}</div>
        </div>
      </div>
      
      <div style="position: relative; height: 12px; background: rgba(0,0,0,0.05); border-radius: 999px; overflow: hidden; margin-top: 8px;">
        <div style="position: absolute; left: 0; top: 0; height: 100%; width: {Math.min((fin_kpi_mtd[0].gross_mtd / (target_recommendation[0]?.recommended_target || 1500000000)) * 100, 100)}%; background: linear-gradient(90deg, #0d9488, #2dd4bf); border-radius: 999px; transition: width 1s ease-out;"></div>
        <div style="position: absolute; left: {(fin_kpi_mtd[0].hari_berjalan / fin_kpi_mtd[0].total_hari_bulan) * 100}%; top: -2px; bottom: -2px; width: 3px; background: #f43f5e; border-radius: 999px; box-shadow: 0 0 4px rgba(244,63,94,0.5); z-index: 10;"></div>
      </div>
      
      <div style="display: flex; justify-content: space-between; font-size: 0.8rem;">
        <span style="color: #000000; font-weight: 600;">Achieved: <strong>{Math.round((fin_kpi_mtd[0].gross_mtd / (target_recommendation[0]?.recommended_target || 1500000000)) * 1000) / 10}%</strong></span>
        <div style="display: flex; align-items: center; gap: 4px; color: var(--color-text-secondary);">
          <span style="display: inline-block; width: 8px; height: 8px; background: #f43f5e; border-radius: 50%;"></span>
          Pacing Day {fin_kpi_mtd[0].hari_berjalan}: {Math.round((fin_kpi_mtd[0].hari_berjalan / fin_kpi_mtd[0].total_hari_bulan) * 100)}%
        </div>
      </div>
      
      <div class="chart-insight-bar">
        📌 <strong>Target Calculation:</strong> The end-of-month target is calculated automatically using your average revenue from the last 3 full months.
      </div>
    </div>

            <hr style="margin: 32px 0; border: none; border-top: 1px dashed var(--color-border-tertiary);" />

            <div class="section-head">
              <div>
                <div class="section-eyebrow">💸 Cost Breakdown</div>
                <h3 class="section-title">Cost structure over the last 30 days</h3>
                <p class="section-copy">For every Rp100 of gross sales earned in the last 30 days, see how much goes toward ingredients, labor, and operations.</p>
              </div>
            </div>
            <div class="cost-grid">
              <div class="cost-card" style="background: {fin_cost_pct[0].bahan_30d < 25 ? 'linear-gradient(180deg, rgba(254,252,232,0.9), rgba(254,249,195,0.6))' : fin_cost_pct[0].bahan_30d <= 30 ? 'linear-gradient(180deg, rgba(240,253,244,0.9), rgba(220,252,231,0.6))' : fin_cost_pct[0].bahan_30d <= 35 ? 'linear-gradient(180deg, rgba(254,252,232,0.9), rgba(254,249,195,0.6))' : 'linear-gradient(180deg, rgba(254,242,242,0.9), rgba(254,226,226,0.6))'}; border-color: {fin_cost_pct[0].bahan_30d < 25 ? 'rgba(234,179,8,0.5)' : fin_cost_pct[0].bahan_30d <= 30 ? 'rgba(34,197,94,0.5)' : fin_cost_pct[0].bahan_30d <= 35 ? 'rgba(234,179,8,0.5)' : 'rgba(239,68,68,0.5)'};">
                <div class="cost-label">🥩 Ingredient Cost</div>
                <div class="cost-value" style="color:{fin_cost_pct[0].bahan_30d < 25 ? '#ea580c' : fin_cost_pct[0].bahan_30d <= 30 ? '#16a34a' : fin_cost_pct[0].bahan_30d <= 35 ? '#ea580c' : '#dc2626'};">{(Number(fin_cost_pct[0].bahan_30d)).toFixed(1)}%</div>
                <div class="cost-target">🎯 Target: Max 30%</div>
                <div class="progress-track">
                  <div class="progress-fill" style="width:{Math.min(fin_cost_pct[0].bahan_30d / 40 * 100, 100)}%; background:{fin_cost_pct[0].bahan_30d < 25 ? 'linear-gradient(90deg,#f59e0b,#fde68a)' : fin_cost_pct[0].bahan_30d <= 30 ? 'linear-gradient(90deg,#16a34a,#86efac)' : fin_cost_pct[0].bahan_30d <= 35 ? 'linear-gradient(90deg,#f59e0b,#fde68a)' : 'linear-gradient(90deg,#ef4444,#fca5a5)'};"></div>
                  <div class="progress-target" style="left:{30 / 40 * 100}%;"></div>
                </div>
                <div class="progress-scale"><span>0%</span><span>30%</span><span>40%</span></div>
                <a href="/01-financial-report/02-cost-breakdown?rincian-biaya-tabs=🥩 Ingredient Costs" class="cost-cta">View Details ➔</a>
                <div class="cost-note">
                  <div style="font-size: 0.82rem; font-weight: 600; color: {fin_cost_pct[0].bahan_30d < 25 ? '#ea580c' : fin_cost_pct[0].bahan_30d <= 30 ? '#16a34a' : fin_cost_pct[0].bahan_30d <= 35 ? '#ea580c' : '#dc2626'};">
                    {fin_cost_pct[0].bahan_30d < 25 ? '👀 Low Cost (<25%)' : fin_cost_pct[0].bahan_30d <= 30 ? '⭐ Ideal Zone (25-30%)' : fin_cost_pct[0].bahan_30d <= 35 ? '⚠️ Watch Zone (30-35%)' : '📉 Critical High (>35%)'}
                  </div>
                  <div style="font-size: 0.78rem; color: var(--color-text-secondary); margin-top: 4px; line-height: 1.4;">
                    {fin_cost_pct[0].bahan_30d < 25 ? 'Ratio below target. Verify portion size consistency.' : fin_cost_pct[0].bahan_30d <= 30 ? 'Efficient ratio. Maintain current recipe standards.' : fin_cost_pct[0].bahan_30d <= 35 ? 'Ratio is rising. Review daily ingredient usage.' : 'Ratio above standard. Check for waste or procurement issues.'}
                  </div>
                  <div style="margin-top: 8px;">
                    {#if fin_cost_pct[0].delta_bahan_30d > 0}
                      <span class="trend-indicator down">▲ +{String(fin_cost_pct[0].delta_bahan_30d)}%</span>
                    {:else if fin_cost_pct[0].delta_bahan_30d < 0}
                      <span class="trend-indicator up">▼ {String(fin_cost_pct[0].delta_bahan_30d)}%</span>
                    {:else}
                      <span class="trend-indicator neutral">0.0%</span>
                    {/if}
                    <span style="font-size: 0.78rem; color: var(--color-text-secondary);"> vs previous 30 days</span>
                  </div>
                </div>
              </div>
              <div class="cost-card" style="background: {fin_cost_pct[0].sdm_30d < 15 ? 'linear-gradient(180deg, rgba(254,242,242,0.9), rgba(254,226,226,0.6))' : fin_cost_pct[0].sdm_30d < 20 ? 'linear-gradient(180deg, rgba(254,252,232,0.9), rgba(254,249,195,0.6))' : fin_cost_pct[0].sdm_30d <= 30 ? 'linear-gradient(180deg, rgba(240,253,244,0.9), rgba(220,252,231,0.6))' : fin_cost_pct[0].sdm_30d <= 35 ? 'linear-gradient(180deg, rgba(254,252,232,0.9), rgba(254,249,195,0.6))' : 'linear-gradient(180deg, rgba(254,242,242,0.9), rgba(254,226,226,0.6))'}; border-color: {fin_cost_pct[0].sdm_30d < 15 ? 'rgba(239,68,68,0.5)' : fin_cost_pct[0].sdm_30d < 20 ? 'rgba(234,179,8,0.5)' : fin_cost_pct[0].sdm_30d <= 30 ? 'rgba(34,197,94,0.5)' : fin_cost_pct[0].sdm_30d <= 35 ? 'rgba(234,179,8,0.5)' : 'rgba(239,68,68,0.5)'};">
                <div class="cost-label">👥 Labor Cost</div>
                <div class="cost-value" style="color:{fin_cost_pct[0].sdm_30d < 15 ? '#dc2626' : fin_cost_pct[0].sdm_30d < 20 ? '#ea580c' : fin_cost_pct[0].sdm_30d <= 30 ? '#16a34a' : fin_cost_pct[0].sdm_30d <= 35 ? '#ea580c' : '#dc2626'};">{(Number(fin_cost_pct[0].sdm_30d)).toFixed(1)}%</div>
                <div class="cost-target">🎯 Target: Max 30%</div>
                <div class="progress-track">
                  <div class="progress-fill" style="width:{Math.min(fin_cost_pct[0].sdm_30d / 35 * 100, 100)}%; background:{fin_cost_pct[0].sdm_30d < 15 ? 'linear-gradient(90deg,#ef4444,#fca5a5)' : fin_cost_pct[0].sdm_30d < 20 ? 'linear-gradient(90deg,#f59e0b,#fde68a)' : fin_cost_pct[0].sdm_30d <= 30 ? 'linear-gradient(90deg,#16a34a,#86efac)' : fin_cost_pct[0].sdm_30d <= 35 ? 'linear-gradient(90deg,#f59e0b,#fde68a)' : 'linear-gradient(90deg,#ef4444,#fca5a5)'};"></div>
                  <div class="progress-target" style="left:{30 / 35 * 100}%;"></div>
                </div>
                <div class="progress-scale"><span>0%</span><span>30%</span><span>35%</span></div>
                <a href="/01-financial-report/02-cost-breakdown?rincian-biaya-tabs=👥 Labor Costs" class="cost-cta">View Details ➔</a>
                <div class="cost-note">
                  <div style="font-size: 0.82rem; font-weight: 600; color: {fin_cost_pct[0].sdm_30d < 15 ? '#dc2626' : fin_cost_pct[0].sdm_30d < 20 ? '#ea580c' : fin_cost_pct[0].sdm_30d <= 30 ? '#16a34a' : fin_cost_pct[0].sdm_30d <= 35 ? '#ea580c' : '#dc2626'};">
                    {fin_cost_pct[0].sdm_30d < 15 ? '🚨 Critical Low (<15%)' : fin_cost_pct[0].sdm_30d < 20 ? '👀 Low Cost (15-20%)' : fin_cost_pct[0].sdm_30d <= 30 ? '⭐ Ideal Zone (20-30%)' : fin_cost_pct[0].sdm_30d <= 35 ? '⚠️ Watch Zone (30-35%)' : '📉 Critical High (>35%)'}
                  </div>
                  <div style="font-size: 0.78rem; color: var(--color-text-secondary); margin-top: 4px; line-height: 1.4;">
                    {fin_cost_pct[0].sdm_30d < 15 ? 'Ratio is very low. Operational and service risks increase.' : fin_cost_pct[0].sdm_30d < 20 ? 'Ratio below target. Watch for potential staff burnout.' : fin_cost_pct[0].sdm_30d <= 30 ? 'Staff expenditure is efficient. Maintain productivity.' : fin_cost_pct[0].sdm_30d <= 35 ? 'Ratio is rising. Review overtime and shift schedules.' : 'High labor cost. Evaluate team structure and shift efficiency.'}
                  </div>
                  <div style="margin-top: 8px;">
                    {#if fin_cost_pct[0].delta_sdm_30d > 0}
                      <span class="trend-indicator down">▲ +{String(fin_cost_pct[0].delta_sdm_30d)}%</span>
                    {:else if fin_cost_pct[0].delta_sdm_30d < 0}
                      <span class="trend-indicator up">▼ {String(fin_cost_pct[0].delta_sdm_30d)}%</span>
                    {:else}
                      <span class="trend-indicator neutral">0.0%</span>
                    {/if}
                    <span style="font-size: 0.78rem; color: var(--color-text-secondary);"> vs previous 30 days</span>
                  </div>
                </div>
              </div>
              <div class="cost-card" style="background: {fin_cost_pct[0].ops_30d < 25 ? 'linear-gradient(180deg, rgba(254,252,232,0.9), rgba(254,249,195,0.6))' : fin_cost_pct[0].ops_30d <= 30 ? 'linear-gradient(180deg, rgba(240,253,244,0.9), rgba(220,252,231,0.6))' : fin_cost_pct[0].ops_30d <= 35 ? 'linear-gradient(180deg, rgba(254,252,232,0.9), rgba(254,249,195,0.6))' : 'linear-gradient(180deg, rgba(254,242,242,0.9), rgba(254,226,226,0.6))'}; border-color: {fin_cost_pct[0].ops_30d < 25 ? 'rgba(234,179,8,0.5)' : fin_cost_pct[0].ops_30d <= 30 ? 'rgba(34,197,94,0.5)' : fin_cost_pct[0].ops_30d <= 35 ? 'rgba(234,179,8,0.5)' : 'rgba(239,68,68,0.5)'};">
                <div class="cost-label">⚙️ Overhead Cost</div>
                <div class="cost-value" style="color:{fin_cost_pct[0].ops_30d < 25 ? '#ea580c' : fin_cost_pct[0].ops_30d <= 30 ? '#16a34a' : fin_cost_pct[0].ops_30d <= 35 ? '#ea580c' : '#dc2626'};">{(Number(fin_cost_pct[0].ops_30d)).toFixed(1)}%</div>
                <div class="cost-target">🎯 Target: Max 30%</div>
                <div class="progress-track">
                  <div class="progress-fill" style="width:{Math.min(fin_cost_pct[0].ops_30d / 40 * 100, 100)}%; background:{fin_cost_pct[0].ops_30d < 25 ? 'linear-gradient(90deg,#f59e0b,#fde68a)' : fin_cost_pct[0].ops_30d <= 30 ? 'linear-gradient(90deg,#16a34a,#86efac)' : fin_cost_pct[0].ops_30d <= 35 ? 'linear-gradient(90deg,#f59e0b,#fde68a)' : 'linear-gradient(90deg,#ef4444,#fca5a5)'};"></div>
                  <div class="progress-target" style="left:{30 / 40 * 100}%;"></div>
                </div>
                <div class="progress-scale"><span>0%</span><span>30%</span><span>40%</span></div>
                <a href="/01-financial-report/02-cost-breakdown?rincian-biaya-tabs=⚙️ Overhead Costs" class="cost-cta">View Details ➔</a>
                <div class="cost-note">
                  <div style="font-size: 0.82rem; font-weight: 600; color: {fin_cost_pct[0].ops_30d < 25 ? '#ea580c' : fin_cost_pct[0].ops_30d <= 30 ? '#16a34a' : fin_cost_pct[0].ops_30d <= 35 ? '#ea580c' : '#dc2626'};">
                    {fin_cost_pct[0].ops_30d < 25 ? '👀 Low Cost (<25%)' : fin_cost_pct[0].ops_30d <= 30 ? '⭐ Ideal Zone (25-30%)' : fin_cost_pct[0].ops_30d <= 35 ? '⚠️ Watch Zone (30-35%)' : '📉 Critical High (>35%)'}
                  </div>
                  <div style="font-size: 0.78rem; color: var(--color-text-secondary); margin-top: 4px; line-height: 1.4;">
                    {fin_cost_pct[0].ops_30d < 25 ? 'Ratio below target. Review maintenance cost allocations.' : fin_cost_pct[0].ops_30d <= 30 ? 'Overhead cost is efficient. Maintain current setup.' : fin_cost_pct[0].ops_30d <= 35 ? 'Ratio is rising. Review monthly utility and vendor bills.' : 'High overhead cost. Audit non-essential spending.'}
                  </div>
                  <div style="margin-top: 8px;">
                    {#if fin_cost_pct[0].delta_ops_30d > 0}
                      <span class="trend-indicator down">▲ +{String(fin_cost_pct[0].delta_ops_30d)}%</span>
                    {:else if fin_cost_pct[0].delta_ops_30d < 0}
                      <span class="trend-indicator up">▼ {String(fin_cost_pct[0].delta_ops_30d)}%</span>
                    {:else}
                      <span class="trend-indicator neutral">0.0%</span>
                    {/if}
                    <span style="font-size: 0.78rem; color: var(--color-text-secondary);"> vs previous 30 days</span>
                  </div>
                </div>
              </div>
            </div>

            <div style="display: flex; gap: 8px; margin-top: 16px; padding-top: 12px; border-top: 1px dashed var(--color-border-tertiary, #e5e7eb);">
              <span style="font-size: 0.9rem; margin-top: 2px; flex-shrink: 0;">📎</span>
              <div style="display: flex; flex-direction: column; gap: 2px;">
                <span style="font-size: 0.78rem; line-height: 1.5; color: var(--color-text-secondary);">The 30% target benchmark is based on the <strong>30-30-30-10 financial rule</strong> (30% Ingredients, 30% Labor, 30% Overhead, 10% Operating Margin).</span>
                <cite style="font-size: 0.7rem; color: #000000; font-style: italic;">Source: National Restaurant Association Industry Benchmarks</cite>
              </div>
            </div>
          </div>

          <div style="margin-top: 32px; padding: 24px; background: linear-gradient(135deg, rgba(13, 148, 136, 0.08), rgba(20, 184, 166, 0.04)); border: 1.5px solid rgba(13, 148, 136, 0.2); border-radius: 16px; display: flex; flex-direction: column; align-items: center; text-align: center; gap: 16px;">
            <div>
              <h3 style="margin: 0; font-size: 1.15rem; font-weight: 700; color: var(--color-text-primary);">📈 Ready to analyze daily and seasonal trends?</h3>
              <p style="margin: 8px 0 0 0; color: var(--color-text-secondary); font-size: 0.95rem;">Explore the Trends Report to uncover long-term margin and revenue correlations.</p>
            </div>
            <a href="/01-financial-report/03-trend" style="display: inline-block; padding: 10px 24px; background-color: #0d9488; color: white; text-decoration: none; font-weight: 600; border-radius: 8px; font-size: 0.95rem; box-shadow: 0 4px 6px -1px rgba(13, 148, 136, 0.2); transition: all 0.2s ease;">
              View Full Trends Report ➔
            </a>
          </div>
        </div>
    </div>

{:else}
  <GlobalLoading />
{/if}
