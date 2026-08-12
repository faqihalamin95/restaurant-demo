---
title: Analysis
---

<script>
  import DiagnosticsHeader from '$lib/DiagnosticsHeader.svelte';
  import SectionHeader from '$lib/SectionHeader.svelte';
  import SectionCard from '$lib/SectionCard.svelte';
  import PremiumTable from '$lib/PremiumTable.svelte';
  import GlobalLoading from '$lib/GlobalLoading.svelte';

  function usFormat(num, dec = 0) {
    if (num === null || num === undefined) return '0';
    return new Intl.NumberFormat('en-US', { minimumFractionDigits: dec, maximumFractionDigits: dec }).format(num);
  }

  let concentrationN = 1;
  let concentrationPct = 0;
  let concentrationNetPct = 0;

  let boxColorClass = "amber";
  let iconHeadline = "🔍";
  let executiveHeadline = "Observation: Profit Concentration &amp; Expense Distribution";
  let kalInti = "";

  let resCount = 0;
  let decCount = 0;

  $: if (typeof branch_summary_30d !== 'undefined' && branch_summary_30d.length > 0 && typeof branch_macro_strategic !== 'undefined' && branch_macro_strategic.length > 0 && typeof branch_health_overview !== 'undefined' && branch_health_overview.length > 0) {
      const sortedByRev = [...branch_summary_30d].sort((a, b) => b.total_revenue - a.total_revenue);
      const totalBranches = sortedByRev.length;
      
      // Dinamis: Top 1 untuk <=3 location, Top 2 untuk <=7, Top 3 untuk >7
      if (totalBranches <= 3) concentrationN = 1;
      else if (totalBranches <= 7) concentrationN = 2;
      else concentrationN = 3;

      let topNRev = 0;
      let totalRev = 0;
      let topNNet = 0;
      let totalNet = 0;
      
      for (let i = 0; i < totalBranches; i++) {
          totalRev += sortedByRev[i].total_revenue;
          totalNet += sortedByRev[i].net_revenue;
          if (i < concentrationN) {
              topNRev += sortedByRev[i].total_revenue;
              topNNet += sortedByRev[i].net_revenue;
          }
      }
      
      concentrationPct = totalRev > 0 ? (topNRev / totalRev) * 100 : 0;
      concentrationNetPct = totalNet > 0 ? (topNNet / totalNet) * 100 : (topNNet > 0 ? 100 : 0);

      // Algoritma 4 Skenario (Fair Share & Gap)
      const fairShare = (concentrationN / totalBranches) * 100;
      const revIndex = concentrationPct / fairShare;
      const gap = concentrationNetPct - concentrationPct;
      
      let zona = "Well Distributed";
      if (revIndex > 1.35) zona = "Highly Concentrated";
      else if (revIndex >= 1.15) zona = "Moderately Concentrated";

      resCount = branch_macro_strategic[0].resilient_count || 0;
      decCount = branch_health_overview[0].declining_30d || 0;
      let aov = usFormat(branch_macro_strategic[0].network_aov_30d);

      if (gap > 10) {
          // Skenario A: Parasite Network (Omzet Tersebar, Profit Terpusat)
          boxColorClass = "red";
          iconHeadline = "🚨";
          executiveHeadline = "Portfolio Alert: Severe Profit Cross-Subsidization";
          kalInti = `This month, <strong>${concentrationN} core location(s)</strong> generated <strong>${usFormat(concentrationPct, 1)}%</strong> of total network revenue. However, they disproportionately carry <strong>${usFormat(concentrationNetPct, 1)}% of total company Net Profit</strong>, with an average ticket size of Rp ${aov}. This sharp divergence highlights extreme cross-subsidization, where flagship locations are effectively subsidizing operational loss leaks in weaker branches across the network.`;
          
          if (concentrationNetPct > 100) {
              kalInti += `<br><br><span style="font-size: 0.85rem; color: var(--color-text-tertiary);"><em>*Note: A profit contribution exceeding 100% mathematically indicates that secondary locations within the portfolio are operating at a net loss.</em></span>`;
          }
      }
      else if (gap < -10) {
          // Scenario B: Inefficient Giants (High Volume, Compressed Margins)
          boxColorClass = "amber";
          iconHeadline = "⚠️";
          executiveHeadline = "Portfolio Observation: Volume Illusion & Margin Compression";
          kalInti = `Although <strong>${concentrationN} core location(s)</strong> dominate <strong>${usFormat(concentrationPct, 1)}%</strong> of total network revenue, their net profit contribution lags proportionally at <strong>${usFormat(concentrationNetPct, 1)}%</strong>. With average ticket size hovering at Rp ${aov}, this divergence indicates that high transaction volume in dominant branches is being heavily eroded by operational cost inefficiencies.`;
      } 
      else {
          // Balanced Scenarios (Gap within +/- 10%)
          if (zona === "Highly Concentrated") {
              // Scenario C: Fragile Empire (Single Point of Failure Risk)
              boxColorClass = "amber";
              iconHeadline = "⚠️";
              executiveHeadline = "Portfolio Risk: Revenue Concentration (Single Point of Failure)";
              kalInti = `Revenue and net profit scale in lockstep: <strong>${concentrationN} core location(s)</strong> generate <strong>${usFormat(concentrationPct, 1)}%</strong> of total revenue and <strong>${usFormat(concentrationNetPct, 1)}%</strong> of network net profit, with an average ticket size of Rp ${aov}. This absolute dependency creates severe concentration risk (CR${concentrationN}), leaving overall company cash flow vulnerable to operational disruptions in these few flagship units.`;
          } else {
              // Scenario D: Resilient Ecosystem (Balanced Distribution)
              boxColorClass = "blue";
              iconHeadline = "✅";
              executiveHeadline = "Portfolio Health: Resilient & Decentralized Network";
              kalInti = `Operational standardization across the network is performing optimally. The <strong>${usFormat(concentrationPct, 1)}%</strong> revenue share from <strong>${concentrationN} core location(s)</strong> aligns directly with a healthy <strong>${usFormat(concentrationNetPct, 1)}%</strong> net profit distribution (Average Ticket: Rp ${aov}). This balanced ratio confirms the absence of single-branch risk exposure, signaling a well-diversified and resilient store portfolio.`;
          }
      } 
  }
</script>

<style>
.warning-banner {
  background: linear-gradient(135deg, rgba(245, 158, 11, 0.12), rgba(251, 191, 36, 0.04));
  border: 1px solid rgba(245, 158, 11, 0.3);
  border-left: 4px solid #f59e0b;
  border-radius: 12px;
  padding: 16px 20px;
  margin-top: 16px;
  margin-bottom: 24px;
  display: flex;
  gap: 16px;
  align-items: flex-start;
  box-shadow: 0 4px 12px rgba(0,0,0,0.02);
  transition: all 0.22s ease;
}
.warning-banner-title { margin: 0 0 6px 0; color: #b45309; font-size: 0.95rem; font-weight: 700; }
.warning-banner-desc { margin: 0; color: var(--color-text-secondary); font-size: 0.85rem; line-height: 1.6; }

.diagnostics-stack { display: flex; flex-direction: column; gap: 24px; }
.diagnostics-header { margin-bottom: 8px; }
.diagnostics-eyebrow { font-size: 11px; font-weight: 700; letter-spacing: 0.1em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 8px; }
.diagnostics-title { margin: 0 0 8px 0; font-size: 1.5rem; letter-spacing: -0.02em; color: var(--color-text-primary); line-height: 1.2; }
.diagnostics-copy { margin: 0; font-size: 0.9rem; color: var(--color-text-secondary); line-height: 1.6; max-width: 80ch; }

.chart-insight-bar { margin-top: 14px; padding: 14px 16px; border-radius: 14px; border: 1px solid rgba(99,102,241,0.15); background: linear-gradient(135deg, rgba(99,102,241,0.05), rgba(139,92,246,0.03)); font-size: 0.88rem; line-height: 1.7; color: var(--color-text-secondary); }

.risk-section { display: flex; flex-direction: column; gap: 20px; margin-bottom: 32px; }

.risk-row {
  border-radius: 20px;
  overflow: hidden;
  box-shadow: 0 2px 12px rgba(0,0,0,0.03);
  transition: border-color 0.3s ease, box-shadow 0.3s ease;
}

/* Row color themes */
.risk-row.purple-theme { background: linear-gradient(135deg, rgba(168,85,247,0.03), rgba(168,85,247,0.008)); border: 1.5px solid rgba(168,85,247,0.12); }
.risk-row.blue-theme { background: linear-gradient(135deg, rgba(59,130,246,0.03), rgba(59,130,246,0.008)); border: 1.5px solid rgba(59,130,246,0.12); }
.risk-row.slate-theme { background: linear-gradient(135deg, rgba(15,23,42,0.03), rgba(15,23,42,0.008)); border: 1.5px solid rgba(15,23,42,0.08); }

/* Hover: outline only */
.risk-row.purple-theme:hover { border-color: rgba(168,85,247,0.35); box-shadow: 0 4px 20px rgba(168,85,247,0.06); }
.risk-row.blue-theme:hover { border-color: rgba(59,130,246,0.35); box-shadow: 0 4px 20px rgba(59,130,246,0.06); }
.risk-row.slate-theme:hover { border-color: rgba(15,23,42,0.20); box-shadow: 0 4px 20px rgba(15,23,42,0.04); }

.risk-row-header { display: flex; align-items: center; gap: 12px; padding: 18px 24px; }
.risk-row.purple-theme .risk-row-header { border-bottom: 1px solid rgba(168,85,247,0.08); }
.risk-row.blue-theme .risk-row-header { border-bottom: 1px solid rgba(59,130,246,0.08); }
.risk-row.slate-theme .risk-row-header { border-bottom: 1px solid rgba(15,23,42,0.06); }

.risk-row-icon { font-size: 1.15rem; width: 36px; height: 36px; display: flex; align-items: center; justify-content: center; border-radius: 11px; flex-shrink: 0; }
.risk-row.purple-theme .risk-row-icon { background: rgba(168,85,247,0.10); }
.risk-row.blue-theme .risk-row-icon { background: rgba(59,130,246,0.10); }
.risk-row.slate-theme .risk-row-icon { background: rgba(15,23,42,0.06); }

.risk-row-title { margin: 0; font-size: 1.02rem; font-weight: 800; color: var(--color-text-primary); letter-spacing: -0.02em; }

/* Pills: 3-column grid */
.risk-pills { display: grid; grid-template-columns: repeat(3, 1fr); }
.risk-pills.cols-2 { grid-template-columns: repeat(2, 1fr); }
.risk-pill {
  display: flex; flex-direction: column; align-items: center; text-align: center;
  gap: 10px; padding: 20px 16px;
  border-right: 1px solid rgba(0,0,0,0.04);
  transition: background 0.25s ease;
}
.risk-pill:last-child { border-right: none; }
.risk-row.purple-theme .risk-pill:hover { background: rgba(168,85,247,0.05); }
.risk-row.blue-theme .risk-pill:hover { background: rgba(59,130,246,0.05); }
.risk-row.slate-theme .risk-pill:hover { background: rgba(15,23,42,0.03); }

.risk-pill-anchor {
  font-size: 1.15rem;
  width: 44px; height: 44px; border-radius: 50%;
  display: flex; align-items: center; justify-content: center;
}
.risk-row.purple-theme .risk-pill-anchor { background: rgba(168,85,247,0.10); }
.risk-row.blue-theme .risk-pill-anchor { background: rgba(59,130,246,0.10); }
.risk-row.slate-theme .risk-pill-anchor { background: rgba(15,23,42,0.06); }

.risk-pill-content { display: flex; flex-direction: column; gap: 4px; }
.risk-pill-content strong { font-size: 0.85rem; font-weight: 800; color: var(--color-text-primary); letter-spacing: -0.01em; }
.risk-pill-content span { font-size: 0.8rem; line-height: 1.5; color: var(--color-text-secondary); }

/* Fun fact footer */
.risk-funfact {
  display: flex; align-items: flex-start; gap: 12px;
  padding: 14px 24px;
  border-top: 1px dashed rgba(0,0,0,0.06);
  background: rgba(0,0,0,0.015);
}
.risk-funfact-icon { font-size: 0.9rem; margin-top: 2px; flex-shrink: 0; }
.risk-funfact-content { display: flex; flex-direction: column; gap: 2px; }
.risk-funfact-content span { font-size: 0.78rem; line-height: 1.5; color: var(--color-text-secondary); }
.risk-funfact-content cite { font-size: 0.7rem; color: var(--color-text-tertiary); font-style: italic; }

/* Quadrant Legends */
.quadrant-grid {
  display: grid; 
  grid-template-columns: repeat(2, 1fr); 
  gap: 16px; 
  margin-bottom: 32px;
}
.quadrant-card {
  padding: 16px;
  border-radius: 12px;
  display: flex;
  flex-direction: column;
  gap: 6px;
  transition: transform 0.2s ease, box-shadow 0.2s ease;
  border-left: 4px solid;
}
.quadrant-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0,0,0,0.05);
}
.quadrant-title {
  font-weight: 700;
  font-size: 0.9rem;
  display: flex;
  align-items: center;
  gap: 8px;
}
.quadrant-desc {
  font-size: 0.8rem;
  color: var(--color-text-secondary);
  line-height: 1.5;
  margin: 0;
}
.quad-stars {
  background: linear-gradient(135deg, rgba(16,185,129,0.05), rgba(16,185,129,0.01));
  border-color: #10b981;
}
.quad-stars .quadrant-title { color: #047857; }

.quad-decaying {
  background: linear-gradient(135deg, rgba(245,158,11,0.05), rgba(245,158,11,0.01));
  border-color: #f59e0b;
}
.quad-decaying .quadrant-title { color: #b45309; }

.quad-leaking {
  background: linear-gradient(135deg, rgba(99,102,241,0.05), rgba(99,102,241,0.01));
  border-color: #6366f1;
}
.quad-leaking .quadrant-title { color: #4338ca; }

.quad-parasites {
  background: linear-gradient(135deg, rgba(239,68,68,0.05), rgba(239,68,68,0.01));
  border-color: #ef4444;
}
.quad-parasites .quadrant-title { color: #b91c1c; }
</style>

```sql branch_summary_30d
SELECT * FROM restaurant.branch_index_branch_summary_30d
```

```sql branch_macro_strategic
SELECT * FROM restaurant.branch_index_macro_strategic
```

```sql ytd_matrix_data
SELECT * FROM restaurant.ytd_matrix
```

```sql branch_health_overview
SELECT * FROM restaurant.branch_index_branch_health_overview
```

```sql branch_health_classification
SELECT * FROM restaurant.branch_index_branch_health_classification
ORDER BY health_status ASC, active_margin_pct DESC
```

```sql profitability_period_compare
SELECT * FROM restaurant.branch_analysis_profitability_period_compare
```

```sql subsidi_silang_data
WITH total AS (
  SELECT SUM(total_revenue) as sum_rev, SUM(net_revenue) as sum_net 
  FROM restaurant.branch_index_branch_summary_30d
)
SELECT 
  b.branch_name,
  b.total_revenue,
  b.net_revenue,
  ROUND(b.net_revenue / NULLIF(b.total_revenue, 0) * 100, 1) as net_margin_pct,
  ROUND(b.total_revenue / t.sum_rev * 100, 1) as rev_contribution_pct,
  ROUND(b.net_revenue / t.sum_net * 100, 1) as net_contribution_pct
FROM restaurant.branch_index_branch_summary_30d b
CROSS JOIN total t
ORDER BY b.total_revenue DESC
```

{#if typeof branch_summary_30d !== 'undefined' && typeof branch_macro_strategic !== 'undefined' && typeof ytd_matrix_data !== 'undefined' && typeof branch_health_overview !== 'undefined' && typeof branch_health_classification !== 'undefined' && typeof profitability_period_compare !== 'undefined' && typeof subsidi_silang_data !== 'undefined'}

<div class="branch-analysis-body">

_Multi-location portfolio breakdown: evaluate margin health, revenue growth, unit profitability, and strategic action priorities across branches._

<details class="guide-acc"  style="margin-top:12px; margin-bottom:12px;">
  <summary>💡 How to choose a subpage</summary>
    <div class="guide-body">
      <p style="margin-top: 4px; margin-bottom: 16px; font-weight: 500; color: var(--color-text-secondary);">
        Seamlessly navigate location performance, from high-level financial health down to granular outlet audits.
      </p>
      <div class="guide-grid" style="grid-template-columns: repeat(3, minmax(0, 1fr));">
        <div class="guide-card blue">
          <div class="guide-card-icon">🏠</div>
          <div class="guide-card-content">
            <div class="guide-card-label">Overview</div>
            <h4 class="guide-card-title">Core Metrics &amp; Variance</h4>
            <p class="guide-card-desc">Quickly monitor order volume, AOV, and performance variance across all outlets.</p>
          </div>
        </div>
        <div class="guide-card orange">
          <div class="guide-card-icon">🏪</div>
          <div class="guide-card-content">
            <div class="guide-card-label">Deep Dive</div>
            <h4 class="guide-card-title">Branch Audit</h4>
            <p class="guide-card-desc">Granular outlet analysis: daily margins, COGS breakdown, expenditure trends, and supporting data.</p>
          </div>
        </div>
        <div class="guide-card teal">
          <div class="guide-card-icon">🔭</div>
          <div class="guide-card-content">
            <div class="guide-card-label">Analysis</div>
            <h4 class="guide-card-title">Portfolio Strategy</h4>
            <p class="guide-card-desc">Evaluate long-term growth trajectories, unit profitability, and location-level strategic alignment.</p>
          </div>
        </div>
      </div>
      <div style="font-size: 0.75rem; color: var(--color-text-secondary); margin-top: 12px;">
        *For aggregate multi-unit financial health, visit the <a class="inline-link" href="/01-financial-report">Financial Report</a> page.
      </div>
    </div>
</details>

<div class="evidence-tabs-container">
  <a href="/02-branch-performance" class="tab-button">🏠 Overview</a>
  <a href="/02-branch-performance/02-deepdive" class="tab-button">🏪 Deep Dive</a>
  <a href="/02-branch-performance/03-analysis" class="tab-button active">🔭 Analysis</a>
  <a href="/02-branch-performance/04-data-directory" class="tab-button">📁 Data Directory</a>
</div>

  <!-- Panel 1: Kesimpulan (Makro) -->
  <div class="decision-box {boxColorClass}" style="margin-top: 32px; margin-bottom: 48px;">
    <div class="decision-content">
      <div class="decision-title">
        <span style="display: flex; align-items: center; gap: 8px;">
          💡 Operational Insights &amp; Recommendations
        </span>
        <div class="ai-badge">✨ AI Generated</div>
      </div>
      
          <p class="decision-text" style="color: var(--color-text-primary); margin-bottom: 12px;">
            <strong>{iconHeadline} {executiveHeadline}</strong>
          </p>
          
          <p class="decision-text" style="color: var(--color-text-primary); margin-bottom: 16px;">
            {@html kalInti}
          </p>
          
          <div class="metrics-row" style="margin-top: 24px;">
            <div class="metric-pill">⚖️ Dominant Core: Top {concentrationN} Location(s)</div>
            <div class="metric-pill">📊 Revenue Share: {usFormat(concentrationPct, 1)}%</div>
            <div class="metric-pill">💰 Net Profit Share: {usFormat(concentrationNetPct, 1)}%</div>
            <div class="metric-pill">📉 Declining Trajectory: {usFormat(decCount)} Location(s)</div>
          </div>

          <div class="decision-footer" style="margin-top: 24px;">
            <em>*Disclaimer: This analysis is automatically computed based on portfolio revenue distribution and net profitability ratios across locations over the past 30 days. Use as a strategic directional guide, and cross-reference with long-term expansion objectives.</em>
          </div>
    </div>
  </div>

  <!-- RISIKO STRUKTURAL SECTION -->
  <div class="diagnostics-header" style="margin-top: 48px; margin-bottom: 24px;">
    <div class="diagnostics-eyebrow">⚠️ LOCATION PORTFOLIO DYNAMICS</div>
    <h2 class="diagnostics-title">Portfolio Concentration &amp; Network Subsidization</h2>
    <p class="diagnostics-copy">Evaluate how heavy reliance on flagship branches or unmonitored expansion can create profit leakage and erode network-wide cash flow stability.</p>
  </div>

  <div class="risk-section">

    <div class="risk-row purple-theme">
      <div class="risk-row-header">
        <span class="risk-row-icon">⚖️</span>
        <h4 class="risk-row-title">Portfolio Concentration Risk Exposure</h4>
      </div>
      <div class="risk-pills">
        <div class="risk-pill">
          <span class="risk-pill-anchor">🏢</span>
          <div class="risk-pill-content">
            <strong>Single Point of Failure</strong>
            <span>Over-reliance on 1–2 flagship locations leaves cash flow highly vulnerable to localized operational disruptions.</span>
          </div>
        </div>
        <div class="risk-pill">
          <span class="risk-pill-anchor">🎭</span>
          <div class="risk-pill-content">
            <strong>Illusion of Aggregate Growth</strong>
            <span>Top-line group revenue growth can easily mask underlying margin erosion and stagnation in secondary branches.</span>
          </div>
        </div>
        <div class="risk-pill">
          <span class="risk-pill-anchor">🎯</span>
          <div class="risk-pill-content">
            <strong>Lease Dependency & Rent Squeeze</strong>
            <span>Loss of bargaining power during lease renewals with prime landlords, as network cash flow cannot sustain losing key sites.</span>
          </div>
        </div>
      </div>
      <div class="risk-funfact">
        <span class="risk-funfact-icon">📎</span>
        <div class="risk-funfact-content">
          <span>Relying on fewer than 3 locations for over <strong>60%</strong> of total network revenue doubles systemic solvency risks during localized market shocks.</span>
          <cite>Industry Benchmark • Portfolio Risk Analysis</cite>
        </div>
      </div>
    </div>

    <div class="risk-row blue-theme">
      <div class="risk-row-header">
        <span class="risk-row-icon">🕸️</span>
        <h4 class="risk-row-title">Unchecked Expansion &amp; Cross-Subsidy Traps</h4>
      </div>
      <div class="risk-pills">
        <div class="risk-pill">
          <span class="risk-pill-anchor">🩸</span>
          <div class="risk-pill-content">
            <strong>Profit Siphoning &amp; Subsidies</strong>
            <span>Net margins generated by flagship locations are continuously absorbed to patch cash flow leaks in underperforming branches.</span>
          </div>
        </div>
        <div class="risk-pill">
          <span class="risk-pill-anchor">🦈</span>
          <div class="risk-pill-content">
            <strong>Trade Area Cannibalization</strong>
            <span>Opening new units within overlapping trade radii dilutes existing store traffic, effectively doubling occupancy overhead for the same customer base.</span>
          </div>
        </div>
        <div class="risk-pill">
          <span class="risk-pill-anchor">🐘</span>
          <div class="risk-pill-content">
            <strong>High-Volume Margin Compression</strong>
            <span>Large flagship outlets generate impressive top-line revenue, but their net profit margins often lag behind leaner, compact formats.</span>
          </div>
        </div>
      </div>
      <div class="risk-funfact">
        <span class="risk-funfact-icon">📎</span>
        <div class="risk-funfact-content">
          <span>Opening satellite branches within overlapping trade radii can erode overall group operational margins by <strong>15%–25%</strong> in the first year.</span>
          <cite>Industry Benchmark • Retail Network Expansion Dynamics</cite>
        </div>
      </div>
    </div>
  </div>

  <!-- Panel 2: Analysis Performance Lintas Location -->
<SectionHeader 
  eyebrow="📊 PORTFOLIO HEALTH & PERFORMANCE MATRIX"
  title="Branch Cross-Subsidies, Health Quadrants & YTD Performance"
  description="Examines profit contribution density across branches, categorizes location health quadrants, and benchmarks year-to-date structural trajectories."
/>

<div class="data-wrapper">
  <Tabs id="analisis_makro_tabs" fullWidth=true>

    <Tab label="⚖️ Cross-Subsidy Audit">
      <div style="margin-top: 24px; margin-bottom: 24px;">
        <BarChart 
          data={subsidi_silang_data} 
          x="branch_name" 
          y="net_revenue" 
          swapXY={true}
          title="Net Profit Breakdown by Location (IDR)" 
          xAxisTitle="Net Profit Value (IDR)" 
        />
      </div>

      <div>
        <h4 style="margin-bottom: 12px; font-weight: 700; font-size: 1rem;">
          Cross-Subsidy Audit: Revenue Share vs. Net Profit Contribution
        </h4>
        <PremiumTable 
          data={subsidi_silang_data} 
          pageSize={10} 
          columns={[
            { title: "Location", key: "branch_name", align: "left", bold: true },
            { title: "Revenue (30D)", key: "total_revenue", align: "right", type: "currency" },
            { title: "Revenue Share", key: "rev_contribution_pct", align: "right", type: "pct" },
            { title: "Net Profit (30D)", key: "net_revenue", align: "right", type: "currency" },
            { title: "Profit Share", key: "net_contribution_pct", align: "right", type: "pct", colorRules: "growth" },
            { title: "Net Margin", key: "net_margin_pct", align: "right", type: "pct", showPlus: true, colorRules: "growth" }
          ]} 
        />
      </div>
    </Tab>
    
    <Tab label="📍 Performance Quadrant Matrix">
      <div style="margin-top: 24px; margin-bottom: 24px;">
        <ScatterPlot 
          data={ytd_matrix_data} 
          x="active_margin_pct" 
          y="baseline_change_pct" 
          xFmt="num1"
          yFmt="num1"
          series="branch_name" 
          xAxisTitle="Net Margin YTD (%)" 
          yAxisTitle="Order Volume Growth (YTD YoY %)"
          title="Long-Term Performance Quadrant: Margin vs. Order Growth"
        />
      </div>

      <!-- Quadrant Legend -->
      <div class="quadrant-grid">
        <div class="quadrant-card quad-stars">
          <div class="quadrant-title">↗️ Top-Right: The Stars</div>
          <p class="quadrant-desc">
            <strong>High Margin + Traffic Expansion:</strong><br/>
            Flagship locations driving sustainable net profitability and growing local market share.
          </p>
        </div>
        <div class="quadrant-card quad-decaying">
          <div class="quadrant-title">↘️ Bottom-Right: Decaying Giants</div>
          <p class="quadrant-desc">
            <strong>High Margin + Traffic Contraction:</strong><br/>
            Profitable locations maintaining healthy unit economics but experiencing gradual volume erosion.
          </p>
        </div>
        <div class="quadrant-card quad-leaking">
          <div class="quadrant-title">↖️ Top-Left: Leaking Bucket</div>
          <p class="quadrant-desc">
            <strong>Thin/Negative Margin + Traffic Expansion:</strong><br/>
            High-volume locations severely eroded by prime cost leaks or operational cost overruns.
          </p>
        </div>
        <div class="quadrant-card quad-parasites">
          <div class="quadrant-title">↙️ Bottom-Left: The Parasites</div>
          <p class="quadrant-desc">
            <strong>Negative Margin + Traffic Contraction:</strong><br/>
            Deficit locations operating at an active loss, sustained entirely by cross-subsidies.
          </p>
        </div>
      </div>

      <div>
        <h4 style="margin-bottom: 12px; font-weight: 700; font-size: 1rem; color: var(--color-text-primary);">
          YTD Structural Performance Benchmarks (YoY Baseline)
        </h4>
        <PremiumTable 
          data={ytd_matrix_data} 
          pageSize={10} 
          columns={[
            { title: "Location", key: "branch_name", align: "left", bold: true },
            { title: "Health Status", key: "health_status", align: "center", colorRules: "health" },
            { title: "Net Margin (YTD)", key: "active_margin_pct", prevKey: "prev_margin_pct", align: "right", type: "margin_growth" },
            { title: "Order Volume (YTD)", key: "active_orders", prevKey: "prev_orders", align: "right", type: "number_growth" }
          ]} 
        />
        <div style="margin-top: 12px; font-size: 0.8rem; color: var(--color-text-secondary); background: rgba(0,0,0,0.02); padding: 8px 12px; border-radius: 6px; display: inline-block;">
          📌 <strong>Note:</strong> Net Margin and Order Volume metrics reflect Year-To-Date (YTD) performance. Growth variances (▲/▼) benchmark current year-to-date metrics against the matching calendar period from the previous year (YTD YoY), eliminating seasonal bias.
        </div>
      </div>
    </Tab>

  </Tabs>
</div>

</div>

{:else}
  <GlobalLoading />
{/if}
