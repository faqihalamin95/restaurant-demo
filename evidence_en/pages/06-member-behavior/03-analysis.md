---
title: Analysis
---
<MemberTabs activeTab="strategis" />

```sql member_kpi_period
SELECT * FROM restaurant.member_member_kpi_period
WHERE period = '30d'
```

```sql cohort_retention
WITH cohort_data AS (
  SELECT 
    DATE_TRUNC('month', join_date) AS cohort_month,
    DATE_TRUNC('month', order_date) AS order_month,
    COUNT(DISTINCT member_id) AS active_members
  FROM restaurant.member_purchase_behavior
  WHERE join_date IS NOT NULL
  GROUP BY 1, 2
),
cohort_sizes AS (
  SELECT cohort_month, active_members AS total_cohort_size
  FROM cohort_data
  WHERE cohort_month = order_month
)
SELECT 
  strftime(c.cohort_month, '%b %Y') AS "Cohort",
  'Month ' || datediff('month', c.cohort_month, c.order_month) AS "Bulan",
  datediff('month', c.cohort_month, c.order_month) AS sort_bulan,
  c.active_members,
  ROUND(LEAST(c.active_members * 1.0 / NULLIF(s.total_cohort_size, 0), 1.0), 3) AS "Retensi"
FROM cohort_data c
JOIN cohort_sizes s ON c.cohort_month = s.cohort_month
WHERE c.cohort_month >= (SELECT MAX(join_date) FROM restaurant.member_purchase_behavior) - INTERVAL '6 months'
AND datediff('month', c.cohort_month, c.order_month) > 0
ORDER BY c.cohort_month, sort_bulan
```

```sql freq_dist
WITH max_d AS (SELECT MAX(order_date) AS d FROM restaurant.member_purchase_behavior),
member_stats AS (
    SELECT 
        m.member_id,
        SUM(m.total_orders) AS orders_last_30d
    FROM restaurant.member_purchase_behavior m
    CROSS JOIN max_d
    WHERE m.order_date >= max_d.d - INTERVAL '30 days'
    GROUP BY 1
),
binned AS (
    SELECT 
        CASE 
            WHEN orders_last_30d = 1 THEN '1x'
            WHEN orders_last_30d = 2 THEN '2x'
            WHEN orders_last_30d BETWEEN 3 AND 5 THEN '3-5x'
            WHEN orders_last_30d BETWEEN 6 AND 10 THEN '6-10x'
            ELSE '> 10x'
        END AS visit_bucket,
        CASE 
            WHEN orders_last_30d = 1 THEN 1
            WHEN orders_last_30d = 2 THEN 2
            WHEN orders_last_30d BETWEEN 3 AND 5 THEN 3
            WHEN orders_last_30d BETWEEN 6 AND 10 THEN 4
            ELSE 5
        END AS sort_order,
        COUNT(member_id) AS member_count
    FROM member_stats
    GROUP BY 1, 2
)
SELECT visit_bucket, member_count
FROM binned
ORDER BY sort_order DESC
```



<script>
  // 1. Ambil Metrik Utama dari SQL
  let aovMember = 0;
  let aovNonMember = 0;
  let pctRevenue = 0;
  let pctTransaksi = 0;
  let frekuensi = 0;
  let akuisisi = 0;
  let activeMembers = 0;

  $: if (member_kpi_period && member_kpi_period.length > 0) {
     aovMember = member_kpi_period[0].avg_order_value || 0;
     aovNonMember = member_kpi_period[0].avg_order_value_non_member || 0;
     pctRevenue = member_kpi_period[0].pct_revenue_member || 0;
     pctTransaksi = member_kpi_period[0].pct_order_member || 0;
     activeMembers = member_kpi_period[0].active_members || 0;
     frekuensi = activeMembers > 0 
                  ? (member_kpi_period[0].total_member_orders / activeMembers) 
                  : 0;
     akuisisi = member_kpi_period[0].new_members || 0;
  }

  let boxColorClass = "blue";
  let executiveHeadline = "";
  let iconHeadline = "";
  let kalInti = "";
  let kalDampak = "";
  let kalAkuisisi = "";

  $: {
      // Benchmark Sederhana
      let isAovTurun = aovMember < aovNonMember;
      let isFrekuensiNaik = frekuensi >= 3.0; // Anggap 3x sebulan adalah batas habit sehat
      let acquisitionRate = activeMembers > 0 ? (akuisisi / activeMembers) * 100 : 0;
      let isAkuisisiMati = akuisisi === 0;

      // Evaluation Trade-off & Kondisi Inti
      if (isAovTurun && isFrekuensiNaik) {
          boxColorClass = "blue";
          iconHeadline = "🔍";
          executiveHeadline = "Observation: Transaction Habit Shift";
          let mcv = Math.round(aovMember * frekuensi);
          kalInti = `Members are indexing lower in per-visit spend vs. non-members (Rp${aovMember.toLocaleString('en-US')} vs Rp${aovNonMember.toLocaleString('en-US')}) but compensate with accelerated visit velocity (${frekuensi.toFixed(1)}x/month). In aggregate, this yields a Monthly Customer Value (MCV) of <strong>Rp${mcv.toLocaleString('en-US')}</strong> per active member, indicating strong daypart habituation.`;
      } 
      else if (!isAovTurun && isFrekuensiNaik) {
          boxColorClass = isAkuisisiMati ? "amber" : "green";
          iconHeadline = isAkuisisiMati ? "⚠️" : "✅";
          executiveHeadline = isAkuisisiMati ? "Isolation Warning: Stagnant Acquisition" : "Optimal Expansion Performance";
          kalInti = `Ideal operational performance achieved. High visit frequency (${frekuensi.toFixed(1)}x/month) is compounding with check averages that outpace non-members (Rp${aovMember.toLocaleString('en-US')} vs Rp${aovNonMember.toLocaleString('en-US')}). The loyalty cohort is operating at peak retention and margin contribution levels.`;
      } 
      else if (!isAovTurun && !isFrekuensiNaik) {
          boxColorClass = "amber";
          iconHeadline = "⚠️";
          executiveHeadline = "Warning: Potential Engagement Decline";
          kalInti = `Member purchasing power remains resilient (Rp${aovMember.toLocaleString('en-US')} vs Rp${aovNonMember.toLocaleString('en-US')}), but visit velocity is decelerating (${frekuensi.toFixed(1)}x/month). The cohort is skewing toward occasional transactions rather than habitual usage. Targeted behavioral stimuli are required to re-engage routine visits.`;
      } 
      else {
          boxColorClass = "red";
          iconHeadline = "🚨";
          executiveHeadline = "Critical: Margin & Retention Shrinkage";
          kalInti = `Member visit frequency is eroding (${frekuensi.toFixed(1)}x/month) while check averages trail non-member baselines (Rp${aovMember.toLocaleString('en-US')} vs Rp${aovNonMember.toLocaleString('en-US')}). High probability of imminent guest churn detected due to program fatigue or degraded perceived value.`;
      }

      // Evaluation Akuisisi Berbasis Persentase (Growth Rate)
      if (isAkuisisiMati) {
          kalAkuisisi = `<strong>Action Focus:</strong> Acquisition velocity has flatlined (0 new enrollments). Without top-of-funnel replenishment to offset natural churn decay, the loyalty program's aggregate revenue contribution faces structural decline.`;
      } else if (acquisitionRate <= 10) {
          kalAkuisisi = `Sluggish funnel growth (added ${akuisisi} enrollments, a ${acquisitionRate.toFixed(1)}% expansion rate). Immediate acquisition campaign optimization is mandated to ensure net-new guest velocity outpaces historical attrition rates.`;
      } else {
          kalAkuisisi = `Robust acquisition pipeline (added ${akuisisi} enrollments, a ${acquisitionRate.toFixed(1)}% expansion rate). This healthy top-of-funnel velocity secures a sustainable organic revenue baseline for future periods.`;
      }

      // Evaluation Dampak Berdasarkan Kontribusi Revenue
      if (pctRevenue > 30) {
          kalDampak = `Commanding a dominant ${pctRevenue.toFixed(1)}% share of total monthly revenue, the loyalty segment functions as a structural anchor for the restaurant's top-line financial stability.`;
      } else if (pctRevenue >= 15) {
          kalDampak = `Generating ${pctRevenue.toFixed(1)}% of total revenue, the loyalty segment serves as a healthy supplementary channel for sustained operational cash flow.`;
      } else {
          kalDampak = `Representing merely ${pctRevenue.toFixed(1)}% of aggregate revenue, this segment highlights under-penetrated market potential requiring aggressive programmatic overhaul.`;
      }
  }
</script>

<div class="member-page" style="margin-top: 24px;">
    
    <!-- HEADER BAB 1 -->
    <div class="diagnostics-header">
      <div class="diagnostics-eyebrow">🧠 MAIN DIAGNOSTICS</div>
      <h2 class="diagnostics-title">Macro Health Synthesis</h2>
      <p class="diagnostics-copy">A comprehensive evaluation of the structural health and unit economics of the loyalty program for the current operational period.</p>
    </div>

    {#if member_kpi_period && member_kpi_period.length > 0}
    <!-- Kesimpulan Eksekutif (Puncak Piramida) -->
    <div class="decision-box {boxColorClass}">
      <div class="decision-content">
        <div class="decision-title">
          <span style="display: flex; align-items: center; gap: 8px;">
            💡 Operational Insight & Recommendations
          </span>
          <div class="ai-badge">✨ AI Generated</div>
        </div>
        
        <p class="decision-text" style="color: var(--color-text-primary); margin-bottom: 12px;">
          <strong>{iconHeadline} {executiveHeadline}</strong>
        </p>
        
        <p class="decision-text" style="color: var(--color-text-primary); margin-bottom: 16px;">
          {@html kalInti}
        </p>
        
        <p class="decision-text" style="color: var(--color-text-primary); margin-top: 20px; margin-bottom: 16px;">
          {@html kalDampak}
        </p>

        <p class="decision-text" style="color: var(--color-text-primary); margin-top: 20px; margin-bottom: 20px;">
          {@html kalAkuisisi}
        </p>
        
        <div class="metrics-row" style="margin-top: 24px;">
            <div class="metric-pill">💰 AOV: Rp {aovMember.toLocaleString('en-US')}</div>
            <div class="metric-pill">💳 Rev: {pctRevenue.toFixed(1)}%</div>
            <div class="metric-pill">🌱 Acquisition: {akuisisi}</div>
            <div class="metric-pill">📦 Trx: {pctTransaksi.toFixed(1)}%</div>
            <div class="metric-pill">🔁 Freq: {frekuensi.toFixed(1)}x</div>
        </div>

        <div class="decision-footer" style="margin-top: 24px;">
          <em>*Disclaimer: This guide is calculated automatically based on the quantification of margins and frequency. Use it as a decision-support tool, combined with your contextual understanding of external dynamics not yet captured by data.</em>
        </div>
      </div>
    </div>

    <!-- HEADER BAB 2 & TRANSISI -->
    <div style="margin-top: 56px; border-top: 2px dotted rgba(128, 128, 128, 0.35); padding-top: 40px;">
      <div class="diagnostics-header" style="margin-bottom: 24px;">
        <div class="diagnostics-eyebrow">🔬 SUPPORTING ANALYSIS (DEEP-DIVE)</div>
<h2 class="diagnostics-title">Retention Cycle & Guest Fatigue</h2>
        <p class="diagnostics-copy">Deconstructing cohort endurance, isolating guest fatigue thresholds, and mapping true visit frequency distribution.</p>
      </div>
      
      <!-- Tempat untuk Analysis Pendukung dengan Tabs -->
      <Tabs id="deep-dive" fullWidth=true>
        <Tab label="📉 Heatmap (Cohort Retention)">
          <div style="margin-top: 24px;">
            <p style="color: var(--color-text-secondary); margin-bottom: 24px;">Analyzing cohort-level retention trajectories to project the statistical probability of guest return visits across subsequent operational periods post-acquisition.</p>
            <div style="padding: 24px; background: var(--color-background-primary); border-radius: 12px; border: 1px solid var(--color-border-tertiary); margin-bottom: 16px; box-shadow: 0 4px 12px rgba(0,0,0,0.02);">
                <Heatmap 
                  data={cohort_retention} 
                  x=Bulan
                  y=Cohort
                  value=Retensi
                  valueFmt="pct"
                  colorPalette={['#f8fafc', '#bae6fd', '#3b82f6', '#1d4ed8']}
                  title="Member Retention Rate per Cohort (%)"
                  echartsOptions={{
                    xAxis: {
                      axisLabel: {
                        formatter: function(val) { return val.replace('Month ', ''); }
                      }
                    }
                  }}
                />
            </div>
            <details class="guide-acc" style="margin-top: 16px; margin-bottom: 24px;">
              <summary>🎯 Operational Playbook & Strategic Utilization</summary>
              <div class="guide-body">
                <p style="margin-top: 4px; margin-bottom: 16px; font-weight: 500; color: var(--color-text-secondary);">
                  Core frameworks for interpreting cohort retention data to optimize lifecycle marketing spend and maximize guest lifetime value (LTV).
                </p>
                <div class="guide-grid" style="grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 12px;">
                  <div class="guide-card blue">
                    <div class="guide-card-icon">💡</div>
                    <div class="guide-card-content">
                      <div class="guide-card-label">Strategic Objective</div>
                      <h4 class="guide-card-title">Isolate Churn Velocity Thresholds</h4>
                      <p class="guide-card-desc">Identify the precise operational month where cohort retention experiences the sharpest drop-off. This metric defines the critical window for habituating guest behavior before permanent attrition occurs.</p>
                    </div>
                  </div>
                  <div class="guide-card orange">
                    <div class="guide-card-icon">🔎</div>
                    <div class="guide-card-content">
                      <div class="guide-card-label">Diagnostic Signal</div>
                      <h4 class="guide-card-title">Heatmap Density Degradation</h4>
                      <p class="guide-card-desc">A rapid deceleration in color density during "Month 2" or "Month 3" indicates systemic failure in post-acquisition onboarding, signaling that guests are churning before loyalty loops are solidified.</p>
                    </div>
                  </div>
                  <div class="guide-card teal">
                    <div class="guide-card-icon">🚀</div>
                    <div class="guide-card-content">
                      <div class="guide-card-label">Execution Strategy</div>
                      <h4 class="guide-card-title">Trigger-Based Win-Back Campaigns</h4>
                      <p class="guide-card-desc">Deploy automated, high-yield incentives exclusively to segments approaching their identified drop-off month. Eliminate blanket promotions that unnecessarily dilute aggregate profit margins.</p>
                    </div>
                  </div>
                </div>
              </div>
            </details>
          </div>
        </Tab>
        <Tab label="📊 Visit Distribution">
          <div style="margin-top: 24px;">
            <p style="color: var(--color-text-secondary); margin-bottom: 24px;">Evaluating visit frequency distribution to determine whether topline engagement is sustained by broad-based loyalty or artificially inflated by a minority segment of super-users.</p>
            <div style="padding: 24px; background: var(--color-background-primary); border-radius: 12px; border: 1px solid var(--color-border-tertiary); margin-bottom: 16px; box-shadow: 0 4px 12px rgba(0,0,0,0.02);">
                <BarChart 
                  data={freq_dist} 
                  x=visit_bucket 
                  y=member_count 
                  title="Member Visit Distribution (Last 30 Days)"
                  fillColor="#6366f1"
                  sort=false
                />
            </div>
            <details class="guide-acc" style="margin-top: 16px; margin-bottom: 24px;">
              <summary>🎯 Operational Playbook & Strategic Utilization</summary>
              <div class="guide-body">
                <p style="margin-top: 4px; margin-bottom: 16px; font-weight: 500; color: var(--color-text-secondary);">
                  Analytical framework for contextualizing frequency distribution against your specific F&B operating model and unit economics.
                </p>
                <div class="guide-grid" style="grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 12px;">
                  <div class="guide-card blue">
                    <div class="guide-card-icon">💡</div>
                    <div class="guide-card-content">
                      <div class="guide-card-label">Strategic Objective</div>
                      <h4 class="guide-card-title">Deconstruct Revenue Drivers</h4>
                      <p class="guide-card-desc">Determine if top-line revenue is fueled by <strong>transaction volume</strong> (habitual frequency) or <strong>check averages</strong> (occasional high-spend dining). This insight dictates structural marketing investments.</p>
                    </div>
                  </div>
                  <div class="guide-card orange">
                    <div class="guide-card-icon">🔎</div>
                    <div class="guide-card-content">
                      <div class="guide-card-label">Diagnostic Signal</div>
                      <h4 class="guide-card-title">Cross-Reference against Check Averages</h4>
                      <p class="guide-card-desc">If distribution heavily skews toward "1x–2x" visits, immediately benchmark member AOV against non-member averages. Parity between the two indicates a structurally deficient loyalty program failing to drive incremental value.</p>
                    </div>
                  </div>
                  <div class="guide-card teal">
                    <div class="guide-card-icon">🚀</div>
                    <div class="guide-card-content">
                      <div class="guide-card-label">Execution Strategy</div>
                      <h4 class="guide-card-title">Calibrate to Operating Concept</h4>
                      <p class="guide-card-desc"><em>QSR/Café concepts:</em> Prioritize frequency-driving mechanisms. <em>Fine Dining concepts:</em> Accept 1x-2x baselines provided AOV premiums remain intact. Optimize KPIs based on your specific service model.</p>
                    </div>
                  </div>
                </div>
              </div>
            </details>
          </div>
        </Tab>
      </Tabs>

      <!-- PANDUAN EKSEKUSI & BATASAN ETIKA (DUA KOLOM) -->
      <div style="margin-top: 56px; border-top: 2px dotted rgba(128, 128, 128, 0.35); padding-top: 40px;">
        <div class="diagnostics-header" style="margin-bottom: 24px;">
          <div class="diagnostics-eyebrow">🛡️ OPERATIONAL PLAYBOOK</div>
<h2 class="diagnostics-title">Deployment Protocol & Guest Experience Guardrails</h2>
          <p class="diagnostics-copy">Tactical frameworks for operationalizing data-driven insights while safeguarding hospitality standards and long-term brand equity.</p>
        </div>
      <div style="margin-top: 16px; display: grid; grid-template-columns: repeat(auto-fit, minmax(400px, 1fr)); gap: 24px;">
        
        <!-- Kolom Kiri: Panduan Taktis -->
        <div style="display: flex; flex-direction: column;">
          <h4 style="margin: 0 0 16px 0; font-weight: 800; display: flex; align-items: center; gap: 8px; color: var(--color-text-primary);">
            <span>📈</span> Metric Optimization Directives
          </h4>

          <div class="opt-action-stack">
            <div class="opt-action-card blue">
              <div class="opt-action-badge">💰 CHECK AVERAGE (AOV)</div>
              <div class="opt-action-title">Frictionless Menu Engineering</div>
              <div class="opt-action-desc">Deploy strategic <em>cross-selling</em> through curated bundle configurations (e.g., prix fixe pairing add-ons) to drive incremental spend without aggressive upselling pressure.</div>
            </div>
            <div class="opt-action-card orange">
              <div class="opt-action-badge">🔁 FREQUENCY & RETENTION</div>
              <div class="opt-action-title">Habituate Daypart Engagement</div>
              <div class="opt-action-desc">Engineer organic visit drivers targeting underperforming dayparts (e.g., localized <em>Coffee Morning</em> activations or exclusive weekend-only menu rollouts) to stimulate recurring foot traffic.</div>
            </div>
            <div class="opt-action-card teal">
              <div class="opt-action-badge">🤝 ONBOARDING & ACQUISITION</div>
              <div class="opt-action-title">High-Intent Point of Interaction</div>
              <div class="opt-action-desc">Train front-of-house (FOH) staff to introduce the loyalty program during moments of peak guest satisfaction (post-dining), eliminating high-friction solicitations at the POS terminal.</div>
            </div>
          </div>


        </div>

        <!-- Kolom Kanan: Guardrail Etika -->
        <div style="display: flex; flex-direction: column;">
          <h4 style="margin: 0 0 16px 0; font-weight: 800; display: flex; align-items: center; gap: 8px; color: var(--color-text-primary);">
            <span>🛡️</span> Hospitality Integrity Standards
          </h4>
          <div class="ethic-preview-1">
            <div class="ethic-content-1">
              <p>While maximizing transaction velocity is a fundamental prerequisite for unit-level profitability, operators must recognize the inherent limits of monetizing a static guest base.</p>
              <p class="ethic-quote-1">"Vigilantly monitor for indicators of <strong>customer fatigue</strong>. Aggressively mining the loyalty database via heavy-handed upselling or relentless promotional cadences invariably accelerates brand erosion. Sustainable retention is anchored in consistent service execution and emotional resonance, not merely treating guests as transactional commodities."</p>
            </div>
          </div>
        </div>

      </div>

    </div>
    </div>
    {:else}
      <GlobalLoading />
    {/if}
</div>

<style>
.member-page { display: flex; flex-direction: column; gap: 24px; margin-top: 10px; }

/* Decision Box Styles moved to app.css */

.diagnostics-stack { display: flex; flex-direction: column; gap: 16px; margin-top: 14px; }
.diagnostics-header { padding: 0 2px; margin-bottom: 24px; }
.diagnostics-eyebrow { font-size: 10px; font-weight: 700; letter-spacing: 0.12em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 6px; display: flex; align-items: center; gap: 6px; }
.diagnostics-title { font-size: 1.3rem; font-weight: 800; letter-spacing: -0.025em; color: var(--color-text-primary); margin: 0 0 4px; }
.diagnostics-copy { font-size: 0.9rem; line-height: 1.7; color: var(--color-text-secondary); max-width: 68ch; margin: 0; }

/* Override Evidence Tabs agar merentang penuh (50-50) jika isinya 2 */
/* ── PREVIEW OPSI 1: Action Queue ── */
.opt-action-stack { display: flex; flex-direction: column; gap: 12px; margin-left: 28px; }
.opt-action-card { padding: 16px 18px; border-radius: 12px; border-left: 4px solid; border-top: 1px solid; border-right: 1px solid; border-bottom: 1px solid; display: flex; flex-direction: column; gap: 4px; transition: transform 0.2s; }
.opt-action-card:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(0,0,0,0.05); }
.opt-action-card.blue { border-left-color: #3b82f6; border-color: rgba(59,130,246,0.2); background: rgba(59,130,246,0.04); }
.opt-action-card.orange { border-left-color: #f59e0b; border-color: rgba(245,158,11,0.2); background: rgba(245,158,11,0.04); }
.opt-action-card.teal { border-left-color: #10b981; border-color: rgba(16,185,129,0.2); background: rgba(16,185,129,0.04); }
.opt-action-badge { font-size: 10px; font-weight: 800; letter-spacing: 0.1em; text-transform: uppercase; padding: 2px 8px; border-radius: 999px; display: inline-block; width: max-content; margin-bottom: 4px; }
.opt-action-card.blue .opt-action-badge { background: rgba(59,130,246,0.15); color: #1d4ed8; }
.opt-action-card.orange .opt-action-badge { background: rgba(245,158,11,0.15); color: #b45309; }
.opt-action-card.teal .opt-action-badge { background: rgba(16,185,129,0.15); color: #047857; }
.opt-action-title { font-size: 0.95rem; font-weight: 800; color: var(--color-text-primary); }
.opt-action-desc { font-size: 0.88rem; line-height: 1.6; color: var(--color-text-secondary); margin-top: 2px; }

/* ── ETHIC PREVIEW 1: The Golden Rule ── */
.ethic-preview-1 { background: rgba(220, 38, 38, 0.04); border-radius: 12px; padding: 24px; border: 1px solid rgba(220, 38, 38, 0.15); position: relative; overflow: hidden; margin-left: 28px; }
.ethic-preview-1::before { content: '"'; position: absolute; top: -20px; left: -10px; font-size: 140px; font-family: serif; font-weight: 900; color: rgba(220, 38, 38, 0.08); line-height: 1; pointer-events: none; }
.ethic-content-1 { position: relative; z-index: 1; margin: 0; color: var(--color-text-secondary); line-height: 1.6; font-size: 0.95rem; display: flex; flex-direction: column; gap: 12px; }
.ethic-content-1 p { margin: 0; }
.ethic-quote-1 { font-style: italic; font-weight: 600; border-left: 3px solid rgba(220, 38, 38, 0.4); padding-left: 12px; color: var(--color-text-primary); }

</style>
