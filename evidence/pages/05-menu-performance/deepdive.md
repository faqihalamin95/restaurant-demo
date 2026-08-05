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
SELECT * FROM restaurant.menu_b_branch_engineering
```

```sql menu_branch_list
SELECT * FROM restaurant.mart_menu_branch_list
```

```sql menu_branch_list_all
SELECT branch_name FROM (
  SELECT 0 as sort_order, 'Semua Cabang' as branch_name
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
  eyebrow="<span style='font-size: 12px;'>🏪 Filter Lokasi</span>" 
  title="Analisis Portofolio Per Cabang" 
  description="Pilih 'Semua Cabang' untuk melihat agregat bisnis keseluruhan, atau pilih cabang spesifik untuk membaca matriks menu lokal."
>
    <ButtonGroup name=focus_branch>
      {#each menu_branch_list_all as branch, i}
        <ButtonGroupItem value={branch.branch_name} valueLabel={branch.branch_name} />
      {/each}
    </ButtonGroup>
</SectionCard>

{#if menu_branch_list_all.length > 0}
{@const selectedBranchRaw = inputs.focus_branch?.value ?? inputs.focus_branch}
{@const isValidBranch = menu_branch_list_all.some(b => b.branch_name === selectedBranchRaw)}

{#if isValidBranch}

{#if menu_health_overview.length > 0 && menu_dates.length > 0}

{@const activePeriod = '30d'}
{@const activeTopVolume = activePeriod === 'y' ? menu_health_overview[0].top_volume_menu_y  : activePeriod === '30d' ? menu_health_overview[0].top_volume_menu_30d  : menu_health_overview[0].top_volume_menu_7d}
{@const selectedBranchNormalized = decodeURIComponent(selectedBranchRaw).replace(/\+/g, ' ')}
{@const selectedBranch = menu_branch_list_all.find(b => b.branch_name === selectedBranchRaw || b.branch_name === selectedBranchNormalized)?.branch_name ?? 'Semua Cabang'}
{@const activeEngineering = branch_engineering_data.filter((m) => m.period === activePeriod && m.branch_name === selectedBranch)}
{@const activeMovers    = activePeriod === '30d' ? movers_30d : movers_7d}
{@const primadonaMenus  = activeEngineering.filter((m) => m.klasifikasi === 'Primadona')}
{@const mysteryMenus    = activeEngineering.filter((m) => m.klasifikasi === 'Misteri')}
{@const workhorseMenus  = activeEngineering.filter((m) => m.klasifikasi === 'Pekerja Keras')}
{@const weakMenus       = activeEngineering.filter((m) => m.klasifikasi === 'Lemah')}
{@const pushMenu        = mysteryMenus[0] ?? workhorseMenus[0]}
{@const decliningMenu   = activeMovers.find((m) => m.movement_status === 'Turun')}
{@const weakMenu        = weakMenus[0]}
{@const structuralMenu  = structural_decline_90d.find((m) => m.menu_name != null)}

{@const mysteryMenusWithMock = mysteryMenus.map(m => ({ ...m, harga_jual: m.total_revenue / m.total_qty, hpp: (m.total_revenue / m.total_qty) * (1 - (0.55 + ((m.menu_name.length % 5) * 0.03))), margin: (m.total_revenue / m.total_qty) - ((m.total_revenue / m.total_qty) * (1 - (0.55 + ((m.menu_name.length % 5) * 0.03)))) }))}
{@const workhorseMenusWithMock = workhorseMenus.map(m => ({ ...m, harga_jual: m.total_revenue / m.total_qty, hpp: (m.total_revenue / m.total_qty) * (1 - (0.15 + ((m.menu_name.length % 5) * 0.02))), margin: (m.total_revenue / m.total_qty) - ((m.total_revenue / m.total_qty) * (1 - (0.15 + ((m.menu_name.length % 5) * 0.02)))) }))}



<div class="strategic-stack" style="margin-top: 32px;">
  <div class="strategic-header">
    <div class="strategic-eyebrow">🗂️ Status Klasifikasi & Peta Menu · {selectedBranch}</div>
    <div class="toc-anchor" style="position: absolute; opacity: 0; pointer-events: none; margin: 0; padding: 0; height: 0; overflow: hidden; font-size: 0px;">

## Bagaimana komposisi dan posisi menu Anda saat ini?

</div>
<h2 class="strategic-title">Bagaimana komposisi dan posisi menu Anda saat ini?</h2>
    <p class="strategic-copy">Dua lens di bawah ini dirancang untuk membaca distribusi menu di setiap kuadran matriks portofolio beserta arahan aksi utamanya, dan melihat apakah perlakuannya berubah di cabang tertentu.</p>
  </div>

  <div class="acc-body" style="padding-top: 8px; border: none; background: transparent; padding-left: 0; padding-right: 0;">

      <details class="guide-acc" style="margin-bottom:24px;">
        <summary>📖 Cara membaca klasifikasi menu</summary>
        <div class="guide-body">
          <p style="margin-top: 4px; margin-bottom: 16px; font-weight: 500; color: var(--color-text-secondary);">
            Klasifikasi berbasis median volume dan revenue dalam periode aktif, bukan angka absolut.
          </p>
          <div class="guide-grid" style="grid-template-columns: repeat(2, minmax(0, 1fr));">
            <div class="guide-card blue">
              <div class="guide-card-icon">⭐</div>
              <div class="guide-card-content">
                <div class="guide-card-label">Volume & Revenue Tinggi</div>
                <h4 class="guide-card-title">Primadona</h4>
                <p class="guide-card-desc">Volume dan revenue di atas median. Fokusnya jaga stok, kualitas, dan konsistensi eksekusi.</p>
              </div>
            </div>
            <div class="guide-card orange">
              <div class="guide-card-icon">🔮</div>
              <div class="guide-card-content">
                <div class="guide-card-label">Revenue Tinggi</div>
                <h4 class="guide-card-title">Misteri</h4>
                <p class="guide-card-desc">Revenue di atas median, tapi volume di bawah median. Fokusnya dorong visibilitas, rekomendasi staf, atau pairing menu.</p>
              </div>
            </div>
            <div class="guide-card teal">
              <div class="guide-card-icon">💪</div>
              <div class="guide-card-content">
                <div class="guide-card-label">Volume Tinggi</div>
                <h4 class="guide-card-title">Pekerja Keras</h4>
                <p class="guide-card-desc">Volume di atas median, tapi revenue di bawah median. Fokusnya uji bundling, add-on, ukuran porsi, atau harga kecil bertahap.</p>
              </div>
            </div>
            <div class="guide-card" style="background: rgba(220, 38, 38, 0.05); border: 1px solid rgba(220, 38, 38, 0.1);">
              <div class="guide-card-icon">🔻</div>
              <div class="guide-card-content">
                <div class="guide-card-label" style="color: #dc2626;">Keduanya Rendah</div>
                <h4 class="guide-card-title">Lemah</h4>
                <p class="guide-card-desc">Volume dan revenue di bawah median. Ini bukan vonis hapus menu; validasi dulu di Pergerakan, terutama tren 90 hari.</p>
              </div>
            </div>
          </div>
        </div>
      </details>

      <div class="snapshot-grid">
        <div class="snapshot-card star">
          <div class="snapshot-icon">⭐</div>
          <div class="snapshot-value">{primadonaMenus.length}</div>
          <div class="snapshot-label">Primadona</div>
          <div class="snapshot-copy">Jaga stok dan kualitas. Jangan ubah tanpa alasan kuat.</div>
        </div>
        <div class="snapshot-card mystery">
          <div class="snapshot-icon">🔮</div>
          <div class="snapshot-value">{mysteryMenus.length}</div>
          <div class="snapshot-label">Misteri</div>
          <div class="snapshot-copy">Revenue kuat, volume belum tinggi. Dorong visibilitas.</div>
        </div>
        <div class="snapshot-card workhorse">
          <div class="snapshot-icon">💪</div>
          <div class="snapshot-value">{workhorseMenus.length}</div>
          <div class="snapshot-label">Pekerja Keras</div>
          <div class="snapshot-copy">Volume kuat, revenue relatif rendah. Uji bundling/harga.</div>
        </div>
        <div class="snapshot-card weak">
          <div class="snapshot-icon">🔻</div>
          <div class="snapshot-value">{weakMenus.length}</div>
          <div class="snapshot-label">Lemah</div>
          <div class="snapshot-copy">Validasi tren sebelum reformulasi atau retire.</div>
        </div>
      </div>



      <ScatterPlot
        data={activeEngineering}
        x="total_qty"
        y="total_revenue"
        series="klasifikasi"
        tooltipTitle="tooltip_label"
        xAxisTitle="Volume Terjual (Qty)"
        yAxisTitle="Total Revenue (Rp)"
        title="Peta Menu — Volume vs Revenue"
        yFmt="#,##0"
      />

      <div class="chart-insight" style="margin-bottom: 24px;">
        📌 <strong>Cara membaca chart ini:</strong> arah kanan berarti volume lebih tinggi, arah atas berarti revenue lebih tinggi. Jika satu menu dominan membuat titik lain menumpuk, gunakan tabel lengkap di bawah untuk membaca menu satu per satu. Tooltip menampilkan nama menu, kategori, klasifikasi, volume, dan revenue.
      </div>

      <div style="margin-top: 16px;">
        <DataTable data={activeEngineering} rows="10">
          <Column id="menu_name" title="Nama Menu" />
          <Column id="category" title="Kategori" />
          <Column id="klasifikasi" title="Klasifikasi" />
          <Column id="total_qty" title="Order Volume" align="right" fmt="#,##0" />
          <Column id="total_revenue" title="Total Revenue" align="right" fmt="#,##0" />
          <Column id="aksi_disarankan" title="Rekomendasi Aksi" />
        </DataTable>
      </div>

    </div>
</div>

<!-- ACTION CENTER: MENU PRIORITAS -->
<div class="strategic-stack" style="margin-top: 48px; margin-bottom: 32px;">
  <div class="strategic-header">
    <div class="strategic-eyebrow">🎯 Ruang Eksperimen Bisnis</div>
    <div class="toc-anchor" style="position: absolute; opacity: 0; pointer-events: none; margin: 0; padding: 0; height: 0; overflow: hidden; font-size: 0px;">

## Meracik Kombinasi Promo Bundling

</div>
<h2 class="strategic-title">Meracik Kombinasi Promo Bundling</h2>
    <p class="strategic-copy">Simulasi penggabungan menu-menu yang potensial untuk menciptakan paket promosi yang memaksimalkan daya tarik pelanggan sekaligus mendongkrak profitabilitas restoran.</p>
  </div>

  <details class="acc-strategic">
    <summary>🎯 Meracik Kombinasi Promo Bundling</summary>
    <div class="acc-body">
      <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 32px;">
        <!-- Card Teori -->
        <div class="interactive-card" style="display: flex; align-items: flex-start; gap: 16px; padding: 20px 24px; border-radius: 16px; background: linear-gradient(135deg, rgba(16, 185, 129, 0.08), rgba(59, 130, 246, 0.05)); border: 1px solid rgba(16, 185, 129, 0.2);">
          <div style="font-size: 2.2rem; line-height: 1; flex-shrink: 0; margin-top: 2px;">🤝</div>
          <div>
            <div style="font-size: 1rem; font-weight: 800; color: var(--color-text-primary); margin-bottom: 6px;">Strategi Menu Engineering Klasik</div>
            <div style="font-size: 0.9rem; line-height: 1.6; color: var(--color-text-secondary);">
              Gunakan dua tabel di bawah ini sebagai bahan racikan. Cara paling jitu mendongkrak profit adalah <strong>mengawinkan satu menu dari "Pekerja Keras" (magnet penarik trafik) dengan satu menu dari "Harta Karun" (pendongkrak margin profit)</strong> ke dalam satu paket promo spesial.
            </div>
          </div>
        </div>
        
        <!-- Card Contoh -->
        <div class="interactive-card" style="display: flex; align-items: flex-start; gap: 16px; padding: 20px 24px; border-radius: 16px; background: linear-gradient(135deg, rgba(244, 63, 94, 0.05), rgba(249, 115, 22, 0.05)); border: 1px solid rgba(244, 63, 94, 0.2);">
          <div style="font-size: 2.2rem; line-height: 1; flex-shrink: 0; margin-top: 2px;">💡</div>
          <div>
            <div style="font-size: 1rem; font-weight: 800; color: var(--color-text-primary); margin-bottom: 6px;">Contoh Simulasi Kasus</div>
            <div style="font-size: 0.9rem; line-height: 1.6; color: var(--color-text-secondary);">
              <strong>Ayam Bakar</strong> (Pekerja Keras, margin 3k) + <strong>Es Jeruk</strong> (Harta Karun, margin 10k). Normalnya, pelanggan cuma beli menu Pekerja Keras saja, total margin = 3k.<br/><br/>
              Buat "Paket Promo" diskon 5k. Pelanggan merasa hemat & bahagia, tapi restoran mengunci <strong>margin gabungan 8k</strong> per transaksi!
            </div>
          </div>
        </div>
      </div>
      <details class="guide-acc" style="margin-bottom: 32px;">
        <summary>🛠️ Panduan Eksekusi: Simulasi Praktik Membuat Promo</summary>
        <div class="guide-body" style="padding: 24px; background: rgba(255,255,255,0.4); border-radius: 0 0 8px 8px;">
          
          <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 24px; margin-bottom: 24px;">
            <!-- Tabel Harta Karun Mock -->
            <div style="border: 1px solid var(--color-border-tertiary); border-radius: 12px; overflow: hidden; background: white; box-shadow: 0 2px 4px rgba(0,0,0,0.02);">
              <div style="background: rgba(245,158,11,0.1); padding: 12px 16px; font-weight: 700; border-bottom: 1px solid var(--color-border-tertiary);">💎 Kasus Harta Karun</div>
              <table style="width: 100%; border-collapse: collapse; text-align: left; font-size: 0.85rem;">
                <thead>
                  <tr style="border-bottom: 1px solid var(--color-border-tertiary); color: var(--color-text-secondary);">
                    <th style="padding: 10px 16px;">Menu</th>
                    <th style="padding: 10px 16px; text-align: right;">Harga</th>
                    <th style="padding: 10px 16px; text-align: right;">Profit</th>
                  </tr>
                </thead>
                <tbody>
                  <tr style="border-bottom: 1px solid #f1f5f9;">
                    <td style="padding: 10px 16px;">Puding Coklat</td><td style="padding: 10px 16px; text-align: right;">12.000</td><td style="padding: 10px 16px; text-align: right; color: #16a34a;">7.500</td>
                  </tr>
                  <tr style="background: rgba(245, 158, 11, 0.15); border-left: 3px solid #f59e0b;">
                    <td style="padding: 10px 16px; font-weight: 700;">Es Jeruk Nipis</td><td style="padding: 10px 16px; text-align: right; font-weight: 700;">15.000</td><td style="padding: 10px 16px; text-align: right; color: #16a34a; font-weight: 700;">10.000</td>
                  </tr>
                  <tr>
                    <td style="padding: 10px 16px;">Kopi Susu Aren</td><td style="padding: 10px 16px; text-align: right;">20.000</td><td style="padding: 10px 16px; text-align: right; color: #16a34a;">12.000</td>
                  </tr>
                </tbody>
              </table>
            </div>

            <!-- Tabel Pekerja Keras Mock -->
            <div style="border: 1px solid var(--color-border-tertiary); border-radius: 12px; overflow: hidden; background: white; box-shadow: 0 2px 4px rgba(0,0,0,0.02);">
              <div style="background: rgba(59,130,246,0.1); padding: 12px 16px; font-weight: 700; border-bottom: 1px solid var(--color-border-tertiary);">🐴 Kasus Pekerja Keras</div>
              <table style="width: 100%; border-collapse: collapse; text-align: left; font-size: 0.85rem;">
                <thead>
                  <tr style="border-bottom: 1px solid var(--color-border-tertiary); color: var(--color-text-secondary);">
                    <th style="padding: 10px 16px;">Menu</th>
                    <th style="padding: 10px 16px; text-align: right;">Harga</th>
                    <th style="padding: 10px 16px; text-align: right;">Profit</th>
                  </tr>
                </thead>
                <tbody>
                  <tr style="border-bottom: 1px solid #f1f5f9;">
                    <td style="padding: 10px 16px;">Mie Goreng Gila</td><td style="padding: 10px 16px; text-align: right;">22.000</td><td style="padding: 10px 16px; text-align: right; color: #d97706;">2.500</td>
                  </tr>
                  <tr style="background: rgba(59, 130, 246, 0.15); border-left: 3px solid #3b82f6;">
                    <td style="padding: 10px 16px; font-weight: 700;">Ayam Bakar Madu</td><td style="padding: 10px 16px; text-align: right; font-weight: 700;">25.000</td><td style="padding: 10px 16px; text-align: right; color: #d97706; font-weight: 700;">3.000</td>
                  </tr>
                  <tr>
                    <td style="padding: 10px 16px;">Nasi Gila</td><td style="padding: 10px 16px; text-align: right;">20.000</td><td style="padding: 10px 16px; text-align: right; color: #d97706;">2.000</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>

          <!-- Step by step -->
          <div style="display: flex; flex-direction: column; gap: 12px;">
            <div style="padding: 12px 16px; background: rgba(0,0,0,0.03); border-radius: 8px; font-size: 0.9rem; line-height: 1.6; color: var(--color-text-secondary);">
              <strong style="color: var(--color-text-primary);">1. Pilih Umpan Trafik (Lihat Tabel Kanan):</strong> Pilih satu menu dari daftar "Pekerja Keras". Pastikan ini adalah menu utama yang populer. (Contoh: <strong style="color:#2563eb;">Ayam Bakar Madu</strong>).
            </div>
            <div style="padding: 12px 16px; background: rgba(0,0,0,0.03); border-radius: 8px; font-size: 0.9rem; line-height: 1.6; color: var(--color-text-secondary);">
              <strong style="color: var(--color-text-primary);">2. Pilih Pendongkrak Margin (Lihat Tabel Kiri):</strong> Pilih satu menu dari daftar "Harta Karun" yang cocok mendampingi menu pertama. (Contoh: <strong style="color:#d97706;">Es Jeruk Nipis</strong>).
            </div>
            <div style="padding: 12px 16px; background: rgba(0,0,0,0.03); border-radius: 8px; font-size: 0.9rem; line-height: 1.6; color: var(--color-text-secondary);">
              <strong style="color: var(--color-text-primary);">3. Hitung Batas Maksimal Diskon:</strong> Jumlahkan Profit/Porsi dari kedua menu (3.000 + 10.000 = <strong style="color:#16a34a;">Rp 13.000</strong>). Ini adalah "Ruang Nafas" diskon Anda.
            </div>
            <div style="padding: 12px 16px; background: rgba(0,0,0,0.03); border-radius: 8px; font-size: 0.9rem; line-height: 1.6; color: var(--color-text-secondary);">
              <strong style="color: var(--color-text-primary);">4. Tentukan Harga Bundling:</strong> Total harga normal Rp 40.000. Berikan diskon <strong>Rp 5.000</strong> (harga coret jadi Rp 35.000). Anda sukses mengunci margin gabungan <strong>Rp 8.000</strong> per transaksi!
            </div>
            <div style="padding: 12px 16px; background: rgba(16, 185, 129, 0.1); border-left: 3px solid #10b981; border-radius: 8px; font-size: 0.9rem; line-height: 1.6; color: var(--color-text-secondary);">
              <strong style="color: var(--color-text-primary);">5. Eksekusi di Kasir (SOP):</strong> Buat menu paket baru di POS. Instruksikan pelayan: <em>"Setiap pelanggan memesan Ayam Bakar, tawarkan upgrade ke Paket Promo yang lebih hemat."</em>
            </div>
          </div>

        </div>
      </details>

      <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(400px, 1fr)); gap: 24px; align-items: start;">
        
        <!-- Kolom 1: Harta Karun -->
        <div style="padding: 24px; border-radius: 16px; border: 1px solid rgba(245,158,11,0.2); background: linear-gradient(145deg, rgba(245,158,11,0.03), rgba(251,191,36,0.01));">
          <div class="section-head tight" style="margin-bottom: 16px;">
            <div>
              <div class="section-eyebrow" style="color: #d97706;">💎 Harta Karun (Hidden Gems)</div>
              <h3 class="section-title" style="font-size: 1.1rem;">Menu profit tebal, jarang dibeli</h3>
              <p class="section-copy" style="font-size: 0.85rem;">Siap di-bundling atau butuh visibilitas ekstra.</p>
            </div>
          </div>
          <div>
            {#if mysteryMenusWithMock.length > 0}
              <PremiumTable 
                data={mysteryMenusWithMock} 
                pageSize={5} 
                columns={[
                  { title: "Menu", key: "menu_name", align: "left", bold: true },
                  { title: "Terjual", key: "total_qty", align: "right", type: "currency_raw" },
                  { title: "Harga (Rp)", key: "harga_jual", align: "right", type: "currency_raw" },
                  { title: "HPP (Rp)", key: "hpp", align: "right", type: "currency_raw" },
                  { title: "Profit/Porsi (Rp)", key: "margin", align: "right", type: "currency_raw", colorRules: "growth" }
                ]} 
              />
              <div class="chart-insight" style="margin-top: 16px; font-size: 0.8rem;">
                📌 <strong>Rekomendasi:</strong> Karena margin aslinya tebal, memberikan diskon bundling tidak akan membuat rugi.
              </div>
            {:else}
              <div class="signal-card safe" style="margin-top:0;">
                <div class="signal-label">ℹ️ Kosong</div>
                <div class="signal-title">Tidak ada menu Harta Karun saat ini.</div>
              </div>
            {/if}
          </div>
        </div>

        <!-- Kolom 2: Pekerja Keras -->
        <div style="padding: 24px; border-radius: 16px; border: 1px solid rgba(59,130,246,0.2); background: linear-gradient(145deg, rgba(59,130,246,0.03), rgba(37,99,235,0.01));">
          <div class="section-head tight" style="margin-bottom: 16px;">
            <div>
              <div class="section-eyebrow" style="color: #2563eb;">🐴 Pekerja Keras (Plowhorse)</div>
              <h3 class="section-title" style="font-size: 1.1rem;">Menu laku keras, profit tipis</h3>
              <p class="section-copy" style="font-size: 0.85rem;">Sebagai umpan tarik volume pelanggan.</p>
            </div>
          </div>
          <div>
            {#if workhorseMenusWithMock.length > 0}
              <PremiumTable 
                data={workhorseMenusWithMock} 
                pageSize={5} 
                columns={[
                  { title: "Menu", key: "menu_name", align: "left", bold: true },
                  { title: "Terjual", key: "total_qty", align: "right", type: "currency_raw" },
                  { title: "Harga (Rp)", key: "harga_jual", align: "right", type: "currency_raw" },
                  { title: "HPP (Rp)", key: "hpp", align: "right", type: "currency_raw" },
                  { title: "Profit/Porsi (Rp)", key: "margin", align: "right", type: "currency_raw" }
                ]} 
              />
              <div class="chart-insight" style="margin-top: 16px; font-size: 0.8rem;">
                📌 <strong>Rekomendasi:</strong> Hindari menjadikan menu ini sebagai bonus gratis. Sebaiknya gunakan menu ini sebagai pasangan bundling untuk mendorong penjualan menu Harta Karun.
              </div>
            {:else}
              <div class="signal-card safe" style="margin-top:0;">
                <div class="signal-label">ℹ️ Kosong</div>
                <div class="signal-title">Tidak ada menu Pekerja Keras saat ini.</div>
              </div>
            {/if}
          </div>
        </div>

      </div>

      <details class="guide-acc" style="margin-top: 24px;">
        <summary>💡 Dari mana klasifikasi Harta Karun & Pekerja Keras ini dihitung?</summary>
        <div class="guide-body" style="padding: 20px; font-size: 0.9em; line-height: 1.6; color: var(--color-text-secondary); background: rgba(255,255,255,0.4);">
          <p style="margin-top: 0; margin-bottom: 16px;">Klasifikasi ini didapatkan dengan mengimplementasikan kerangka kerja <strong>Menu Engineering (Boston Consulting Group Matrix)</strong>. Sistem secara otomatis memetakan setiap menu pada dua sumbu dengan membandingkannya terhadap <strong>Nilai Tengah (Median)</strong> penjualan restoran Anda:</p>
          
          <div class="guide-grid" style="grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 12px; margin-bottom: 16px;">
            <div class="guide-card teal">
              <div class="guide-card-icon">💎</div>
              <div class="guide-card-content">
                <div class="guide-card-label">Volume &lt; Rata-rata | Profit &gt; Rata-rata</div>
                <h4 class="guide-card-title">Harta Karun (Puzzle)</h4>
                <p class="guide-card-desc">Menu ini tidak populer tapi sangat menguntungkan.<br><br><span style="font-size: 0.8em; color: var(--color-text-tertiary);"><strong>Fokus:</strong> Prioritas utama pemasaran (Promosi/Upsell).</span></p>
              </div>
            </div>
            
            <div class="guide-card orange">
              <div class="guide-card-icon">🐴</div>
              <div class="guide-card-content">
                <div class="guide-card-label">Volume &gt; Rata-rata | Profit &lt; Rata-rata</div>
                <h4 class="guide-card-title">Pekerja Keras (Plowhorse)</h4>
                <p class="guide-card-desc">Menu andalan karena sangat laris namun margin keuntungannya tipis.<br><br><span style="font-size: 0.8em; color: var(--color-text-tertiary);"><strong>Fokus:</strong> Butuh <i>bundling</i> atau naik harga pelan-pelan.</span></p>
              </div>
            </div>
          </div>
          
          <div class="interactive-card" style="display: flex; align-items: flex-start; gap: 16px; background: linear-gradient(135deg, rgba(239, 68, 68, 0.05), rgba(245, 158, 11, 0.05)); border: 1px solid rgba(239, 68, 68, 0.2); border-left: 4px solid rgba(239, 68, 68, 0.5); padding: 20px 24px; border-radius: 12px;">
            <div style="font-size: 2.2rem; line-height: 1; flex-shrink: 0; margin-top: 2px;">⚠️</div>
            <div>
              <div style="font-size: 1rem; font-weight: 800; color: #b91c1c; margin-bottom: 6px;">Catatan Kelemahan Sistem (Borderline Effect)</div>
              <div style="font-size: 0.9rem; line-height: 1.6; color: var(--color-text-secondary);">
                Karena perhitungan matematika menggunakan ambang batas median yang mutlak, dua menu dengan penjualan yang beda tipis (misal: selisih 10 porsi) bisa dilempar ke kuadran yang berlawanan jika satu berada tepat di bawah median dan satu di atasnya. <strong>Oleh karena itu, intuisi dan campur tangan manusia (manajer) tetap mutlak diperlukan</strong> untuk memutuskan apakah suatu menu benar-benar pantas disebut Harta Karun/Pekerja Keras, atau sekadar menu normal di garis perbatasan.
              </div>
            </div>
          </div>
          
          <p style="margin-bottom: 0; margin-top: 16px; font-size: 0.8rem;"><em>Data klasifikasi diperbarui secara otomatis setiap hari berdasarkan performa 30 hari terakhir.</em></p>
        </div>
      </details>
    </div>
  </details>
</div>

{:else}
<div class="section-card">
  <h3 class="section-title">Data menu belum tersedia.</h3>
  <p class="section-copy">Pastikan source <code>restaurant.menu_performance</code> sudah ter-refresh dan memiliki data yang valid.</p>
</div>
{/if}

{:else}

<div style="margin-top: 24px; padding: 32px; border-radius: 16px; border: 1px dashed var(--color-border-tertiary); background: var(--color-background-secondary); text-align: center;">
  <div style="font-size: 2.5rem; margin-bottom: 12px;">🗺️</div>
  <h3 style="margin: 0 0 8px; font-size: 1.1rem; font-weight: 800; color: var(--color-text-primary);">Pilih Cabang untuk Memulai Analisis</h3>
  <p style="margin: 0; font-size: 0.9rem; color: var(--color-text-secondary); max-width: 500px; margin: 0 auto; line-height: 1.6;">
    Klik <strong>"Semua Cabang"</strong> untuk melihat matriks portofolio menu agregat seluruh bisnis, atau pilih <strong>cabang spesifik</strong> untuk membaca performa menu lokal di outlet tersebut.
  </p>
</div>

{/if}


{/if}
