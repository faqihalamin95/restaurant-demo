---
title: Performa Menu
---

_Cockpit portofolio menu: mana yang harus dijaga, didorong, dinaikkan nilainya, atau dievaluasi._

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

.strategic-stack { display: flex; flex-direction: column; gap: 12px; }
.strategic-header { padding: 0 2px; margin-bottom: 4px; }
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

/* ── Layout ── */
.menu-page { display: flex; flex-direction: column; gap: 22px; margin-top: 10px; }

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
.period-pill-value { font-size: 0.95rem; font-weight: 800; color: var(--color-text-primary); display: flex; align-items: center; gap: 6px; margin-bottom: 4px; }
.period-pill-copy  { font-size: 0.8rem; line-height: 1.5; color: var(--color-text-secondary); }
.pill-badge { display: inline-block; padding: 2px 8px; border-radius: 999px; font-size: 10px; font-weight: 700; }
.pill-badge.sehat   { background: rgba(22,163,74,0.15);  color: #15803d; }
.pill-badge.waspada { background: rgba(245,158,11,0.18); color: #b45309; }
.pill-badge.kritis  { background: rgba(239,68,68,0.15);  color: #b91c1c; }

.subpage-period-control {
  display: flex;
  flex-direction: column;
  gap: 8px;
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
.subpage-period-copy {
  margin-top: -3px;
  font-size: 0.82rem;
  line-height: 1.55;
  color: var(--color-text-secondary);
}
.control-stack {
  display: flex;
  flex-direction: column;
  gap: 10px;
}
.control-scroll {
  max-width: 100%;
  overflow-x: auto;
  overflow-y: hidden;
  padding-bottom: 2px;
}
.control-scroll > * {
  min-width: max-content;
}
.control-scroll::-webkit-scrollbar { height: 6px; }
.control-scroll::-webkit-scrollbar-thumb {
  background: rgba(99,102,241,0.24);
  border-radius: 999px;
}

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

/* ── Menu Summary ── */
.menu-status {
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
.menu-status.safe {
  border-color: rgba(22,163,74,0.30);
  background:
    radial-gradient(circle at top right, rgba(22,163,74,0.16), transparent 35%),
    linear-gradient(135deg, rgba(22,163,74,0.095), rgba(16,185,129,0.045)),
    var(--color-background-secondary);
}
.menu-status.warn {
  border-color: rgba(245,158,11,0.36);
  background:
    radial-gradient(circle at top right, rgba(245,158,11,0.18), transparent 35%),
    linear-gradient(135deg, rgba(245,158,11,0.12), rgba(251,191,36,0.055)),
    var(--color-background-secondary);
}
.menu-status.critical {
  border-color: rgba(239,68,68,0.32);
  background:
    radial-gradient(circle at top right, rgba(239,68,68,0.16), transparent 35%),
    linear-gradient(135deg, rgba(239,68,68,0.11), rgba(220,38,38,0.05)),
    var(--color-background-secondary);
}
.menu-status-label { font-size: 11px; font-weight: 700; letter-spacing: 0.13em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 8px; }
.menu-status-title { margin: 0 0 10px; font-size: 1.9rem; line-height: 1.1; letter-spacing: -0.035em; color: var(--color-text-primary); }
.menu-status-copy { margin: 0; max-width: 62ch; font-size: 0.95rem; line-height: 1.75; color: var(--color-text-secondary); }
.menu-status-action { margin-top: 14px; padding: 12px 14px; border-radius: 14px; border-left: 4px solid rgba(37,99,235,0.38); background: rgba(37,99,235,0.045); font-size: 0.88rem; line-height: 1.65; color: var(--color-text-secondary); }
.menu-status.safe .menu-status-action { border-left-color: rgba(22,163,74,0.48); background: rgba(22,163,74,0.055); }
.menu-status.warn .menu-status-action { border-left-color: rgba(245,158,11,0.56); background: rgba(245,158,11,0.065); }
.menu-status.critical .menu-status-action { border-left-color: rgba(239,68,68,0.50); background: rgba(239,68,68,0.055); }
.menu-status-action strong { color: var(--color-text-primary); }
.menu-status-metrics { display: flex; flex-direction: column; gap: 10px; }
.menu-status-metric { flex: 1; padding: 14px 15px; border-radius: 14px; border: 1px solid var(--color-border-tertiary); background: rgba(255,255,255,0.72); }
.menu-status-metric-label { font-size: 10px; font-weight: 700; letter-spacing: 0.1em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 4px; }
.menu-status-metric-value { font-size: 1.05rem; font-weight: 800; color: var(--color-text-primary); letter-spacing: -0.02em; }
.menu-status-metric-note { margin-top: 4px; font-size: 0.82rem; line-height: 1.6; color: var(--color-text-secondary); }
.menu-health { padding: 17px 18px; border-radius: 16px; border: 1px solid var(--color-border-tertiary); background: var(--color-background-secondary); box-shadow: 0 1px 3px rgba(0,0,0,0.035); }
.menu-health-head { display: flex; align-items: center; justify-content: space-between; gap: 10px; flex-wrap: wrap; padding-bottom: 12px; margin-bottom: 12px; border-bottom: 1px solid var(--color-border-tertiary); }
.menu-health-label { font-size: 10px; font-weight: 850; letter-spacing: 0.11em; text-transform: uppercase; color: var(--color-text-tertiary); }
.menu-health-badges { display: flex; align-items: center; gap: 8px; flex-wrap: wrap; }
.menu-health-badge { display: inline-flex; align-items: center; gap: 5px; padding: 4px 10px; border-radius: 999px; font-size: 11px; font-weight: 800; border: 1px solid; }
.menu-health-badge.safe { background: rgba(22,163,74,0.10); color: #166534; border-color: rgba(22,163,74,0.22); }
.menu-health-badge.warn { background: rgba(234,179,8,0.10); color: #854d0e; border-color: rgba(234,179,8,0.26); }
.menu-health-badge.critical { background: rgba(220,38,38,0.08); color: #991b1b; border-color: rgba(220,38,38,0.20); }
.menu-health-list { display: flex; flex-direction: column; gap: 6px; }
.menu-health-row { display: flex; align-items: flex-start; gap: 10px; padding: 9px 10px; border-radius: 10px; font-size: 0.84rem; line-height: 1.55; border: 1px solid transparent; }
.menu-health-row.safe { background: rgba(22,163,74,0.045); border-color: rgba(22,163,74,0.12); }
.menu-health-row.warn { background: rgba(234,179,8,0.045); border-color: rgba(234,179,8,0.16); }
.menu-health-row.critical { background: rgba(220,38,38,0.04); border-color: rgba(220,38,38,0.13); }
.menu-health-icon { width: 18px; flex: 0 0 18px; margin-top: 1px; font-size: 14px; line-height: 1.2; text-align: center; }
.menu-health-title { font-weight: 850; color: var(--color-text-primary); }
.menu-health-copy { color: var(--color-text-secondary); }
.menu-health-value { font-weight: 850; color: var(--color-text-primary); }
.menu-analysis-grid { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 12px; }
.menu-analysis-grid.context { grid-template-columns: repeat(4, minmax(0, 1fr)); }
.menu-analysis-card { padding: 16px; border-radius: 16px; border: 1px solid var(--color-border-tertiary); background: var(--color-background-secondary); }
.menu-analysis-card.safe { border-color: rgba(22,163,74,0.24); background: rgba(22,163,74,0.045); }
.menu-analysis-card.warn { border-color: rgba(245,158,11,0.28); background: rgba(245,158,11,0.055); }
.menu-analysis-card.critical { border-color: rgba(239,68,68,0.24); background: rgba(239,68,68,0.045); }
.menu-analysis-card.neutral { border-color: rgba(99,102,241,0.18); background: rgba(99,102,241,0.035); }
.menu-analysis-label { font-size: 10px; font-weight: 800; letter-spacing: 0.09em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 6px; }
.menu-analysis-title { font-size: 0.98rem; font-weight: 850; color: var(--color-text-primary); line-height: 1.3; margin-bottom: 6px; }
.menu-analysis-copy { font-size: 0.84rem; line-height: 1.62; color: var(--color-text-secondary); }
.menu-threshold-line { margin-top: 9px; padding-top: 8px; border-top: 1px dashed rgba(100,116,139,0.24); font-size: 0.77rem; line-height: 1.55; color: var(--color-text-tertiary); }
.menu-threshold-line strong { color: var(--color-text-primary); }

/* ── KPI Grid — 4 cards ── */
.kpi-grid { display: grid; grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 11px; }
.kpi-card { padding: 16px; border-radius: 18px; border: 1.5px solid var(--color-border-tertiary); background: var(--color-background-secondary); }
.kpi-card.revenue { border-color: rgba(37,99,235,0.18);  background: linear-gradient(145deg, rgba(37,99,235,0.06), rgba(99,102,241,0.03)); }
.kpi-card.volume  { border-color: rgba(16,185,129,0.22); background: linear-gradient(145deg, rgba(16,185,129,0.07), rgba(22,163,74,0.03)); }
.kpi-card.mix     { border-color: rgba(245,158,11,0.22); background: linear-gradient(145deg, rgba(245,158,11,0.07), rgba(251,191,36,0.03)); }
.kpi-card.alert   { border-color: rgba(239,68,68,0.22);  background: linear-gradient(145deg, rgba(239,68,68,0.07), rgba(220,38,38,0.03)); }
.kpi-label { font-size: 10px; font-weight: 700; letter-spacing: 0.1em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 7px; }
.kpi-value { font-size: 1rem; font-weight: 800; color: var(--color-text-primary); letter-spacing: -0.02em; }
.kpi-meta  { margin-top: 5px; font-size: 0.8rem; line-height: 1.55; color: var(--color-text-secondary); }

/* ── Signal Grid — 2 cards ── */
.signal-grid { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 12px; }
.signal-card { padding: 17px; border-radius: 16px; border: 1px solid var(--color-border-tertiary); background: var(--color-background-secondary); }
.signal-card.safe     { border-color: rgba(22,163,74,0.25);  background: linear-gradient(135deg, rgba(22,163,74,0.08), rgba(16,185,129,0.03)); }
.signal-card.warn     { border-color: rgba(245,158,11,0.30); background: linear-gradient(135deg, rgba(245,158,11,0.09), rgba(251,191,36,0.03)); }
.signal-card.critical { border-color: rgba(239,68,68,0.25);  background: linear-gradient(135deg, rgba(239,68,68,0.09), rgba(220,38,38,0.03)); }
.signal-card.neutral  { border-color: rgba(99,102,241,0.20); background: linear-gradient(135deg, rgba(99,102,241,0.07), rgba(139,92,246,0.03)); }
.signal-label { font-size: 10px; font-weight: 700; letter-spacing: 0.09em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 5px; }
.signal-title { font-size: 0.96rem; font-weight: 800; color: var(--color-text-primary); margin-bottom: 5px; }
.signal-copy  { font-size: 0.87rem; line-height: 1.68; color: var(--color-text-secondary); }

/* ── Legend chips (compact inline) ── */
.legend-chips { display: flex; flex-wrap: wrap; gap: 7px; margin-bottom: 14px; }
.legend-chip  { display: inline-flex; align-items: center; gap: 5px; padding: 4px 10px; border-radius: 999px; font-size: 11px; font-weight: 700; border: 1px solid; }
.legend-chip.star      { background: rgba(22,163,74,0.08);  border-color: rgba(22,163,74,0.25);  color: #15803d; }
.legend-chip.mystery   { background: rgba(245,158,11,0.08); border-color: rgba(245,158,11,0.25); color: #b45309; }
.legend-chip.workhorse { background: rgba(59,130,246,0.08); border-color: rgba(59,130,246,0.25); color: #1d4ed8; }
.legend-chip.weak      { background: rgba(239,68,68,0.06);  border-color: rgba(239,68,68,0.22);  color: #b91c1c; }

/* ── Section card ── */
.section-card { padding: 20px; border-radius: 20px; border: 1px solid var(--color-border-tertiary); background: var(--color-background-secondary); }
.section-head { margin-bottom: 13px; }
.section-eyebrow { font-size: 10px; font-weight: 700; letter-spacing: 0.11em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 4px; display: flex; align-items: center; gap: 5px; flex-wrap: wrap; }
.section-title { margin: 0; font-size: 1.08rem; font-weight: 800; letter-spacing: -0.02em; color: var(--color-text-primary); }
.section-copy  { margin: 4px 0 0; font-size: 0.87rem; line-height: 1.7; color: var(--color-text-secondary); max-width: 70ch; }
.timeframe-tag { display: inline-block; padding: 2px 7px; border-radius: 999px; font-size: 10px; font-weight: 700; background: rgba(0,0,0,0.05); color: var(--color-text-tertiary); }

/* ── Overview snapshots ── */
.snapshot-grid { display: grid; grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 10px; }
.snapshot-card {
  padding: 14px 15px; border-radius: 16px;
  border: 1px solid var(--color-border-tertiary);
  background: var(--color-background-secondary);
}
.snapshot-card.star      { border-color: rgba(22,163,74,0.22);  background: linear-gradient(145deg, rgba(22,163,74,0.07), rgba(16,185,129,0.03)); }
.snapshot-card.mystery   { border-color: rgba(245,158,11,0.24); background: linear-gradient(145deg, rgba(245,158,11,0.08), rgba(251,191,36,0.03)); }
.snapshot-card.workhorse { border-color: rgba(59,130,246,0.22); background: linear-gradient(145deg, rgba(59,130,246,0.07), rgba(37,99,235,0.03)); }
.snapshot-card.weak      { border-color: rgba(239,68,68,0.22);  background: linear-gradient(145deg, rgba(239,68,68,0.07), rgba(220,38,38,0.03)); }
.snapshot-label { font-size: 10px; font-weight: 800; letter-spacing: 0.1em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 6px; }
.snapshot-value { font-size: 1.12rem; font-weight: 900; color: var(--color-text-primary); letter-spacing: -0.025em; }
.snapshot-copy  { margin-top: 4px; font-size: 0.8rem; line-height: 1.55; color: var(--color-text-secondary); }
.priority-grid { display: grid; grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 10px; }
.priority-card {
  padding: 15px; border-radius: 16px;
  border: 1px solid var(--color-border-tertiary);
  background: var(--color-background-secondary);
}
.priority-label { font-size: 10px; font-weight: 800; letter-spacing: 0.1em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 7px; }
.priority-title { font-size: 0.94rem; font-weight: 850; color: var(--color-text-primary); line-height: 1.35; }
.priority-copy  { margin-top: 5px; font-size: 0.82rem; line-height: 1.6; color: var(--color-text-secondary); }
.priority-metric { margin-top: 8px; display: inline-block; padding: 3px 8px; border-radius: 999px; background: rgba(0,0,0,0.05); font-size: 10px; font-weight: 750; color: var(--color-text-tertiary); }
.period-guide {
  padding: 16px 18px; border-radius: 18px;
  border: 1.5px solid rgba(99,102,241,0.18);
  background: linear-gradient(135deg, rgba(99,102,241,0.06), rgba(59,130,246,0.03));
}
.period-guide-label { font-size: 10px; font-weight: 800; letter-spacing: 0.12em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 5px; }
.period-guide-title { font-size: 1rem; font-weight: 850; letter-spacing: -0.02em; color: var(--color-text-primary); }
.period-guide-copy { margin-top: 5px; font-size: 0.86rem; line-height: 1.7; color: var(--color-text-secondary); max-width: 78ch; }

/* ── Callout ── */
.callout {
  margin-top: 12px; padding: 11px 15px; border-radius: 12px;
  font-size: 0.87rem; line-height: 1.7; color: var(--color-text-secondary);
  border-left: 3px solid rgba(99,102,241,0.35); background: rgba(99,102,241,0.04);
}
.callout strong { color: var(--color-text-primary); }
.callout.warn { border-left-color: rgba(245,158,11,0.5); background: rgba(245,158,11,0.05); }
.callout.safe { border-left-color: rgba(22,163,74,0.4);  background: rgba(22,163,74,0.05); }

/* ── Action queue ── */
.action-stack { display: flex; flex-direction: column; gap: 10px; }
.action-card {
  padding: 15px 17px; border-radius: 16px;
  border-left: 4px solid; border-top: 1px solid; border-right: 1px solid; border-bottom: 1px solid;
  display: flex; flex-direction: column; gap: 5px;
}
.action-card.critical { border-left-color: #ef4444; border-color: rgba(239,68,68,0.22);  background: rgba(239,68,68,0.04); }
.action-card.high     { border-left-color: #f97316; border-color: rgba(249,115,22,0.22); background: rgba(249,115,22,0.04); }
.action-card.moderate { border-left-color: #f59e0b; border-color: rgba(245,158,11,0.22); background: rgba(245,158,11,0.04); }
.action-card.low      { border-left-color: #64748b; border-color: rgba(100,116,139,0.15); background: rgba(100,116,139,0.03); }
.action-header { display: flex; align-items: center; justify-content: space-between; gap: 10px; flex-wrap: wrap; }
.action-severity { font-size: 9px; font-weight: 800; letter-spacing: 0.1em; text-transform: uppercase; padding: 2px 7px; border-radius: 999px; display: inline-block; }
.action-card.critical .action-severity { background: rgba(239,68,68,0.12);  color: #b91c1c; }
.action-card.high     .action-severity { background: rgba(249,115,22,0.12); color: #c2410c; }
.action-card.moderate .action-severity { background: rgba(245,158,11,0.14); color: #b45309; }
.action-card.low      .action-severity { background: rgba(100,116,139,0.10); color: #475569; }
.action-badge  { padding: 3px 9px; border-radius: 999px; font-size: 10px; font-weight: 700; background: rgba(0,0,0,0.05); color: var(--color-text-tertiary); }
.action-title  { font-size: 0.96rem; font-weight: 800; color: var(--color-text-primary); letter-spacing: -0.02em; }
.action-impact { font-size: 0.82rem; font-weight: 700; padding: 4px 10px; background: rgba(0,0,0,0.04); border-radius: 8px; display: inline-block; color: var(--color-text-primary); }
.action-rec    { font-size: 0.85rem; line-height: 1.65; color: var(--color-text-secondary); }
.action-meta { display: flex; flex-wrap: wrap; gap: 6px; margin-top: 4px; }
.action-meta span { padding: 3px 8px; border-radius: 999px; background: rgba(0,0,0,0.045); font-size: 10px; font-weight: 750; color: var(--color-text-tertiary); }
.action-detail-grid { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 8px; margin-top: 6px; }
.action-detail { padding: 9px 10px; border-radius: 10px; border: 1px solid rgba(128,128,128,0.12); background: rgba(255,255,255,0.48); }
.action-detail-label { font-size: 9px; font-weight: 800; letter-spacing: 0.1em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 3px; }
.action-detail-copy { font-size: 0.8rem; line-height: 1.55; color: var(--color-text-secondary); }

/* ── Responsive ── */
@media (max-width: 1000px) {
  .kpi-grid { grid-template-columns: repeat(2, 1fr); }
  .snapshot-grid, .priority-grid { grid-template-columns: repeat(2, minmax(0, 1fr)); }
  .hero, .menu-status, .menu-analysis-grid, .menu-analysis-grid.context, .period-strip, .signal-grid { grid-template-columns: 1fr; }
}
@media (max-width: 680px) {
  .kpi-grid { grid-template-columns: 1fr 1fr; }
  .snapshot-grid, .priority-grid, .menu-analysis-grid, .menu-analysis-grid.context { grid-template-columns: 1fr; }
  .action-detail-grid { grid-template-columns: 1fr; }
  .hero-title { font-size: 1.4rem; }
}
</style>

```sql menu_dates
SELECT
    strftime('%d %b %Y', MAX(order_date))                       AS tgl_akhir,
    strftime('%d %b %Y', MAX(order_date) - INTERVAL '6 days')  AS tgl_7_awal,
    strftime('%d %b %Y', MAX(order_date) - INTERVAL '29 days') AS tgl_30_awal,
    strftime('%d %b %Y', MAX(order_date) - INTERVAL '89 days') AS tgl_90_awal
FROM restaurant.menu_performance
```

```sql menu_health_overview
WITH max_d AS (SELECT MAX(order_date) AS d FROM restaurant.menu_performance),
curr_y AS (
    SELECT menu_name, SUM(total_qty_sold) AS qty, SUM(total_revenue) AS rev
    FROM restaurant.menu_performance CROSS JOIN max_d
    WHERE order_date = d GROUP BY menu_name HAVING SUM(total_qty_sold) > 0
),
curr_7d AS (
    SELECT menu_name, SUM(total_qty_sold) AS qty, SUM(total_revenue) AS rev
    FROM restaurant.menu_performance CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '6 days' GROUP BY menu_name HAVING SUM(total_qty_sold) > 0
),
curr_30d AS (
    SELECT menu_name, SUM(total_qty_sold) AS qty, SUM(total_revenue) AS rev
    FROM restaurant.menu_performance CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '29 days' GROUP BY menu_name HAVING SUM(total_qty_sold) > 0
),
prev_y   AS (SELECT menu_name, SUM(total_qty_sold) AS qty FROM restaurant.menu_performance CROSS JOIN max_d WHERE order_date = d - INTERVAL '7 days' GROUP BY menu_name),
prev_7d  AS (SELECT menu_name, SUM(total_qty_sold) AS qty FROM restaurant.menu_performance CROSS JOIN max_d WHERE order_date >= d - INTERVAL '13 days' AND order_date < d - INTERVAL '6 days' GROUP BY menu_name),
prev_30d AS (SELECT menu_name, SUM(total_qty_sold) AS qty FROM restaurant.menu_performance CROSS JOIN max_d WHERE order_date >= d - INTERVAL '59 days' AND order_date < d - INTERVAL '29 days' GROUP BY menu_name),
med_y    AS (SELECT MEDIAN(qty) AS mq, MEDIAN(rev) AS mr FROM curr_y),
med_7d   AS (SELECT MEDIAN(qty) AS mq, MEDIAN(rev) AS mr FROM curr_7d),
med_30d  AS (SELECT MEDIAN(qty) AS mq, MEDIAN(rev) AS mr FROM curr_30d),
sy AS (
    SELECT COUNT(*) AS ac, SUM(c.rev) AS tr, SUM(c.qty) AS tq,
        SUM(CASE WHEN c.qty < m.mq AND c.rev < m.mr THEN 1 ELSE 0 END) AS wk,
        MAX(CASE WHEN rn_q=1 THEN c.menu_name END) AS tvm,
        MAX(CASE WHEN rn_r=1 THEN c.menu_name END) AS trm,
        SUM(CASE WHEN COALESCE(p.qty,0)>0 AND c.qty<=COALESCE(p.qty,0)*0.8 THEN 1 ELSE 0 END) AS dc,
        SUM(CASE WHEN COALESCE(p.qty,0)>0 AND c.qty>=COALESCE(p.qty,0)*1.2 THEN 1 ELSE 0 END) AS rc
    FROM (SELECT *, ROW_NUMBER() OVER (ORDER BY qty DESC) AS rn_q, ROW_NUMBER() OVER (ORDER BY rev DESC) AS rn_r FROM curr_y) c
    LEFT JOIN prev_y p ON c.menu_name=p.menu_name CROSS JOIN med_y m
),
t5y  AS (SELECT COALESCE(SUM(rev),0) AS t5r FROM (SELECT rev FROM curr_y  ORDER BY rev DESC LIMIT 5)),
s7 AS (
    SELECT COUNT(*) AS ac, SUM(c.rev) AS tr, SUM(c.qty) AS tq,
        SUM(CASE WHEN c.qty < m.mq AND c.rev < m.mr THEN 1 ELSE 0 END) AS wk,
        MAX(CASE WHEN rn_q=1 THEN c.menu_name END) AS tvm,
        MAX(CASE WHEN rn_r=1 THEN c.menu_name END) AS trm,
        SUM(CASE WHEN COALESCE(p.qty,0)>0 AND c.qty<=COALESCE(p.qty,0)*0.8 THEN 1 ELSE 0 END) AS dc,
        SUM(CASE WHEN COALESCE(p.qty,0)>0 AND c.qty>=COALESCE(p.qty,0)*1.2 THEN 1 ELSE 0 END) AS rc
    FROM (SELECT *, ROW_NUMBER() OVER (ORDER BY qty DESC) AS rn_q, ROW_NUMBER() OVER (ORDER BY rev DESC) AS rn_r FROM curr_7d) c
    LEFT JOIN prev_7d p ON c.menu_name=p.menu_name CROSS JOIN med_7d m
),
t57  AS (SELECT COALESCE(SUM(rev),0) AS t5r FROM (SELECT rev FROM curr_7d  ORDER BY rev DESC LIMIT 5)),
s30 AS (
    SELECT COUNT(*) AS ac, SUM(c.rev) AS tr, SUM(c.qty) AS tq,
        SUM(CASE WHEN c.qty < m.mq AND c.rev < m.mr THEN 1 ELSE 0 END) AS wk,
        MAX(CASE WHEN rn_q=1 THEN c.menu_name END) AS tvm,
        MAX(CASE WHEN rn_r=1 THEN c.menu_name END) AS trm,
        SUM(CASE WHEN COALESCE(p.qty,0)>0 AND c.qty<=COALESCE(p.qty,0)*0.8 THEN 1 ELSE 0 END) AS dc,
        SUM(CASE WHEN COALESCE(p.qty,0)>0 AND c.qty>=COALESCE(p.qty,0)*1.2 THEN 1 ELSE 0 END) AS rc
    FROM (SELECT *, ROW_NUMBER() OVER (ORDER BY qty DESC) AS rn_q, ROW_NUMBER() OVER (ORDER BY rev DESC) AS rn_r FROM curr_30d) c
    LEFT JOIN prev_30d p ON c.menu_name=p.menu_name CROSS JOIN med_30d m
),
t530 AS (SELECT COALESCE(SUM(rev),0) AS t5r FROM (SELECT rev FROM curr_30d ORDER BY rev DESC LIMIT 5)),
raw AS (
    SELECT
        sy.ac AS active_y,  sy.tr AS rev_y,  sy.tq AS qty_y,  sy.wk AS weak_y,  sy.dc AS declining_y,  sy.rc AS rising_y,
        sy.tvm AS top_volume_menu_y,  sy.trm AS top_revenue_menu_y,
        ROUND(t5y.t5r*100.0/NULLIF(sy.tr,0),1) AS top5_share_y,
        s7.ac AS active_7d, s7.tr AS rev_7d, s7.tq AS qty_7d, s7.wk AS weak_7d, s7.dc AS declining_7d, s7.rc AS rising_7d,
        s7.tvm AS top_volume_menu_7d, s7.trm AS top_revenue_menu_7d,
        ROUND(t57.t5r*100.0/NULLIF(s7.tr,0),1) AS top5_share_7d,
        s30.ac AS active_30d,s30.tr AS rev_30d,s30.tq AS qty_30d,s30.wk AS weak_30d,s30.dc AS declining_30d,s30.rc AS rising_30d,
        s30.tvm AS top_volume_menu_30d,s30.trm AS top_revenue_menu_30d,
        ROUND(t530.t5r*100.0/NULLIF(s30.tr,0),1) AS top5_share_30d
    FROM sy CROSS JOIN t5y CROSS JOIN s7 CROSS JOIN t57 CROSS JOIN s30 CROSS JOIN t530
)
SELECT *,
    CASE WHEN top5_share_y>=70 OR declining_y>=5 OR (active_y>0 AND weak_y*1.0/NULLIF(active_y,0)>=0.40) THEN 'Kritis'
         WHEN top5_share_y>=55 OR declining_y>=2 OR (active_y>0 AND weak_y*1.0/NULLIF(active_y,0)>=0.25) THEN 'Waspada'
         ELSE 'Sehat' END AS status_y,
    CASE WHEN top5_share_y>=70 THEN 'Konsentrasi revenue' WHEN declining_y>=2 THEN 'Menu menurun'
         WHEN active_y>0 AND weak_y*1.0/NULLIF(active_y,0)>=0.25 THEN 'Menu lemah' ELSE 'Portofolio sehat' END AS focus_y,
    CASE WHEN top5_share_7d>=70 OR declining_7d>=5 OR (active_7d>0 AND weak_7d*1.0/NULLIF(active_7d,0)>=0.40) THEN 'Kritis'
         WHEN top5_share_7d>=55 OR declining_7d>=2 OR (active_7d>0 AND weak_7d*1.0/NULLIF(active_7d,0)>=0.25) THEN 'Waspada'
         ELSE 'Sehat' END AS status_7d,
    CASE WHEN top5_share_7d>=70 THEN 'Konsentrasi revenue' WHEN declining_7d>=2 THEN 'Menu menurun'
         WHEN active_7d>0 AND weak_7d*1.0/NULLIF(active_7d,0)>=0.25 THEN 'Menu lemah' ELSE 'Portofolio sehat' END AS focus_7d,
    CASE WHEN top5_share_30d>=70 OR declining_30d>=5 OR (active_30d>0 AND weak_30d*1.0/NULLIF(active_30d,0)>=0.40) THEN 'Kritis'
         WHEN top5_share_30d>=55 OR declining_30d>=2 OR (active_30d>0 AND weak_30d*1.0/NULLIF(active_30d,0)>=0.25) THEN 'Waspada'
         ELSE 'Sehat' END AS status_30d,
    CASE WHEN top5_share_30d>=70 THEN 'Konsentrasi revenue' WHEN declining_30d>=2 THEN 'Menu menurun'
         WHEN active_30d>0 AND weak_30d*1.0/NULLIF(active_30d,0)>=0.25 THEN 'Menu lemah' ELSE 'Portofolio sehat' END AS focus_30d
FROM raw
```

```sql menu_kpi_y
SELECT SUM(total_qty_sold) AS total_qty, SUM(total_revenue) AS total_revenue,
    COUNT(DISTINCT menu_name) AS active_menu_count,
    ROUND(SUM(total_revenue)/NULLIF(COUNT(DISTINCT menu_name),0),0) AS avg_revenue_per_menu,
    MAX(CASE WHEN rn_q=1 THEN menu_name END) AS top_volume_menu,
    MAX(CASE WHEN rn_q=1 THEN total_qty_sold END) AS top_volume_qty,
    MAX(CASE WHEN rn_r=1 THEN menu_name END) AS top_revenue_menu,
    MAX(CASE WHEN rn_r=1 THEN total_revenue END) AS top_revenue_value,
    ROUND(SUM(CASE WHEN rn_r<=5 THEN total_revenue ELSE 0 END)*100.0/NULLIF(SUM(total_revenue),0),1) AS top5_revenue_share
FROM (
    SELECT menu_name, SUM(total_qty_sold) AS total_qty_sold, SUM(total_revenue) AS total_revenue,
        ROW_NUMBER() OVER (ORDER BY SUM(total_qty_sold) DESC) AS rn_q,
        ROW_NUMBER() OVER (ORDER BY SUM(total_revenue) DESC) AS rn_r
    FROM restaurant.menu_performance
    WHERE order_date = (SELECT MAX(order_date) FROM restaurant.menu_performance)
    GROUP BY menu_name HAVING SUM(total_qty_sold)>0
)
```

```sql menu_kpi_7d
SELECT SUM(total_qty_sold) AS total_qty, SUM(total_revenue) AS total_revenue,
    COUNT(DISTINCT menu_name) AS active_menu_count,
    ROUND(SUM(total_revenue)/NULLIF(COUNT(DISTINCT menu_name),0),0) AS avg_revenue_per_menu,
    MAX(CASE WHEN rn_q=1 THEN menu_name END) AS top_volume_menu,
    MAX(CASE WHEN rn_q=1 THEN total_qty_sold END) AS top_volume_qty,
    MAX(CASE WHEN rn_r=1 THEN menu_name END) AS top_revenue_menu,
    MAX(CASE WHEN rn_r=1 THEN total_revenue END) AS top_revenue_value,
    ROUND(SUM(CASE WHEN rn_r<=5 THEN total_revenue ELSE 0 END)*100.0/NULLIF(SUM(total_revenue),0),1) AS top5_revenue_share
FROM (
    SELECT menu_name, SUM(total_qty_sold) AS total_qty_sold, SUM(total_revenue) AS total_revenue,
        ROW_NUMBER() OVER (ORDER BY SUM(total_qty_sold) DESC) AS rn_q,
        ROW_NUMBER() OVER (ORDER BY SUM(total_revenue) DESC) AS rn_r
    FROM restaurant.menu_performance
    WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '6 days'
    GROUP BY menu_name HAVING SUM(total_qty_sold)>0
)
```

```sql menu_kpi_30d
SELECT SUM(total_qty_sold) AS total_qty, SUM(total_revenue) AS total_revenue,
    COUNT(DISTINCT menu_name) AS active_menu_count,
    ROUND(SUM(total_revenue)/NULLIF(COUNT(DISTINCT menu_name),0),0) AS avg_revenue_per_menu,
    MAX(CASE WHEN rn_q=1 THEN menu_name END) AS top_volume_menu,
    MAX(CASE WHEN rn_q=1 THEN total_qty_sold END) AS top_volume_qty,
    MAX(CASE WHEN rn_r=1 THEN menu_name END) AS top_revenue_menu,
    MAX(CASE WHEN rn_r=1 THEN total_revenue END) AS top_revenue_value,
    ROUND(SUM(CASE WHEN rn_r<=5 THEN total_revenue ELSE 0 END)*100.0/NULLIF(SUM(total_revenue),0),1) AS top5_revenue_share
FROM (
    SELECT menu_name, SUM(total_qty_sold) AS total_qty_sold, SUM(total_revenue) AS total_revenue,
        ROW_NUMBER() OVER (ORDER BY SUM(total_qty_sold) DESC) AS rn_q,
        ROW_NUMBER() OVER (ORDER BY SUM(total_revenue) DESC) AS rn_r
    FROM restaurant.menu_performance
    WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '29 days'
    GROUP BY menu_name HAVING SUM(total_qty_sold)>0
)
```

```sql menu_engineering_y
WITH base AS (
    SELECT menu_name,
        CASE category WHEN 'main' THEN 'Menu Utama' WHEN 'drink' THEN 'Minuman'
            WHEN 'snack' THEN 'Camilan' WHEN 'dessert' THEN 'Dessert' WHEN 'side' THEN 'Pendamping' ELSE category END AS category,
        price_tier, SUM(total_qty_sold) AS total_qty, SUM(total_revenue) AS total_revenue,
        ROUND(SUM(total_revenue)/NULLIF(SUM(total_qty_sold),0),0) AS avg_price_realisasi
    FROM restaurant.menu_performance
    WHERE order_date = (SELECT MAX(order_date) FROM restaurant.menu_performance)
    GROUP BY menu_name, category, price_tier
)
SELECT *,
    menu_name || ' · ' || category AS tooltip_label,
    CASE
        WHEN total_qty>=MEDIAN(total_qty) OVER () AND total_revenue>=MEDIAN(total_revenue) OVER () THEN 'Primadona'
        WHEN total_qty>=MEDIAN(total_qty) OVER () AND total_revenue< MEDIAN(total_revenue) OVER () THEN 'Pekerja Keras'
        WHEN total_qty< MEDIAN(total_qty) OVER () AND total_revenue>=MEDIAN(total_revenue) OVER () THEN 'Misteri'
        ELSE 'Lemah'
    END AS klasifikasi,
    CASE
        WHEN total_qty>=MEDIAN(total_qty) OVER () AND total_revenue>=MEDIAN(total_revenue) OVER () THEN 'Jaga stok & kualitas'
        WHEN total_qty>=MEDIAN(total_qty) OVER () AND total_revenue< MEDIAN(total_revenue) OVER () THEN 'Uji bundling / harga'
        WHEN total_qty< MEDIAN(total_qty) OVER () AND total_revenue>=MEDIAN(total_revenue) OVER () THEN 'Dorong visibilitas'
        ELSE 'Validasi tren dulu'
    END AS aksi_disarankan
FROM base
ORDER BY total_revenue DESC
```

```sql menu_engineering_7d
WITH base AS (
    SELECT menu_name,
        CASE category WHEN 'main' THEN 'Menu Utama' WHEN 'drink' THEN 'Minuman'
            WHEN 'snack' THEN 'Camilan' WHEN 'dessert' THEN 'Dessert' WHEN 'side' THEN 'Pendamping' ELSE category END AS category,
        price_tier, SUM(total_qty_sold) AS total_qty, SUM(total_revenue) AS total_revenue,
        ROUND(SUM(total_revenue)/NULLIF(SUM(total_qty_sold),0),0) AS avg_price_realisasi
    FROM restaurant.menu_performance
    WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '6 days'
    GROUP BY menu_name, category, price_tier
)
SELECT *,
    menu_name || ' · ' || category AS tooltip_label,
    CASE
        WHEN total_qty>=MEDIAN(total_qty) OVER () AND total_revenue>=MEDIAN(total_revenue) OVER () THEN 'Primadona'
        WHEN total_qty>=MEDIAN(total_qty) OVER () AND total_revenue< MEDIAN(total_revenue) OVER () THEN 'Pekerja Keras'
        WHEN total_qty< MEDIAN(total_qty) OVER () AND total_revenue>=MEDIAN(total_revenue) OVER () THEN 'Misteri'
        ELSE 'Lemah'
    END AS klasifikasi,
    CASE
        WHEN total_qty>=MEDIAN(total_qty) OVER () AND total_revenue>=MEDIAN(total_revenue) OVER () THEN 'Jaga stok & kualitas'
        WHEN total_qty>=MEDIAN(total_qty) OVER () AND total_revenue< MEDIAN(total_revenue) OVER () THEN 'Uji bundling / harga'
        WHEN total_qty< MEDIAN(total_qty) OVER () AND total_revenue>=MEDIAN(total_revenue) OVER () THEN 'Dorong visibilitas'
        ELSE 'Validasi tren dulu'
    END AS aksi_disarankan
FROM base
ORDER BY total_revenue DESC
```

```sql menu_engineering_30d
WITH base AS (
    SELECT menu_name,
        CASE category WHEN 'main' THEN 'Menu Utama' WHEN 'drink' THEN 'Minuman'
            WHEN 'snack' THEN 'Camilan' WHEN 'dessert' THEN 'Dessert' WHEN 'side' THEN 'Pendamping' ELSE category END AS category,
        price_tier, SUM(total_qty_sold) AS total_qty, SUM(total_revenue) AS total_revenue,
        ROUND(SUM(total_revenue)/NULLIF(SUM(total_qty_sold),0),0) AS avg_price_realisasi
    FROM restaurant.menu_performance
    WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '29 days'
    GROUP BY menu_name, category, price_tier
)
SELECT *,
    menu_name || ' · ' || category AS tooltip_label,
    CASE
        WHEN total_qty>=MEDIAN(total_qty) OVER () AND total_revenue>=MEDIAN(total_revenue) OVER () THEN 'Primadona'
        WHEN total_qty>=MEDIAN(total_qty) OVER () AND total_revenue< MEDIAN(total_revenue) OVER () THEN 'Pekerja Keras'
        WHEN total_qty< MEDIAN(total_qty) OVER () AND total_revenue>=MEDIAN(total_revenue) OVER () THEN 'Misteri'
        ELSE 'Lemah'
    END AS klasifikasi,
    CASE
        WHEN total_qty>=MEDIAN(total_qty) OVER () AND total_revenue>=MEDIAN(total_revenue) OVER () THEN 'Jaga stok & kualitas'
        WHEN total_qty>=MEDIAN(total_qty) OVER () AND total_revenue< MEDIAN(total_revenue) OVER () THEN 'Uji bundling / harga'
        WHEN total_qty< MEDIAN(total_qty) OVER () AND total_revenue>=MEDIAN(total_revenue) OVER () THEN 'Dorong visibilitas'
        ELSE 'Validasi tren dulu'
    END AS aksi_disarankan
FROM base
ORDER BY total_revenue DESC
```

```sql top5_vol_y
SELECT menu_name,
    CASE category WHEN 'main' THEN 'Menu Utama' WHEN 'drink' THEN 'Minuman' WHEN 'snack' THEN 'Camilan' WHEN 'dessert' THEN 'Dessert' WHEN 'side' THEN 'Pendamping' ELSE category END AS category,
    SUM(total_qty_sold) AS total_qty
FROM restaurant.menu_performance
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.menu_performance)
GROUP BY menu_name, category ORDER BY total_qty DESC LIMIT 5
```

```sql top5_vol_7d
SELECT menu_name,
    CASE category WHEN 'main' THEN 'Menu Utama' WHEN 'drink' THEN 'Minuman' WHEN 'snack' THEN 'Camilan' WHEN 'dessert' THEN 'Dessert' WHEN 'side' THEN 'Pendamping' ELSE category END AS category,
    SUM(total_qty_sold) AS total_qty
FROM restaurant.menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '6 days'
GROUP BY menu_name, category ORDER BY total_qty DESC LIMIT 5
```

```sql top5_vol_30d
SELECT menu_name,
    CASE category WHEN 'main' THEN 'Menu Utama' WHEN 'drink' THEN 'Minuman' WHEN 'snack' THEN 'Camilan' WHEN 'dessert' THEN 'Dessert' WHEN 'side' THEN 'Pendamping' ELSE category END AS category,
    SUM(total_qty_sold) AS total_qty
FROM restaurant.menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '29 days'
GROUP BY menu_name, category ORDER BY total_qty DESC LIMIT 5
```

```sql top5_rev_y
SELECT menu_name,
    CASE category WHEN 'main' THEN 'Menu Utama' WHEN 'drink' THEN 'Minuman' WHEN 'snack' THEN 'Camilan' WHEN 'dessert' THEN 'Dessert' WHEN 'side' THEN 'Pendamping' ELSE category END AS category,
    SUM(total_revenue) AS total_revenue
FROM restaurant.menu_performance
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.menu_performance)
GROUP BY menu_name, category ORDER BY total_revenue DESC LIMIT 5
```

```sql top5_rev_7d
SELECT menu_name,
    CASE category WHEN 'main' THEN 'Menu Utama' WHEN 'drink' THEN 'Minuman' WHEN 'snack' THEN 'Camilan' WHEN 'dessert' THEN 'Dessert' WHEN 'side' THEN 'Pendamping' ELSE category END AS category,
    SUM(total_revenue) AS total_revenue
FROM restaurant.menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '6 days'
GROUP BY menu_name, category ORDER BY total_revenue DESC LIMIT 5
```

```sql top5_rev_30d
SELECT menu_name,
    CASE category WHEN 'main' THEN 'Menu Utama' WHEN 'drink' THEN 'Minuman' WHEN 'snack' THEN 'Camilan' WHEN 'dessert' THEN 'Dessert' WHEN 'side' THEN 'Pendamping' ELSE category END AS category,
    SUM(total_revenue) AS total_revenue
FROM restaurant.menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '29 days'
GROUP BY menu_name, category ORDER BY total_revenue DESC LIMIT 5
```

```sql cat_mix_y
SELECT
    CASE category WHEN 'main' THEN 'Menu Utama' WHEN 'drink' THEN 'Minuman' WHEN 'snack' THEN 'Camilan' WHEN 'dessert' THEN 'Dessert' WHEN 'side' THEN 'Pendamping' ELSE category END AS category,
    COUNT(DISTINCT menu_name) AS total_menu, SUM(total_qty_sold) AS total_qty, SUM(total_revenue) AS total_revenue,
    ROUND(SUM(total_revenue)/NULLIF(SUM(total_qty_sold),0),0) AS avg_price_realisasi,
    ROUND(SUM(total_revenue)/NULLIF(SUM(SUM(total_revenue)) OVER (),0)*100,1) AS pct_revenue
FROM restaurant.menu_performance
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.menu_performance)
GROUP BY category ORDER BY total_revenue DESC
```

```sql cat_mix_7d
SELECT
    CASE category WHEN 'main' THEN 'Menu Utama' WHEN 'drink' THEN 'Minuman' WHEN 'snack' THEN 'Camilan' WHEN 'dessert' THEN 'Dessert' WHEN 'side' THEN 'Pendamping' ELSE category END AS category,
    COUNT(DISTINCT menu_name) AS total_menu, SUM(total_qty_sold) AS total_qty, SUM(total_revenue) AS total_revenue,
    ROUND(SUM(total_revenue)/NULLIF(SUM(total_qty_sold),0),0) AS avg_price_realisasi,
    ROUND(SUM(total_revenue)/NULLIF(SUM(SUM(total_revenue)) OVER (),0)*100,1) AS pct_revenue
FROM restaurant.menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '6 days'
GROUP BY category ORDER BY total_revenue DESC
```

```sql cat_mix_30d
SELECT
    CASE category WHEN 'main' THEN 'Menu Utama' WHEN 'drink' THEN 'Minuman' WHEN 'snack' THEN 'Camilan' WHEN 'dessert' THEN 'Dessert' WHEN 'side' THEN 'Pendamping' ELSE category END AS category,
    COUNT(DISTINCT menu_name) AS total_menu, SUM(total_qty_sold) AS total_qty, SUM(total_revenue) AS total_revenue,
    ROUND(SUM(total_revenue)/NULLIF(SUM(total_qty_sold),0),0) AS avg_price_realisasi,
    ROUND(SUM(total_revenue)/NULLIF(SUM(SUM(total_revenue)) OVER (),0)*100,1) AS pct_revenue
FROM restaurant.menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '29 days'
GROUP BY category ORDER BY total_revenue DESC
```

```sql tier_mix_y
SELECT price_tier, COUNT(DISTINCT menu_name) AS total_menu, SUM(total_qty_sold) AS total_qty,
    SUM(total_revenue) AS total_revenue,
    ROUND(SUM(total_revenue)/NULLIF(SUM(SUM(total_revenue)) OVER (),0)*100,1) AS pct_revenue
FROM restaurant.menu_performance
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.menu_performance)
GROUP BY price_tier ORDER BY total_revenue DESC
```

```sql tier_mix_7d
SELECT price_tier, COUNT(DISTINCT menu_name) AS total_menu, SUM(total_qty_sold) AS total_qty,
    SUM(total_revenue) AS total_revenue,
    ROUND(SUM(total_revenue)/NULLIF(SUM(SUM(total_revenue)) OVER (),0)*100,1) AS pct_revenue
FROM restaurant.menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '6 days'
GROUP BY price_tier ORDER BY total_revenue DESC
```

```sql tier_mix_30d
SELECT price_tier, COUNT(DISTINCT menu_name) AS total_menu, SUM(total_qty_sold) AS total_qty,
    SUM(total_revenue) AS total_revenue,
    ROUND(SUM(total_revenue)/NULLIF(SUM(SUM(total_revenue)) OVER (),0)*100,1) AS pct_revenue
FROM restaurant.menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '29 days'
GROUP BY price_tier ORDER BY total_revenue DESC
```

```sql branch_playbook_7d
SELECT branch_name,
    MAX(CASE WHEN rn_qty=1 THEN menu_name END) AS top_volume_menu,
    MAX(CASE WHEN rn_qty=1 THEN total_qty END)  AS top_volume_qty,
    MAX(CASE WHEN rn_rev=1 THEN menu_name END)  AS top_revenue_menu,
    MAX(CASE WHEN rn_rev=1 THEN total_rev END)  AS top_revenue_value,
    CASE
        WHEN MAX(CASE WHEN rn_qty=1 THEN menu_name END) = MAX(CASE WHEN rn_rev=1 THEN menu_name END)
        THEN 'Stok: jaga ' || MAX(CASE WHEN rn_qty=1 THEN menu_name END) || '. Kualitas adalah prioritas utama.'
        ELSE 'Stok: ' || MAX(CASE WHEN rn_qty=1 THEN menu_name END) || '. Upsell: tawarkan ' || MAX(CASE WHEN rn_rev=1 THEN menu_name END) || ' ke setiap meja.'
    END AS recommended_focus
FROM (
    SELECT branch_name, menu_name,
        SUM(total_qty_sold) AS total_qty, SUM(total_revenue) AS total_rev,
        ROW_NUMBER() OVER (PARTITION BY branch_name ORDER BY SUM(total_qty_sold) DESC) AS rn_qty,
        ROW_NUMBER() OVER (PARTITION BY branch_name ORDER BY SUM(total_revenue) DESC)  AS rn_rev
    FROM restaurant.menu_performance
    WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '6 days'
    GROUP BY branch_name, menu_name
)
GROUP BY branch_name ORDER BY branch_name
```

```sql branch_playbook_30d
SELECT branch_name,
    MAX(CASE WHEN rn_qty=1 THEN menu_name END) AS top_volume_menu,
    MAX(CASE WHEN rn_qty=1 THEN total_qty END)  AS top_volume_qty,
    MAX(CASE WHEN rn_rev=1 THEN menu_name END)  AS top_revenue_menu,
    MAX(CASE WHEN rn_rev=1 THEN total_rev END)  AS top_revenue_value,
    CASE
        WHEN MAX(CASE WHEN rn_qty=1 THEN menu_name END) = MAX(CASE WHEN rn_rev=1 THEN menu_name END)
        THEN 'Stok: jaga ' || MAX(CASE WHEN rn_qty=1 THEN menu_name END) || '. Kualitas adalah prioritas utama.'
        ELSE 'Stok: ' || MAX(CASE WHEN rn_qty=1 THEN menu_name END) || '. Upsell: tawarkan ' || MAX(CASE WHEN rn_rev=1 THEN menu_name END) || ' ke setiap meja.'
    END AS recommended_focus
FROM (
    SELECT branch_name, menu_name,
        SUM(total_qty_sold) AS total_qty, SUM(total_revenue) AS total_rev,
        ROW_NUMBER() OVER (PARTITION BY branch_name ORDER BY SUM(total_qty_sold) DESC) AS rn_qty,
        ROW_NUMBER() OVER (PARTITION BY branch_name ORDER BY SUM(total_revenue) DESC)  AS rn_rev
    FROM restaurant.menu_performance
    WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '29 days'
    GROUP BY branch_name, menu_name
)
GROUP BY branch_name ORDER BY branch_name
```

```sql menu_branch_list
SELECT DISTINCT branch_name
FROM restaurant.menu_performance
ORDER BY branch_name
```

```sql menu_branch_detail
WITH max_d AS (SELECT MAX(order_date) AS d FROM restaurant.menu_performance),
periods AS (
    SELECT 'y' AS period, d AS start_date, d AS end_date, d - INTERVAL '7 days' AS prev_start, d - INTERVAL '7 days' AS prev_end FROM max_d
    UNION ALL
    SELECT '7d' AS period, d - INTERVAL '6 days' AS start_date, d AS end_date, d - INTERVAL '13 days' AS prev_start, d - INTERVAL '7 days' AS prev_end FROM max_d
    UNION ALL
    SELECT '30d' AS period, d - INTERVAL '29 days' AS start_date, d AS end_date, d - INTERVAL '59 days' AS prev_start, d - INTERVAL '30 days' AS prev_end FROM max_d
),
curr AS (
    SELECT
        p.period,
        mp.branch_name,
        mp.menu_name,
        CASE mp.category WHEN 'main' THEN 'Menu Utama' WHEN 'drink' THEN 'Minuman'
            WHEN 'snack' THEN 'Camilan' WHEN 'dessert' THEN 'Dessert'
            WHEN 'side' THEN 'Pendamping' ELSE mp.category END AS category,
        mp.price_tier,
        SUM(mp.total_qty_sold) AS qty_current,
        SUM(mp.total_revenue) AS revenue_current
    FROM restaurant.menu_performance mp
    JOIN periods p ON mp.order_date BETWEEN p.start_date AND p.end_date
    GROUP BY p.period, mp.branch_name, mp.menu_name, category, mp.price_tier
),
prev AS (
    SELECT
        p.period,
        mp.branch_name,
        mp.menu_name,
        SUM(mp.total_qty_sold) AS qty_previous,
        SUM(mp.total_revenue) AS revenue_previous
    FROM restaurant.menu_performance mp
    JOIN periods p ON mp.order_date BETWEEN p.prev_start AND p.prev_end
    GROUP BY p.period, mp.branch_name, mp.menu_name
)
SELECT
    c.period,
    c.branch_name,
    c.menu_name,
    c.category,
    c.price_tier,
    c.qty_current,
    c.revenue_current,
    ROUND(c.revenue_current / NULLIF(c.qty_current, 0), 0) AS avg_price,
    ROUND(c.revenue_current * 100.0 / NULLIF(SUM(c.revenue_current) OVER (PARTITION BY c.period, c.branch_name), 0), 1) AS revenue_share_pct,
    COALESCE(p.qty_previous, 0) AS qty_previous,
    COALESCE(p.revenue_previous, 0) AS revenue_previous,
    ROUND((c.qty_current - COALESCE(p.qty_previous, 0)) * 100.0 / NULLIF(p.qty_previous, 0), 1) AS pct_change_qty,
    CASE
        WHEN COALESCE(p.qty_previous, 0)=0 AND c.qty_current>0 THEN 'Baru'
        WHEN ROUND((c.qty_current - COALESCE(p.qty_previous, 0)) * 100.0 / NULLIF(p.qty_previous, 0), 1)<=-20 THEN 'Turun'
        WHEN ROUND((c.qty_current - COALESCE(p.qty_previous, 0)) * 100.0 / NULLIF(p.qty_previous, 0), 1)>=20 THEN 'Naik'
        ELSE 'Stabil'
    END AS movement_status
FROM curr c
LEFT JOIN prev p
    ON c.period=p.period
   AND c.branch_name=p.branch_name
   AND c.menu_name=p.menu_name
WHERE c.qty_current > 0
ORDER BY c.period, c.branch_name, c.revenue_current DESC
```

```sql menu_branch_summary
WITH detail AS (
    SELECT * FROM ${menu_branch_detail}
),
branch_ranked AS (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY period, branch_name ORDER BY qty_current DESC, revenue_current DESC) AS rn_qty,
        ROW_NUMBER() OVER (PARTITION BY period, branch_name ORDER BY revenue_current DESC, qty_current DESC) AS rn_rev
    FROM detail
),
branch_rows AS (
    SELECT
        period,
        branch_name,
        SUM(qty_current) AS total_qty,
        SUM(revenue_current) AS total_revenue,
        COUNT(DISTINCT menu_name) AS active_menu_count,
        MAX(CASE WHEN rn_qty=1 THEN menu_name END) AS top_qty_menu,
        MAX(CASE WHEN rn_qty=1 THEN qty_current END) AS top_qty,
        MAX(CASE WHEN rn_rev=1 THEN menu_name END) AS top_revenue_menu,
        MAX(CASE WHEN rn_rev=1 THEN revenue_current END) AS top_revenue
    FROM branch_ranked
    GROUP BY period, branch_name
),
all_menu AS (
    SELECT period, menu_name, MAX(category) AS category,
        SUM(qty_current) AS qty_current,
        SUM(revenue_current) AS revenue_current
    FROM detail
    GROUP BY period, menu_name
),
all_ranked AS (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY period ORDER BY qty_current DESC, revenue_current DESC) AS rn_qty,
        ROW_NUMBER() OVER (PARTITION BY period ORDER BY revenue_current DESC, qty_current DESC) AS rn_rev
    FROM all_menu
),
all_rows AS (
    SELECT
        period,
        'Semua Cabang' AS branch_name,
        SUM(qty_current) AS total_qty,
        SUM(revenue_current) AS total_revenue,
        COUNT(DISTINCT menu_name) AS active_menu_count,
        MAX(CASE WHEN rn_qty=1 THEN menu_name END) AS top_qty_menu,
        MAX(CASE WHEN rn_qty=1 THEN qty_current END) AS top_qty,
        MAX(CASE WHEN rn_rev=1 THEN menu_name END) AS top_revenue_menu,
        MAX(CASE WHEN rn_rev=1 THEN revenue_current END) AS top_revenue
    FROM all_ranked
    GROUP BY period
),
combined AS (
    SELECT * FROM all_rows
    UNION ALL
    SELECT * FROM branch_rows
)
SELECT *,
    CASE
        WHEN top_qty_menu = top_revenue_menu THEN 'Stok: jaga ' || top_qty_menu || '. Kualitas dan availability adalah prioritas utama.'
        ELSE 'Stok: ' || top_qty_menu || '. Upsell: tawarkan ' || top_revenue_menu || ' ke pelanggan yang relevan.'
    END AS recommended_focus
FROM combined
ORDER BY period, branch_name
```

```sql menu_branch_mix
WITH detail AS (
    SELECT * FROM ${menu_branch_detail}
),
branch_category AS (
    SELECT
        period,
        branch_name,
        'Kategori' AS mix_type,
        category AS segment,
        COUNT(DISTINCT menu_name) AS total_menu,
        SUM(qty_current) AS total_qty,
        SUM(revenue_current) AS total_revenue,
        ROUND(SUM(revenue_current) / NULLIF(SUM(qty_current), 0), 0) AS avg_price,
        ROUND(SUM(revenue_current) * 100.0 / NULLIF(SUM(SUM(revenue_current)) OVER (PARTITION BY period, branch_name), 0), 1) AS pct_revenue
    FROM detail
    GROUP BY period, branch_name, category
),
branch_tier AS (
    SELECT
        period,
        branch_name,
        'Segmen Harga' AS mix_type,
        COALESCE(price_tier, 'Tanpa Segmen') AS segment,
        COUNT(DISTINCT menu_name) AS total_menu,
        SUM(qty_current) AS total_qty,
        SUM(revenue_current) AS total_revenue,
        ROUND(SUM(revenue_current) / NULLIF(SUM(qty_current), 0), 0) AS avg_price,
        ROUND(SUM(revenue_current) * 100.0 / NULLIF(SUM(SUM(revenue_current)) OVER (PARTITION BY period, branch_name), 0), 1) AS pct_revenue
    FROM detail
    GROUP BY period, branch_name, COALESCE(price_tier, 'Tanpa Segmen')
),
all_category AS (
    SELECT
        period,
        'Semua Cabang' AS branch_name,
        'Kategori' AS mix_type,
        category AS segment,
        COUNT(DISTINCT menu_name) AS total_menu,
        SUM(qty_current) AS total_qty,
        SUM(revenue_current) AS total_revenue,
        ROUND(SUM(revenue_current) / NULLIF(SUM(qty_current), 0), 0) AS avg_price,
        ROUND(SUM(revenue_current) * 100.0 / NULLIF(SUM(SUM(revenue_current)) OVER (PARTITION BY period), 0), 1) AS pct_revenue
    FROM detail
    GROUP BY period, category
),
all_tier AS (
    SELECT
        period,
        'Semua Cabang' AS branch_name,
        'Segmen Harga' AS mix_type,
        COALESCE(price_tier, 'Tanpa Segmen') AS segment,
        COUNT(DISTINCT menu_name) AS total_menu,
        SUM(qty_current) AS total_qty,
        SUM(revenue_current) AS total_revenue,
        ROUND(SUM(revenue_current) / NULLIF(SUM(qty_current), 0), 0) AS avg_price,
        ROUND(SUM(revenue_current) * 100.0 / NULLIF(SUM(SUM(revenue_current)) OVER (PARTITION BY period), 0), 1) AS pct_revenue
    FROM detail
    GROUP BY period, COALESCE(price_tier, 'Tanpa Segmen')
)
SELECT * FROM all_category
UNION ALL SELECT * FROM all_tier
UNION ALL SELECT * FROM branch_category
UNION ALL SELECT * FROM branch_tier
ORDER BY period, branch_name, mix_type, total_revenue DESC
```

```sql menu_branch_engineering
WITH detail AS (
    SELECT period, branch_name, menu_name, category, price_tier, qty_current, revenue_current
    FROM ${menu_branch_detail}
),
all_rows AS (
    SELECT
        period,
        'Semua Cabang' AS branch_name,
        menu_name,
        MAX(category) AS category,
        MAX(price_tier) AS price_tier,
        SUM(qty_current) AS total_qty,
        SUM(revenue_current) AS total_revenue
    FROM detail
    GROUP BY period, menu_name
),
branch_rows AS (
    SELECT
        period,
        branch_name,
        menu_name,
        MAX(category) AS category,
        MAX(price_tier) AS price_tier,
        SUM(qty_current) AS total_qty,
        SUM(revenue_current) AS total_revenue
    FROM detail
    GROUP BY period, branch_name, menu_name
),
combined AS (
    SELECT * FROM all_rows
    UNION ALL
    SELECT * FROM branch_rows
),
scored AS (
    SELECT *,
        ROUND(total_revenue / NULLIF(total_qty, 0), 0) AS avg_price_realisasi,
        MEDIAN(total_qty) OVER (PARTITION BY period, branch_name) AS median_qty,
        MEDIAN(total_revenue) OVER (PARTITION BY period, branch_name) AS median_revenue
    FROM combined
)
SELECT
    period,
    branch_name,
    menu_name,
    category,
    price_tier,
    total_qty,
    total_revenue,
    avg_price_realisasi,
    menu_name || ' · ' || category || ' · ' || branch_name AS tooltip_label,
    CASE
        WHEN total_qty>=median_qty AND total_revenue>=median_revenue THEN 'Primadona'
        WHEN total_qty>=median_qty AND total_revenue< median_revenue THEN 'Pekerja Keras'
        WHEN total_qty< median_qty AND total_revenue>=median_revenue THEN 'Misteri'
        ELSE 'Lemah'
    END AS klasifikasi,
    CASE
        WHEN total_qty>=median_qty AND total_revenue>=median_revenue THEN 'Jaga stok & kualitas'
        WHEN total_qty>=median_qty AND total_revenue< median_revenue THEN 'Uji bundling / harga'
        WHEN total_qty< median_qty AND total_revenue>=median_revenue THEN 'Dorong visibilitas'
        ELSE 'Validasi tren dulu'
    END AS aksi_disarankan
FROM scored
ORDER BY period, branch_name, total_revenue DESC
```

```sql menu_branch_movers
WITH max_d AS (SELECT MAX(order_date) AS d FROM restaurant.menu_performance),
periods AS (
    SELECT '7d' AS period, d - INTERVAL '6 days' AS start_date, d AS end_date, d - INTERVAL '13 days' AS prev_start, d - INTERVAL '7 days' AS prev_end FROM max_d
    UNION ALL
    SELECT '30d' AS period, d - INTERVAL '29 days' AS start_date, d AS end_date, d - INTERVAL '59 days' AS prev_start, d - INTERVAL '30 days' AS prev_end FROM max_d
),
source_rows AS (
    SELECT order_date, branch_name, menu_name,
        CASE category WHEN 'main' THEN 'Menu Utama' WHEN 'drink' THEN 'Minuman'
            WHEN 'snack' THEN 'Camilan' WHEN 'dessert' THEN 'Dessert'
            WHEN 'side' THEN 'Pendamping' ELSE category END AS category,
        total_qty_sold,
        total_revenue
    FROM restaurant.menu_performance
    UNION ALL
    SELECT order_date, 'Semua Cabang' AS branch_name, menu_name,
        CASE category WHEN 'main' THEN 'Menu Utama' WHEN 'drink' THEN 'Minuman'
            WHEN 'snack' THEN 'Camilan' WHEN 'dessert' THEN 'Dessert'
            WHEN 'side' THEN 'Pendamping' ELSE category END AS category,
        total_qty_sold,
        total_revenue
    FROM restaurant.menu_performance
),
curr AS (
    SELECT p.period, s.branch_name, s.menu_name, MAX(s.category) AS category,
        SUM(s.total_qty_sold) AS qty_current,
        SUM(s.total_revenue) AS revenue_current
    FROM source_rows s
    JOIN periods p ON s.order_date BETWEEN p.start_date AND p.end_date
    GROUP BY p.period, s.branch_name, s.menu_name
),
prev AS (
    SELECT p.period, s.branch_name, s.menu_name, MAX(s.category) AS category,
        SUM(s.total_qty_sold) AS qty_previous,
        SUM(s.total_revenue) AS revenue_previous
    FROM source_rows s
    JOIN periods p ON s.order_date BETWEEN p.prev_start AND p.prev_end
    GROUP BY p.period, s.branch_name, s.menu_name
)
SELECT
    COALESCE(c.period, p.period) AS period,
    COALESCE(c.branch_name, p.branch_name) AS branch_name,
    COALESCE(c.menu_name, p.menu_name) AS menu_name,
    COALESCE(c.category, p.category) AS category,
    COALESCE(c.qty_current, 0) AS qty_current,
    COALESCE(p.qty_previous, 0) AS qty_previous,
    ROUND((COALESCE(c.qty_current, 0) - COALESCE(p.qty_previous, 0)) * 100.0 / NULLIF(p.qty_previous, 0), 1) AS pct_change_qty,
    COALESCE(c.revenue_current, 0) AS revenue_current,
    COALESCE(p.revenue_previous, 0) AS revenue_previous,
    ROUND((COALESCE(c.revenue_current, 0) - COALESCE(p.revenue_previous, 0)) * 100.0 / NULLIF(p.revenue_previous, 0), 1) AS pct_change_revenue,
    CASE
        WHEN COALESCE(p.qty_previous, 0)=0 AND COALESCE(c.qty_current, 0)>0 THEN 'Baru'
        WHEN COALESCE(c.qty_current, 0)=0 AND COALESCE(p.qty_previous, 0)>0 THEN 'Tidak Aktif'
        WHEN ROUND((COALESCE(c.qty_current, 0) - COALESCE(p.qty_previous, 0)) * 100.0 / NULLIF(p.qty_previous, 0), 1)<=-20 THEN 'Turun'
        WHEN ROUND((COALESCE(c.qty_current, 0) - COALESCE(p.qty_previous, 0)) * 100.0 / NULLIF(p.qty_previous, 0), 1)>=20 THEN 'Naik'
        ELSE 'Stabil'
    END AS movement_status
FROM curr c
FULL OUTER JOIN prev p
    ON c.period=p.period
   AND c.branch_name=p.branch_name
   AND c.menu_name=p.menu_name
ORDER BY period, branch_name, pct_change_qty ASC NULLS FIRST
```

```sql structural_decline_90d_branch
WITH max_d AS (SELECT MAX(order_date) AS d FROM restaurant.menu_performance),
calendar AS (
    SELECT gs AS order_date
    FROM max_d, generate_series(d - INTERVAL '89 days', d, INTERVAL '1 day') AS t(gs)
),
source_rows AS (
    SELECT order_date, branch_name, menu_name,
        CASE category WHEN 'main' THEN 'Menu Utama' WHEN 'drink' THEN 'Minuman'
            WHEN 'snack' THEN 'Camilan' WHEN 'dessert' THEN 'Dessert'
            WHEN 'side' THEN 'Pendamping' ELSE category END AS category,
        total_qty_sold,
        total_revenue
    FROM restaurant.menu_performance CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '89 days'
    UNION ALL
    SELECT order_date, 'Semua Cabang' AS branch_name, menu_name,
        CASE category WHEN 'main' THEN 'Menu Utama' WHEN 'drink' THEN 'Minuman'
            WHEN 'snack' THEN 'Camilan' WHEN 'dessert' THEN 'Dessert'
            WHEN 'side' THEN 'Pendamping' ELSE category END AS category,
        total_qty_sold,
        total_revenue
    FROM restaurant.menu_performance CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '89 days'
),
menu_dim AS (
    SELECT branch_name, menu_name, MAX(category) AS category
    FROM source_rows
    GROUP BY branch_name, menu_name
),
daily AS (
    SELECT
        c.order_date,
        m.branch_name,
        m.menu_name,
        m.category,
        COALESCE(SUM(s.total_qty_sold), 0) AS qty_daily,
        COALESCE(SUM(s.total_revenue), 0) AS revenue_daily
    FROM calendar c
    CROSS JOIN menu_dim m
    LEFT JOIN source_rows s
        ON s.order_date = c.order_date
       AND s.branch_name = m.branch_name
       AND s.menu_name = m.menu_name
    GROUP BY c.order_date, m.branch_name, m.menu_name, m.category
),
rolling AS (
    SELECT
        order_date,
        branch_name,
        menu_name,
        category,
        qty_daily,
        revenue_daily,
        DATE_DIFF('day', (SELECT d - INTERVAL '89 days' FROM max_d), order_date) AS day_index,
        AVG(qty_daily) OVER (
            PARTITION BY branch_name, menu_name
            ORDER BY order_date
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ) AS rolling_avg_qty,
        AVG(revenue_daily) OVER (
            PARTITION BY branch_name, menu_name
            ORDER BY order_date
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ) AS rolling_avg_revenue
    FROM daily
),
weekly AS (
    SELECT
        branch_name,
        menu_name,
        MAX(category) AS category,
        CAST(FLOOR((day_index - 6) / 7) + 1 AS INTEGER) AS week_no,
        SUM(qty_daily) AS weekly_qty,
        SUM(revenue_daily) AS weekly_revenue
    FROM rolling
    WHERE day_index BETWEEN 6 AND 89
    GROUP BY branch_name, menu_name, week_no
),
weekly_change AS (
    SELECT *,
        LAG(weekly_qty) OVER (PARTITION BY branch_name, menu_name ORDER BY week_no) AS prev_weekly_qty
    FROM weekly
),
summary AS (
    SELECT
        branch_name,
        menu_name,
        MAX(category) AS category,
        COUNT(*) AS weeks_observed,
        SUM(CASE WHEN prev_weekly_qty IS NOT NULL AND weekly_qty < prev_weekly_qty THEN 1 ELSE 0 END) AS declining_weeks_12,
        MAX(CASE WHEN week_no=1 THEN weekly_qty END) AS weekly_qty_awal,
        AVG(weekly_qty) FILTER (WHERE week_no BETWEEN 5 AND 8) AS weekly_qty_tengah,
        MAX(CASE WHEN week_no=12 THEN weekly_qty END) AS weekly_qty_akhir,
        MAX(CASE WHEN week_no=12 THEN weekly_revenue END) AS weekly_revenue_akhir,
        AVG(weekly_qty) FILTER (WHERE week_no BETWEEN 10 AND 12) AS recent_3w_avg
    FROM weekly_change
    GROUP BY branch_name, menu_name
),
peak AS (
    SELECT branch_name, menu_name, week_no AS peak_week_no, weekly_qty AS weekly_qty_peak
    FROM (
        SELECT
            branch_name,
            menu_name,
            week_no,
            weekly_qty,
            ROW_NUMBER() OVER (
                PARTITION BY branch_name, menu_name
                ORDER BY weekly_qty DESC, week_no DESC
            ) AS rn
        FROM weekly
    )
    WHERE rn = 1
),
scored AS (
    SELECT
        s.branch_name,
        s.menu_name,
        s.category,
        p.peak_week_no,
        s.weeks_observed,
        s.declining_weeks_12,
        s.weekly_qty_awal,
        s.weekly_qty_tengah,
        p.weekly_qty_peak,
        s.weekly_qty_akhir,
        s.weekly_revenue_akhir,
        s.recent_3w_avg,
        ROUND((s.weekly_qty_akhir - p.weekly_qty_peak) * 100.0 / NULLIF(p.weekly_qty_peak, 0), 1) AS pct_change_90d
    FROM summary s
    JOIN peak p ON s.branch_name=p.branch_name AND s.menu_name=p.menu_name
)
SELECT
    branch_name,
    menu_name,
    category,
    peak_week_no,
    weeks_observed,
    declining_weeks_12,
    ROUND(weekly_qty_awal, 1) AS weekly_qty_awal,
    ROUND(weekly_qty_tengah, 1) AS weekly_qty_tengah,
    ROUND(weekly_qty_peak, 1) AS weekly_qty_peak,
    ROUND(weekly_qty_akhir, 1) AS weekly_qty_akhir,
    ROUND(weekly_revenue_akhir, 0) AS weekly_revenue_akhir,
    ROUND(weekly_qty_awal, 1) AS rolling_qty_awal,
    ROUND(weekly_qty_tengah, 1) AS rolling_qty_tengah,
    ROUND(weekly_qty_peak, 1) AS rolling_qty_peak,
    ROUND(weekly_qty_akhir, 1) AS rolling_qty_akhir,
    ROUND(weekly_revenue_akhir, 0) AS rolling_revenue_akhir,
    pct_change_90d,
    CASE
        WHEN declining_weeks_12 >= 9 AND pct_change_90d <= -25 AND weekly_qty_akhir <= recent_3w_avg * 1.10 THEN 'Kritis'
        WHEN declining_weeks_12 >= 8 AND pct_change_90d <= -15 THEN 'Waspada'
        ELSE 'Pantau'
    END AS severity,
    CAST(declining_weeks_12 AS VARCHAR) || ' dari 12 minggu turun' AS trend_status,
    CASE
        WHEN declining_weeks_12 >= 9 AND pct_change_90d <= -25 AND weekly_qty_akhir <= recent_3w_avg * 1.10 THEN '>=75% minggu turun + akhir turun >=25% + belum pulih'
        WHEN declining_weeks_12 >= 8 AND pct_change_90d <= -15 THEN '>=67% minggu turun + akhir turun >=15%'
        ELSE '>=60% minggu turun + akhir turun >=10%'
    END AS decline_rule,
    CASE WHEN weekly_qty_akhir <= recent_3w_avg * 1.10 THEN '3 minggu terakhir belum pulih signifikan' ELSE 'Ada indikasi pemulihan akhir' END AS recent_status
FROM scored
WHERE weekly_qty_peak >= 5
  AND weeks_observed = 12
  AND (
      (declining_weeks_12 >= 9 AND pct_change_90d <= -25 AND weekly_qty_akhir <= recent_3w_avg * 1.10)
      OR (declining_weeks_12 >= 8 AND pct_change_90d <= -15)
      OR (declining_weeks_12 >= 7 AND pct_change_90d <= -10)
  )
ORDER BY branch_name, pct_change_90d ASC
```

```sql declining_trend_90d_branch
WITH candidates AS (
    SELECT branch_name, menu_name
    FROM (
        SELECT *,
            ROW_NUMBER() OVER (PARTITION BY branch_name ORDER BY pct_change_90d ASC) AS rn
        FROM ${structural_decline_90d_branch}
    )
    WHERE rn <= 6
),
max_d AS (SELECT MAX(order_date) AS d FROM restaurant.menu_performance),
calendar AS (
    SELECT gs AS order_date
    FROM max_d, generate_series(d - INTERVAL '89 days', d, INTERVAL '1 day') AS t(gs)
),
source_rows AS (
    SELECT order_date, branch_name, menu_name, total_qty_sold
    FROM restaurant.menu_performance CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '89 days'
    UNION ALL
    SELECT order_date, 'Semua Cabang' AS branch_name, menu_name, total_qty_sold
    FROM restaurant.menu_performance CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '89 days'
),
daily AS (
    SELECT
        c.order_date,
        cd.branch_name,
        cd.menu_name,
        COALESCE(SUM(s.total_qty_sold), 0) AS qty_daily
    FROM calendar c
    CROSS JOIN candidates cd
    LEFT JOIN source_rows s
        ON s.order_date = c.order_date
       AND s.branch_name = cd.branch_name
       AND s.menu_name = cd.menu_name
    GROUP BY c.order_date, cd.branch_name, cd.menu_name
)
SELECT order_date, branch_name, menu_name,
    ROUND(AVG(qty_daily) OVER (
        PARTITION BY branch_name, menu_name
        ORDER BY order_date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ), 2) AS rolling_avg_qty
FROM daily
ORDER BY branch_name, order_date, menu_name
```

```sql movers_7d
WITH max_d AS (SELECT MAX(order_date) AS d FROM restaurant.menu_performance),
curr AS (
    SELECT menu_name,
        CASE category WHEN 'main' THEN 'Menu Utama' WHEN 'drink' THEN 'Minuman' WHEN 'snack' THEN 'Camilan' WHEN 'dessert' THEN 'Dessert' WHEN 'side' THEN 'Pendamping' ELSE category END AS category,
        SUM(total_qty_sold) AS qty_current, SUM(total_revenue) AS revenue_current
    FROM restaurant.menu_performance CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '6 days' GROUP BY menu_name, category
),
prev AS (
    SELECT menu_name,
        CASE category WHEN 'main' THEN 'Menu Utama' WHEN 'drink' THEN 'Minuman' WHEN 'snack' THEN 'Camilan' WHEN 'dessert' THEN 'Dessert' WHEN 'side' THEN 'Pendamping' ELSE category END AS category,
        SUM(total_qty_sold) AS qty_previous, SUM(total_revenue) AS revenue_previous
    FROM restaurant.menu_performance CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '13 days' AND order_date < d - INTERVAL '6 days' GROUP BY menu_name, category
)
SELECT COALESCE(c.menu_name,p.menu_name) AS menu_name, COALESCE(c.category,p.category) AS category,
    COALESCE(c.qty_current,0) AS qty_current, COALESCE(p.qty_previous,0) AS qty_previous,
    ROUND((COALESCE(c.qty_current,0)-COALESCE(p.qty_previous,0))*100.0/NULLIF(p.qty_previous,0),1) AS pct_change_qty,
    COALESCE(c.revenue_current,0) AS revenue_current,
    ROUND((COALESCE(c.revenue_current,0)-COALESCE(p.revenue_previous,0))*100.0/NULLIF(p.revenue_previous,0),1) AS pct_change_revenue,
    CASE
        WHEN COALESCE(p.qty_previous,0)=0 AND COALESCE(c.qty_current,0)>0 THEN 'Baru'
        WHEN COALESCE(c.qty_current,0)=0 AND COALESCE(p.qty_previous,0)>0 THEN 'Tidak Aktif'
        WHEN ROUND((COALESCE(c.qty_current,0)-COALESCE(p.qty_previous,0))*100.0/NULLIF(p.qty_previous,0),1)<=-20 THEN 'Turun'
        WHEN ROUND((COALESCE(c.qty_current,0)-COALESCE(p.qty_previous,0))*100.0/NULLIF(p.qty_previous,0),1)>=20  THEN 'Naik'
        ELSE 'Stabil'
    END AS movement_status
FROM curr c FULL OUTER JOIN prev p ON c.menu_name=p.menu_name ORDER BY pct_change_qty ASC NULLS FIRST
```

```sql movers_30d
WITH max_d AS (SELECT MAX(order_date) AS d FROM restaurant.menu_performance),
curr AS (
    SELECT menu_name,
        CASE category WHEN 'main' THEN 'Menu Utama' WHEN 'drink' THEN 'Minuman' WHEN 'snack' THEN 'Camilan' WHEN 'dessert' THEN 'Dessert' WHEN 'side' THEN 'Pendamping' ELSE category END AS category,
        SUM(total_qty_sold) AS qty_current, SUM(total_revenue) AS revenue_current
    FROM restaurant.menu_performance CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '29 days' GROUP BY menu_name, category
),
prev AS (
    SELECT menu_name,
        CASE category WHEN 'main' THEN 'Menu Utama' WHEN 'drink' THEN 'Minuman' WHEN 'snack' THEN 'Camilan' WHEN 'dessert' THEN 'Dessert' WHEN 'side' THEN 'Pendamping' ELSE category END AS category,
        SUM(total_qty_sold) AS qty_previous, SUM(total_revenue) AS revenue_previous
    FROM restaurant.menu_performance CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '59 days' AND order_date < d - INTERVAL '29 days' GROUP BY menu_name, category
)
SELECT COALESCE(c.menu_name,p.menu_name) AS menu_name, COALESCE(c.category,p.category) AS category,
    COALESCE(c.qty_current,0) AS qty_current, COALESCE(p.qty_previous,0) AS qty_previous,
    ROUND((COALESCE(c.qty_current,0)-COALESCE(p.qty_previous,0))*100.0/NULLIF(p.qty_previous,0),1) AS pct_change_qty,
    COALESCE(c.revenue_current,0) AS revenue_current,
    ROUND((COALESCE(c.revenue_current,0)-COALESCE(p.revenue_previous,0))*100.0/NULLIF(p.revenue_previous,0),1) AS pct_change_revenue,
    CASE
        WHEN COALESCE(p.qty_previous,0)=0 AND COALESCE(c.qty_current,0)>0 THEN 'Baru'
        WHEN COALESCE(c.qty_current,0)=0 AND COALESCE(p.qty_previous,0)>0 THEN 'Tidak Aktif'
        WHEN ROUND((COALESCE(c.qty_current,0)-COALESCE(p.qty_previous,0))*100.0/NULLIF(p.qty_previous,0),1)<=-20 THEN 'Turun'
        WHEN ROUND((COALESCE(c.qty_current,0)-COALESCE(p.qty_previous,0))*100.0/NULLIF(p.qty_previous,0),1)>=20  THEN 'Naik'
        ELSE 'Stabil'
    END AS movement_status
FROM curr c FULL OUTER JOIN prev p ON c.menu_name=p.menu_name ORDER BY pct_change_qty ASC NULLS FIRST
```

```sql structural_decline_90d
WITH max_d AS (SELECT MAX(order_date) AS d FROM restaurant.menu_performance),
calendar AS (
    SELECT gs AS order_date
    FROM max_d, generate_series(d - INTERVAL '89 days', d, INTERVAL '1 day') AS t(gs)
),
menu_dim AS (
    SELECT
        menu_name,
        MAX(CASE category WHEN 'main' THEN 'Menu Utama' WHEN 'drink' THEN 'Minuman'
            WHEN 'snack' THEN 'Camilan' WHEN 'dessert' THEN 'Dessert'
            WHEN 'side' THEN 'Pendamping' ELSE category END) AS category
    FROM restaurant.menu_performance CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '89 days'
    GROUP BY menu_name
),
daily AS (
    SELECT
        c.order_date,
        m.menu_name,
        m.category,
        COALESCE(SUM(p.total_qty_sold), 0) AS qty_daily,
        COALESCE(SUM(p.total_revenue), 0) AS revenue_daily
    FROM calendar c
    CROSS JOIN menu_dim m
    LEFT JOIN restaurant.menu_performance p
        ON p.order_date = c.order_date
       AND p.menu_name = m.menu_name
    GROUP BY c.order_date, m.menu_name, m.category
),
rolling AS (
    SELECT
        order_date,
        menu_name,
        category,
        qty_daily,
        revenue_daily,
        DATE_DIFF('day', (SELECT d - INTERVAL '89 days' FROM max_d), order_date) AS day_index,
        AVG(qty_daily) OVER (
            PARTITION BY menu_name
            ORDER BY order_date
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ) AS rolling_avg_qty,
        AVG(revenue_daily) OVER (
            PARTITION BY menu_name
            ORDER BY order_date
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ) AS rolling_avg_revenue
    FROM daily
),
weekly AS (
    SELECT
        menu_name,
        MAX(category) AS category,
        CAST(FLOOR((day_index - 6) / 7) + 1 AS INTEGER) AS week_no,
        SUM(qty_daily) AS weekly_qty,
        SUM(revenue_daily) AS weekly_revenue
    FROM rolling
    WHERE day_index BETWEEN 6 AND 89
    GROUP BY menu_name, week_no
),
weekly_change AS (
    SELECT *,
        LAG(weekly_qty) OVER (PARTITION BY menu_name ORDER BY week_no) AS prev_weekly_qty
    FROM weekly
),
summary AS (
    SELECT
        menu_name,
        MAX(category) AS category,
        COUNT(*) AS weeks_observed,
        SUM(CASE WHEN prev_weekly_qty IS NOT NULL AND weekly_qty < prev_weekly_qty THEN 1 ELSE 0 END) AS declining_weeks_12,
        MAX(CASE WHEN week_no=1 THEN weekly_qty END) AS weekly_qty_awal,
        AVG(weekly_qty) FILTER (WHERE week_no BETWEEN 5 AND 8) AS weekly_qty_tengah,
        MAX(CASE WHEN week_no=12 THEN weekly_qty END) AS weekly_qty_akhir,
        MAX(CASE WHEN week_no=12 THEN weekly_revenue END) AS weekly_revenue_akhir,
        AVG(weekly_qty) FILTER (WHERE week_no BETWEEN 10 AND 12) AS recent_3w_avg
    FROM weekly_change
    GROUP BY menu_name
),
peak AS (
    SELECT menu_name, week_no AS peak_week_no, weekly_qty AS weekly_qty_peak
    FROM (
        SELECT
            menu_name,
            week_no,
            weekly_qty,
            ROW_NUMBER() OVER (
                PARTITION BY menu_name
                ORDER BY weekly_qty DESC, week_no DESC
            ) AS rn
        FROM weekly
    )
    WHERE rn = 1
),
scored AS (
    SELECT
        s.menu_name,
        s.category,
        p.peak_week_no,
        s.weeks_observed,
        s.declining_weeks_12,
        s.weekly_qty_awal,
        s.weekly_qty_tengah,
        p.weekly_qty_peak,
        s.weekly_qty_akhir,
        s.weekly_revenue_akhir,
        s.recent_3w_avg,
        ROUND((s.weekly_qty_akhir - p.weekly_qty_peak) * 100.0 / NULLIF(p.weekly_qty_peak, 0), 1) AS pct_change_90d
    FROM summary s
    JOIN peak p ON s.menu_name = p.menu_name
)
SELECT
    menu_name,
    category,
    peak_week_no,
    weeks_observed,
    declining_weeks_12,
    ROUND(weekly_qty_awal, 1) AS weekly_qty_awal,
    ROUND(weekly_qty_tengah, 1) AS weekly_qty_tengah,
    ROUND(weekly_qty_peak, 1) AS weekly_qty_peak,
    ROUND(weekly_qty_akhir, 1) AS weekly_qty_akhir,
    ROUND(weekly_revenue_akhir, 0) AS weekly_revenue_akhir,
    ROUND(weekly_qty_awal, 1) AS rolling_qty_awal,
    ROUND(weekly_qty_tengah, 1) AS rolling_qty_tengah,
    ROUND(weekly_qty_peak, 1) AS rolling_qty_peak,
    ROUND(weekly_qty_akhir, 1) AS rolling_qty_akhir,
    ROUND(weekly_revenue_akhir, 0) AS rolling_revenue_akhir,
    pct_change_90d,
    CASE
        WHEN declining_weeks_12 >= 9 AND pct_change_90d <= -25 AND weekly_qty_akhir <= recent_3w_avg * 1.10 THEN 'Kritis'
        WHEN declining_weeks_12 >= 8 AND pct_change_90d <= -15 THEN 'Waspada'
        ELSE 'Pantau'
    END AS severity,
    CAST(declining_weeks_12 AS VARCHAR) || ' dari 12 minggu turun' AS trend_status,
    CASE
        WHEN declining_weeks_12 >= 9 AND pct_change_90d <= -25 AND weekly_qty_akhir <= recent_3w_avg * 1.10 THEN '>=75% minggu turun + akhir turun >=25% + belum pulih'
        WHEN declining_weeks_12 >= 8 AND pct_change_90d <= -15 THEN '>=67% minggu turun + akhir turun >=15%'
        ELSE '>=60% minggu turun + akhir turun >=10%'
    END AS decline_rule,
    CASE WHEN weekly_qty_akhir <= recent_3w_avg * 1.10 THEN '3 minggu terakhir belum pulih signifikan' ELSE 'Ada indikasi pemulihan akhir' END AS recent_status
FROM scored
WHERE weekly_qty_peak >= 5
  AND weeks_observed = 12
  AND (
      (declining_weeks_12 >= 9 AND pct_change_90d <= -25 AND weekly_qty_akhir <= recent_3w_avg * 1.10)
      OR (declining_weeks_12 >= 8 AND pct_change_90d <= -15)
      OR (declining_weeks_12 >= 7 AND pct_change_90d <= -10)
  )
ORDER BY pct_change_90d ASC
```

```sql declining_trend_90d
WITH max_d AS (SELECT MAX(order_date) AS d FROM restaurant.menu_performance),
calendar AS (
    SELECT gs AS order_date
    FROM max_d, generate_series(d - INTERVAL '89 days', d, INTERVAL '1 day') AS t(gs)
),
menu_dim AS (
    SELECT menu_name
    FROM ${structural_decline_90d}
    ORDER BY pct_change_90d ASC
    LIMIT 6
),
daily AS (
    SELECT
        c.order_date,
        m.menu_name,
        COALESCE(SUM(p.total_qty_sold), 0) AS qty_daily
    FROM calendar c
    CROSS JOIN menu_dim m
    LEFT JOIN restaurant.menu_performance p
        ON p.order_date = c.order_date
       AND p.menu_name = m.menu_name
    GROUP BY c.order_date, m.menu_name
)
SELECT order_date, menu_name,
    ROUND(AVG(qty_daily) OVER (
        PARTITION BY menu_name
        ORDER BY order_date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ), 2) AS rolling_avg_qty
FROM daily
ORDER BY order_date, menu_name
```

```sql declining_by_branch
SELECT branch_name, menu_name,
    SUM(CASE WHEN order_date < (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '59 days'  THEN total_qty_sold ELSE 0 END) AS qty_30_awal,
    SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '29 days' THEN total_qty_sold ELSE 0 END) AS qty_30_akhir,
    ROUND(
        (SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '29 days' THEN total_qty_sold ELSE 0 END)
        - SUM(CASE WHEN order_date < (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '59 days'  THEN total_qty_sold ELSE 0 END))
        / NULLIF(SUM(CASE WHEN order_date < (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '59 days' THEN total_qty_sold ELSE 0 END),0) * 100
    ,1) AS pct_change
FROM restaurant.menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '89 days'
GROUP BY branch_name, menu_name HAVING pct_change < 0 ORDER BY pct_change ASC
```

```sql menu_action_queue
WITH max_d AS (SELECT MAX(order_date) AS d FROM restaurant.menu_performance),
curr_7 AS (
    SELECT menu_name,
        CASE category WHEN 'main' THEN 'Menu Utama' WHEN 'drink' THEN 'Minuman'
            WHEN 'snack' THEN 'Camilan' WHEN 'dessert' THEN 'Dessert' WHEN 'side' THEN 'Pendamping' ELSE category END AS category,
        SUM(total_qty_sold) AS qty_curr,
        SUM(total_revenue)  AS rev_curr
    FROM restaurant.menu_performance CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '6 days'
    GROUP BY menu_name, category
),
prev_7 AS (
    SELECT menu_name, SUM(total_qty_sold) AS qty_prev
    FROM restaurant.menu_performance CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '13 days' AND order_date < d - INTERVAL '6 days'
    GROUP BY menu_name
),
curr_30 AS (
    SELECT menu_name,
        CASE category WHEN 'main' THEN 'Menu Utama' WHEN 'drink' THEN 'Minuman'
            WHEN 'snack' THEN 'Camilan' WHEN 'dessert' THEN 'Dessert' WHEN 'side' THEN 'Pendamping' ELSE category END AS category,
        SUM(total_qty_sold) AS qty_curr,
        SUM(total_revenue)  AS rev_curr
    FROM restaurant.menu_performance CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '29 days'
    GROUP BY menu_name, category
),
prev_30 AS (
    SELECT menu_name, SUM(total_qty_sold) AS qty_prev
    FROM restaurant.menu_performance CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '59 days' AND order_date < d - INTERVAL '29 days'
    GROUP BY menu_name
),
meds AS (SELECT MEDIAN(qty_curr) AS mq, MEDIAN(rev_curr) AS mr FROM curr_30),
top5_rev AS (
    SELECT ROUND(SUM(CASE WHEN rnk<=5 THEN rev_curr ELSE 0 END)*100.0/NULLIF(SUM(rev_curr),0),1) AS share
    FROM (SELECT rev_curr, ROW_NUMBER() OVER (ORDER BY rev_curr DESC) AS rnk FROM curr_30)
),
quick_decline AS (
    SELECT c.menu_name, c.category,
        ROUND((c.qty_curr - COALESCE(p.qty_prev,0))*100.0/NULLIF(p.qty_prev,0),1) AS pct_chg,
        ROW_NUMBER() OVER (
            ORDER BY ROUND((c.qty_curr - COALESCE(p.qty_prev,0))*100.0/NULLIF(p.qty_prev,0),1) ASC
        ) AS rn
    FROM curr_7 c
    LEFT JOIN prev_7 p ON c.menu_name=p.menu_name
    WHERE COALESCE(p.qty_prev,0)>0
      AND ROUND((c.qty_curr - COALESCE(p.qty_prev,0))*100.0/NULLIF(p.qty_prev,0),1) <= -20
),
classified AS (
    SELECT c.menu_name, c.category, c.qty_curr, c.rev_curr,
        COALESCE(p.qty_prev,0) AS qty_prev,
        ROUND((c.qty_curr - COALESCE(p.qty_prev,0))*100.0/NULLIF(p.qty_prev,0),1) AS pct_chg,
        CASE
            WHEN c.qty_curr>=m.mq AND c.rev_curr>=m.mr THEN 'Primadona'
            WHEN c.qty_curr>=m.mq AND c.rev_curr< m.mr THEN 'Pekerja Keras'
            WHEN c.qty_curr< m.mq AND c.rev_curr>=m.mr THEN 'Misteri'
            ELSE 'Lemah'
        END AS klasifikasi
    FROM curr_30 c
    LEFT JOIN prev_30 p ON c.menu_name=p.menu_name
    CROSS JOIN meds m
),
declining AS (
    SELECT menu_name, category, pct_chg,
        CASE WHEN pct_chg<=-40 THEN 'Kritis' ELSE 'Tinggi' END AS sev,
        ROW_NUMBER() OVER (ORDER BY pct_chg ASC) AS rn
    FROM classified WHERE pct_chg<=-20 AND qty_prev>0
),
misteri AS (
    SELECT menu_name, category, rev_curr,
        ROW_NUMBER() OVER (ORDER BY rev_curr DESC) AS rn
    FROM classified WHERE klasifikasi='Misteri'
),
pekerja AS (
    SELECT menu_name, category, qty_curr,
        ROW_NUMBER() OVER (ORDER BY qty_curr DESC) AS rn
    FROM classified WHERE klasifikasi='Pekerja Keras'
),
concentration AS (
    SELECT share FROM top5_rev WHERE share>=55
),
structural AS (
    SELECT menu_name, category, pct_change_90d, severity, declining_weeks_12,
        ROW_NUMBER() OVER (ORDER BY pct_change_90d ASC) AS rn
    FROM ${structural_decline_90d}
)
SELECT
    priority,
    action_group,
    severity,
    action_type,
    menu_name,
    category,
    metric_value,
    impact_text,
    recommended_action,
    evidence_window,
    first_step,
    guardrail
FROM (
    SELECT 10 + q.rn AS priority, 'Aksi Cepat' AS action_group,
        CASE WHEN q.pct_chg<=-35 THEN 'Tinggi' ELSE 'Sedang' END AS severity,
        'Drop Mingguan' AS action_type,
        q.menu_name, q.category,
        CAST(q.pct_chg AS VARCHAR) || '% qty vs 7H sebelumnya' AS metric_value,
        'Sinyal cepat: kemungkinan stok, kualitas, promo, atau eksekusi cabang berubah minggu ini' AS impact_text,
        'Cek stok, jam jual, kualitas plating/rasa, dan cabang yang paling turun sebelum membuat promo.' AS recommended_action,
        '7H vs 7H sebelumnya' AS evidence_window,
        'Audit cabang dan ketersediaan menu hari ini.' AS first_step,
        'Jangan reformulasi atau retire dari sinyal 7H saja.' AS guardrail
    FROM quick_decline q WHERE q.rn<=2
    UNION ALL
    SELECT 20 + s.rn, 'Evaluasi Serius',
        s.severity,
        'Tren 90H' AS action_type,
        s.menu_name, s.category,
        CAST(s.pct_change_90d AS VARCHAR) || '% dari peak mingguan 90H · ' || CAST(s.declining_weeks_12 AS VARCHAR) || '/12 minggu turun' AS metric_value,
        'Penurunan berulang dalam mayoritas minggu 90H, bukan sekadar drop sesaat' AS impact_text,
        'Bandingkan per cabang, margin, stok bahan, dan histori promo sebelum reformulasi, reprice, atau retire.' AS recommended_action,
        'Persistensi mingguan 90H' AS evidence_window,
        'Buka Pergerakan 90H dan Penurunan per Cabang untuk menu ini.' AS first_step,
        'Jangan promosi besar sebelum tahu penyebab turun: demand, harga, kualitas, atau stok.' AS guardrail
    FROM structural s WHERE s.rn<=2
    UNION ALL
    SELECT 30, 'Aksi Portofolio',
        CASE WHEN c.share>=70 THEN 'Tinggi' ELSE 'Sedang' END,
        'Konsentrasi Revenue', 'Portofolio', 'Semua Kategori',
        CAST(c.share AS VARCHAR) || '% revenue dari 5 menu teratas' AS metric_value,
        'Ketergantungan tinggi: gangguan menu andalan langsung memukul total revenue' AS impact_text,
        'Dorong menu tingkat dua lewat bundling, rekomendasi staf, atau pairing dengan menu andalan.' AS recommended_action,
        '30H portofolio' AS evidence_window,
        'Pilih 1-2 menu Misteri atau Pekerja Keras untuk eksperimen minggu ini.' AS first_step,
        'Jangan mengurangi stok menu andalan sebelum demand menu tingkat dua terbukti naik.' AS guardrail
    FROM concentration c
    UNION ALL
    SELECT 40 + d.rn, 'Aksi Portofolio', d.sev, 'Menu Turun 30H' AS action_type,
        d.menu_name, d.category,
        CAST(d.pct_chg AS VARCHAR) || '% qty vs 30H sebelumnya' AS metric_value,
        'Penurunan bulanan cukup kuat untuk masuk audit portofolio' AS impact_text,
        'Cek distribusi antar cabang dulu. Jika turun di satu cabang: audit stok dan kualitas lokal. Jika menyebar: pertimbangkan promo, bundling, atau repositioning.' AS recommended_action,
        '30H vs 30H sebelumnya' AS evidence_window,
        'Cek apakah drop menyebar ke banyak cabang.' AS first_step,
        'Jika menu juga masuk Evaluasi Serius 90H, prioritaskan diagnosis akar masalah dulu.' AS guardrail
    FROM declining d WHERE d.rn<=2
    UNION ALL
    SELECT 50 + m.rn, 'Aksi Portofolio', 'Sedang', 'Misteri', m.menu_name, m.category,
        'Revenue tinggi, volume rendah' AS metric_value,
        'Potensi revenue belum tergali karena kurang dikenal pelanggan' AS impact_text,
        'Rekomendasikan aktif saat pelanggan memesan menu andalan. Pertimbangkan posisi lebih menonjol di daftar menu.' AS recommended_action,
        '30H klasifikasi menu' AS evidence_window,
        'Uji rekomendasi staf atau placement selama 7 hari.' AS first_step,
        'Jika menu ini juga turun 90H, jangan langsung dipush tanpa cek kualitas dan harga.' AS guardrail
    FROM misteri m WHERE m.rn<=2
    UNION ALL
    SELECT 60 + p.rn, 'Aksi Portofolio', 'Sedang', 'Pekerja Keras', p.menu_name, p.category,
        'Volume tinggi, revenue rendah' AS metric_value,
        'Menu laris tapi belum dimonetisasi optimal' AS impact_text,
        'Uji bundling dengan item premium atau kenaikan harga kecil. Pantau apakah volume tetap stabil setelah perubahan.' AS recommended_action,
        '30H klasifikasi menu' AS evidence_window,
        'Buat satu bundle/add-on kecil dan ukur attach rate.' AS first_step,
        'Jangan naikkan harga tajam tanpa melihat sensitivitas volume.' AS guardrail
    FROM pekerja p WHERE p.rn=1
) ORDER BY priority ASC, severity DESC
LIMIT 8
```

<ButtonGroup name=view>
  <ButtonGroupItem valueLabel="🏠 Ringkasan" value="overview" default />
  <ButtonGroupItem valueLabel="🏪 Detail Cabang" value="detail" />
  <ButtonGroupItem valueLabel="🗺️ Peta Menu" value="portfolio" />
  <ButtonGroupItem valueLabel="📉 Pergerakan" value="movement" />
  <ButtonGroupItem valueLabel="🎯 Pusat Aksi" value="action" />
</ButtonGroup>

{#if menu_health_overview.length > 0 && menu_dates.length > 0}

{@const overviewPeriod = inputs.overview_period ?? '30d'}
{@const detailPeriod = inputs.detail_period ?? 'y'}
{@const portfolioPeriod = inputs.portfolio_period ?? '30d'}
{@const movementPeriod = inputs.movement_period ?? '7d'}
{@const activePeriod = inputs.view === 'detail' ? detailPeriod : inputs.view === 'portfolio' ? portfolioPeriod : inputs.view === 'movement' ? movementPeriod : inputs.view === 'action' ? '30d' : overviewPeriod}
{@const activeStatus    = activePeriod === 'y' ? menu_health_overview[0].status_y     : activePeriod === '30d' ? menu_health_overview[0].status_30d     : menu_health_overview[0].status_7d}
{@const activeFocus     = activePeriod === 'y' ? menu_health_overview[0].focus_y      : activePeriod === '30d' ? menu_health_overview[0].focus_30d      : menu_health_overview[0].focus_7d}
{@const activeMenuCount = activePeriod === 'y' ? menu_health_overview[0].active_y     : activePeriod === '30d' ? menu_health_overview[0].active_30d     : menu_health_overview[0].active_7d}
{@const activeTop5Share = activePeriod === 'y' ? menu_health_overview[0].top5_share_y : activePeriod === '30d' ? menu_health_overview[0].top5_share_30d : menu_health_overview[0].top5_share_7d}
{@const activeDeclining = activePeriod === 'y' ? menu_health_overview[0].declining_y  : activePeriod === '30d' ? menu_health_overview[0].declining_30d  : menu_health_overview[0].declining_7d}
{@const activeRising    = activePeriod === 'y' ? menu_health_overview[0].rising_y     : activePeriod === '30d' ? menu_health_overview[0].rising_30d     : menu_health_overview[0].rising_7d}
{@const activeWeak      = activePeriod === 'y' ? menu_health_overview[0].weak_y       : activePeriod === '30d' ? menu_health_overview[0].weak_30d       : menu_health_overview[0].weak_7d}
{@const activeTopVolume = activePeriod === 'y' ? menu_health_overview[0].top_volume_menu_y  : activePeriod === '30d' ? menu_health_overview[0].top_volume_menu_30d  : menu_health_overview[0].top_volume_menu_7d}
{@const activeTopRevenue= activePeriod === 'y' ? menu_health_overview[0].top_revenue_menu_y : activePeriod === '30d' ? menu_health_overview[0].top_revenue_menu_30d : menu_health_overview[0].top_revenue_menu_7d}
{@const activeKpi       = activePeriod === 'y' ? menu_kpi_y        : activePeriod === '30d' ? menu_kpi_30d        : menu_kpi_7d}
{@const activeEngineering = activePeriod === 'y' ? menu_engineering_y : activePeriod === '30d' ? menu_engineering_30d : menu_engineering_7d}
{@const activeMovers    = activePeriod === '30d' ? movers_30d : movers_7d}
{@const moverDown       = activeMovers.filter((m) => m.movement_status === 'Turun')}
{@const moverUp         = activeMovers.filter((m) => m.movement_status === 'Naik')}
{@const moverNew        = activeMovers.filter((m) => m.movement_status === 'Baru')}
{@const moverInactive   = activeMovers.filter((m) => m.movement_status === 'Tidak Aktif')}
{@const primadonaMenus  = activeEngineering.filter((m) => m.klasifikasi === 'Primadona')}
{@const mysteryMenus    = activeEngineering.filter((m) => m.klasifikasi === 'Misteri')}
{@const workhorseMenus  = activeEngineering.filter((m) => m.klasifikasi === 'Pekerja Keras')}
{@const weakMenus       = activeEngineering.filter((m) => m.klasifikasi === 'Lemah')}
{@const pushMenu        = mysteryMenus[0] ?? workhorseMenus[0]}
{@const decliningMenu   = activeMovers.find((m) => m.movement_status === 'Turun')}
{@const weakMenu        = weakMenus[0]}
{@const structuralMenu  = structural_decline_90d.find((m) => m.menu_name != null)}
{@const periodLensTitle = activePeriod === 'y' ? 'Cek Operasional Harian' : activePeriod === '30d' ? 'Keputusan Awal Portofolio' : 'Sinyal Mingguan'}
{@const menuConcentrationState = activeTop5Share >= 70 ? 'critical' : activeTop5Share >= 55 ? 'warn' : 'safe'}
{@const menuDeclineState = activeDeclining >= 5 ? 'critical' : activeDeclining >= 2 ? 'warn' : 'safe'}
{@const menuWeakRatio = activeMenuCount > 0 ? Math.round(activeWeak * 1000 / activeMenuCount) / 10 : 0}
{@const menuWeakState = menuWeakRatio >= 40 ? 'critical' : menuWeakRatio >= 25 ? 'warn' : 'safe'}
{@const menuPrimaryStates = [menuConcentrationState, menuDeclineState]}
{@const menuPrimarySafeCount = menuPrimaryStates.filter(s => s === 'safe').length}
{@const menuPrimaryWarnCount = menuPrimaryStates.filter(s => s === 'warn').length}
{@const menuPrimaryCriticalCount = menuPrimaryStates.filter(s => s === 'critical').length}

<div class="menu-page">

{#if inputs.view === 'overview'}

<div class="subpage-period-control">
  <div class="subpage-period-label">Periode Ringkasan</div>
  <ButtonGroup name=overview_period>
    <ButtonGroupItem valueLabel="Kemarin" value="y" />
    <ButtonGroupItem valueLabel="7 Hari" value="7d" />
    <ButtonGroupItem valueLabel="30 Hari" value="30d" default />
  </ButtonGroup>
  <div class="subpage-period-copy">Ringkasan default memakai 30H untuk keputusan portofolio awal. Kemarin tersedia untuk cek operasional harian, bukan keputusan permanen.</div>
</div>

<!-- ════ PERIOD STRIP ════ -->
<div class="period-strip">
  <div class="period-pill {menu_health_overview[0].status_y === 'Sehat' ? 'sehat' : menu_health_overview[0].status_y === 'Waspada' ? 'waspada' : 'kritis'}">
    <div class="period-pill-label">📅 Kemarin · {menu_dates[0].tgl_akhir}</div>
    <div class="period-pill-value">
      <span class="pill-badge {menu_health_overview[0].status_y === 'Sehat' ? 'sehat' : menu_health_overview[0].status_y === 'Waspada' ? 'waspada' : 'kritis'}">
        {menu_health_overview[0].status_y === 'Sehat' ? '✅' : menu_health_overview[0].status_y === 'Waspada' ? '⚠️' : '🚨'} {menu_health_overview[0].status_y}
      </span>
      Top 5: {menu_health_overview[0].top5_share_y}%
    </div>
    <div class="period-pill-copy">{menu_health_overview[0].declining_y} turun · {menu_health_overview[0].active_y} aktif</div>
  </div>
  <div class="period-pill {menu_health_overview[0].status_7d === 'Sehat' ? 'sehat' : menu_health_overview[0].status_7d === 'Waspada' ? 'waspada' : 'kritis'}">
    <div class="period-pill-label">📊 7 Hari · {menu_dates[0].tgl_7_awal}–{menu_dates[0].tgl_akhir}</div>
    <div class="period-pill-value">
      <span class="pill-badge {menu_health_overview[0].status_7d === 'Sehat' ? 'sehat' : menu_health_overview[0].status_7d === 'Waspada' ? 'waspada' : 'kritis'}">
        {menu_health_overview[0].status_7d === 'Sehat' ? '✅' : menu_health_overview[0].status_7d === 'Waspada' ? '⚠️' : '🚨'} {menu_health_overview[0].status_7d}
      </span>
      Top 5: {menu_health_overview[0].top5_share_7d}%
    </div>
    <div class="period-pill-copy">{menu_health_overview[0].declining_7d} turun · {menu_health_overview[0].active_7d} aktif</div>
  </div>
  <div class="period-pill {menu_health_overview[0].status_30d === 'Sehat' ? 'sehat' : menu_health_overview[0].status_30d === 'Waspada' ? 'waspada' : 'kritis'}">
    <div class="period-pill-label">🗓️ 30 Hari · {menu_dates[0].tgl_30_awal}–{menu_dates[0].tgl_akhir}</div>
    <div class="period-pill-value">
      <span class="pill-badge {menu_health_overview[0].status_30d === 'Sehat' ? 'sehat' : menu_health_overview[0].status_30d === 'Waspada' ? 'waspada' : 'kritis'}">
        {menu_health_overview[0].status_30d === 'Sehat' ? '✅' : menu_health_overview[0].status_30d === 'Waspada' ? '⚠️' : '🚨'} {menu_health_overview[0].status_30d}
      </span>
      Top 5: {menu_health_overview[0].top5_share_30d}%
    </div>
    <div class="period-pill-copy">{menu_health_overview[0].declining_30d} turun · {menu_health_overview[0].active_30d} aktif</div>
  </div>
</div>

<div class="period-guide">
  <div class="period-guide-label">Cara membaca periode aktif</div>
  <div class="period-guide-title">{periodLensTitle}</div>
  <div class="period-guide-copy">
    {#if activePeriod === 'y'}
      Kemarin dipakai untuk mengecek anomali operasional: stok, kualitas, menu tiba-tiba drop, atau menu andalan yang perlu disiapkan hari ini. Jangan pakai data satu hari untuk hapus menu atau ubah harga.
    {:else if activePeriod === '30d'}
      30 hari cukup untuk membaca arah portofolio dan kandidat evaluasi awal. Keputusan serius seperti reformulasi besar, retire menu, atau redesign kategori sebaiknya menunggu validasi tren 90 hari.
    {:else}
      7 hari dipakai untuk membaca perubahan cepat: menu yang mulai naik/turun, kandidat promo ringan, dan audit cabang. Ini bagus untuk eksperimen mingguan, belum cukup untuk keputusan permanen.
    {/if}
  </div>
</div>

<!-- ════ STATUS UTAMA ════ -->
<div class="menu-status {activeStatus === 'Sehat' ? 'safe' : activeStatus === 'Waspada' ? 'warn' : 'critical'}">
  <div>
    <div class="menu-status-label">Status Utama · {activePeriod === 'y' ? 'Evaluasi Kemarin' : activePeriod === '30d' ? 'Pola 30 Hari' : 'Pola 7 Hari'}</div>
    <h2 class="menu-status-title">
      {#if activeStatus === 'Sehat'}Portofolio menu masih terkendali. ✅
      {:else if activeStatus === 'Waspada'}Menu masih berjalan, tapi ada sinyal yang perlu dicek. ⚠️
      {:else}Portofolio menu perlu perhatian serius. 🚨{/if}
    </h2>
    <div class="menu-status-copy">
      {#if activePeriod === 'y'}Kemarin dipakai untuk cek operasional menu. Ada {activeMenuCount} menu aktif, Top 5 menyumbang {activeTop5Share}% revenue, {activeDeclining} menu turun, dan {activeWeak} menu lemah.
      {:else if activePeriod === '7d'}Dalam 7 hari terakhir, ada {activeMenuCount} menu aktif, Top 5 menyumbang {activeTop5Share}% revenue, {activeDeclining} menu turun, dan {activeWeak} menu lemah. Baca ini sebagai sinyal mingguan, bukan keputusan permanen.
      {:else}Dalam 30 hari terakhir, ada {activeMenuCount} menu aktif, Top 5 menyumbang {activeTop5Share}% revenue, {activeDeclining} menu turun, dan {activeWeak} menu lemah. Ini window utama untuk keputusan portofolio awal.{/if}
    </div>
    <div class="menu-status-action">
      <strong>Mulai dari sini:</strong>
      {#if activeFocus === 'Konsentrasi revenue'}cek apakah bisnis terlalu bergantung pada sedikit menu. Jaga stok menu andalan, lalu dorong menu tingkat dua.
      {:else if activeFocus === 'Menu menurun'}buka <strong>Pergerakan</strong> untuk melihat menu yang turun dan apakah penurunannya menyebar antar cabang.
      {:else if activeFocus === 'Menu lemah'}buka <strong>Peta Menu</strong> dan <strong>Pusat Aksi</strong> untuk memilah menu yang perlu didorong, diuji ulang, atau dievaluasi.
      {:else}jaga stok dan kualitas menu andalan, lalu cari kandidat menu yang bisa didorong naik kelas.{/if}
    </div>
  </div>
  <div class="menu-status-metrics">
    <div class="menu-status-metric">
      <div class="menu-status-metric-label">📅 Periode Aktif</div>
      <div class="menu-status-metric-value">{activePeriod === 'y' ? menu_dates[0].tgl_akhir : activePeriod === '30d' ? menu_dates[0].tgl_30_awal + ' - ' + menu_dates[0].tgl_akhir : menu_dates[0].tgl_7_awal + ' - ' + menu_dates[0].tgl_akhir}</div>
      <div class="menu-status-metric-note">{activePeriod === 'y' ? 'Cocok untuk cek operasional harian, bukan keputusan menu permanen.' : activePeriod === '30d' ? 'Cukup panjang untuk membaca portofolio, cukup dekat untuk ditindaklanjuti.' : 'Cocok untuk eksperimen mingguan dan audit perubahan cepat.'}</div>
    </div>
    <div class="menu-status-metric">
      <div class="menu-status-metric-label">🍽️ Menu Andalan</div>
      <div class="menu-status-metric-value">{activeTopVolume ?? 'Belum ada data'}</div>
      <div class="menu-status-metric-note">Revenue terbesar: {activeTopRevenue ?? 'belum ada data'}. Prioritasnya stok, prep, kualitas, dan upsell yang konsisten.</div>
    </div>
  </div>
</div>

<div class="menu-health">
  <div class="menu-health-head">
    <div class="menu-health-label">Ringkasan 2 Indikator Utama</div>
    <div class="menu-health-badges">
      <span class="menu-health-badge safe">✓ {menuPrimarySafeCount} sehat</span>
      <span class="menu-health-badge warn">! {menuPrimaryWarnCount} waspada</span>
      <span class="menu-health-badge critical">x {menuPrimaryCriticalCount} kritis</span>
    </div>
  </div>
  <div class="menu-health-list">
    <div class="menu-health-row {menuConcentrationState}">
      <div class="menu-health-icon">{menuConcentrationState === 'safe' ? '✅' : menuConcentrationState === 'warn' ? '⚠️' : '🚨'}</div>
      <div><span class="menu-health-title">Konsentrasi Revenue</span> <span class="menu-health-copy">- <span class="menu-health-value">Top 5 menyumbang {activeTop5Share}% revenue</span>. Sehat = &lt;55%, Waspada = 55-69%, Kritis = 70% ke atas.</span></div>
    </div>
    <div class="menu-health-row {menuDeclineState}">
      <div class="menu-health-icon">{menuDeclineState === 'safe' ? '✅' : menuDeclineState === 'warn' ? '⚠️' : '🚨'}</div>
      <div><span class="menu-health-title">Menu Menurun</span> <span class="menu-health-copy">- <span class="menu-health-value">{activeDeclining} menu turun</span>. Sehat = 0-1 menu, Waspada = 2-4 menu, Kritis = 5 menu atau lebih.</span></div>
    </div>
  </div>
</div>

<details class="acc-strategic">
  <summary>Kenapa konsentrasi dan menu turun jadi angka utama?</summary>
  <div class="acc-body">
    <div class="section-head">
      <div class="section-eyebrow">Makna Angka Utama</div>
      <h3 class="section-title">Dua hal paling dasar untuk owner</h3>
      <p class="section-copy">Kalau hanya punya waktu singkat, baca dulu apakah revenue terlalu bergantung pada sedikit menu dan apakah terlalu banyak menu yang mulai turun.</p>
    </div>
    <div class="menu-analysis-grid">
      <div class="menu-analysis-card {menuConcentrationState}">
        <div class="menu-analysis-label">Konsentrasi Revenue</div>
        <div class="menu-analysis-title">Top 5 = {activeTop5Share}% revenue</div>
        <div class="menu-analysis-copy">Angka ini menjawab apakah revenue restoran terlalu bergantung pada sedikit menu. Semakin tinggi, semakin besar risiko jika stok, kualitas, atau demand menu andalan terganggu.</div>
        <div class="menu-threshold-line"><strong>Batas:</strong> &lt;55% sehat · 55-69% waspada · ≥70% kritis</div>
      </div>
      <div class="menu-analysis-card {menuDeclineState}">
        <div class="menu-analysis-label">Menu Menurun</div>
        <div class="menu-analysis-title">{activeDeclining} menu turun</div>
        <div class="menu-analysis-copy">Menu turun berarti qty periode ini turun minimal 20% dibanding periode pembanding. Ini sinyal untuk cek stok, rasa, harga, cabang, atau momentum demand.</div>
        <div class="menu-threshold-line"><strong>Batas:</strong> 0-1 sehat · 2-4 waspada · ≥5 kritis</div>
      </div>
    </div>
  </div>
</details>

<div class="section-card">
  <div class="section-head">
    <div class="section-eyebrow">Konteks Lanjutan</div>
    <h3 class="section-title">Detail tambahan setelah angka utama</h3>
    <p class="section-copy">Gunakan bagian ini untuk memahami konteks sebelum masuk ke Peta Menu, Pergerakan, atau Pusat Aksi.</p>
  </div>
  <div class="menu-analysis-grid context">
    <div class="menu-analysis-card neutral">
      <div class="menu-analysis-label">Total Revenue</div>
      <div class="menu-analysis-title">Rp {(activeKpi[0]?.total_revenue ?? 0).toLocaleString('id-ID', {maximumFractionDigits:0})}</div>
      <div class="menu-analysis-copy">Rata-rata Rp {(activeKpi[0]?.avg_revenue_per_menu ?? 0).toLocaleString('id-ID', {maximumFractionDigits:0})} per menu aktif.</div>
    </div>
    <div class="menu-analysis-card {menuWeakState}">
      <div class="menu-analysis-label">Menu Lemah</div>
      <div class="menu-analysis-title">{activeWeak} menu · {menuWeakRatio}%</div>
      <div class="menu-analysis-copy">Menu dengan volume dan revenue di bawah median periode aktif. Ini watchlist, bukan alasan langsung hapus menu.</div>
    </div>
    <div class="menu-analysis-card safe">
      <div class="menu-analysis-label">Menu Naik</div>
      <div class="menu-analysis-title">{activeRising} menu naik</div>
      <div class="menu-analysis-copy">Menu naik minimal 20% dibanding periode pembanding. Cari penyebabnya untuk direplikasi.</div>
    </div>
    <div class="menu-analysis-card neutral">
      <div class="menu-analysis-label">Menu Prioritas</div>
      <div class="menu-analysis-title">{pushMenu?.menu_name ?? 'Belum ada kandidat'}</div>
      <div class="menu-analysis-copy">Kandidat dorong dari kategori Misteri atau Pekerja Keras. Detail aksi ada di Pusat Aksi.</div>
    </div>
  </div>
</div>

<!-- ════ PORTFOLIO SNAPSHOT ════ -->
<div class="section-card">
  <div class="section-head">
    <div class="section-eyebrow">🧭 Snapshot Portofolio <span class="timeframe-tag">{activePeriod === 'y' ? 'Kemarin' : activePeriod === '30d' ? '30 Hari' : '7 Hari'}</span></div>
    <h3 class="section-title">Komposisi menu saat ini: mana yang kuat, potensial, berat kerja, dan lemah</h3>
    <p class="section-copy">
      {#if activePeriod === 'y'}
        Ini snapshot harian, jadi baca sebagai kondisi operasional kemarin. Klasifikasi belum cukup untuk keputusan permanen.
      {:else if activePeriod === '30d'}
        Ini peta awal portofolio 30 hari. Gunakan untuk memilih kandidat evaluasi, lalu validasi serius dengan tren 90 hari.
      {:else}
        Ini sinyal mingguan untuk eksperimen ringan dan audit cepat. Gunakan 30H/90H sebelum keputusan besar.
      {/if}
    </p>
  </div>
  <div class="snapshot-grid">
    <div class="snapshot-card star">
      <div class="snapshot-label">⭐ Primadona</div>
      <div class="snapshot-value">{primadonaMenus.length} menu</div>
      <div class="snapshot-copy">Jaga stok, kualitas, dan konsistensi eksekusi.</div>
    </div>
    <div class="snapshot-card mystery">
      <div class="snapshot-label">🔮 Misteri</div>
      <div class="snapshot-value">{mysteryMenus.length} menu</div>
      <div class="snapshot-copy">Revenue bagus, volume belum tinggi. Kandidat dorong.</div>
    </div>
    <div class="snapshot-card workhorse">
      <div class="snapshot-label">💪 Pekerja Keras</div>
      <div class="snapshot-value">{workhorseMenus.length} menu</div>
      <div class="snapshot-copy">Laku, tapi nilai per order perlu dinaikkan.</div>
    </div>
    <div class="snapshot-card weak">
      <div class="snapshot-label">🔻 Lemah</div>
      <div class="snapshot-value">{weakMenus.length} menu</div>
      <div class="snapshot-copy">{activePeriod === 'y' ? 'Performa rendah kemarin, belum berarti menu buruk.' : 'Evaluasi setelah cek tren dan cabang.'}</div>
    </div>
  </div>
</div>

<div class="period-guide">
  <div class="period-guide-label">Batas keputusan evaluasi</div>
  <div class="period-guide-title">30H = sinyal awal, 90H = evaluasi serius</div>
  <div class="period-guide-copy">
    {#if activePeriod === 'y'}
      Data kemarin hanya dipakai untuk cek operasional. Untuk evaluasi menu, buka 30H sebagai watchlist dan cek validasi 90H di subpage Pergerakan.
    {:else if activePeriod === '7d'}
      7H bagus untuk membaca sinyal mingguan. Evaluasi serius baru kuat kalau sinyal berlanjut ke 30H dan tervalidasi di 90H pada subpage Pergerakan.
    {:else}
      30 hari cukup untuk menandai menu yang mulai melemah. Validasi seriusnya dibaca di subpage Pergerakan lewat tren 90H dan menu yang turun berturut-turut.
    {/if}
    {#if activePeriod === '30d' && structuralMenu}
      Kandidat 90H terkuat saat ini: <strong>{structuralMenu.menu_name}</strong> ({structuralMenu.pct_change_90d}% vs 30H awal).
    {:else if activePeriod === '30d'}
      Saat ini belum ada menu yang turun berturut-turut dalam tiga blok 30 hari.
    {/if}
  </div>
</div>

<!-- ════ PRIORITY MENU CARDS ════ -->
<div class="section-card">
  <div class="section-head">
    <div class="section-eyebrow">🎯 Menu Prioritas</div>
    <h3 class="section-title">Nama menu yang perlu diperhatikan owner sekarang</h3>
    <p class="section-copy">
      {#if activePeriod === 'y'}Fokusnya cek operasional hari ini: stok, kualitas, dan briefing staf.
      {:else if activePeriod === '30d'}Fokusnya memilih kandidat keputusan portofolio awal, lalu cek 90H sebelum tindakan besar.
      {:else}Fokusnya eksperimen mingguan: promo ringan, rekomendasi staf, atau audit cabang.{/if}
    </p>
  </div>
  <div class="priority-grid">
    <div class="priority-card">
      <div class="priority-label">Jaga</div>
      <div class="priority-title">{activeTopVolume ?? 'Belum ada menu'}</div>
      <div class="priority-copy">{activePeriod === 'y' ? 'Pastikan stok dan prep hari ini aman karena menu ini paling sering dipesan kemarin.' : 'Menu dengan volume terbesar. Prioritasnya stok aman dan kualitas konsisten.'}</div>
      <div class="priority-metric">{activePeriod === 'y' ? 'Cek operasional' : 'Menu andalan volume'}</div>
    </div>
    <div class="priority-card">
      <div class="priority-label">Dorong</div>
      <div class="priority-title">{pushMenu?.menu_name ?? 'Belum ada kandidat'}</div>
      <div class="priority-copy">
        {#if activePeriod === 'y'}Jika menu ini tersedia hari ini, jadikan rekomendasi staf ringan. Jangan pakai satu hari untuk ubah harga.
        {:else if pushMenu?.klasifikasi === 'Misteri'}Revenue kuat tapi volume belum tinggi. Cocok untuk rekomendasi staf atau placement lebih jelas.
        {:else if pushMenu?.klasifikasi === 'Pekerja Keras'}Volume kuat tapi revenue relatif rendah. Cocok untuk bundling atau uji kenaikan harga kecil.
        {:else}Belum ada kandidat dorong yang menonjol pada periode ini.{/if}
      </div>
      <div class="priority-metric">{pushMenu?.klasifikasi ?? 'Kandidat dorong'}</div>
    </div>
    <div class="priority-card">
      <div class="priority-label">{activePeriod === 'y' ? 'Cek Anomali' : 'Audit'}</div>
      <div class="priority-title">{decliningMenu?.menu_name ?? (activePeriod === 'y' ? 'Tidak ada drop besar' : 'Belum ada menu turun')}</div>
      <div class="priority-copy">
        {#if decliningMenu}
          {activePeriod === 'y' ? 'Cek apakah drop kemarin karena stok, cabang, atau jam operasional. Ini belum tren.' : 'Cek apakah penurunan terjadi di semua cabang atau hanya cabang tertentu sebelum promo/reformulasi.'}
        {:else if activePeriod === 'y'}
          Tidak ada menu yang masuk kategori turun tajam kemarin. Fokus cek menu andalan dan kesiapan stok hari ini.
        {:else}
          Tidak ada menu yang turun tajam pada periode ini. Lanjutkan pemantauan dan cek tren 30H/90H.
        {/if}
      </div>
      <div class="priority-metric">{decliningMenu?.movement_status ?? (activePeriod === 'y' ? 'Tidak ada anomali drop' : 'Tidak ada sinyal turun')}</div>
    </div>
    <div class="priority-card">
      <div class="priority-label">{activePeriod === 'y' ? 'Pantau' : activePeriod === '7d' ? 'Watchlist' : 'Evaluasi'}</div>
      <div class="priority-title">{activePeriod === '30d' ? structuralMenu?.menu_name ?? weakMenu?.menu_name ?? 'Belum ada kandidat serius' : weakMenu?.menu_name ?? 'Belum ada menu lemah'}</div>
      <div class="priority-copy">
        {#if activePeriod === 'y'}Performa rendah kemarin hanya bahan cek. Jangan masuk evaluasi serius dari satu hari.
        {:else if activePeriod === '7d'}Masukkan ke watchlist mingguan dulu. Jika tetap lemah di 30H, baru cek detail 90H.
        {:else if activePeriod === '30d' && structuralMenu}Menu ini punya sinyal 90H. Buka Pergerakan untuk validasi sebelum reformulasi/retire.
        {:else if activePeriod === '30d'}Pakai 30H sebagai watchlist. Validasi 90H ada di subpage Pergerakan sebelum keputusan final.
        {:else}Jangan langsung hapus. Validasi tren 30H/90H di Pergerakan, lalu cek biaya bahan dan performa per cabang.{/if}
      </div>
      <div class="priority-metric">{activePeriod === 'y' ? 'Pantauan harian' : activePeriod === '7d' ? 'Watchlist mingguan' : 'Validasi 90H'}</div>
    </div>
  </div>
</div>

{:else if inputs.view === 'detail'}

{@const selectedDetailBranchRaw = String(inputs.detail_branch ?? 'all')}
{@const selectedDetailBranchNormalized = decodeURIComponent(selectedDetailBranchRaw).replace(/\+/g, ' ')}
{@const selectedDetailBranch = selectedDetailBranchRaw === 'all' || selectedDetailBranchNormalized === 'Semua Cabang' ? 'Semua Cabang' : menu_branch_list.find((branch) => branch.branch_name === selectedDetailBranchRaw || branch.branch_name === selectedDetailBranchNormalized)?.branch_name ?? 'Semua Cabang'}
{@const activeDetailLabel = detailPeriod === 'y' ? 'Kemarin' : detailPeriod === '30d' ? '30 Hari' : '7 Hari'}
{@const activeDetailRows = menu_branch_detail.filter((row) => row.period === detailPeriod && (selectedDetailBranch === 'Semua Cabang' || row.branch_name === selectedDetailBranch))}
{@const activeDetailSummary = menu_branch_summary.find((row) => row.period === detailPeriod && row.branch_name === selectedDetailBranch)}
{@const activeDetailTopQty = [...activeDetailRows].sort((a, b) => (b.qty_current ?? 0) - (a.qty_current ?? 0)).slice(0, 10)}
{@const activeDetailTopRevenue = [...activeDetailRows].sort((a, b) => (b.revenue_current ?? 0) - (a.revenue_current ?? 0)).slice(0, 10)}
{@const activeDetailDrops = activeDetailRows.filter((row) => row.movement_status === 'Turun').length}
{@const activeDetailCatMix = menu_branch_mix.filter((row) => row.period === detailPeriod && row.branch_name === selectedDetailBranch && row.mix_type === 'Kategori')}
{@const activeDetailTierMix = menu_branch_mix.filter((row) => row.period === detailPeriod && row.branch_name === selectedDetailBranch && row.mix_type === 'Segmen Harga')}

<div class="control-stack">
  <div class="subpage-period-control">
    <div class="subpage-period-label">Periode Detail</div>
    <div class="control-scroll">
      <ButtonGroup name=detail_period>
        <ButtonGroupItem valueLabel="Kemarin" value="y" default />
        <ButtonGroupItem valueLabel="7 Hari" value="7d" />
        <ButtonGroupItem valueLabel="30 Hari" value="30d" />
      </ButtonGroup>
    </div>
    <div class="subpage-period-copy">Kemarin untuk cek operasional cepat. 7H untuk pola mingguan. 30H untuk membaca kontribusi cabang yang lebih stabil.</div>
  </div>
  <div class="subpage-period-control">
    <div class="subpage-period-label">Cabang</div>
    <div class="control-scroll">
      <ButtonGroup name=detail_branch>
        <ButtonGroupItem valueLabel="Semua Cabang" value="all" default />
        {#each menu_branch_list as branch}
          <ButtonGroupItem valueLabel={branch.branch_name} value={branch.branch_name} />
        {/each}
      </ButtonGroup>
    </div>
    <div class="subpage-period-copy">Pilih semua cabang untuk melihat sebaran, atau satu cabang untuk menjawab detail menu terjual di cabang tersebut.</div>
  </div>
</div>

<details class="context-acc">
  <summary>📖 Kapan subpage ini dipakai?</summary>
  <div class="acc-body">
    <ul>
      <li><strong>Cek cabang spesifik:</strong> jawab pertanyaan seperti “berapa Ayam Penyet terjual kemarin di cabang X?”.</li>
      <li><strong>Validasi sebelum aksi:</strong> kalau Ringkasan atau Pusat Aksi memberi sinyal drop, cek dulu apakah masalahnya menyebar atau hanya cabang tertentu.</li>
      <li><strong>Briefing operasional:</strong> pakai top qty untuk stok/prep, top revenue untuk rekomendasi staf dan upsell.</li>
      <li><strong>Perubahan status:</strong> Naik/Turun memakai ambang 20%. Kemarin dibanding hari yang sama minggu sebelumnya, 7H dibanding 7H sebelumnya, dan 30H dibanding 30H sebelumnya.</li>
    </ul>
  </div>
</details>

<div class="strategic-stack">
  <div class="strategic-header">
    <div class="strategic-eyebrow">🏪 Deep Dive Cabang · {activeDetailLabel}</div>
    <h2 class="strategic-title">Detail menu terjual untuk {selectedDetailBranch}</h2>
    <p class="strategic-copy">Subpage ini sengaja dibuat lebih granular daripada Ringkasan. Fokusnya bukan diagnosis portofolio, tapi bukti operasional per cabang dan per menu.</p>
  </div>

  <div class="kpi-grid">
    <div class="kpi-card volume">
      <div class="kpi-label">📦 Qty Terjual</div>
      <div class="kpi-value">{(activeDetailSummary?.total_qty ?? 0).toLocaleString('id-ID', {maximumFractionDigits:0})}</div>
      <div class="kpi-meta">{activeDetailLabel} · {selectedDetailBranch}</div>
    </div>
    <div class="kpi-card revenue">
      <div class="kpi-label">💵 Revenue</div>
      <div class="kpi-value">Rp {(activeDetailSummary?.total_revenue ?? 0).toLocaleString('id-ID', {maximumFractionDigits:0})}</div>
      <div class="kpi-meta">{(activeDetailSummary?.active_menu_count ?? 0).toLocaleString('id-ID')} menu aktif</div>
    </div>
    <div class="kpi-card mix">
      <div class="kpi-label">🏆 Top Qty</div>
      <div class="kpi-value">{activeDetailSummary?.top_qty_menu ?? '—'}</div>
      <div class="kpi-meta">{(activeDetailSummary?.top_qty ?? 0).toLocaleString('id-ID', {maximumFractionDigits:0})} porsi</div>
    </div>
    <div class="kpi-card {activeDetailDrops > 0 ? 'alert' : 'volume'}">
      <div class="kpi-label">📉 Menu Turun</div>
      <div class="kpi-value">{activeDetailDrops}</div>
      <div class="kpi-meta">{activeDetailDrops > 0 ? 'Cek stok, kualitas, atau pergeseran demand.' : 'Tidak ada drop >=20% pada filter ini.'}</div>
    </div>
  </div>

  <details class="acc-strategic" open>
    <summary>📊 Top Menu · Baca Stok dan Revenue</summary>
    <div class="acc-body">
      {#if activeDetailRows.length > 0}
      <div class="signal-card {activeDetailSummary?.top_qty_menu === activeDetailSummary?.top_revenue_menu ? 'safe' : 'neutral'}" style="margin-bottom:16px;">
        <div class="signal-label">{activeDetailSummary?.top_qty_menu === activeDetailSummary?.top_revenue_menu ? '✅ Satu Menu Dominan' : '🔀 Fokus Terpisah'}</div>
        <div class="signal-title">
          {#if activeDetailSummary?.top_qty_menu === activeDetailSummary?.top_revenue_menu}
            {activeDetailSummary?.top_qty_menu} adalah menu terlaris sekaligus revenue terbesar di {selectedDetailBranch}.
          {:else}
            {activeDetailSummary?.top_qty_menu} paling sering dipesan, sementara {activeDetailSummary?.top_revenue_menu} menghasilkan revenue terbesar.
          {/if}
        </div>
        <div class="signal-copy">
          {#if activeDetailSummary?.top_qty_menu === activeDetailSummary?.top_revenue_menu}
            Prioritasnya menjaga stok, prep, dan kualitas eksekusi menu ini karena gangguan kecil bisa langsung terasa ke volume dan omzet.
          {:else}
            Artinya briefing operasional perlu dipisah: stok mengikuti menu volume tinggi, sedangkan upsell mengikuti menu revenue tinggi.
          {/if}
        </div>
      </div>

      <Grid cols=2>
        <div>
          <BarChart data={activeDetailTopQty} x="menu_name" y="qty_current" swapXY=true
            title="Top 10 — Qty Terjual" xAxisTitle="Qty" colorPalette={['#4f86c6']} />
        </div>
        <div>
          <BarChart data={activeDetailTopRevenue} x="menu_name" y="revenue_current" swapXY=true
            title="Top 10 — Revenue (Rp)" yFmt="#,##0" xAxisTitle="Revenue (Rp)" colorPalette={['#e07b39']} />
        </div>
      </Grid>
      <div class="chart-insight">
        📌 <strong>Analisis cepat:</strong> qty tertinggi dipakai untuk kesiapan stok dan prep. Revenue tertinggi dipakai untuk prioritas rekomendasi staf, upsell, atau pairing menu.
      </div>
      {:else}
      <div class="signal-card safe" style="margin-top:0;">
        <div class="signal-label">✅ Kosong</div>
        <div class="signal-title">Belum ada penjualan pada filter ini.</div>
        <div class="signal-copy">Coba pilih periode atau cabang lain untuk melihat detail penjualan menu.</div>
      </div>
      {/if}
    </div>
  </details>

  <details class="acc-strategic">
    <summary>🥗 Mix Kategori & Segmen Harga · Baca Ketergantungan</summary>
    <div class="acc-body">
      {#if activeDetailCatMix.length > 0 || activeDetailTierMix.length > 0}
      <Grid cols=2>
        <div>
          <BarChart data={activeDetailCatMix} x="segment" y="total_revenue"
            title="Revenue per Kategori (Rp)" yFmt="#,##0" xAxisTitle="Kategori" yAxisTitle="Revenue (Rp)" />
        </div>
        <div>
          <BarChart data={activeDetailTierMix} x="segment" y="total_revenue"
            title="Revenue per Segmen Harga (Rp)" yFmt="#,##0" xAxisTitle="Segmen" yAxisTitle="Revenue (Rp)" />
        </div>
      </Grid>

      {#if activeDetailCatMix.length > 0}
      <div class="chart-insight">
        {#if activeDetailCatMix[0].pct_revenue >= 70}
          ⚠️ <strong>{activeDetailCatMix[0].segment}</strong> menyumbang {activeDetailCatMix[0].pct_revenue}% revenue {selectedDetailBranch}. Ini bagus sebagai engine utama, tapi riskan kalau supply, kualitas, atau demand kategori ini terganggu.
        {:else}
          ✅ <strong>Mix kategori cukup seimbang.</strong> Tidak ada satu kategori yang terlalu mendominasi revenue pada filter ini.
        {/if}
      </div>
      {/if}

      <details style="margin-top:14px;">
        <summary>📋 Detail kategori & segmen harga</summary>
        <div class="acc-body">
          <Grid cols=2>
            <div>
              {#if activeDetailCatMix.length > 0}
              <DataTable data={activeDetailCatMix}>
                <Column id="segment" title="Kategori"/>
                <Column id="total_menu" title="Menu" fmt="#,##0"/>
                <Column id="total_qty" title="Qty" fmt="#,##0"/>
                <Column id="total_revenue" title="Revenue (Rp)" fmt="#,##0"/>
                <Column id="avg_price" title="Harga Realisasi" fmt="#,##0"/>
                <Column id="pct_revenue" title="% Revenue" fmt="0.0\%"/>
              </DataTable>
              {:else}
              <div class="signal-card safe" style="margin-top:0;">
                <div class="signal-label">✅ Kosong</div>
                <div class="signal-title">Belum ada mix kategori.</div>
                <div class="signal-copy">Data kategori akan muncul saat penjualan periode ini tersedia.</div>
              </div>
              {/if}
            </div>
            <div>
              {#if activeDetailTierMix.length > 0}
              <DataTable data={activeDetailTierMix}>
                <Column id="segment" title="Segmen"/>
                <Column id="total_menu" title="Menu" fmt="#,##0"/>
                <Column id="total_qty" title="Qty" fmt="#,##0"/>
                <Column id="total_revenue" title="Revenue (Rp)" fmt="#,##0"/>
                <Column id="avg_price" title="Harga Realisasi" fmt="#,##0"/>
                <Column id="pct_revenue" title="% Revenue" fmt="0.0\%"/>
              </DataTable>
              {:else}
              <div class="signal-card safe" style="margin-top:0;">
                <div class="signal-label">✅ Kosong</div>
                <div class="signal-title">Belum ada mix segmen harga.</div>
                <div class="signal-copy">Data segmen akan muncul saat penjualan periode ini tersedia.</div>
              </div>
              {/if}
            </div>
          </Grid>
        </div>
      </details>
      {:else}
      <div class="signal-card safe" style="margin-top:0;">
        <div class="signal-label">✅ Kosong</div>
        <div class="signal-title">Belum ada data kategori atau segmen harga.</div>
        <div class="signal-copy">Detail akan muncul saat ada penjualan pada cabang dan periode yang dipilih.</div>
      </div>
      {/if}
    </div>
  </details>

  <details class="acc-strategic" open>
    <summary>📋 Tabel Detail · Cabang, Menu, Qty, Revenue</summary>
    <div class="acc-body">
      {#if activeDetailRows.length > 0}
      <DataTable data={activeDetailRows} rows=20>
        <Column id="branch_name" title="Cabang"/>
        <Column id="menu_name" title="Menu"/>
        <Column id="category" title="Kategori"/>
        <Column id="qty_current" title="Qty" fmt="#,##0"/>
        <Column id="revenue_current" title="Revenue (Rp)" fmt="#,##0"/>
        <Column id="avg_price" title="Harga Realisasi (Rp)" fmt="#,##0"/>
        <Column id="revenue_share_pct" title="% Revenue Cabang" fmt="0.0\%"/>
        <Column id="qty_previous" title="Qty Pembanding" fmt="#,##0"/>
        <Column id="pct_change_qty" title="Δ Qty (%)" fmt="+0.0;-0.0" contentType="delta"/>
        <Column id="movement_status" title="Status"/>
      </DataTable>
      {:else}
      <div class="signal-card safe" style="margin-top:0;">
        <div class="signal-label">✅ Kosong</div>
        <div class="signal-title">Tidak ada baris detail untuk filter ini.</div>
        <div class="signal-copy">Detail akan muncul saat ada penjualan menu di cabang dan periode yang dipilih.</div>
      </div>
      {/if}
    </div>
  </details>
</div>

{:else if inputs.view === 'portfolio'}

{@const selectedPortfolioBranchRaw = String(inputs.portfolio_branch ?? 'all')}
{@const selectedPortfolioBranchNormalized = decodeURIComponent(selectedPortfolioBranchRaw).replace(/\+/g, ' ')}
{@const selectedPortfolioBranch = selectedPortfolioBranchRaw === 'all' || selectedPortfolioBranchNormalized === 'Semua Cabang' ? 'Semua Cabang' : menu_branch_list.find((branch) => branch.branch_name === selectedPortfolioBranchRaw || branch.branch_name === selectedPortfolioBranchNormalized)?.branch_name ?? 'Semua Cabang'}
{@const activePortfolioEngineering = menu_branch_engineering.filter((row) => row.period === portfolioPeriod && row.branch_name === selectedPortfolioBranch)}
{@const portfolioPrimadonaMenus = activePortfolioEngineering.filter((m) => m.klasifikasi === 'Primadona')}
{@const portfolioMysteryMenus = activePortfolioEngineering.filter((m) => m.klasifikasi === 'Misteri')}
{@const portfolioWorkhorseMenus = activePortfolioEngineering.filter((m) => m.klasifikasi === 'Pekerja Keras')}
{@const portfolioWeakMenus = activePortfolioEngineering.filter((m) => m.klasifikasi === 'Lemah')}

<div class="control-stack">
  <div class="subpage-period-control">
    <div class="subpage-period-label">Periode Peta Menu</div>
    <div class="control-scroll">
      <ButtonGroup name=portfolio_period>
        <ButtonGroupItem valueLabel="7 Hari" value="7d" />
        <ButtonGroupItem valueLabel="30 Hari" value="30d" default />
      </ButtonGroup>
    </div>
    <div class="subpage-period-copy">7H cocok untuk eksperimen cepat, sedangkan 30H lebih stabil untuk membaca klasifikasi Primadona, Misteri, Pekerja Keras, dan Lemah.</div>
  </div>
  <div class="subpage-period-control">
    <div class="subpage-period-label">Cabang Peta Menu</div>
    <div class="control-scroll">
      <ButtonGroup name=portfolio_branch>
        <ButtonGroupItem valueLabel="Semua Cabang" value="all" default />
        {#each menu_branch_list as branch}
          <ButtonGroupItem valueLabel={branch.branch_name} value={branch.branch_name} />
        {/each}
      </ButtonGroup>
    </div>
    <div class="subpage-period-copy">Pilih cabang untuk melihat klasifikasi menu lokal. Menu yang kuat secara total bisa saja lemah di cabang tertentu.</div>
  </div>
</div>

<!-- ════ PORTFOLIO MAP ════ -->
<details class="context-acc">
  <summary>📖 Cara membaca klasifikasi menu</summary>
  <div class="acc-body">
    <ul>
      <li>Klasifikasi berbasis median volume dan revenue dalam periode aktif, bukan angka absolut.</li>
      <li>⭐ <strong>Primadona</strong> berarti volume dan revenue di atas median. Fokusnya jaga stok, kualitas, dan konsistensi eksekusi.</li>
      <li>🔮 <strong>Misteri</strong> berarti revenue di atas median, tapi volume di bawah median. Fokusnya dorong visibilitas, rekomendasi staf, atau pairing menu.</li>
      <li>💪 <strong>Pekerja Keras</strong> berarti volume di atas median, tapi revenue di bawah median. Fokusnya uji bundling, add-on, ukuran porsi, atau harga kecil bertahap.</li>
      <li>🔻 <strong>Lemah</strong> berarti volume dan revenue di bawah median. Ini bukan vonis hapus menu; validasi dulu di Pergerakan, terutama tren 90 hari.</li>
    </ul>
  </div>
</details>

<div class="strategic-stack">
  <div class="strategic-header">
    <div class="strategic-eyebrow">🔭 Perspektif Peta Menu · {selectedPortfolioBranch}</div>
    <h2 class="strategic-title">Baca posisi dan perlakuan menu per cabang</h2>
    <p class="strategic-copy">Dua lens di bawah ini dirancang untuk pertanyaan utama: komposisi portofolio menu saat ini seperti apa, dan apakah perlakuannya berubah saat dilihat di cabang tertentu?</p>
  </div>

  <details class="acc-strategic" open>
    <summary>🧭 Komposisi Portofolio · Baca Perlakuan Menu</summary>
    <div class="acc-body">
      <div class="snapshot-grid">
        <div class="snapshot-card star">
          <div class="snapshot-label">⭐ Primadona</div>
          <div class="snapshot-value">{portfolioPrimadonaMenus.length}</div>
          <div class="snapshot-copy">Jaga stok dan kualitas. Jangan ubah tanpa alasan kuat.</div>
        </div>
        <div class="snapshot-card mystery">
          <div class="snapshot-label">🔮 Misteri</div>
          <div class="snapshot-value">{portfolioMysteryMenus.length}</div>
          <div class="snapshot-copy">Revenue kuat, volume belum tinggi. Dorong visibilitas.</div>
        </div>
        <div class="snapshot-card workhorse">
          <div class="snapshot-label">💪 Pekerja Keras</div>
          <div class="snapshot-value">{portfolioWorkhorseMenus.length}</div>
          <div class="snapshot-copy">Volume kuat, revenue relatif rendah. Uji bundling/harga.</div>
        </div>
        <div class="snapshot-card weak">
          <div class="snapshot-label">🔻 Lemah</div>
          <div class="snapshot-value">{portfolioWeakMenus.length}</div>
          <div class="snapshot-copy">Validasi tren sebelum reformulasi atau retire.</div>
        </div>
      </div>

      <div class="chart-insight">
        📌 <strong>Analisis cepat:</strong> peta ini bukan ranking final. Primadona biasanya butuh perlindungan operasional, Misteri butuh dorongan demand, Pekerja Keras butuh monetisasi, dan Lemah butuh validasi tren sebelum keputusan besar.
      </div>
    </div>
  </details>

  <details class="acc-strategic" open>
    <summary>📍 Scatter Volume vs Revenue · Baca Posisi Menu</summary>
    <div class="acc-body">
      <div class="legend-chips">
        <span class="legend-chip star">⭐ Primadona — jaga stok & kualitas</span>
        <span class="legend-chip mystery">🔮 Misteri — tingkatkan visibilitas</span>
        <span class="legend-chip workhorse">💪 Pekerja Keras — uji bundling/harga</span>
        <span class="legend-chip weak">🔻 Lemah — evaluasi setelah validasi</span>
      </div>

      <ScatterPlot
        data={activePortfolioEngineering}
        x="total_qty"
        y="total_revenue"
        series="klasifikasi"
        pointName="menu_name"
        tooltipTitle="tooltip_label"
        xAxisTitle="Volume Terjual (Qty)"
        yAxisTitle="Total Revenue (Rp)"
        title="Peta Menu — Volume vs Revenue"
        yFmt="#,##0"
      />

      <div class="chart-insight">
        📌 <strong>Cara membaca chart ini:</strong> arah kanan berarti volume lebih tinggi, arah atas berarti revenue lebih tinggi. Jika satu menu dominan membuat titik lain menumpuk, gunakan tabel lengkap di bawah untuk membaca menu satu per satu. Tooltip menampilkan nama menu, kategori, klasifikasi, volume, dan revenue.
      </div>

      <details style="margin-top:14px;">
        <summary>📋 Lihat semua menu (tabel lengkap)</summary>
        <div class="acc-body">
          {#if activePortfolioEngineering.length > 0}
          <DataTable data={activePortfolioEngineering} rows=15>
            <Column id="klasifikasi" title="Klasifikasi"/>
            <Column id="branch_name" title="Cabang"/>
            <Column id="menu_name" title="Menu"/>
            <Column id="category" title="Kategori"/>
            <Column id="total_qty" title="Volume" fmt="#,##0"/>
            <Column id="total_revenue" title="Revenue (Rp)" fmt="#,##0"/>
            <Column id="avg_price_realisasi" title="Harga Realisasi (Rp)" fmt="#,##0"/>
            <Column id="aksi_disarankan" title="Aksi Disarankan"/>
          </DataTable>
          {:else}
          <div class="signal-card safe" style="margin-top:0;">
            <div class="signal-label">✅ Kosong</div>
            <div class="signal-title">Belum ada menu aktif pada periode ini.</div>
            <div class="signal-copy">Tabel akan muncul saat data penjualan menu tersedia.</div>
          </div>
          {/if}
        </div>
      </details>
    </div>
  </details>
</div>

{:else if inputs.view === 'movement'}

{@const selectedMovementBranchRaw = String(inputs.movement_branch ?? 'all')}
{@const selectedMovementBranchNormalized = decodeURIComponent(selectedMovementBranchRaw).replace(/\+/g, ' ')}
{@const selectedMovementBranch = selectedMovementBranchRaw === 'all' || selectedMovementBranchNormalized === 'Semua Cabang' ? 'Semua Cabang' : menu_branch_list.find((branch) => branch.branch_name === selectedMovementBranchRaw || branch.branch_name === selectedMovementBranchNormalized)?.branch_name ?? 'Semua Cabang'}
{@const activeMovementMovers = menu_branch_movers.filter((row) => row.period === movementPeriod && row.branch_name === selectedMovementBranch)}
{@const movementMoverDown = activeMovementMovers.filter((m) => m.movement_status === 'Turun')}
{@const movementMoverUp = activeMovementMovers.filter((m) => m.movement_status === 'Naik')}
{@const movementMoverNew = activeMovementMovers.filter((m) => m.movement_status === 'Baru')}
{@const movementMoverInactive = activeMovementMovers.filter((m) => m.movement_status === 'Tidak Aktif')}
{@const activeStructuralDeclines = structural_decline_90d_branch.filter((row) => row.branch_name === selectedMovementBranch)}
{@const activeDecliningTrend = declining_trend_90d_branch.filter((row) => row.branch_name === selectedMovementBranch)}
{@const activeDecliningByBranch = selectedMovementBranch === 'Semua Cabang' ? declining_by_branch : declining_by_branch.filter((row) => row.branch_name === selectedMovementBranch)}

<div class="control-stack">
  <div class="subpage-period-control">
    <div class="subpage-period-label">Periode Movers</div>
    <div class="control-scroll">
      <ButtonGroup name=movement_period>
        <ButtonGroupItem valueLabel="7 Hari" value="7d" default />
        <ButtonGroupItem valueLabel="30 Hari" value="30d" />
      </ButtonGroup>
    </div>
    <div class="subpage-period-copy">Selector ini hanya mengubah tabel movers jangka pendek. Panel Validasi 90H tetap memakai aturan persistensi 12 minggu karena konteksnya keputusan serius.</div>
  </div>
  <div class="subpage-period-control">
    <div class="subpage-period-label">Cabang Pergerakan</div>
    <div class="control-scroll">
      <ButtonGroup name=movement_branch>
        <ButtonGroupItem valueLabel="Semua Cabang" value="all" default />
        {#each menu_branch_list as branch}
          <ButtonGroupItem valueLabel={branch.branch_name} value={branch.branch_name} />
        {/each}
      </ButtonGroup>
    </div>
    <div class="subpage-period-copy">Pilih cabang untuk membedakan penurunan lokal dari tren yang menyebar di semua cabang.</div>
  </div>
</div>

<!-- ════ MOVERS & DECLINING ════ -->
<details class="context-acc">
  <summary>📖 Cara membaca pergerakan menu</summary>
  <div class="acc-body">
    <ul>
      <li><strong>⚡ 7H</strong> = sinyal cepat untuk cek stok, promo, kualitas, dan operasional minggu ini.</li>
      <li><strong>📅 30H</strong> = watchlist awal untuk menu yang mulai melemah, belum cukup untuk keputusan retire.</li>
      <li><strong>🧭 90H</strong> = validasi serius berbasis persistensi tren mingguan. Window 90H dibaca sebagai 12 minggu berjalan, lalu dihitung berapa minggu yang turun dibanding minggu sebelumnya.</li>
      <li><strong>🚦 Severity 90H</strong> = Pantau jika minimal 7/12 minggu turun dan akhir turun ≥10% dari peak mingguan. Waspada: 8/12 dan ≥15%. Kritis: 9/12, ≥25%, dan 3 minggu terakhir belum pulih signifikan.</li>
      <li><strong>📐 Kenapa dua syarat?</strong> Persistence memastikan grafik benar-benar sering turun; magnitude memastikan penurunannya cukup besar, bukan turun kecil-kecil tanpa dampak operasional.</li>
      <li><strong>📉 Turun / Naik</strong> = qty berubah minimal 20% dibanding periode pembanding.</li>
      <li><strong>⏸️ Tidak Aktif</strong> = perlu dicek stok, cabang, seasonality, atau memang menu sengaja tidak dijual.</li>
    </ul>
  </div>
</details>

<div class="strategic-stack">
  <div class="strategic-header">
    <div class="strategic-eyebrow">🔭 Perspektif Pergerakan · {selectedMovementBranch}</div>
    <h2 class="strategic-title">Pisahkan noise cabang dari tren yang layak ditindak</h2>
    <p class="strategic-copy">Tiga lens di bawah ini dirancang untuk menjawab: menu mana yang bergerak pada periode aktif, apakah penurunan itu sudah serius di 90H, dan apakah masalahnya lokal per cabang atau menyebar.</p>
  </div>

  <details class="acc-strategic" open>
    <summary>📊 Movers Periode Aktif · Baca Sinyal Terbaru</summary>
    <div class="acc-body">
      <div class="snapshot-grid" style="margin-bottom:16px;">
        <div class="snapshot-card weak">
          <div class="snapshot-label">📉 Turun</div>
          <div class="snapshot-value">{movementMoverDown.length}</div>
          <div class="snapshot-copy">Qty turun minimal 20% vs periode pembanding.</div>
        </div>
        <div class="snapshot-card star">
          <div class="snapshot-label">📈 Naik</div>
          <div class="snapshot-value">{movementMoverUp.length}</div>
          <div class="snapshot-copy">Qty naik minimal 20%; cek apakah karena promo atau demand organik.</div>
        </div>
        <div class="snapshot-card mystery">
          <div class="snapshot-label">🆕 Baru</div>
          <div class="snapshot-value">{movementMoverNew.length}</div>
          <div class="snapshot-copy">Muncul di periode aktif, tidak ada di periode pembanding.</div>
        </div>
        <div class="snapshot-card workhorse">
          <div class="snapshot-label">⏸️ Tidak Aktif</div>
          <div class="snapshot-value">{movementMoverInactive.length}</div>
          <div class="snapshot-copy">Ada di periode sebelumnya, tapi tidak terjual di periode aktif.</div>
        </div>
      </div>

      {#if movementMoverDown.length > 0}
      <div class="signal-card warn" style="margin-bottom:16px;">
        <div class="signal-label">⚠️ Sinyal Turun</div>
        <div class="signal-title">{movementMoverDown[0].menu_name} turun paling perlu dicek di {selectedMovementBranch}.</div>
        <div class="signal-copy">Qty berubah {movementMoverDown[0].pct_change_qty}% vs periode pembanding. Mulai dari cek stok, jam jual, cabang, dan kualitas eksekusi sebelum masuk evaluasi menu.</div>
      </div>
      {:else}
      <div class="signal-card safe" style="margin-bottom:16px;">
        <div class="signal-label">✅ Tidak Ada Drop Tajam</div>
        <div class="signal-title">Tidak ada menu yang turun minimal 20% pada periode aktif.</div>
        <div class="signal-copy">Fokus tetap pada menu naik, menu baru, dan validasi tren 90H untuk keputusan portofolio.</div>
      </div>
      {/if}

      {#if activeMovementMovers.length > 0}
      <DataTable data={activeMovementMovers} rows=10>
        <Column id="branch_name" title="Cabang"/>
        <Column id="movement_status" title="Status"/>
        <Column id="menu_name" title="Menu"/>
        <Column id="category" title="Kategori"/>
        <Column id="qty_current" title="Qty Sekarang" fmt="#,##0"/>
        <Column id="qty_previous" title="Qty Sebelum" fmt="#,##0"/>
        <Column id="pct_change_qty" title="Δ Qty (%)" fmt="+0.0;-0.0" contentType="delta"/>
        <Column id="pct_change_revenue" title="Δ Revenue (%)" fmt="+0.0;-0.0" contentType="delta"/>
      </DataTable>
      {:else}
      <div class="signal-card safe" style="margin-top:0;">
        <div class="signal-label">✅ Kosong</div>
        <div class="signal-title">Belum ada pergerakan menu pada periode ini.</div>
        <div class="signal-copy">Tabel movers akan muncul saat ada data periode aktif dan periode pembanding.</div>
      </div>
      {/if}
    </div>
  </details>

  <details class="acc-strategic" open>
    <summary>📉 Validasi 90 Hari · Baca Tren Serius</summary>
    <div class="acc-body">
      {#if activeStructuralDeclines.length > 0}
      <div class="signal-card critical" style="margin-bottom:16px;">
        <div class="signal-label">🚨 Kandidat Evaluasi Serius</div>
        <div class="signal-title">{activeStructuralDeclines[0].menu_name} turun {activeStructuralDeclines[0].declining_weeks_12} dari 12 minggu di {selectedMovementBranch}.</div>
        <div class="signal-copy">Qty minggu akhir turun {activeStructuralDeclines[0].pct_change_90d}% dari peak mingguan 90H. Ini menggabungkan persistence, magnitude, volume floor, dan kondisi terbaru supaya yang masuk benar-benar grafiknya turun, bukan drop sesaat.</div>
      </div>
      {:else}
      <div class="signal-card safe" style="margin-bottom:16px;">
        <div class="signal-label">✅ Belum Ada Tren Struktural</div>
        <div class="signal-title">Tidak ada menu yang memenuhi pola penurunan mingguan 90H.</div>
        <div class="signal-copy">Penurunan periode aktif lebih aman dibaca sebagai watchlist atau isu operasional dulu karena belum cukup persisten dan/atau belum cukup besar.</div>
      </div>
      {/if}

      {#if activeDecliningTrend.length > 0}
      <LineChart data={activeDecliningTrend} x="order_date" y="rolling_avg_qty" series="menu_name"
        title="Tren Penurunan Menu — Rolling Avg 7 Hari"
        xAxisTitle="Tanggal" yAxisTitle="Rata-rata Qty (7H)" />
      <div class="chart-insight">
        📌 <strong>Formula 90H:</strong> 90H dibaca sebagai 12 minggu berjalan. Hitung qty tiap minggu, lalu bandingkan minggu ini vs minggu sebelumnya. Pantau = minimal 7/12 minggu turun dan akhir turun ≥10% dari peak mingguan. Waspada = 8/12 dan ≥15%. Kritis = 9/12, ≥25%, dan 3 minggu terakhir belum pulih signifikan.
      </div>
      {/if}

      {#if activeStructuralDeclines.length > 0}
      <div class="chart-insight" style="margin-top:14px;">
        🧪 <strong>Studi kasus:</strong> {activeStructuralDeclines[0].menu_name} pernah mencapai peak {activeStructuralDeclines[0].weekly_qty_peak} porsi/minggu, lalu minggu akhir menjadi {activeStructuralDeclines[0].weekly_qty_akhir} porsi/minggu. Dari 12 minggu, {activeStructuralDeclines[0].declining_weeks_12} minggu lebih rendah dari minggu sebelumnya. Artinya penurunan {activeStructuralDeclines[0].pct_change_90d}% ini cukup persisten untuk divalidasi di {selectedMovementBranch}.
      </div>
      {/if}

      <details style="margin-top:14px;">
        <summary>📋 Kandidat 90H struktural</summary>
        <div class="acc-body">
          {#if activeStructuralDeclines.length > 0}
          <DataTable data={activeStructuralDeclines} rows=10>
            <Column id="branch_name" title="Cabang"/>
            <Column id="menu_name" title="Menu"/>
            <Column id="category" title="Kategori"/>
            <Column id="severity" title="Severity"/>
            <Column id="trend_status" title="Pola"/>
            <Column id="declining_weeks_12" title="Minggu Turun" fmt="#,##0"/>
            <Column id="weekly_qty_awal" title="Minggu Awal" fmt="#,##0.0"/>
            <Column id="weekly_qty_peak" title="Peak Mingguan" fmt="#,##0.0"/>
            <Column id="weekly_qty_akhir" title="Minggu Akhir" fmt="#,##0.0"/>
            <Column id="pct_change_90d" title="Δ dari Peak (%)" fmt="+0.0;-0.0" contentType="delta"/>
            <Column id="recent_status" title="Kondisi Terbaru"/>
            <Column id="decline_rule" title="Aturan Masuk"/>
          </DataTable>
          {:else}
          <div class="signal-card safe" style="margin-top:0;">
            <div class="signal-label">✅ Kosong</div>
            <div class="signal-title">Belum ada kandidat 90H struktural.</div>
            <div class="signal-copy">Tidak ada menu yang memenuhi kombinasi persistence mingguan, magnitude penurunan, volume floor, dan kondisi terbaru.</div>
          </div>
          {/if}
        </div>
      </details>
    </div>
  </details>

  <details class="acc-strategic">
    <summary>🏪 Penurunan per Cabang · Baca Lokal vs Menyebar</summary>
    <div class="acc-body">
      <div class="chart-insight" style="margin-top:0;margin-bottom:14px;">
        📌 <strong>Interpretasi cabang:</strong> kalau penurunan hanya muncul di satu cabang, mulai dari audit operasional cabang. Kalau menu yang sama turun di banyak cabang, masalahnya lebih mungkin di demand, harga, kualitas menu, atau positioning.
      </div>
      {#if activeDecliningByBranch.length > 0}
      <DataTable data={activeDecliningByBranch} rows=15>
        <Column id="branch_name" title="Cabang"/>
        <Column id="menu_name" title="Menu"/>
        <Column id="qty_30_awal" title="30H Awal" fmt="#,##0"/>
        <Column id="qty_30_akhir" title="30H Akhir" fmt="#,##0"/>
        <Column id="pct_change" title="Perubahan (%)" fmt="+0.0;-0.0" contentType="delta"/>
      </DataTable>
      {:else}
      <div class="signal-card safe" style="margin-top:0;">
        <div class="signal-label">✅ Kosong</div>
        <div class="signal-title">Tidak ada penurunan cabang yang perlu ditampilkan.</div>
        <div class="signal-copy">Belum ada kombinasi menu-cabang yang turun dibanding 30H awal pada window 90H.</div>
      </div>
      {/if}
    </div>
  </details>
</div>

{:else if inputs.view === 'action'}

{@const quickActions = menu_action_queue.filter((a) => a.action_group === 'Aksi Cepat')}
{@const portfolioActions = menu_action_queue.filter((a) => a.action_group === 'Aksi Portofolio')}
{@const seriousActions = menu_action_queue.filter((a) => a.action_group === 'Evaluasi Serius')}

<!-- ════ ACTION QUEUE ════ -->
<div class="section-card">
  <div class="section-head">
    <div class="section-eyebrow">🎯 Pusat Aksi</div>
    <h3 class="section-title">Triage aksi menu: cepat, portofolio, dan evaluasi serius</h3>
    <p class="section-copy">Pusat Aksi menggabungkan sinyal 7H, 30H, dan 90H. Tujuannya bukan memilih periode laporan, tetapi menentukan tindakan yang aman dilakukan sekarang dan tindakan yang masih perlu validasi.</p>
  </div>

  {#if menu_action_queue.length > 0}
  <div class="snapshot-grid" style="margin-bottom:14px;">
    <div class="snapshot-card mystery">
      <div class="snapshot-label">⚡ Aksi Cepat</div>
      <div class="snapshot-value">{quickActions.length}</div>
      <div class="snapshot-copy">Audit stok, kualitas, dan cabang dari sinyal 7H.</div>
    </div>
    <div class="snapshot-card workhorse">
      <div class="snapshot-label">🧭 Portofolio</div>
      <div class="snapshot-value">{portfolioActions.length}</div>
      <div class="snapshot-copy">Bundling, upsell, konsentrasi revenue, dan monetisasi menu.</div>
    </div>
    <div class="snapshot-card weak">
      <div class="snapshot-label">📉 Evaluasi Serius</div>
      <div class="snapshot-value">{seriousActions.length}</div>
      <div class="snapshot-copy">Kandidat 90H untuk diagnosis sebelum reformulasi atau retire.</div>
    </div>
    <div class="snapshot-card star">
      <div class="snapshot-label">📌 Total Aksi</div>
      <div class="snapshot-value">{menu_action_queue.length}</div>
      <div class="snapshot-copy">Urutan berbasis urgensi dan kekuatan sinyal.</div>
    </div>
  </div>

  <div class="strategic-stack">
    <details class="acc-strategic" open>
      <summary>⚡ Aksi Cepat · Audit Operasional</summary>
      <div class="acc-body">
        <details class="context-acc" style="margin-top:0;margin-bottom:14px;">
          <summary>📖 Kapan masuk Aksi Cepat?</summary>
          <div class="acc-body">
            <ul>
              <li>Menu masuk section ini kalau qty dalam <strong>7H terakhir turun minimal 20%</strong> dibanding 7H sebelumnya.</li>
              <li>Menu harus punya penjualan di 7H pembanding, supaya drop bukan sekadar menu baru atau data kosong.</li>
              <li>Ini dibaca sebagai sinyal operasional: stok, kualitas, jam jual, promo, atau eksekusi cabang.</li>
              <li><strong>Batas aman:</strong> jangan reformulasi, reprice besar, atau retire menu dari sinyal 7H saja.</li>
            </ul>
          </div>
        </details>

        {#if quickActions.length > 0}
        <div class="action-stack">
          {#each quickActions as action, i}
          <div class="action-card {action.severity === 'Kritis' ? 'critical' : action.severity === 'Tinggi' ? 'high' : action.severity === 'Sedang' ? 'moderate' : 'low'}">
            <div class="action-header">
              <span class="action-severity">{action.severity === 'Kritis' ? '🚨 KRITIS' : action.severity === 'Tinggi' ? '🔴 TINGGI' : '⚠️ SEDANG'} · #{i+1}</span>
              <span class="action-badge">{action.evidence_window}</span>
            </div>
            <div class="action-title">{action.menu_name} — {action.metric_value}</div>
            <div class="action-impact">💡 {action.impact_text}</div>
            <div class="action-rec">{action.recommended_action}</div>
            <div class="action-detail-grid">
              <div class="action-detail"><div class="action-detail-label">Langkah pertama</div><div class="action-detail-copy">{action.first_step}</div></div>
              <div class="action-detail"><div class="action-detail-label">Batas aman</div><div class="action-detail-copy">{action.guardrail}</div></div>
            </div>
          </div>
          {/each}
        </div>
        {:else}
        <div class="signal-card safe" style="margin-top:0;">
          <div class="signal-label">✅ Tidak Ada Drop Cepat</div>
          <div class="signal-title">Tidak ada aksi operasional 7H yang mendesak.</div>
          <div class="signal-copy">Fokus bisa bergeser ke portofolio 30H dan validasi 90H.</div>
        </div>
        {/if}
      </div>
    </details>

    <details class="acc-strategic" open>
      <summary>🧭 Aksi Portofolio · Dorong, Monetisasi, Kurangi Ketergantungan</summary>
      <div class="acc-body">
        <details class="context-acc" style="margin-top:0;margin-bottom:14px;">
          <summary>📖 Kapan masuk Aksi Portofolio?</summary>
          <div class="acc-body">
            <ul>
              <li><strong>Konsentrasi Revenue</strong> muncul kalau Top 5 menu menyumbang minimal <strong>55%</strong> revenue 30H. Di atas 70% dianggap tinggi.</li>
              <li><strong>Menu Turun 30H</strong> muncul kalau qty 30H terakhir turun minimal <strong>20%</strong> dibanding 30H sebelumnya.</li>
              <li><strong>Misteri</strong> berarti revenue 30H di atas median, tetapi volume di bawah median. Fokusnya dorong visibilitas dan rekomendasi staf.</li>
              <li><strong>Pekerja Keras</strong> berarti volume 30H di atas median, tetapi revenue di bawah median. Fokusnya bundling, add-on, atau harga kecil bertahap.</li>
              <li><strong>Batas aman:</strong> ini cukup untuk eksperimen portofolio, tapi keputusan permanen tetap perlu cek tren 90H, margin, dan cabang.</li>
            </ul>
          </div>
        </details>

        {#if portfolioActions.length > 0}
        <div class="action-stack">
          {#each portfolioActions as action, i}
          <div class="action-card {action.severity === 'Kritis' ? 'critical' : action.severity === 'Tinggi' ? 'high' : action.severity === 'Sedang' ? 'moderate' : 'low'}">
            <div class="action-header">
              <span class="action-severity">{action.severity === 'Kritis' ? '🚨 KRITIS' : action.severity === 'Tinggi' ? '🔴 TINGGI' : '⚠️ SEDANG'} · #{i+1}</span>
              <span class="action-badge">{action.action_type} · {action.evidence_window}</span>
            </div>
            <div class="action-title">{action.menu_name} — {action.metric_value}</div>
            <div class="action-impact">💡 {action.impact_text}</div>
            <div class="action-rec">{action.recommended_action}</div>
            <div class="action-detail-grid">
              <div class="action-detail"><div class="action-detail-label">Langkah pertama</div><div class="action-detail-copy">{action.first_step}</div></div>
              <div class="action-detail"><div class="action-detail-label">Batas aman</div><div class="action-detail-copy">{action.guardrail}</div></div>
            </div>
          </div>
          {/each}
        </div>
        {:else}
        <div class="signal-card safe" style="margin-top:0;">
          <div class="signal-label">✅ Portofolio Stabil</div>
          <div class="signal-title">Belum ada aksi portofolio yang menonjol.</div>
          <div class="signal-copy">Pantau klasifikasi Misteri, Pekerja Keras, dan konsentrasi Top 5 pada periode berikutnya.</div>
        </div>
        {/if}
      </div>
    </details>

    <details class="acc-strategic" open>
      <summary>📉 Evaluasi Serius · Validasi 90H Sebelum Keputusan Berat</summary>
      <div class="acc-body">
        <details class="context-acc" style="margin-top:0;margin-bottom:14px;">
          <summary>📖 Kapan masuk Evaluasi Serius?</summary>
          <div class="acc-body">
            <ul>
              <li>Menu masuk section ini kalau penurunannya <strong>persisten</strong>: 90H dibaca sebagai 12 minggu berjalan, lalu dihitung berapa minggu yang turun dibanding minggu sebelumnya.</li>
              <li><strong>Pantau</strong>: minimal <strong>7 dari 12 minggu</strong> turun dan minggu akhir turun minimal <strong>10%</strong> dari peak mingguan.</li>
              <li><strong>Waspada</strong>: minimal <strong>8 dari 12 minggu</strong> turun dan minggu akhir turun minimal <strong>15%</strong> dari peak mingguan.</li>
              <li><strong>Kritis</strong>: minimal <strong>9 dari 12 minggu</strong> turun, minggu akhir turun minimal <strong>25%</strong>, dan 3 minggu terakhir belum pulih signifikan.</li>
              <li>Peak mingguan minimal <strong>5 porsi/minggu</strong>, supaya menu kecil tidak terlihat kritis hanya karena turun dari angka sangat kecil.</li>
              <li>Section ini dipakai untuk validasi sebelum reformulasi, reprice besar, atau retire menu.</li>
              <li><strong>Batas aman:</strong> cek cabang, margin, stok bahan, dan histori promo sebelum mengambil keputusan berat.</li>
            </ul>
          </div>
        </details>

        {#if seriousActions.length > 0}
        <div class="action-stack">
          {#each seriousActions as action, i}
          <div class="action-card {action.severity === 'Kritis' ? 'critical' : action.severity === 'Tinggi' ? 'high' : action.severity === 'Sedang' ? 'moderate' : 'low'}">
            <div class="action-header">
              <span class="action-severity">{action.severity === 'Kritis' ? '🚨 KRITIS' : action.severity === 'Tinggi' ? '🔴 TINGGI' : action.severity === 'Waspada' ? '⚠️ WASPADA' : '👁️ PANTAU'} · #{i+1}</span>
              <span class="action-badge">{action.evidence_window}</span>
            </div>
            <div class="action-title">{action.menu_name} — {action.metric_value}</div>
            <div class="action-impact">💡 {action.impact_text}</div>
            <div class="action-rec">{action.recommended_action}</div>
            <div class="action-detail-grid">
              <div class="action-detail"><div class="action-detail-label">Langkah pertama</div><div class="action-detail-copy">{action.first_step}</div></div>
              <div class="action-detail"><div class="action-detail-label">Batas aman</div><div class="action-detail-copy">{action.guardrail}</div></div>
            </div>
          </div>
          {/each}
        </div>
        {:else}
        <div class="signal-card safe" style="margin-top:0;">
          <div class="signal-label">✅ Tidak Ada Kandidat Berat</div>
          <div class="signal-title">Belum ada menu yang perlu evaluasi serius 90H.</div>
          <div class="signal-copy">Keputusan besar seperti reformulasi, reprice besar, atau retire belum perlu diprioritaskan.</div>
        </div>
        {/if}
      </div>
    </details>
  </div>
  {:else}
  <div style="padding:14px 16px;border-radius:12px;border:1px solid rgba(22,163,74,0.2);background:rgba(22,163,74,0.06);">
    <div style="font-size:0.9rem;font-weight:700;color:#15803d;margin-bottom:3px;">✅ Tidak ada aksi prioritas saat ini</div>
    <div style="font-size:0.85rem;color:var(--color-text-secondary);">Portofolio tidak menunjukkan alarm besar pada periode aktif. Lanjutkan pemantauan rutin.</div>
  </div>
  {/if}
</div>

<details class="acc-strategic">
  <summary>⚠️ Catatan sebelum mengambil keputusan menu</summary>
  <div class="acc-body">
    <ul style="display:flex;flex-direction:column;gap:8px;list-style:none;padding:0;margin:0;font-size:0.9rem;line-height:1.7;color:var(--color-text-secondary);">
      <li>🗓️ <strong style="color:var(--color-text-primary);">"Kemarin"</strong> = tanggal data terakhir tersedia, bukan selalu hari kalender kemarin.</li>
      <li>📉 <strong style="color:var(--color-text-primary);">Penurunan satu minggu</strong> bukan sinyal cukup untuk hapus atau reformulasi menu — validasi dengan tren 90H dan data per cabang.</li>
      <li>💰 <strong style="color:var(--color-text-primary);">Revenue ≠ margin.</strong> Tidak ada data biaya bahan per menu di sini. Sambungkan dengan data inventori sebelum keputusan pricing.</li>
      <li>🏪 <strong style="color:var(--color-text-primary);">Penurunan lokal vs menyebar</strong> butuh penanganan berbeda — lokal adalah masalah operasional cabang, menyebar adalah masalah portofolio.</li>
    </ul>
  </div>
</details>

{/if}

</div>

{:else}
<div class="section-card">
  <h3 class="section-title">Data menu belum tersedia.</h3>
  <p class="section-copy">Pastikan source <code>restaurant.menu_performance</code> sudah ter-refresh dan memiliki data yang valid.</p>
</div>
{/if}
