---
title: Deepdive
---

<script>
  import SectionCard from '$lib/SectionCard.svelte';
  import PremiumTable from '$lib/PremiumTable.svelte';
</script>

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
  background: var(--color-background-secondary);
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
  background: var(--color-background-secondary);
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
.hero-side-card { padding: 13px 14px; border-radius: 14px; border: 1px solid var(--color-border-tertiary); background: var(--color-background-secondary); }
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
.menu-status-metric { flex: 1; padding: 14px 15px; border-radius: 14px; border: 1px solid var(--color-border-tertiary); background: var(--color-background-secondary); }
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
.snapshot-grid { display: grid; grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 16px; margin-bottom: 32px; }
.snapshot-card {
  display: flex; flex-direction: column; align-items: center; text-align: center;
  padding: 24px 16px; border-radius: 16px;
  border: 1px solid var(--color-border-tertiary);
  background: var(--color-background-secondary);
  transition: all 0.2s ease-in-out;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -2px rgba(0, 0, 0, 0.05);
}
.snapshot-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.08), 0 4px 6px -4px rgba(0, 0, 0, 0.05);
}
.snapshot-card.star      { border-color: rgba(22,163,74,0.22);  background: linear-gradient(145deg, rgba(22,163,74,0.07), rgba(16,185,129,0.03)); }
.snapshot-card.mystery   { border-color: rgba(245,158,11,0.24); background: linear-gradient(145deg, rgba(245,158,11,0.08), rgba(251,191,36,0.03)); }
.snapshot-card.workhorse { border-color: rgba(59,130,246,0.22); background: linear-gradient(145deg, rgba(59,130,246,0.07), rgba(37,99,235,0.03)); }
.snapshot-card.weak      { border-color: rgba(239,68,68,0.22);  background: linear-gradient(145deg, rgba(239,68,68,0.07), rgba(220,38,38,0.03)); }
.snapshot-icon  { font-size: 2rem; margin-bottom: 8px; }
.snapshot-value { font-size: 2.5rem; font-weight: 900; color: var(--color-text-primary); line-height: 1; margin-bottom: 8px; letter-spacing: -0.025em; }
.snapshot-label { font-size: 0.85rem; font-weight: 800; letter-spacing: 0.05em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 12px; }
.snapshot-copy  { font-size: 0.8rem; line-height: 1.55; color: var(--color-text-secondary); }
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
.action-detail { padding: 9px 10px; border-radius: 10px; border: 1px solid rgba(128,128,128,0.12); background: var(--color-background-secondary); }
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
SELECT * FROM restaurant.mart_menu_dates
```

```sql menu_health_overview
SELECT * FROM restaurant.mart_menu_health_overview
```




```sql menu_engineering_y
SELECT * FROM restaurant.mart_menu_engineering_y
```

```sql menu_engineering_7d
SELECT * FROM restaurant.mart_menu_engineering_7d
```

```sql menu_engineering_30d
SELECT * FROM restaurant.mart_menu_engineering_30d
```

```sql branch_engineering_data
SELECT 
  period,
  CASE WHEN branch_name = 'Semua Cabang' THEN 'All Branches' ELSE branch_name END as branch_name,
  menu_name,
  CASE category
    WHEN 'Menu Utama' THEN 'Main'
    WHEN 'Minuman' THEN 'Drink'
    WHEN 'Camilan' THEN 'Snack'
    WHEN 'Pendamping' THEN 'Side'
    ELSE category
  END as category,
  price_tier,
  total_qty,
  total_revenue,
  avg_price_realisasi,
  menu_name || ' · ' || 
    CASE category
      WHEN 'Menu Utama' THEN 'Main'
      WHEN 'Minuman' THEN 'Drink'
      WHEN 'Camilan' THEN 'Snack'
      WHEN 'Pendamping' THEN 'Side'
      ELSE category
    END || ' · ' || 
    CASE WHEN branch_name = 'Semua Cabang' THEN 'All Branches' ELSE branch_name END as tooltip_label,
  CASE klasifikasi
    WHEN 'Primadona' THEN 'Star'
    WHEN 'Misteri' THEN 'Puzzle'
    WHEN 'Pekerja Keras' THEN 'Workhorse'
    WHEN 'Lemah' THEN 'Underperformer'
    ELSE klasifikasi
  END as classification,
  CASE aksi_disarankan
    WHEN 'Jaga stok & kualitas' THEN 'Maintain stock & quality'
    WHEN 'Uji bundling / harga' THEN 'Test bundling / pricing'
    WHEN 'Dorong visibilitas' THEN 'Push visibility'
    ELSE 'Validate trend first'
  END as aksi_disarankan
FROM restaurant.menu_b_branch_engineering
```

```sql menu_branch_list
SELECT * FROM restaurant.mart_menu_branch_list
```

```sql menu_branch_list_all
SELECT branch_name FROM (
  SELECT 0 as sort_order, 'All Branches' as branch_name
  UNION ALL
  SELECT 1 as sort_order, branch_name FROM restaurant.mart_menu_branch_list
) ORDER BY sort_order, branch_name
```

```sql menu_branch_detail
SELECT * FROM restaurant.mart_menu_branch_detail
```

```sql menu_branch_summary
SELECT * FROM restaurant.mart_menu_branch_summary
```

```sql menu_branch_mix
SELECT * FROM restaurant.mart_menu_branch_mix
```

```sql movers_7d
SELECT * FROM restaurant.mart_movers_7d
```

```sql movers_30d
SELECT * FROM restaurant.mart_movers_30d
```

```sql structural_decline_90d
SELECT * FROM restaurant.mart_structural_decline_90d
```

<MenuTabs activeTab="deepdive" />

<SectionCard 
  eyebrow="🏪 LOCATION FILTER" 
  title="Portfolio Analysis by Branch" 
  description="Select 'All Branches' for consolidated business aggregates, or select a specific location to isolate branch-level menu performance."
>
    <ButtonGroup 
      name="focus_branch" 
      data={menu_branch_list_all} 
      value="branch_name" 
      label="branch_name" 
      defaultValue="All Branches"
    />
</SectionCard>

{#if menu_branch_list_all.length > 0}
{@const selectedBranchRaw = inputs.focus_branch?.value ?? inputs.focus_branch}
{@const isValidBranch = menu_branch_list_all.some(b => b.branch_name === selectedBranchRaw)}

{#if isValidBranch}

{#if menu_health_overview.length > 0 && menu_dates.length > 0}

{@const activePeriod = '30d'}
{@const activeTopVolume = activePeriod === 'y' ? menu_health_overview[0].top_volume_menu_y  : activePeriod === '30d' ? menu_health_overview[0].top_volume_menu_30d  : menu_health_overview[0].top_volume_menu_7d}
{@const selectedBranchNormalized = decodeURIComponent(selectedBranchRaw).replace(/\+/g, ' ')}
{@const selectedBranch = menu_branch_list_all.find(b => b.branch_name === selectedBranchRaw || b.branch_name === selectedBranchNormalized)?.branch_name ?? 'All Branches'}
{@const activeEngineering = branch_engineering_data.filter((m) => m.period === activePeriod && m.branch_name === selectedBranch)}
{@const activeMovers    = activePeriod === '30d' ? movers_30d : movers_7d}
{@const primadonaMenus  = activeEngineering.filter((m) => m.classification === 'Star')}
{@const mysteryMenus    = activeEngineering.filter((m) => m.classification === 'Puzzle')}
{@const workhorseMenus  = activeEngineering.filter((m) => m.classification === 'Workhorse')}
{@const weakMenus       = activeEngineering.filter((m) => m.classification === 'Underperformer')}
{@const pushMenu        = mysteryMenus[0] ?? workhorseMenus[0]}
{@const decliningMenu   = activeMovers.find((m) => m.movement_status === 'Turun')}
{@const weakMenu        = weakMenus[0]}
{@const structuralMenu  = structural_decline_90d.find((m) => m.menu_name != null)}

{@const mysteryMenusWithMock = mysteryMenus.map(m => ({ ...m, harga_jual: m.total_revenue / m.total_qty, hpp: (m.total_revenue / m.total_qty) * (1 - (0.55 + ((m.menu_name.length % 5) * 0.03))), margin: (m.total_revenue / m.total_qty) - ((m.total_revenue / m.total_qty) * (1 - (0.55 + ((m.menu_name.length % 5) * 0.03)))) }))}
{@const workhorseMenusWithMock = workhorseMenus.map(m => ({ ...m, harga_jual: m.total_revenue / m.total_qty, hpp: (m.total_revenue / m.total_qty) * (1 - (0.15 + ((m.menu_name.length % 5) * 0.02))), margin: (m.total_revenue / m.total_qty) - ((m.total_revenue / m.total_qty) * (1 - (0.15 + ((m.menu_name.length % 5) * 0.02)))) }))}



<div class="strategic-stack" style="margin-top: 32px;">
  <div class="strategic-header">
    <div class="strategic-eyebrow">🗂️ MENU MATRIX CLASSIFICATION · {selectedBranch}</div>
    <h2 class="strategic-title">Portfolio Distribution &amp; Quadrant Mapping</h2>
    <p class="strategic-copy">Evaluates item distribution across portfolio quadrants to analyze relative volume velocity and margin contribution variance for the selected location.</p>
  </div>

  <div class="acc-body" style="padding-top: 8px; border: none; background: transparent; padding-left: 0; padding-right: 0;">

      <details class="guide-acc" style="margin-bottom:24px;">
        <summary>📖 Menu Matrix Classification Methodology</summary>
        <div class="guide-body">
          <p style="margin-top: 4px; margin-bottom: 16px; font-weight: 500; color: var(--color-text-secondary);">
            Categorizes menu items relative to active period sales volume and revenue medians.
          </p>
          <div class="guide-grid" style="grid-template-columns: repeat(2, minmax(0, 1fr));">
            <div class="guide-card blue">
              <div class="guide-card-icon">⭐</div>
              <div class="guide-card-content">
                <div class="guide-card-label">High Volume &amp; High Revenue</div>
                <h4 class="guide-card-title">Star</h4>
                <p class="guide-card-desc">Sales volume and gross revenue both equal to or exceeding period medians.</p>
              </div>
            </div>
            <div class="guide-card orange">
              <div class="guide-card-icon">🧩</div>
              <div class="guide-card-content">
                <div class="guide-card-label">Low Volume &amp; High Revenue</div>
                <h4 class="guide-card-title">Puzzle</h4>
                <p class="guide-card-desc">Gross revenue at or above period median, with sales volume falling below period median.</p>
              </div>
            </div>
            <div class="guide-card teal">
              <div class="guide-card-icon">💪</div>
              <div class="guide-card-content">
                <div class="guide-card-label">High Volume &amp; Low Revenue</div>
                <h4 class="guide-card-title">Workhorse</h4>
                <p class="guide-card-desc">Sales volume at or above period median, with gross revenue falling below period median.</p>
              </div>
            </div>
            <div class="guide-card" style="background: rgba(220, 38, 38, 0.05); border: 1px solid rgba(220, 38, 38, 0.1);">
              <div class="guide-card-icon">🔻</div>
              <div class="guide-card-content">
                <div class="guide-card-label" style="color: #dc2626;">Low Volume &amp; Low Revenue</div>
                <h4 class="guide-card-title">Underperformer</h4>
                <p class="guide-card-desc">Sales volume and gross revenue both falling below period medians.</p>
              </div>
            </div>
          </div>
        </div>
      </details>

      <div class="snapshot-grid">
        <div class="snapshot-card star">
          <div class="snapshot-icon">⭐</div>
          <div class="snapshot-value">{primadonaMenus.length}</div>
          <div class="snapshot-label">Star</div>
          <div class="snapshot-copy">High volume and high revenue contribution.</div>
        </div>
        <div class="snapshot-card mystery">
          <div class="snapshot-icon">🧩</div>
          <div class="snapshot-value">{mysteryMenus.length}</div>
          <div class="snapshot-label">Puzzle</div>
          <div class="snapshot-copy">High revenue contribution with below-median sales volume.</div>
        </div>
        <div class="snapshot-card workhorse">
          <div class="snapshot-icon">💪</div>
          <div class="snapshot-value">{workhorseMenus.length}</div>
          <div class="snapshot-label">Workhorse</div>
          <div class="snapshot-copy">High sales volume with below-median revenue contribution.</div>
        </div>
        <div class="snapshot-card weak">
          <div class="snapshot-icon">🔻</div>
          <div class="snapshot-value">{weakMenus.length}</div>
          <div class="snapshot-label">Underperformer</div>
          <div class="snapshot-copy">Below-median sales volume and revenue contribution.</div>
        </div>
      </div>

      <ScatterPlot
        data={activeEngineering}
        x="total_qty"
        y="total_revenue"
        series="classification"
        tooltipTitle="tooltip_label"
        xAxisTitle="Volume Sold (Qty)"
        yAxisTitle="Total Revenue (Rp)"
        title="Menu Map — Volume vs Revenue"
        yFmt="#,##0"
      />

      <div class="chart-insight" style="margin-bottom: 24px;">
        📌 <strong>Chart Interpretation:</strong> Horizontal axis represents sales volume; vertical axis represents total revenue. Tooltips provide item-level menu name, category, matrix classification, sales volume, and gross revenue metrics.
      </div>

      <div style="margin-top: 16px;">
        <DataTable data={activeEngineering} rows="10">
          <Column id="menu_name" title="Menu Name" />
          <Column id="category" title="Category" />
          <Column id="classification" title="Classification" />
          <Column id="total_qty" title="Order Volume" align="right" fmt="#,##0" />
          <Column id="total_revenue" title="Total Revenue" align="right" fmt="#,##0" />
          <Column id="aksi_disarankan" title="Classification Note" />
        </DataTable>
      </div>

    </div>
</div>

<!-- ACTION CENTER: PRIORITY MENU -->
<div class="strategic-stack" style="margin-top: 48px; margin-bottom: 32px;">
  <div class="strategic-header">
    <div class="strategic-eyebrow">🎯 PROMOTIONAL BUNDLING SIMULATION</div>
    <h2 class="strategic-title">Cross-Category Item Bundling Analysis</h2>
    <p class="strategic-copy">Simulates item pairings across menu matrix quadrants to evaluate potential revenue and order volume impact.</p>
  </div>

  <details class="acc-strategic">
    <summary>🎯 Cross-Item Promotional Analysis &amp; Bundling Framework</summary>
    <div class="acc-body">
      <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 32px;">
        <!-- Card Methodology -->
        <div class="interactive-card" style="display: flex; align-items: flex-start; gap: 16px; padding: 20px 24px; border-radius: 16px; background: linear-gradient(135deg, rgba(16, 185, 129, 0.08), rgba(59, 130, 246, 0.05)); border: 1px solid rgba(16, 185, 129, 0.2);">
          <div style="font-size: 2.2rem; line-height: 1; flex-shrink: 0; margin-top: 2px;">🤝</div>
          <div>
            <div style="font-size: 1rem; font-weight: 800; color: var(--color-text-primary); margin-bottom: 6px;">Menu Engineering Cross-Category Dynamics</div>
            <div style="font-size: 0.9rem; line-height: 1.6; color: var(--color-text-secondary);">
              Evaluates structural opportunities for high-volume Workhorse items (high order velocity) paired with high-revenue Puzzle items (lower order velocity).
            </div>
          </div>
        </div>
        
        <!-- Card Contoh (Option 2 Table) -->
        <div class="interactive-card" style="padding: 20px 24px; border-radius: 16px; background: linear-gradient(135deg, rgba(139, 92, 246, 0.05), rgba(217, 70, 239, 0.05)); border: 1px solid rgba(139, 92, 246, 0.2);">
          <div style="font-size: 1rem; font-weight: 800; color: var(--color-text-primary); margin-bottom: 12px; display: flex; align-items: center; gap: 8px;">
            <span style="font-size: 1.5rem;">💡</span> Margin Impact Simulation
          </div>
          <div style="border: 1px solid var(--color-border-tertiary); border-radius: 8px; overflow: hidden; font-size: 0.85rem; background: var(--color-background-primary, white);">
            <div style="display: grid; grid-template-columns: 1fr auto; background: var(--color-background-secondary); padding: 8px 12px; font-weight: 700; border-bottom: 1px solid var(--color-border-tertiary);">
              <div>Item Pairing Scenario</div>
              <div>Net Margin Contribution</div>
            </div>
            <div style="display: grid; grid-template-columns: 1fr auto; padding: 8px 12px; border-bottom: 1px solid var(--color-border-tertiary);">
              <div><span style="color: var(--color-text-tertiary);">Standalone:</span> Single Item Baseline</div>
              <div style="font-weight: 600; color: var(--color-text-secondary);">+Rp 3,000</div>
            </div>
            <div style="display: grid; grid-template-columns: 1fr auto; padding: 8px 12px; background: rgba(16,185,129,0.05);">
              <div><span style="color: #059669; font-weight: 600;">Bundled:</span> Dual Item Pairing (Rp 5,000 Discount)</div>
              <div style="color: #059669; font-weight: 800;">+Rp 8,000</div>
            </div>
          </div>
        </div>
      </div>
      <details class="guide-acc" style="margin-bottom: 32px;">
        <summary>🛠️ Promotional Bundling Execution Methodology</summary>
        <div class="guide-body" style="padding: 24px; background: var(--color-background-secondary); border-radius: 0 0 8px 8px;">
          
          <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 24px; margin-bottom: 24px;">
            <!-- High-Margin Puzzle Item Table -->
            <div style="border: 1px solid var(--color-border-tertiary); border-radius: 12px; overflow: hidden; background: var(--color-background-primary, white); box-shadow: 0 2px 4px rgba(0,0,0,0.02);">
              <div style="background: rgba(245,158,11,0.1); padding: 12px 16px; font-weight: 700; border-bottom: 1px solid var(--color-border-tertiary);">💎 High-Margin Puzzle Items</div>
              <table style="width: 100%; border-collapse: collapse; text-align: left; font-size: 0.85rem;">
                <thead>
                  <tr style="border-bottom: 1px solid var(--color-border-tertiary); color: var(--color-text-secondary);">
                    <th style="padding: 10px 16px;">Menu Item</th>
                    <th style="padding: 10px 16px; text-align: right;">Price (Rp)</th>
                    <th style="padding: 10px 16px; text-align: right;">Margin Contribution (Rp)</th>
                  </tr>
                </thead>
                <tbody>
                  <tr style="border-bottom: 1px solid #f1f5f9;">
                    <td style="padding: 10px 16px;">Pudding</td><td style="padding: 10px 16px; text-align: right;">12,000</td><td style="padding: 10px 16px; text-align: right; color: #16a34a;">7,500</td>
                  </tr>
                  <tr style="background: rgba(245, 158, 11, 0.15); border-left: 3px solid #f59e0b;">
                    <td style="padding: 10px 16px; font-weight: 700;">Milkshake</td><td style="padding: 10px 16px; text-align: right; font-weight: 700;">15,000</td><td style="padding: 10px 16px; text-align: right; color: #16a34a; font-weight: 700;">10,000</td>
                  </tr>
                  <tr>
                    <td style="padding: 10px 16px;">Juice</td><td style="padding: 10px 16px; text-align: right;">20,000</td><td style="padding: 10px 16px; text-align: right; color: #16a34a;">12,000</td>
                  </tr>
                </tbody>
              </table>
            </div>

            <!-- High-Volume Workhorse Item Table -->
            <div style="border: 1px solid var(--color-border-tertiary); border-radius: 12px; overflow: hidden; background: var(--color-background-primary, white); box-shadow: 0 2px 4px rgba(0,0,0,0.02);">
              <div style="background: rgba(59,130,246,0.1); padding: 12px 16px; font-weight: 700; border-bottom: 1px solid var(--color-border-tertiary);">🐴 High-Volume Workhorse Items</div>
              <table style="width: 100%; border-collapse: collapse; text-align: left; font-size: 0.85rem;">
                <thead>
                  <tr style="border-bottom: 1px solid var(--color-border-tertiary); color: var(--color-text-secondary);">
                    <th style="padding: 10px 16px;">Menu Item</th>
                    <th style="padding: 10px 16px; text-align: right;">Price (Rp)</th>
                    <th style="padding: 10px 16px; text-align: right;">Margin Contribution (Rp)</th>
                  </tr>
                </thead>
                <tbody>
                  <tr style="border-bottom: 1px solid #f1f5f9;">
                    <td style="padding: 10px 16px;">Pizza</td><td style="padding: 10px 16px; text-align: right;">22,000</td><td style="padding: 10px 16px; text-align: right; color: #d97706;">2,500</td>
                  </tr>
                  <tr style="background: rgba(59, 130, 246, 0.15); border-left: 3px solid #3b82f6;">
                    <td style="padding: 10px 16px; font-weight: 700;">Hamburger</td><td style="padding: 10px 16px; text-align: right; font-weight: 700;">25,000</td><td style="padding: 10px 16px; text-align: right; color: #d97706; font-weight: 700;">3,000</td>
                  </tr>
                  <tr>
                    <td style="padding: 10px 16px;">Hotdog</td><td style="padding: 10px 16px; text-align: right;">20,000</td><td style="padding: 10px 16px; text-align: right; color: #d97706;">2,000</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>

          <!-- Step by step -->
          <div style="display: flex; flex-direction: column; gap: 12px;">
            <div style="padding: 12px 16px; background: rgba(0,0,0,0.03); border-radius: 8px; font-size: 0.9rem; line-height: 1.6; color: var(--color-text-secondary);">
              <strong style="color: var(--color-text-primary);">1. Identify High-Volume Anchor Item (Workhorse Table):</strong> Select a primary high-velocity item from the Workhorse category (e.g., <strong style="color:#2563eb;">Hamburger</strong>).
            </div>
            <div style="padding: 12px 16px; background: rgba(0,0,0,0.03); border-radius: 8px; font-size: 0.9rem; line-height: 1.6; color: var(--color-text-secondary);">
              <strong style="color: var(--color-text-primary);">2. Pair High-Margin Secondary Item (Puzzle Table):</strong> Select a high-margin item from the Puzzle category to complement the anchor item (e.g., <strong style="color:#d97706;">Milkshake</strong>).
            </div>
            <div style="padding: 12px 16px; background: rgba(0,0,0,0.03); border-radius: 8px; font-size: 0.9rem; line-height: 1.6; color: var(--color-text-secondary);">
              <strong style="color: var(--color-text-primary);">3. Calculate Total Combined Margin Threshold:</strong> Sum the individual item margins (Rp 3,000 + Rp 10,000 = <strong style="color:#16a34a;">Rp 13,000</strong>). This value represents the maximum theoretical discount ceiling before unit contribution loss.
            </div>
            <div style="padding: 12px 16px; background: rgba(0,0,0,0.03); border-radius: 8px; font-size: 0.9rem; line-height: 1.6; color: var(--color-text-secondary);">
              <strong style="color: var(--color-text-primary);">4. Simulate Promotional Pricing Structure:</strong> Combine standalone prices (Rp 40,000 total) and apply a <strong>Rp 5,000</strong> promo discount (promotional price becomes Rp 35,000). Net contribution margin stabilizes at <strong>Rp 8,000</strong> per unit transaction.
            </div>
            <div style="padding: 12px 16px; background: rgba(16, 185, 129, 0.1); border-left: 3px solid #10b981; border-radius: 8px; font-size: 0.9rem; line-height: 1.6; color: var(--color-text-secondary);">
              <strong style="color: var(--color-text-primary);">5. POS Configuration &amp; Mapping:</strong> Configure the promo item pairing within the POS database to track order velocity and aggregate margin realization.
            </div>
          </div>

        </div>
      </details>

      <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(400px, 1fr)); gap: 24px; align-items: start;">
        
        <!-- Column 1: High-Margin Puzzle Items -->
        <div style="padding: 24px; border-radius: 16px; border: 1px solid rgba(245,158,11,0.2); background: linear-gradient(145deg, rgba(245,158,11,0.03), rgba(251,191,36,0.01));">
          <div class="section-head tight" style="margin-bottom: 16px;">
            <div>
              <div class="section-eyebrow" style="color: #d97706;">🧩 High-Margin Puzzle Items</div>
              <h3 class="section-title" style="font-size: 1.1rem;">High Margin Contribution, Lower Order Volume</h3>
              <p class="section-copy" style="font-size: 0.85rem;">Items exhibiting gross revenue or margin contribution above median with sales volume below median.</p>
            </div>
          </div>
          <div>
            {#if mysteryMenusWithMock.length > 0}
              <PremiumTable 
                data={mysteryMenusWithMock} 
                pageSize={5} 
                columns={[
                  { title: "Menu Item", key: "menu_name", align: "left", bold: true },
                  { title: "Order Volume", key: "total_qty", align: "right", type: "currency_raw" },
                  { title: "Price (Rp)", key: "harga_jual", align: "right", type: "currency_raw" },
                  { title: "COGS (Rp)", key: "hpp", align: "right", type: "currency_raw" },
                  { title: "Margin Contribution (Rp)", key: "margin", align: "right", type: "currency_raw", colorRules: "growth" }
                ]} 
              />
              <div class="chart-insight" style="margin-top: 16px; font-size: 0.8rem;">
                📌 <strong>Financial Structure:</strong> High unit contribution margin provides substantial clearance for promotional discount structures without breaching unit profitability.
              </div>
            {:else}
              <div class="signal-card safe" style="margin-top:0;">
                <div class="signal-label">ℹ️ Status</div>
                <div class="signal-title">No Puzzle menu items recorded for the selected period.</div>
              </div>
            {/if}
          </div>
        </div>

        <!-- Column 2: High-Volume Workhorse Items -->
        <div style="padding: 24px; border-radius: 16px; border: 1px solid rgba(59,130,246,0.2); background: linear-gradient(145deg, rgba(59,130,246,0.03), rgba(37,99,235,0.01));">
          <div class="section-head tight" style="margin-bottom: 16px;">
            <div>
              <div class="section-eyebrow" style="color: #2563eb;">🐴 High-Volume Workhorse Items</div>
              <h3 class="section-title" style="font-size: 1.1rem;">High Order Volume, Lower Margin Contribution</h3>
              <p class="section-copy" style="font-size: 0.85rem;">Items exhibiting sales volume at or above median with gross revenue or margin contribution below median.</p>
            </div>
          </div>
          <div>
            {#if workhorseMenusWithMock.length > 0}
              <PremiumTable 
                data={workhorseMenusWithMock} 
                pageSize={5} 
                columns={[
                  { title: "Menu Item", key: "menu_name", align: "left", bold: true },
                  { title: "Order Volume", key: "total_qty", align: "right", type: "currency_raw" },
                  { title: "Price (Rp)", key: "harga_jual", align: "right", type: "currency_raw" },
                  { title: "COGS (Rp)", key: "hpp", align: "right", type: "currency_raw" },
                  { title: "Margin Contribution (Rp)", key: "margin", align: "right", type: "currency_raw" }
                ]} 
              />
              <div class="chart-insight" style="margin-top: 16px; font-size: 0.8rem;">
                📌 <strong>Financial Structure:</strong> High transaction frequency makes these items suitable anchor candidates for volume velocity analytics and cross-category item pairing.
              </div>
            {:else}
              <div class="signal-card safe" style="margin-top:0;">
                <div class="signal-label">ℹ️ Status</div>
                <div class="signal-title">No Workhorse menu items recorded for the selected period.</div>
              </div>
            {/if}
          </div>
        </div>

      </div>

      <details class="guide-acc" style="margin-top: 24px;">
        <summary>💡 Puzzle &amp; Workhorse Calculation Methodology</summary>
        <div class="guide-body" style="padding: 20px; font-size: 0.9em; line-height: 1.6; color: var(--color-text-secondary); background: var(--color-background-secondary);">
          <p style="margin-top: 0; margin-bottom: 16px;">Calculated using the <strong>Menu Engineering Framework (Kasavana &amp; Smith Matrix)</strong>. The system automatically plots each menu item across two axes by comparing individual item metrics against overall menu portfolio <strong>Median</strong> baselines:</p>
          
          <div class="guide-grid" style="grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 12px; margin-bottom: 16px;">
            <div class="guide-card teal">
              <div class="guide-card-icon">🧩</div>
              <div class="guide-card-content">
                <div class="guide-card-label">Volume &lt; Median | Margin &gt; Median</div>
                <h4 class="guide-card-title">Puzzle</h4>
                <p class="guide-card-desc">Items exhibiting above-median unit contribution margin with below-median order volume velocity.</p>
              </div>
            </div>
            
            <div class="guide-card orange">
              <div class="guide-card-icon">🐴</div>
              <div class="guide-card-content">
                <div class="guide-card-label">Volume &gt; Median | Margin &lt; Median</div>
                <h4 class="guide-card-title">Workhorse</h4>
                <p class="guide-card-desc">High-velocity anchor items exhibiting above-median order volume with below-median unit contribution margin.</p>
              </div>
            </div>
          </div>
          
          <div class="interactive-card" style="display: flex; align-items: flex-start; gap: 16px; background: linear-gradient(135deg, rgba(239, 68, 68, 0.05), rgba(245, 158, 11, 0.05)); border: 1px solid rgba(239, 68, 68, 0.2); border-left: 4px solid rgba(239, 68, 68, 0.5); padding: 20px 24px; border-radius: 12px;">
            <div style="font-size: 2.2rem; line-height: 1; flex-shrink: 0; margin-top: 2px;">⚠️</div>
            <div>
              <div style="font-size: 1rem; font-weight: 800; color: #b91c1c; margin-bottom: 6px;">Statistical Boundary Consideration (Threshold Proximity)</div>
              <div style="font-size: 0.9rem; line-height: 1.6; color: var(--color-text-secondary);">
                Due to absolute mathematical median thresholding, items positioned near baseline boundaries may shift matrix quadrants based on minor unit volume fluctuations. Review trailing multi-period trend lines to distinguish structural category shifts from minor volume variance.
              </div>
            </div>
          </div>
          
          <p style="margin-bottom: 0; margin-top: 16px; font-size: 0.8rem;"><em>Classification metrics update daily using a trailing 30-day performance window.</em></p>
        </div>
      </details>
    </div>
  </details>
</div>

{:else}
<div class="section-card">
  <h3 class="section-title">No Menu Performance Data Available</h3>
  <p class="section-copy">No transaction or menu performance records were found for the selected period and branch location.</p>
</div>
{/if}

{:else}

<div style="margin-top: 24px; padding: 32px; border-radius: 16px; border: 1px dashed var(--color-border-tertiary); background: var(--color-background-secondary); text-align: center;">
  <div style="font-size: 2.5rem; margin-bottom: 12px;">🗺️</div>
  <h3 style="margin: 0 0 8px; font-size: 1.1rem; font-weight: 800; color: var(--color-text-primary);">No Branch Selected</h3>
  <p style="margin: 0; font-size: 0.9rem; color: var(--color-text-secondary); max-width: 500px; margin: 0 auto; line-height: 1.6;">
    Selecting <strong>"All Branches"</strong> displays consolidated multi-location menu portfolio metrics. Selecting an <strong>individual branch</strong> isolates location-specific item performance.
  </p>
</div>

{/if}


{/if}
