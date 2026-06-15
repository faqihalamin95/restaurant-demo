---
title: Inventori & Stok
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

```sql inv_inventory_overview
WITH max_d AS (
    SELECT MAX(txn_date)::DATE AS d FROM restaurant.inventory_stok
),
latest AS (
    SELECT *
    FROM restaurant.inventory_stok CROSS JOIN max_d
    WHERE txn_date = d
),
movement_7 AS (
    SELECT
        SUM(usage_cost) AS usage_cost_7d,
        SUM(purchase_cost) AS purchase_cost_7d
    FROM restaurant.inventory_stok CROSS JOIN max_d
    WHERE txn_date >= d - INTERVAL '6 days'
),
movement_30 AS (
    SELECT
        SUM(usage_cost) AS usage_cost_30d,
        SUM(purchase_cost) AS purchase_cost_30d,
        ROUND(SUM(purchase_cost)/NULLIF(SUM(usage_cost),0),2) AS purchase_usage_ratio_30d
    FROM restaurant.inventory_stok CROSS JOIN max_d
    WHERE txn_date >= d - INTERVAL '29 days'
),
price_30 AS (
    SELECT
        ROUND(AVG(CASE WHEN base_unit_cost > 0 THEN (avg_unit_cost-base_unit_cost)/base_unit_cost*100 END),1) AS avg_price_variance_pct,
        COUNT(DISTINCT CASE WHEN base_unit_cost > 0 AND (avg_unit_cost-base_unit_cost)/base_unit_cost*100 > 10 THEN item_name END) AS price_alert_items
    FROM restaurant.inventory_stok CROSS JOIN max_d
    WHERE txn_date >= d - INTERVAL '29 days'
),
summary AS (
    SELECT
        COUNT(*) AS stock_points,
        COUNT(DISTINCT item_name) AS total_items,
        COUNT(DISTINCT branch_name) AS total_branches,
        ROUND(SUM(stock_value),0) AS stock_value,
        SUM(CASE WHEN stock_status = 'low' OR days_remaining < 3 THEN 1 ELSE 0 END) AS low_points,
        COUNT(DISTINCT CASE WHEN stock_status = 'low' OR days_remaining < 3 THEN item_name END) AS low_items,
        SUM(CASE WHEN stock_status = 'overstock' OR days_remaining > 14 THEN 1 ELSE 0 END) AS overstock_points,
        COUNT(DISTINCT CASE WHEN stock_status = 'overstock' OR days_remaining > 14 THEN item_name END) AS overstock_items,
        ROUND(SUM(CASE WHEN stock_status = 'overstock' OR days_remaining > 14 THEN stock_value ELSE 0 END),0) AS overstock_value,
        ROUND(MIN(days_remaining),1) AS min_days_remaining
    FROM latest
)
SELECT
    s.*,
    m7.usage_cost_7d,
    m7.purchase_cost_7d,
    m30.usage_cost_30d,
    m30.purchase_cost_30d,
    m30.purchase_usage_ratio_30d,
    p.avg_price_variance_pct,
    p.price_alert_items,
    ROUND(s.overstock_value / NULLIF(s.stock_value,0) * 100,1) AS overstock_value_pct,
    CASE
        WHEN s.low_points > 0 THEN 'Kritis'
        WHEN s.overstock_value / NULLIF(s.stock_value,0) > 0.25 OR p.price_alert_items > 0 OR m30.purchase_usage_ratio_30d > 1.3 THEN 'Waspada'
        ELSE 'Sehat'
    END AS health_status,
    CASE
        WHEN s.low_points > 0 THEN 'Ada item yang mendekati habis. Prioritas pertama adalah mencegah menu tidak bisa dijual.'
        WHEN s.overstock_value / NULLIF(s.stock_value,0) > 0.25 THEN 'Modal mulai tertahan di stok berlebih. Cek tab Overstock untuk item dan cabang spesifik.'
        WHEN p.price_alert_items > 0 THEN 'Harga supplier mulai menekan biaya bahan. Cek tab Supplier untuk prioritas negosiasi.'
        WHEN m30.purchase_usage_ratio_30d > 1.3 THEN 'Pembelian lebih cepat dari pemakaian. Jadwal pengadaan perlu direview.'
        ELSE 'Stok aktual, ritme pemakaian, dan tekanan harga masih terkendali.'
    END AS diagnosis
FROM summary s, movement_7 m7, movement_30 m30, price_30 p
```

```sql inv_stock_value_by_category
WITH max_d AS (SELECT MAX(txn_date)::DATE AS d FROM restaurant.inventory_stok)
SELECT
    category,
    ROUND(SUM(stock_value),0) AS stock_value,
    ROUND(SUM(CASE WHEN stock_status = 'overstock' OR days_remaining > 14 THEN stock_value ELSE 0 END),0) AS overstock_value,
    SUM(CASE WHEN stock_status = 'low' OR days_remaining < 3 THEN 1 ELSE 0 END) AS low_points,
    ROUND(AVG(days_remaining),1) AS avg_days_remaining
FROM restaurant.inventory_stok CROSS JOIN max_d
WHERE txn_date = d
GROUP BY 1
ORDER BY stock_value DESC
```

<div class="evidence-tabs-container">
  <a href="/03-inventori-stok" class="tab-button active">🏠 Ringkasan</a>
  <a href="/03-inventori-stok/reorder" class="tab-button ">🛒 Reorder</a>
  <a href="/03-inventori-stok/overstock" class="tab-button ">📦 Overstock</a>
  <a href="/03-inventori-stok/supplier" class="tab-button ">💹 Supplier</a>
  <a href="/03-inventori-stok/branch" class="tab-button ">🏪 Cabang</a>
  <a href="/03-inventori-stok/action" class="tab-button ">🎯 Pusat Aksi</a>
</div>


{#if inv_inventory_overview.length > 0}
<div class="inv-page">

  <div class="inv-hero">
    <div>
      <div class="hero-kicker">Snapshot Stok Aktual</div>
      <h2 class="hero-title">Kesehatan &amp; Efisiensi Stok Aktual</h2>
      <p class="hero-copy">Dashboard Inventory Control Center Restoran. Pantau saldo fisik terbaru, estimasi sisa hari coverage pemakaian harian, dan deteksi risiko operasional serta keuangan.</p>
    </div>
    <div class="hero-status">
      <div class="status-label">Status Dashboard</div>
      <span class="status-pill {inv_inventory_overview[0].health_status === 'Sehat' ? 'sehat' : inv_inventory_overview[0].health_status === 'Waspada' ? 'waspada' : 'kritis'}">
        {inv_inventory_overview[0].health_status}
      </span>
      <div class="status-main">{inv_inventory_overview[0].health_status === 'Sehat' ? 'Stok Terkendali' : inv_inventory_overview[0].health_status === 'Waspada' ? 'Perlu Perhatian' : 'Sinyal Kritis Terdeteksi'}</div>
      <div class="status-note">{inv_inventory_overview[0].diagnosis}</div>
    </div>
  </div>

  <details class="acc-strategic" open>
    <summary>Kenapa stok aktual dan pergerakan (movement) dipisah?</summary>
    <div class="acc-body">
      <div class="section-head">
        <div>
          <div class="section-eyebrow">Penyebab Operasional</div>
          <h3 class="section-title">Posisi stok dulu, baru ritme pembelian</h3>
          <p class="section-copy">Stok aktual menjawab kondisi hari ini. Movement membantu mencari penyebab: pemakaian naik, pembelian terlalu cepat/lambat, atau supplier mulai mahal.</p>
        </div>
      </div>
      <div class="inv-analysis-grid">
        <div class="inv-analysis-card {inv_inventory_overview[0].low_points > 0 ? 'critical' : 'safe'}">
          <div class="inv-analysis-label">Low Stock</div>
          <div class="inv-analysis-title">{inv_inventory_overview[0].low_items ?? 0} item rawan habis</div>
          <div class="inv-analysis-copy">Low stock membaca ketersediaan fisik hari ini di outlet. Kurang dari 5 hari coverage berarti risiko stockout tinggi.</div>
          <div class="inv-threshold-line"><strong>Batas:</strong> 0 aman · lebih dari 0 perlu cek Reorder · coverage di bawah 3 hari prioritas cepat</div>
        </div>
        <div class="inv-analysis-card {(inv_inventory_overview[0].overstock_value_pct ?? 0) > 25 ? 'warn' : 'safe'}">
          <div class="inv-analysis-label">Overstock</div>
          <div class="inv-analysis-title">{inv_inventory_overview[0].overstock_value_pct ?? 0}% nilai stok</div>
          <div class="inv-analysis-copy">Overstock membaca uang yang terlalu lama diam sebagai stok dan berpotensi waste, terutama bahan mudah rusak.</div>
          <div class="inv-threshold-line"><strong>Batas:</strong> sampai 25% terkendali · di atas 25% perlu cek Overstock dan transfer antar cabang</div>
        </div>
      </div>
    </div>
  </details>

  <div class="inv-summary">
    <div class="inv-summary-head">
      <div class="inv-summary-label">Sinyal Pendukung Operasional</div>
      <div class="inv-badges">
        <span class="inv-badge warn">harga supplier</span>
        <span class="inv-badge warn">beli/pakai 30H</span>
      </div>
    </div>
    <div class="inv-list">
      <div class="inv-row {(inv_inventory_overview[0].price_alert_items ?? 0) > 0 ? 'warn' : 'safe'}">
        <div class="inv-icon">{(inv_inventory_overview[0].price_alert_items ?? 0) > 0 ? '⚠️' : '✅'}</div>
        <div><span class="inv-row-title">Tekanan supplier</span> <span class="inv-row-copy">- <span class="inv-row-value">{inv_inventory_overview[0].price_alert_items ?? 0} item price alert</span>. Harga naik perlu dicek karena bisa menekan margin menu.</span></div>
      </div>
      <div class="inv-row {(inv_inventory_overview[0].purchase_usage_ratio_30d ?? 1) > 1.3 || (inv_inventory_overview[0].purchase_usage_ratio_30d ?? 1) < 0.8 ? 'warn' : 'safe'}">
        <div class="inv-icon">{(inv_inventory_overview[0].purchase_usage_ratio_30d ?? 1) > 1.3 || (inv_inventory_overview[0].purchase_usage_ratio_30d ?? 1) < 0.8 ? '⚠️' : '✅'}</div>
        <div><span class="inv-row-title">Rasio beli/pakai</span> <span class="inv-row-copy">- <span class="inv-row-value">{inv_inventory_overview[0].purchase_usage_ratio_30d ?? 0}x</span>. Normal 0.8-1.3x; di luar itu perlu validasi bersama stok aktual.</span></div>
      </div>
    </div>
  </div>

  <details class="acc-strategic">
    <summary>Kenapa stok aktual dan movement dipisah?</summary>
    <div class="acc-body">
      <div class="section-head">
        <div>
          <div class="section-eyebrow">Penyebab Operasional</div>
          <h3 class="section-title">Posisi stok dulu, baru ritme pembelian</h3>
          <p class="section-copy">Stok aktual menjawab kondisi hari ini. Movement 7H/30H membantu mencari penyebab: pemakaian naik, pembelian terlalu cepat/lambat, atau supplier mulai mahal.</p>
        </div>
      </div>
      <div class="inv-analysis-grid supporting">
        <div class="inv-analysis-card {(inv_inventory_overview[0].price_alert_items ?? 0) > 0 ? 'warn' : 'safe'}">
          <div class="inv-analysis-label">Supplier</div>
          <div class="inv-analysis-title">{inv_inventory_overview[0].price_alert_items ?? 0} item alert</div>
          <div class="inv-analysis-copy">Gunakan subpage Supplier untuk mencari item dengan kenaikan harga terbesar dan bukti negosiasi.</div>
          <div class="inv-threshold-line"><strong>Alert:</strong> harga &gt;10% dari baseline supplier.</div>
        </div>
        <div class="inv-analysis-card {(inv_inventory_overview[0].purchase_usage_ratio_30d ?? 1) > 1.3 || (inv_inventory_overview[0].purchase_usage_ratio_30d ?? 1) < 0.8 ? 'warn' : 'safe'}">
          <div class="inv-analysis-label">Beli/Pakai</div>
          <div class="inv-analysis-title">{inv_inventory_overview[0].purchase_usage_ratio_30d ?? 0}x</div>
          <div class="inv-analysis-copy">Rasio ini hanya sinyal pendukung. Tetap konfirmasi dengan days remaining dan low stock aktual.</div>
          <div class="inv-threshold-line"><strong>Batas:</strong> 0.8-1.3x normal · &gt;1.3 risiko overstock · &lt;0.8 risiko pembelian tertinggal</div>
        </div>
      </div>
    </div>
  </details>

  <div class="section-card">
    <div class="section-head">
      <div>
        <div class="section-eyebrow">Konteks Lanjutan</div>
        <h3 class="section-title">Pilih subpage sesuai pertanyaan</h3>
        <p class="section-copy">Gunakan bagian ini untuk deep dive tanpa membaca semua tabel sekaligus.</p>
      </div>
    </div>
    <div class="inv-analysis-grid">
      <div class="inv-analysis-card {(inv_inventory_overview[0].low_points ?? 0) > 0 ? 'critical' : 'safe'}">
        <div class="inv-analysis-label">Reorder</div>
        <div class="inv-analysis-title">{inv_inventory_overview[0].low_items ?? 0} item terdampak</div>
        <div class="inv-analysis-copy">Cegah stockout dengan melihat item-cabang yang coverage-nya paling pendek.</div>
      </div>
      <div class="inv-analysis-card {(inv_inventory_overview[0].overstock_value_pct ?? 0) > 25 ? 'warn' : 'safe'}">
        <div class="inv-analysis-label">Overstock</div>
        <div class="inv-analysis-title">{inv_inventory_overview[0].overstock_items ?? 0} item</div>
        <div class="inv-analysis-copy">Cari item yang terlalu lama menumpuk dan kandidat tahan PO atau transfer.</div>
      </div>
      <div class="inv-analysis-card {(inv_inventory_overview[0].price_alert_items ?? 0) > 0 ? 'warn' : 'safe'}">
        <div class="inv-analysis-label">Supplier</div>
        <div class="inv-analysis-title">{inv_inventory_overview[0].price_alert_items ?? 0} alert</div>
        <div class="inv-analysis-copy">Cek bahan yang harganya naik dan dampak rupiah terbesarnya.</div>
      </div>
      <div class="inv-analysis-card neutral">
        <div class="inv-analysis-label">Cabang</div>
        <div class="inv-analysis-title">Ritme outlet</div>
        <div class="inv-analysis-copy">Bandingkan cabang mana yang rawan habis, overstock, atau pembeliannya tidak seimbang.</div>
      </div>
    </div>
  </div>

  <div class="branch-health-grid">
    <div class="branch-health-card {inv_inventory_overview[0].low_points > 0 ? 'kritis' : 'sehat'}">
      <div style="display:flex;justify-content:space-between;gap:10px;align-items:flex-start;">
        <div class="branch-card-name">Availability</div>
        <span class="branch-status-badge {inv_inventory_overview[0].low_points > 0 ? 'kritis' : 'sehat'}">{inv_inventory_overview[0].low_points > 0 ? 'Rawan Habis' : 'Aman'}</span>
      </div>
      <div class="branch-margin-main {inv_inventory_overview[0].low_points > 0 ? 'kritis' : 'sehat'}">{inv_inventory_overview[0].low_points ?? 0} titik</div>
      <div class="branch-margin-label">Low stock aktif</div>
      <div class="branch-margin-structural">
        <span>Item terdampak <strong>{inv_inventory_overview[0].low_items ?? 0}</strong></span>
        <span>Coverage minimum <strong>{inv_inventory_overview[0].min_days_remaining ?? 0} hari</strong></span>
      </div>
      <div class="branch-stats-row">
        <div>Periode baca: snapshot stok aktual.</div>
        <div>Ambang cepat: coverage di bawah 5 hari.</div>
      </div>
      <div class="branch-diagnosis">Jika ada titik low stock, buka Reorder sebelum membaca isu efisiensi. Stockout berdampak langsung ke menu yang tidak bisa dijual.</div>
      <div class="branch-next-link">Next: Reorder</div>
    </div>

    <div class="branch-health-card {inv_inventory_overview[0].overstock_value_pct > 25 ? 'waspada' : 'sehat'}">
      <div style="display:flex;justify-content:space-between;gap:10px;align-items:flex-start;">
        <div class="branch-card-name">Working Capital</div>
        <span class="branch-status-badge {inv_inventory_overview[0].overstock_value_pct > 25 ? 'waspada' : 'sehat'}">{inv_inventory_overview[0].overstock_value_pct > 25 ? 'Modal Tertahan' : 'Terkendali'}</span>
      </div>
      <div class="branch-margin-main {inv_inventory_overview[0].overstock_value_pct > 25 ? 'waspada' : 'sehat'}">Rp {((inv_inventory_overview[0].overstock_value ?? 0)/1000000).toFixed(1)}jt</div>
      <div class="branch-margin-label">Estimasi nilai overstock</div>
      <div class="branch-margin-structural">
        <span>Porsi stok <strong>{inv_inventory_overview[0].overstock_value_pct ?? 0}%</strong></span>
        <span>Item overstock <strong>{inv_inventory_overview[0].overstock_items ?? 0}</strong></span>
      </div>
      <div class="branch-stats-row">
        <div>Total nilai stok: <strong>Rp {((inv_inventory_overview[0].stock_value ?? 0)/1000000).toFixed(1)}jt</strong></div>
        <div>Ambang awal: coverage di atas 14 hari.</div>
      </div>
      <div class="branch-diagnosis">Kartu ini menjawab apakah uang terlalu banyak diam sebagai stok. Jika tinggi, tahan PO baru atau pindahkan stok ke cabang yang butuh.</div>
      <div class="branch-next-link">Next: Overstock</div>
    </div>

    <div class="branch-health-card {inv_inventory_overview[0].price_alert_items > 0 ? 'waspada' : 'sehat'}">
      <div style="display:flex;justify-content:space-between;gap:10px;align-items:flex-start;">
        <div class="branch-card-name">Supplier Pressure</div>
        <span class="branch-status-badge {inv_inventory_overview[0].price_alert_items > 0 ? 'waspada' : 'sehat'}">{inv_inventory_overview[0].price_alert_items > 0 ? 'Harga Naik' : 'Normal'}</span>
      </div>
      <div class="branch-margin-main {inv_inventory_overview[0].price_alert_items > 0 ? 'waspada' : 'sehat'}">{inv_inventory_overview[0].price_alert_items ?? 0} item</div>
      <div class="branch-margin-label">Price alert 30H</div>
      <div class="branch-margin-structural">
        <span>Rata-rata variance <strong>{inv_inventory_overview[0].avg_price_variance_pct ?? 0}%</strong></span>
        <span>Baseline <strong>harga dasar</strong></span>
      </div>
      <div class="branch-stats-row">
        <div>Alert mulai: harga &gt;10% dari baseline.</div>
        <div>Prioritas: dampak rupiah terbesar.</div>
      </div>
      <div class="branch-diagnosis">Harga supplier tidak selalu terlihat dari stok, tapi langsung menekan margin bahan. Gunakan Supplier untuk bukti negosiasi.</div>
      <div class="branch-next-link">Next: Supplier</div>
    </div>

    <div class="branch-health-card {(inv_inventory_overview[0].purchase_usage_ratio_30d ?? 1) > 1.3 || (inv_inventory_overview[0].purchase_usage_ratio_30d ?? 1) < 0.8 ? 'waspada' : 'sehat'}">
      <div style="display:flex;justify-content:space-between;gap:10px;align-items:flex-start;">
        <div class="branch-card-name">Purchase Discipline</div>
        <span class="branch-status-badge {(inv_inventory_overview[0].purchase_usage_ratio_30d ?? 1) > 1.3 || (inv_inventory_overview[0].purchase_usage_ratio_30d ?? 1) < 0.8 ? 'waspada' : 'sehat'}">{(inv_inventory_overview[0].purchase_usage_ratio_30d ?? 1) > 1.3 ? 'Beli Cepat' : (inv_inventory_overview[0].purchase_usage_ratio_30d ?? 1) < 0.8 ? 'Beli Lambat' : 'Seimbang'}</span>
      </div>
      <div class="branch-margin-main {(inv_inventory_overview[0].purchase_usage_ratio_30d ?? 1) > 1.3 || (inv_inventory_overview[0].purchase_usage_ratio_30d ?? 1) < 0.8 ? 'waspada' : 'sehat'}">{inv_inventory_overview[0].purchase_usage_ratio_30d ?? 0}x</div>
      <div class="branch-margin-label">Rasio beli/pakai 30H</div>
      <div class="branch-margin-structural">
        <span>Normal <strong>0.8-1.3x</strong></span>
        <span>Ideal sekitar <strong>1.0x</strong></span>
      </div>
      <div class="branch-stats-row">
        <div>&gt;1.3x: pembelian lebih cepat dari pemakaian.</div>
        <div>&lt;0.8x: pemakaian lebih cepat dari pembelian.</div>
      </div>
      <div class="branch-diagnosis">
        {#if (inv_inventory_overview[0].purchase_usage_ratio_30d ?? 1) > 1.3}
          Pembelian lebih cepat dari pemakaian. Cek risiko overstock, minimum order supplier, atau jadwal PO yang terlalu rapat.
        {:else if (inv_inventory_overview[0].purchase_usage_ratio_30d ?? 1) < 0.8}
          Pemakaian lebih cepat dari pembelian. Ini belum otomatis stockout, tapi jika coverage aktual pendek maka risiko barang habis meningkat.
        {:else}
          Pembelian relatif sejalan dengan pemakaian. Tetap validasi di subpage Cabang untuk melihat outlet yang menyimpang.
        {/if}
      </div>
      <div class="branch-next-link">Next: Cabang</div>
    </div>
  </div>

  <details class="context-acc">
    <summary>🔍 Kenapa stok aktual dan periode movement dipisah?</summary>
    <div class="acc-body">
      <strong>Stok aktual</strong> menjawab posisi hari ini: barang mana yang hampir habis atau terlalu menumpuk. <strong>Movement 7H/30H</strong> menjawab penyebabnya: apakah pemakaian naik, pembelian terlalu cepat, pembelian terlalu lambat, atau harga supplier mulai mahal. Karena itu rasio beli/pakai tidak boleh sendirian menentukan sehat atau tidak; risiko habis tetap harus dikonfirmasi dengan <strong>days remaining</strong> dan low stock aktual.
    </div>
  </details>

  <div class="section-card">
    <div class="section-head">
      <div class="section-eyebrow">📊 Komposisi Stok <span class="timeframe-tag">Snapshot</span></div>
      <h3 class="section-title">Kategori mana yang paling banyak mengikat modal?</h3>
      <p class="section-copy">Gunakan bagian ini untuk membedakan bahan inti yang wajar bernilai besar dari kategori yang mulai menumpuk.</p>
    </div>
    <BarChart data={inv_stock_value_by_category} x="category" y="stock_value"
      title="Nilai Stok Aktual per Kategori" yFmt="#,##0" xAxisTitle="Kategori" yAxisTitle="Nilai Stok (Rp)" />
  </div>

</div>
{/if}
