---
title: Inventori & Stok
sidebar_link: false
---

<style>
.over-container { display: none !important; }

.inv-page { display: flex; flex-direction: column; gap: 22px; margin-top: 10px; }
.inv-hero {
  display: grid;
  grid-template-columns: 1.4fr 1fr;
  gap: 18px;
  padding: 24px;
  border-radius: 22px;
  border: 1px solid rgba(37,99,235,0.14);
  background:
    radial-gradient(circle at top right, rgba(20,184,166,0.14), transparent 34%),
    radial-gradient(circle at bottom left, rgba(37,99,235,0.08), transparent 38%),
    linear-gradient(135deg, rgba(255,255,255,0.86), rgba(248,250,252,0.62));
  box-shadow: 0 10px 28px rgba(15,23,42,0.06);
}
.hero-kicker,
.section-eyebrow,
.metric-label,
.status-label {
  font-size: 10px;
  font-weight: 800;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: var(--color-text-tertiary);
}
.hero-title {
  margin: 5px 0 6px;
  font-size: 1.45rem;
  line-height: 1.18;
  font-weight: 900;
  letter-spacing: -0.03em;
  color: var(--color-text-primary);
}
.hero-copy {
  margin: 0;
  max-width: 70ch;
  font-size: 0.9rem;
  line-height: 1.7;
  color: var(--color-text-secondary);
}
.hero-status {
  align-self: stretch;
  display: flex;
  flex-direction: column;
  justify-content: center;
  gap: 8px;
  padding: 16px;
  border-radius: 16px;
  border: 1px solid rgba(148,163,184,0.18);
  background: rgba(255,255,255,0.66);
  box-shadow: inset 0 1px 0 rgba(255,255,255,0.7);
}
.status-pill {
  width: fit-content;
  padding: 5px 10px;
  border-radius: 999px;
  font-size: 0.76rem;
  font-weight: 800;
}
.status-pill.sehat { background: rgba(22,163,74,0.12); color: #15803d; }
.status-pill.waspada { background: rgba(245,158,11,0.15); color: #b45309; }
.status-pill.kritis { background: rgba(239,68,68,0.13); color: #b91c1c; }
.status-main { font-size: 1.22rem; font-weight: 900; letter-spacing: -0.03em; color: var(--color-text-primary); }
.status-note { font-size: 0.84rem; line-height: 1.6; color: var(--color-text-secondary); }


.inv-status-card {
  display: grid;
  grid-template-columns: minmax(0, 1.7fr) minmax(280px, 1fr);
  gap: 18px;
  padding: 24px;
  border-radius: 22px;
  border: 1px solid rgba(37,99,235,0.12);
  background:
    radial-gradient(circle at top right, rgba(20,184,166,0.18), transparent 35%),
    radial-gradient(circle at bottom left, rgba(99,102,241,0.08), transparent 40%),
    linear-gradient(135deg, rgba(37,99,235,0.05), rgba(20,184,166,0.04)),
    var(--color-background-secondary);
}
.inv-status-card.safe {
  border-color: rgba(22,163,74,0.30);
  background:
    radial-gradient(circle at top right, rgba(22,163,74,0.16), transparent 35%),
    linear-gradient(135deg, rgba(22,163,74,0.095), rgba(16,185,129,0.045)),
    var(--color-background-secondary);
}
.inv-status-card.warn {
  border-color: rgba(245,158,11,0.36);
  background:
    radial-gradient(circle at top right, rgba(245,158,11,0.18), transparent 35%),
    linear-gradient(135deg, rgba(245,158,11,0.12), rgba(251,191,36,0.055)),
    var(--color-background-secondary);
}
.inv-status-card.critical {
  border-color: rgba(239,68,68,0.32);
  background:
    radial-gradient(circle at top right, rgba(239,68,68,0.16), transparent 35%),
    linear-gradient(135deg, rgba(239,68,68,0.11), rgba(220,38,38,0.05)),
    var(--color-background-secondary);
}
.inv-status-label {
  font-size: 11px;
  font-weight: 800;
  letter-spacing: 0.13em;
  text-transform: uppercase;
  color: var(--color-text-tertiary);
  margin-bottom: 8px;
}
.inv-status-title {
  margin: 0 0 10px;
  font-size: 1.9rem;
  line-height: 1.1;
  letter-spacing: -0.035em;
  color: var(--color-text-primary);
}
.inv-status-copy {
  margin: 0;
  max-width: 66ch;
  font-size: 0.95rem;
  line-height: 1.75;
  color: var(--color-text-secondary);
}
.inv-status-action {
  margin-top: 14px;
  padding: 12px 14px;
  border-radius: 14px;
  border-left: 4px solid rgba(37,99,235,0.38);
  background: rgba(37,99,235,0.045);
  font-size: 0.88rem;
  line-height: 1.65;
  color: var(--color-text-secondary);
}
.inv-status-card.safe .inv-status-action { border-left-color: rgba(22,163,74,0.48); background: rgba(22,163,74,0.055); }
.inv-status-card.warn .inv-status-action { border-left-color: rgba(245,158,11,0.56); background: rgba(245,158,11,0.065); }
.inv-status-card.critical .inv-status-action { border-left-color: rgba(239,68,68,0.50); background: rgba(239,68,68,0.055); }
.inv-status-action strong { color: var(--color-text-primary); }
.inv-status-metrics { display: flex; flex-direction: column; gap: 10px; }
.inv-status-metric {
  flex: 1;
  padding: 14px 15px;
  border-radius: 14px;
  border: 1px solid var(--color-border-tertiary);
  background: rgba(255,255,255,0.72);
}
.inv-status-metric-label {
  font-size: 10px;
  font-weight: 800;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: var(--color-text-tertiary);
  margin-bottom: 4px;
}
.inv-status-metric-value {
  font-size: 1.05rem;
  font-weight: 850;
  color: var(--color-text-primary);
  letter-spacing: -0.02em;
}
.inv-status-metric-note {
  margin-top: 4px;
  font-size: 0.82rem;
  line-height: 1.6;
  color: var(--color-text-secondary);
}
.inv-summary {
  padding: 17px 18px;
  border-radius: 16px;
  border: 1px solid var(--color-border-tertiary);
  background: var(--color-background-secondary);
  box-shadow: 0 1px 3px rgba(0,0,0,0.035);
}
.inv-summary-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 10px;
  flex-wrap: wrap;
  padding-bottom: 12px;
  margin-bottom: 12px;
  border-bottom: 1px solid var(--color-border-tertiary);
}
.inv-summary-label {
  font-size: 10px;
  font-weight: 850;
  letter-spacing: 0.11em;
  text-transform: uppercase;
  color: var(--color-text-tertiary);
}
.inv-badges { display: flex; align-items: center; gap: 8px; flex-wrap: wrap; }
.inv-badge {
  display: inline-flex;
  align-items: center;
  gap: 5px;
  padding: 4px 10px;
  border-radius: 999px;
  font-size: 11px;
  font-weight: 800;
  border: 1px solid;
}
.inv-badge.safe { background: rgba(22,163,74,0.10); color: #166534; border-color: rgba(22,163,74,0.22); }
.inv-badge.warn { background: rgba(234,179,8,0.10); color: #854d0e; border-color: rgba(234,179,8,0.26); }
.inv-badge.critical { background: rgba(220,38,38,0.08); color: #991b1b; border-color: rgba(220,38,38,0.20); }
.inv-list { display: flex; flex-direction: column; gap: 6px; }
.inv-row {
  display: flex;
  align-items: flex-start;
  gap: 10px;
  padding: 9px 10px;
  border-radius: 10px;
  font-size: 0.84rem;
  line-height: 1.55;
  border: 1px solid transparent;
}
.inv-row.safe { background: rgba(22,163,74,0.045); border-color: rgba(22,163,74,0.12); }
.inv-row.warn { background: rgba(234,179,8,0.045); border-color: rgba(234,179,8,0.16); }
.inv-row.critical { background: rgba(220,38,38,0.04); border-color: rgba(220,38,38,0.13); }
.inv-icon { width: 18px; flex: 0 0 18px; margin-top: 1px; font-size: 14px; line-height: 1.2; text-align: center; }
.inv-row-title { font-weight: 850; color: var(--color-text-primary); }
.inv-row-copy { color: var(--color-text-secondary); }
.inv-row-value { font-weight: 850; color: var(--color-text-primary); }
.inv-analysis-grid { display: grid; grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 12px; }
.inv-analysis-grid.primary,
.inv-analysis-grid.supporting { grid-template-columns: repeat(2, minmax(0, 1fr)); }
.inv-analysis-card {
  padding: 16px;
  border-radius: 16px;
  border: 1px solid var(--color-border-tertiary);
  background: var(--color-background-secondary);
}
.inv-analysis-card.safe { border-color: rgba(22,163,74,0.24); background: rgba(22,163,74,0.045); }
.inv-analysis-card.warn { border-color: rgba(245,158,11,0.28); background: rgba(245,158,11,0.055); }
.inv-analysis-card.critical { border-color: rgba(239,68,68,0.24); background: rgba(239,68,68,0.045); }
.inv-analysis-card.neutral { border-color: rgba(99,102,241,0.18); background: rgba(99,102,241,0.035); }
.inv-analysis-label {
  font-size: 10px;
  font-weight: 800;
  letter-spacing: 0.09em;
  text-transform: uppercase;
  color: var(--color-text-tertiary);
  margin-bottom: 6px;
}
.inv-analysis-title {
  font-size: 0.98rem;
  font-weight: 850;
  color: var(--color-text-primary);
  line-height: 1.3;
  margin-bottom: 6px;
}
.inv-analysis-copy { font-size: 0.84rem; line-height: 1.62; color: var(--color-text-secondary); }
.inv-threshold-line {
  margin-top: 9px;
  padding-top: 8px;
  border-top: 1px dashed rgba(100,116,139,0.24);
  font-size: 0.77rem;
  line-height: 1.55;
  color: var(--color-text-tertiary);
}
.inv-threshold-line strong { color: var(--color-text-primary); }

.hero-wrap {
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
.hero-main {
  display: flex;
  flex-direction: column;
  gap: 8px;
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
.hero-headline {
  margin: 0 0 2px;
  font-size: 1.75rem;
  font-weight: 900;
  letter-spacing: -0.035em;
  color: var(--color-text-primary);
  line-height: 1.12;
}
.hero-side-card {
  min-width: 240px;
  padding: 14px 16px;
  border-radius: 14px;
  border: 1px solid var(--color-border-tertiary);
  background: rgba(255,255,255,0.72);
  display: flex;
  flex-direction: column;
  gap: 7px;
}
.hero-side-label {
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: var(--color-text-tertiary);
}
.hero-side-name {
  font-size: 1rem;
  font-weight: 800;
  color: var(--color-text-primary);
  letter-spacing: -0.02em;
}
.hero-side-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 0.8rem;
  color: var(--color-text-secondary);
  gap: 6px;
}
.hero-side-row strong { color: var(--color-text-primary); }

.metric-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 10px; }
.metric-card {
  padding: 15px 16px;
  border-radius: 14px;
  border: 1px solid var(--color-border-tertiary);
  background: var(--color-background-secondary);
}
.metric-card.good { border-color: rgba(22,163,74,0.24); background: linear-gradient(145deg, rgba(22,163,74,0.07), rgba(16,185,129,0.02)); }
.metric-card.warn { border-color: rgba(245,158,11,0.26); background: linear-gradient(145deg, rgba(245,158,11,0.08), rgba(251,191,36,0.02)); }
.metric-card.bad { border-color: rgba(239,68,68,0.24); background: linear-gradient(145deg, rgba(239,68,68,0.08), rgba(220,38,38,0.02)); }
.metric-card.info { border-color: rgba(59,130,246,0.22); background: linear-gradient(145deg, rgba(59,130,246,0.07), rgba(96,165,250,0.02)); }
.metric-value { margin-top: 6px; font-size: 1.18rem; font-weight: 900; letter-spacing: -0.03em; color: var(--color-text-primary); }
.metric-meta { margin-top: 4px; font-size: 0.8rem; line-height: 1.55; color: var(--color-text-secondary); }

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
.section-title {
  margin: 0;
  font-size: 1.1rem;
  font-weight: 800;
  letter-spacing: -0.02em;
  color: var(--color-text-primary);
}
.section-copy {
  margin: 6px 0 0;
  max-width: 72ch;
  font-size: 0.88rem;
  line-height: 1.7;
  color: var(--color-text-secondary);
}
.timeframe-tag {
  display: inline-block;
  padding: 2px 7px;
  border-radius: 999px;
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 0.05em;
  background: rgba(0,0,0,0.05);
  color: var(--color-text-tertiary);
}

.context-acc {
  border: 1px solid rgba(128, 128, 128, 0.18);
  border-radius: 12px;
  margin: 10px 0;
  overflow: hidden;
  background: rgba(255,255,255,0.55);
}
.context-acc summary {
  padding: 14px 16px;
  cursor: pointer;
  background: rgba(128, 128, 128, 0.04);
  font-size: 0.9rem;
  font-weight: 700;
  list-style: none;
  display: flex;
  align-items: center;
  gap: 8px;
  color: var(--color-text-primary);
}
.context-acc summary::-webkit-details-marker { display: none; }
.context-acc[open] summary { border-bottom: 1px solid rgba(128, 128, 128, 0.14); }
.acc-body {
  padding: 16px;
  font-size: 0.9em;
  line-height: 1.75;
  color: var(--color-text-secondary);
}
.acc-body strong { color: var(--color-text-primary); }
.acc-body ul { margin: 6px 0 0; padding-left: 18px; }
.acc-body li { margin-bottom: 3px; }

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
details.acc-strategic .acc-body { padding: 20px; }

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
.subpage-hero {
  padding: 18px 20px;
  border-radius: 18px;
  border: 1px solid var(--color-border-tertiary);
  background: var(--color-background-secondary);
  display: flex;
  flex-direction: column;
  gap: 6px;
}
.subpage-hero-eyebrow {
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: var(--color-text-tertiary);
}
.subpage-hero-title {
  margin: 0;
  font-size: 1.15rem;
  font-weight: 900;
  letter-spacing: -0.02em;
  color: var(--color-text-primary);
}
.subpage-hero-copy {
  margin: 0;
  font-size: 0.88rem;
  line-height: 1.7;
  color: var(--color-text-secondary);
  max-width: 72ch;
}

.lens-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 12px; }
.lens-card {
  padding: 16px;
  border-radius: 14px;
  border: 1px solid var(--color-border-tertiary);
  background: rgba(255,255,255,0.52);
}
.lens-card.low { border-color: rgba(239,68,68,0.22); background: rgba(239,68,68,0.045); }
.lens-card.over { border-color: rgba(245,158,11,0.25); background: rgba(245,158,11,0.05); }
.lens-card.price { border-color: rgba(59,130,246,0.2); background: rgba(59,130,246,0.045); }
.lens-card.flow { border-color: rgba(20,184,166,0.2); background: rgba(20,184,166,0.045); }
.lens-title { margin-top: 5px; font-size: 0.97rem; font-weight: 850; color: var(--color-text-primary); }
.lens-copy { margin-top: 5px; font-size: 0.84rem; line-height: 1.6; color: var(--color-text-secondary); }
.lens-action {
  margin-top: 9px;
  display: inline-block;
  padding: 6px 10px;
  border-radius: 8px;
  background: rgba(0,0,0,0.04);
  font-size: 0.8rem;
  font-weight: 750;
  color: var(--color-text-primary);
}

.priority-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px; }
.priority-card {
  padding: 15px 16px;
  border-radius: 14px;
  border-left: 4px solid;
  border-top: 1px solid;
  border-right: 1px solid;
  border-bottom: 1px solid;
  background: rgba(255,255,255,0.56);
}
.priority-card.critical { border-color: rgba(239,68,68,0.22); border-left-color: #ef4444; background: rgba(239,68,68,0.045); }
.priority-card.high { border-color: rgba(245,158,11,0.24); border-left-color: #f59e0b; background: rgba(245,158,11,0.045); }
.priority-card.normal { border-color: rgba(100,116,139,0.16); border-left-color: #64748b; background: rgba(100,116,139,0.035); }
.priority-title { margin-top: 5px; font-size: 0.94rem; font-weight: 850; color: var(--color-text-primary); }
.priority-copy { margin-top: 4px; font-size: 0.82rem; line-height: 1.58; color: var(--color-text-secondary); }

.action-stack { display: flex; flex-direction: column; gap: 10px; }
.action-card {
  padding: 17px 18px;
  border-radius: 16px;
  border-left: 4px solid;
  border-top: 1px solid;
  border-right: 1px solid;
  border-bottom: 1px solid;
  display: flex;
  flex-direction: column;
  gap: 6px;
}
.action-card.critical { border-color: rgba(239,68,68,0.22); border-left-color: #ef4444; background: rgba(239,68,68,0.05); }
.action-card.high { border-color: rgba(245,158,11,0.22); border-left-color: #f59e0b; background: rgba(245,158,11,0.05); }
.action-card.medium,
.action-card.moderate { border-color: rgba(59,130,246,0.2); border-left-color: #3b82f6; background: rgba(59,130,246,0.04); }
.action-card.low { border-color: rgba(100,116,139,0.16); border-left-color: #64748b; background: rgba(100,116,139,0.035); }
.action-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 10px;
  flex-wrap: wrap;
}
.action-workline {
  display: flex;
  align-items: center;
  gap: 8px;
  flex-wrap: wrap;
}
.action-rank {
  width: 28px;
  height: 28px;
  border-radius: 999px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  font-size: 0.78rem;
  font-weight: 900;
  color: var(--color-text-primary);
  background: rgba(0,0,0,0.06);
}
.action-severity,
.action-badge {
  display: inline-flex;
  align-items: center;
  gap: 5px;
  padding: 3px 9px;
  border-radius: 999px;
  font-size: 10px;
  font-weight: 800;
  letter-spacing: 0.05em;
}
.action-severity.critical { background: rgba(239,68,68,0.14); color: #b91c1c; }
.action-severity.high { background: rgba(245,158,11,0.15); color: #b45309; }
.action-severity.moderate { background: rgba(59,130,246,0.14); color: #1d4ed8; }
.action-badge {
  background: rgba(0,0,0,0.05);
  color: var(--color-text-tertiary);
}
.action-title {
  font-size: 1rem;
  font-weight: 800;
  color: var(--color-text-primary);
  letter-spacing: -0.02em;
}
.action-copy,
.action-next {
  font-size: 0.85rem;
  line-height: 1.65;
  color: var(--color-text-secondary);
}
.action-next {
  margin-top: 4px;
  padding: 10px 12px;
  border-radius: 12px;
  border: 1px solid rgba(99,102,241,0.13);
  background: rgba(255,255,255,0.55);
}
.action-copy strong,
.action-next strong { color: var(--color-text-primary); }
.action-impact {
  font-size: 1.05rem;
  font-weight: 900;
  letter-spacing: -0.025em;
  color: var(--color-text-primary);
}
.action-impact span {
  font-size: 0.78rem;
  font-weight: 700;
  letter-spacing: 0;
  color: var(--color-text-secondary);
}

.guide-acc {
  border: 1px solid rgba(128,128,128,0.18);
  border-radius: 14px;
  background: rgba(255,255,255,0.58);
  overflow: hidden;
}
.guide-acc summary {
  padding: 14px 16px;
  cursor: pointer;
  background: rgba(128,128,128,0.03);
  list-style: none;
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 0.9rem;
  font-weight: 800;
  color: var(--color-text-primary);
}
.guide-acc summary::-webkit-details-marker { display: none; }
.guide-acc[open] summary {
  border-bottom: 1px solid rgba(128,128,128,0.14);
}
.guide-body {
  padding: 0 16px 16px;
  font-size: 0.88rem;
  line-height: 1.75;
  color: var(--color-text-secondary);
}
.guide-body strong { color: var(--color-text-primary); }

.branch-health-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 14px;
  margin-bottom: 16px;
}
.branch-health-card {
  padding: 18px;
  border-radius: 16px;
  border: 1.5px solid var(--color-border-tertiary);
  background: var(--color-background-secondary);
  display: flex;
  flex-direction: column;
  gap: 10px;
  min-height: 260px;
}
.branch-health-card.sehat {
  border-color: rgba(22,163,74,0.3);
  background: linear-gradient(160deg, rgba(22,163,74,0.07), rgba(16,185,129,0.03));
}
.branch-health-card.waspada {
  border-color: rgba(245,158,11,0.32);
  background: linear-gradient(160deg, rgba(245,158,11,0.08), rgba(251,191,36,0.03));
}
.branch-health-card.kritis {
  border-color: rgba(239,68,68,0.3);
  background: linear-gradient(160deg, rgba(239,68,68,0.08), rgba(220,38,38,0.03));
}
.branch-status-badge {
  display: inline-flex;
  align-items: center;
  padding: 3px 9px;
  border-radius: 999px;
  font-size: 10px;
  font-weight: 800;
  letter-spacing: 0.05em;
  width: fit-content;
}
.branch-status-badge.sehat { background: rgba(22,163,74,0.15); color: #15803d; }
.branch-status-badge.waspada { background: rgba(245,158,11,0.18); color: #b45309; }
.branch-status-badge.kritis { background: rgba(239,68,68,0.15); color: #b91c1c; }
.branch-card-name {
  font-size: 1rem;
  font-weight: 800;
  letter-spacing: -0.02em;
  color: var(--color-text-primary);
}
.branch-margin-main {
  font-size: 1.9rem;
  font-weight: 900;
  letter-spacing: -0.04em;
  line-height: 1;
}
.branch-margin-main.sehat { color: #15803d; }
.branch-margin-main.waspada { color: #b45309; }
.branch-margin-main.kritis { color: #b91c1c; }
.branch-margin-label {
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: var(--color-text-tertiary);
  margin-top: 2px;
}
.branch-margin-structural {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 6px;
  font-size: 0.82rem;
  color: var(--color-text-secondary);
  padding: 6px 0;
  border-top: 1px solid var(--color-border-tertiary);
}
.branch-margin-structural strong {
  color: var(--color-text-primary);
}
.branch-stats-row {
  display: flex;
  flex-direction: column;
  gap: 3px;
  font-size: 0.8rem;
  color: var(--color-text-secondary);
}
.branch-diagnosis {
  font-size: 0.85rem;
  line-height: 1.65;
  color: var(--color-text-secondary);
  padding: 10px 12px;
  border-radius: 12px;
  border: 1px solid rgba(99,102,241,0.12);
  background: linear-gradient(135deg, rgba(99,102,241,0.045), rgba(139,92,246,0.025));
}
.branch-next-link {
  font-size: 0.78rem;
  font-weight: 700;
  color: var(--color-text-tertiary);
}
.action-summary-grid,
.action-split-grid {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 12px;
  margin-bottom: 14px;
}
.action-summary-card {
  padding: 15px 16px;
  border-radius: 15px;
  border: 1px solid var(--color-border-tertiary);
  background: rgba(255,255,255,0.64);
}
.action-summary-value {
  font-size: 1.18rem;
  font-weight: 900;
  letter-spacing: -0.03em;
  color: var(--color-text-primary);
}
.action-summary-copy {
  margin-top: 5px;
  font-size: 0.8rem;
  line-height: 1.55;
  color: var(--color-text-secondary);
}
.action-card {
  padding: 17px 18px;
  border-radius: 16px;
  border-left: 4px solid;
  border-top: 1px solid;
  border-right: 1px solid;
  border-bottom: 1px solid;
  display: flex;
  flex-direction: column;
  gap: 6px;
}
.action-card.critical {
  border-left-color: #ef4444;
  border-color: rgba(239,68,68,0.22);
  background: rgba(239,68,68,0.05);
}
.action-card.high {
  border-left-color: #f59e0b;
  border-color: rgba(245,158,11,0.25);
  background: rgba(245,158,11,0.05);
}
.action-card.moderate {
  border-left-color: #3b82f6;
  border-color: rgba(59,130,246,0.22);
  background: rgba(59,130,246,0.05);
}
.action-card.pantau {
  border-left-color: #10b981;
  border-color: rgba(16,185,129,0.22);
  background: rgba(16,185,129,0.05);
}
.action-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.action-workline {
  display: flex;
  align-items: center;
  gap: 8px;
}
.action-rank {
  font-size: 11px;
  font-weight: 800;
  color: var(--color-text-tertiary);
}
.action-severity {
  font-size: 10px;
  font-weight: 800;
  padding: 2px 6px;
  border-radius: 4px;
  text-transform: uppercase;
}
.action-severity.critical { background: rgba(239,68,68,0.15); color: #b91c1c; }
.action-severity.high { background: rgba(245,158,11,0.18); color: #b45309; }
.action-severity.moderate { background: rgba(59,130,246,0.15); color: #1d4ed8; }
.action-severity.pantau { background: rgba(16,185,129,0.15); color: #047857; }
.action-badge {
  font-size: 10px;
  font-weight: 700;
  color: var(--color-text-tertiary);
  background: rgba(0,0,0,0.05);
  padding: 2px 6px;
  border-radius: 4px;
}
.action-impact {
  text-align: right;
  font-size: 1.1rem;
  font-weight: 800;
  color: var(--color-text-primary);
}
.action-impact span {
  display: block;
  font-size: 9px;
  color: var(--color-text-tertiary);
  text-transform: uppercase;
  font-weight: 700;
}
.action-title {
  font-size: 0.98rem;
  font-weight: 800;
  color: var(--color-text-primary);
}
.action-copy {
  font-size: 0.86rem;
  line-height: 1.6;
  color: var(--color-text-secondary);
}
.action-empty {
  padding: 32px;
  text-align: center;
  border: 1.5px dashed var(--color-border-tertiary);
  border-radius: 20px;
  background: var(--color-background-secondary);
}
.action-empty .title {
  font-size: 1.05rem;
  font-weight: 800;
  color: var(--color-text-primary);
  margin-bottom: 6px;
}

.evidence-tabs-container {
  display: inline-flex;
  background-color: var(--color-background-tertiary, #f3f4f6);
  padding: 4px;
  border-radius: 12px;
  gap: 2px;
  border: 1px solid var(--color-border-tertiary, #e5e7eb);
  margin-top: 10px;
  margin-bottom: 16px;
}

.tab-button {
  padding: 6px 14px;
  font-size: 0.85rem;
  font-weight: 600;
  color: var(--color-text-secondary, #4b5563);
  text-decoration: none;
  border-radius: 9px;
  transition: all 0.2s ease;
  display: inline-flex;
  align-items: center;
  gap: 6px;
}

.tab-button:hover {
  color: var(--color-text-primary, #111827);
  background-color: rgba(255, 255, 255, 0.4);
}

.tab-button.active {
  color: var(--color-text-primary, #111827);
  background-color: var(--color-background-primary, #ffffff);
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1), 0 1px 2px rgba(0, 0, 0, 0.06);
}
</style>


```sql inv_dates
SELECT
    strftime('%d %b %Y', MAX(txn_date))                       AS tgl_akhir,
    strftime('%d %b %Y', MAX(txn_date) - INTERVAL '6 days')  AS tgl_7d_awal,
    strftime('%d %b %Y', MAX(txn_date) - INTERVAL '29 days') AS tgl_30d_awal,
    strftime('%d %b %Y', MAX(txn_date) - INTERVAL '89 days') AS tgl_90d_awal
FROM restaurant.inventory_stok
```

```sql inv_supplier_alerts
WITH max_d AS (SELECT MAX(txn_date)::DATE AS d FROM restaurant.inventory_stok)
SELECT
    item_name,
    category,
    ROUND(AVG(base_unit_cost),0) AS base_unit_cost,
    ROUND(AVG(avg_unit_cost),0) AS avg_unit_cost,
    ROUND((AVG(avg_unit_cost)-AVG(base_unit_cost))/NULLIF(AVG(base_unit_cost),0)*100,1) AS price_variance_pct,
    SUM(usage_cost) AS usage_cost_30d,
    ROUND(SUM(usage_cost) * GREATEST((AVG(avg_unit_cost)-AVG(base_unit_cost))/NULLIF(AVG(base_unit_cost),0),0),0) AS estimated_price_impact,
    CASE
        WHEN (AVG(avg_unit_cost)-AVG(base_unit_cost))/NULLIF(AVG(base_unit_cost),0)*100 >= 20 THEN 'Kritis'
        ELSE 'Waspada'
    END AS severity
FROM restaurant.inventory_stok CROSS JOIN max_d
WHERE txn_date >= d - INTERVAL '29 days'
GROUP BY 1, 2
HAVING (AVG(avg_unit_cost)-AVG(base_unit_cost))/NULLIF(AVG(base_unit_cost),0)*100 > 10
ORDER BY estimated_price_impact DESC, price_variance_pct DESC
```

```sql inv_price_trend_weekly
WITH max_d AS (SELECT MAX(txn_date)::DATE AS d FROM restaurant.inventory_stok)
SELECT
    DATE_TRUNC('week', txn_date) AS minggu,
    item_name,
    category,
    ROUND(AVG(avg_unit_cost),0) AS harga_rata_beli,
    ROUND(AVG(base_unit_cost),0) AS harga_dasar
FROM restaurant.inventory_stok CROSS JOIN max_d
WHERE txn_date >= d - INTERVAL '89 days'
GROUP BY 1, 2, 3
ORDER BY 1, 2
```

```sql inv_price_trend_weekly_focus
WITH max_d AS (SELECT MAX(txn_date)::DATE AS d FROM restaurant.inventory_stok),
top_items AS (
    SELECT item_name
    FROM ${inv_supplier_alerts}
    ORDER BY estimated_price_impact DESC
    LIMIT 5
)
SELECT
    DATE_TRUNC('week', txn_date) AS minggu,
    i.item_name,
    i.category,
    ROUND(AVG(avg_unit_cost),0) AS harga_rata_beli,
    ROUND(AVG(base_unit_cost),0) AS harga_dasar
FROM restaurant.inventory_stok i
CROSS JOIN max_d
INNER JOIN top_items t ON i.item_name = t.item_name
WHERE txn_date >= d - INTERVAL '89 days'
GROUP BY 1, 2, 3
ORDER BY 1, 2
```

```sql inv_volatility_summary
WITH max_d AS (SELECT MAX(txn_date)::DATE AS d FROM restaurant.inventory_stok)
SELECT
    item_name,
    category,
    ROUND(MIN(avg_unit_cost),0) AS harga_min,
    ROUND(MAX(avg_unit_cost),0) AS harga_maks,
    ROUND(AVG(avg_unit_cost),0) AS harga_rata,
    ROUND(AVG(base_unit_cost),0) AS harga_dasar,
    ROUND((MAX(avg_unit_cost)-MIN(avg_unit_cost))/NULLIF(MIN(avg_unit_cost),0)*100,1) AS volatilitas_pct,
    ROUND((AVG(avg_unit_cost)-AVG(base_unit_cost))/NULLIF(AVG(base_unit_cost),0)*100,1) AS selisih_vs_dasar_pct,
    CASE
        WHEN ROUND((MAX(avg_unit_cost)-MIN(avg_unit_cost))/NULLIF(MIN(avg_unit_cost),0)*100,1) >= 30 THEN 'Sangat Volatil'
        WHEN ROUND((MAX(avg_unit_cost)-MIN(avg_unit_cost))/NULLIF(MIN(avg_unit_cost),0)*100,1) >= 15 THEN 'Volatil'
        WHEN ROUND((MAX(avg_unit_cost)-MIN(avg_unit_cost))/NULLIF(MIN(avg_unit_cost),0)*100,1) >= 5 THEN 'Moderat'
        ELSE 'Stabil'
    END AS kategori_volatilitas
FROM restaurant.inventory_stok CROSS JOIN max_d
WHERE txn_date >= d - INTERVAL '89 days'
GROUP BY 1, 2
ORDER BY volatilitas_pct DESC
```

<div class="evidence-tabs-container">
  <a href="/03-inventori-stok" class="tab-button ">🏠 Ringkasan</a>
  <a href="/03-inventori-stok/reorder" class="tab-button ">🛒 Reorder</a>
  <a href="/03-inventori-stok/overstock" class="tab-button ">📦 Overstock</a>
  <a href="/03-inventori-stok/supplier" class="tab-button active">💹 Supplier</a>
  <a href="/03-inventori-stok/branch" class="tab-button ">🏪 Cabang</a>
  <a href="/03-inventori-stok/action" class="tab-button ">🎯 Pusat Aksi</a>
</div>


<div class="inv-page">

  <div class="subpage-hero">
    <div class="subpage-hero-eyebrow">💹 SUPPLIER PRESSURE</div>
    <h3 class="subpage-hero-title">Analisis Volatilitas &amp; Kenaikan Harga Supplier</h3>
    <p class="subpage-hero-copy">Pantau item dengan kenaikan harga beli aktual di atas 10% dari harga dasar untuk prioritas negosiasi kontrak.</p>
  </div>

  <div class="section-card" style="margin-top: 16px;">
    <div class="section-head">
      <div class="section-eyebrow">⚠️ ALERT HARGA BELI SUPPLIER (30H)</div>
      <h3 class="section-title">Item dengan Kenaikan Harga Terbesar</h3>
      <p class="section-copy">Harga rata-rata pembelian aktual yang melebihi 10% dari baseline harga dasar kontrak supplier.</p>
    </div>
    <DataTable data={inv_supplier_alerts} search=true rows=10>
      <Column id="item_name" title="Bahan" />
      <Column id="category" title="Kategori" />
      <Column id="base_unit_cost" title="Harga Dasar" fmt="#,##0" />
      <Column id="avg_unit_cost" title="Harga Rata-Rata" fmt="#,##0" />
      <Column id="price_variance_pct" title="Variance (%)" fmt="0.0" />
      <Column id="usage_cost_30d" title="Pemakaian 30H" fmt="#,##0" />
      <Column id="estimated_price_impact" title="Estimasi Dampak" fmt="#,##0" />
      <Column id="severity" title="Status" />
    </DataTable>
  </div>

  <div class="section-card" style="margin-top: 16px;">
    <div class="section-head">
      <div class="section-eyebrow">📈 Tren Harga &amp; Volatilitas (90H)</div>
      <h3 class="section-title">Rincian Volatilitas &amp; Tren Harga Historis</h3>
      <p class="section-copy">Analisis volatilitas membantu mengidentifikasi bahan baku dengan fluktuasi harga tinggi untuk penyesuaian strategi purchasing.</p>
    </div>
    <Grid cols=2>
      <div>
        <DataTable data={inv_volatility_summary} search=true rows=8>
          <Column id="item_name" title="Bahan" />
          <Column id="harga_min" title="Min" fmt="#,##0" />
          <Column id="harga_maks" title="Maks" fmt="#,##0" />
          <Column id="harga_rata" title="Rata-rata" fmt="#,##0" />
          <Column id="volatilitas_pct" title="Volatilitas (%)" fmt="0.0" />
          <Column id="selisih_vs_dasar_pct" title="Selisih vs Dasar (%)" fmt="0.0" />
          <Column id="kategori_volatilitas" title="Volatilitas" />
        </DataTable>
      </div>
      <div>
        {#if inv_price_trend_weekly.length > 0}
          <LineChart data={inv_price_trend_weekly} x="minggu" y="harga_rata_beli" series="item_name" title="Tren Harga Beli Mingguan (Top Alert)" xAxisTitle="Minggu" yAxisTitle="Harga Rata-Rata (Rp)" />
        {/if}
      </div>
    </Grid>
  </div>

</div>
