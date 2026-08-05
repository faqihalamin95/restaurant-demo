---
title: Rapor
---


<style>
.interactive-card {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -1px rgba(0, 0, 0, 0.03);
}
.interactive-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 12px 20px -5px rgba(0, 0, 0, 0.1), 0 8px 10px -5px rgba(0, 0, 0, 0.04);
}
h2[id] {
  visibility: hidden;
  position: absolute;
  pointer-events: none;
  opacity: 0;
  margin: 0;
  padding: 0;
}
h2[id] * {
  display: none !important;
}


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

/* ── KPI Grid — 5 cards split ── */
.kpi-grid-top { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 12px; margin-bottom: 12px; }
.kpi-grid-bottom { display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 12px; }
.kpi-card {
  padding: 18px 16px; border-radius: 18px; text-align: center;
  border: 1.5px solid var(--color-border-tertiary);
  background: var(--color-background-secondary);
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.02), 0 1px 3px rgba(0, 0, 0, 0.01);
  position: relative; overflow: hidden; transition: all 0.22s ease;
}
.kpi-card:hover { transform: translateY(-2px); box-shadow: 0 8px 16px rgba(0, 0, 0, 0.04), 0 2px 4px rgba(0, 0, 0, 0.02); }
.kpi-card.volume { border-color: rgba(16, 185, 129, 0.22); background: linear-gradient(145deg, rgba(16,185,129,0.07), rgba(22,163,74,0.03)); }
.kpi-card.volume .kpi-label { color: #10b981; }
.kpi-card.revenue { border-color: rgba(37, 99, 235, 0.22); background: linear-gradient(145deg, rgba(37,99,235,0.06), rgba(99,102,241,0.03)); }
.kpi-card.revenue .kpi-label { color: #2563eb; }
.kpi-card.price { border-color: rgba(245, 158, 11, 0.22); background: linear-gradient(145deg, rgba(245,158,11,0.07), rgba(251,191,36,0.03)); }
.kpi-card.price .kpi-label { color: #d97706; }
.kpi-card.cost { border-color: rgba(220, 38, 38, 0.22); background: linear-gradient(145deg, rgba(239,68,68,0.07), rgba(220,38,38,0.03)); }
.kpi-card.cost .kpi-label { color: #dc2626; }
.kpi-card.margin { border-color: rgba(139, 92, 246, 0.22); background: linear-gradient(145deg, rgba(139,92,246,0.07), rgba(167,139,250,0.03)); }
.kpi-card.margin .kpi-label { color: #8b5cf6; }

.kpi-label { font-size: 10px; font-weight: 700; letter-spacing: 0.1em; text-transform: uppercase; margin-bottom: 8px; text-align: center !important; display: flex; justify-content: center; align-items: center; gap: 4px; }
.kpi-value { font-size: 1.35rem; font-weight: 800; letter-spacing: -0.02em; color: var(--color-text-primary); }
.kpi-prev { margin-top: 6px; font-size: 0.78rem; line-height: 1.5; color: var(--color-text-tertiary); font-style: italic; }

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

/* ===== Placeholder / Empty State ===== */
.empty-state {
  padding: 48px 32px;
  text-align: center;
  background: linear-gradient(135deg, #f8fafc, #f1f5f9);
  border: 2px dashed #cbd5e1;
  border-radius: 16px;
  margin: 24px 0 32px 0;
}
.empty-state-icon {
  font-size: 3.5rem;
  margin-bottom: 16px;
  animation: float 3s ease-in-out infinite;
}
@keyframes float {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-8px); }
}
.empty-state h3 {
  margin: 0 0 8px 0;
  color: #334155;
  font-size: 1.25rem;
  font-weight: 700;
}
.empty-state p {
  margin: 0;
  color: #64748b;
  font-size: 0.95rem;
  max-width: 480px;
  margin-left: auto;
  margin-right: auto;
  line-height: 1.6;
}

/* ===== Custom Segmented Control (Premium Buttons) ===== */
.custom-category-tabs {
  display: flex;
  justify-content: center;
  margin-top: 16px;
  margin-bottom: 8px; /* Internal spacing only */
}
.custom-category-tabs .custom-category-tabs .custom-category-tabs .custom-category-tabs /* ===== Custom Dropdown (Premium Selection) ===== */
.custom-dropdown-container {
  display: flex;
  justify-content: center;
  padding: 16px 0 8px 0;
}
.custom-dropdown-container .custom-dropdown-container /* ===== KPI Cards (Bab 1) ===== */
.kpi-card {
  transition: all 0.25s ease;
  position: relative;
  overflow: hidden;
}
.kpi-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 3px;
  border-radius: 3px 3px 0 0;
}
.kpi-card:hover {
  transform: translateY(-3px);
  box-shadow: 0 8px 24px -8px rgba(0,0,0,0.12);
}
.kpi-icon-wrapper {
  width: 40px;
  height: 40px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.2rem;
  margin-bottom: 10px;
}



/* ===== Chart wrapper ===== */
.chart-panel {
  background: transparent;
  border: none;
  padding: 12px 0 0 0;
  margin-top: 0;
}
.chart-panel h4 {
  font-size: 0.88rem;
  font-weight: 700;
  color: #334155;
  margin: 0 0 16px 0;
}

  .cross-sell-card {
    background: #f8fafc;
    border: 1px solid #e2e8f0;
    border-radius: 12px;
    padding: 14px 16px;
    transition: all 0.3s ease;
    position: relative;
    overflow: hidden;
  }
  .cross-sell-card:hover {
    transform: translateX(4px);
    background: #ffffff;
    border-color: #cbd5e1;
    box-shadow: 0 4px 12px -2px rgba(0,0,0,0.05);
  }
  .cross-sell-card.golden {
    border-color: #fcd34d;
    background: linear-gradient(to right, #fffbeb, #ffffff);
  }
  .cross-sell-card.golden:hover {
    border-color: #f59e0b;
    box-shadow: 0 4px 15px -2px rgba(245, 158, 11, 0.15);
  }
  .golden-badge {
    position: absolute;
    top: 0;
    right: 0;
    background: linear-gradient(90deg, #f59e0b, #ef4444);
    color: white;
    font-size: 0.6rem;
    font-weight: 800;
    padding: 3px 10px;
    border-bottom-left-radius: 8px;
    letter-spacing: 0.05em;
    text-transform: uppercase;
  }
  .cross-sell-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 8px;
    margin-top: 4px;
  }
  .cross-sell-title {
    font-size: 0.95rem;
    font-weight: 700;
    color: #1e293b;
    display: flex;
    align-items: center;
    gap: 6px;
  }
  .cross-sell-pct {
    font-size: 1.05rem;
    font-weight: 800;
  }
  .cross-sell-bar-bg {
    width: 100%;
    height: 8px;
    background: rgba(0,0,0,0.05);
    border-radius: 999px;
    overflow: hidden;
  }
  .cross-sell-bar-fill {
    height: 100%;
    border-radius: 999px;
    transition: width 1s cubic-bezier(0.4, 0, 0.2, 1);
  }

  .decision-box {
    display: flex;
    gap: 24px;
    padding: 24px 32px;
    border-radius: 16px;
    border: 2px solid transparent;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);
  }
  .decision-box.red {
    background: linear-gradient(135deg, #fef2f2 0%, #fee2e2 100%);
    border-color: #fca5a5;
    color: #991b1b;
  }
  .decision-box.red:hover {
    box-shadow: 0 15px 30px -5px rgba(220, 38, 38, 0.3);
    transform: translateY(-4px);
    border-color: #ef4444;
  }
  .decision-box.green {
    background: linear-gradient(135deg, #f0fdf4 0%, #dcfce7 100%);
    border-color: #86efac;
    color: #166534;
  }
  .decision-box.green:hover {
    box-shadow: 0 15px 30px -5px rgba(16, 185, 129, 0.3);
    transform: translateY(-4px);
    border-color: #10b981;
  }
  .decision-box.amber {
    background: linear-gradient(135deg, #fffbeb 0%, #fef3c7 100%);
    border-color: #fcd34d;
    color: #92400e;
  }
  .decision-box.amber:hover {
    box-shadow: 0 15px 30px -5px rgba(245, 158, 11, 0.3);
    transform: translateY(-4px);
    border-color: #f59e0b;
  }
  .decision-box.blue {
    background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%);
    border-color: #93c5fd;
    color: #1e3a8a;
  }
  .decision-box.blue:hover {
    box-shadow: 0 15px 30px -5px rgba(59, 130, 246, 0.3);
    transform: translateY(-4px);
    border-color: #3b82f6;
  }
  
  .decision-icon {
    font-size: 4rem;
    display: flex;
    align-items: center;
    justify-content: center;
    text-shadow: 0 8px 16px rgba(0,0,0,0.15);
    transition: transform 0.3s ease;
  }
  .decision-box:hover .decision-icon {
    transform: scale(1.1) rotate(-5deg);
  }
  
  .decision-content {
    flex: 1;
  }
  .decision-title {
    font-size: 1.25rem;
    font-weight: 800;
    margin-bottom: 12px;
    display: flex;
    justify-content: space-between;
    align-items: center;
  }
  .decision-text {
    font-size: 1.05rem;
    line-height: 1.6;
    font-weight: 500;
    margin: 0;
  }
  .decision-footer {
    margin-top: 16px;
    font-size: 0.8rem;
    opacity: 0.8;
    border-top: 1px dashed currentColor;
    padding-top: 12px;
  }
  .ai-badge {
    background: rgba(0,0,0,0.08);
    padding: 6px 12px;
    border-radius: 8px;
    font-size: 0.65rem;
    text-transform: uppercase;
    font-weight: 800;
    letter-spacing: 0.05em;
  }
</style>

```sql menu_dates
SELECT * FROM restaurant.mart_menu_dates
```

```sql menu_health_overview
SELECT * FROM restaurant.mart_menu_health_overview
```





































```sql movers_30d
SELECT * FROM restaurant.menu_movers_30d
```

```sql structural_decline_90d
SELECT * FROM restaurant.menu_a_structural_decline_90d
```

```sql structural_decline_90d_branch
SELECT * FROM restaurant.menu_a_structural_decline_90d_branch
```

```sql declining_trend_90d
SELECT * FROM restaurant.menu_b_declining_trend_90d
```

```sql declining_trend_90d_branch
SELECT * FROM restaurant.menu_b_declining_trend_90d_branch
```

{#if menu_health_overview.length > 0 && menu_dates.length > 0}
{@const activeMovers = movers_30d}
{@const movementMoverDown = activeMovers.filter(d => d.movement_status === 'Turun')}
{@const movementMoverUp = activeMovers.filter(d => d.movement_status === 'Naik')}
{@const movementMoverNew = activeMovers.filter(d => d.movement_status === 'Baru')}
{@const movementMoverInactive = activeMovers.filter(d => d.movement_status === 'Tidak Aktif')}
{@const activeMovementMovers = activeMovers}
{@const activeStructuralDeclines = structural_decline_90d}
{@const activeDecliningByBranch = structural_decline_90d_branch}
{@const activeDecliningTrend = declining_trend_90d}
{@const selectedMovementBranch = 'Semua Cabang'}

<MenuTabs activeTab="rapor" />



<!-- ════ MOVERS & DECLINING ════ -->
<details class="context-acc">
  <summary>📖 Cara Cepat Menggunakan Halaman Ini</summary>
  <div class="acc-body">
    <div style="display: flex; align-items: center; gap: 12px; padding: 8px 0; width: 100%;">
      <!-- Step 1 Card -->
      <div class="interactive-card" style="flex: 1 1 0%; min-width: 0; background: #f4f8fb; border: 1px solid #e1ecf4; border-radius: 16px; padding: 20px; position: relative;">
        <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 12px;">
          <div style="position: relative;">
            <div style="font-size: 1.4rem; height: 40px; width: 40px; display: flex; align-items: center; justify-content: center; background: white; border-radius: 12px; box-shadow: 0 2px 8px rgba(124, 168, 209, 0.15);">🔭</div>
            <div style="position: absolute; width: 20px; height: 20px; background: #7ca8d1; color: white; border-radius: 50%; font-size: 0.7rem; font-weight: 800; display: flex; align-items: center; justify-content: center; box-shadow: 0 2px 4px rgba(124, 168, 209, 0.3); border: 2px solid white; top: -6px; right: -6px;">1</div>
          </div>
          <div style="font-weight: 800; color: var(--color-text-primary); font-size: 1rem;">Pantau Makro</div>
        </div>
        <div style="font-size: 0.85rem; color: var(--color-text-secondary); line-height: 1.6;">
          Amati daftar menu di atas yang mengalami <strong>anomali drastis</strong> (lonjakan, drop tajam, atau tren mati suri).
        </div>
      </div>
      
      <!-- Arrow 1 -->
      <div style="font-size: 1.5rem; color: #cbd5e1; font-weight: bold; flex-shrink: 0; display: flex; align-items: center; justify-content: center;">➔</div>
      
      <!-- Step 2 Card -->
      <div class="interactive-card" style="flex: 1 1 0%; min-width: 0; background: #f9f5fa; border: 1px solid #eee1f1; border-radius: 16px; padding: 20px; position: relative;">
        <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 12px;">
          <div style="position: relative;">
            <div style="font-size: 1.4rem; height: 40px; width: 40px; display: flex; align-items: center; justify-content: center; background: white; border-radius: 12px; box-shadow: 0 2px 8px rgba(178, 139, 194, 0.15);">🎯</div>
            <div style="position: absolute; width: 20px; height: 20px; background: #b28bc2; color: white; border-radius: 50%; font-size: 0.7rem; font-weight: 800; display: flex; align-items: center; justify-content: center; box-shadow: 0 2px 4px rgba(178, 139, 194, 0.3); border: 2px solid white; top: -6px; right: -6px;">2</div>
          </div>
          <div style="font-weight: 800; color: var(--color-text-primary); font-size: 1rem;">Pilih Target</div>
        </div>
        <div style="font-size: 0.85rem; color: var(--color-text-secondary); line-height: 1.6;">
          Gulir ke bawah dan <strong>pilih menu bermasalah</strong> tersebut lewat <i>dropdown</i> untuk mulai dibedah.
        </div>
      </div>

      <!-- Arrow 2 -->
      <div style="font-size: 1.5rem; color: #cbd5e1; font-weight: bold; flex-shrink: 0; display: flex; align-items: center; justify-content: center;">➔</div>

      <!-- Step 3 Card -->
      <div class="interactive-card" style="flex: 1 1 0%; min-width: 0; background: #f4fbf7; border: 1px solid #dcf2e5; border-radius: 16px; padding: 20px; position: relative;">
        <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 12px;">
          <div style="position: relative;">
            <div style="font-size: 1.4rem; height: 40px; width: 40px; display: flex; align-items: center; justify-content: center; background: white; border-radius: 12px; box-shadow: 0 2px 8px rgba(123, 191, 153, 0.15);">🧬</div>
            <div style="position: absolute; width: 20px; height: 20px; background: #7bbf99; color: white; border-radius: 50%; font-size: 0.7rem; font-weight: 800; display: flex; align-items: center; justify-content: center; box-shadow: 0 2px 4px rgba(123, 191, 153, 0.3); border: 2px solid white; top: -6px; right: -6px;">3</div>
          </div>
          <div style="font-weight: 800; color: var(--color-text-primary); font-size: 1rem;">Deepdive Masalah</div>
        </div>
        <div style="font-size: 0.85rem; color: var(--color-text-secondary); line-height: 1.6;">
          Analisis detail: pantau <strong>tren harian, margin profit, dan perbandingan cabang</strong> secara mendalam.
        </div>
      </div>
    </div>
  </div>
</details>


{:else}

<div class="section-card">
  <h3 class="section-title">Data menu belum tersedia.</h3>
  <p class="section-copy">Pastikan source <code>restaurant.menu_performance</code> sudah ter-refresh dan memiliki data yang valid.</p>
</div>
{/if}


<div class="strategic-stack" style="margin-top: 32px; margin-bottom: 24px;">
  <div class="strategic-header">
    <div class="strategic-eyebrow">🧬 Buku Medis Menu (Menu 360°)</div>
    <div class="toc-anchor" style="position: absolute; opacity: 0; pointer-events: none; margin: 0; padding: 0; height: 0; overflow: hidden; font-size: 0px;">

## Bedah Performa & Finansial Menu Individual

</div>
<h2 class="strategic-title">Bedah Performa & Finansial Menu Individual</h2>
    <p class="strategic-copy">Pilih salah satu menu untuk membedah komposisi margin, estimasi HPP resep, tren penjualan harian, dan distribusi antar cabang.</p>
  </div>
</div>

```sql category_list
SELECT DISTINCT 
  category,
  CASE 
    WHEN lower(category) IN ('makanan', 'main') THEN '🍔 ' || category
    WHEN lower(category) IN ('minuman', 'drink') THEN '🍹 ' || category
    WHEN lower(category) = 'dessert' THEN '🍰 ' || category
    WHEN lower(category) = 'snack' THEN '🍟 ' || category
    ELSE '🍽️ ' || category
  END as category_label
FROM restaurant.menu_performance
WHERE category IS NOT NULL
ORDER BY category
```

```sql menu_list
SELECT DISTINCT menu_name, category 
FROM restaurant.menu_performance 
ORDER BY menu_name
```

<div style="display: flex; flex-direction: column; gap: 24px; margin-bottom: 32px;">
<SectionCard 
  eyebrow="<span style='font-size: 12px;'>📂 Langkah 1</span>" 
  title="Pilih Kategori Menu" 
  description="Tentukan kelompok menu yang ingin dianalisis (Misal: main, drink, dessert, snack)."
>
  <div class="custom-category-tabs">
    <ButtonGroup name="selected_category">
      <ButtonGroupItem valueLabel="✨ Semua Kategori" value="Semua Kategori" />
      {#each category_list as cat}
        <ButtonGroupItem 
          valueLabel={cat.category_label} 
          value={cat.category} 
        />
      {/each}
    </ButtonGroup>
  </div>
</SectionCard>

{#if category_list.length > 0}
{@const selectedCatRaw = inputs.selected_category?.value ?? inputs.selected_category}
{@const isValidCategory = selectedCatRaw === 'Semua Kategori' || category_list.some(c => c.category === selectedCatRaw)}

{#if isValidCategory}
<SectionCard 
  eyebrow="<span style='font-size: 12px;'>🎯 Langkah 2</span>" 
  title="Target Menu Spesifik" 
  description="Pilih satu menu untuk membedah komposisi margin, estimasi HPP, dan tren penjualannya."
>
  <div class="custom-dropdown-container">
    {#if selectedCatRaw === 'Semua Kategori'}
    <Dropdown 
      name="selected_menu" 
      data={menu_list} 
      value="menu_name"
    />
    {:else}
    <Dropdown 
      name="selected_menu" 
      data={menu_list} 
      value="menu_name"
      where="category = '{selectedCatRaw}'"
    />
    {/if}
  </div>
</SectionCard>
{:else}
<div class="empty-state">
  <div class="empty-state-icon">🗺️</div>
  <h3>Pilih Kategori untuk Memulai Analisis</h3>
  <p>Klik <strong>"Semua Kategori"</strong> untuk melihat seluruh menu, atau pilih kategori spesifik di atas untuk memfilter daftar menu yang tersedia.</p>
</div>
{/if}
{/if}
</div>

```sql menu_stats
SELECT 
  menu_name,
  category,
  SUM(total_qty_sold) as total_qty,
  SUM(total_revenue) as total_revenue,
  SUM(total_revenue) / NULLIF(SUM(total_qty_sold), 0) as avg_price,
  -- Estimasi HPP (karena data asli belum ada, kita asumsikan HPP = 45% dari harga jual rata-rata)
  (SUM(total_revenue) / NULLIF(SUM(total_qty_sold), 0)) * 0.45 as est_hpp,
  -- Margin = avg_price - est_hpp
  (SUM(total_revenue) / NULLIF(SUM(total_qty_sold), 0)) * 0.55 as est_margin
FROM restaurant.menu_performance
WHERE menu_name = '${inputs.selected_menu.value}'
  AND order_date >= (SELECT MAX(order_date) - INTERVAL 30 DAY FROM restaurant.menu_performance)
GROUP BY 1, 2
```

```sql menu_daily_trend
SELECT 
  order_date as date,
  SUM(total_qty_sold) as qty,
  SUM(total_revenue) as revenue
FROM restaurant.menu_performance
WHERE menu_name = '${inputs.selected_menu.value}'
  AND order_date >= (SELECT MAX(order_date) - INTERVAL 30 DAY FROM restaurant.menu_performance)
GROUP BY 1
ORDER BY 1
```

```sql menu_insights
WITH peak_sales AS (
  SELECT order_date, SUM(total_qty_sold) as peak_qty
  FROM restaurant.menu_performance
  WHERE menu_name = '${inputs.selected_menu.value}'
    AND order_date >= (SELECT MAX(order_date) - INTERVAL 30 DAY FROM restaurant.menu_performance)
  GROUP BY 1
  ORDER BY 2 DESC
  LIMIT 1
),
branch_sales AS (
  SELECT branch_name, SUM(total_qty_sold) as b_qty
  FROM restaurant.menu_performance
  WHERE menu_name = '${inputs.selected_menu.value}'
    AND order_date >= (SELECT MAX(order_date) - INTERVAL 30 DAY FROM restaurant.menu_performance)
  GROUP BY 1
),
total_sales AS (
  SELECT NULLIF(SUM(b_qty), 0) as total FROM branch_sales
),
top_branch AS (
  SELECT branch_name, (b_qty * 100.0 / (SELECT total FROM total_sales)) as pct
  FROM branch_sales
  ORDER BY b_qty DESC
  LIMIT 1
)
SELECT 
  (SELECT order_date FROM peak_sales) as peak_date,
  (SELECT peak_qty FROM peak_sales) as peak_qty,
  (SELECT branch_name FROM top_branch) as top_branch_name,
  (SELECT pct FROM top_branch) as top_branch_pct
```

```sql menu_branch_comparison
WITH total AS (
  SELECT NULLIF(SUM(total_qty_sold), 0) as grand_total
  FROM restaurant.menu_performance
  WHERE menu_name = '${inputs.selected_menu.value}'
    AND order_date >= (SELECT MAX(order_date) - INTERVAL 30 DAY FROM restaurant.menu_performance)
),
stats AS (
  SELECT 
    branch_name,
    SUM(total_qty_sold) as total_qty,
    SUM(total_revenue) as total_revenue,
    (SUM(total_qty_sold) * 100.0 / (SELECT grand_total FROM total)) as contribution_pct
  FROM restaurant.menu_performance
  WHERE menu_name = '${inputs.selected_menu.value}'
    AND order_date >= (SELECT MAX(order_date) - INTERVAL 30 DAY FROM restaurant.menu_performance)
  GROUP BY 1
)
SELECT 
  *,
  CASE 
    WHEN contribution_pct >= 30 THEN '🔥 Leader'
    WHEN contribution_pct < 15 THEN '⚠️ Tertinggal'
    ELSE '⚖️ Stabil'
  END as status_badge
FROM stats
ORDER BY total_qty DESC
```

```sql menu_evaluation
WITH global_avg_90d AS (
  SELECT 
    AVG(total_qty) as avg_qty,
    AVG(total_revenue) as avg_revenue
  FROM (
    SELECT menu_name, SUM(total_qty_sold) as total_qty, SUM(total_revenue) as total_revenue
    FROM restaurant.menu_performance
    WHERE order_date >= (SELECT MAX(order_date) - INTERVAL 90 DAY FROM restaurant.menu_performance)
    GROUP BY menu_name
  )
),
this_menu_90d AS (
  SELECT 
    SUM(total_qty_sold) as qty_90,
    SUM(total_revenue) as rev_90
  FROM restaurant.menu_performance
  WHERE menu_name = '${inputs.selected_menu.value}'
    AND order_date >= (SELECT MAX(order_date) - INTERVAL 90 DAY FROM restaurant.menu_performance)
),
this_menu_trend AS (
  SELECT 
    SUM(CASE WHEN order_date >= (SELECT MAX(order_date) - INTERVAL 30 DAY FROM restaurant.menu_performance) THEN total_qty_sold ELSE 0 END) as qty_last_30,
    SUM(CASE WHEN order_date >= (SELECT MAX(order_date) - INTERVAL 90 DAY FROM restaurant.menu_performance) AND order_date < (SELECT MAX(order_date) - INTERVAL 30 DAY FROM restaurant.menu_performance) THEN total_qty_sold ELSE 0 END) / 2.0 as avg_qty_prev_30
  FROM restaurant.menu_performance
  WHERE menu_name = '${inputs.selected_menu.value}'
),
cross_sell AS (
  SELECT MAX(match_pct) as max_match
  FROM restaurant.mart_menu_basket_analysis
  WHERE menu_name = '${inputs.selected_menu.value}'
)
SELECT 
  t90.qty_90 as qty,
  t90.rev_90 as rev,
  g90.avg_qty,
  g90.avg_revenue,
  tr.qty_last_30,
  tr.avg_qty_prev_30,
  CASE 
    WHEN tr.avg_qty_prev_30 > 0 AND (tr.qty_last_30 - tr.avg_qty_prev_30) / tr.avg_qty_prev_30 >= 0.15 THEN 'naik'
    WHEN tr.avg_qty_prev_30 > 0 AND (tr.qty_last_30 - tr.avg_qty_prev_30) / tr.avg_qty_prev_30 <= -0.15 THEN 'turun'
    ELSE 'stabil'
  END as trend_status,
  CASE 
    WHEN lower('${inputs.selected_menu.value}') LIKE '%seafood%' OR lower('${inputs.selected_menu.value}') LIKE '%special%' OR lower('${inputs.selected_menu.value}') LIKE '%spesial%' THEN 'Tinggi (Bahan Unik/Spesifik)'
    ELSE 'Rendah (Berbagi Bahan)'
  END as inventory_complexity,
  
  -- We use 90d data to classify BCG, with 85% tolerance (Borderline)
  CASE 
    WHEN t90.qty_90 >= g90.avg_qty AND t90.rev_90 >= g90.avg_revenue THEN '⭐ Primadona'
    WHEN t90.qty_90 >= g90.avg_qty AND t90.rev_90 < g90.avg_revenue THEN '🐴 Pekerja Keras'
    WHEN t90.qty_90 < g90.avg_qty AND t90.qty_90 >= (g90.avg_qty * 0.85) AND t90.rev_90 >= (g90.avg_revenue * 0.85) THEN '⚖️ Stabil (Borderline)'
    WHEN t90.qty_90 < g90.avg_qty AND t90.rev_90 >= g90.avg_revenue THEN '❓ Misteri'
    ELSE '⚠️ Lemah'
  END || 
  CASE 
    WHEN tr.avg_qty_prev_30 > 0 AND (tr.qty_last_30 - tr.avg_qty_prev_30) / tr.avg_qty_prev_30 >= 0.15 THEN ' (Tren Naik 📈)'
    WHEN tr.avg_qty_prev_30 > 0 AND (tr.qty_last_30 - tr.avg_qty_prev_30) / tr.avg_qty_prev_30 <= -0.15 THEN ' (Tren Turun 📉)'
    ELSE ' (Stabil ➖)'
  END as matrix_class,

  -- Action color using 90d logic, scaled pasif logic (15/mo = 45/90d)
  CASE
    WHEN t90.qty_90 >= g90.avg_qty THEN 'green'
    WHEN t90.qty_90 >= (g90.avg_qty * 0.85) THEN 'blue'
    WHEN t90.qty_90 < (g90.avg_qty * 0.85) AND t90.qty_90 >= 45 AND NOT (lower('${inputs.selected_menu.value}') LIKE '%seafood%' OR lower('${inputs.selected_menu.value}') LIKE '%special%' OR lower('${inputs.selected_menu.value}') LIKE '%spesial%') THEN 'blue'
    WHEN t90.qty_90 < 45 THEN 'red'
    ELSE 'amber'
  END as action_color,

  CASE 
    WHEN t90.qty_90 >= g90.avg_qty AND t90.rev_90 >= g90.avg_revenue AND COALESCE(c.max_match, 0) >= 10 THEN 'Menu andalan yang luar biasa. Selain untung besar, menu ini terbukti kuat menarik penjualan produk lain (Cross-selling tinggi). Jadikan fokus promosi utama dan jangan pernah ubah resepnya!'
    WHEN t90.qty_90 >= g90.avg_qty AND t90.rev_90 >= g90.avg_revenue AND COALESCE(c.max_match, 0) < 10 THEN 'Menu ini menghasilkan untung besar secara mandiri, tapi pelanggan jarang menambah pesanan lain. Latih kasir untuk lebih agresif menawarkan upsell minuman/dessert setiap ada pesanan menu ini.'
    WHEN t90.qty_90 >= g90.avg_qty AND t90.rev_90 < g90.avg_revenue THEN 'Margin menu ini tipis, TAPI sangat laris. JANGAN naikkan harganya sembarangan, biarkan ia terus memancing kedatangan pelanggan. Fokus ciptakan paket dengan minuman ber-margin tinggi.'
    WHEN t90.qty_90 < g90.avg_qty AND t90.qty_90 >= (g90.avg_qty * 0.85) THEN '💡 Menu ini berada sedikit di bawah rata-rata (-15% margin toleransi). Performanya masuk kategori <strong>Aman/Stabil</strong>. Pertahankan posisinya dan coba berikan promo ringan untuk mendorongnya melewati batas rata-rata.'
    WHEN t90.qty_90 < (g90.avg_qty * 0.85) AND t90.qty_90 >= 45 AND NOT (lower('${inputs.selected_menu.value}') LIKE '%seafood%' OR lower('${inputs.selected_menu.value}') LIKE '%special%' OR lower('${inputs.selected_menu.value}') LIKE '%spesial%') THEN '💡 Walau penjualannya di bawah rata-rata, menu ini menggunakan <strong>Bahan Baku Rendah Risiko</strong> (berbagi bahan dengan menu lain). Pertahankan saja sebagai variasi menu tanpa perlu dipromosikan berlebihan, karena risiko dead-stock-nya mendekati nol.'
    WHEN t90.qty_90 < 45 AND (lower('${inputs.selected_menu.value}') LIKE '%seafood%' OR lower('${inputs.selected_menu.value}') LIKE '%special%' OR lower('${inputs.selected_menu.value}') LIKE '%spesial%') THEN '🚨 Untungnya besar, tapi sangat tidak laku (Pasif <15 porsi/bulan rata-rata) dan bahannya rentan basi. Segera ubah statusnya menjadi menu musiman (Seasonal/Weekend Only) untuk meminimalisir food waste, atau DROP.'
    ELSE '⚠️ Menu berkinerja di bawah rata-rata. Namun karena volume penjualannya masih aman (>15 porsi/bulan rata-rata), cobalah strategi diskon atau evaluasi rasa sebelum memutuskan DROP.'
  END 
  || 
  CASE 
    WHEN tr.avg_qty_prev_30 > 0 AND (tr.qty_last_30 - tr.avg_qty_prev_30) / tr.avg_qty_prev_30 <= -0.15 THEN '<br><br>📉 <b>Peringatan Tren Penjualan:</b> Waspada! Penjualan 30 hari terakhir menunjukkan <b>penurunan sebesar ' || ROUND(ABS((tr.qty_last_30 - tr.avg_qty_prev_30) / tr.avg_qty_prev_30 * 100)) || '%</b> dibanding rata-rata sebelumnya. Cek apakah ada masalah rasa atau ketersediaan bahan.'
    WHEN tr.avg_qty_prev_30 > 0 AND (tr.qty_last_30 - tr.avg_qty_prev_30) / tr.avg_qty_prev_30 >= 0.15 THEN '<br><br>📈 <b>Sinyal Tren Penjualan:</b> Berita baik! Penjualan 30 hari terakhir <b>meroket ' || ROUND(((tr.qty_last_30 - tr.avg_qty_prev_30) / tr.avg_qty_prev_30 * 100)) || '%</b> dibanding rata-rata sebelumnya. Momentum ini sangat bagus, pertahankan!'
    ELSE ''
  END as action_plan

FROM this_menu_90d t90
CROSS JOIN global_avg_90d g90
CROSS JOIN this_menu_trend tr
CROSS JOIN cross_sell c
```

```sql menu_cross_sell
WITH main_vol AS (
  SELECT SUM(total_qty_sold) as qty_90
  FROM restaurant.menu_performance
  WHERE menu_name = '${inputs.selected_menu.value}'
    AND order_date >= (SELECT MAX(order_date) - INTERVAL 90 DAY FROM restaurant.menu_performance)
)
SELECT 
  b.paired_menu,
  b.match_pct,
  (SELECT category FROM restaurant.menu_performance WHERE menu_name = b.paired_menu LIMIT 1) as category,
  (SELECT qty_90 FROM main_vol) as main_qty_90
FROM restaurant.mart_menu_basket_analysis b
WHERE b.menu_name = '${inputs.selected_menu.value}'
ORDER BY b.match_pct DESC
LIMIT 3
```

```sql menu_bom
WITH base AS (
  SELECT 
    '${inputs.selected_menu.value}' as menu_name,
    category,
    (SUM(total_revenue) / NULLIF(SUM(total_qty_sold), 0)) * 0.45 as target_hpp
  FROM restaurant.menu_performance
  WHERE menu_name = '${inputs.selected_menu.value}'
  GROUP BY category
)
SELECT 
  CASE 
    WHEN menu_name ILIKE '%Air Mineral%' THEN 'Produk Jadi'
    ELSE 'Bahan Utama' 
  END as component,
  CASE 
    WHEN menu_name ILIKE '%Air Mineral%' THEN '🧊 Air Mineral Kemasan'
    WHEN lower(category) IN ('minuman', 'drink') THEN '💧 Liquid / Ekstrak / Sirup'
    WHEN lower(category) IN ('dessert') THEN '🍦 Susu / Krim / Adonan Dasar'
    WHEN lower(category) IN ('snack') THEN '🥔 Bahan Kering / Karbohidrat'
    ELSE '🥩 Protein / Bahan Mentah'
  END as item,
  CASE 
    WHEN menu_name ILIKE '%Air Mineral%' THEN '1 Botol'
    WHEN lower(category) IN ('minuman', 'drink') THEN '200 ml'
    WHEN lower(category) IN ('dessert') THEN '150 gram'
    ELSE '1 Porsi Standar (250g)'
  END as qty,
  CASE 
    WHEN menu_name ILIKE '%Air Mineral%' THEN target_hpp
    ELSE target_hpp * 0.70
  END as subtotal_hpp,
  1 as sort_order
FROM base

UNION ALL

SELECT 
  'Pelengkap' as component,
  CASE 
    WHEN lower(category) IN ('minuman', 'drink') THEN '🧊 Es Batu & Pemanis'
    WHEN lower(category) IN ('dessert') THEN '🍒 Topping & Saus Manis'
    WHEN lower(category) IN ('snack') THEN '🧂 Bumbu Tabur & Saus Cocol'
    ELSE '🧅 Bumbu Dapur & Sayuran (Garnish)'
  END as item,
  CASE 
    WHEN lower(category) IN ('minuman', 'drink') THEN 'Sesuai Takaran (1 Porsi)'
    ELSE 'Sesuai SOP Resep'
  END as qty,
  target_hpp * 0.15 as subtotal_hpp,
  2 as sort_order
FROM base
WHERE menu_name NOT ILIKE '%Air Mineral%'

UNION ALL

SELECT 
  'Kemasan' as component,
  CASE 
    WHEN lower(category) IN ('minuman', 'drink') THEN '🥤 Cup Plastik / Gelas'
    WHEN lower(category) IN ('dessert') THEN '🥣 Mangkok Kertas / Plastik'
    ELSE '📦 Kotak Takeaway / Piring'
  END as item,
  '1 Unit' as qty,
  target_hpp * 0.15 as subtotal_hpp,
  3 as sort_order
FROM base
WHERE menu_name NOT ILIKE '%Air Mineral%'

ORDER BY sort_order
```

{#if category_list.length > 0}
{@const selectedCatRaw = inputs.selected_category?.value ?? inputs.selected_category}
{@const isValidCategory = selectedCatRaw === 'Semua Kategori' || category_list.some(c => c.category === selectedCatRaw)}
{#if isValidCategory}
{#if menu_stats.length > 0}
<!-- BAB 1 -->
<div style="display: flex; flex-direction: column; gap: 24px; padding-bottom: 40px;">
<SectionCard 
  eyebrow="<span style='font-size: 12px;'>📊 Rapor Identitas & Finansial</span>" 
  title="Kesehatan Finansial Menu" 
  description="Ringkasan kesehatan finansial menu terpilih selama 30 hari terakhir."
>
  <div class="kpi-grid-top">
    <div class="kpi-card volume">
      <div class="kpi-label">📦 Volume Terjual</div>
      <div class="kpi-value">{Intl.NumberFormat('id-ID').format(menu_stats[0].total_qty || 0)}</div>
      <div class="kpi-prev">porsi dalam 30 hari</div>
    </div>
    <div class="kpi-card revenue">
      <div class="kpi-label">💰 Total Omzet</div>
      <div class="kpi-value">Rp {Intl.NumberFormat('id-ID').format(menu_stats[0].total_revenue || 0)}</div>
      <div class="kpi-prev">pendapatan kotor 30H</div>
    </div>
  </div>
  <div class="kpi-grid-bottom">
    <div class="kpi-card price">
      <div class="kpi-label">🏷️ Harga Jual</div>
      <div class="kpi-value">Rp {Intl.NumberFormat('id-ID').format(menu_stats[0].avg_price || 0)}</div>
      <div class="kpi-prev">rata-rata per porsi</div>
    </div>
    <div class="kpi-card cost">
      <div class="kpi-label">🧾 Estimasi HPP</div>
      <div class="kpi-value">Rp {Intl.NumberFormat('id-ID').format(menu_stats[0].est_hpp || 0)}</div>
      <div class="kpi-prev">modal per porsi (45%)</div>
    </div>
    <div class="kpi-card margin">
      <div class="kpi-label">✅ Margin Profit</div>
      <div class="kpi-value">Rp {Intl.NumberFormat('id-ID').format(menu_stats[0].est_margin || 0)}</div>
      <div class="kpi-prev">keuntungan per porsi (55%)</div>
    </div>
  </div>
  <div style="font-size: 0.75rem; color: var(--color-text-tertiary); margin-top: 14px; text-align: center; font-style: italic;">
    *Catatan: Nilai Estimasi HPP saat ini adalah asumsi rasio statis. Nilai ini akan menjadi otomatis dan dinamis ketika diintegrasikan dengan Modul Inventori.
  </div>
</SectionCard>

<!-- BAB 2 -->
<SectionCard 
  eyebrow="<span style='font-size: 12px;'>🔪 Anatomi Resep (BOM) & HPP Teoritis</span>" 
  title="Komposisi Bahan Baku" 
  description="Komposisi bahan baku ideal yang membentuk menu ini. (Data riil akan dihubungkan dengan modul Inventory)"
>
  <div style="overflow-x: auto; margin-bottom: 8px;">
    <table style="width:100%; border-collapse:collapse; font-size:0.88rem; text-align:left; border: 1px solid var(--color-border-tertiary); border-radius: 8px;">
      <thead>
        <tr style="background:var(--color-background-secondary); border-bottom:1.5px solid var(--color-border-tertiary);">
          <th style="padding:10px 14px; font-weight:700; color:var(--color-text-primary);">Kategori Komponen</th>
          <th style="padding:10px 14px; font-weight:700; color:var(--color-text-primary);">Detail Bahan (Mockup)</th>
          <th style="padding:10px 14px; font-weight:700; text-align:right; color:var(--color-text-primary);">Kebutuhan / Porsi</th>
          <th style="padding:10px 14px; font-weight:700; text-align:right; color:var(--color-text-primary);">Estimasi Harga Satuan</th>
          <th style="padding:10px 14px; font-weight:700; text-align:right; color:var(--color-text-primary);">Subtotal HPP</th>
        </tr>
      </thead>
      <tbody>
        {#each menu_bom as bom}
        <tr style="border-bottom:1px solid var(--color-border-tertiary);">
          <td style="padding:10px 14px; font-weight:normal; color:var(--color-text-secondary);">{bom.component}</td>
          <td style="padding:10px 14px; font-weight:600; color:var(--color-text-primary);">{bom.item}</td>
          <td style="padding:10px 14px; text-align:right; font-weight:700; color:var(--color-text-primary);">{bom.qty}</td>
          <td style="padding:10px 14px; text-align:right; font-family:monospace;">Rp {Intl.NumberFormat('id-ID').format(bom.subtotal_hpp)} / {bom.component === 'Kemasan' ? 'unit' : 'resep'}</td>
          <td style="padding:10px 14px; text-align:right; font-family:monospace; font-weight:700;">Rp {Intl.NumberFormat('id-ID').format(bom.subtotal_hpp)}</td>
        </tr>
        {/each}
      </tbody>
      <tfoot>
        <tr style="background:var(--color-background-secondary);">
          <td colspan="4" style="padding:12px 14px; text-align:right; font-weight:700; color:var(--color-text-primary);">Total Estimasi HPP per Porsi</td>
          <td style="padding:12px 14px; text-align:right; font-weight:800; font-family:monospace; color:var(--color-text-primary);">Rp {Intl.NumberFormat('id-ID').format(menu_stats[0].est_hpp || 0)}</td>
        </tr>
      </tfoot>
    </table>
  </div>
</SectionCard>

<!-- BAB 3 -->
<SectionCard 
  eyebrow="<span style='font-size: 12px;'>📈 Performa Pasar & Respons Pelanggan</span>" 
  title="Tren Historis" 
  description="Tren grafik penjualan harian dan perbandingan performa menu ini di setiap cabang selama 30 hari terakhir."
>
  <!-- Leaderboard Cabang -->
  <div style="margin-bottom: 32px;">
    <h3 style="margin-top: 0; margin-bottom: 16px; font-size: 1rem; font-weight: 700; color: var(--color-text-primary); text-transform: uppercase; letter-spacing: 0.05em;">🏆 Leaderboard Cabang</h3>
    <div style="overflow-x: auto;">
      <table style="width: 100%; border-collapse: collapse; font-size: 0.85rem;">
        <thead>
          <tr style="border-bottom: 1.5px solid var(--color-border-tertiary);">
            <th style="padding: 8px; text-align: left; color: var(--color-text-secondary);">Cabang</th>
            <th style="padding: 8px; text-align: right; color: var(--color-text-secondary);">Kontribusi</th>
            <th style="padding: 8px; text-align: center; color: var(--color-text-secondary);">Status</th>
          </tr>
        </thead>
        <tbody>
          {#each menu_branch_comparison as branch}
            <tr style="border-bottom: 1px solid var(--color-border-tertiary);">
              <td style="padding: 10px 8px; font-weight: 600; color: var(--color-text-primary);">{branch.branch_name}</td>
              <td style="padding: 10px 8px; text-align: right;">
                <div style="font-weight: 700; color: var(--color-text-primary);">{Intl.NumberFormat('id-ID', {minimumFractionDigits: 1, maximumFractionDigits: 1}).format(branch.contribution_pct)}%</div>
                <div style="font-size: 0.75rem; color: var(--color-text-tertiary);">{Intl.NumberFormat('id-ID').format(branch.total_qty)} porsi</div>
              </td>
              <td style="padding: 10px 8px; text-align: center;">
                <span style="display: inline-block; padding: 4px 8px; border-radius: 999px; font-size: 0.75rem; font-weight: 700; background: {branch.contribution_pct >= 30 ? 'rgba(16,185,129,0.1)' : branch.contribution_pct < 15 ? 'rgba(239,68,68,0.1)' : 'rgba(148,163,184,0.1)'}; color: {branch.contribution_pct >= 30 ? '#059669' : branch.contribution_pct < 15 ? '#dc2626' : '#64748b'};">
                  {branch.status_badge}
                </span>
              </td>
            </tr>
          {/each}
        </tbody>
      </table>
    </div>
    <div style="font-size: 0.7rem; color: var(--color-text-tertiary); margin-top: 12px; text-align: center; font-style: italic;">
      *Leader: &gt;30% | Tertinggal: &lt;15%
    </div>
  </div>

  <!-- Tren Chart (1 Line, Custom Tooltip) -->
  <div style="margin-bottom: 8px;">
    <h3 style="margin-top: 0; margin-bottom: 12px; font-size: 1rem; font-weight: 700; color: var(--color-text-primary); text-transform: uppercase; letter-spacing: 0.05em;">📈 Tren Penjualan Harian</h3>
    <AreaChart 
      data={menu_daily_trend} 
      x="date" 
      y="qty"
      yAxisTitle="Porsi Terjual"
      fillColor="#10b981"
      fillOpacity="0.15"
      lineColor="#059669"
      echartsOptions={{
        tooltip: {
          trigger: 'axis',
          formatter: function(params) {
            if (!params || !params.length) return '';
            let dataIndex = params[0].dataIndex;
            let row = menu_daily_trend[dataIndex];
            if (!row) return '';
            
            let dateStr = new Date(row.date).toLocaleDateString('id-ID', {day: 'numeric', month: 'short', year: 'numeric'});
            let qtyStr = Intl.NumberFormat('id-ID').format(row.qty);
            let revStr = Intl.NumberFormat('id-ID').format(row.revenue);
            
            return "<div style='font-weight:700;margin-bottom:8px;font-family:sans-serif;'>" + dateStr + "</div>" +
                   "<div style='font-family:sans-serif;'><span style='color:#10b981;font-weight:700;margin-right:6px;'>●</span><span style='color:#64748b;'>Volume:</span> <b style='color:#1e293b;'>" + qtyStr + " porsi</b></div>" +
                   "<div style='font-family:sans-serif;'><span style='color:#3b82f6;font-weight:700;margin-right:6px;'>●</span><span style='color:#64748b;'>Omzet:</span> <b style='color:#1e293b;'>Rp " + revStr + "</b></div>";
          }
        }
      }}
    />
  </div>
</SectionCard>

<!-- BAB 4 -->
<SectionCard 
  eyebrow="<span style='font-size: 12px;'>⚖️ Evaluasi & Keputusan Strategis</span>" 
  title="Rekomendasi Menu Engineering" 
  description="Kesimpulan eksekutif mengenai nasib menu ini berdasarkan perbandingan performa rata-rata (Volume vs Omzet)."
>
  <div class="detail-grid" style="grid-template-columns: 3fr 2fr; gap: 24px;">
    
    <!-- Bagian Kiri: Matrix & Action Plan -->
    <div style="display: flex; flex-direction: column; gap: 16px;">
      <div style="background: var(--color-background-secondary); border: 1.5px solid var(--color-border-tertiary); border-radius: 12px; padding: 20px;">
        <div style="font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.1em; color: var(--color-text-tertiary); font-weight: 700; margin-bottom: 8px;">Klasifikasi Menu (BCG Matrix)</div>
        <div style="font-size: 1.8rem; font-weight: 800; color: var(--color-text-primary); margin-bottom: 16px;">
          <Value data={menu_evaluation} column="matrix_class" />
        </div>
        
        <div class="kpi-grid-bottom" style="margin-bottom: 24px;">
          <div class="kpi-card volume">
            <div class="kpi-label">⏱️ Penjualan (30 Hari)</div>
            <div class="kpi-value" style="font-size: 1.4rem;">{Intl.NumberFormat('id-ID').format(menu_evaluation[0]?.qty_last_30 || 0)} <span style="font-size: 0.85rem; font-weight: 500; color: var(--color-text-secondary);">porsi</span></div>
            <div class="kpi-prev">Tren: <span style="font-weight: 600; color: {menu_evaluation[0]?.trend_status === 'naik' ? '#059669' : menu_evaluation[0]?.trend_status === 'turun' ? '#dc2626' : 'inherit'}">{menu_evaluation[0]?.trend_status === 'naik' ? '↗ Meroket' : menu_evaluation[0]?.trend_status === 'turun' ? '↘ Anjlok' : '➖ Stabil'}</span></div>
          </div>
          <div class="kpi-card revenue">
            <div class="kpi-label">📊 Penjualan Kuartal (90 Hari)</div>
            <div class="kpi-value" style="font-size: 1.4rem;">{Intl.NumberFormat('id-ID').format(menu_evaluation[0]?.qty || 0)} <span style="font-size: 0.85rem; font-weight: 500; color: var(--color-text-secondary);">porsi</span></div>
            <div class="kpi-prev">Rata-rata restoran: {Intl.NumberFormat('id-ID', {maximumFractionDigits: 0}).format(menu_evaluation[0]?.avg_qty || 0)}</div>
          </div>
          <div class="kpi-card margin">
            <div class="kpi-label">📦 Kompleksitas Bahan Baku</div>
            <div class="kpi-value" style="font-size: 1.1rem; color: {menu_evaluation[0]?.inventory_complexity?.includes('Tinggi') ? '#dc2626' : '#059669'};">
              <Value data={menu_evaluation} column="inventory_complexity" />
            </div>
            <div class="kpi-prev">Risiko <em>dead-stock</em> inventori</div>
          </div>
        </div>

        {#if true}
          {@const actionColor = menu_evaluation.length > 0 ? menu_evaluation[0]?.action_color : 'amber'}
          {@const iconAlert = actionColor === 'red' ? '🚨' : actionColor === 'green' ? '✨' : actionColor === 'blue' ? '💡' : '⚠️'}
          {@const titleText = actionColor === 'red' ? 'Tindakan Kritis Dibutuhkan!' : actionColor === 'green' ? 'Strategi Unggulan' : actionColor === 'blue' ? 'Insight Operasional & Rekomendasi' : 'Panduan Keputusan Strategis'}
          
          <div class="decision-box {actionColor}">
            <div class="decision-icon">
              {iconAlert}
            </div>
            <div class="decision-content">
              <div class="decision-title">
                {titleText}
                <div class="ai-badge">✨ AI Generated</div>
              </div>
              <p class="decision-text">
                {#if menu_evaluation.length > 0}
                  {@html menu_evaluation[0].action_plan}
                {/if}
              </p>
              <div class="decision-footer">
                <em>*Disclaimer: Panduan ini dihitung otomatis menggunakan kombinasi performa kuartal (90 hari) dan momentum (30 hari). Eksekusi final wajib mengandalkan insting bisnis Owner.</em>
              </div>
            </div>
          </div>
        {/if}
      </div>
    </div>

    <!-- Bagian Kanan: Cross-Selling (Penyelamat) -->
    <div class="chart-panel" style="margin: 0; padding: 24px; border-radius: 16px; border: 1.5px solid var(--color-border-tertiary); background: #ffffff; box-shadow: 0 10px 25px -5px rgba(0,0,0,0.02);">
      <div style="font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.1em; color: var(--color-text-tertiary); font-weight: 800; margin-bottom: 16px; display: flex; align-items: center; gap: 8px;">
        🛒 Analisis Keranjang (Cross-Selling)
      </div>
      <p style="font-size: 0.85rem; color: var(--color-text-secondary); margin-top: -8px; margin-bottom: 20px; font-weight: 500;">Sering dipesan bersamaan dengan:</p>
      
      <div style="display: flex; flex-direction: column; gap: 14px;">
        {#each menu_cross_sell as cross}
          {@const mainCategory = menu_bom.length > 0 ? (menu_bom[0].category || "").toLowerCase() : ""}
          {@const mainNameLower = menu_bom.length > 0 ? (menu_bom[0].menu_name || "").toLowerCase() : ""}
          {@const isDrink = mainCategory.includes("minuman") || mainCategory.includes("drink") || mainNameLower.includes("es ") || mainNameLower.includes("teh") || mainNameLower.includes("kopi") || mainNameLower.includes("jus") || mainNameLower.includes("mineral")}
          {@const isDessert = mainCategory.includes("dessert") || mainCategory.includes("pencuci mulut")}
          {@const isBundleAnchor = !isDrink && !isDessert}
          {@const isGolden = cross.match_pct >= 35 && cross.main_qty_90 >= 90 && isBundleAnchor}
          {@const heatColor = cross.match_pct >= 35 ? "#ef4444" : cross.match_pct >= 15 ? "#f59e0b" : "#3b82f6"}
          {@const heatGradient = cross.match_pct >= 35 ? "linear-gradient(90deg, #f87171, #ef4444)" : cross.match_pct >= 15 ? "linear-gradient(90deg, #fbbf24, #f59e0b)" : "linear-gradient(90deg, #60a5fa, #3b82f6)"}
          {@const catLower = (cross.category || "").toLowerCase()}
          {@const menuNameLower = (cross.paired_menu || "").toLowerCase()}
          {@const smartIcon = (catLower.includes("minuman") || menuNameLower.includes("es ") || menuNameLower.includes("teh") || menuNameLower.includes("kopi") || menuNameLower.includes("jus") || menuNameLower.includes("mineral")) ? "🥤" : (catLower.includes("dessert") || menuNameLower.includes("pisang") || menuNameLower.includes("keju") || menuNameLower.includes("coklat")) ? "🍰" : "🍲"}
          
          <div class="cross-sell-card {isGolden ? 'golden' : ''}">
            {#if isGolden}
              <div class="golden-badge">🔥 Golden Pair (Promo Bundle!)</div>
            {/if}
            <div class="cross-sell-header">
              <span class="cross-sell-title">{smartIcon} {cross.paired_menu}</span>
              <span class="cross-sell-pct" style="color: {heatColor}">{Number(cross.match_pct).toFixed(1)}%</span>
            </div>
            <div class="cross-sell-bar-bg">
              <div class="cross-sell-bar-fill" style="width: {cross.match_pct}%; background: {heatGradient};"></div>
            </div>
          </div>
        {/each}
      </div>
      <div style="font-size: 0.75rem; color: var(--color-text-tertiary); margin-top: 20px; font-style: italic; background: rgba(0,0,0,0.02); padding: 12px; border-radius: 8px; border-left: 3px solid #cbd5e1;">
        <strong>*Catatan:</strong> Jangan menghapus menu utama jika produk pasangannya adalah penyumbang margin tinggi (Misal: 🥤 Minuman).
      </div>
    </div>

  </div>
</SectionCard>

</div>
{:else}
  <div class="empty-state" style="border-color: #e2e8f0; background: linear-gradient(135deg, #f8fafc, #f1f5f9);">
    <div class="empty-state-icon">🔍</div>
    <h3>Data Tidak Ditemukan</h3>
    <p>Tidak ada data penjualan untuk menu ini dalam 30 hari terakhir. Silakan pilih menu lain dari <em>dropdown</em> di atas.</p>
  </div>
{/if}
{/if}
{/if}

