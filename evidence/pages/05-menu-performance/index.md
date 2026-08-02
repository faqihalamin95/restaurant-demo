---
title: Performa Menu
sidebar: hide
hide_toc: true
---

<script>
  import PremiumTable from '$lib/PremiumTable.svelte';

</script>





<style>
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
}
.hero-side-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.04), 0 2px 4px rgba(0, 0, 0, 0.02);
  background: rgba(255, 255, 255, 0.9);
}
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
.menu-health-badge { display: inline-flex; align-items: center; gap: 5px; padding: 4px 10px; border-radius: 999px; font-size: 11px; font-weight: 800; border: 1px solid; transition: all 0.2s ease; cursor: pointer; }
.menu-health-badge:hover { transform: translateY(-2px); box-shadow: 0 4px 8px rgba(0, 0, 0, 0.08); }
.menu-health-badge.safe { background: rgba(22,163,74,0.10); color: #166534; border-color: rgba(22,163,74,0.22); }
.menu-health-badge.warn { background: rgba(234,179,8,0.10); color: #854d0e; border-color: rgba(234,179,8,0.26); }
.menu-health-badge.critical { background: rgba(220,38,38,0.08); color: #991b1b; border-color: rgba(220,38,38,0.20); }
.menu-health-list { display: flex; flex-direction: column; gap: 6px; }
.menu-health-row { display: flex; align-items: flex-start; gap: 10px; padding: 9px 10px; border-radius: 10px; font-size: 0.84rem; line-height: 1.55; border: 1px solid transparent; transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1); cursor: pointer; }
.menu-health-row:hover { transform: translateX(4px) translateY(-1px); box-shadow: 0 4px 12px rgba(0,0,0,0.06); }
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
/* Makro Fix */
#makro-fix .kpi-meta { margin-top: 6px !important; font-size: 0.82rem !important; line-height: 1 !important; }
#makro-fix .kpi-prev { margin-top: 6px !important; font-size: 0.78rem !important; color: var(--color-text-secondary) !important; line-height: 1.4 !important; }
#makro-fix .kpi-card.revenue { border-color: rgba(37,99,235,0.18) !important; background: linear-gradient(145deg, rgba(37,99,235,0.06), rgba(99,102,241,0.03)) !important; }
#makro-fix .kpi-card.net { border-color: rgba(16,185,129,0.22) !important; background: linear-gradient(145deg, rgba(16,185,129,0.07), rgba(22,163,74,0.03)) !important; }
#makro-fix .kpi-card.margin { border-color: rgba(245,158,11,0.22) !important; background: linear-gradient(145deg, rgba(245,158,11,0.07), rgba(251,191,36,0.03)) !important; }
#makro-fix .kpi-card.expense { border-color: rgba(239,68,68,0.18) !important; background: linear-gradient(145deg, rgba(239,68,68,0.06), rgba(220,38,38,0.02)) !important; }
#makro-fix p { margin: 0 !important; padding: 0 !important; line-height: normal !important; }

/* -- KPI & Macro Strategic -- */
:global(#makro-fix .kpi-grid) { display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 12px; }
:global(#makro-fix .kpi-grid-2) { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 12px; }
:global(#makro-fix .kpi-card) { padding: 18px 16px; border-radius: 18px; border: 1.5px solid var(--color-border-tertiary); background: var(--color-background-secondary); box-shadow: 0 4px 10px rgba(0, 0, 0, 0.02), 0 1px 3px rgba(0, 0, 0, 0.01); transition: all 0.22s ease; text-align: center; }
:global(#makro-fix .kpi-card:hover) { transform: translateY(-2px); box-shadow: 0 8px 16px rgba(0, 0, 0, 0.04), 0 2px 4px rgba(0, 0, 0, 0.02); }
:global(#makro-fix .kpi-label) { font-size: 10px; font-weight: 700; letter-spacing: 0.1em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 8px; display: flex; align-items: center; justify-content: center; gap: 5px; }
:global(#makro-fix .kpi-value) { font-size: 1.15rem; font-weight: 800; letter-spacing: -0.03em; color: var(--color-text-primary); }
:global(#makro-fix .kpi-meta) { margin-top: 6px; font-size: 0.82rem; line-height: 1; }
:global(#makro-fix .kpi-prev) { margin-top: 6px; font-size: 0.78rem; color: var(--color-text-secondary); line-height: 1.4; }
:global(#makro-fix .kpi-card.revenue) { border-color: rgba(37,99,235,0.18); background: linear-gradient(145deg, rgba(37,99,235,0.06), rgba(99,102,241,0.03)); }
:global(#makro-fix .kpi-card.net) { border-color: rgba(16,185,129,0.22); background: linear-gradient(145deg, rgba(16,185,129,0.07), rgba(22,163,74,0.03)); }
:global(#makro-fix .kpi-card.margin) { border-color: rgba(245,158,11,0.22); background: linear-gradient(145deg, rgba(245,158,11,0.07), rgba(251,191,36,0.03)); }
:global(#makro-fix .kpi-card.expense) { border-color: rgba(239,68,68,0.18); background: linear-gradient(145deg, rgba(239,68,68,0.06), rgba(220,38,38,0.02)); }

:global(#makro-fix .clean-cta-banner) { margin-top: 32px; margin-bottom: 40px; padding: 24px 28px; border-radius: 16px; background: rgba(13, 148, 136, 0.03); border: 1px solid rgba(13, 148, 136, 0.15); display: flex; align-items: center; justify-content: space-between; box-shadow: 0 4px 12px rgba(13, 148, 136, 0.03); transition: all 0.3s ease; }
:global(#makro-fix .clean-cta-banner:hover) { background: rgba(13, 148, 136, 0.05); border-color: rgba(13, 148, 136, 0.25); box-shadow: 0 8px 24px rgba(13, 148, 136, 0.06); }
:global(#makro-fix .clean-cta-content) { display: flex; align-items: center; gap: 20px; }
:global(#makro-fix .clean-cta-icon) { font-size: 2.2rem; line-height: 1; filter: drop-shadow(0 2px 4px rgba(13, 148, 136, 0.15)); }
:global(#makro-fix .clean-cta-title) { margin: 0 0 4px 0; font-size: 1.1rem; font-weight: 800; letter-spacing: -0.01em; color: #0f766e; }
:global(#makro-fix .clean-cta-desc) { margin: 0; font-size: 0.88rem; color: var(--color-text-secondary); font-weight: 400; max-width: 65ch; line-height: 1.6; }
:global(#makro-fix .clean-cta-button) { background: white !important; border: 1px solid rgba(13, 148, 136, 0.3) !important; color: #0d9488 !important; font-weight: 800 !important; font-size: 0.9rem !important; padding: 12px 20px !important; border-radius: 8px !important; text-decoration: none !important; display: inline-flex !important; align-items: center !important; justify-content: center !important; transition: all 0.2s ease !important; box-shadow: 0 2px 6px rgba(13, 148, 136, 0.06) !important; line-height: 1 !important; margin: 0 !important; white-space: nowrap !important; }
:global(#makro-fix .clean-cta-button:hover) { background: #f0fdfa !important; color: #0f766e !important; border-color: #0d9488 !important; transform: translateY(-1px) !important; box-shadow: 0 4px 12px rgba(13, 148, 136, 0.1) !important; }

:global(#makro-fix .branch-card-link) {
  padding: 20px;
  border-radius: 16px;
  border: 1.5px solid rgba(37, 99, 235, 0.12);
  background: linear-gradient(145deg, rgba(37,99,235,0.04), rgba(99,102,241,0.01));
  box-shadow: 0 4px 12px rgba(0,0,0,0.02);
  display: flex;
  flex-direction: column;
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
  text-decoration: none;
  color: inherit;
  cursor: pointer;
}
:global(#makro-fix .branch-card-link:hover) {
  transform: translateY(-4px);
  box-shadow: 0 12px 24px rgba(37, 99, 235, 0.08), 0 4px 8px rgba(37, 99, 235, 0.04);
  border-color: rgba(37, 99, 235, 0.3);
}
</style>

```sql menu_dates
SELECT * FROM restaurant.mart_menu_dates
```

```sql menu_health_overview
SELECT * FROM restaurant.mart_menu_health_overview
```

```sql menu_kpi_y
SELECT * FROM restaurant.mart_menu_kpi_y
```

```sql menu_kpi_7d
SELECT * FROM restaurant.mart_menu_kpi_7d
```

```sql menu_kpi_30d
SELECT * FROM restaurant.mart_menu_kpi_30d
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

























```sql structural_decline_90d
SELECT * FROM restaurant.mart_structural_decline_90d
```


```sql passive_data
SELECT menu_name, category, total_qty as porsi, total_revenue as rev, (total_revenue / NULLIF(total_qty, 0)) as price
FROM restaurant.mart_menu_engineering_30d
WHERE total_qty < 15
ORDER BY total_qty ASC
```


{#if menu_health_overview.length > 0 && menu_dates.length > 0}

{@const activePeriod = '30d'}
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
{@const primadonaMenus  = activeEngineering.filter((m) => m.klasifikasi === 'Primadona')}
{@const mysteryMenus    = activeEngineering.filter((m) => m.klasifikasi === 'Misteri')}
{@const workhorseMenus  = activeEngineering.filter((m) => m.klasifikasi === 'Pekerja Keras')}
{@const weakMenus       = activeEngineering.filter((m) => m.klasifikasi === 'Lemah')}
{@const pushMenu        = mysteryMenus[0] ?? workhorseMenus[0]}
{@const structuralMenu  = structural_decline_90d.find((m) => m.menu_name != null)}
{@const periodLensTitle = activePeriod === 'y' ? 'Cek Operasional Harian' : activePeriod === '30d' ? 'Keputusan Awal Portofolio' : 'Sinyal Mingguan'}
{@const menuConcentrationState = activeTop5Share >= 70 ? 'critical' : activeTop5Share >= 55 ? 'warn' : 'safe'}
{@const menuDeclineState = activeDeclining >= 5 ? 'critical' : activeDeclining >= 2 ? 'warn' : 'safe'}
{@const activeStableCount = activeMenuCount - activeDeclining}
{@const heroStatusClass = menuDeclineState === 'safe' ? 'status-sehat' : menuDeclineState === 'warn' ? 'status-waspada' : 'status-kritis'}
{@const menuWeakRatio = activeMenuCount > 0 ? Math.round(activeWeak * 1000 / activeMenuCount) / 10 : 0}
{@const passiveMenus = activeEngineering.filter(m => m.total_qty < 15)}
{@const passiveCount = passiveMenus.length}
{@const menuPassiveState = passiveCount >= 3 ? 'critical' : passiveCount >= 1 ? 'warn' : 'safe'}
{@const menuPrimaryStates = [menuConcentrationState, menuPassiveState]}
{@const menuPrimarySafeCount = menuPrimaryStates.filter(s => s === 'safe').length}
{@const menuPrimaryWarnCount = menuPrimaryStates.filter(s => s === 'warn').length}
{@const menuPrimaryCriticalCount = menuPrimaryStates.filter(s => s === 'critical').length}

<MenuTabs activeTab="ringkasan" />

<div class="hero" style="margin-top: 10px;">
  <div class="hero-eyebrow">📊 Performa Menu · {activePeriod === '30d' ? '30 Hari Terakhir' : 'Pola 7 Hari'}</div>
  <div class="hero-grid">
    <div class="hero-main-card {heroStatusClass}">
      <div class="hero-stat-number">{activeStableCount}/{activeMenuCount}</div>
      <div class="hero-stat-label">menu stabil</div>
      <div class="hero-subtitle">
        {#if menuDeclineState === 'safe'}
          Mayoritas dari <strong>{activeMenuCount} menu aktif</strong> menunjukkan tren volume penjualan yang stabil.
        {:else if menuDeclineState === 'warn'}
          Terdapat {activeDeclining} dari <strong>{activeMenuCount} menu aktif</strong> yang volume penjualannya turun lebih dari 20%.
        {:else}
          Terdapat {activeDeclining} dari <strong>{activeMenuCount} menu aktif</strong> yang volume penjualannya turun lebih dari 20%. Kondisi ini butuh perhatian khusus.
        {/if}
        <div style="margin-top: 8px; font-size: 0.75em; opacity: 0.65;">
          *Sistem mengecualikan menu kosong (0 penjualan) dari perhitungan aktif. Penurunan pada menu pasif tidak dihitung sebagai anjlok.
        </div>
      </div>
    </div>
    <div class="hero-side">
      <div class="hero-side-card">
        <div class="hero-side-label">📅 Periode Aktif</div>
        <div class="hero-side-value">{activePeriod === '30d' ? menu_dates[0].tgl_30_awal + ' - ' + menu_dates[0].tgl_akhir : menu_dates[0].tgl_7_awal + ' - ' + menu_dates[0].tgl_akhir}</div>
        <div class="hero-side-note">Ini window paling stabil untuk keputusan operasional: cukup panjang untuk melihat pola, cukup dekat untuk bereaksi.</div>
      </div>
      <div class="hero-side-card">
        <div class="hero-side-label">🍽️ Menu Andalan</div>
        <div class="hero-side-value">{activeTopVolume ?? 'Belum ada data'}</div>
        <div class="hero-side-note">Bukan sekadar laku; pastikan suplai bahan baku untuk menu ini tidak pernah putus.</div>
      </div>
    </div>
  </div>
</div><details class="guide-acc" style="margin-top: 12px; margin-bottom: 24px;">
  <summary>💡 Dari mana angka Menu Stabil ini dihitung?</summary>
  <div class="guide-body">
    <p style="margin-top: 4px; margin-bottom: 16px; font-weight: 500; color: var(--color-text-secondary);">
      Angka ini murni mengukur <strong>Momentum</strong> dengan membandingkan performa setiap menu melawan dirinya sendiri di periode sebelumnya (misal: 30 hari terakhir vs 30 hari sebelumnya).
    </p>
    <div class="guide-grid" style="grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 12px;">
      <div class="guide-card blue">
        <div class="guide-card-icon">🧮</div>
        <div class="guide-card-content">
          <div class="guide-card-label">Angka Pembagi</div>
          <h4 class="guide-card-title">Menu Aktif</h4>
          <p class="guide-card-desc">Sistem hanya memperhitungkan daftar menu yang berhasil terjual minimal 1 porsi pada periode saat ini. Menu yang mati/kosong tidak dihitung di sini.</p>
        </div>
      </div>
      <div class="guide-card orange">
        <div class="guide-card-icon">📉</div>
        <div class="guide-card-content">
          <div class="guide-card-label">Sinyal Bahaya</div>
          <h4 class="guide-card-title">Toleransi 20%</h4>
          <p class="guide-card-desc">Jika penjualan menu anjlok &gt;20%, sistem mendeteksinya sebagai menu sakit. <strong>Pengecualian:</strong> Penurunan pada menu pasif diabaikan agar tidak memicu alarm palsu akibat fluktuasi angka kecil.</p>
        </div>
      </div>
      <div class="guide-card teal">
        <div class="guide-card-icon">📈</div>
        <div class="guide-card-content">
          <div class="guide-card-label">Syarat Lulus</div>
          <h4 class="guide-card-title">Menu Stabil</h4>
          <p class="guide-card-desc">Semua menu yang penjualannya meroket, konsisten, atau sekadar turun tipis (&lt;20%) dianggap sehat secara tren dan dihitung sebagai Menu Stabil.</p>
        </div>
      </div>
    </div>
  </div>
</details>

```sql branch_local_profile
WITH raw_data AS (
  SELECT branch_name, menu_name, SUM(total_qty_sold) as qty, SUM(total_revenue) as rev
  FROM restaurant.menu_performance
  WHERE order_date >= (SELECT MAX(order_date) - INTERVAL 29 DAY FROM restaurant.menu_performance)
  GROUP BY branch_name, menu_name
),
ranked AS (
  SELECT *,
         ROW_NUMBER() OVER(PARTITION BY branch_name ORDER BY qty DESC, rev DESC) as rn_qty,
         ROW_NUMBER() OVER(PARTITION BY branch_name ORDER BY rev DESC, qty DESC) as rn_rev
  FROM raw_data
),
agg AS (
  SELECT 
    branch_name,
    SUM(qty) as total_qty,
    SUM(rev) as total_revenue,
    SUM(rev)/NULLIF(SUM(qty), 0) as avg_item_price,
    COUNT(CASE WHEN qty > 0 THEN 1 END) as active_menus,
    COUNT(CASE WHEN qty < 15 AND qty > 0 THEN 1 END) as passive_menus
  FROM raw_data
  GROUP BY branch_name
)
SELECT 
  a.branch_name,
  a.total_qty,
  a.total_revenue,
  a.avg_item_price,
  a.active_menus,
  a.passive_menus,
  rq.menu_name as top_qty_menu,
  rq.qty as top_qty,
  rr.menu_name as top_rev_menu,
  rr.rev as top_rev,
  CASE 
    WHEN a.passive_menus >= 3 THEN 'Terdapat ' || a.passive_menus || ' menu pasif. Evaluasi efisiensi stok bahan harian.'
    WHEN a.avg_item_price > 25000 THEN 'Pelanggan gemar menu premium. Fokuskan upsell pada paket bundle.'
    ELSE 'Tipe pelanggan jajan santai/ekonomis. Volume tinggi di menu satuan.'
  END as insight
FROM agg a
JOIN ranked rq ON a.branch_name = rq.branch_name AND rq.rn_qty = 1
JOIN ranked rr ON a.branch_name = rr.branch_name AND rr.rn_rev = 1
WHERE a.branch_name != 'Semua Cabang'
ORDER BY a.total_revenue DESC
```

<div id="makro-fix">
  <div style="margin-bottom: 16px; display: flex; align-items: center; gap: 10px; margin-top: 48px; padding-top: 32px; border-top: 2px dashed rgba(0,0,0,0.06);">
    <div style="font-size: 1.5rem;">📋</div>
    <div>
      <h2 style="margin: 0; font-size: 1.25rem; font-weight: 800; color: var(--color-text-primary); letter-spacing: -0.02em;">PROFIL KARAKTERISTIK LOKAL (30H)</h2>
      <div style="font-size: 0.85rem; color: var(--color-text-tertiary); font-weight: 500;">Fokus: Membaca selera lokal dan kebiasaan belanja di tiap cabang.</div>
    </div>
  </div>

  <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); gap: 16px; margin-bottom: 40px;">
    {#each branch_local_profile as b}
      <a href="/05-menu-performance/deepdive?focus_branch={b.branch_name}" class="branch-card-link">
        
        <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 1px dashed rgba(37,99,235,0.15); padding-bottom: 12px; margin-bottom: 16px;">
          <div style="font-weight: 800; font-size: 1.15rem; color: #1e3a8a;">{b.branch_name}</div>
        </div>
        
        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 20px;">
          <div>
            <div style="color: var(--color-text-secondary); font-size: 0.75rem; margin-bottom: 4px;">👑 Favorit Lokal (Volume)</div>
            <div style="font-weight: 700; color: var(--color-text-primary); font-size: 0.9rem; line-height: 1.3;">{b.top_qty_menu}</div>
            <div style="font-size: 0.75rem; font-weight: 600; color: #16a34a; margin-top: 4px;">{Number(b.top_qty).toLocaleString('id-ID')} porsi</div>
          </div>
          <div>
            <div style="color: var(--color-text-secondary); font-size: 0.75rem; margin-bottom: 4px;">💸 Pendorong Struk (Omzet)</div>
            <div style="font-weight: 700; color: var(--color-text-primary); font-size: 0.9rem; line-height: 1.3;">{b.top_rev_menu}</div>
            <div style="font-size: 0.75rem; font-weight: 600; color: var(--color-text-tertiary); margin-top: 4px;">Rp {Number(b.top_rev / 1000000).toLocaleString('id-ID', {minimumFractionDigits:1, maximumFractionDigits:1})}jt</div>
          </div>
        </div>

        <div style="display: flex; gap: 12px; margin-bottom: 16px; background: rgba(255,255,255,0.6); padding: 12px; border-radius: 8px; border: 1px solid rgba(0,0,0,0.03);">
          <div style="flex: 1;">
            <div style="color: var(--color-text-secondary); font-size: 0.7rem; text-transform: uppercase; font-weight: 700; margin-bottom: 4px;">Daya Beli Rata-Rata</div>
            <div style="font-size: 1rem; font-weight: 800; color: #2563eb;">Rp {Math.round(b.avg_item_price).toLocaleString('id-ID')}</div>
          </div>
          <div style="width: 1px; background: rgba(128,128,128,0.2);"></div>
          <div style="flex: 1;">
            <div style="color: var(--color-text-secondary); font-size: 0.7rem; text-transform: uppercase; font-weight: 700; margin-bottom: 4px;">Status Menu</div>
            <div style="font-size: 1rem; font-weight: 800; color: var(--color-text-primary);">
              <span style="color: {b.passive_menus > 0 ? '#dc2626' : '#16a34a'};">{b.passive_menus} Pasif</span> <span style="font-size: 0.8rem; color: var(--color-text-tertiary); font-weight: 600;">/ {b.active_menus} Aktif</span>
            </div>
          </div>
        </div>

        <div style="display: flex; gap: 10px; padding: 14px; border-radius: 10px; border: 1.5px solid rgba(59,130,246,0.12); border-left-width: 4px; border-left-color: #3b82f6; background: rgba(59,130,246,0.04); font-size: 0.8rem; line-height: 1.5; color: var(--color-text-secondary); margin-top: auto;">
          <div style="font-size: 1.1rem; margin-top: -2px;">💡</div>
          <div>{b.insight}</div>
        </div>
      </a>
    {/each}
  </div>

  <div style="margin-bottom: 16px; display: flex; align-items: center; gap: 10px; margin-top: 48px; padding-top: 32px; border-top: 2px dashed rgba(0,0,0,0.06);">
    <div style="font-size: 1.5rem;">🔭</div>
    <div>
      <h2 style="margin: 0; font-size: 1.25rem; font-weight: 800; color: var(--color-text-primary); letter-spacing: -0.02em;">KESEHATAN MAKRO (STRATEGIS)</h2>
      <div style="font-size: 0.85rem; color: var(--color-text-tertiary); font-weight: 500;">Fokus: Evaluasi Kebijakan Bisnis Jangka Panjang</div>
    </div>
  </div>

  <div class="kpi-grid-2" style="margin-bottom: 24px;">
    <div class="kpi-card revenue">
      <div class="kpi-label">⚖️ Pemusatan Risiko (CR5)</div>
      <div class="kpi-value">{activeTop5Share}%</div>
      <div class="kpi-meta">
        <span class="trend-indicator neutral">Dominasi 5 Menu Teratas</span>
      </div>
      <div class="kpi-prev">{activeTop5Share}% omzet bergantung pada 5 menu.</div>
    </div>
    
    <div class="kpi-card expense">
      <div class="kpi-label">🧊 Daftar Hitam Menu Pasif</div>
      <div class="kpi-value">{passiveCount}</div>
      <div class="kpi-meta">
        <span class="trend-indicator {passiveCount === 0 ? 'up' : 'down'}" style="color: {passiveCount === 0 ? '#15803d' : '#b91c1c'};">Risiko Food Waste</span>
      </div>
      <div class="kpi-prev">Rawan menumpuk di kulkas.</div>
    </div>
  </div>

  <div class="clean-cta-banner">
    <div class="clean-cta-content">
      <div class="clean-cta-icon">🔍</div>
      <div class="clean-cta-text">
        <h3 class="clean-cta-title">Eksplorasi Ekosistem & Peta Kekuatan Menu</h3>
        <p class="clean-cta-desc">Bedah lebih dalam efektivitas SOP, deteksi anomali kinerja, dan ukur ketimpangan profitabilitas lintas menu secara komprehensif.</p>
      </div>
    </div>
    <a href="/05-menu-performance/evaluasi" class="clean-cta-button">
      Buka Evaluasi Strategis ➔
    </a>
  </div>
</div>





{:else}
<div class="section-card">
  <h3 class="section-title">Data menu belum tersedia.</h3>
  <p class="section-copy">Pastikan source <code>restaurant.menu_performance</code> sudah ter-refresh dan memiliki data yang valid.</p>
</div>
{/if}
