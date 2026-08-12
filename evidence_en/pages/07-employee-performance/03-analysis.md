---
title: Analysis
---
<EmployeeTabs activeTab="strategis" />

```sql emp_productivity
SELECT 
  employee_name,
  role,
  branch_name,
  hari_hadir,
  total_orders,
  total_revenue,
  avg_ticket,
  revenue_per_hour,
  orders_per_hour,
  productivity_label,
  CASE WHEN hari_hadir >= 26 THEN '⚠️ Capacity Exceeded' ELSE '✅ Optimal' END as burnout_risk
FROM restaurant.productivity_by_employee_period
WHERE period = '30d'
ORDER BY revenue_per_hour DESC
```

```sql shift_productivity
SELECT 
  shift_name,
  role,
  revenue_per_hour,
  orders_per_hour
FROM restaurant.productivity_by_shift_role
WHERE period = '30d'
ORDER BY revenue_per_hour DESC
```

```sql macro_health
SELECT 
  ROUND(AVG(revenue_per_hour), 0) as avg_rev_per_hour,
  ROUND(AVG(orders_per_hour), 1) as avg_orders_per_hour
FROM restaurant.productivity_by_shift_role
WHERE period = '30d'
```

```sql workforce_macro
SELECT 
  attendance_30d as kehadiran,
  late_30d as keterlambatan,
  overtime_pct_30d as lembur,
  rev_per_hour_30d as revenue_per_hour,
  problem_employees_30d as staf_berisiko,
  pressure_shift_30d as shift_rawan,
  pressure_branch_30d as location_rawan,
  focus_30d as fokus_intervensi
FROM restaurant.workforce_health_overview
```

<script>
  let topUpseller = null;
  let topSpeed = null;
  
  $: if (emp_productivity && emp_productivity.length > 0) {
    let sortedByAvgTicket = [...emp_productivity].sort((a, b) => b.avg_ticket - a.avg_ticket);
    topUpseller = sortedByAvgTicket[0];
    
    let sortedBySpeed = [...emp_productivity].sort((a, b) => b.orders_per_hour - a.orders_per_hour);
    topSpeed = sortedBySpeed[0];
  }

  let wm = {};
  let boxColorClass = "blue";
  let executiveHeadline = "";
  let iconHeadline = "";
  let kalInti = "";
  let kalDampak = "";

  $: if (workforce_macro && workforce_macro.length > 0) {
    wm = workforce_macro[0];
    let revText = `Rp ${usFormat(wm.revenue_per_hour)}`;
    let lemburText = `${usFormat(wm.lembur, 1)}%`;
    let indiText = `${usFormat(wm.keterlambatan, 1)}%`;

    if (wm.fokus_intervensi === 'Coverage risk') {
        boxColorClass = "red";
        iconHeadline = "🔍";
        executiveHeadline = "Observation: Staff Capacity Deficit";
        kalInti = `Current labor productivity maintains a revenue generation rate of <strong>${revText}/hour</strong> per employee. However, schedule variance (absences/lateness) has escalated to <strong>${indiText}</strong>.`;
        kalDampak = `To fulfill operational requirements, supplementary hours (overtime) surged to <strong>${lemburText}</strong>. This labor deficit is concentrated in <strong>${wm.location_rawan}</strong> during <strong>the ${wm.shift_rawan} shift</strong>, introducing severe productivity degradation risks.`;
    } 
    else if (wm.fokus_intervensi === 'Overtime pressure') {
        boxColorClass = "amber";
        iconHeadline = "⚠️";
        executiveHeadline = "Observation: Elevated Supplementary Hour Utilization";
        kalInti = `While labor productivity reaches <strong>${revText}/hour</strong> and schedule adherence remains solid (variance at <strong>${indiText}</strong>),`;
        kalDampak = `reliance on supplementary labor has spiked to <strong>${lemburText}</strong>. This indicates chronic understaffing relative to demand, particularly at <strong>${wm.location_rawan}</strong> (<strong>the ${wm.shift_rawan} shift</strong>).`;
    }
    else if (wm.fokus_intervensi === 'Keterlambatan') {
        boxColorClass = "amber";
        iconHeadline = "⚠️";
        executiveHeadline = "Observation: Schedule Adherence Degradation";
        kalInti = `Employee productivity averages <strong>${revText}/hour</strong>. However, adherence to scheduling is declining, with variance (lateness/absence) reaching <strong>${indiText}</strong>.`;
        kalDampak = `While supplementary labor utilization remains controlled (<strong>${lemburText}</strong>), these adherence deviations—most prominent at <strong>${wm.location_rawan}</strong> during <strong>the ${wm.shift_rawan} shift</strong>—pose a direct threat to target service velocity.`;
    }
    else {
        boxColorClass = "green";
        iconHeadline = "✅";
        executiveHeadline = "Observation: Optimal Labor Utilization";
        kalInti = `Labor allocation is optimized, yielding a productivity rate of <strong>${revText}/hour</strong> per employee.`;
        kalDampak = `Schedule adherence is excellent (variance at <strong>${indiText}</strong>) and supplementary labor remains within healthy thresholds (<strong>${lemburText}</strong>). Key operational areas, including <strong>${wm.location_rawan}</strong> during <strong>the ${wm.shift_rawan} shift</strong>, demonstrate high reliability.`;
    }
  }
  
  function usFormat(num, dec = 0) {
    if (num === null || num === undefined) return '0';
    return new Intl.NumberFormat('en-US', { minimumFractionDigits: dec, maximumFractionDigits: dec }).format(num);
  }
</script>

<div class="diagnostics-header" style="margin-top: 24px; margin-bottom: 24px;">
  <div class="diagnostics-eyebrow">🧠 MAIN DIAGNOSTIC</div>
<h2 class="diagnostics-title">Macro Efficiency & Productivity Synthesis</h2>
  <p class="diagnostics-copy">Comprehensive evaluation of operational capacity, labor profitability, and structural health of working hours this month.</p>
</div>

<!-- Narrative Box -->
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
        
        <div class="metrics-row" style="margin-top: 24px;">
            <div class="metric-pill">⚠️ Risk: {wm.shift_rawan}</div>
            <div class="metric-pill">🏢 Branch: {wm.location_rawan}</div>
            <div class="metric-pill">💰 Rev/Hour: Rp {usFormat(wm.revenue_per_hour)}</div>
            <div class="metric-pill">🕒 Overtime: {usFormat(wm.lembur, 1)}%</div>
            <div class="metric-pill">📉 Absent/Late: {usFormat(wm.keterlambatan, 1)}%</div>
        </div>

        <div class="decision-footer" style="margin-top: 24px;">
          <em>*Disclaimer: This analysis utilizes 30-day trailing averages of labor utilization, adherence, and productivity metrics. Validate findings against qualitative field observations.</em>
        </div>
  </div>
</div>


<!-- STRUCTURAL RISK SECTION -->
<div class="diagnostics-header" style="margin-top: 48px; margin-bottom: 24px;">
  <div class="diagnostics-eyebrow">⚠️ STRUCTURAL RISK</div>
<h2 class="diagnostics-title">Cost of Overtime & Schedule Variance</h2>
  <p class="diagnostics-copy">Evaluates how reliance on supplementary labor hours and schedule non-adherence erode profit margins and disrupt service level agreements (SLAs).</p>
</div>

<div class="risk-section">

  <div class="risk-row purple-theme">
    <div class="risk-row-header">
      <span class="risk-row-icon">🕒</span>
      <h4 class="risk-row-title">Financial & Operational Impact of Sustained Overtime</h4>
    </div>
    <div class="risk-pills">
      <div class="risk-pill">
        <span class="risk-pill-anchor">💸</span>
        <div class="risk-pill-content">
          <strong>Margin Erosion</strong>
          <span>Premium overtime wages significantly inflate prime costs and degrade net payroll margins.</span>
        </div>
      </div>
      <div class="risk-pill">
        <span class="risk-pill-anchor">🧠</span>
        <div class="risk-pill-content">
          <strong>Productivity Degradation</strong>
          <span>Labor fatigue correlates with elevated error rates, order inaccuracies, and reduced throughput.</span>
        </div>
      </div>
      <div class="risk-pill">
        <span class="risk-pill-anchor">🚪</span>
        <div class="risk-pill-content">
          <strong>Retention Risk</strong>
          <span>Sustained utilization strain directly impacts employee lifecycle and drives turnover.</span>
        </div>
      </div>
    </div>
    <div class="risk-funfact">
      <span class="risk-funfact-icon">📎</span>
      <div class="risk-funfact-content">
        <span>In Indonesia, overtime rate for the first hour = <strong>1.5x</strong> hourly wage, and subsequent hours = <strong>2x</strong> hourly wage.</span>
        <cite>PP 35/2021 — Government Regulation on Working Hours & Overtime</cite>
      </div>
    </div>
  </div>

  <div class="risk-row blue-theme">
    <div class="risk-row-header">
      <span class="risk-row-icon">📉</span>
      <h4 class="risk-row-title">Compounding Effect of Schedule Variance</h4>
    </div>
    <div class="risk-pills">
      <div class="risk-pill">
        <span class="risk-pill-anchor">⚡</span>
        <div class="risk-pill-content">
          <strong>Capacity Constraint</strong>
          <span>Isolated tardiness redistributes workload, stressing on-shift personnel.</span>
        </div>
      </div>
      <div class="risk-pill">
        <span class="risk-pill-anchor">🍳</span>
        <div class="risk-pill-content">
          <strong>Operational Bottleneck</strong>
          <span>Prep-work delays disrupt upstream processes, directly impacting fulfillment consistency.</span>
        </div>
      </div>
      <div class="risk-pill">
        <span class="risk-pill-anchor">⏱️</span>
        <div class="risk-pill-content">
          <strong>Service Velocity Degradation</strong>
          <span>Throughput metrics decline, increasing peak-hour abandonment and dissatisfaction.</span>
        </div>
      </div>
    </div>
    <div class="risk-funfact">
      <span class="risk-funfact-icon">📎</span>
      <div class="risk-funfact-content">
        <span>Working more than 12 hours/day increases the risk of workplace accidents by up to <strong>37%</strong>.</span>
        <cite>Dembe et al., Occupational & Environmental Medicine, 2005</cite>
      </div>
    </div>
  </div>

  <div class="risk-row slate-theme">
    <div class="risk-row-header">
      <span class="risk-row-icon">🔄</span>
      <h4 class="risk-row-title">Patterns to Watch Out For</h4>
    </div>
    <div class="risk-pills cols-2">
      <div class="risk-pill">
        <span class="risk-pill-anchor">🔁</span>
        <div class="risk-pill-content">
          <strong>Compounding Variance</strong>
          <span>Supplementary Labor → Degradation → Schedule Variance → Reliance on More Labor</span>
        </div>
      </div>
      <div class="risk-pill">
        <span class="risk-pill-anchor">💡</span>
        <div class="risk-pill-content">
          <strong>Intervention Required</strong>
          <span>Proactive capacity realignment prevents systemic degradation across operations.</span>
        </div>
      </div>
    </div>
    <div class="risk-funfact">
      <span class="risk-funfact-icon">📎</span>
      <div class="risk-funfact-content">
        <span>The restaurant & accommodation sector consistently records the <strong>highest turnover rate</strong> among all industries.</span>
        <cite>U.S. Bureau of Labor Statistics, JOLTS Report</cite>
      </div>
    </div>
  </div>

</div>

<style>
/* Decision Box Styles moved to app.css */

/* ── Risk Section (Mini-Card Layout) ── */
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
  width: 40px; height: 40px;
  display: flex; align-items: center; justify-content: center;
  border-radius: 12px;
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
</style>
