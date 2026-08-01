---
title: Permintaan & Traffic
---

<style>
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

.hero-main-card.status-biru {
  background: rgba(59, 130, 246, 0.08);
  border-color: rgba(59, 130, 246, 0.22);
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
  margin-bottom: 2px;
}

.hero-main-card.status-sehat .hero-stat-number {
  color: #15803d;
}

.hero-main-card.status-biru .hero-stat-number {
  color: #1d4ed8;
}

.hero-main-card.status-waspada .hero-stat-number {
  color: #b45309;
}

.hero-main-card.status-kritis .hero-stat-number {
  color: #b91c1c;
}

.hero-stat-label {
  font-size: 0.8rem;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  font-weight: 700;
  color: var(--color-text-tertiary);
  margin-bottom: 12px;
}

.hero-subtitle {
  font-size: 1.15rem;
  font-weight: 700;
  letter-spacing: -0.02em;
  color: var(--color-text-primary);
  margin-bottom: 0;
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
  font-size: 1.1rem;
  font-weight: 800;
  color: var(--color-text-primary);
}

.hero-side-note {
  font-size: 0.78rem;
  line-height: 1.45;
  color: var(--color-text-secondary);
  margin-top: 4px;
}


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


/* ── Branch Health Card Hover ── */
.branch-health-card {
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
  cursor: pointer;
}

.branch-health-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 10px 22px rgba(0, 0, 0, 0.08), 0 3px 6px rgba(0, 0, 0, 0.03);
}

.branch-health-card.sehat:hover {
  border-color: rgba(22, 163, 74, 0.5) !important;
  background: linear-gradient(160deg, rgba(22, 163, 74, 0.12), rgba(16, 185, 129, 0.06)) !important;
}

.branch-health-card.waspada:hover {
  border-color: rgba(245, 158, 11, 0.52) !important;
  background: linear-gradient(160deg, rgba(245, 158, 11, 0.14), rgba(251, 191, 36, 0.06)) !important;
}

.branch-health-card.early-warning:hover {
  border-color: rgba(249, 115, 22, 0.55) !important;
  background: linear-gradient(160deg, rgba(249, 115, 22, 0.14), rgba(251, 146, 60, 0.06)) !important;
}

.branch-health-card.recovery:hover {
  border-color: rgba(59, 130, 246, 0.5) !important;
  background: linear-gradient(160deg, rgba(59, 130, 246, 0.12), rgba(99, 102, 241, 0.06)) !important;
}

.branch-health-card.membaik:hover {
  border-color: rgba(20, 184, 166, 0.5) !important;
  background: linear-gradient(160deg, rgba(20, 184, 166, 0.14), rgba(59, 130, 246, 0.06)) !important;
}

.branch-health-card.stabil-rendah:hover {
  border-color: rgba(245, 158, 11, 0.48) !important;
  background: linear-gradient(160deg, rgba(245, 158, 11, 0.1), rgba(251, 191, 36, 0.04)) !important;
}

.branch-health-card.turnaround:hover {
  border-color: rgba(239, 68, 68, 0.5) !important;
  background: linear-gradient(160deg, rgba(239, 68, 68, 0.14), rgba(220, 38, 38, 0.06)) !important;
}

/* ── Custom Branch Cards Layout ── */
.branch-card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 8px;
  flex-wrap: wrap;
  padding-bottom: 8px;
  border-bottom: 1px dashed rgba(128, 128, 128, 0.15);
}

.branch-margin-section {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;
  align-items: center;
  padding: 8px 0;
}

.branch-margin-active-box {
  display: flex;
  flex-direction: column;
}

.branch-margin-benchmarks {
  display: flex;
  flex-direction: column;
  gap: 6px;
  background: rgba(255, 255, 255, 0.45);
  padding: 8px 12px;
  border-radius: 10px;
  border: 1px solid rgba(128, 128, 128, 0.08);
}

.benchmark-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 0.76rem;
  color: var(--color-text-secondary);
}

.benchmark-label {
  font-weight: 500;
}

.benchmark-val {
  color: var(--color-text-primary);
  font-weight: 700;
}

/* Stats Grid */
.branch-stats-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 8px;
  margin: 4px 0;
}

.stat-pill {
  background: rgba(255, 255, 255, 0.5);
  border: 1px solid rgba(128, 128, 128, 0.1);
  padding: 8px 6px;
  border-radius: 10px;
  text-align: center;
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.stat-label {
  font-size: 0.68rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: var(--color-text-tertiary);
}

.stat-value {
  font-size: 0.8rem;
  font-weight: 700;
  color: var(--color-text-primary);
}

.stat-value.text-up {
  color: #16a34a !important;
}

.stat-value.text-down {
  color: #dc2626 !important;
}

/* Diagnosis Box with left border color matching state */
.branch-diagnosis-box {
  display: flex;
  gap: 8px;
  padding: 10px 12px;
  border-radius: 10px;
  border: 1.5px solid transparent;
  border-left-width: 4px;
  font-size: 0.78rem;
  line-height: 1.45;
  color: var(--color-text-secondary);
  align-items: flex-start;
  margin-top: auto;
}

.branch-diagnosis-box.sehat {
  background: rgba(22, 163, 74, 0.04);
  border-color: rgba(22, 163, 74, 0.12);
  border-left-color: #16a34a;
}
.branch-diagnosis-box.waspada {
  background: rgba(245, 158, 11, 0.04);
  border-color: rgba(245, 158, 11, 0.12);
  border-left-color: #f59e0b;
}
.branch-diagnosis-box.early-warning {
  background: rgba(249, 115, 22, 0.04);
  border-color: rgba(249, 115, 22, 0.12);
  border-left-color: #f97316;
}
.branch-diagnosis-box.recovery {
  background: rgba(59, 130, 246, 0.04);
  border-color: rgba(59, 130, 246, 0.12);
  border-left-color: #3b82f6;
}
.branch-diagnosis-box.membaik {
  background: rgba(20, 184, 166, 0.04);
  border-color: rgba(20, 184, 166, 0.12);
  border-left-color: #14b8a6;
}
.branch-diagnosis-box.stabil-rendah {
  background: rgba(245, 158, 11, 0.03);
  border-color: rgba(245, 158, 11, 0.08);
  border-left-color: #f59e0b;
}
.branch-diagnosis-box.turnaround {
  background: rgba(239, 68, 68, 0.04);
  border-color: rgba(239, 68, 68, 0.12);
  border-left-color: #ef4444;
}

.diagnosis-icon {
  font-size: 0.85rem;
  margin-top: 1px;
}
</style>


<!-- ══════════════════════════════════════
     SQL — SHARED
══════════════════════════════════════ -->

```sql periode_30d
SELECT * FROM restaurant.peak_periode_30d
```

<!-- ══════════════════════════════════════
     SQL — JAM SIBUK
══════════════════════════════════════ -->

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

<!-- ══════════════════════════════════════
     SQL — HARI RAMAI
══════════════════════════════════════ -->

```sql hari_metrics
SELECT * FROM restaurant.peak_hari_metrics
```

```sql daily_avg
SELECT * FROM restaurant.peak_daily_avg
```

```sql branch_daily
SELECT * FROM restaurant.peak_branch_daily
```

<!-- ══════════════════════════════════════
     SQL — VOLATILITAS
══════════════════════════════════════ -->

```sql volatility_metrics
SELECT * FROM restaurant.peak_volatility_metrics
```

```sql daily_trend
SELECT * FROM restaurant.peak_daily_trend
```

```sql anomaly_detail
SELECT * FROM restaurant.peak_anomaly_detail
```

<!-- ══════════════════════════════════════
     SQL — MUSIMAN
══════════════════════════════════════ -->

```sql seasonal_metrics
SELECT * FROM restaurant.peak_seasonal_metrics
```

```sql monthly_trend
SELECT * FROM restaurant.peak_monthly_trend
```

```sql quarterly_trend
SELECT * FROM restaurant.peak_quarterly_trend
```

<PeakTabs activeTab="ringkasan" />


{#if typeof volatility_metrics !== 'undefined' && volatility_metrics.length > 0 && typeof jam_metrics !== 'undefined' && jam_metrics.length > 0 && typeof hari_metrics !== 'undefined' && hari_metrics.length > 0 && typeof seasonal_metrics !== 'undefined' && seasonal_metrics.length > 0}
{@const vl  = volatility_metrics[0].volatility_level}
{@const cv  = volatility_metrics[0].cv_pct}
{@const phl = jam_metrics[0].peak_hours_label}
{@const bd  = hari_metrics[0].busiest_day}
{@const wsp = hari_metrics[0].weekend_share_pct}
{@const sq  = seasonal_metrics[0].strongest_q}
{@const hep = seasonal_metrics[0].holiday_effect_pct}

{@const p_pct = jam_metrics[0].peak_pct}
{@const jamState = p_pct < 12 ? 'safe' : p_pct <= 18 ? 'warn' : 'critical'}
{@const g_pct = hari_metrics[0].gap_pct}
{@const hariState = g_pct < 30 ? 'safe' : g_pct <= 60 ? 'warn' : 'critical'}
{@const totalSafe = (jamState === 'safe' ? 1 : 0) + (hariState === 'safe' ? 1 : 0)}
{@const totalWarn = (jamState === 'warn' ? 1 : 0) + (hariState === 'warn' ? 1 : 0)}
{@const totalCrit = (jamState === 'critical' ? 1 : 0) + (hariState === 'critical' ? 1 : 0)}

<div class="pt-page">
  <div class="hero">
    <div class="hero-eyebrow" style="margin-bottom: 0; font-size: 11px;">📊 Permintaan & Traffic · Snapshot Bulan Ini</div>
    <div class="hero-grid">
      
      <!-- Main Block: Volatility (Difficulty) -->
      <div class="hero-main-card {vl === 'tinggi' ? 'status-kritis' : (vl === 'sedang' ? 'status-waspada' : 'status-sehat')}">
        <div class="hero-eyebrow">Karakteristik Demand</div>
        <div class="hero-stat-number" style="font-size: 2.2rem; margin-top: 16px; margin-bottom: 8px;">
          {#if vl === 'tinggi'}Dinamis & Sulit Ditebak
          {:else if vl === 'sedang'}Terkendali & Sesekali Meleset
          {:else}Sangat Stabil & Terprediksi{/if}

        </div>
        <div class="hero-stat-label" style="text-transform: none; font-size: 1.15rem; margin-bottom: 0;">Rata-rata deviasi harian: <strong>±{cv}%</strong></div>
      </div>
      
      <!-- Supporting Blocks -->
      <div class="hero-side">
        
        <!-- Block 1: Peak Hour & Day -->
        <div class="hero-side-card">
          <div class="hero-side-label">⏰ Jendela Kritis (Peak Hour)</div>
          <div class="hero-side-value">{phl} ({bd})</div>
          <div class="hero-side-note">
            Titik pengerucutan antrean terbesar. Menyumbang <strong>{wsp}%</strong> dari total volume mingguan.
          </div>
        </div>
        
        <!-- Block 2: Seasonality -->
        <div class="hero-side-card">
          <div class="hero-side-label">🔁 Puncak Musiman (High Season)</div>
          <div class="hero-side-value">Kuartal {sq} ({hep > 0 ? '+' : ''}{hep}%)</div>
          <div class="hero-side-note">
            Fase terkuat dalam setahun dengan lonjakan traffic di atas rata-rata hari biasa.
          </div>
        </div>
        
      </div>
      
    </div>
  </div>
  

  <details class="guide-acc" style="margin-top: 2px; margin-bottom: 24px;">
    <summary>💡 Cara membaca status Karakteristik Demand</summary>
    <div class="guide-body">
      <p style="margin-top: 4px; margin-bottom: 16px; font-weight: 500; color: var(--color-text-secondary);">
        Tingkat volatilitas adalah pengetahuan dasar sebelum merencanakan jadwal operasional. Mengetahui seberapa liar traffic meleset dari ekspektasi menentukan seberapa kaku atau fleksibel tim Anda harus bersiap.
      </p>
      <div class="guide-grid" style="grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 12px;">
        <div class="guide-card teal">
          <div class="guide-card-icon">🎯</div>
          <div class="guide-card-content">
            <div class="guide-card-label">Deviasi &lt; 10%</div>
            <h4 class="guide-card-title">Sangat Stabil</h4>
            <p class="guide-card-desc">Traffic harian bergerak layaknya jarum jam. Penjadwalan staf statis dan kaku sangat aman dijalankan tanpa mitigasi khusus.</p>
          </div>
        </div>
        <div class="guide-card orange">
          <div class="guide-card-icon">🌊</div>
          <div class="guide-card-content">
            <div class="guide-card-label">Deviasi 10% - 20%</div>
            <h4 class="guide-card-title">Terkendali</h4>
            <p class="guide-card-desc">Traffic sesekali meleset akibat cuaca atau faktor eksternal minor. Jadwal standar masih aman, cukup sediakan sedikit <em>buffer</em> di akhir pekan.</p>
          </div>
        </div>
        <div class="guide-card purple">
          <div class="guide-card-icon">🎢</div>
          <div class="guide-card-content">
            <div class="guide-card-label">Deviasi &gt; 20%</div>
            <h4 class="guide-card-title">Dinamis &amp; Liar</h4>
            <p class="guide-card-desc">Demand sangat sulit ditebak. Risiko <em>understaffed</em> sangat tinggi. Wajib siapkan staf cadangan (<em>on-call</em>) dan stok penyangga harian.</p>
          </div>
        </div>
        <div class="guide-card blue">
          <div class="guide-card-icon">🔭</div>
          <div class="guide-card-content">
            <div class="guide-card-label">Langkah Lanjutan</div>
            <h4 class="guide-card-title">Cek Anomali</h4>
            <p class="guide-card-desc">Jika status cabang Dinamis/Liar, buka subpage <strong>Hari Ramai</strong> untuk melihat di hari apa tepatnya anomali traffic paling sering merusak ritme.</p>
          </div>
        </div>
      </div>
      <div style="font-size: 0.75rem; color: var(--color-text-secondary); margin-top: 12px;">
        *Rumus deviasi: rata-rata dari seluruh selisih traffic harian aktual dibandingkan angka ekspektasi normal per harinya.
      </div>
    </div>
  </details>





```sql branch_directory
SELECT * FROM restaurant.peak_branch_directory
```



  <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 24px; margin-top: 16px;">
    <div style="font-size: 2rem;">📋</div>
    <div>
      <h2 style="margin: 0; font-size: 1.25rem; font-weight: 800; color: var(--color-text-primary); letter-spacing: -0.02em; text-transform: uppercase;">DETAIL KARAKTERISTIK PER CABANG</h2>
      <div style="font-size: 0.85rem; color: var(--color-text-tertiary); font-weight: 500;">Fokus: Memotret stabilitas dan kepribadian traffic operasional terbaru tiap cabang (30 hari terakhir).</div>
    </div>
  </div>

<div class="branch-health-grid" style="margin-top:14px; ">
  {#each branch_directory as row}
    {@const branchStatusClass = row.volatilitas > 20 ? 'turnaround' : row.volatilitas > 10 ? 'waspada' : 'sehat'}
    <div class="branch-health-card {branchStatusClass}">
      
      <!-- Header Row -->
      <div class="branch-card-header">
        <span class="branch-card-name">{row.branch_name}</span>
        <span class="branch-status-badge {branchStatusClass}">
          {row.volatilitas > 20 ? '🎢 Sangat Liar' : row.volatilitas > 10 ? '🌊 Terkendali' : '🎯 Stabil'}
        </span>
      </div>

      <!-- Main Section -->
      {#if row.pola === 'Mirip'}
      <div class="branch-margin-section" style="grid-template-columns: 1fr; text-align: center; padding: 12px 0;">
        <div class="branch-margin-active-box" style="align-items: center;">
          <div class="branch-margin-main {branchStatusClass}">{row.weekday_peak}</div>
          <div class="branch-margin-label">Puncak Weekday & Weekend</div>
        </div>
      </div>
      {:else}
      <div class="branch-margin-section" style="grid-template-columns: 1fr 1px 1fr; gap: 0; text-align: center; padding: 12px 0;">
        <div class="branch-margin-active-box" style="align-items: center; padding-right: 12px;">
          <div class="branch-margin-main {branchStatusClass}">{row.weekday_peak}</div>
          <div class="branch-margin-label">Puncak Weekday</div>
        </div>
        <div style="height: 70%; width: 1px; background: rgba(0,0,0,0.1); margin: auto;"></div>
        <div class="branch-margin-active-box" style="align-items: center; padding-left: 12px;">
          <div class="branch-margin-main {branchStatusClass}">{row.weekend_peak}</div>
          <div class="branch-margin-label">Puncak Weekend</div>
        </div>
      </div>
      {/if}

      <!-- Stats Grid Row -->
      <div class="branch-stats-grid">
        <div class="stat-pill">
          <span class="stat-label">Hari Puncak</span>
          <span class="stat-value">{row.hari_puncak}</span>
        </div>
        <div class="stat-pill">
          <span class="stat-label">Musim Ramai</span>
          <span class="stat-value">Q{row.puncak_musiman}</span>
        </div>
        <div class="stat-pill">
          <span class="stat-label">Volatilitas</span>
          <span class="stat-value">Deviasi {row.volatilitas}%</span>
        </div>
      </div>

      <!-- Diagnosis Row -->
      <div class="branch-diagnosis-box {branchStatusClass}">
        <div class="diagnosis-icon">📝</div>
        <div class="diagnosis-text"><strong>Pola Jam Sibuk {row.pola}:</strong> {row.rekomendasi}</div>
      </div>
    </div>
  {/each}
</div>
</div>
{/if}
