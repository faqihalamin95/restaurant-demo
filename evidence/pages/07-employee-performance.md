---
title: Performa Pegawai
---

_Ringkasan tenaga kerja: cek pola risiko shift, kehadiran, overtime, produktivitas, dan prioritas coaching._

<style>
.over-container { display: none !important; }

details {
  border: 1px solid rgba(128,128,128,0.18);
  border-radius: 12px;
  margin: 10px 0;
  overflow: hidden;
  background: rgba(255,255,255,0.55);
}
details > summary {
  padding: 14px 16px;
  cursor: pointer;
  background: rgba(128,128,128,0.04);
  font-weight: 700;
  list-style: none;
  display: flex;
  align-items: center;
  gap: 8px;
}
details > summary::-webkit-details-marker { display: none; }
details[open] > summary { border-bottom: 1px solid rgba(128,128,128,0.14); }
.acc-body { padding: 16px; font-size: 0.9em; line-height: 1.75; }
.acc-body ul { margin: 6px 0 0; padding-left: 18px; }
.acc-body li { margin-bottom: 3px; }

.context-acc {
  border: 1px solid rgba(128,128,128,0.18);
  border-radius: 12px;
  margin: 10px 0;
  overflow: hidden;
  background: rgba(255,255,255,0.55);
}
.context-acc summary {
  padding: 14px 16px;
  cursor: pointer;
  background: rgba(128,128,128,0.04);
  font-size: 0.9rem;
  font-weight: 700;
  list-style: none;
  display: flex;
  align-items: center;
  gap: 8px;
  color: var(--color-text-primary);
}
.context-acc summary::-webkit-details-marker { display: none; }
.context-acc[open] summary { border-bottom: 1px solid rgba(128,128,128,0.14); }

details.acc-strategic {
  border-radius: 20px;
  border: 1.5px solid rgba(99,102,241,0.18);
  background: linear-gradient(135deg, rgba(99,102,241,0.04), rgba(139,92,246,0.03));
}
details.acc-strategic > summary {
  padding: 18px 20px; background: transparent;
  font-size: 1rem; font-weight: 800; color: var(--color-text-primary);
}
details.acc-strategic > summary::after {
  content: '›'; margin-left: auto; font-size: 1.3rem; font-weight: 400;
  color: var(--color-text-tertiary); transition: transform 0.2s; display: inline-block;
}
details.acc-strategic[open] > summary::after { transform: rotate(90deg); }
details.acc-strategic[open] > summary { border-bottom: 1.5px solid rgba(99,102,241,0.14); }
details.acc-strategic .acc-body { padding: 20px; }

/* ── Layout ── */
.workforce-page { display: flex; flex-direction: column; gap: 22px; margin-top: 10px; }
.page-intro { font-size: 0.92rem; line-height: 1.75; color: var(--color-text-secondary); max-width: 70ch; }
.inline-link { color: var(--color-primary); text-decoration: none; }
.inline-link:hover { text-decoration: underline; }
.subpage-period-control {
  display: flex;
  flex-direction: column;
  gap: 10px;
  padding: 14px 16px;
  border-radius: 16px;
  border: 1px solid rgba(99,102,241,0.14);
  background: rgba(99,102,241,0.035);
}
.subpage-period-label {
  font-size: 10px;
  font-weight: 800;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: var(--color-text-tertiary);
}
.subpage-period-copy { margin-top: -3px; font-size: 0.82rem; line-height: 1.55; color: var(--color-text-secondary); }

/* ── Period strip ── */
.period-strip { display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 10px; }
.period-pill {
  padding: 13px 15px; border-radius: 16px;
  border: 1.5px solid var(--color-border-tertiary);
  background: var(--color-background-secondary);
}
.period-pill.sehat   { border-color: rgba(22,163,74,0.28);  background: linear-gradient(135deg, rgba(22,163,74,0.09), rgba(16,185,129,0.05)); }
.period-pill.waspada { border-color: rgba(245,158,11,0.32); background: linear-gradient(135deg, rgba(245,158,11,0.10), rgba(251,191,36,0.05)); }
.period-pill.kritis  { border-color: rgba(239,68,68,0.28);  background: linear-gradient(135deg, rgba(239,68,68,0.09), rgba(220,38,38,0.05)); }
.period-pill-label { font-size: 10px; font-weight: 700; letter-spacing: 0.1em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 5px; }
.period-pill-value { font-size: 0.95rem; font-weight: 800; color: var(--color-text-primary); display: flex; align-items: center; gap: 6px; margin-bottom: 4px; flex-wrap: wrap; }
.period-pill-copy  { font-size: 0.8rem; line-height: 1.5; color: var(--color-text-secondary); }
.pill-badge { display: inline-block; padding: 2px 8px; border-radius: 999px; font-size: 10px; font-weight: 700; }
.pill-badge.sehat   { background: rgba(22,163,74,0.15);  color: #15803d; }
.pill-badge.waspada { background: rgba(245,158,11,0.18); color: #b45309; }
.pill-badge.kritis  { background: rgba(239,68,68,0.15);  color: #b91c1c; }

/* ── Hero ── */
.hero {
  display: grid;
  grid-template-columns: minmax(0, 1.65fr) minmax(230px, 1fr);
  gap: 16px; padding: 22px; border-radius: 22px;
  border: 1px solid rgba(37,99,235,0.12);
  background:
    radial-gradient(circle at top right, rgba(69,161,191,0.16), transparent 35%),
    radial-gradient(circle at bottom left, rgba(99,102,241,0.07), transparent 40%),
    var(--color-background-secondary);
}
.hero-eyebrow { font-size: 11px; font-weight: 700; letter-spacing: 0.13em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 8px; }
.hero-title   { margin: 0 0 7px; font-size: 1.6rem; line-height: 1.15; letter-spacing: -0.03em; color: var(--color-text-primary); }
.hero-copy    { margin: 0; font-size: 0.9rem; line-height: 1.7; color: var(--color-text-secondary); max-width: 56ch; }
.hero-side    { display: flex; flex-direction: column; gap: 10px; }
.hero-side-card { padding: 13px 14px; border-radius: 14px; border: 1px solid var(--color-border-tertiary); background: rgba(255,255,255,0.72); }
.hero-side-label { font-size: 10px; font-weight: 700; letter-spacing: 0.1em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 4px; }
.hero-side-value { font-size: 0.98rem; font-weight: 800; color: var(--color-text-primary); letter-spacing: -0.02em; }
.hero-side-note  { margin-top: 3px; font-size: 0.8rem; line-height: 1.55; color: var(--color-text-secondary); }

/* ── KPI Grid ── */
.kpi-grid { display: grid; grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 11px; }
.kpi-card { padding: 16px; border-radius: 18px; border: 1.5px solid var(--color-border-tertiary); background: var(--color-background-secondary); }
.kpi-card.safe { border-color: rgba(22,163,74,0.28); background: linear-gradient(145deg, rgba(22,163,74,0.09), rgba(16,185,129,0.04)); }
.kpi-card.warn { border-color: rgba(245,158,11,0.34); background: linear-gradient(145deg, rgba(245,158,11,0.11), rgba(251,191,36,0.05)); }
.kpi-card.critical { border-color: rgba(239,68,68,0.30); background: linear-gradient(145deg, rgba(239,68,68,0.10), rgba(220,38,38,0.04)); }
.kpi-card.neutral { border-color: rgba(37,99,235,0.18); background: linear-gradient(145deg, rgba(37,99,235,0.06), rgba(99,102,241,0.03)); }
.kpi-label { font-size: 10px; font-weight: 700; letter-spacing: 0.1em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 7px; }
.kpi-value { font-size: 1rem; font-weight: 800; color: var(--color-text-primary); letter-spacing: -0.02em; }
.kpi-meta  { margin-top: 5px; font-size: 0.8rem; line-height: 1.55; color: var(--color-text-secondary); }

/* ── Signal Grid ── */
.signal-grid { display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 12px; }
.signal-card { padding: 17px; border-radius: 16px; border: 1px solid var(--color-border-tertiary); background: var(--color-background-secondary); }
.signal-card.safe     { border-color: rgba(22,163,74,0.25);  background: linear-gradient(135deg, rgba(22,163,74,0.08), rgba(16,185,129,0.03)); }
.signal-card.warn     { border-color: rgba(245,158,11,0.30); background: linear-gradient(135deg, rgba(245,158,11,0.09), rgba(251,191,36,0.03)); }
.signal-card.critical { border-color: rgba(239,68,68,0.25);  background: linear-gradient(135deg, rgba(239,68,68,0.09), rgba(220,38,38,0.03)); }
.signal-card.neutral  { border-color: rgba(99,102,241,0.20); background: linear-gradient(135deg, rgba(99,102,241,0.07), rgba(139,92,246,0.03)); }
.signal-label { font-size: 10px; font-weight: 700; letter-spacing: 0.09em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 5px; }
.signal-title { font-size: 0.96rem; font-weight: 800; color: var(--color-text-primary); margin-bottom: 5px; }
.signal-copy  { font-size: 0.87rem; line-height: 1.68; color: var(--color-text-secondary); }

/* ── Owner Summary ── */
.owner-status {
  display: grid;
  grid-template-columns: minmax(0, 1.7fr) minmax(280px, 1fr);
  gap: 18px;
  padding: 24px;
  border-radius: 22px;
  border: 1px solid rgba(37,99,235,0.12);
  background:
    radial-gradient(circle at top right, rgba(69,161,191,0.18), transparent 35%),
    radial-gradient(circle at bottom left, rgba(99,102,241,0.08), transparent 40%),
    linear-gradient(135deg, rgba(37,99,235,0.06), rgba(194,65,12,0.04)),
    var(--color-background-secondary);
}
.owner-status.safe {
  border-color: rgba(22,163,74,0.30);
  background:
    radial-gradient(circle at top right, rgba(22,163,74,0.16), transparent 35%),
    linear-gradient(135deg, rgba(22,163,74,0.095), rgba(16,185,129,0.045)),
    var(--color-background-secondary);
}
.owner-status.warn {
  border-color: rgba(245,158,11,0.36);
  background:
    radial-gradient(circle at top right, rgba(245,158,11,0.18), transparent 35%),
    linear-gradient(135deg, rgba(245,158,11,0.12), rgba(251,191,36,0.055)),
    var(--color-background-secondary);
}
.owner-status.critical {
  border-color: rgba(239,68,68,0.32);
  background:
    radial-gradient(circle at top right, rgba(239,68,68,0.16), transparent 35%),
    linear-gradient(135deg, rgba(239,68,68,0.11), rgba(220,38,38,0.05)),
    var(--color-background-secondary);
}
.owner-status-label { font-size: 11px; font-weight: 700; letter-spacing: 0.13em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 8px; display: flex; align-items: center; gap: 6px; }
.owner-status-badge { display: inline-flex; align-items: center; justify-content: center; width: 36px; height: 36px; padding: 0; border-radius: 999px; font-size: 18px; line-height: 1; font-weight: 800; border: 1px solid; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }
.owner-status-badge.safe { background: rgba(22,163,74,0.14); color: #15803d; border-color: rgba(22,163,74,0.24); }
.owner-status-badge.warn { background: rgba(245,158,11,0.18); color: #b45309; border-color: rgba(245,158,11,0.28); }
.owner-status-badge.critical { background: rgba(239,68,68,0.14); color: #b91c1c; border-color: rgba(239,68,68,0.24); }
.owner-status-title { margin: 0 0 10px; font-size: 1.9rem; line-height: 1.1; letter-spacing: -0.035em; color: var(--color-text-primary); }
.owner-status-copy { margin: 0; max-width: 62ch; font-size: 0.95rem; line-height: 1.75; color: var(--color-text-secondary); }
.owner-status-action { margin-top: 14px; padding: 12px 14px; border-radius: 14px; border-left: 4px solid rgba(37,99,235,0.38); background: rgba(37,99,235,0.045); font-size: 0.88rem; line-height: 1.65; color: var(--color-text-secondary); }
.owner-status.safe .owner-status-action { border-left-color: rgba(22,163,74,0.48); background: rgba(22,163,74,0.055); }
.owner-status.warn .owner-status-action { border-left-color: rgba(245,158,11,0.56); background: rgba(245,158,11,0.065); }
.owner-status.critical .owner-status-action { border-left-color: rgba(239,68,68,0.50); background: rgba(239,68,68,0.055); }
.owner-status-action strong { color: var(--color-text-primary); }
.owner-status-metrics { display: flex; flex-direction: column; gap: 10px; }
.owner-status-metric { flex: 1; padding: 14px 15px; border-radius: 14px; border: 1px solid var(--color-border-tertiary); background: rgba(255,255,255,0.72); }
.owner-status-metric-label { font-size: 10px; font-weight: 700; letter-spacing: 0.1em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 4px; }
.owner-status-metric-value { font-size: 1.05rem; font-weight: 800; color: var(--color-text-primary); letter-spacing: -0.02em; }
.owner-status-metric-note { margin-top: 4px; font-size: 0.82rem; line-height: 1.6; color: var(--color-text-secondary); }
.health-summary { padding: 17px 18px; border-radius: 16px; border: 1px solid var(--color-border-tertiary); background: var(--color-background-secondary); box-shadow: 0 1px 3px rgba(0,0,0,0.035); }
.health-summary-head { display: flex; align-items: center; justify-content: space-between; gap: 10px; flex-wrap: wrap; padding-bottom: 12px; margin-bottom: 12px; border-bottom: 1px solid var(--color-border-tertiary); }
.health-summary-label { font-size: 10px; font-weight: 850; letter-spacing: 0.11em; text-transform: uppercase; color: var(--color-text-tertiary); }
.health-badges { display: flex; align-items: center; gap: 8px; flex-wrap: wrap; }
.health-badge { display: inline-flex; align-items: center; gap: 5px; padding: 4px 10px; border-radius: 999px; font-size: 11px; font-weight: 800; border: 1px solid; }
.health-badge.safe { background: rgba(22,163,74,0.10); color: #166534; border-color: rgba(22,163,74,0.22); }
.health-badge.warn { background: rgba(234,179,8,0.10); color: #854d0e; border-color: rgba(234,179,8,0.26); }
.health-badge.critical { background: rgba(220,38,38,0.08); color: #991b1b; border-color: rgba(220,38,38,0.20); }
.health-list { display: flex; flex-direction: column; gap: 6px; }
.health-row { display: flex; align-items: flex-start; gap: 10px; padding: 9px 10px; border-radius: 10px; font-size: 0.84rem; line-height: 1.55; border: 1px solid transparent; }
.health-row.safe { background: rgba(22,163,74,0.045); border-color: rgba(22,163,74,0.12); }
.health-row.warn { background: rgba(234,179,8,0.045); border-color: rgba(234,179,8,0.16); }
.health-row.critical { background: rgba(220,38,38,0.04); border-color: rgba(220,38,38,0.13); }
.health-icon { width: 18px; flex: 0 0 18px; margin-top: 1px; font-size: 14px; line-height: 1.2; text-align: center; }
.health-row-title { font-weight: 850; color: var(--color-text-primary); }
.health-row-copy { color: var(--color-text-secondary); }
.health-row-value { font-weight: 850; color: var(--color-text-primary); }
.threshold-line { margin-top: 9px; padding-top: 8px; border-top: 1px dashed rgba(100,116,139,0.24); font-size: 0.77rem; line-height: 1.55; color: var(--color-text-tertiary); }
.threshold-line strong { color: var(--color-text-primary); }
.analysis-grid { display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 12px; }
.analysis-grid.primary { grid-template-columns: repeat(2, minmax(0, 1fr)); }
.analysis-grid.supporting { grid-template-columns: repeat(2, minmax(0, 1fr)); }
.analysis-grid.secondary { grid-template-columns: repeat(4, minmax(0, 1fr)); }
.analysis-card { padding: 16px; border-radius: 16px; border: 1px solid var(--color-border-tertiary); background: var(--color-background-secondary); }
.analysis-card.safe { border-color: rgba(22,163,74,0.24); background: rgba(22,163,74,0.045); }
.analysis-card.warn { border-color: rgba(245,158,11,0.28); background: rgba(245,158,11,0.055); }
.analysis-card.critical { border-color: rgba(239,68,68,0.24); background: rgba(239,68,68,0.045); }
.analysis-card.neutral { border-color: rgba(99,102,241,0.18); background: rgba(99,102,241,0.035); }
.analysis-label { font-size: 10px; font-weight: 800; letter-spacing: 0.09em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 6px; }
.analysis-title { font-size: 0.98rem; font-weight: 850; color: var(--color-text-primary); line-height: 1.3; margin-bottom: 6px; }
.analysis-copy { font-size: 0.84rem; line-height: 1.62; color: var(--color-text-secondary); }
.analysis-link { margin-top: 9px; font-size: 0.78rem; font-weight: 800; color: var(--color-primary); }
.owner-split { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 12px; }
.owner-list { padding: 16px; border-radius: 16px; border: 1px solid var(--color-border-tertiary); background: var(--color-background-secondary); }
.owner-list.warn { border-color: rgba(245,158,11,0.26); background: rgba(245,158,11,0.045); }
.owner-list.safe { border-color: rgba(22,163,74,0.22); background: rgba(22,163,74,0.04); }
.owner-list-title { font-size: 0.96rem; font-weight: 850; color: var(--color-text-primary); margin-bottom: 8px; }
.owner-list ul { margin: 0; padding-left: 17px; color: var(--color-text-secondary); font-size: 0.86rem; line-height: 1.7; }
.deep-dive-grid { display: grid; grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 10px; }
.deep-dive-item { padding: 13px 14px; border-radius: 14px; border: 1px solid rgba(99,102,241,0.16); background: rgba(99,102,241,0.035); }
.deep-dive-label { font-size: 10px; font-weight: 850; letter-spacing: 0.08em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 5px; }
.deep-dive-copy { font-size: 0.83rem; line-height: 1.55; color: var(--color-text-secondary); }

/* ── Section card ── */
.section-card { padding: 20px; border-radius: 20px; border: 1px solid var(--color-border-tertiary); background: var(--color-background-secondary); }
.section-head { margin-bottom: 13px; }
.section-head.tight { margin-bottom: 10px; }
.section-eyebrow { font-size: 10px; font-weight: 700; letter-spacing: 0.11em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 4px; display: flex; align-items: center; gap: 5px; flex-wrap: wrap; }
.section-title { margin: 0; font-size: 1.08rem; font-weight: 800; letter-spacing: -0.02em; color: var(--color-text-primary); }
.section-copy  { margin: 4px 0 0; font-size: 0.87rem; line-height: 1.7; color: var(--color-text-secondary); max-width: 70ch; }
.timeframe-tag { display: inline-block; padding: 2px 7px; border-radius: 999px; font-size: 10px; font-weight: 700; background: rgba(0,0,0,0.05); color: var(--color-text-tertiary); }

/* ── Workforce Action Queue ── */
.workforce-action-stack { display: flex; flex-direction: column; gap: 10px; }
.workforce-action-card {
  padding: 15px 17px; border-radius: 16px;
  border-left: 4px solid; border-top: 1px solid; border-right: 1px solid; border-bottom: 1px solid;
  display: flex; flex-direction: column; gap: 5px;
}
.workforce-action-card.critical { border-left-color: #ef4444; border-color: rgba(239,68,68,0.22);  background: rgba(239,68,68,0.04); }
.workforce-action-card.high     { border-left-color: #f97316; border-color: rgba(249,115,22,0.22); background: rgba(249,115,22,0.04); }
.workforce-action-card.moderate { border-left-color: #f59e0b; border-color: rgba(245,158,11,0.22); background: rgba(245,158,11,0.04); }
.workforce-action-card.low      { border-left-color: #64748b; border-color: rgba(100,116,139,0.15); background: rgba(100,116,139,0.03); }
.action-header { display: flex; align-items: center; justify-content: space-between; gap: 10px; flex-wrap: wrap; }
.action-severity { font-size: 9px; font-weight: 800; letter-spacing: 0.1em; text-transform: uppercase; padding: 2px 7px; border-radius: 999px; display: inline-block; }
.workforce-action-card.critical .action-severity { background: rgba(239,68,68,0.12);   color: #b91c1c; }
.workforce-action-card.high     .action-severity { background: rgba(249,115,22,0.12);  color: #c2410c; }
.workforce-action-card.moderate .action-severity { background: rgba(245,158,11,0.14); color: #b45309; }
.workforce-action-card.low      .action-severity { background: rgba(100,116,139,0.10); color: #475569; }
.action-badge  { padding: 3px 9px; border-radius: 999px; font-size: 10px; font-weight: 700; background: rgba(0,0,0,0.05); color: var(--color-text-tertiary); }
.action-title  { font-size: 0.96rem; font-weight: 800; color: var(--color-text-primary); letter-spacing: -0.02em; }
.action-impact { font-size: 0.82rem; font-weight: 700; padding: 4px 10px; background: rgba(0,0,0,0.04); border-radius: 8px; display: inline-block; color: var(--color-text-primary); }
.action-rec    { font-size: 0.85rem; line-height: 1.65; color: var(--color-text-secondary); }
.action-dashboard { display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 11px; margin-bottom: 14px; }
.action-snapshot { padding: 14px 15px; border-radius: 15px; border: 1px solid var(--color-border-tertiary); background: rgba(255,255,255,0.62); }
.action-snapshot-label { font-size: 10px; font-weight: 800; letter-spacing: 0.1em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 5px; }
.action-snapshot-value { font-size: 1.35rem; line-height: 1; font-weight: 850; color: var(--color-text-primary); letter-spacing: -0.025em; }
.action-snapshot-copy { margin-top: 5px; font-size: 0.8rem; line-height: 1.5; color: var(--color-text-secondary); }
.action-lane { margin-top: 16px; }
.action-lane:first-of-type { margin-top: 0; }
.action-lane-title { margin: 0 0 8px; font-size: 0.92rem; font-weight: 850; color: var(--color-text-primary); letter-spacing: -0.015em; }
.action-lane-copy { margin: -2px 0 10px; font-size: 0.83rem; line-height: 1.6; color: var(--color-text-secondary); max-width: 68ch; }

/* ── Coverage & Coaching ── */
.coverage-grid  { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 12px; }
.pressure-grid  { display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 12px; }
.coaching-stack { display: flex; flex-direction: column; gap: 10px; }
.coaching-card  { padding: 14px 16px; border-radius: 14px; border: 1px solid var(--color-border-tertiary); background: var(--color-background-secondary); }
.coaching-card.attendance { border-color: rgba(239,68,68,0.22); background: rgba(239,68,68,0.04); }
.coaching-card.overtime   { border-color: rgba(249,115,22,0.22); background: rgba(249,115,22,0.04); }
.coaching-card.productivity { border-color: rgba(37,99,235,0.18); background: rgba(37,99,235,0.04); }
.coaching-label { font-size: 10px; font-weight: 700; letter-spacing: 0.09em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 4px; }
.coaching-title { font-size: 0.93rem; font-weight: 800; color: var(--color-text-primary); margin-bottom: 4px; }
.coaching-copy  { font-size: 0.84rem; line-height: 1.65; color: var(--color-text-secondary); }

/* ── Callout ── */
.callout {
  margin-top: 12px; padding: 11px 15px; border-radius: 12px;
  font-size: 0.87rem; line-height: 1.7; color: var(--color-text-secondary);
  border-left: 3px solid rgba(99,102,241,0.35); background: rgba(99,102,241,0.04);
}
.callout strong { color: var(--color-text-primary); }
.callout.warn { border-left-color: rgba(245,158,11,0.5); background: rgba(245,158,11,0.05); }
.callout.safe { border-left-color: rgba(22,163,74,0.4); background: rgba(22,163,74,0.05); }

/* ── Responsive ── */
@media (max-width: 900px) {
  .period-strip,
  .kpi-grid,
  .signal-grid,
  .analysis-grid,
  .analysis-grid.primary,
  .analysis-grid.supporting,
  .analysis-grid.secondary,
  .owner-split,
  .deep-dive-grid,
  .coverage-grid,
  .pressure-grid,
  .action-dashboard {
    grid-template-columns: 1fr;
  }
  .hero,
  .owner-status { grid-template-columns: 1fr; }
}
@media (max-width: 680px) {
  .hero-title { font-size: 1.4rem; }
  .kpi-grid { grid-template-columns: 1fr 1fr; }
  .signal-grid,
  .analysis-grid,
  .analysis-grid.primary,
  .analysis-grid.supporting,
  .analysis-grid.secondary,
  .owner-split,
  .deep-dive-grid { grid-template-columns: 1fr; }
}
</style>

```sql workforce_dates
SELECT * FROM restaurant.workforce_dates
```

```sql workforce_health_period
SELECT * FROM restaurant.workforce_health_period
```

```sql workforce_health_overview
SELECT * FROM restaurant.workforce_health_overview
```

```sql workforce_kpi_period
SELECT * FROM restaurant.workforce_kpi_period
```

```sql workforce_trend_period
SELECT * FROM restaurant.workforce_trend_period
```


```sql workforce_today_actions
SELECT * FROM restaurant.workforce_today_actions
```

```sql attendance_events_yesterday
SELECT * FROM restaurant.attendance_events_yesterday
```

```sql attendance_trend_period
SELECT * FROM restaurant.attendance_trend_period
```

```sql attendance_weekly_30d
SELECT * FROM restaurant.attendance_weekly_30d
```

```sql workforce_action_queue
SELECT * FROM restaurant.workforce_action_queue
```

```sql attendance_mix_period
SELECT * FROM restaurant.attendance_mix_period
```

```sql attendance_by_branch_period
SELECT * FROM restaurant.attendance_by_branch_period
```

```sql attendance_daily_trend
SELECT * FROM restaurant.attendance_daily_trend
```

```sql attendance_by_dayofweek
SELECT * FROM restaurant.attendance_by_dayofweek
```

```sql shift_coverage_period
SELECT * FROM restaurant.shift_coverage_period
```


```sql role_coverage_period
SELECT * FROM restaurant.role_coverage_period
```

```sql roster_detail_period
SELECT * FROM restaurant.roster_detail_period
```

```sql shift_movement_period
SELECT * FROM restaurant.shift_movement_period
```

```sql overtime_pressure_period
SELECT * FROM restaurant.overtime_pressure_period
```

```sql overtime_by_branch_period
SELECT * FROM restaurant.overtime_by_branch_period
```

```sql overtime_trend
SELECT * FROM restaurant.overtime_trend
```


```sql overtime_weekly_30d
SELECT * FROM restaurant.overtime_weekly_30d
```

```sql productivity_by_employee_period
SELECT * FROM restaurant.productivity_by_employee_period
```

```sql productivity_by_shift_role
SELECT * FROM restaurant.productivity_by_shift_role
```

```sql role_diagnostics_period
SELECT * FROM restaurant.role_diagnostics_period
```

```sql attendance_problem_period
SELECT * FROM restaurant.attendance_problem_period
```

```sql top_overtime_employees_period
SELECT * FROM restaurant.top_overtime_employees_period
```

<ButtonGroup name=workforce_view>
  <ButtonGroupItem valueLabel="🏠 Ringkasan" value="summary" default />
  <ButtonGroupItem valueLabel="📋 Kehadiran" value="attendance" />
  <ButtonGroupItem valueLabel="👥 Pola Risiko Shift" value="coverage" />
  <ButtonGroupItem valueLabel="✅ Pusat Aksi" value="coaching" />
  <ButtonGroupItem valueLabel="🔎 Analisis Lanjutan" value="advanced" />
</ButtonGroup>

{#if workforce_health_overview.length > 0 && workforce_dates.length > 0}

{@const activeView = inputs.workforce_view ?? 'summary'}
{@const activePeriod = inputs.period ?? '7d'}
{@const activeFocus = activePeriod === 'y' ? workforce_health_overview[0].focus_y : activePeriod === '30d' ? workforce_health_overview[0].focus_30d : workforce_health_overview[0].focus_7d}
{@const activeAttendance = activePeriod === 'y' ? workforce_health_overview[0].attendance_y : activePeriod === '30d' ? workforce_health_overview[0].attendance_30d : workforce_health_overview[0].attendance_7d}
{@const activeLate = activePeriod === 'y' ? workforce_health_overview[0].late_y : activePeriod === '30d' ? workforce_health_overview[0].late_30d : workforce_health_overview[0].late_7d}
{@const activeAbsent = activePeriod === 'y' ? workforce_health_overview[0].absent_y : activePeriod === '30d' ? workforce_health_overview[0].absent_30d : workforce_health_overview[0].absent_7d}
{@const activeOvertimePct = activePeriod === 'y' ? workforce_health_overview[0].overtime_pct_y : activePeriod === '30d' ? workforce_health_overview[0].overtime_pct_30d : workforce_health_overview[0].overtime_pct_7d}
{@const activeRevenuePerHour = activePeriod === 'y' ? workforce_health_overview[0].rev_per_hour_y : activePeriod === '30d' ? workforce_health_overview[0].rev_per_hour_30d : workforce_health_overview[0].rev_per_hour_7d}
{@const activePressureBranch = activePeriod === 'y' ? null : activePeriod === '30d' ? workforce_health_overview[0].pressure_branch_30d : workforce_health_overview[0].pressure_branch_7d}
{@const activeKpi = workforce_kpi_period.find(r => r.period === activePeriod) ?? workforce_kpi_period.find(r => r.period === '7d')}
{@const activeTrend = workforce_trend_period.find(r => r.period === activePeriod) ?? workforce_trend_period.find(r => r.period === '7d')}
{@const activeLeave = activeKpi?.leave_count ?? 0}
{@const activeUnavailable = activeKpi?.unavailable_count ?? activeAbsent}
{@const activeShiftCoverage = shift_coverage_period.filter(r => r.period === activePeriod)}
{@const activeRoleCoverage = role_coverage_period.filter(r => r.period === activePeriod)}
{@const activeRosterDetail = roster_detail_period.filter(r => r.period === activePeriod)}
{@const activeRoleGap = activeRoleCoverage.find(r => r.gap_sessions > 0) ?? activeRoleCoverage[0]}
{@const activeAbsentByBranch = attendance_by_branch_period.filter(r => r.period === activePeriod && r.attendance_status === 'absent')}
{@const activeOvertimePressure = overtime_pressure_period.filter(r => r.period === activePeriod)}
{@const activeOvertimeByBranch = overtime_by_branch_period.filter(r => r.period === activePeriod)}
{@const activeTopOvertime = top_overtime_employees_period.filter(r => r.period === activePeriod)}
{@const activeOvertimeToday = activeRosterDetail.filter(r => r.overtime_hours > 0)}
{@const activeOvertimeShift = activeOvertimePressure[0]}
{@const activeProductivityByShiftRole = productivity_by_shift_role.filter(r => r.period === activePeriod)}
{@const activeProductivityByEmployee = productivity_by_employee_period.filter(r => r.period === activePeriod)}
{@const activeRoleDiagnostics = role_diagnostics_period.filter(r => r.period === activePeriod)}
{@const activeTopProductivityEmployee = activeProductivityByEmployee[0]}
{@const activeTopProductivityShiftRole = activeProductivityByShiftRole[0]}
{@const activeAttendanceProblems = attendance_problem_period.filter(r => r.period === activePeriod)}
{@const activeAttendanceTrend = attendance_trend_period.filter(r => r.period === activePeriod)}
{@const activeWeeklyRisk = attendance_weekly_30d}
{@const activeAttendanceEventsYesterday = attendance_events_yesterday}
{@const activeRosterIssues = activeRosterDetail.filter(r => r.status_label === 'Absent' || r.status_label === 'Terlambat')}
{@const actionQueue = workforce_action_queue}
{@const operationalActions = actionQueue.filter(a => a.action_group === 'Masalah Operasional')}
{@const attendanceActions = actionQueue.filter(a => a.action_group === 'Masalah Kehadiran')}
{@const positiveActions = actionQueue.filter(a => a.action_group === 'Peluang Positif')}
{@const priorityAction = actionQueue[0]}
{@const actionRootCause = operationalActions.length >= attendanceActions.length && operationalActions.length > 0 ? 'Operasional/kapasitas' : attendanceActions.length > 0 ? 'Kehadiran/disiplin' : positiveActions.length > 0 ? 'Benchmark produktivitas' : 'Tidak ada sinyal dominan'}
{@const actionRootCopy = operationalActions.length >= attendanceActions.length && operationalActions.length > 0 ? 'Masalah paling banyak datang dari cabang, shift, role, atau overtime. Atur kapasitas dulu sebelum menyimpulkan individu bermasalah.' : attendanceActions.length > 0 ? 'Masalah paling banyak datang dari absent atau terlambat. Mulai dari percakapan validasi dan cek jadwal.' : positiveActions.length > 0 ? 'Sinyal utama adalah pegawai produktif yang bisa jadi contoh, mentor, atau kandidat apresiasi.' : 'Belum ada tindakan dominan dari data periode ini.'}
{@const attendanceKpiState = activeKpi && activeKpi.attendance_rate >= 92 ? 'safe' : activeKpi && activeKpi.attendance_rate >= 85 ? 'warn' : 'critical'}
{@const lateKpiState = activeKpi && activeKpi.late_rate < 10 ? 'safe' : activeKpi && activeKpi.late_rate < 20 ? 'warn' : 'critical'}
{@const coverageKpiState = activeUnavailable <= 0 ? 'safe' : activePeriod === 'y' ? (activeUnavailable <= 2 ? 'warn' : 'critical') : activePeriod === '7d' ? (activeUnavailable <= 5 ? 'warn' : 'critical') : (activeUnavailable <= 12 ? 'warn' : 'critical')}
{@const overtimeKpiState = activeKpi && activeKpi.overtime_session_pct < 20 ? 'safe' : activeKpi && activeKpi.overtime_session_pct < 35 ? 'warn' : 'critical'}
{@const leaveKpiState = activeLeave > 0 ? 'warn' : 'safe'}
{@const activeStatus = attendanceKpiState === 'safe' && lateKpiState === 'safe' && coverageKpiState !== 'critical' ? 'Sehat' : ((attendanceKpiState === 'critical' && lateKpiState === 'critical') || (attendanceKpiState === 'critical' && lateKpiState === 'warn') || (attendanceKpiState === 'warn' && lateKpiState === 'critical')) ? 'Kritis' : 'Waspada'}
{@const primarySignalStates = [attendanceKpiState, lateKpiState]}
{@const primarySafeCount = primarySignalStates.filter(s => s === 'safe').length}
{@const primaryWarnCount = primarySignalStates.filter(s => s === 'warn').length}
{@const primaryCriticalCount = primarySignalStates.filter(s => s === 'critical').length}
{@const secondarySignalStates = [coverageKpiState, leaveKpiState]}
{@const secondarySafeCount = secondarySignalStates.filter(s => s === 'safe').length}
{@const secondaryWarnCount = secondarySignalStates.filter(s => s === 'warn').length}
{@const secondaryCriticalCount = secondarySignalStates.filter(s => s === 'critical').length}
{@const activeCoverageWarnLimit = activePeriod === 'y' ? 2 : activePeriod === '7d' ? 5 : 12}
{@const activeProblemEmployeeCount = activePeriod === '30d' ? workforce_health_overview[0].problem_employees_30d : activePeriod === '7d' ? activeAttendanceProblems.length : activeAttendanceEventsYesterday.filter(r => r.status_label === 'Absent' || r.status_label === 'Terlambat').length}

<div class="workforce-page">

<div class="page-intro">
  Halaman ini membaca hal paling dasar tentang pegawai: siapa hadir, siapa absent/cuti, siapa terlambat, dan tindakan apa yang perlu diprioritaskan owner. Overtime dan produktivitas dipisahkan sebagai analisis lanjutan agar tidak membebani pembacaan utama.
</div>

<div class="subpage-period-control">
  <div class="subpage-period-label">{activeView === 'summary' ? 'Periode Ringkasan' : activeView === 'coaching' ? 'Pusat Aksi' : activeView === 'advanced' ? 'Analisis Lanjutan' : 'Periode Analisis'}</div>
  {#if activeView === 'coaching'}
  <div class="period-strip">
    <div class="period-pill waspada"><div class="period-pill-label">🛠️ Masalah Operasional</div><div class="period-pill-value">{operationalActions.length} aksi</div><div class="period-pill-copy">Roster, coverage, role rawan, atau overtime yang perlu ditangani dulu.</div></div>
    <div class="period-pill waspada"><div class="period-pill-label">💬 Masalah Kehadiran</div><div class="period-pill-value">{attendanceActions.length} aksi</div><div class="period-pill-copy">Absent dan keterlambatan yang perlu validasi, bukan hukuman otomatis.</div></div>
    <div class="period-pill sehat"><div class="period-pill-label">🏅 Peluang Positif</div><div class="period-pill-value">{positiveActions.length} aksi</div><div class="period-pill-copy">Benchmark produktivitas untuk apresiasi, mentor, atau praktik kerja baik.</div></div>
  </div>
  {:else}
  <ButtonGroup name=period>
    <ButtonGroupItem valueLabel="Kemarin" value="y" />
    <ButtonGroupItem valueLabel="7 Hari" value="7d" default />
    <ButtonGroupItem valueLabel="30 Hari" value="30d" />
  </ButtonGroup>
  {/if}
  <div class="subpage-period-copy">
    {#if activeView === 'summary'}Ringkasan memberi gambaran cepat untuk owner: apa yang bermasalah, apa yang masih aman, dan ke mana harus deep dive.
    {:else if activeView === 'attendance'}Kehadiran fokus ke absent, cuti, dan keterlambatan pegawai.
    {:else if activeView === 'coverage'}Pola Risiko Shift membaca kejadian kemarin, pola harian 7H, dan pola mingguan 30H.
    {:else if activeView === 'advanced'}Analisis Lanjutan berisi overtime dan produktivitas sebagai konteks tambahan, bukan dasar penilaian utama.
    {:else}Pusat Aksi mengubah sinyal pegawai menjadi daftar problem dan pemecahan masalah yang bisa langsung ditindaklanjuti.{/if}
  </div>
</div>

{#if activeView === 'summary'}


<details class="context-acc">
  <summary>📖 Cara membaca Ringkasan Pegawai</summary>
  <div class="acc-body">
    <ul>
      <li><strong>Ringkasan</strong> adalah peta cepat untuk owner: status umum, masalah utama, area aman, dan arah deep dive.</li>
      <li><strong>Indikator utama</strong> adalah hal paling pokok: kehadiran dan keterlambatan.</li>
      <li><strong>Penyebab operasional</strong> membantu menjelaskan apakah masalah datang dari roster, shift, atau beban kerja.</li>
      <li><strong>Konteks lanjutan</strong> dipakai setelah itu: role/cabang rawan, produktivitas, dan pusat aksi.</li>
      <li><strong>Detail bukti</strong> tetap tersedia di subpage, tetapi tidak perlu dibaca dulu jika owner hanya butuh gambaran cepat.</li>
    </ul>
  </div>
</details>

<div class="owner-status {activeStatus === 'Sehat' ? 'safe' : activeStatus === 'Waspada' ? 'warn' : 'critical'}">
  <div>
    <div class="owner-status-label">Status Utama · {activePeriod === 'y' ? 'Evaluasi Kemarin' : activePeriod === '30d' ? 'Pola 30 Hari' : 'Pola 7 Hari'}</div>
    <h2 class="owner-status-title">
      {#if activeStatus === 'Sehat'}Tim operasional masih terkendali. ✅
      {:else if activeStatus === 'Waspada'}Tim masih berjalan, tapi ada sinyal yang perlu dicek. ⚠️
      {:else}Kapasitas tim perlu perhatian serius. 🚨{/if}
    </h2>
    <div class="owner-status-copy">
      {#if activePeriod === 'y'}Kemarin dipakai untuk evaluasi shift terakhir. Kehadiran {activeAttendance}%, {activeAbsent} absent, {activeLeave} cuti, dan {activeLate}% terlambat.
      {:else if activePeriod === '7d'}Dalam 7 hari terakhir, kehadiran {activeAttendance}%, absent {activeAbsent} sesi, cuti {activeLeave} sesi, dan keterlambatan {activeLate}%. Baca ini sebagai pola pendek, bukan kejadian tunggal.
      {:else}Dalam 30 hari terakhir, kehadiran {activeAttendance}%, {activeUnavailable} sesi butuh pengganti, dan keterlambatan {activeLate}%. Baca ini sebagai sinyal struktur kehadiran dan roster.{/if}
    </div>
    <div class="owner-status-action">
      <strong>Mulai dari sini:</strong>
      {#if activeFocus === 'Coverage risk'}cek <strong>Pola Risiko Shift</strong> untuk melihat shift, role, dan cabang yang sering bermasalah.
      {:else if activeFocus === 'Overtime pressure'}cek <strong>Analisis Lanjutan</strong> jika ingin memahami tekanan overtime sebagai konteks tambahan.
      {:else if activeFocus === 'Keterlambatan'}cek <strong>Pusat Aksi</strong> setelah melihat pola keterlambatan di Pola Risiko Shift.
      {:else}cek <strong>Kehadiran</strong> untuk melihat daftar pegawai absent, cuti, dan terlambat.{/if}
    </div>
  </div>
  <div class="owner-status-metrics">
    <div class="owner-status-metric">
      <div class="owner-status-metric-label">📅 Periode Aktif</div>
      <div class="owner-status-metric-value">{activeTrend?.active_range ?? (activePeriod === '30d' ? workforce_dates[0].tgl_30_awal + ' - ' + workforce_dates[0].tgl_akhir : activePeriod === '7d' ? workforce_dates[0].tgl_7_awal + ' - ' + workforce_dates[0].tgl_akhir : workforce_dates[0].tgl_akhir)}</div>
      <div class="owner-status-metric-note">Window ini dipakai untuk membaca pola pegawai: cukup dekat untuk ditindaklanjuti, cukup panjang untuk melihat kebiasaan.</div>
    </div>
    <div class="owner-status-metric">
      <div class="owner-status-metric-label">👥 Tren Kesiapan Tim</div>
      <div class="owner-status-metric-value">Kehadiran {activeTrend?.attendance_change_pct > 0 ? '+' : ''}{activeTrend?.attendance_change_pct ?? 0}%</div>
      <div class="owner-status-metric-note">Keterlambatan berubah {activeTrend?.late_change_pct > 0 ? '+' : ''}{activeTrend?.late_change_pct ?? 0}% vs {activeTrend?.comparison_label ?? 'periode sebelumnya'}. Overtime dipindahkan ke Analisis Lanjutan.</div>
    </div>
  </div>
</div>

<div class="health-summary">
  <div class="health-summary-head">
    <div class="health-summary-label">Ringkasan 2 Indikator Utama</div>
    <div class="health-badges">
      <span class="health-badge safe">✓ {primarySafeCount} sehat</span>
      <span class="health-badge warn">! {primaryWarnCount} waspada</span>
      <span class="health-badge critical">x {primaryCriticalCount} kritis</span>
    </div>
  </div>
  <div class="health-list">
    <div class="health-row {attendanceKpiState === 'safe' ? 'safe' : attendanceKpiState === 'warn' ? 'warn' : 'critical'}">
      <div class="health-icon">{attendanceKpiState === 'safe' ? '✅' : attendanceKpiState === 'warn' ? '⚠️' : '🚨'}</div>
      <div><span class="health-row-title">Kehadiran</span> <span class="health-row-copy">- <span class="health-row-value">{activeAttendance}% hadir</span>. Sehat = minimal 92%, Waspada = 85-91%, Kritis = di bawah 85%.</span></div>
    </div>
    <div class="health-row {lateKpiState === 'safe' ? 'safe' : lateKpiState === 'warn' ? 'warn' : 'critical'}">
      <div class="health-icon">{lateKpiState === 'safe' ? '✅' : lateKpiState === 'warn' ? '⚠️' : '🚨'}</div>
      <div><span class="health-row-title">Keterlambatan</span> <span class="health-row-copy">- <span class="health-row-value">{activeLate}% terlambat</span>. Sehat = di bawah 10%, Waspada = 10-19%, Kritis = 20% ke atas.</span></div>
    </div>
  </div>
</div>

<details class="acc-strategic">
  <summary>Kenapa kehadiran dan keterlambatan jadi angka utama?</summary>
  <div class="acc-body">
    <div class="section-head tight">
      <div class="section-eyebrow">Makna Angka Utama</div>
      <h3 class="section-title">Dua hal paling dasar untuk owner</h3>
      <p class="section-copy">Kalau hanya punya waktu singkat, baca kehadiran dan keterlambatan dulu.</p>
    </div>
    <div class="analysis-grid primary">
      <div class="analysis-card {attendanceKpiState === 'safe' ? 'safe' : attendanceKpiState === 'warn' ? 'warn' : 'critical'}">
        <div class="analysis-label">Kehadiran</div>
        <div class="analysis-title">{activeAttendance}% hadir</div>
        <div class="analysis-copy">Kehadiran menjawab pertanyaan paling dasar: apakah orang yang dijadwalkan benar-benar masuk kerja.</div>
        <div class="threshold-line"><strong>Batas:</strong> ≥92% sehat · 85-91% waspada · &lt;85% kritis</div>
        <div class="analysis-link">Lihat cabang/shift di Pola Risiko Shift</div>
      </div>
      <div class="analysis-card {lateKpiState === 'safe' ? 'safe' : lateKpiState === 'warn' ? 'warn' : 'critical'}">
        <div class="analysis-label">Keterlambatan</div>
        <div class="analysis-title">{activeLate}% terlambat</div>
        <div class="analysis-copy">Keterlambatan membaca disiplin operasional. Gunakan sebagai pola awal sebelum masuk tindakan individu.</div>
        <div class="threshold-line"><strong>Batas:</strong> &lt;10% sehat · 10-19% waspada · ≥20% kritis</div>
        <div class="analysis-link">Lihat follow-up di Pusat Aksi</div>
      </div>
    </div>
  </div>
</details>

<div class="health-summary">
  <div class="health-summary-head">
    <div class="health-summary-label">Sinyal Pendukung Kehadiran</div>
    <div class="health-badges">
      <span class="health-badge safe">✓ {secondarySafeCount} sehat</span>
      <span class="health-badge warn">! {secondaryWarnCount} waspada</span>
      <span class="health-badge critical">x {secondaryCriticalCount} kritis</span>
    </div>
  </div>
  <div class="health-list">
    <div class="health-row {coverageKpiState === 'safe' ? 'safe' : coverageKpiState === 'warn' ? 'warn' : 'critical'}">
      <div class="health-icon">{coverageKpiState === 'safe' ? '✅' : coverageKpiState === 'warn' ? '⚠️' : '🚨'}</div>
      <div><span class="health-row-title">Risiko Shift</span> <span class="health-row-copy">- <span class="health-row-value">{activeUnavailable} sesi butuh pengganti</span>. Sehat = 0, Waspada = 1-{activeCoverageWarnLimit}, Kritis = lebih dari {activeCoverageWarnLimit}.</span></div>
    </div>
    <div class="health-row {activeLeave > 0 ? 'warn' : 'safe'}">
      <div class="health-icon">{activeLeave > 0 ? '⚠️' : '✅'}</div>
      <div><span class="health-row-title">Cuti</span> <span class="health-row-copy">- <span class="health-row-value">{activeLeave} sesi cuti</span>. Cuti bukan pelanggaran, tapi tetap perlu dicatat agar shift tidak kekurangan orang.</span></div>
    </div>
  </div>
</div>

<details class="acc-strategic">
  <summary>Kenapa absent dan cuti ikut dibaca bersama?</summary>
  <div class="acc-body">
    <div class="section-head tight">
      <div class="section-eyebrow">Penyebab Kehadiran</div>
      <h3 class="section-title">Bedakan pelanggaran dari kebutuhan roster</h3>
      <p class="section-copy">Absent dan terlambat perlu validasi. Cuti adalah hak pegawai, tetapi operasional tetap perlu pengganti agar shift berjalan.</p>
    </div>
    <div class="analysis-grid supporting">
      <div class="analysis-card {coverageKpiState === 'safe' ? 'safe' : coverageKpiState === 'warn' ? 'warn' : 'critical'}">
        <div class="analysis-label">Absent + Cuti</div>
        <div class="analysis-title">{activeUnavailable} sesi butuh pengganti</div>
        <div class="analysis-copy">{activeKpi?.absent_count ?? activeAbsent} absent · {activeLeave} cuti. Cuti bukan masalah disiplin, tapi tetap perlu ditutup roster.</div>
        <div class="threshold-line"><strong>Batas:</strong> 0 sehat · 1-{activeCoverageWarnLimit} waspada · &gt;{activeCoverageWarnLimit} kritis</div>
        <div class="analysis-link">Lihat detail di Kehadiran dan Pola Risiko Shift</div>
      </div>
      <div class="analysis-card {lateKpiState === 'safe' ? 'safe' : lateKpiState === 'warn' ? 'warn' : 'critical'}">
        <div class="analysis-label">Terlambat</div>
        <div class="analysis-title">{activeLate}% terlambat</div>
        <div class="analysis-copy">Keterlambatan dibaca sebagai pola operasional. Jangan langsung menyimpulkan individu bermasalah sebelum cek jadwal dan shift.</div>
        <div class="threshold-line"><strong>Batas:</strong> &lt;10% sehat · 10-19% waspada · ≥20% kritis</div>
        <div class="analysis-link">Lihat follow-up di Pusat Aksi</div>
      </div>
    </div>
  </div>
</details>

<div class="section-card">
  <div class="section-head tight">
    <div class="section-eyebrow">Konteks Lanjutan</div>
    <h3 class="section-title">Detail tambahan setelah angka utama</h3>
  </div>
  <div class="analysis-grid secondary">
    <div class="analysis-card {activeRoleGap?.gap_sessions > 0 ? 'warn' : 'safe'}">
      <div class="analysis-label">Role Rawan</div>
      <div class="analysis-title">{activeRoleGap?.gap_sessions > 0 ? activeRoleGap.role : 'Tidak dominan'}</div>
      <div class="analysis-copy">{activeRoleGap?.gap_sessions > 0 ? activeRoleGap.branch_name + ' · ' + activeRoleGap.shift_name + ' · ' + activeRoleGap.gap_sessions + ' slot' : 'Komposisi role tidak menunjukkan gap besar.'}</div>
    </div>
    <div class="analysis-card {activePressureBranch ? 'warn' : 'neutral'}">
      <div class="analysis-label">Cabang Rawan</div>
      <div class="analysis-title">{activePeriod === 'y' ? (activeAbsentByBranch[0]?.branch_name ?? 'Tidak dominan') : (activePressureBranch ?? activeAbsentByBranch[0]?.branch_name ?? 'Tidak dominan')}</div>
      <div class="analysis-copy">Gunakan sebagai titik awal cek roster cabang, bukan kesimpulan final.</div>
    </div>
    <div class="analysis-card {activeRosterIssues.length > 0 ? 'warn' : 'safe'}">
      <div class="analysis-label">Pegawai Dicatat</div>
      <div class="analysis-title">{activePeriod === 'y' ? activeRosterIssues.length : activeAttendanceProblems.length} orang/pola</div>
      <div class="analysis-copy">Pegawai dengan absent atau terlambat perlu dilihat sebagai bahan validasi, bukan vonis final.</div>
    </div>
    <div class="analysis-card {activeProblemEmployeeCount > 0 ? 'warn' : 'safe'}">
      <div class="analysis-label">Pusat Aksi</div>
      <div class="analysis-title">{activeProblemEmployeeCount} perlu follow-up</div>
      <div class="analysis-copy">Gunakan pusat aksi sebagai daftar kerja, bukan hukuman otomatis.</div>
    </div>
  </div>
</div>

<div class="section-card">
  <div class="section-head tight">
    <div class="section-eyebrow">Mau Lihat Detail?</div>
    <h3 class="section-title">Pilih subpage sesuai pertanyaan</h3>
  </div>
  <div class="deep-dive-grid">
    <div class="deep-dive-item"><div class="deep-dive-label">Pola Risiko Shift</div><div class="deep-dive-copy">Kejadian kemarin, pola harian 7H, dan pola mingguan 30H.</div></div>
    <div class="deep-dive-item"><div class="deep-dive-label">Kehadiran</div><div class="deep-dive-copy">Daftar pegawai absent, cuti, dan terlambat.</div></div>
    <div class="deep-dive-item"><div class="deep-dive-label">Pusat Aksi</div><div class="deep-dive-copy">Problem pegawai dan langkah tindak lanjut owner.</div></div>
    <div class="deep-dive-item"><div class="deep-dive-label">Analisis Lanjutan</div><div class="deep-dive-copy">Overtime dan produktivitas sebagai konteks tambahan.</div></div>
  </div>
</div>


{:else if activeView === 'attendance'}

<details class="context-acc">
  <summary>📖 Cara membaca Kehadiran Pegawai</summary>
  <div class="acc-body">
    <ul>
      <li>Subpage ini sengaja fokus hanya ke <strong>absent</strong>, <strong>cuti</strong>, dan <strong>keterlambatan</strong>.</li>
      <li><strong>Kemarin</strong> dipakai sebagai laporan kejadian terakhir.</li>
      <li><strong>7 Hari</strong> membaca pola pendek yang perlu segera divalidasi.</li>
      <li><strong>30 Hari</strong> membaca kebiasaan berulang yang layak masuk review jadwal.</li>
      <li>Cuti tidak disamakan dengan pelanggaran, tetapi tetap memengaruhi kebutuhan pengganti shift.</li>
    </ul>
  </div>
</details>

<div class="section-card">
  <div class="section-head">
    <div class="section-eyebrow">📋 Kehadiran Pegawai <span class="timeframe-tag">{activePeriod === 'y' ? 'Kemarin' : activePeriod === '30d' ? '30 Hari' : '7 Hari'}</span></div>
    <h3 class="section-title">Siapa absent, cuti, atau terlambat?</h3>
    <p class="section-copy">Gunakan subpage ini sebagai daftar cek awal. Validasi penyebab sebelum mengambil tindakan personal.</p>
  </div>

  <div class="signal-grid">
    <div class="signal-card {attendanceKpiState === 'safe' ? 'safe' : attendanceKpiState === 'warn' ? 'warn' : 'critical'}">
      <div class="signal-label">✅ Kehadiran</div>
      <div class="signal-title">{activeAttendance}% hadir</div>
      <div class="signal-copy">Sehat minimal 92%, waspada 85-91%, kritis di bawah 85%.</div>
    </div>
    <div class="signal-card {activeAbsent > 0 ? 'warn' : 'safe'}">
      <div class="signal-label">🚫 Absent</div>
      <div class="signal-title">{activeAbsent} sesi</div>
      <div class="signal-copy">Absent perlu validasi penyebab dan dampaknya ke shift.</div>
    </div>
    <div class="signal-card {lateKpiState === 'safe' ? 'safe' : lateKpiState === 'warn' ? 'warn' : 'critical'}">
      <div class="signal-label">⏱️ Terlambat</div>
      <div class="signal-title">{activeLate}%</div>
      <div class="signal-copy">Baca sebagai pola, bukan vonis dari satu kejadian.</div>
    </div>
  </div>

  <details class="acc-strategic" open>
    <summary>{activePeriod === 'y' ? '🧾 Kejadian kemarin' : '📋 Pegawai dengan pola kehadiran'}</summary>
    <div class="acc-body">
      {#if activePeriod === 'y'}
        {#if activeRosterIssues.length > 0}
        <DataTable data={activeRosterIssues} rows=12>
          <Column id="tanggal" title="Tanggal"/>
          <Column id="employee_name" title="Pegawai"/>
          <Column id="role" title="Role"/>
          <Column id="branch_name" title="Cabang"/>
          <Column id="shift_name" title="Shift"/>
          <Column id="status_label" title="Status"/>
          <Column id="roster_action" title="Catatan"/>
        </DataTable>
        {:else}
          <div class="callout safe">Tidak ada pegawai absent atau terlambat pada shift terakhir.</div>
        {/if}
      {:else}
        {#if activeAttendanceProblems.length > 0}
        <DataTable data={activeAttendanceProblems} rows=15>
          <Column id="employee_name" title="Pegawai"/>
          <Column id="role" title="Role"/>
          <Column id="branch_name" title="Cabang"/>
          <Column id="shift_name" title="Shift"/>
          <Column id="total_workdays" title="Hari Terjadwal" fmt="#,##0"/>
          <Column id="total_absent" title="Absent" fmt="#,##0"/>
          <Column id="total_late" title="Terlambat" fmt="#,##0"/>
          <Column id="total_leave" title="Cuti" fmt="#,##0"/>
          <Column id="risk_label" title="Status Pantau"/>
          <Column id="recommended_action" title="Catatan"/>
        </DataTable>
        {:else}
          <div class="callout safe">Tidak ada pola absent atau keterlambatan yang menonjol pada periode ini.</div>
        {/if}
      {/if}
      <div class="callout">📌 <strong>Cara membaca:</strong> mulai dari Absent dan Terlambat. Cuti tetap hak pegawai, tetapi perlu dicatat untuk kebutuhan pengganti shift.</div>
    </div>
  </details>

  <details class="acc-strategic">
    <summary>📅 Pola periode kehadiran</summary>
    <div class="acc-body">
      <DataTable data={activePeriod === '30d' ? activeWeeklyRisk : activeAttendanceTrend} rows=10 />
      <div class="callout">📌 <strong>Cara membaca:</strong> cari tanggal/periode yang sering berisi absent atau keterlambatan tinggi. Itu kandidat review jadwal.</div>
    </div>
  </details>
</div>

{:else if activeView === 'coverage'}

<details class="context-acc"><summary>📖 Cara membaca Pola Risiko Shift</summary><div class="acc-body"><ul><li>Kemarin adalah laporan kejadian.</li><li>7H membaca pola harian.</li><li>30H membaca pola mingguan dan struktur roster.</li></ul></div></details>
<div class="section-card"><div class="section-head"><div class="section-eyebrow">👥 Pola Risiko Shift <span class="timeframe-tag">{activePeriod === 'y' ? 'Laporan Kemarin' : activePeriod === '30d' ? 'Pola Mingguan 30H' : 'Pola Harian 7H'}</span></div><h3 class="section-title">Shift, cabang, atau role mana yang rawan?</h3><p class="section-copy">Subpage ini membedakan masalah disiplin dari masalah kapasitas roster.</p></div>
  <div class="signal-grid"><div class="signal-card neutral"><div class="signal-label">⚠️ Shift Paling Rawan</div><div class="signal-title">{activePeriod === 'y' ? activeRosterIssues.length + ' pegawai absent/terlambat' : (activeShiftCoverage[0]?.shift_name ?? 'Belum ada data shift')}</div><div class="signal-copy">{activePeriod === 'y' ? 'Gunakan sebagai catatan evaluasi shift terakhir.' : 'Skor tekanan ' + (activeShiftCoverage[0]?.pressure_score ?? 0) + '. Cek tanggal, cabang, dan role sebelum menyimpulkan.'}</div></div><div class="signal-card {activeUnavailable > 0 ? 'warn' : 'safe'}"><div class="signal-label">🚫 Perlu Ditutup</div><div class="signal-title">{activeUnavailable} sesi</div><div class="signal-copy">{activeKpi?.absent_count ?? activeAbsent} absent · {activeLeave} cuti.</div></div><div class="signal-card {activeRoleGap?.gap_sessions > 0 ? 'warn' : 'neutral'}"><div class="signal-label">🧩 Role Rawan</div><div class="signal-title">{activeRoleGap?.gap_sessions > 0 ? activeRoleGap.role + ' · ' + activeRoleGap.branch_name : 'Tidak ada role dominan'}</div><div class="signal-copy">{activeRoleGap?.gap_sessions > 0 ? activeRoleGap.shift_name + ' · ' + activeRoleGap.gap_sessions + ' slot' : 'Tidak ada kombinasi role yang menonjol.'}</div></div></div>
  <details class="acc-strategic" open><summary>{activePeriod === '30d' ? '🗓️ Pola Mingguan 30H' : activePeriod === 'y' ? '🧾 Kejadian Kemarin' : '📅 Pola Harian 7H'}</summary><div class="acc-body">{#if activePeriod === '30d'}<DataTable data={activeWeeklyRisk} rows=6 />{:else}<DataTable data={activePeriod === 'y' ? activeRosterIssues : activeAttendanceTrend} rows=12 />{/if}<div class="callout">📌 <strong>Cara membaca:</strong> cari tanggal/periode dengan absent, cuti, late, atau overtime tinggi sebagai kandidat review roster.</div></div></details>
  <details class="acc-strategic"><summary>🧩 Cabang, shift, dan role rawan</summary><div class="acc-body"><DataTable data={activeRoleCoverage} rows=12 /></div></details>
</div>


{:else if activeView === 'advanced'}

<details class="context-acc"><summary>📖 Cara membaca Analisis Lanjutan</summary><div class="acc-body"><ul><li><strong>Analisis Lanjutan</strong> berisi overtime dan produktivitas.</li><li>Bagian ini bukan dasar utama menilai pegawai. Gunakan setelah kehadiran dan keterlambatan sudah dipahami.</li><li>Overtime membaca tekanan kapasitas. Produktivitas membaca benchmark kerja yang perlu dibandingkan dalam role dan shift yang sama.</li></ul></div></details>
<div class="section-card"><div class="section-head"><div class="section-eyebrow">🔎 Analisis Lanjutan <span class="timeframe-tag">{activePeriod === '30d' ? '30 Hari' : activePeriod === '7d' ? '7 Hari' : 'Konteks Kemarin'}</span></div><h3 class="section-title">Konteks tambahan: beban kerja dan benchmark produktivitas</h3><p class="section-copy">Baca bagian ini setelah melihat Kehadiran dan Pola Risiko Shift. Tujuannya memberi konteks, bukan membuat vonis performa personal.</p></div>
{#if activePeriod !== 'y'}
  <div class="signal-grid"><div class="signal-card {overtimeKpiState === 'safe' ? 'safe' : overtimeKpiState === 'warn' ? 'warn' : 'critical'}"><div class="signal-label">⚡ Sesi Overtime</div><div class="signal-title">{activeOvertimePct}% sesi overtime</div><div class="signal-copy">Membaca tekanan kapasitas, bukan ranking pegawai.</div></div><div class="signal-card neutral"><div class="signal-label">📈 Produktivitas per Jam</div><div class="signal-title">Rp {(activeRevenuePerHour ?? 0).toLocaleString('id-ID')} / jam</div><div class="signal-copy">Bandingkan dalam role dan shift yang sama.</div></div><div class="signal-card neutral"><div class="signal-label">👤 Pegawai Benchmark</div><div class="signal-title">{activeTopProductivityEmployee?.employee_name ?? activeTopOvertime[0]?.employee_name ?? 'Belum ada pegawai dominan'}</div><div class="signal-copy">Cek overtime, absent, dan telat sebelum dijadikan reward atau mentor.</div></div></div>
  <div class="callout warn" style="margin-top:14px;">⚠️ <strong>Framing penting:</strong> overtime dan produktivitas mudah disalahbaca. Overtime tinggi bisa berarti kekurangan orang; produktivitas tinggi bisa karena traffic atau role.</div>
  <details class="acc-strategic" open><summary>⚡ Overtime · tekanan kapasitas</summary><div class="acc-body"><DataTable data={activeOvertimePressure} rows=8 /><div style="margin-top:14px;"><DataTable data={activeOvertimeByBranch} rows=8 /></div><div class="callout">📌 <strong>Cara membaca:</strong> mulai dari shift/cabang dengan Total Jam OT dan OT % tertinggi. Jika sama dengan pola absent/cuti, akar masalahnya kemungkinan kapasitas.</div></div></details>
  <details class="acc-strategic"><summary>👤 Pegawai dengan overtime berulang</summary><div class="acc-body"><DataTable data={activeTopOvertime} rows=12 /><div class="callout">📌 <strong>Cara membaca:</strong> cek apakah pegawai yang sama terlalu sering menutup kekurangan roster.</div></div></details>
  <details class="acc-strategic" open><summary>📈 Produktivitas · benchmark per jam</summary><div class="acc-body">{#if activeProductivityByShiftRole.length > 0}<BarChart data={activeProductivityByShiftRole} x="shift_name" y="revenue_per_hour" series="role" type="grouped" title="Revenue per Jam Kerja (Rp) — Shift × Role" yFmt="#,##0" xAxisTitle="Shift" yAxisTitle="Revenue per Jam (Rp)" />{:else}<div class="callout">Data produktivitas per shift dan role belum tersedia.</div>{/if}<div class="callout">📌 <strong>Cara membaca:</strong> gap besar adalah titik awal mencari praktik kerja, bukan vonis individu.</div></div></details>
  <details class="acc-strategic"><summary>🏷️ Pegawai dan role benchmark</summary><div class="acc-body"><DataTable data={activeProductivityByEmployee} rows=15><Column id="employee_name" title="Pegawai"/><Column id="role" title="Role"/><Column id="branch_name" title="Cabang"/><Column id="shift_name" title="Shift"/><Column id="hari_hadir" title="Hari Hadir" fmt="#,##0"/><Column id="revenue_per_hour" title="Rev/Jam (Rp) ↑" fmt="#,##0"/><Column id="orders_per_hour" title="Order/Jam" fmt="0.00"/><Column id="total_overtime_hours" title="Jam OT" fmt="0.0"/><Column id="late_count" title="Terlambat" fmt="#,##0"/><Column id="absent_count" title="Absent" fmt="#,##0"/><Column id="productivity_label" title="Label"/></DataTable><div class="callout">📌 <strong>Cara membaca:</strong> mulai dari Rev/Jam, lalu cek Jam OT, Terlambat, dan Absent. Jangan jadikan ranking mentah.</div></div></details>
{:else}
  <div class="callout">📌 Kemarin terlalu tipis untuk analisis produktivitas. Gunakan 7 Hari atau 30 Hari untuk membaca overtime dan produktivitas dengan lebih stabil.</div>
{/if}
</div>

{:else if activeView === 'coaching'}

<details class="context-acc"><summary>📖 Cara membaca Pusat Aksi Pegawai</summary><div class="acc-body"><ul><li><strong>Pusat Aksi</strong> mengubah sinyal dari subpage lain menjadi daftar problem dan pemecahan masalah.</li><li><strong>Masalah Operasional</strong> berasal dari cabang/shift kurang orang, role rawan, atau overtime tinggi.</li><li><strong>Masalah Kehadiran</strong> berasal dari absent atau terlambat yang perlu divalidasi lewat percakapan.</li><li><strong>Peluang Positif</strong> berasal dari pegawai benchmark yang layak diapresiasi atau dijadikan mentor.</li><li><strong>7H</strong> dipakai sebagai konteks cepat; <strong>30H</strong> dipakai sebagai pola berulang. Keduanya muncul sebagai bukti, bukan tab analisis terpisah.</li></ul></div></details>
<div class="section-card"><div class="section-head"><div class="section-eyebrow">✅ Pusat Aksi Pegawai</div><h3 class="section-title">Problem yang ditemukan dan cara menanganinya</h3><p class="section-copy">Subpage ini menjawab: masalahnya apa, buktinya apa, dampaknya apa, dan owner sebaiknya melakukan apa.</p></div>
  <div class="analysis-grid secondary"><div class="analysis-card {operationalActions.length > 0 ? 'warn' : 'safe'}"><div class="analysis-label">🛠️ Masalah Operasional</div><div class="analysis-title">{operationalActions.length} aksi</div><div class="analysis-copy">Roster, coverage, role rawan, atau overtime.</div></div><div class="analysis-card {attendanceActions.length > 0 ? 'warn' : 'safe'}"><div class="analysis-label">💬 Masalah Kehadiran</div><div class="analysis-title">{attendanceActions.length} aksi</div><div class="analysis-copy">Absent dan terlambat yang butuh validasi.</div></div><div class="analysis-card {positiveActions.length > 0 ? 'safe' : 'neutral'}"><div class="analysis-label">🏅 Peluang Positif</div><div class="analysis-title">{positiveActions.length} aksi</div><div class="analysis-copy">Benchmark produktivitas untuk apresiasi atau mentor.</div></div><div class="analysis-card {priorityAction?.severity === 'Kritis' ? 'critical' : priorityAction?.severity === 'Tinggi' ? 'warn' : priorityAction ? 'neutral' : 'safe'}"><div class="analysis-label">📌 Fokus Utama</div><div class="analysis-title">{actionRootCause}</div><div class="analysis-copy">{actionRootCopy}</div></div></div>
  <div class="callout warn" style="margin-top:14px;">⚠️ <strong>Framing penting:</strong> atur roster dulu sebelum menyalahkan individu. Cuti bukan pelanggaran, overtime bukan otomatis prestasi, dan benchmark jangan terus dijadikan penutup kekurangan orang.</div>
  <details class="acc-strategic" open><summary>🛠️ Masalah Operasional · roster, coverage, overtime</summary><div class="acc-body">{#if operationalActions.length > 0}<div class="workforce-action-stack">{#each operationalActions as action, i}<div class="workforce-action-card {action.severity === 'Kritis' ? 'critical' : action.severity === 'Tinggi' ? 'high' : action.severity === 'Sedang' ? 'moderate' : 'low'}"><div class="action-header"><span class="action-severity">{action.severity} · #{i + 1}</span><span class="action-badge">{action.evidence_window}</span></div><div class="action-title">{action.action_type} · {action.subject_name}</div><div class="action-impact">Problem: {action.action_type}</div><div class="action-rec"><strong>Bukti:</strong> {action.metric_value}</div><div class="action-rec"><strong>Dampak:</strong> {action.impact_text}</div><div class="action-rec"><strong>Pemecahan:</strong> {action.recommended_action}</div><div class="action-rec"><strong>Langkah pertama:</strong> {action.first_step}</div><div class="action-rec"><strong>Batas aman:</strong> {action.guardrail}</div></div>{/each}</div>{:else}<div class="signal-card safe">Tidak ada problem operasional menonjol.</div>{/if}</div></details>
  <details class="acc-strategic" open><summary>💬 Masalah Kehadiran · absent dan keterlambatan</summary><div class="acc-body">{#if attendanceActions.length > 0}<div class="workforce-action-stack">{#each attendanceActions as action, i}<div class="workforce-action-card {action.severity === 'Kritis' ? 'critical' : action.severity === 'Tinggi' ? 'high' : action.severity === 'Sedang' ? 'moderate' : 'low'}"><div class="action-header"><span class="action-severity">{action.severity} · #{i + 1}</span><span class="action-badge">{action.evidence_window}</span></div><div class="action-title">{action.action_type} · {action.subject_name}</div><div class="action-impact">Problem: {action.action_type}</div><div class="action-rec"><strong>Bukti:</strong> {action.metric_value}</div><div class="action-rec"><strong>Dampak:</strong> {action.impact_text}</div><div class="action-rec"><strong>Pemecahan:</strong> {action.recommended_action}</div><div class="action-rec"><strong>Langkah pertama:</strong> {action.first_step}</div><div class="action-rec"><strong>Batas aman:</strong> {action.guardrail}</div></div>{/each}</div>{:else}<div class="signal-card safe">Tidak ada masalah kehadiran menonjol.</div>{/if}</div></details>
  <details class="acc-strategic"><summary>🏅 Peluang Positif · benchmark dan apresiasi</summary><div class="acc-body">{#if positiveActions.length > 0}<div class="workforce-action-stack">{#each positiveActions as action, i}<div class="workforce-action-card low"><div class="action-header"><span class="action-severity">{action.severity} · #{i + 1}</span><span class="action-badge">{action.evidence_window}</span></div><div class="action-title">{action.action_type} · {action.subject_name}</div><div class="action-impact">Peluang: {action.action_type}</div><div class="action-rec"><strong>Bukti:</strong> {action.metric_value}</div><div class="action-rec"><strong>Dampak:</strong> {action.impact_text}</div><div class="action-rec"><strong>Pemecahan:</strong> {action.recommended_action}</div><div class="action-rec"><strong>Langkah pertama:</strong> {action.first_step}</div><div class="action-rec"><strong>Batas aman:</strong> {action.guardrail}</div></div>{/each}</div>{:else}<div class="signal-card neutral">Belum ada peluang positif yang menonjol.</div>{/if}</div></details>
  <details class="acc-strategic"><summary>📋 Tabel audit problem & tindakan</summary><div class="acc-body"><DataTable data={actionQueue} rows=12><Column id="priority" title="Urutan" fmt="#,##0"/><Column id="action_group" title="Problem"/><Column id="evidence_window" title="Konteks"/><Column id="severity" title="Prioritas"/><Column id="action_type" title="Jenis Problem"/><Column id="subject_name" title="Objek"/><Column id="metric_value" title="Bukti"/><Column id="recommended_action" title="Pemecahan"/></DataTable><div class="callout">📌 <strong>Cara membaca tabel:</strong> mulai dari Problem dan Prioritas. 7H berarti konteks cepat; 30H berarti pola berulang.</div></div></details>
</div>

{/if}
</div>

{:else}
<div class="section-card"><div class="section-head"><div class="section-eyebrow">⚠️ Data Belum Tersedia</div><h3 class="section-title">Data pegawai belum tersedia.</h3></div><p class="section-copy">Pastikan source <code>restaurant.employee_shift_performance</code> sudah ter-refresh dan memiliki data yang valid.</p></div>
{/if}
