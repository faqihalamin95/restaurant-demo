---
title: Analisis Perilaku Member
---

_Cockpit loyalitas member: siapa yang aktif, siapa yang bernilai tinggi, dan siapa yang perlu dijaga sebelum churn._

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
  letter-spacing: 0;
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

details.info-accordion {
  border-radius: 14px;
  border: 1px solid rgba(20,184,166,0.22);
  background: linear-gradient(135deg, rgba(20,184,166,0.06), rgba(37,99,235,0.025));
}
details.info-accordion > summary {
  padding: 15px 17px;
  background: transparent;
  font-size: 0.92rem;
  font-weight: 800;
}
.info-grid { display: grid; grid-template-columns: repeat(4, minmax(0,1fr)); gap: 10px; }
.info-item { padding: 12px 13px; border-radius: 12px; border: 1px solid rgba(20,184,166,0.16); background: rgba(255,255,255,0.55); }
.info-label { font-size: 10px; font-weight: 800; letter-spacing: 0.1em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 5px; }
.info-copy { font-size: 0.84rem; line-height: 1.6; color: var(--color-text-secondary); }

/* ── Layout ── */
.member-page { display: flex; flex-direction: column; gap: 24px; margin-top: 10px; }

.page-intro {
  font-size: 0.92rem; line-height: 1.75;
  color: var(--color-text-secondary); max-width: 70ch;
}

.inline-link { color: var(--color-primary); text-decoration: none; }
.inline-link:hover { text-decoration: underline; }

/* ── Period Strip ── */
.period-strip { display: grid; grid-template-columns: repeat(3, minmax(0,1fr)); gap: 10px; }
.period-pill {
  padding: 14px 16px; border-radius: 16px;
  border: 1.5px solid var(--color-border-tertiary);
  background: var(--color-background-secondary);
  position: relative;
  overflow: hidden;
}
.period-pill.sehat   { border-color: rgba(22,163,74,0.28);  background: linear-gradient(135deg, rgba(22,163,74,0.09) 0%, rgba(16,185,129,0.05) 100%); }
.period-pill.waspada { border-color: rgba(245,158,11,0.32); background: linear-gradient(135deg, rgba(245,158,11,0.10) 0%, rgba(251,191,36,0.05) 100%); }
.period-pill.kritis  { border-color: rgba(239,68,68,0.28);  background: linear-gradient(135deg, rgba(239,68,68,0.09) 0%, rgba(220,38,38,0.05) 100%); }
.period-pill-label { font-size: 10px; font-weight: 700; letter-spacing: 0.1em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 5px; }
.period-pill-value { font-size: 1.02rem; font-weight: 800; letter-spacing: -0.02em; color: var(--color-text-primary); display: flex; align-items: center; gap: 6px; flex-wrap: wrap; margin-bottom: 4px; }
.period-pill-copy  { margin-top: 4px; font-size: 0.82rem; line-height: 1.55; color: var(--color-text-secondary); }
.pill-badge { display: inline-block; padding: 2px 8px; border-radius: 999px; font-size: 10px; font-weight: 700; letter-spacing: 0.04em; }
.pill-badge.sehat   { background: rgba(22,163,74,0.15);  color: #15803d; }
.pill-badge.waspada { background: rgba(245,158,11,0.18); color: #b45309; }
.pill-badge.kritis  { background: rgba(239,68,68,0.15);  color: #b91c1c; }
.pill-badge.neutral { background: rgba(99,102,241,0.14); color: #4338ca; }

/* ── Hero ── */
.hero {
  display: grid;
  grid-template-columns: minmax(0, 1.7fr) minmax(280px, 1fr);
  gap: 18px; padding: 24px; border-radius: 22px;
  border: 1px solid rgba(37,99,235,0.12);
  background:
    radial-gradient(circle at top right, rgba(69,161,191,0.18), transparent 35%),
    radial-gradient(circle at bottom left, rgba(99,102,241,0.08), transparent 40%),
    linear-gradient(135deg, rgba(37,99,235,0.06), rgba(194,65,12,0.04)),
    var(--color-background-secondary);
}
.hero-eyebrow { font-size: 11px; font-weight: 700; letter-spacing: 0.13em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 8px; display: flex; align-items: center; gap: 6px; }
.hero-title   { margin: 0 0 10px; font-size: 1.9rem; line-height: 1.1; letter-spacing: -0.035em; color: var(--color-text-primary); }
.hero-copy    { margin: 0; font-size: 0.95rem; line-height: 1.75; color: var(--color-text-secondary); max-width: 62ch; }
.hero-side    { display: flex; flex-direction: column; gap: 10px; }
.hero-side-card { padding: 14px 15px; border-radius: 14px; border: 1px solid var(--color-border-tertiary); background: rgba(255,255,255,0.72); }
.hero-side-label { font-size: 10px; font-weight: 700; letter-spacing: 0.1em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 4px; }
.hero-side-value { font-size: 1.05rem; font-weight: 800; color: var(--color-text-primary); letter-spacing: -0.02em; }
.hero-side-note  { margin-top: 4px; font-size: 0.82rem; line-height: 1.6; color: var(--color-text-secondary); }

/* ── Member Summary ── */
.member-status {
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
.member-status.safe {
  border-color: rgba(22,163,74,0.30);
  background:
    radial-gradient(circle at top right, rgba(22,163,74,0.16), transparent 35%),
    linear-gradient(135deg, rgba(22,163,74,0.095), rgba(16,185,129,0.045)),
    var(--color-background-secondary);
}
.member-status.warn {
  border-color: rgba(245,158,11,0.36);
  background:
    radial-gradient(circle at top right, rgba(245,158,11,0.18), transparent 35%),
    linear-gradient(135deg, rgba(245,158,11,0.12), rgba(251,191,36,0.055)),
    var(--color-background-secondary);
}
.member-status.critical {
  border-color: rgba(239,68,68,0.32);
  background:
    radial-gradient(circle at top right, rgba(239,68,68,0.16), transparent 35%),
    linear-gradient(135deg, rgba(239,68,68,0.11), rgba(220,38,38,0.05)),
    var(--color-background-secondary);
}
.member-status-label { font-size: 11px; font-weight: 700; letter-spacing: 0.13em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 8px; }
.member-status-title { margin: 0 0 10px; font-size: 1.9rem; line-height: 1.1; letter-spacing: -0.035em; color: var(--color-text-primary); }
.member-status-copy { margin: 0; max-width: 62ch; font-size: 0.95rem; line-height: 1.75; color: var(--color-text-secondary); }
.member-status-action { margin-top: 14px; padding: 12px 14px; border-radius: 14px; border-left: 4px solid rgba(37,99,235,0.38); background: rgba(37,99,235,0.045); font-size: 0.88rem; line-height: 1.65; color: var(--color-text-secondary); }
.member-status.safe .member-status-action { border-left-color: rgba(22,163,74,0.48); background: rgba(22,163,74,0.055); }
.member-status.warn .member-status-action { border-left-color: rgba(245,158,11,0.56); background: rgba(245,158,11,0.065); }
.member-status.critical .member-status-action { border-left-color: rgba(239,68,68,0.50); background: rgba(239,68,68,0.055); }
.member-status-action strong { color: var(--color-text-primary); }
.member-status-metrics { display: flex; flex-direction: column; gap: 10px; }
.member-status-metric { flex: 1; padding: 14px 15px; border-radius: 14px; border: 1px solid var(--color-border-tertiary); background: rgba(255,255,255,0.72); }
.member-status-metric-label { font-size: 10px; font-weight: 700; letter-spacing: 0.1em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 4px; }
.member-status-metric-value { font-size: 1.05rem; font-weight: 800; color: var(--color-text-primary); letter-spacing: -0.02em; }
.member-status-metric-note { margin-top: 4px; font-size: 0.82rem; line-height: 1.6; color: var(--color-text-secondary); }
.member-health { padding: 17px 18px; border-radius: 16px; border: 1px solid var(--color-border-tertiary); background: var(--color-background-secondary); box-shadow: 0 1px 3px rgba(0,0,0,0.035); }
.member-health-head { display: flex; align-items: center; justify-content: space-between; gap: 10px; flex-wrap: wrap; padding-bottom: 12px; margin-bottom: 12px; border-bottom: 1px solid var(--color-border-tertiary); }
.member-health-label { font-size: 10px; font-weight: 850; letter-spacing: 0.11em; text-transform: uppercase; color: var(--color-text-tertiary); }
.member-health-badges { display: flex; align-items: center; gap: 8px; flex-wrap: wrap; }
.member-health-badge { display: inline-flex; align-items: center; gap: 5px; padding: 4px 10px; border-radius: 999px; font-size: 11px; font-weight: 800; border: 1px solid; }
.member-health-badge.safe { background: rgba(22,163,74,0.10); color: #166534; border-color: rgba(22,163,74,0.22); }
.member-health-badge.warn { background: rgba(234,179,8,0.10); color: #854d0e; border-color: rgba(234,179,8,0.26); }
.member-health-badge.critical { background: rgba(220,38,38,0.08); color: #991b1b; border-color: rgba(220,38,38,0.20); }
.member-health-list { display: flex; flex-direction: column; gap: 6px; }
.member-health-row { display: flex; align-items: flex-start; gap: 10px; padding: 9px 10px; border-radius: 10px; font-size: 0.84rem; line-height: 1.55; border: 1px solid transparent; }
.member-health-row.safe { background: rgba(22,163,74,0.045); border-color: rgba(22,163,74,0.12); }
.member-health-row.warn { background: rgba(234,179,8,0.045); border-color: rgba(234,179,8,0.16); }
.member-health-row.critical { background: rgba(220,38,38,0.04); border-color: rgba(220,38,38,0.13); }
.member-health-icon { width: 18px; flex: 0 0 18px; margin-top: 1px; font-size: 14px; line-height: 1.2; text-align: center; }
.member-health-title { font-weight: 850; color: var(--color-text-primary); }
.member-health-copy { color: var(--color-text-secondary); }
.member-health-value { font-weight: 850; color: var(--color-text-primary); }
.member-analysis-grid { display: grid; grid-template-columns: repeat(2, minmax(0,1fr)); gap: 12px; }
.member-analysis-grid.context { grid-template-columns: repeat(4, minmax(0,1fr)); }
.member-analysis-card { padding: 16px; border-radius: 16px; border: 1px solid var(--color-border-tertiary); background: var(--color-background-secondary); }
.member-analysis-card.safe { border-color: rgba(22,163,74,0.24); background: rgba(22,163,74,0.045); }
.member-analysis-card.warn { border-color: rgba(245,158,11,0.28); background: rgba(245,158,11,0.055); }
.member-analysis-card.critical { border-color: rgba(239,68,68,0.24); background: rgba(239,68,68,0.045); }
.member-analysis-card.neutral { border-color: rgba(99,102,241,0.18); background: rgba(99,102,241,0.035); }
.member-analysis-label { font-size: 10px; font-weight: 800; letter-spacing: 0.09em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 6px; }
.member-analysis-title { font-size: 0.98rem; font-weight: 850; color: var(--color-text-primary); line-height: 1.3; margin-bottom: 6px; }
.member-analysis-copy { font-size: 0.84rem; line-height: 1.62; color: var(--color-text-secondary); }
.member-threshold-line { margin-top: 9px; padding-top: 8px; border-top: 1px dashed rgba(100,116,139,0.24); font-size: 0.77rem; line-height: 1.55; color: var(--color-text-tertiary); }
.member-threshold-line strong { color: var(--color-text-primary); }

/* ── KPI Grid ── */
.kpi-grid { display: grid; grid-template-columns: repeat(4, minmax(0,1fr)); gap: 12px; }
.kpi-card { padding: 17px; border-radius: 18px; border: 1.5px solid var(--color-border-tertiary); background: var(--color-background-secondary); box-shadow: 0 1px 4px rgba(0,0,0,0.05); position: relative; overflow: hidden; }
.kpi-card.member    { border-color: rgba(37,99,235,0.18);  background: linear-gradient(145deg, rgba(37,99,235,0.06), rgba(99,102,241,0.03)); }
.kpi-card.orders    { border-color: rgba(16,185,129,0.22); background: linear-gradient(145deg, rgba(16,185,129,0.07), rgba(22,163,74,0.03)); }
.kpi-card.frequency { border-color: rgba(245,158,11,0.22); background: linear-gradient(145deg, rgba(245,158,11,0.07), rgba(251,191,36,0.03)); }
.kpi-card.churn     { border-color: rgba(239,68,68,0.22);  background: linear-gradient(145deg, rgba(239,68,68,0.07), rgba(220,38,38,0.03)); }
.kpi-card.value     { border-color: rgba(20,184,166,0.22); background: linear-gradient(145deg, rgba(20,184,166,0.07), rgba(16,185,129,0.03)); }
.kpi-label { font-size: 10px; font-weight: 700; letter-spacing: 0.1em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 8px; display: flex; align-items: center; gap: 5px; }
.kpi-value { font-size: 1rem; font-weight: 800; color: var(--color-text-primary); letter-spacing: -0.03em; }
.kpi-meta  { margin-top: 6px; font-size: 0.82rem; line-height: 1.6; color: var(--color-text-secondary); }

/* ── Signal Grid ── */
.signal-grid { display: grid; grid-template-columns: repeat(3, minmax(0,1fr)); gap: 14px; }
.signal-card { padding: 18px; border-radius: 16px; border: 1px solid var(--color-border-tertiary); background: var(--color-background-secondary); }
.signal-card.safe     { border-color: rgba(22,163,74,0.25);  background: linear-gradient(135deg, rgba(22,163,74,0.08), rgba(16,185,129,0.03)); }
.signal-card.warn     { border-color: rgba(245,158,11,0.30); background: linear-gradient(135deg, rgba(245,158,11,0.09), rgba(251,191,36,0.03)); }
.signal-card.critical { border-color: rgba(239,68,68,0.25);  background: linear-gradient(135deg, rgba(239,68,68,0.09), rgba(220,38,38,0.03)); }
.signal-card.neutral  { border-color: rgba(99,102,241,0.20); background: linear-gradient(135deg, rgba(99,102,241,0.07), rgba(139,92,246,0.03)); }
.signal-label { font-size: 10px; font-weight: 700; letter-spacing: 0.09em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 6px; display: flex; align-items: center; gap: 5px; }
.signal-title { font-size: 1rem; font-weight: 800; letter-spacing: -0.02em; color: var(--color-text-primary); margin-bottom: 6px; }
.signal-copy  { font-size: 0.9rem; line-height: 1.7; color: var(--color-text-secondary); }


/* ── Overview Action Preview ── */
.overview-action-grid { display: grid; grid-template-columns: repeat(3, minmax(0,1fr)); gap: 12px; }
.overview-action-card {
  padding: 16px 17px;
  border-radius: 16px;
  border-left: 4px solid;
  border-top: 1px solid;
  border-right: 1px solid;
  border-bottom: 1px solid;
  display: flex;
  flex-direction: column;
  gap: 7px;
}
.overview-action-card.critical { border-left-color: #ef4444; border-color: rgba(239,68,68,0.22); background: rgba(239,68,68,0.04); }
.overview-action-card.high     { border-left-color: #f97316; border-color: rgba(249,115,22,0.22); background: rgba(249,115,22,0.04); }
.overview-action-card.moderate { border-left-color: #f59e0b; border-color: rgba(245,158,11,0.22); background: rgba(245,158,11,0.04); }
.overview-action-card.low      { border-left-color: #64748b; border-color: rgba(100,116,139,0.15); background: rgba(100,116,139,0.03); }
.overview-action-top { display: flex; justify-content: space-between; align-items: center; gap: 8px; flex-wrap: wrap; }
.overview-action-rank {
  font-size: 9px;
  font-weight: 800;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  padding: 2px 7px;
  border-radius: 999px;
  background: rgba(0,0,0,0.05);
  color: var(--color-text-tertiary);
}
.overview-action-card.critical .overview-action-rank { background: rgba(239,68,68,0.12); color: #b91c1c; }
.overview-action-card.high .overview-action-rank { background: rgba(249,115,22,0.12); color: #c2410c; }
.overview-action-tag { font-size: 10px; font-weight: 700; color: var(--color-text-tertiary); }
.overview-action-title { font-size: 0.98rem; font-weight: 800; color: var(--color-text-primary); }
.overview-action-metric { font-size: 0.82rem; font-weight: 700; color: var(--color-text-primary); }
.overview-action-copy { font-size: 0.84rem; line-height: 1.6; color: var(--color-text-secondary); }
.overview-action-footer {
  margin-top: 2px;
  padding-top: 8px;
  border-top: 1px solid rgba(128,128,128,0.14);
  font-size: 0.78rem;
  font-weight: 700;
  color: var(--color-text-tertiary);
}

/* ── Analysis Blocks ── */
.analysis-grid { display: grid; grid-template-columns: repeat(3, minmax(0,1fr)); gap: 12px; margin-bottom: 14px; }
.analysis-card {
  padding: 16px 17px;
  border-radius: 16px;
  border: 1px solid rgba(37,99,235,0.14);
  background: linear-gradient(135deg, rgba(37,99,235,0.055), rgba(20,184,166,0.025));
}
.analysis-label { font-size: 10px; font-weight: 800; letter-spacing: 0.1em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 6px; }
.analysis-title { font-size: 0.98rem; font-weight: 800; color: var(--color-text-primary); margin-bottom: 5px; }
.analysis-copy { font-size: 0.86rem; line-height: 1.65; color: var(--color-text-secondary); }

/* ── Section Card ── */
.section-card { padding: 20px; border-radius: 20px; border: 1px solid var(--color-border-tertiary); background: var(--color-background-secondary); box-shadow: 0 1px 3px rgba(0,0,0,0.04); }
.section-head { display: flex; justify-content: space-between; align-items: end; gap: 16px; flex-wrap: wrap; margin-bottom: 14px; }
.section-head.tight { margin-bottom: 10px; }
.section-eyebrow { font-size: 10px; font-weight: 700; letter-spacing: 0.11em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 4px; display: flex; align-items: center; gap: 5px; flex-wrap: wrap; }
.section-title { margin: 0; font-size: 1.12rem; font-weight: 800; letter-spacing: -0.02em; color: var(--color-text-primary); }
.section-copy  { margin: 4px 0 0; font-size: 0.88rem; line-height: 1.7; color: var(--color-text-secondary); max-width: 70ch; }
.timeframe-tag { display: inline-block; padding: 2px 7px; border-radius: 999px; font-size: 10px; font-weight: 700; background: rgba(0,0,0,0.05); color: var(--color-text-tertiary); }
.callout { padding: 13px 15px; border-radius: 12px; border: 1px solid rgba(99,102,241,0.18); background: rgba(99,102,241,0.05); font-size: 0.86rem; line-height: 1.65; color: var(--color-text-secondary); }

.subpage-control {
  display: flex;
  flex-direction: column;
  gap: 8px;
  padding: 14px 16px;
  border-radius: 16px;
  border: 1px solid rgba(99,102,241,0.14);
  background: rgba(99,102,241,0.035);
}
.subpage-label {
  font-size: 10px;
  font-weight: 800;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: var(--color-text-tertiary);
}
.subpage-copy {
  margin-top: -3px;
  font-size: 0.82rem;
  line-height: 1.55;
  color: var(--color-text-secondary);
}
.control-scroll {
  max-width: 100%;
  overflow-x: auto;
  overflow-y: hidden;
  padding-bottom: 2px;
}
.control-scroll > * { min-width: max-content; }

/* ── Retention Queue ── */
.retention-stack { display: flex; flex-direction: column; gap: 10px; }
.retention-card {
  padding: 15px 17px; border-radius: 16px;
  border-left: 4px solid; border-top: 1px solid; border-right: 1px solid; border-bottom: 1px solid;
  display: flex; flex-direction: column; gap: 5px;
}
.retention-card.critical { border-left-color: #ef4444; border-color: rgba(239,68,68,0.22);  background: rgba(239,68,68,0.04); }
.retention-card.high     { border-left-color: #f97316; border-color: rgba(249,115,22,0.22); background: rgba(249,115,22,0.04); }
.retention-card.moderate { border-left-color: #f59e0b; border-color: rgba(245,158,11,0.22); background: rgba(245,158,11,0.04); }
.retention-card.low      { border-left-color: #64748b; border-color: rgba(100,116,139,0.15); background: rgba(100,116,139,0.03); }
.retention-header { display: flex; align-items: center; justify-content: space-between; gap: 10px; flex-wrap: wrap; }
.retention-severity {
  font-size: 9px; font-weight: 800; letter-spacing: 0.1em; text-transform: uppercase;
  padding: 2px 7px; border-radius: 999px; display: inline-block;
}
.retention-card.critical .retention-severity { background: rgba(239,68,68,0.12); color: #b91c1c; }
.retention-card.high     .retention-severity { background: rgba(249,115,22,0.12); color: #c2410c; }
.retention-card.moderate .retention-severity { background: rgba(245,158,11,0.14); color: #b45309; }
.retention-card.low      .retention-severity { background: rgba(100,116,139,0.10); color: #475569; }
.retention-badge { padding: 3px 9px; border-radius: 999px; font-size: 10px; font-weight: 700; background: rgba(0,0,0,0.05); color: var(--color-text-tertiary); }
.retention-title  { font-size: 0.96rem; font-weight: 800; color: var(--color-text-primary); letter-spacing: 0; }
.retention-impact { font-size: 0.82rem; font-weight: 700; padding: 4px 10px; background: rgba(0,0,0,0.04); border-radius: 8px; display: inline-block; color: var(--color-text-primary); }
.retention-rec    { font-size: 0.85rem; line-height: 1.65; color: var(--color-text-secondary); }

/* ── Tier Grid ── */
.tier-grid { display: grid; grid-template-columns: repeat(3, minmax(0,1fr)); gap: 12px; }
.tier-card { padding: 16px 17px; border-radius: 16px; border: 1.5px solid var(--color-border-tertiary); background: var(--color-background-secondary); }
.tier-card.gold   { border-color: rgba(245,158,11,0.35); background: linear-gradient(145deg, rgba(245,158,11,0.09), rgba(251,191,36,0.04)); }
.tier-card.silver { border-color: rgba(148,163,184,0.35); background: linear-gradient(145deg, rgba(148,163,184,0.09), rgba(100,116,139,0.04)); }
.tier-card.bronze { border-color: rgba(180,120,80,0.30); background: linear-gradient(145deg, rgba(180,120,80,0.09), rgba(160,100,60,0.04)); }
.tier-label { font-size: 10px; font-weight: 700; letter-spacing: 0.1em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 4px; }
.tier-title { font-size: 1rem; font-weight: 800; color: var(--color-text-primary); margin-bottom: 6px; }
.tier-value { font-size: 0.93rem; font-weight: 800; color: var(--color-text-primary); }
.tier-copy  { margin-top: 5px; font-size: 0.82rem; line-height: 1.55; color: var(--color-text-secondary); }

/* ── Segment Grid ── */
.segment-grid { display: grid; grid-template-columns: repeat(3, minmax(0,1fr)); gap: 11px; }
.segment-card { padding: 13px 15px; border-radius: 14px; border: 1px solid var(--color-border-tertiary); background: var(--color-background-secondary); }

/* ── Strategic snapshots ── */
.snapshot-grid { display: grid; grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 10px; }
.snapshot-card {
  padding: 14px 15px; border-radius: 16px;
  border: 1px solid var(--color-border-tertiary);
  background: var(--color-background-secondary);
}
.snapshot-card.safe    { border-color: rgba(22,163,74,0.22);  background: linear-gradient(145deg, rgba(22,163,74,0.07), rgba(16,185,129,0.03)); }
.snapshot-card.warn    { border-color: rgba(245,158,11,0.24); background: linear-gradient(145deg, rgba(245,158,11,0.08), rgba(251,191,36,0.03)); }
.snapshot-card.info    { border-color: rgba(59,130,246,0.22); background: linear-gradient(145deg, rgba(59,130,246,0.07), rgba(37,99,235,0.03)); }
.snapshot-card.danger  { border-color: rgba(239,68,68,0.22);  background: linear-gradient(145deg, rgba(239,68,68,0.07), rgba(220,38,38,0.03)); }
.snapshot-card.gold    { border-color: rgba(245,158,11,0.35); background: linear-gradient(145deg, rgba(245,158,11,0.09), rgba(251,191,36,0.04)); }
.snapshot-card.silver  { border-color: rgba(148,163,184,0.35); background: linear-gradient(145deg, rgba(148,163,184,0.09), rgba(100,116,139,0.04)); }
.snapshot-card.bronze  { border-color: rgba(180,120,80,0.30); background: linear-gradient(145deg, rgba(180,120,80,0.09), rgba(160,100,60,0.04)); }
.snapshot-label { font-size: 10px; font-weight: 800; letter-spacing: 0.1em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 6px; }
.snapshot-value { font-size: 1.12rem; font-weight: 900; color: var(--color-text-primary); letter-spacing: 0; }
.snapshot-copy  { margin-top: 4px; font-size: 0.8rem; line-height: 1.55; color: var(--color-text-secondary); }

/* ── Responsive ── */
@media (max-width: 900px) {
  .period-strip, .kpi-grid, .signal-grid, .overview-action-grid, .analysis-grid, .member-analysis-grid, .member-analysis-grid.context, .tier-grid, .segment-grid, .info-grid, .snapshot-grid {
    grid-template-columns: 1fr;
  }
  .hero, .member-status { grid-template-columns: 1fr; }
  .kpi-grid { grid-template-columns: repeat(2, 1fr); }
  .signal-grid, .overview-action-grid, .analysis-grid, .member-analysis-grid, .info-grid, .snapshot-grid { grid-template-columns: repeat(2, 1fr); }
  .tier-grid { grid-template-columns: repeat(2, 1fr); }
}
@media (max-width: 600px) {
  .period-strip, .kpi-grid, .signal-grid, .overview-action-grid, .analysis-grid, .member-analysis-grid, .member-analysis-grid.context, .tier-grid, .segment-grid, .info-grid, .snapshot-grid { grid-template-columns: 1fr; }
}
</style>


```sql member_dates
SELECT
    strftime('%d %b %Y', MAX(order_date))                        AS tgl_akhir,
    strftime('%d %b %Y', MAX(order_date) - INTERVAL '29 days')  AS tgl_30_awal,
    strftime('%d %b %Y', MAX(order_date) - INTERVAL '89 days')  AS tgl_90_awal,
    strftime('%d %b %Y', MAX(order_date) - INTERVAL '179 days') AS tgl_180_awal
FROM restaurant.member_purchase_behavior
```

```sql member_health_overview
WITH max_d AS (SELECT MAX(order_date) AS d FROM restaurant.member_purchase_behavior),
members AS (
    SELECT member_id, member_name, tier, city, join_date
    FROM restaurant.dim_members
),
last_order AS (
    SELECT member_id, MAX(order_date) AS last_order_date
    FROM restaurant.member_purchase_behavior CROSS JOIN max_d
    WHERE order_date <= d
    GROUP BY member_id
),
member_state AS (
    SELECT
        m.member_id,
        m.member_name,
        m.tier,
        m.city,
        m.join_date,
        l.last_order_date,
        COALESCE(DATEDIFF('day', l.last_order_date, d), 9999) AS recency_days,
        CASE
            WHEN m.tier='Gold' AND COALESCE(DATEDIFF('day', l.last_order_date, d), 9999) >= 14 THEN 1
            WHEN m.tier='Silver' AND COALESCE(DATEDIFF('day', l.last_order_date, d), 9999) >= 21 THEN 1
            WHEN m.tier='Bronze' AND COALESCE(DATEDIFF('day', l.last_order_date, d), 9999) >= 30 THEN 1
            ELSE 0
        END AS is_churn_risk
    FROM members m
    CROSS JOIN max_d
    LEFT JOIN last_order l ON m.member_id = l.member_id
),
curr_30 AS (
    SELECT member_id,
        SUM(total_orders) AS orders,
        SUM(total_spend)  AS spend
    FROM restaurant.member_purchase_behavior CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '29 days'
    GROUP BY member_id
),
prev_30 AS (
    SELECT member_id,
        SUM(total_orders) AS orders,
        SUM(total_spend)  AS spend
    FROM restaurant.member_purchase_behavior CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '59 days'
      AND order_date <  d - INTERVAL '29 days'
    GROUP BY member_id
),
curr_90 AS (
    SELECT member_id,
        SUM(total_orders) AS orders,
        SUM(total_spend)  AS spend
    FROM restaurant.member_purchase_behavior CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '89 days'
    GROUP BY member_id
),
prev_90 AS (
    SELECT member_id,
        SUM(total_orders) AS orders,
        SUM(total_spend)  AS spend
    FROM restaurant.member_purchase_behavior CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '179 days'
      AND order_date <  d - INTERVAL '89 days'
    GROUP BY member_id
),
agg_30 AS (
    SELECT
        COUNT(CASE WHEN COALESCE(c.orders,0)>0 THEN 1 END) AS active,
        SUM(COALESCE(c.orders,0)) AS tot_orders,
        SUM(COALESCE(c.spend,0)) AS tot_spend,
        ROUND(SUM(COALESCE(c.spend,0))/NULLIF(SUM(COALESCE(c.orders,0)),0),0) AS aov,
        ROUND(SUM(COALESCE(c.orders,0))*1.0/NULLIF(COUNT(CASE WHEN COALESCE(c.orders,0)>0 THEN 1 END),0)/4.29,2) AS freq_pw,
        SUM(ms.is_churn_risk) AS churn,
        SUM(CASE WHEN ms.tier='Gold' AND ms.is_churn_risk=1 THEN 1 ELSE 0 END) AS gold_churn
    FROM member_state ms
    LEFT JOIN curr_30 c ON ms.member_id = c.member_id
),
comp_30 AS (
    SELECT
        ROUND((SUM(COALESCE(c.spend,0))/NULLIF(SUM(COALESCE(c.orders,0)),0) - SUM(COALESCE(p.spend,0))/NULLIF(SUM(COALESCE(p.orders,0)),0))
            / NULLIF(SUM(COALESCE(p.spend,0))/NULLIF(SUM(COALESCE(p.orders,0)),0),0)*100,1) AS aov_chg,
        ROUND((SUM(COALESCE(c.orders,0))*1.0/NULLIF(COUNT(CASE WHEN COALESCE(c.orders,0)>0 THEN 1 END),0)
            - SUM(COALESCE(p.orders,0))*1.0/NULLIF(COUNT(CASE WHEN COALESCE(p.orders,0)>0 THEN 1 END),0))
            / NULLIF(SUM(COALESCE(p.orders,0))*1.0/NULLIF(COUNT(CASE WHEN COALESCE(p.orders,0)>0 THEN 1 END),0),0)*100,1) AS freq_chg
    FROM member_state ms
    LEFT JOIN curr_30 c ON ms.member_id=c.member_id
    LEFT JOIN prev_30 p ON ms.member_id=p.member_id
),
agg_90 AS (
    SELECT
        COUNT(CASE WHEN COALESCE(c.orders,0)>0 THEN 1 END) AS active,
        SUM(COALESCE(c.orders,0)) AS tot_orders,
        SUM(COALESCE(c.spend,0)) AS tot_spend,
        ROUND(SUM(COALESCE(c.spend,0))/NULLIF(SUM(COALESCE(c.orders,0)),0),0) AS aov,
        ROUND(SUM(COALESCE(c.orders,0))*1.0/NULLIF(COUNT(CASE WHEN COALESCE(c.orders,0)>0 THEN 1 END),0)/12.86,2) AS freq_pw,
        SUM(ms.is_churn_risk) AS churn,
        SUM(CASE WHEN ms.tier='Gold' AND ms.is_churn_risk=1 THEN 1 ELSE 0 END) AS gold_churn
    FROM member_state ms
    LEFT JOIN curr_90 c ON ms.member_id = c.member_id
),
comp_90 AS (
    SELECT
        ROUND((SUM(COALESCE(c.spend,0))/NULLIF(SUM(COALESCE(c.orders,0)),0) - SUM(COALESCE(p.spend,0))/NULLIF(SUM(COALESCE(p.orders,0)),0))
            / NULLIF(SUM(COALESCE(p.spend,0))/NULLIF(SUM(COALESCE(p.orders,0)),0),0)*100,1) AS aov_chg,
        ROUND((SUM(COALESCE(c.orders,0))*1.0/NULLIF(COUNT(CASE WHEN COALESCE(c.orders,0)>0 THEN 1 END),0)
            - SUM(COALESCE(p.orders,0))*1.0/NULLIF(COUNT(CASE WHEN COALESCE(p.orders,0)>0 THEN 1 END),0))
            / NULLIF(SUM(COALESCE(p.orders,0))*1.0/NULLIF(COUNT(CASE WHEN COALESCE(p.orders,0)>0 THEN 1 END),0),0)*100,1) AS freq_chg
    FROM member_state ms
    LEFT JOIN curr_90 c ON ms.member_id=c.member_id
    LEFT JOIN prev_90 p ON ms.member_id=p.member_id
),
cohort_agg AS (
    SELECT
        DATE_TRUNC('month', join_date)                                              AS cb,
        ROUND(SUM(total_orders)*1.0/NULLIF(COUNT(DISTINCT member_id),0)/12.86, 2) AS fw,
        ROUND(SUM(total_spend)/NULLIF(COUNT(DISTINCT member_id),0), 0)            AS av
    FROM restaurant.member_purchase_behavior CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '89 days'
    GROUP BY DATE_TRUNC('month', join_date)
),
cohort_stats AS (
    SELECT
        MAX(CASE WHEN cb = (SELECT MAX(cb) FROM cohort_agg) THEN fw END) AS newest_freq,
        MAX(CASE WHEN cb = (SELECT MAX(cb) FROM cohort_agg) THEN av  END) AS newest_value,
        ROUND(AVG(fw),2) AS avg_freq,
        ROUND(AVG(av),0) AS avg_value
    FROM cohort_agg
)
SELECT
    a3.active      AS active_30d,
    a3.tot_orders  AS orders_30d,
    a3.tot_spend   AS spend_30d,
    a3.aov         AS aov_30d,
    a3.freq_pw     AS freq_30d,
    a3.churn       AS churn_30d,
    a3.gold_churn  AS gold_churn_30d,
    c3.aov_chg     AS aov_change_30d,
    c3.freq_chg    AS freq_change_30d,
    CASE
        WHEN a3.gold_churn>=3 OR c3.freq_chg<=-25 OR c3.aov_chg<=-20 THEN 'Kritis'
        WHEN a3.gold_churn>=1 OR a3.churn>=5 OR c3.freq_chg<=-10 OR c3.aov_chg<=-10 THEN 'Waspada'
        ELSE 'Sehat'
    END AS status_30d,
    CASE
        WHEN a3.gold_churn>=1    THEN 'Churn risk'
        WHEN c3.freq_chg<=-10   THEN 'Frekuensi turun'
        WHEN c3.aov_chg<=-10    THEN 'Value turun'
        WHEN a3.active < 5       THEN 'Aktivasi rendah'
        ELSE 'Loyalitas sehat'
    END AS focus_30d,
    a9.active      AS active_90d,
    a9.tot_orders  AS orders_90d,
    a9.tot_spend   AS spend_90d,
    a9.aov         AS aov_90d,
    a9.freq_pw     AS freq_90d,
    a9.churn       AS churn_90d,
    a9.gold_churn  AS gold_churn_90d,
    c9.aov_chg     AS aov_change_90d,
    c9.freq_chg    AS freq_change_90d,
    CASE
        WHEN a9.gold_churn>=3 OR c9.freq_chg<=-25 OR c9.aov_chg<=-20 THEN 'Kritis'
        WHEN a9.gold_churn>=1 OR a9.churn>=5 OR c9.freq_chg<=-10 OR c9.aov_chg<=-10 THEN 'Waspada'
        ELSE 'Sehat'
    END AS status_90d,
    CASE
        WHEN a9.gold_churn>=1    THEN 'Churn risk'
        WHEN c9.freq_chg<=-10   THEN 'Frekuensi turun'
        WHEN c9.aov_chg<=-10    THEN 'Value turun'
        WHEN a9.active < 5       THEN 'Aktivasi rendah'
        ELSE 'Loyalitas sehat'
    END AS focus_90d,
    cs.newest_freq  AS cohort_newest_freq,
    cs.avg_freq     AS cohort_avg_freq,
    cs.newest_value AS cohort_newest_value,
    cs.avg_value    AS cohort_avg_value,
    CASE WHEN cs.newest_freq >= cs.avg_freq THEN 'Sehat' ELSE 'Waspada' END AS cohort_status,
    CASE WHEN cs.newest_freq < cs.avg_freq
        THEN 'Kualitas cohort baru menurun'
        ELSE 'Cohort baru berkualitas baik'
    END AS cohort_focus
FROM agg_30 a3, comp_30 c3, agg_90 a9, comp_90 c9, cohort_stats cs
```

```sql member_kpi_period
WITH max_d AS (SELECT MAX(order_date) AS d FROM restaurant.member_purchase_behavior),
members AS (
    SELECT member_id, tier, join_date
    FROM restaurant.dim_members
),
last_order AS (
    SELECT member_id, MAX(order_date) AS last_order_date
    FROM restaurant.member_purchase_behavior CROSS JOIN max_d
    WHERE order_date <= d
    GROUP BY member_id
),
member_state AS (
    SELECT
        m.member_id,
        m.tier,
        m.join_date,
        COALESCE(DATEDIFF('day', l.last_order_date, d), 9999) AS recency_days,
        CASE
            WHEN m.tier='Gold' AND COALESCE(DATEDIFF('day', l.last_order_date, d), 9999) >= 14 THEN 1
            WHEN m.tier='Silver' AND COALESCE(DATEDIFF('day', l.last_order_date, d), 9999) >= 21 THEN 1
            WHEN m.tier='Bronze' AND COALESCE(DATEDIFF('day', l.last_order_date, d), 9999) >= 30 THEN 1
            ELSE 0
        END AS is_churn_risk
    FROM members m
    CROSS JOIN max_d
    LEFT JOIN last_order l ON m.member_id = l.member_id
),
curr_30 AS (
    SELECT member_id,
        SUM(total_orders) AS orders, SUM(total_spend) AS spend
    FROM restaurant.member_purchase_behavior CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '29 days'
    GROUP BY member_id
),
curr_90 AS (
    SELECT member_id,
        SUM(total_orders) AS orders, SUM(total_spend) AS spend
    FROM restaurant.member_purchase_behavior CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '89 days'
    GROUP BY member_id
),
all_orders_30 AS (
    SELECT SUM(total_orders) AS total_restaurant_orders
    FROM restaurant.daily_revenue CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '29 days'
      AND order_date <= d
),
all_orders_90 AS (
    SELECT SUM(total_orders) AS total_restaurant_orders
    FROM restaurant.daily_revenue CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '89 days'
      AND order_date <= d
)
SELECT '30d' AS period,
    COUNT(*) AS total_members,
    COUNT(CASE WHEN COALESCE(c.orders,0)>0 THEN 1 END) AS active_members,
    ROUND(COUNT(CASE WHEN COALESCE(c.orders,0)>0 THEN 1 END)*100.0/NULLIF(COUNT(*),0),1) AS active_rate_pct,
    SUM(CASE WHEN ms.join_date >= (SELECT d FROM max_d) - INTERVAL '29 days' THEN 1 ELSE 0 END) AS new_members,
    SUM(COALESCE(c.orders,0)) AS total_member_orders,
    MAX(a.total_restaurant_orders) AS total_restaurant_orders,
    ROUND(SUM(COALESCE(c.orders,0))*100.0/NULLIF(MAX(a.total_restaurant_orders),0),1) AS pct_order_member,
    SUM(COALESCE(c.spend,0)) AS total_member_spend,
    ROUND(SUM(COALESCE(c.spend,0))/NULLIF(SUM(COALESCE(c.orders,0)),0),0) AS avg_order_value,
    ROUND(SUM(COALESCE(c.orders,0))*1.0/NULLIF(COUNT(CASE WHEN COALESCE(c.orders,0)>0 THEN 1 END),0)/4.29,2) AS avg_orders_per_member,
    ROUND(SUM(COALESCE(c.orders,0))*1.0/NULLIF(COUNT(CASE WHEN COALESCE(c.orders,0)>0 THEN 1 END),0)/4.29,2) AS orders_per_member_per_week,
    SUM(ms.is_churn_risk) AS churn_risk_count,
    SUM(CASE WHEN ms.tier='Gold' AND ms.is_churn_risk=1 THEN 1 ELSE 0 END) AS gold_churn_risk
FROM member_state ms
CROSS JOIN all_orders_30 a
LEFT JOIN curr_30 c ON ms.member_id = c.member_id
UNION ALL
SELECT '90d' AS period,
    COUNT(*) AS total_members,
    COUNT(CASE WHEN COALESCE(c.orders,0)>0 THEN 1 END) AS active_members,
    ROUND(COUNT(CASE WHEN COALESCE(c.orders,0)>0 THEN 1 END)*100.0/NULLIF(COUNT(*),0),1) AS active_rate_pct,
    SUM(CASE WHEN ms.join_date >= (SELECT d FROM max_d) - INTERVAL '89 days' THEN 1 ELSE 0 END) AS new_members,
    SUM(COALESCE(c.orders,0)) AS total_member_orders,
    MAX(a.total_restaurant_orders) AS total_restaurant_orders,
    ROUND(SUM(COALESCE(c.orders,0))*100.0/NULLIF(MAX(a.total_restaurant_orders),0),1) AS pct_order_member,
    SUM(COALESCE(c.spend,0)) AS total_member_spend,
    ROUND(SUM(COALESCE(c.spend,0))/NULLIF(SUM(COALESCE(c.orders,0)),0),0) AS avg_order_value,
    ROUND(SUM(COALESCE(c.orders,0))*1.0/NULLIF(COUNT(CASE WHEN COALESCE(c.orders,0)>0 THEN 1 END),0)/12.86,2) AS avg_orders_per_member,
    ROUND(SUM(COALESCE(c.orders,0))*1.0/NULLIF(COUNT(CASE WHEN COALESCE(c.orders,0)>0 THEN 1 END),0)/12.86,2) AS orders_per_member_per_week,
    SUM(ms.is_churn_risk) AS churn_risk_count,
    SUM(CASE WHEN ms.tier='Gold' AND ms.is_churn_risk=1 THEN 1 ELSE 0 END) AS gold_churn_risk
FROM member_state ms
CROSS JOIN all_orders_90 a
LEFT JOIN curr_90 c ON ms.member_id = c.member_id
```

```sql member_activity_mix
WITH max_d AS (SELECT MAX(order_date) AS d FROM restaurant.member_purchase_behavior),
members AS (
    SELECT member_id
    FROM restaurant.dim_members
),
activity AS (
    SELECT
        m.member_id,
        MAX(CASE WHEN p.order_date >= d - INTERVAL '89 days' THEN 1 ELSE 0 END) AS active_90d
    FROM members m
    CROSS JOIN max_d
    LEFT JOIN restaurant.member_purchase_behavior p
        ON m.member_id = p.member_id
       AND p.order_date <= d
       AND p.order_date >= d - INTERVAL '89 days'
    GROUP BY m.member_id
),
status_dim AS (
    SELECT 'Aktif' AS status
    UNION ALL
    SELECT 'Belum aktif' AS status
),
raw_status AS (
    SELECT
        CASE WHEN active_90d = 1 THEN 'Aktif' ELSE 'Belum aktif' END AS status,
        COUNT(*) AS member_count
    FROM activity
    GROUP BY 1
),
status_mix AS (
    SELECT
        s.status,
        COALESCE(r.member_count, 0) AS member_count
    FROM status_dim s
    LEFT JOIN raw_status r USING (status)
),
totals AS (
    SELECT SUM(member_count) AS total_members
    FROM status_mix
)
SELECT
    status,
    member_count,
    ROUND(member_count * 100.0 / NULLIF(total_members, 0), 1) AS pct_members
FROM status_mix, totals
ORDER BY CASE status WHEN 'Aktif' THEN 1 ELSE 2 END
```

```sql retention_queue
WITH max_d AS (SELECT MAX(order_date) AS d FROM restaurant.member_purchase_behavior),
members AS (
    SELECT member_id, member_name, tier, city
    FROM restaurant.dim_members
),
orders_180 AS (
    SELECT member_id,
        SUM(total_orders) AS total_orders_180,
        SUM(total_spend) AS total_spend_180,
        ROUND(SUM(total_orders)/25.71,1) AS orders_per_week_180,
        ROUND(SUM(total_spend)/NULLIF(SUM(total_orders),0),0) AS avg_order_value_180
    FROM restaurant.member_purchase_behavior CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '179 days'
    GROUP BY member_id
),
visit_days AS (
    SELECT DISTINCT member_id, order_date
    FROM restaurant.member_purchase_behavior CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '179 days'
      AND order_date <= d
),
visit_gaps AS (
    SELECT
        member_id,
        order_date,
        DATEDIFF('day', LAG(order_date) OVER (PARTITION BY member_id ORDER BY order_date), order_date) AS gap_days
    FROM visit_days
),
visit_rhythm AS (
    SELECT
        member_id,
        COUNT(*) AS visit_days_180,
        ROUND(AVG(gap_days),1) AS avg_visit_interval_days
    FROM visit_gaps
    GROUP BY member_id
),
last_order AS (
    SELECT member_id, MAX(order_date) AS last_order_date
    FROM restaurant.member_purchase_behavior CROSS JOIN max_d
    WHERE order_date <= d
    GROUP BY member_id
),
base AS (
    SELECT
        m.member_name, m.tier, m.city,
        COALESCE(o.total_orders_180,0) AS total_orders,
        COALESCE(o.orders_per_week_180,0) AS orders_per_week,
        COALESCE(o.total_spend_180,0) AS total_spend,
        COALESCE(o.avg_order_value_180,0) AS avg_order_value,
        COALESCE(r.visit_days_180,0) AS visit_days_180,
        r.avg_visit_interval_days,
        COALESCE(DATEDIFF('day', l.last_order_date, d), 9999) AS recency_days,
        CASE
            WHEN r.avg_visit_interval_days IS NULL THEN NULL
            ELSE ROUND(COALESCE(DATEDIFF('day', l.last_order_date, d), 9999) - r.avg_visit_interval_days, 1)
        END AS delay_days
    FROM members m
    CROSS JOIN max_d
    LEFT JOIN orders_180 o ON m.member_id = o.member_id
    LEFT JOIN visit_rhythm r ON m.member_id = r.member_id
    LEFT JOIN last_order l ON m.member_id = l.member_id
),
spend_p75 AS (
    SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_spend) AS p75
    FROM base WHERE total_spend > 0
),
gold_risk AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY delay_days DESC NULLS LAST, total_spend DESC) AS rn,
        CASE WHEN recency_days >= 21 OR delay_days >= 14 THEN 'Kritis' ELSE 'Tinggi' END AS severity,
        'Gold Churn Risk'  AS action_type,
        'Gold mulai jarang kembali' AS action_label,
        'Hubungi personal, beri apresiasi khusus' AS action_short,
        member_name, tier, city,
        total_spend,
        avg_order_value,
        orders_per_week,
        recency_days,
        delay_days,
        CAST(recency_days AS VARCHAR) || ' hari tidak transaksi' AS metric_value,
        CASE
            WHEN avg_visit_interval_days IS NULL THEN 'Ritme normal belum cukup histori.'
            WHEN delay_days > 0 THEN 'Biasanya tiap ' || CAST(avg_visit_interval_days AS VARCHAR) || ' hari; sekarang telat ' || CAST(delay_days AS VARCHAR) || ' hari dari ritme normal.'
            ELSE 'Masih dalam ritme kunjungan normal.'
        END AS rhythm_text,
        'Member Gold bernilai tinggi mulai berisiko churn.' AS impact_text,
        'Hubungi personal via WhatsApp/telepon. Beri apresiasi khusus, akses reservasi, atau perhatian personal.' AS recommended_action
    FROM base
    WHERE tier = 'Gold' AND recency_days >= 14
),
hv_inactive AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY delay_days DESC NULLS LAST, total_spend DESC) AS rn,
        'Tinggi'            AS severity,
        'High-Value Inactive' AS action_type,
        'Member bernilai tinggi tidak aktif' AS action_label,
        'Kirim win-back personal' AS action_short,
        member_name, tier, city,
        total_spend,
        avg_order_value,
        orders_per_week,
        recency_days,
        delay_days,
        CAST(recency_days AS VARCHAR) || ' hari · Rp' || CAST(ROUND(total_spend/1000000.0,1) AS VARCHAR) || 'jt' AS metric_value,
        CASE
            WHEN avg_visit_interval_days IS NULL THEN 'Ritme normal belum cukup histori.'
            WHEN delay_days > 0 THEN 'Biasanya tiap ' || CAST(avg_visit_interval_days AS VARCHAR) || ' hari; sekarang telat ' || CAST(delay_days AS VARCHAR) || ' hari dari ritme normal.'
            ELSE 'Masih dalam ritme kunjungan normal.'
        END AS rhythm_text,
        'Member dengan belanja besar tapi sudah lama tidak aktif.' AS impact_text,
        'Kirim pesan win-back dengan penawaran personalisasi.' AS recommended_action
    FROM base, spend_p75
    WHERE tier IN ('Silver','Bronze')
      AND recency_days >= 21
      AND total_spend > spend_p75.p75
      AND total_spend > 0
)
SELECT
    severity,
    action_type,
    action_label,
    action_short,
    member_name,
    tier,
    city,
    CAST(recency_days AS VARCHAR) || ' hari lalu' AS last_order_label,
    CASE
        WHEN delay_days IS NULL THEN 'Belum cukup histori'
        WHEN delay_days > 0 THEN CAST(delay_days AS VARCHAR) || ' hari'
        ELSE 'Masih sesuai ritme'
    END AS delay_label,
    total_spend,
    avg_order_value,
    orders_per_week,
    metric_value,
    rhythm_text,
    impact_text,
    recommended_action
FROM (
    SELECT severity, action_type, action_label, action_short, member_name, tier, city, total_spend, avg_order_value, orders_per_week, recency_days, delay_days, metric_value, rhythm_text, impact_text, recommended_action, rn FROM gold_risk
    UNION ALL
    SELECT severity, action_type, action_label, action_short, member_name, tier, city, total_spend, avg_order_value, orders_per_week, recency_days, delay_days, metric_value, rhythm_text, impact_text, recommended_action, rn FROM hv_inactive
)
ORDER BY
    CASE severity WHEN 'Kritis' THEN 1 WHEN 'Tinggi' THEN 2 ELSE 3 END,
    CASE action_type WHEN 'Gold Churn Risk' THEN 1 ELSE 2 END,
    rn
```

```sql member_risk_snapshot
WITH max_d AS (SELECT MAX(order_date) AS d FROM restaurant.member_purchase_behavior),
members AS (
    SELECT member_id, member_name, tier, city
    FROM restaurant.dim_members
),
orders_180 AS (
    SELECT member_id,
        SUM(total_orders) AS total_orders_180,
        SUM(total_spend) AS total_spend_180
    FROM restaurant.member_purchase_behavior CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '179 days'
    GROUP BY member_id
),
last_order AS (
    SELECT member_id, MAX(order_date) AS last_order_date
    FROM restaurant.member_purchase_behavior CROSS JOIN max_d
    WHERE order_date <= d
    GROUP BY member_id
),
base AS (
    SELECT
        m.member_id, m.tier,
        COALESCE(o.total_spend_180,0) AS total_spend_180,
        COALESCE(DATEDIFF('day', l.last_order_date, d), 9999) AS recency_days,
        CASE
            WHEN m.tier='Gold' AND COALESCE(DATEDIFF('day', l.last_order_date, d), 9999) >= 14 THEN 1
            WHEN m.tier='Silver' AND COALESCE(DATEDIFF('day', l.last_order_date, d), 9999) >= 21 THEN 1
            WHEN m.tier='Bronze' AND COALESCE(DATEDIFF('day', l.last_order_date, d), 9999) >= 30 THEN 1
            ELSE 0
        END AS is_churn_risk
    FROM members m
    CROSS JOIN max_d
    LEFT JOIN orders_180 o ON m.member_id = o.member_id
    LEFT JOIN last_order l ON m.member_id = l.member_id
),
spend_p75 AS (
    SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_spend_180) AS p75
    FROM base
    WHERE total_spend_180 > 0
)
SELECT
    COUNT(*) AS total_members,
    SUM(is_churn_risk) AS churn_risk_members,
    ROUND(SUM(is_churn_risk)*100.0/NULLIF(COUNT(*),0),1) AS churn_risk_pct,
    SUM(CASE WHEN tier='Gold' AND is_churn_risk=1 THEN 1 ELSE 0 END) AS gold_churn_risk,
    SUM(CASE WHEN tier='Silver' AND is_churn_risk=1 THEN 1 ELSE 0 END) AS silver_churn_risk,
    SUM(CASE WHEN tier='Bronze' AND is_churn_risk=1 THEN 1 ELSE 0 END) AS bronze_churn_risk,
    SUM(CASE WHEN tier IN ('Silver','Bronze')
              AND recency_days >= 21
              AND total_spend_180 > (SELECT p75 FROM spend_p75)
             THEN 1 ELSE 0 END) AS high_value_inactive
FROM base
```

```sql retention_risk_by_tier
WITH max_d AS (SELECT MAX(order_date) AS d FROM restaurant.member_purchase_behavior),
members AS (
    SELECT member_id, member_name, tier, city
    FROM restaurant.dim_members
),
last_order AS (
    SELECT member_id, MAX(order_date) AS last_order_date
    FROM restaurant.member_purchase_behavior CROSS JOIN max_d
    WHERE order_date <= d
    GROUP BY member_id
),
orders_180 AS (
    SELECT member_id,
        SUM(total_orders) AS total_orders_180,
        SUM(total_spend) AS total_spend_180
    FROM restaurant.member_purchase_behavior CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '179 days'
    GROUP BY member_id
),
visit_days AS (
    SELECT DISTINCT member_id, order_date
    FROM restaurant.member_purchase_behavior CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '179 days'
      AND order_date <= d
),
visit_gaps AS (
    SELECT
        member_id,
        order_date,
        DATEDIFF('day', LAG(order_date) OVER (PARTITION BY member_id ORDER BY order_date), order_date) AS gap_days
    FROM visit_days
),
visit_rhythm AS (
    SELECT
        member_id,
        COUNT(*) AS visit_days_180,
        ROUND(AVG(gap_days),1) AS avg_visit_interval_days
    FROM visit_gaps
    GROUP BY member_id
),
base AS (
    SELECT
        m.member_id,
        m.tier,
        COALESCE(o.total_orders_180,0) AS total_orders_180,
        COALESCE(o.total_spend_180,0) AS total_spend_180,
        COALESCE(r.visit_days_180,0) AS visit_days_180,
        r.avg_visit_interval_days,
        COALESCE(DATEDIFF('day', l.last_order_date, d), 9999) AS recency_days,
        CASE
            WHEN r.avg_visit_interval_days IS NULL THEN NULL
            ELSE ROUND(COALESCE(DATEDIFF('day', l.last_order_date, d), 9999) - r.avg_visit_interval_days, 1)
        END AS delay_days,
        CASE
            WHEN m.tier='Gold' AND COALESCE(DATEDIFF('day', l.last_order_date, d), 9999) >= 14 THEN 1
            WHEN m.tier='Silver' AND COALESCE(DATEDIFF('day', l.last_order_date, d), 9999) >= 21 THEN 1
            WHEN m.tier='Bronze' AND COALESCE(DATEDIFF('day', l.last_order_date, d), 9999) >= 30 THEN 1
            ELSE 0
        END AS is_churn_risk
    FROM members m
    CROSS JOIN max_d
    LEFT JOIN last_order l ON m.member_id = l.member_id
    LEFT JOIN orders_180 o ON m.member_id = o.member_id
    LEFT JOIN visit_rhythm r ON m.member_id = r.member_id
)
SELECT
    tier,
    COUNT(*) AS total_members,
    SUM(is_churn_risk) AS churn_risk_members,
    ROUND(SUM(is_churn_risk)*100.0/NULLIF(COUNT(*),0),1) AS churn_risk_pct,
    ROUND(AVG(CASE WHEN recency_days < 9999 THEN recency_days END),1) AS avg_recency_days,
    ROUND(AVG(CASE WHEN is_churn_risk=1 AND avg_visit_interval_days IS NOT NULL THEN avg_visit_interval_days END),1) AS avg_visit_interval_days,
    ROUND(AVG(CASE WHEN is_churn_risk=1 AND delay_days IS NOT NULL THEN delay_days END),1) AS avg_delay_days,
    SUM(CASE WHEN is_churn_risk=1 AND delay_days > 0 THEN 1 ELSE 0 END) AS delayed_beyond_rhythm,
    SUM(CASE WHEN is_churn_risk=1 AND avg_visit_interval_days IS NOT NULL THEN 1 ELSE 0 END) AS rhythm_known_members,
    SUM(total_orders_180) AS orders_180d,
    SUM(total_spend_180) AS spend_180d,
    ROUND(SUM(total_spend_180)/NULLIF(SUM(total_orders_180),0),0) AS avg_order_value_180d
FROM base
GROUP BY tier
ORDER BY CASE tier WHEN 'Gold' THEN 1 WHEN 'Silver' THEN 2 ELSE 3 END
```

```sql tier_economics_90d
WITH max_d AS (SELECT MAX(order_date) AS d FROM restaurant.member_purchase_behavior),
base AS (
    SELECT member_id, tier,
        SUM(total_orders) AS orders,
        SUM(total_spend)  AS spend
    FROM restaurant.member_purchase_behavior CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '89 days'
    GROUP BY member_id, tier
),
totals AS (SELECT SUM(spend) AS tot FROM base)
SELECT tier,
    COUNT(DISTINCT member_id)                                                     AS active_members,
    SUM(orders)                                                                    AS total_orders,
    SUM(spend)                                                                     AS total_spend,
    ROUND(SUM(spend)/NULLIF(SUM(orders),0),0)                                     AS avg_order_value,
    ROUND(SUM(orders)*1.0/NULLIF(COUNT(DISTINCT member_id),0),1)                  AS orders_per_member,
    ROUND(SUM(orders)*1.0/NULLIF(COUNT(DISTINCT member_id),0)/12.86,2)            AS orders_per_member_per_week,
    ROUND(SUM(spend)/NULLIF(COUNT(DISTINCT member_id),0),0)                       AS spend_per_member,
    ROUND(SUM(spend)*100.0/NULLIF(t.tot,0),1)                                     AS pct_spend,
    ROUND(COUNT(DISTINCT member_id)*100.0/NULLIF(SUM(COUNT(DISTINCT member_id)) OVER (),0),1) AS pct_members
FROM base, totals t
GROUP BY tier, t.tot
ORDER BY total_spend DESC
```

```sql tier_movement_90d
WITH max_d AS (SELECT MAX(order_date) AS d FROM restaurant.member_purchase_behavior),
curr AS (
    SELECT tier, member_id, SUM(total_spend) AS spend, SUM(total_orders) AS orders
    FROM restaurant.member_purchase_behavior CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '89 days'
    GROUP BY tier, member_id
),
prev AS (
    SELECT tier, member_id, SUM(total_spend) AS spend, SUM(total_orders) AS orders
    FROM restaurant.member_purchase_behavior CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '179 days'
      AND order_date <  d - INTERVAL '89 days'
    GROUP BY tier, member_id
),
ac AS (SELECT tier, SUM(spend) AS sc, SUM(orders) AS oc, COUNT(*) AS mc FROM curr GROUP BY tier),
ap AS (SELECT tier, SUM(spend) AS sp, SUM(orders) AS op, COUNT(*) AS mp FROM prev GROUP BY tier)
SELECT c.tier,
    c.sc                                                                          AS spend_current,
    COALESCE(p.sp,0)                                                              AS spend_previous,
    ROUND((c.sc - COALESCE(p.sp,0))/NULLIF(p.sp,0)*100,1)                        AS spend_change_pct,
    c.oc                                                                          AS orders_current,
    COALESCE(p.op,0)                                                              AS orders_previous,
    ROUND((c.oc - COALESCE(p.op,0))/NULLIF(p.op,0)*100,1)                        AS orders_change_pct,
    ROUND(c.oc*1.0/NULLIF(c.mc,0)/12.86,2)                                       AS freq_current,
    ROUND(COALESCE(p.op,0)*1.0/NULLIF(p.mp,0)/12.86,2)                           AS freq_previous,
    CASE
        WHEN (c.sc - COALESCE(p.sp,0))/NULLIF(p.sp,0)*100 >=  10 THEN 'Naik'
        WHEN (c.sc - COALESCE(p.sp,0))/NULLIF(p.sp,0)*100 <= -10 THEN 'Turun'
        ELSE 'Stabil'
    END AS movement_status
FROM ac c LEFT JOIN ap p ON c.tier=p.tier
ORDER BY c.sc DESC
```

```sql member_tier_detail
WITH max_d AS (SELECT MAX(order_date) AS d FROM restaurant.member_purchase_behavior),
members AS (
    SELECT member_id, member_name, tier, city
    FROM restaurant.dim_members
),
orders_90 AS (
    SELECT
        member_id,
        SUM(total_orders) AS total_orders,
        SUM(total_spend) AS total_spend,
        ROUND(SUM(total_spend)/NULLIF(SUM(total_orders),0),0) AS avg_order_value
    FROM restaurant.member_purchase_behavior CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '89 days'
      AND order_date <= d
    GROUP BY member_id
),
last_order AS (
    SELECT member_id, MAX(order_date) AS last_order_date
    FROM restaurant.member_purchase_behavior CROSS JOIN max_d
    WHERE order_date <= d
    GROUP BY member_id
)
SELECT
    m.member_name,
    m.tier,
    m.city,
    COALESCE(o.total_orders,0) AS total_orders,
    ROUND(COALESCE(o.total_orders,0)/12.86,1) AS orders_per_week,
    COALESCE(o.total_spend,0) AS total_spend,
    COALESCE(o.avg_order_value,0) AS avg_order_value,
    COALESCE(DATEDIFF('day', l.last_order_date, d), 9999) AS recency_days,
    CASE
        WHEN COALESCE(o.total_orders,0) = 0 THEN 'Belum aktif'
        WHEN m.tier='Gold' AND COALESCE(DATEDIFF('day', l.last_order_date, d), 9999) >= 14 THEN 'Berisiko'
        WHEN m.tier='Silver' AND COALESCE(DATEDIFF('day', l.last_order_date, d), 9999) >= 21 THEN 'Berisiko'
        WHEN m.tier='Bronze' AND COALESCE(DATEDIFF('day', l.last_order_date, d), 9999) >= 30 THEN 'Berisiko'
        ELSE 'Aktif'
    END AS status_member
FROM members m
CROSS JOIN max_d
LEFT JOIN orders_90 o ON m.member_id = o.member_id
LEFT JOIN last_order l ON m.member_id = l.member_id
ORDER BY
    CASE m.tier WHEN 'Gold' THEN 1 WHEN 'Silver' THEN 2 ELSE 3 END,
    COALESCE(o.total_spend,0) DESC
```

```sql top_member_90d
WITH max_d AS (SELECT MAX(order_date) AS d FROM restaurant.member_purchase_behavior),
base AS (
    SELECT member_name, tier, city,
        SUM(total_orders)              AS total_orders,
        ROUND(SUM(total_orders)/12.86,1) AS orders_per_week,
        SUM(total_items)               AS total_items,
        SUM(total_spend)               AS total_spend,
        ROUND(AVG(avg_order_value),0)  AS avg_order_value,
        DATEDIFF('day', MAX(order_date), d) AS recency_days
    FROM restaurant.member_purchase_behavior CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '89 days'
    GROUP BY member_name, tier, city, d
),
p75 AS (SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_spend) AS v FROM base)
SELECT
    b.member_name, b.tier, b.city,
    b.total_orders, b.orders_per_week,
    b.total_items, b.total_spend, b.avg_order_value, b.recency_days,
    CASE
        WHEN (b.tier='Gold' AND b.recency_days>=14)
          OR (b.tier='Silver' AND b.recency_days>=21)
          OR (b.tier='Bronze' AND b.recency_days>=30) THEN 'Cek Retensi'
        WHEN b.total_spend >= p.v AND b.recency_days < 14 THEN 'Pertahankan'
        WHEN b.orders_per_week >= 2 AND b.avg_order_value < 50000 THEN 'Dorong add-on'
        WHEN b.tier = 'Bronze' AND b.orders_per_week >= 1 THEN 'Dorong upgrade'
        ELSE 'Pantau'
    END AS member_action
FROM base b, p75 p
ORDER BY b.total_spend DESC
LIMIT 25
```

```sql spending_trend_90d
SELECT
    order_date,
    tier,
    SUM(total_spend)               AS total_spend,
    SUM(total_orders)              AS total_orders,
    COUNT(DISTINCT member_id)      AS active_members
FROM restaurant.member_purchase_behavior
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.member_purchase_behavior) - INTERVAL '89 days'
GROUP BY order_date, tier
ORDER BY order_date, tier
```

```sql spending_by_city
WITH max_d AS (SELECT MAX(order_date) AS d FROM restaurant.member_purchase_behavior)
SELECT
    city,
    COUNT(DISTINCT member_id)      AS active_members,
    SUM(total_spend)               AS total_spend,
    ROUND(AVG(avg_order_value),0)  AS avg_order_value,
    ROUND(SUM(total_orders)*1.0/NULLIF(COUNT(DISTINCT member_id),0),1) AS orders_per_member
FROM restaurant.member_purchase_behavior CROSS JOIN max_d
WHERE order_date >= d - INTERVAL '89 days'
GROUP BY city
ORDER BY total_spend DESC
```

```sql tier_city_mix
WITH max_d AS (SELECT MAX(order_date) AS d FROM restaurant.member_purchase_behavior)
SELECT
    city, tier,
    COUNT(DISTINCT member_id)      AS active_members,
    SUM(total_spend)               AS total_spend,
    ROUND(AVG(avg_order_value),0)  AS avg_order_value,
    ROUND(COUNT(DISTINCT member_id)*100.0 /
        NULLIF(SUM(COUNT(DISTINCT member_id)) OVER (PARTITION BY city),0),1) AS pct_members_in_city,
    ROUND(SUM(total_spend)*100.0 /
        NULLIF(SUM(SUM(total_spend)) OVER (PARTITION BY city),0),1) AS pct_spend_in_city
FROM restaurant.member_purchase_behavior CROSS JOIN max_d
WHERE order_date >= d - INTERVAL '89 days'
GROUP BY city, tier
ORDER BY city, total_spend DESC
```

```sql cohort_summary
SELECT
    DATE_TRUNC('month', join_date)                                                AS cohort_bulan,
    tier,
    COUNT(DISTINCT member_id)                                                      AS total_member,
    ROUND(SUM(total_spend)/NULLIF(COUNT(DISTINCT member_id),0),0)                 AS avg_spend_per_member,
    ROUND(SUM(total_orders)*1.0/NULLIF(COUNT(DISTINCT member_id),0)/12.86,1)      AS avg_frekuensi_mingguan
FROM restaurant.member_purchase_behavior
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.member_purchase_behavior) - INTERVAL '89 days'
GROUP BY 1, 2
ORDER BY 1, 2
```

```sql cohort_total
SELECT
    DATE_TRUNC('month', join_date)                                                AS cohort_bulan,
    COUNT(DISTINCT member_id)                                                      AS total_member,
    ROUND(SUM(total_spend)/NULLIF(COUNT(DISTINCT member_id),0),0)                 AS avg_spend_per_member,
    ROUND(SUM(total_orders)*1.0/NULLIF(COUNT(DISTINCT member_id),0)/12.86,1)      AS avg_frekuensi_mingguan
FROM restaurant.member_purchase_behavior
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.member_purchase_behavior) - INTERVAL '89 days'
GROUP BY 1
ORDER BY 1
```


<div class="control-scroll">
  <ButtonGroup name=member_view>
    <ButtonGroupItem valueLabel="🏠 Ringkasan" value="overview" default />
    <ButtonGroupItem valueLabel="⚠️ Retensi" value="retention" />
    <ButtonGroupItem valueLabel="💰 Tier & Kota" value="tier_city" />
    <ButtonGroupItem valueLabel="🔬 Cohort" value="cohort" />
    <ButtonGroupItem valueLabel="🎯 Pusat Aksi" value="action_center" />
  </ButtonGroup>
</div>

{#if member_health_overview.length > 0 && member_dates.length > 0}
{@const memberView = inputs.member_view ?? 'overview'}
{@const activeFocus = member_health_overview[0].focus_90d}
{@const activeMembers = member_health_overview[0].active_90d}
{@const activeChurn = member_health_overview[0].churn_90d}
{@const activeGoldChurn = member_health_overview[0].gold_churn_90d}
{@const activeFreq = member_health_overview[0].freq_90d}
{@const activeAov = member_health_overview[0].aov_90d}
{@const activeKpi = member_kpi_period.find(r => r.period === '90d')}
{@const kpi90 = activeKpi}
{@const riskRate90 = activeKpi?.total_members ? activeChurn * 100 / activeKpi.total_members : 0}
{@const riskStatus90 = riskRate90 >= 10 ? 'Kritis' : riskRate90 >= 5 || activeGoldChurn > 0 ? 'Waspada' : 'Sehat'}
{@const activeStatus = activeFocus === 'Churn risk' ? riskStatus90 : member_health_overview[0].status_90d}
{@const activityStatus90 = (kpi90?.active_rate_pct ?? 0) >= 80 ? 'Sehat' : (kpi90?.active_rate_pct ?? 0) >= 50 ? 'Waspada' : 'Kritis'}
{@const riskSnapshot = member_risk_snapshot[0]}
{@const memberActivityState = (kpi90?.active_rate_pct ?? 0) >= 80 ? 'safe' : (kpi90?.active_rate_pct ?? 0) >= 50 ? 'warn' : 'critical'}
{@const memberRiskState = riskStatus90 === 'Kritis' ? 'critical' : riskStatus90 === 'Waspada' ? 'warn' : 'safe'}
{@const memberOrderShareState = (activeKpi?.pct_order_member ?? 0) >= 30 ? 'safe' : (activeKpi?.pct_order_member ?? 0) >= 20 ? 'warn' : 'critical'}
{@const memberFrequencyState = (activeKpi?.orders_per_member_per_week ?? 0) >= 1 ? 'safe' : (activeKpi?.orders_per_member_per_week ?? 0) >= 0.6 ? 'warn' : 'critical'}
{@const memberPrimaryStates = [memberActivityState, memberRiskState]}
{@const memberPrimarySafeCount = memberPrimaryStates.filter(s => s === 'safe').length}
{@const memberPrimaryWarnCount = memberPrimaryStates.filter(s => s === 'warn').length}
{@const memberPrimaryCriticalCount = memberPrimaryStates.filter(s => s === 'critical').length}

<div class="member-page">

{#if memberView === 'overview'}

<div class="page-intro">
  Ringkasan ini membaca kesehatan program member sebagai mesin repeat order: seberapa aktif basis member, seberapa besar kontribusinya ke order restoran, apakah value dan frekuensi kembali masih sehat, serta apakah ada member bernilai tinggi yang mulai berisiko churn.
</div>


<details class="context-acc">
  <summary>📖 Cara membaca Ringkasan</summary>
  <div class="acc-body">
    <ul>
      <li><strong>Status health</strong> adalah diagnosis awal dari churn risk, frekuensi kembali, dan AOV dalam jendela 90 hari.</li>
      <li><strong>Churn risk</strong> dihitung dari recency transaksi terakhir: Gold ≥14 hari, Silver ≥21 hari, Bronze ≥30 hari tidak transaksi.</li>
      <li><strong>Status risiko</strong> dibaca dari proporsi churn risk terhadap total member. Gold risk menaikkan perhatian menjadi Waspada, tetapi tidak otomatis membuat kondisi Kritis.</li>
      <li><strong>Prioritas outreach</strong> memakai severity, tier, value 180 hari, recency terakhir, dan telat dari ritme normal. Tujuannya membantu owner tahu siapa yang dihubungi dulu.</li>
      <li><strong>Angka Ringkasan</strong> hanya mencerminkan kontribusi member, bukan seluruh performa restoran. Detail bukti tetap dibaca di subpage Retensi, Tier & Kota, dan Cohort.</li>
    </ul>
  </div>
</details>

<div class="member-status {activeStatus === 'Sehat' ? 'safe' : activeStatus === 'Waspada' ? 'warn' : 'critical'}">
  <div>
    <div class="member-status-label">Status Utama · Pola 90 Hari</div>
    <h2 class="member-status-title">
      {#if activeStatus === 'Sehat'}Loyalitas member masih terkendali. ✅
      {:else if activeStatus === 'Waspada'}Program member aktif, tapi ada sinyal retensi. ⚠️
      {:else}Member bernilai tinggi perlu perhatian serius. 🚨{/if}
    </h2>
    <div class="member-status-copy">
      Dalam 90 hari terakhir, ada {(kpi90?.active_members ?? 0).toLocaleString('id-ID')} dari {(kpi90?.total_members ?? 0).toLocaleString('id-ID')} member aktif, kontribusi order member {activeKpi?.pct_order_member ?? 0}%, frekuensi {activeKpi?.orders_per_member_per_week ?? 0}× per minggu, dan {activeChurn} member berisiko churn. Baca ini sebagai kesehatan program loyalitas, bukan seluruh performa restoran.
    </div>
    <div class="member-status-action">
      <strong>Mulai dari sini:</strong>
      {#if activeGoldChurn > 0}hubungi member Gold yang mulai melewati batas recency sebelum broadcast promo umum.
      {:else if activeChurn > 0}cek <strong>Retensi</strong> dan <strong>Pusat Aksi</strong> untuk menentukan siapa yang perlu dihubungi lebih dulu.
      {:else if memberActivityState !== 'safe'}cek aktivasi member dan kualitas onboarding sebelum menambah campaign akuisisi.
      {:else}jaga momentum member aktif, lalu cari peluang upgrade tier dan onboarding member baru.{/if}
    </div>
  </div>
  <div class="member-status-metrics">
    <div class="member-status-metric">
      <div class="member-status-metric-label">📅 Periode Aktif</div>
      <div class="member-status-metric-value">{member_dates[0].tgl_90_awal} - {member_dates[0].tgl_akhir}</div>
      <div class="member-status-metric-note">90 hari dipakai karena loyalitas butuh waktu cukup panjang untuk membaca repeat order, recency, dan cohort.</div>
    </div>
    <div class="member-status-metric">
      <div class="member-status-metric-label">🎯 Prioritas Tindakan</div>
      <div class="member-status-metric-value">{activeGoldChurn > 0 ? activeGoldChurn + ' Gold risk' : activeChurn > 0 ? activeChurn + ' member risk' : 'Jaga member aktif'}</div>
      <div class="member-status-metric-note">Target rinci ada di Prioritas Outreach dan Pusat Aksi.</div>
    </div>
  </div>
</div>

<div class="member-health">
  <div class="member-health-head">
    <div class="member-health-label">Ringkasan 2 Indikator Utama</div>
    <div class="member-health-badges">
      <span class="member-health-badge safe">✓ {memberPrimarySafeCount} sehat</span>
      <span class="member-health-badge warn">! {memberPrimaryWarnCount} waspada</span>
      <span class="member-health-badge critical">x {memberPrimaryCriticalCount} kritis</span>
    </div>
  </div>
  <div class="member-health-list">
    <div class="member-health-row {memberActivityState}">
      <div class="member-health-icon">{memberActivityState === 'safe' ? '✅' : memberActivityState === 'warn' ? '⚠️' : '🚨'}</div>
      <div><span class="member-health-title">Aktivitas Member</span> <span class="member-health-copy">- <span class="member-health-value">{kpi90?.active_rate_pct ?? 0}% member aktif</span>. Sehat = ≥80%, Waspada = 50-79%, Kritis = di bawah 50%.</span></div>
    </div>
    <div class="member-health-row {memberRiskState}">
      <div class="member-health-icon">{memberRiskState === 'safe' ? '✅' : memberRiskState === 'warn' ? '⚠️' : '🚨'}</div>
      <div><span class="member-health-title">Risiko Churn</span> <span class="member-health-copy">- <span class="member-health-value">{activeChurn} member berisiko</span> ({riskRate90.toFixed(1)}%). Sehat = &lt;5%, Waspada = 5-9% atau ada Gold risk, Kritis = ≥10%.</span></div>
    </div>
  </div>
</div>

<details class="acc-strategic">
  <summary>Kenapa aktivitas dan churn risk jadi angka utama?</summary>
  <div class="acc-body">
    <div class="section-head tight">
      <div>
        <div class="section-eyebrow">Makna Angka Utama</div>
        <h3 class="section-title">Dua hal paling dasar untuk owner</h3>
        <p class="section-copy">Kalau hanya punya waktu singkat, baca apakah basis member masih hidup dan apakah member bernilai mulai menjauh.</p>
      </div>
    </div>
    <div class="member-analysis-grid">
      <div class="member-analysis-card {memberActivityState}">
        <div class="member-analysis-label">Aktivitas Member</div>
        <div class="member-analysis-title">{kpi90?.active_rate_pct ?? 0}% aktif</div>
        <div class="member-analysis-copy">Aktivitas member menjawab pertanyaan paling dasar: apakah program loyalitas masih membuat member kembali transaksi dalam 90 hari.</div>
        <div class="member-threshold-line"><strong>Batas:</strong> ≥80% sehat · 50-79% waspada · &lt;50% kritis</div>
      </div>
      <div class="member-analysis-card {memberRiskState}">
        <div class="member-analysis-label">Risiko Churn</div>
        <div class="member-analysis-title">{activeChurn} member · {riskRate90.toFixed(1)}%</div>
        <div class="member-analysis-copy">Churn risk membaca member yang melewati batas recency sesuai tier: Gold lebih cepat diprioritaskan karena value-nya biasanya lebih tinggi.</div>
        <div class="member-threshold-line"><strong>Batas:</strong> &lt;5% sehat · 5-9% waspada · ≥10% kritis · Gold risk menaikkan perhatian</div>
      </div>
    </div>
  </div>
</details>

<div class="member-health">
  <div class="member-health-head">
    <div class="member-health-label">Sinyal Pendukung Program</div>
    <div class="member-health-badges">
      <span class="member-health-badge {memberOrderShareState}">{memberOrderShareState === 'safe' ? '✅' : memberOrderShareState === 'warn' ? '⚠️' : '🚨'} order</span>
      <span class="member-health-badge {memberFrequencyState}">{memberFrequencyState === 'safe' ? '✅' : memberFrequencyState === 'warn' ? '⚠️' : '🚨'} frekuensi</span>
    </div>
  </div>
  <div class="member-health-list">
    <div class="member-health-row {memberOrderShareState}">
      <div class="member-health-icon">{memberOrderShareState === 'safe' ? '✅' : memberOrderShareState === 'warn' ? '⚠️' : '🚨'}</div>
      <div><span class="member-health-title">Kontribusi Order</span> <span class="member-health-copy">- <span class="member-health-value">{activeKpi?.pct_order_member ?? 0}% order dari member</span>. Sehat = ≥30%, Waspada = 20-29%, Kritis = di bawah 20%.</span></div>
    </div>
    <div class="member-health-row {memberFrequencyState}">
      <div class="member-health-icon">{memberFrequencyState === 'safe' ? '✅' : memberFrequencyState === 'warn' ? '⚠️' : '🚨'}</div>
      <div><span class="member-health-title">Frekuensi Kembali</span> <span class="member-health-copy">- <span class="member-health-value">{activeKpi?.orders_per_member_per_week ?? 0}×/minggu</span>. Sehat = ≥1×, Waspada = 0.6-0.99×, Kritis = di bawah 0.6×.</span></div>
    </div>
  </div>
</div>

<details class="acc-strategic">
  <summary>Kenapa kontribusi order dan frekuensi ikut dicek?</summary>
  <div class="acc-body">
    <div class="section-head tight">
      <div>
        <div class="section-eyebrow">Konteks Program</div>
        <h3 class="section-title">Bedakan member banyak dari member yang benar-benar memberi value</h3>
        <p class="section-copy">Member aktif saja belum cukup. Program member baru kuat kalau kontribusinya ke order restoran jelas dan member punya ritme kembali yang sehat.</p>
      </div>
    </div>
    <div class="member-analysis-grid">
      <div class="member-analysis-card {memberOrderShareState}">
        <div class="member-analysis-label">Kontribusi Order</div>
        <div class="member-analysis-title">{activeKpi?.pct_order_member ?? 0}% order</div>
        <div class="member-analysis-copy">Angka ini membaca seberapa relevan program member terhadap transaksi restoran. Kalau rendah, benefit atau aktivasi member perlu diperkuat.</div>
        <div class="member-threshold-line"><strong>Batas:</strong> ≥30% sehat · 20-29% waspada · &lt;20% kritis</div>
      </div>
      <div class="member-analysis-card {memberFrequencyState}">
        <div class="member-analysis-label">Frekuensi</div>
        <div class="member-analysis-title">{activeKpi?.orders_per_member_per_week ?? 0}×/minggu</div>
        <div class="member-analysis-copy">Frekuensi membantu membaca kebiasaan kembali. Jika turun, intervensinya lebih dekat ke reminder, benefit kunjungan berikutnya, atau onboarding.</div>
        <div class="member-threshold-line"><strong>Batas:</strong> ≥1× sehat · 0.6-0.99× waspada · &lt;0.6× kritis</div>
      </div>
    </div>
  </div>
</details>

<div class="section-card">
  <div class="section-head tight">
    <div>
      <div class="section-eyebrow">Konteks Lanjutan</div>
      <h3 class="section-title">Detail tambahan setelah angka utama</h3>
      <p class="section-copy">Gunakan ini untuk menentukan apakah deep dive berikutnya lebih cocok ke Retensi, Tier & Kota, Cohort, atau Pusat Aksi.</p>
    </div>
  </div>
  <div class="member-analysis-grid context">
    <div class="member-analysis-card neutral">
      <div class="member-analysis-label">AOV Member</div>
      <div class="member-analysis-title">Rp {(activeKpi?.avg_order_value ?? 0).toLocaleString('id-ID')}</div>
      <div class="member-analysis-copy">Nilai rata-rata sekali transaksi. Baca bersama frekuensi agar tidak salah menilai value.</div>
    </div>
    <div class="member-analysis-card neutral">
      <div class="member-analysis-label">Belanja Member</div>
      <div class="member-analysis-title">Rp {((activeKpi?.total_member_spend ?? 0)/1000000).toFixed(1)}jt</div>
      <div class="member-analysis-copy">Total spend member dalam 90 hari. Gunakan Tier & Kota untuk melihat sumber value.</div>
    </div>
    <div class="member-analysis-card {member_health_overview[0].cohort_status === 'Sehat' ? 'safe' : 'warn'}">
      <div class="member-analysis-label">Cohort Baru</div>
      <div class="member-analysis-title">{member_health_overview[0].cohort_newest_freq}×/minggu</div>
      <div class="member-analysis-copy">Baseline cohort {member_health_overview[0].cohort_avg_freq}×/minggu. Jika melemah, cek onboarding.</div>
    </div>
    <div class="member-analysis-card {retention_queue.length > 0 ? 'warn' : 'safe'}">
      <div class="member-analysis-label">Pusat Aksi</div>
      <div class="member-analysis-title">{retention_queue.length} target outreach</div>
      <div class="member-analysis-copy">Daftar prioritas member yang perlu dihubungi atau ditindaklanjuti secara personal.</div>
    </div>
  </div>
</div>

<div class="section-card">
  <div class="section-head tight">
    <div>
      <div class="section-eyebrow">🎯 Prioritas Outreach</div>
      <h3 class="section-title">{retention_queue.length > 0 ? 'Mulai dari 3 member yang paling perlu dihubungi' : 'Tidak ada outreach retensi mendesak'}</h3>
      <p class="section-copy">{retention_queue.length > 0 ? 'Daftar ini adalah tindak lanjut dari diagnosis program member di atas. Owner tetap membaca kesehatan program dulu, lalu memakai daftar ini untuk menentukan siapa yang dihubungi lebih awal.' : 'Saat risiko retensi rendah, fokus Ringkasan bergeser ke menjaga momentum member aktif, upgrade tier, dan onboarding member baru.'}</p>
    </div>
  </div>
  {#if retention_queue.length > 0}
    <div class="overview-action-grid">
      {#each retention_queue.slice(0, 3) as action, i}
        <div class="overview-action-card {action.severity === 'Kritis' ? 'critical' : action.severity === 'Tinggi' ? 'high' : action.severity === 'Sedang' ? 'moderate' : 'low'}">
          <div class="overview-action-top">
            <span class="overview-action-rank">{action.severity} · #{i+1}</span>
            <span class="overview-action-tag">{action.action_type} · {action.tier}</span>
          </div>
          <div class="overview-action-title">{action.member_name}</div>
          <div class="overview-action-metric">{action.metric_value}</div>
          <div class="overview-action-copy">{action.rhythm_text}</div>
          <div class="overview-action-copy"><strong>Aksi:</strong> {action.recommended_action}</div>
          <div class="overview-action-footer">Detail lengkap ada di Pusat Aksi.</div>
        </div>
      {/each}
    </div>
  {:else}
    <div class="analysis-grid">
      <div class="analysis-card"><div class="analysis-label">Jaga Gold</div><div class="analysis-title">Pertahankan benefit member bernilai tinggi.</div><div class="analysis-copy">Gunakan Tier & Kota untuk membaca lokasi atau tier yang memberi kontribusi spend terbesar.</div></div>
      <div class="analysis-card"><div class="analysis-label">Dorong Upgrade</div><div class="analysis-title">Cari Bronze/Silver aktif yang siap naik kelas.</div><div class="analysis-copy">Prioritaskan member dengan frekuensi baik tetapi AOV masih bisa ditingkatkan lewat add-on atau bundling.</div></div>
      <div class="analysis-card"><div class="analysis-label">Perbaiki Onboarding</div><div class="analysis-title">Cek kualitas cohort baru.</div><div class="analysis-copy">Jika cohort terbaru lebih lemah dari baseline, perbaiki benefit kunjungan kedua sebelum menambah akuisisi.</div></div>
    </div>
  {/if}
</div>

<div class="section-card">
  <div class="section-head tight">
    <div>
      <div class="section-eyebrow">🧭 Basis & Risiko Member</div>
      <h3 class="section-title">Aktivitas umum dan risiko value perlu dibaca terpisah</h3>
      <p class="section-copy">Basis member menunjukkan seberapa hidup program loyalitas dalam jendela 90 hari. Risiko per tier menunjukkan apakah member bernilai tinggi mulai menjauh walaupun aktivitas umum terlihat sehat.</p>
    </div>
  </div>
  <Grid cols=2>
    <div>
      <BarChart
        data={member_activity_mix}
        x="status"
        y="member_count"
        title="Komposisi Basis Member - 90 Hari"
        yFmt="#,##0"
        xAxisTitle="Status member"
        yAxisTitle="Jumlah member"
      />
      <div class="chart-insight">
        📌 <strong>Makna chart:</strong> jika porsi aktif tinggi, program member masih hidup. Jika belum aktif mulai besar, masalahnya ada di aktivasi member, bukan hanya retensi.
      </div>
    </div>
    <div>
      <BarChart
        data={retention_risk_by_tier}
        x="tier"
        y="churn_risk_members"
        title="Risiko Retensi per Tier"
        yFmt="#,##0"
        xAxisTitle="Tier"
        yAxisTitle="Member risk"
      />
      <div class="chart-insight">
        📌 <strong>Makna chart:</strong> Gold risk dibaca lebih serius walau jumlahnya tidak paling besar, karena dampak revenue per member biasanya lebih tinggi.
      </div>
    </div>
  </Grid>
</div>

{:else if memberView === 'retention'}

<details class="context-acc">
  <summary>📖 Cara membaca risiko retensi</summary>
  <div class="acc-body">
    <ul>
      <li>Risiko retensi dihitung dari semua member di dimensi member, termasuk member yang tidak transaksi dalam periode aktif.</li>
      <li><strong>Recency</strong> berarti jumlah hari sejak transaksi terakhir, dihitung dari tanggal transaksi maksimum dataset.</li>
      <li><strong>Ritme normal</strong> berarti rata-rata jarak hari antar kunjungan member dalam histori 180 hari. Member mingguan dan bulanan tidak dibaca dengan standar yang sama.</li>
      <li>⚠️ <strong>Gold berisiko tidak kembali</strong> berarti member Gold tidak transaksi minimal 14 hari. Dampaknya diprioritaskan karena value member biasanya lebih tinggi.</li>
      <li>🟡 <strong>Silver berisiko tidak kembali</strong> berarti member Silver tidak transaksi minimal 21 hari. Fokusnya win-back selektif.</li>
      <li>🟤 <strong>Bronze berisiko tidak kembali</strong> berarti member Bronze tidak transaksi minimal 30 hari. Fokusnya aktivasi ulang dan upgrade bertahap.</li>
      <li>Subpage ini adalah bukti retensi, bukan daftar aksi final. Eksekusi ditempatkan di Pusat Aksi.</li>
    </ul>
  </div>
</details>

<div class="strategic-stack">
  <div class="strategic-header">
    <div class="strategic-eyebrow">🔭 Perspektif Retensi · 90 Hari</div>
    <h2 class="strategic-title">Siapa yang mulai jarang kembali, dan seberapa serius risikonya?</h2>
    <p class="strategic-copy">Dua sudut baca di bawah ini membantu owner melihat apakah risiko member tidak kembali sudah cukup serius, tier mana yang perlu dipantau, dan apakah intervensinya harus personal atau cukup campaign ringan. Setelah tahu tier yang berisiko, buka Pusat Aksi untuk melihat member spesifik yang perlu dihubungi.</p>
  </div>

  <details class="acc-strategic" open>
    <summary>⚠️ Snapshot Risiko Retensi · Baca Member yang Mulai Jarang Kembali</summary>
    <div class="acc-body">
      <div class="snapshot-grid">
        {#each retention_risk_by_tier as t}
          <div class="snapshot-card {t.tier === 'Gold' ? 'gold' : t.tier === 'Silver' ? 'silver' : 'bronze'}">
            <div class="snapshot-label">{t.tier}</div>
            <div class="snapshot-value">{t.churn_risk_members} / {t.total_members}</div>
            <div class="snapshot-copy">{t.churn_risk_pct}% berisiko · rata-rata telat {t.avg_delay_days ?? 0} hari dari ritme.</div>
          </div>
        {/each}
        <div class="snapshot-card {activeGoldChurn > 0 ? 'danger' : activeChurn > 0 ? 'warn' : 'safe'}">
          <div class="snapshot-label">Prioritas</div>
          <div class="snapshot-value">{activeGoldChurn > 0 ? activeGoldChurn + ' Gold' : activeChurn > 0 ? activeChurn + ' Member' : 'Aman'}</div>
          <div class="snapshot-copy">{activeGoldChurn > 0 ? 'Mulai dari retensi personal Gold.' : activeChurn > 0 ? 'Validasi tier dan status sebelum campaign.' : 'Fokus ke upgrade dan peningkatan belanja.'}</div>
        </div>
      </div>

      <div class="chart-insight">
        📌 <strong>Analisis cepat:</strong> recency membaca kapan terakhir transaksi, sedangkan ritme normal membaca seberapa sering member biasanya kembali. Member yang biasanya datang mingguan tetapi absen dua minggu lebih mendesak daripada member yang memang biasa datang bulanan.
      </div>
    </div>
  </details>

  <details class="acc-strategic" open>
    <summary>📊 Risiko per Tier · Baca Bukti Angkanya</summary>
    <div class="acc-body">
      <Grid cols=2>
        <div>
          <BarChart data={retention_risk_by_tier} x="tier" y="churn_risk_members" title="Member Berisiko Tidak Kembali per Tier" yFmt="#,##0" />
        </div>
        <div>
          <BarChart data={retention_risk_by_tier} x="tier" y="avg_delay_days" title="Rata-rata Telat dari Ritme Normal" yFmt="#,##0.0" />
        </div>
      </Grid>

      <div class="chart-insight">
        📌 <strong>Cara membaca chart ini:</strong> chart kiri menunjukkan jumlah member yang mulai jarang kembali. Chart kanan menunjukkan seberapa jauh mereka sudah terlambat dari kebiasaan kunjungannya sendiri. Gold tetap dibaca lebih serius karena potensi value per member biasanya lebih besar.
      </div>

      <details style="margin-top:14px;">
        <summary>📋 Detail metrik retensi per tier</summary>
        <div class="acc-body"><DataTable data={retention_risk_by_tier}><Column id="tier" title="Tier"/><Column id="total_members" title="Total Member" fmt="#,##0"/><Column id="churn_risk_members" title="Churn Risk" fmt="#,##0"/><Column id="churn_risk_pct" title="% Risk" fmt="0.0\%"/><Column id="avg_recency_days" title="Avg Recency" fmt="0.0"/><Column id="avg_visit_interval_days" title="Ritme Normal" fmt="0.0"/><Column id="avg_delay_days" title="Avg Telat" fmt="0.0"/><Column id="delayed_beyond_rhythm" title="Telat dari Ritme" fmt="#,##0"/><Column id="spend_180d" title="Spend 180H (Rp)" fmt="#,##0"/><Column id="avg_order_value_180d" title="AOV 180H (Rp)" fmt="#,##0"/></DataTable></div>
      </details>
    </div>
  </details>
</div>

{:else if memberView === 'tier_city'}

<details class="context-acc">
  <summary>📖 Cara membaca Tier & Kota</summary>
  <div class="acc-body">
    <ul>
      <li><strong>Tier</strong> adalah segmentasi utama: Gold, Silver, dan Bronze.</li>
      <li><strong>Kontribusi value</strong> dibaca dari spend, AOV, dan frekuensi per tier. Jumlah member besar belum tentu berarti value paling besar.</li>
      <li><strong>Kota</strong> membantu menentukan lokasi campaign, benefit, atau evaluasi cabang.</li>
      <li><strong>Detail member</strong> tetap tersedia, tetapi ditempatkan di accordion supaya user membaca strategi dulu sebelum masuk tabel panjang.</li>
    </ul>
  </div>
</details>

<div class="strategic-stack">
  <div class="strategic-header">
    <div class="strategic-eyebrow">💰 Tier & Kota · 90 Hari</div>
    <h2 class="strategic-title">Tier dan kota mana yang paling bernilai untuk program member?</h2>
    <p class="strategic-copy">Subpage ini memisahkan tiga pertanyaan: tier mana yang menyumbang value terbesar, strategi apa yang cocok untuk tiap tier, dan kota mana yang perlu diprioritaskan untuk campaign atau retensi.</p>
  </div>

  <details class="acc-strategic" open>
    <summary>💰 Ringkasan Tier · Siapa Member Paling Bernilai?</summary>
    <div class="acc-body">
      <div class="analysis-grid">
        <div class="analysis-card"><div class="analysis-label">Temuan</div><div class="analysis-title">Value tidak selalu sejalan dengan jumlah member.</div><div class="analysis-copy">Tier kecil bisa memberi kontribusi spend besar jika AOV dan frekuensinya tinggi.</div></div>
        <div class="analysis-card"><div class="analysis-label">Bukti</div><div class="analysis-title">Bandingkan % member vs % belanja.</div><div class="analysis-copy">Gap antara populasi dan spend menunjukkan apakah tier tersebut overperform atau underperform.</div></div>
        <div class="analysis-card"><div class="analysis-label">Implikasi</div><div class="analysis-title">Perlakuan sebaiknya berbeda per tier.</div><div class="analysis-copy">Tier bernilai tinggi butuh retensi personal; tier besar dengan value rendah butuh aktivasi dan upgrade.</div></div>
      </div>
      <div class="tier-grid">
        {#each tier_economics_90d as t}<div class="tier-card {t.tier === 'Gold' ? 'gold' : t.tier === 'Silver' ? 'silver' : 'bronze'}"><div class="tier-label">Tier {t.tier}</div><div class="tier-title">{(t.active_members ?? 0).toLocaleString('id-ID')} member · {t.pct_members}% populasi</div><div class="tier-value">Rp {((t.total_spend ?? 0)/1000000).toFixed(1)}jt · {t.pct_spend}% belanja</div><div class="tier-copy">AOV Rp {(t.avg_order_value ?? 0).toLocaleString('id-ID')} · {t.orders_per_member_per_week}×/minggu</div></div>{/each}
      </div>
      <BarChart data={tier_economics_90d} x="tier" y="total_spend" title="Total Belanja per Tier — 90H (Rp)" yFmt="#,##0" xAxisTitle="Tier" yAxisTitle="Belanja (Rp)" />
      <div class="chart-insight">
        📌 <strong>Cara membaca:</strong> tier dengan porsi spend lebih besar dari porsi member adalah tier yang memberi value tinggi. Jangan hanya melihat jumlah member; baca juga AOV dan frekuensi.
      </div>
    </div>
  </details>

  <details class="acc-strategic">
    <summary>🎯 Strategi per Tier · Apa yang Harus Dilakukan?</summary>
    <div class="acc-body">
      <div class="analysis-grid">
        <div class="analysis-card"><div class="analysis-label">Gold</div><div class="analysis-title">Pertahankan dan jaga hubungan personal.</div><div class="analysis-copy">Gold sebaiknya diperlakukan sebagai segmen retensi premium: outreach personal, apresiasi khusus, dan prioritas saat mulai jarang kembali.</div></div>
        <div class="analysis-card"><div class="analysis-label">Silver</div><div class="analysis-title">Dorong upgrade ke Gold.</div><div class="analysis-copy">Cari Silver dengan frekuensi baik atau AOV tinggi. Program yang cocok: milestone reward, bundling, atau benefit naik tier.</div></div>
        <div class="analysis-card"><div class="analysis-label">Bronze</div><div class="analysis-title">Aktivasi ulang dan add-on ringan.</div><div class="analysis-copy">Bronze biasanya lebih cocok untuk reminder, promo kunjungan kedua, add-on sederhana, atau campaign edukasi benefit member.</div></div>
      </div>
      <div class="chart-insight">
        📌 <strong>Prinsip eksekusi:</strong> jangan menjalankan campaign yang sama untuk semua tier. Gunakan Gold untuk retensi, Silver untuk upgrade, dan Bronze untuk aktivasi.
      </div>
    </div>
  </details>

  <details class="acc-strategic">
    <summary>🗺️ Peta Kota · Di Mana Campaign Diprioritaskan?</summary>
    <div class="acc-body">
      <Grid cols=2><div><BarChart data={spending_by_city} x="city" y="total_spend" title="Belanja Member per Kota (Rp)" yFmt="#,##0" /></div><div><BarChart data={tier_city_mix} x="city" y="active_members" series="tier" type="stacked" title="Distribusi Tier per Kota" /></div></Grid>
      <div class="chart-insight">
        📌 <strong>Cara membaca:</strong> kota dengan proporsi Gold tinggi adalah prioritas retensi premium. Kota dengan Bronze besar dan spend cukup tinggi adalah peluang upgrade. Kota dengan spend tinggi perlu dijaga engagement-nya agar tidak turun.
      </div>
      <details style="margin-top:12px;"><summary>📋 Detail tier per kota</summary><div class="acc-body"><DataTable data={tier_city_mix}><Column id="city" title="Kota"/><Column id="tier" title="Tier"/><Column id="active_members" title="Member" fmt="#,##0"/><Column id="total_spend" title="Belanja (Rp)" fmt="#,##0"/><Column id="avg_order_value" title="AOV (Rp)" fmt="#,##0"/><Column id="pct_members_in_city" title="% Member" fmt="0.0\%"/><Column id="pct_spend_in_city" title="% Belanja" fmt="0.0\%"/></DataTable></div></details>
    </div>
  </details>

  <details class="acc-strategic">
    <summary>📋 Detail Member · Bukti Operasional</summary>
    <div class="acc-body">
      <DataTable data={member_tier_detail} rows=25>
        <Column id="member_name" title="Member"/>
        <Column id="tier" title="Tier"/>
        <Column id="city" title="Kota"/>
        <Column id="status_member" title="Status"/>
        <Column id="total_orders" title="Order" fmt="#,##0"/>
        <Column id="orders_per_week" title="Order/Minggu" fmt="0.0"/>
        <Column id="total_spend" title="Belanja (Rp)" fmt="#,##0"/>
        <Column id="avg_order_value" title="AOV (Rp)" fmt="#,##0"/>
        <Column id="recency_days" title="Recency" fmt="#,##0"/>
      </DataTable>
      <div class="chart-insight">
        📌 <strong>Cara membaca tabel ini:</strong> urutkan kolom tier, kota, status, recency, belanja, atau frekuensi sesuai kebutuhan. Member Gold/Silver yang berisiko dibawa ke Retensi atau Pusat Aksi; member aktif dengan frekuensi dan belanja tinggi dipakai sebagai basis program loyalitas.
      </div>
    </div>
  </details>

  <details class="acc-strategic">
    <summary>📈 Tren Belanja · Bukti Tambahan</summary>
    <div class="acc-body">
      <LineChart data={spending_trend_90d} x="order_date" y="total_spend" series="tier" title="Tren Belanja Member per Tier (90H)" yFmt="#,##0" />
      <div class="chart-insight">
        📌 <strong>Cara membaca:</strong> chart ini bukan prioritas pertama untuk owner. Gunakan hanya untuk melihat apakah lonjakan atau penurunan belanja per tier terjadi pada hari tertentu.
      </div>
    </div>
  </details>
</div>

{:else if memberView === 'cohort'}

<details class="context-acc">
  <summary>📖 Cara membaca cohort member</summary>
  <div class="acc-body">
    <ul>
      <li><strong>Cohort</strong> berarti member dikelompokkan berdasarkan bulan bergabung.</li>
      <li><strong>Value</strong> berarti rata-rata belanja per member dalam jendela 90H.</li>
      <li><strong>Frekuensi</strong> berarti rata-rata order per member per minggu untuk membaca kebiasaan kembali.</li>
      <li>Cohort terbaru belum selalu punya exposure penuh, jadi hasilnya dibaca sebagai indikasi awal, bukan vonis final.</li>
    </ul>
  </div>
</details>

<div class="strategic-stack">
  <div class="strategic-header">
    <div class="strategic-eyebrow">🔬 Cohort Member · 90 Hari</div>
    <h2 class="strategic-title">Apakah member baru makin berkualitas setelah bergabung?</h2>
    <p class="strategic-copy">Subpage ini membaca kualitas member baru: apakah mereka mulai punya kebiasaan kembali, apakah belanjanya cukup bernilai, dan apakah onboarding member perlu diperbaiki.</p>
  </div>

  <details class="acc-strategic" open>
    <summary>🌱 Kualitas Cohort Baru · Baca Sinyal Utama</summary>
    <div class="acc-body">
      <div class="analysis-grid">
        <div class="analysis-card"><div class="analysis-label">Temuan</div><div class="analysis-title">{member_health_overview[0].cohort_status === 'Sehat' ? 'Cohort terbaru masih kompetitif.' : 'Cohort terbaru perlu dipantau.'}</div><div class="analysis-copy">Kualitas cohort dibaca dari frekuensi dan value cohort terbaru terhadap baseline cohort lain.</div></div>
        <div class="analysis-card"><div class="analysis-label">Bukti</div><div class="analysis-title">{member_health_overview[0].cohort_newest_freq} vs {member_health_overview[0].cohort_avg_freq} order/mgg</div><div class="analysis-copy">Jika frekuensi cohort baru lebih rendah, onboarding atau benefit kunjungan kedua perlu dievaluasi.</div></div>
        <div class="analysis-card"><div class="analysis-label">Implikasi</div><div class="analysis-title">Masalah cohort adalah masalah akuisisi dan onboarding.</div><div class="analysis-copy">Aksi finalnya berbeda dari win-back member lama, jadi bukti ini dipisahkan dari retensi.</div></div>
      </div>
      <div class="kpi-grid"><div class="kpi-card member"><div class="kpi-label">Cohort Terbaru</div><div class="kpi-value">{member_health_overview[0].cohort_newest_freq} order/mgg</div><div class="kpi-meta">Frekuensi cohort paling baru.</div></div><div class="kpi-card orders"><div class="kpi-label">Rata-rata Cohort</div><div class="kpi-value">{member_health_overview[0].cohort_avg_freq} order/mgg</div><div class="kpi-meta">Baseline cohort 90H.</div></div><div class="kpi-card value"><div class="kpi-label">Value Terbaru</div><div class="kpi-value">Rp {((member_health_overview[0].cohort_newest_value ?? 0)/1000).toFixed(0)}rb</div><div class="kpi-meta">Belanja/member cohort baru.</div></div><div class="kpi-card frequency"><div class="kpi-label">Avg Value</div><div class="kpi-value">Rp {((member_health_overview[0].cohort_avg_value ?? 0)/1000).toFixed(0)}rb</div><div class="kpi-meta">Baseline value semua cohort.</div></div></div>
      <div class="chart-insight">
        📌 <strong>Cara membaca:</strong> cohort baru yang sehat bukan hanya banyak bergabung, tetapi mulai kembali dan belanja cukup bernilai. Jika frekuensi atau value lebih rendah dari baseline, perbaiki onboarding sebelum menambah akuisisi.
      </div>
    </div>
  </details>

  <details class="acc-strategic">
    <summary>📈 Trend Cohort · Baca Value dan Frekuensi</summary>
    <div class="acc-body">
      <Grid cols=2><div><LineChart data={cohort_total} x="cohort_bulan" y="avg_spend_per_member" title="Avg Belanja per Member per Cohort" yFmt="#,##0" /></div><div><LineChart data={cohort_total} x="cohort_bulan" y="avg_frekuensi_mingguan" title="Avg Frekuensi per Member per Cohort" yFmt="0.0" /></div></Grid>
      <div class="chart-insight">
        📌 <strong>Cara membaca:</strong> chart kiri menunjukkan apakah cohort baru punya value belanja yang membaik. Chart kanan menunjukkan apakah mereka mulai membentuk kebiasaan kembali. Frekuensi biasanya lebih penting untuk loyalitas awal daripada sekali transaksi besar.
      </div>
    </div>
  </details>

  <details class="acc-strategic">
    <summary>🎯 Strategi Onboarding · Apa yang Perlu Dilakukan?</summary>
    <div class="acc-body">
      <div class="analysis-grid">
        <div class="analysis-card"><div class="analysis-label">Frekuensi Turun</div><div class="analysis-title">Dorong kunjungan kedua dan ketiga.</div><div class="analysis-copy">Jika cohort baru jarang kembali, gunakan reminder, benefit kunjungan berikutnya, atau reward setelah transaksi kedua.</div></div>
        <div class="analysis-card"><div class="analysis-label">Value Turun</div><div class="analysis-title">Perbaiki basket awal.</div><div class="analysis-copy">Jika belanja/member rendah, uji bundling, add-on, atau benefit yang mendorong menu bernilai lebih tinggi.</div></div>
        <div class="analysis-card"><div class="analysis-label">Cohort Sehat</div><div class="analysis-title">Pertahankan channel akuisisi.</div><div class="analysis-copy">Jika cohort baru mengalahkan baseline, pertahankan sumber akuisisi dan benefit onboarding yang sedang berjalan.</div></div>
      </div>
      <div class="chart-insight">
        📌 <strong>Prinsip eksekusi:</strong> cohort lemah adalah masalah awal hubungan member, bukan win-back. Fokusnya membuat member baru kembali lebih cepat setelah bergabung.
      </div>
    </div>
  </details>

  <details class="acc-strategic">
    <summary>📋 Detail Cohort per Tier · Bukti Operasional</summary>
    <div class="acc-body">
      <DataTable data={cohort_summary}>
        <Column id="cohort_bulan" title="Bulan Bergabung"/>
        <Column id="tier" title="Tier"/>
        <Column id="total_member" title="Member" fmt="#,##0"/>
        <Column id="avg_spend_per_member" title="Avg Belanja (Rp)" fmt="#,##0"/>
        <Column id="avg_frekuensi_mingguan" title="Avg Frekuensi" fmt="0.0"/>
      </DataTable>
      <div class="chart-insight">
        📌 <strong>Cara membaca tabel ini:</strong> urutkan bulan bergabung dan tier untuk melihat apakah kualitas member baru melemah di tier tertentu. Gunakan detail ini setelah membaca sinyal utama di atas.
      </div>
    </div>
  </details>
</div>

{:else if memberView === 'action_center'}

<details class="context-acc">
  <summary>📖 Cara membaca Pusat Aksi</summary>
  <div class="acc-body">
    <ul>
      <li>Pusat Aksi adalah daftar kerja, bukan halaman analisis. Mulai dari urutan paling atas.</li>
      <li><strong>Urgensi</strong> disusun dari tier, nilai belanja 180 hari, recency terakhir, dan telat dari ritme normal member.</li>
      <li>🚨 <strong>Kritis</strong> berarti perlu outreach personal lebih dulu, terutama Gold yang mulai jarang kembali.</li>
      <li>⚠️ <strong>Tinggi</strong> berarti member bernilai tinggi yang tidak aktif dan masih layak dimenangkan kembali.</li>
      <li>Gunakan subpage Ringkasan, Retensi, Tier & Kota, dan Cohort sebagai bukti pendukung jika perlu menjelaskan alasan prioritas.</li>
    </ul>
  </div>
</details>

<div class="section-card">
  <div class="section-head">
    <div>
      <div class="section-eyebrow">🎯 Pusat Aksi <span class="timeframe-tag">Daftar Kerja</span></div>
      <h3 class="section-title">Siapa yang harus dihubungi dulu minggu ini?</h3>
      <p class="section-copy">Daftar ini mengubah sinyal retensi menjadi urutan kerja: siapa yang perlu dihubungi, kenapa masuk prioritas, dan tindakan apa yang disarankan.</p>
    </div>
  </div>

  <div class="analysis-grid">
    <div class="analysis-card"><div class="analysis-label">Didahulukan</div><div class="analysis-title">{activeGoldChurn > 0 ? 'Gold yang mulai jarang kembali.' : activeChurn > 0 ? 'Member bernilai tinggi yang tidak aktif.' : 'Member aktif bernilai tinggi.'}</div><div class="analysis-copy">Member bernilai tinggi jangan dicampur dengan broadcast promo umum. Mulai dari outreach personal.</div></div>
    <div class="analysis-card"><div class="analysis-label">Bukti yang Dipakai</div><div class="analysis-title">Recency + ritme normal + value 180H.</div><div class="analysis-copy">Member mingguan yang telat diperlakukan lebih urgent daripada member yang memang biasa datang bulanan.</div></div>
    <div class="analysis-card"><div class="analysis-label">Cara Eksekusi</div><div class="analysis-title">Hubungi personal sebelum campaign luas.</div><div class="analysis-copy">Mulai dari WhatsApp/telepon personal, lalu lanjutkan campaign per tier dan kota jika pola risikonya meluas.</div></div>
  </div>

  {#if retention_queue.length > 0}
  <div class="retention-stack">
    {#each retention_queue.slice(0, 8) as action, i}
      <div class="retention-card {action.severity === 'Kritis' ? 'critical' : action.severity === 'Tinggi' ? 'high' : action.severity === 'Sedang' ? 'moderate' : 'low'}">
        <div class="retention-header"><span class="retention-severity">{action.severity} · #{i+1}</span><span class="retention-badge">{action.action_label} · {action.tier} · {action.city}</span></div>
        <div class="retention-title">{action.member_name}</div>
        <div class="retention-impact">📊 Alasan masuk daftar: {action.metric_value}</div>
        <div class="retention-rec">⏱️ Pola kunjungan: {action.rhythm_text}</div>
        <div class="retention-rec">💡 Langkah: {action.action_short}</div>
      </div>
    {/each}
  </div>
  <div class="chart-insight">
    📌 <strong>Prinsip eksekusi:</strong> jangan broadcast promo ke semua member sebelum member bernilai tinggi dihubungi personal. Delapan kartu di atas adalah prioritas paling krusial; daftar lengkap target outreach ada di accordion di bawah.
  </div>

  <details class="acc-strategic">
    <summary>📋 Daftar Lengkap Target Outreach</summary>
    <div class="acc-body">
      <DataTable data={retention_queue} rows=10>
        <Column id="member_name" title="Member"/>
        <Column id="severity" title="Prioritas"/>
        <Column id="action_label" title="Segmen"/>
        <Column id="tier" title="Tier"/>
        <Column id="city" title="Kota"/>
        <Column id="last_order_label" title="Terakhir Belanja"/>
        <Column id="delay_label" title="Telat dari Ritme"/>
        <Column id="total_spend" title="Belanja 180H (Rp)" fmt="#,##0"/>
        <Column id="avg_order_value" title="AOV (Rp)" fmt="#,##0"/>
        <Column id="action_short" title="Aksi"/>
      </DataTable>
      <div class="chart-insight">
        📌 <strong>Cara membaca tabel ini:</strong> mulai dari Member, lalu baca Prioritas, Segmen, nilai belanja, dan Aksi. Urutkan Belanja 180H atau AOV untuk memilih outreach bernilai paling besar.
      </div>
    </div>
  </details>
  {:else}
  <div class="callout">Belum ada aksi retensi mendesak. Fokus berikutnya adalah menjaga Gold aktif, mencari Silver/Bronze yang siap upgrade, dan memperbaiki onboarding cohort baru.</div>
  <div class="chart-insight">
    📌 <strong>Prinsip eksekusi:</strong> saat tidak ada risiko retensi mendesak, jangan membuat promo reaktif. Gunakan energi tim untuk upgrade tier, add-on, dan onboarding member baru.
  </div>
  {/if}
</div>

{/if}

</div>

{:else}
<div class="section-card">
  <h3 class="section-title">Data member belum tersedia.</h3>
  <p class="section-copy">Pastikan source <code>restaurant.member_purchase_behavior</code> sudah ter-refresh dan memiliki data yang valid.</p>
</div>
{/if}