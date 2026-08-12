---
title: Tactical Action
---
<EmployeeTabs activeTab="taktis" />

```sql workforce_overview
SELECT * FROM restaurant.workforce_health_overview
```

```sql burnout_risk
SELECT 
  employee_name,
  role,
  branch_name,
  total_overtime_hours,
  jam_lembur_html,
  overtime_days,
  avg_hours_per_overtime_session,
  recommended_action
FROM restaurant.top_overtime_employees_period
WHERE period = '30d'
ORDER BY total_overtime_hours DESC
```

```sql burnout_distribution
SELECT 
    CASE 
        WHEN total_overtime_hours >= 20 THEN '> 20 Hours'
        WHEN total_overtime_hours >= 10 THEN '10 - 20 Hours'
        ELSE '< 10 Hours'
    END as rentang_lembur,
    COUNT(*) as jumlah_pegawai
FROM restaurant.top_overtime_employees_period
WHERE period = '30d'
GROUP BY 1
ORDER BY 
    CASE rentang_lembur 
        WHEN '< 10 Hours' THEN 1
        WHEN '10 - 20 Hours' THEN 2
        ELSE 3
    END
```

```sql burnout_branch
SELECT branch_name, SUM(total_overtime_hours) as total_lembur
FROM restaurant.top_overtime_employees_period
WHERE period = '30d'
GROUP BY 1
ORDER BY total_lembur ASC
```

```sql attendance_problem
SELECT 
  nama_staf_html,
  employee_name,
  role,
  branch_name,
  total_absent,
  total_late,
  risk_label,
  recommended_action
FROM restaurant.attendance_problem_period
WHERE period = '30d'
ORDER BY 
  CASE risk_label 
    WHEN 'Critical' THEN 1 
    WHEN 'Tinggi' THEN 2
    WHEN 'Sedang' THEN 3
    ELSE 4 
  END, total_absent DESC, total_late DESC
```

```sql attendance_distribution
SELECT risk_label, COUNT(*) as jumlah_pegawai
FROM restaurant.attendance_problem_period
WHERE period = '30d'
GROUP BY 1
ORDER BY CASE risk_label WHEN 'Critical' THEN 1 WHEN 'Tinggi' THEN 2 ELSE 3 END
```

```sql attendance_branch
SELECT branch_name, COUNT(employee_name) as jumlah_pegawai
FROM restaurant.attendance_problem_period
WHERE period = '30d'
GROUP BY 1
ORDER BY jumlah_pegawai ASC
```

<script>
  function usFormat(num, dec = 0) {
    if (num === null || num === undefined) return '0';
    return new Intl.NumberFormat('en-US', { minimumFractionDigits: dec, maximumFractionDigits: dec }).format(num);
  }

  let topBurnout = null;
  let totalBurnoutAlerts = 0;
  let targetBurnoutCount = 0;
  let criticalBurnoutCount = 0;
  let burnout_risk_formatted = [];
  
  $: if (burnout_risk && burnout_risk.length > 0) {
    topBurnout = burnout_risk[0];
    totalBurnoutAlerts = burnout_risk.length;
    targetBurnoutCount = burnout_risk.filter(d => d.total_overtime_hours >= 10).length;
    criticalBurnoutCount = burnout_risk.filter(d => d.total_overtime_hours >= 20).length;
  }

  let topAttendance = null;
  let totalAttendanceAlerts = 0;
  let targetDisiplinCount = 0;
  let criticalDisiplinCount = 0;
  let totalInsiden = 0;
  
  $: if (attendance_problem && attendance_problem.length > 0) {
    topAttendance = attendance_problem[0];
    totalAttendanceAlerts = attendance_problem.length;
    targetDisiplinCount = attendance_problem.filter(d => d.risk_label === 'Critical' || d.risk_label === 'Tinggi').length;
    criticalDisiplinCount = attendance_problem.filter(d => d.risk_label === 'Critical').length;
    totalInsiden = attendance_problem.reduce((sum, d) => sum + d.total_absent + d.total_late, 0);
  }

  let overtimeState = 'safe';
  let overtimeColor = 'green';
  let lateState = 'safe';
  let lateColor = 'green';
  let overtimePct = 0;
  let latePct = 0;

  $: if (workforce_overview && workforce_overview.length > 0) {
    let ovt = workforce_overview[0].overtime_pct_30d;
    let late = workforce_overview[0].late_30d;
    overtimePct = ovt;
    latePct = late;

    if (ovt < 35) { overtimeState = 'safe'; overtimeColor = 'green'; }
    else if (ovt <= 50) { overtimeState = 'warn'; overtimeColor = 'amber'; }
    else { overtimeState = 'critical'; overtimeColor = 'red'; }

    if (late < 10) { lateState = 'safe'; lateColor = 'green'; }
    else if (late <= 20) { lateState = 'warn'; lateColor = 'amber'; }
    else { lateState = 'critical'; lateColor = 'red'; }
  }

  let chartOptionBurnout = {};
  $: if (burnout_distribution && burnout_distribution.length > 0) {
      chartOptionBurnout = {
         tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
         grid: { left: '5%', right: '5%', bottom: '5%', top: '15%', containLabel: true },
         xAxis: { type: 'category', data: burnout_distribution.map(d => d.rentang_lembur), axisLine: { show: false }, axisTick: { show: false }, axisLabel: { fontWeight: 'bold', color: '#64748b' } },
         yAxis: { type: 'value', splitLine: { show: false }, axisLabel: { show: false } },
         series: [{
               name: 'Staff', type: 'bar', barWidth: '45%', showBackground: true, backgroundStyle: { color: 'rgba(239, 68, 68, 0.05)', borderRadius: [8, 8, 0, 0] },
               data: burnout_distribution.map((d, i) => ({ value: d.jumlah_pegawai, itemStyle: { color: i===2 ? '#ef4444' : i===1 ? '#f97316' : '#f59e0b', borderRadius: [8, 8, 0, 0] } })),
               label: { show: true, position: 'top', fontWeight: 'bold', color: '#334155' }
         }]
      };
  }

  let chartOptionBurnoutBranch = {};
  $: if (burnout_branch && burnout_branch.length > 0) {
      chartOptionBurnoutBranch = {
         tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
         grid: { left: '2%', right: '15%', bottom: '2%', top: '2%', containLabel: true },
         xAxis: { type: 'value', splitLine: { show: false }, axisLabel: { show: false } },
         yAxis: { type: 'category', data: burnout_branch.map(d => d.branch_name), axisLine: { show: false }, axisTick: { show: false }, axisLabel: { fontWeight: 'bold', color: '#64748b' }, inverse: true },
         series: [{
               name: 'Overtime Hours', type: 'bar', showBackground: true, backgroundStyle: { color: 'rgba(239, 68, 68, 0.05)', borderRadius: [0, 8, 8, 0] },
               data: burnout_branch.map((d) => ({ value: d.total_lembur, itemStyle: { color: '#ef4444', borderRadius: [0, 8, 8, 0] } })),
               label: { show: true, position: 'right', fontWeight: 'bold', color: '#334155' }
         }]
      };
  }

  let chartOptionAttendance = {};
  $: if (attendance_distribution && attendance_distribution.length > 0) {
      chartOptionAttendance = {
         tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
         grid: { left: '5%', right: '5%', bottom: '5%', top: '15%', containLabel: true },
         xAxis: { type: 'category', data: attendance_distribution.map(d => d.risk_label), axisLine: { show: false }, axisTick: { show: false }, axisLabel: { fontWeight: 'bold', color: '#64748b' } },
         yAxis: { type: 'value', splitLine: { show: false }, axisLabel: { show: false } },
         series: [{
               name: 'Staff', type: 'bar', barWidth: '45%', showBackground: true, backgroundStyle: { color: 'rgba(245, 158, 11, 0.05)', borderRadius: [8, 8, 0, 0] },
               data: attendance_distribution.map((d) => ({ value: d.jumlah_pegawai, itemStyle: { color: d.risk_label === 'Critical' ? '#ef4444' : '#f59e0b', borderRadius: [8, 8, 0, 0] } })),
               label: { show: true, position: 'top', fontWeight: 'bold', color: '#334155' }
         }]
      };
  }

  let chartOptionAttendanceBranch = {};
  $: if (attendance_branch && attendance_branch.length > 0) {
      chartOptionAttendanceBranch = {
         tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
         grid: { left: '2%', right: '15%', bottom: '2%', top: '2%', containLabel: true },
         xAxis: { type: 'value', splitLine: { show: false }, axisLabel: { show: false } },
         yAxis: { type: 'category', data: attendance_branch.map(d => d.branch_name), axisLine: { show: false }, axisTick: { show: false }, axisLabel: { fontWeight: 'bold', color: '#64748b' }, inverse: true },
         series: [{
               name: 'Problematic Staff', type: 'bar', showBackground: true, backgroundStyle: { color: 'rgba(245, 158, 11, 0.05)', borderRadius: [0, 8, 8, 0] },
               data: attendance_branch.map((d) => ({ value: d.jumlah_pegawai, itemStyle: { color: '#f59e0b', borderRadius: [0, 8, 8, 0] } })),
               label: { show: true, position: 'right', fontWeight: 'bold', color: '#334155' }
         }]
      };
  }

  let isLoaded = false;
  let hashHandled = false;

  $: if (workforce_overview && workforce_overview.length > 0 && burnout_risk && attendance_problem) {
    isLoaded = true;
  }

  import { tick } from 'svelte';

  $: if (isLoaded && !hashHandled && typeof window !== 'undefined') {
    hashHandled = true;
    tick().then(() => {
      const hash = window.location.hash;
      if (hash === '#disiplin' || hash === '#burnout') {
        const accId = hash === '#disiplin' ? 'acc-disiplin' : 'acc-burnout';
        const details = document.getElementById(accId);
        if (details) {
          details.open = true;
          setTimeout(() => {
            const target = document.getElementById(hash.slice(1));
            if (target) target.scrollIntoView({ behavior: 'smooth', block: 'start' });
          }, 200);
        }
      }
    });
  }
</script>

{#if isLoaded}

<!-- Outer Diagnostics Container 2 -->
<div id="disiplin" class="diagnostics-stack" style="margin-top: 32px; margin-bottom: 24px;">
  <div class="diagnostics-header">
    <div class="diagnostics-eyebrow">⚠️ Labor Compliance Review</div>
<h2 class="diagnostics-title">Schedule Adherence & Attendance Variance</h2>
    <p class="diagnostics-copy">Identifies personnel with recurring attendance deviations (absences and lateness). Enables proactive scheduling adjustments and compliance reviews to maintain target service velocity.</p>
  </div>
  
  <details id="acc-disiplin" class="acc-strategic">
    <summary>📊 Dive into Schedule Adherence Data</summary>

    <div class="acc-body">
      <div style="display: flex; flex-direction: column; gap: 24px;">
        
        <!-- 1. Kesimpulan (Insight) -->
        <div>
          <div class="section-head tight" style="margin-bottom: 12px;">
            <div>
              <div class="section-eyebrow">⚠️ Compliance Variance</div>
              <h3 class="section-title">Attendance Adherence Rate & Review Priority</h3>
              <p class="section-copy">Presents the aggregate attendance variance rate and flags personnel requiring immediate compliance review.</p>
            </div>
          </div>

          <div class="insight-grid">
            <div class="insight-card {lateState === 'safe' ? 'safe' : lateState === 'warn' ? 'warn' : 'kritis'}">
              <div class="insight-header">
                <span class="insight-icon">{lateState === 'safe' ? '🛡️' : lateState === 'warn' ? '⚠️' : '🚨'}</span>
                <span class="insight-title">Adherence Rate Deviation</span>
              </div>
              <div class="insight-body">
                <div class="insight-number">{usFormat(latePct, 1)}<span class="insight-percent">%</span></div>
                <div class="insight-status-badge {lateState === 'safe' ? 'safe' : lateState === 'warn' ? 'warn' : 'kritis'}">{lateState === 'safe' ? 'TARGET' : lateState === 'warn' ? 'WARNING' : 'CRITICAL'}</div>
              </div>
              <div class="insight-footer">
                {#if lateState === 'safe'}
                  Shift formations operate within optimal compliance parameters. Minimal attendance variance recorded.
                {:else if lateState === 'warn'}
                  Moderate schedule disruption observed, primarily driven by <strong>{totalInsiden} incidents</strong> of lateness or absence this period.
                {:else}
                  Significant schedule instability detected, accumulating <strong>{totalInsiden} incidents</strong> of lateness and absence.
                {/if}
              </div>
            </div>

            <div class="insight-card target-card {criticalDisiplinCount > 0 ? 'kritis' : targetDisiplinCount > 0 ? 'warn' : 'neutral'}">
              <div class="insight-header">
                <span class="insight-icon">🎯</span>
                <span class="insight-title">Target Compliance Review</span>
              </div>
              <div class="insight-body">
                <div class="insight-number">{targetDisiplinCount}<span class="insight-percent">&nbsp;Staff</span></div>
                <div class="insight-status-badge {criticalDisiplinCount > 0 ? 'kritis' : targetDisiplinCount > 0 ? 'warn' : 'neutral'}">REVIEW REQUIRED</div>
              </div>
              <div class="insight-footer">
                {#if lateState === 'safe' && targetDisiplinCount > 0}
                  Macro adherence aligns with benchmarks, but {targetDisiplinCount} personnel present isolated attendance variances requiring review.
                {:else if targetDisiplinCount > 0}
                  Prioritize these {targetDisiplinCount} personnel for immediate schedule adherence review and compliance validation.
                {:else}
                  Zero personnel flagged for critical attendance variance.
                {/if}
              </div>
            </div>
          </div>

          <details class="guide-acc" style="margin-top: 16px; margin-bottom: 0;">
            <summary>💡 AI Parameter: Determining Status & Target</summary>
            <div class="guide-body" style="padding: 16px;">
              <p style="margin-top: 4px; margin-bottom: 16px; font-weight: 500; color: var(--color-text-secondary);">
                The system doesn't use feelings, but rather quantitative data benchmarks to trigger discipline alarms:
              </p>
              
              <div class="guide-grid" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 16px;">
                <div class="guide-card blue">
                  <div class="guide-card-icon">🛡️</div>
                  <div class="guide-card-content">
                    <div class="guide-card-label">Indiscipline Rate</div>
                    <h4 class="guide-card-title">Macro Filter</h4>
                    <p class="guide-card-copy">Measures the ratio of lateness incidents to total daily attendance:</p>
                    <ul style="margin: 12px 0 0 0; padding: 0; font-size: 13px; color: var(--color-text-secondary); line-height: 1.6; display: flex; flex-direction: column; gap: 6px;">
                      <li style="display: flex; align-items: flex-start; gap: 8px;"><span style="color: #94a3b8; font-size: 14px; line-height: 1;">•</span> <div><strong>&lt; 10%:</strong> Healthy (Safe shift formation)</div></li>
                      <li style="display: flex; align-items: flex-start; gap: 8px;"><span style="color: #94a3b8; font-size: 14px; line-height: 1;">•</span> <div><strong>10% - 20%:</strong> Warning (Lateness culture appearing)</div></li>
                      <li style="display: flex; align-items: flex-start; gap: 8px;"><span style="color: #94a3b8; font-size: 14px; line-height: 1;">•</span> <div><strong>&gt; 20%:</strong> Critical (Operational threat)</div></li>
                    </ul>
                  </div>
                </div>

                <div class="guide-card red">
                  <div class="guide-card-icon">🎯</div>
                  <div class="guide-card-content">
                    <div class="guide-card-label">Main Coaching Target</div>
                    <h4 class="guide-card-title">Micro Filter</h4>
                    <p class="guide-card-copy">Detects staff with the worst individual absent/late records:</p>
                    <ul style="margin: 12px 0 0 0; padding: 0; font-size: 13px; color: var(--color-text-secondary); line-height: 1.6; display: flex; flex-direction: column; gap: 6px;">
                      <li style="display: flex; align-items: flex-start; gap: 8px;"><span style="color: #94a3b8; font-size: 14px; line-height: 1;">•</span> <div><strong>High Level:</strong> &ge; 2 Absences or &ge; 4 Latenesses / month</div></li>
                      <li style="display: flex; align-items: flex-start; gap: 8px;"><span style="color: #94a3b8; font-size: 14px; line-height: 1;">•</span> <div><strong>Critical Level:</strong> &ge; 3 Absences or &ge; 6 Latenesses / month</div></li>
                    </ul>
                  </div>
                </div>
              </div>
              <div style="margin-top: 16px; padding: 12px; background: rgba(226, 232, 240, 0.4); border-radius: 8px; font-size: 13px; color: var(--color-text-secondary); border-left: 3px solid #94a3b8;">
                <strong>Long-Term Business Impact:</strong> Just one cashier staff being 15 minutes late during peak hours risks creating long queues and instantly decreasing customer satisfaction levels.
              </div>
            </div>
          </details>

        </div>

        <!-- 2. Rekomendasi Aksi (Decision Box) -->
        <div>
          <div class="section-head tight" style="margin-bottom: 16px;">
            <div>
              <div class="section-eyebrow">📝 Tactical Execution</div>
              <h3 class="section-title">Schedule Adherence Directives</h3>
              <p class="section-copy">Actionable items directed towards mitigating recurring schedule variances.</p>
            </div>
          </div>
          <div class="decision-box {lateColor}">
            <div class="decision-content">
              <div class="decision-title">
                <span style="display: flex; align-items: center; gap: 8px;">
                  <span style="font-size: 1.1em;">{lateState === 'safe' && targetDisiplinCount === 0 ? '✅' : targetDisiplinCount > 0 ? '⚠️' : '🚨'}</span>
                  {lateState === 'safe' && targetDisiplinCount === 0 ? 'Optimal Compliance' : targetDisiplinCount > 0 ? 'Compliance Review Indicated' : 'Compliance Variance Alert'}
                </span>
                <div class="ai-badge">✨ System Verified</div>
              </div>
              <p class="decision-text">
                {#if lateState === 'safe' && targetDisiplinCount === 0}
                  Labor attendance adherence remains within acceptable thresholds, indicating solid shift fulfillment. Monitoring is recommended for long-term consistency.
                {:else if lateState === 'safe' && targetDisiplinCount > 0}
                  Overall adherence is optimal. However, isolated variances in scheduling fulfillment have been detected among <strong>{targetDisiplinCount} personnel</strong>. Procedural compliance review is recommended.
                {:else if lateState === 'warn'}
                  Moderate schedule instability detected among <strong>{targetDisiplinCount} personnel</strong>. Standard operating procedure (SOP) reinforcement is advised to prevent cascading fulfillment issues.
                {:else}
                  Critical deviation from standard scheduling compliance detected. Immediate administrative review and corrective action are required for the following <strong>{targetDisiplinCount} personnel</strong> to restore shift integrity:
                {/if}
              </p>
              
              <div class="table-container">
                <DataTable data={attendance_problem} rows={10} search={true}>
                  <Column id="nama_staf_html" title="Staff Name" contentType="html" />
                  <Column id="role" title="Position" />
                  <Column id="branch_name" title="Branch" />
                  <Column id="total_absent" title="Total Absent" align="center" />
                  <Column id="total_late" title="Total Late" align="center" />
                  <Column id="risk_label" title="Risk Level" align="center" />
                  <Column id="recommended_action" title="Recommended Action" />
                </DataTable>
              </div>

              <div class="decision-footer">
                <em>*Disclaimer: AI punishment recommendations are based on accumulative incident frequency without knowing specific reasons (like being sick). Do cross-validation before taking action.</em>
              </div>
            </div>
          </div>
        </div>

        <!-- 3. Data Pendukung (Grafik) -->
        <div>
          <div class="section-head tight" style="margin-bottom: 12px;">
            <div>
              <div class="section-eyebrow">📊 Violation Profile</div>
              <h3 class="section-title">Discipline Risk Distribution</h3>
              <p class="section-copy">Visualization of discipline severity level and violation contribution from each branch.</p>
            </div>
          </div>
          <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 24px;">
             <div style="background: linear-gradient(180deg, var(--color-background-primary), var(--color-background-secondary)); padding: 24px; border-radius: 16px; border: 1px solid var(--color-border-tertiary); box-shadow: 0 4px 12px rgba(0,0,0,0.02);">
               <h4 style="font-size: 13px; font-weight: 700; letter-spacing: 0.05em; text-transform: uppercase; color: var(--color-text-tertiary); margin-top: 0; margin-bottom: 24px;">Discipline Severity Rate</h4>
               <ECharts config={chartOptionAttendance} height="260px" />
           </div>
           <div style="background: linear-gradient(180deg, var(--color-background-primary), var(--color-background-secondary)); padding: 24px; border-radius: 16px; border: 1px solid var(--color-border-tertiary); box-shadow: 0 4px 12px rgba(0,0,0,0.02);">
             <h4 style="font-size: 13px; font-weight: 700; letter-spacing: 0.05em; text-transform: uppercase; color: var(--color-text-tertiary); margin-top: 0; margin-bottom: 24px;">Problematic Staff Distribution per Branch</h4>
             <ECharts config={chartOptionAttendanceBranch} height="260px" />
           </div>
          </div>
        </div>

      </div>
    </div>
  </details>
</div>

<!-- Outer Diagnostics Container 1 -->
<div id="burnout" class="diagnostics-stack" style="margin-top: 32px; margin-bottom: 24px;">
  <div class="diagnostics-header">
    <div class="diagnostics-eyebrow">🚨 Labor Risk Alert</div>
<h2 class="diagnostics-title">Overtime Strain & Labor Allocation</h2>
    <p class="diagnostics-copy">Identifies personnel exceeding target overtime thresholds. Facilitates schedule recalibration to mitigate productivity degradation and retention risks.</p>
  </div>
  
  <details id="acc-burnout" class="acc-strategic">
    <summary>📊 Dive into Labor Allocation Data</summary>

    <div class="acc-body">
      <div style="display: flex; flex-direction: column; gap: 24px;">
        
        <!-- 1. Kesimpulan (Insight) -->
        <div>
          <div class="section-head tight" style="margin-bottom: 12px;">
            <div>
              <div class="section-eyebrow">🚨 Variance Summary</div>
              <h3 class="section-title">Labor Utilization & Schedule Rotation Priority</h3>
              <p class="section-copy">Analyzes overall labor utilization efficiency and isolates personnel requiring immediate scheduling adjustments to balance overtime distribution.</p>
            </div>
          </div>
          
          <div class="insight-grid">
            <div class="insight-card {overtimeState === 'safe' ? 'safe' : overtimeState === 'warn' ? 'warn' : 'kritis'}">
              <div class="insight-header">
                <span class="insight-icon">{overtimeState === 'safe' ? '🛡️' : overtimeState === 'warn' ? '⚠️' : '🚨'}</span>
                <span class="insight-title">Labor Utilization Rate (Overtime)</span>
              </div>
              <div class="insight-body">
                <div class="insight-number">{usFormat(overtimePct, 1)}<span class="insight-percent">%</span></div>
                <div class="insight-status-badge {overtimeState === 'safe' ? 'safe' : overtimeState === 'warn' ? 'warn' : 'kritis'}">{overtimeState === 'safe' ? 'OPTIMAL' : overtimeState === 'warn' ? 'ELEVATED' : 'CRITICAL'}</div>
              </div>
              <div class="insight-footer">
                {#if overtimeState === 'safe'}
                  Labor distribution across operational shifts remains balanced, requiring minimal supplementary hours.
                {:else if overtimeState === 'warn'}
                  Overhead from supplementary hours is approaching optimal utilization thresholds, indicating potential staffing imbalances.
                {:else}
                  Critical dependence on supplementary labor hours identified. Shift coverage requires structural re-evaluation.
                {/if}
              </div>
            </div>

            <div class="insight-card target-card {criticalBurnoutCount > 0 ? 'kritis' : targetBurnoutCount > 0 ? 'warn' : 'neutral'}">
              <div class="insight-header">
                <span class="insight-icon">🎯</span>
                <span class="insight-title">Target Reallocation Priority</span>
              </div>
              <div class="insight-body">
                <div class="insight-number">{targetBurnoutCount}<span class="insight-percent">&nbsp;Staff</span></div>
                <div class="insight-status-badge {criticalBurnoutCount > 0 ? 'kritis' : targetBurnoutCount > 0 ? 'warn' : 'neutral'}">REALLOCATION RISK</div>
              </div>
              <div class="insight-footer">
                {#if overtimeState === 'safe' && targetBurnoutCount > 0}
                  Despite acceptable macro utilization, overtime burden is highly concentrated among {targetBurnoutCount} personnel.
                {:else if targetBurnoutCount > 0}
                  Immediate scheduling reallocation is advised for {targetBurnoutCount} personnel to mitigate productivity degradation risks.
                {:else}
                  Labor allocation is uniform. No personnel exhibit anomalous overtime density.
                {/if}
              </div>
            </div>
          </div>

          <details class="guide-acc" style="margin-top: 16px; margin-bottom: 0;">
            <summary>💡 AI Parameter: Determining Status & Target</summary>
            <div class="guide-body" style="padding: 16px;">
              <p style="margin-top: 4px; margin-bottom: 16px; font-weight: 500; color: var(--color-text-secondary);">
                To maintain objectivity, AI monitors overtime risk with two rigid metric filter layers:
              </p>
              
              <div class="guide-grid" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 16px;">
                <div class="guide-card blue">
                  <div class="guide-card-icon">🛡️</div>
                  <div class="guide-card-content">
                    <div class="guide-card-label">Overtime Pressure Rate</div>
                    <h4 class="guide-card-title">Macro Filter</h4>
                    <p class="guide-card-copy">Measures the percentage of operational shifts filled with overtime hours:</p>
                    <ul style="margin: 12px 0 0 0; padding: 0; font-size: 13px; color: var(--color-text-secondary); line-height: 1.6; display: flex; flex-direction: column; gap: 6px;">
                      <li style="display: flex; align-items: flex-start; gap: 8px;"><span style="color: #94a3b8; font-size: 14px; line-height: 1;">•</span> <div><strong>&lt; 35%:</strong> Healthy (Ideal capacity)</div></li>
                      <li style="display: flex; align-items: flex-start; gap: 8px;"><span style="color: #94a3b8; font-size: 14px; line-height: 1;">•</span> <div><strong>35% - 50%:</strong> Warning (Starting to lack staff)</div></li>
                      <li style="display: flex; align-items: flex-start; gap: 8px;"><span style="color: #94a3b8; font-size: 14px; line-height: 1;">•</span> <div><strong>&gt; 50%:</strong> Critical (Systemic staff shortage)</div></li>
                    </ul>
                  </div>
                </div>

                <div class="guide-card red">
                  <div class="guide-card-icon">🎯</div>
                  <div class="guide-card-content">
                    <div class="guide-card-label">Priority Rotation Target</div>
                    <h4 class="guide-card-title">Micro Filter</h4>
                    <p class="guide-card-copy">System detects individual overtime accumulation anomalies (Red Zone Target):</p>
                    <ul style="margin: 12px 0 0 0; padding: 0; font-size: 13px; color: var(--color-text-secondary); line-height: 1.6; display: flex; flex-direction: column; gap: 6px;">
                      <li style="display: flex; align-items: flex-start; gap: 8px;"><span style="color: #94a3b8; font-size: 14px; line-height: 1;">•</span> <div><strong>&lt; 10 Hours:</strong> Safe Zone (Reasonable tolerance)</div></li>
                      <li style="display: flex; align-items: flex-start; gap: 8px;"><span style="color: #94a3b8; font-size: 14px; line-height: 1;">•</span> <div><strong>10 - 20 Hours:</strong> Warning (Monitor fatigue)</div></li>
                      <li style="display: flex; align-items: flex-start; gap: 8px;"><span style="color: #94a3b8; font-size: 14px; line-height: 1;">•</span> <div><strong>&gt; 20 Hours:</strong> Critical (Extreme <em>burnout</em> risk)</div></li>
                    </ul>
                  </div>
                </div>
              </div>
              <div style="margin-top: 16px; padding: 12px; background: rgba(226, 232, 240, 0.4); border-radius: 8px; font-size: 13px; color: var(--color-text-secondary); border-left: 3px solid #94a3b8;">
                <strong>Long-Term Business Impact:</strong> Overtime shifts can indeed cover staff shortages instantly, but if left alone this will destroy staff focus and result in high <em>human-error</em> (wrong orders, complaints rise).
              </div>
            </div>
          </details>

        </div>

        <!-- 2. Rekomendasi Aksi (Decision Box) -->
        <div>
          <div class="section-head tight" style="margin-bottom: 16px;">
            <div>
              <div class="section-eyebrow">📝 Tactical Execution</div>
              <h3 class="section-title">Labor Reallocation Strategy</h3>
              <p class="section-copy">System-recommended schedule adjustments targeting personnel exceeding sustainable utilization boundaries.</p>
            </div>
          </div>
          <div class="decision-box {overtimeColor}">
            <div class="decision-content">
              <div class="decision-title">
                <span style="display: flex; align-items: center; gap: 8px;">
                  <span style="font-size: 1.1em;">
                    {#if overtimeState === 'safe' && targetBurnoutCount === 0}✅
                    {:else if overtimeState === 'safe' && targetBurnoutCount > 0}⚠️
                    {:else}🚨{/if}
                  </span>
                  {#if overtimeState === 'safe' && targetBurnoutCount === 0}
                    Capacity Optimized
                  {:else if overtimeState === 'safe' && targetBurnoutCount > 0}
                    Utilization Discrepancy Detected
                  {:else if overtimeState === 'warn'}
                    Labor Constraints Detected
                  {:else}
                    Resource Allocation Critical
                  {/if}
                </span>
                <div class="ai-badge">✨ System Verified</div>
              </div>
              <p class="decision-text">
                {#if overtimeState === 'safe' && targetBurnoutCount === 0}
                  Supplementary labor utilization remains balanced across the workforce. Maintain current scheduling parameters to sustain operational efficiency.
                {:else if overtimeState === 'safe' && targetBurnoutCount > 0}
                  While overall utilization is stable, targeted reallocation is required for <strong>{targetBurnoutCount} personnel</strong> exhibiting excessive overtime accumulation to prevent service degradation.
                {:else if overtimeState === 'warn'}
                  Sustained elevation in supplementary hour utilization suggests underlying baseline coverage deficiencies. Immediate schedule normalization is advised for the following <strong>{targetBurnoutCount} personnel</strong>.
                {:else}
                  Critical deficit in primary labor capacity identified, leading to systemic over-reliance on supplementary shifts. Execute immediate schedule rotations for the affected <strong>{targetBurnoutCount} personnel</strong> and review broader staffing requisites.
                {/if}
              </p>
              
              <div class="table-container">
                <DataTable data={burnout_risk} rows={10} search={true}>
                  <Column id="employee_name" title="Staff Name" />
                  <Column id="role" title="Position" />
                  <Column id="branch_name" title="Branch" />
                  <Column id="jam_lembur_html" title="Total OT (Hours)" align="center" contentType="html" />
                  <Column id="overtime_days" title="OT Sessions (Days)" align="center" />
                  <Column id="recommended_action" title="Recommended Action" />
                </DataTable>
              </div>
              
              <div class="decision-footer">
                <em>*Disclaimer: System detects overtime thresholds based on weekly healthy shift regulations.</em>
              </div>
            </div>
          </div>
        </div>

        <!-- 3. Data Pendukung (Grafik) -->
        <div>
          <div class="section-head tight" style="margin-bottom: 12px;">
            <div>
              <div class="section-eyebrow">📊 Workload Profile</div>
              <h3 class="section-title">Overtime Hours Distribution</h3>
              <p class="section-copy">See the distribution of total overtime hours done by at-risk staff over the last 30 days.</p>
            </div>
          </div>
          <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 24px;">
             <div style="background: linear-gradient(180deg, var(--color-background-primary), var(--color-background-secondary)); padding: 24px; border-radius: 16px; border: 1px solid var(--color-border-tertiary); box-shadow: 0 4px 12px rgba(0,0,0,0.02);">
               <h4 style="font-size: 13px; font-weight: 700; letter-spacing: 0.05em; text-transform: uppercase; color: var(--color-text-tertiary); margin-top: 0; margin-bottom: 24px;">Overtime Severity Rate</h4>
               <ECharts config={chartOptionBurnout} height="260px" />
           </div>
           <div style="background: linear-gradient(180deg, var(--color-background-primary), var(--color-background-secondary)); padding: 24px; border-radius: 16px; border: 1px solid var(--color-border-tertiary); box-shadow: 0 4px 12px rgba(0,0,0,0.02);">
             <h4 style="font-size: 13px; font-weight: 700; letter-spacing: 0.05em; text-transform: uppercase; color: var(--color-text-tertiary); margin-top: 0; margin-bottom: 24px;">Total Overtime Based on Branch</h4>
             <ECharts config={chartOptionBurnoutBranch} height="260px" />
           </div>
          </div>
        </div>

      </div>
    </div>
  </details>
</div>

{:else}
  <GlobalLoading />
{/if}

<style>
/* ── CSS Bawaan (Di-import atau Copy dari Index) ── */
.diagnostics-stack { display: flex; flex-direction: column; gap: 16px; margin-top: 14px; }
.diagnostics-header { padding: 0 2px; margin-bottom: 2px; }
.diagnostics-eyebrow { font-size: 10px; font-weight: 700; letter-spacing: 0.12em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 6px; display: flex; align-items: center; gap: 6px; }
.diagnostics-title { font-size: 1.3rem; font-weight: 800; letter-spacing: -0.025em; color: var(--color-text-primary); margin: 0 0 4px; }
.diagnostics-copy { font-size: 0.9rem; line-height: 1.7; color: var(--color-text-secondary); max-width: 68ch; margin: 0; }

.section-eyebrow { font-size: 10px; font-weight: 700; letter-spacing: 0.12em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 6px; display: flex; align-items: center; gap: 6px; }
.section-title { font-size: 1.15rem; font-weight: 800; letter-spacing: -0.02em; color: var(--color-text-primary); margin: 0 0 4px; }
.section-copy { font-size: 0.85rem; line-height: 1.6; color: var(--color-text-secondary); max-width: 72ch; margin: 0; }

.diagnostics-stack { display: flex; flex-direction: column; gap: 16px; margin-top: 14px; }
.diagnostics-header { padding: 0 2px; margin-bottom: 2px; }
.diagnostics-eyebrow { font-size: 10px; font-weight: 700; letter-spacing: 0.12em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 6px; display: flex; align-items: center; gap: 6px; }
.diagnostics-title { font-size: 1.3rem; font-weight: 800; letter-spacing: -0.025em; color: var(--color-text-primary); margin: 0 0 4px; }
.diagnostics-copy { font-size: 0.9rem; line-height: 1.7; color: var(--color-text-secondary); max-width: 68ch; margin: 0; }

.section-eyebrow { font-size: 10px; font-weight: 700; letter-spacing: 0.12em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 6px; display: flex; align-items: center; gap: 6px; }
.section-title { font-size: 1.15rem; font-weight: 800; letter-spacing: -0.02em; color: var(--color-text-primary); margin: 0 0 4px; }
.section-copy { font-size: 0.85rem; line-height: 1.6; color: var(--color-text-secondary); max-width: 72ch; margin: 0; }

/* ── Insight Cards ── */
.insight-grid { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 16px; }
.insight-card { padding: 20px; border-radius: 16px; border: 1px solid var(--color-border-tertiary); background: var(--color-background-secondary); display: flex; flex-direction: column; justify-content: space-between; transition: all 0.25s ease; position: relative; overflow: hidden; }
.insight-card:hover { transform: translateY(-2px); box-shadow: 0 8px 24px rgba(0,0,0,0.06); }
.insight-card.safe { background: linear-gradient(145deg, rgba(22,163,74,0.03), rgba(22,163,74,0.01)); border-color: rgba(22,163,74,0.2); }
.insight-card.warn { background: linear-gradient(145deg, rgba(245,158,11,0.04), rgba(245,158,11,0.01)); border-color: rgba(245,158,11,0.25); }
.insight-card.kritis { background: linear-gradient(145deg, rgba(220,38,38,0.05), rgba(220,38,38,0.01)); border-color: rgba(220,38,38,0.25); }
.insight-card.neutral { background: linear-gradient(145deg, rgba(99,102,241,0.04), rgba(99,102,241,0.01)); border-color: rgba(99,102,241,0.2); }

.insight-header { display: flex; align-items: center; gap: 8px; margin-bottom: 16px; }
.insight-icon { font-size: 1.2rem; }
.insight-title { font-size: 0.85rem; font-weight: 800; letter-spacing: 0.08em; text-transform: uppercase; color: var(--color-text-tertiary); }

.insight-body { display: flex; align-items: baseline; gap: 12px; margin-bottom: 12px; }
.insight-number { font-size: 3rem; font-weight: 900; line-height: 1; letter-spacing: -0.04em; color: var(--color-text-primary); }
.insight-percent { font-size: 1.25rem; font-weight: 700; color: var(--color-text-secondary); margin-left: 2px; }

.insight-status-badge { padding: 4px 10px; border-radius: 999px; font-size: 0.75rem; font-weight: 800; letter-spacing: 0.05em; }
.insight-status-badge.safe { background: rgba(22,163,74,0.15); color: #166534; }
.insight-status-badge.warn { background: rgba(245,158,11,0.15); color: #92400e; }
.insight-status-badge.kritis { background: rgba(220,38,38,0.15); color: #991b1b; }
.insight-status-badge.neutral { background: rgba(99,102,241,0.15); color: #4338ca; }

.insight-footer { font-size: 0.9rem; color: var(--color-text-secondary); line-height: 1.5; }
.insight-footer strong { color: var(--color-text-primary); }

/* ── Standard Accordion ── */
details.acc-strategic {
  border-radius: 20px;
  border: 1.5px solid rgba(99,102,241,0.18);
  background: linear-gradient(135deg, rgba(99,102,241,0.04), rgba(139,92,246,0.03));
}
details.acc-strategic > summary {
  padding: 18px 20px; background: transparent;
  font-size: 1rem; font-weight: 800; color: var(--color-text-primary);
  cursor: pointer; list-style: none; display: flex; align-items: center;
}
details.acc-strategic > summary::-webkit-details-marker { display: none; }
details.acc-strategic > summary::after {
  content: '›'; margin-left: auto; font-size: 1.3rem; font-weight: 400;
  color: var(--color-text-tertiary); transition: transform 0.2s; display: inline-block;
}
details.acc-strategic[open] > summary::after { transform: rotate(90deg); }
details.acc-strategic[open] > summary { border-bottom: 1.5px solid rgba(99,102,241,0.14); }
details.acc-strategic .acc-body { padding: 20px; }

/* ── AI Decision Box CSS ── */
.decision-box {
  display: flex; gap: 24px; padding: 24px 32px; border-radius: 16px; border: 1px solid var(--color-border-tertiary);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); box-shadow: 0 4px 12px rgba(0,0,0,0.02); background: var(--color-background-secondary);
}
.decision-box.red { border-color: rgba(239, 68, 68, 0.2); background: rgba(239, 68, 68, 0.03); }
.decision-box.red:hover { box-shadow: 0 8px 24px rgba(239, 68, 68, 0.06); border-color: rgba(239, 68, 68, 0.4); transform: translateY(-2px); }
.decision-box.green { border-color: rgba(16, 185, 129, 0.2); background: rgba(16, 185, 129, 0.03); }
.decision-box.green:hover { box-shadow: 0 8px 24px rgba(16, 185, 129, 0.06); border-color: rgba(16, 185, 129, 0.4); transform: translateY(-2px); }
.decision-box.amber { border-color: rgba(245, 158, 11, 0.2); background: rgba(245, 158, 11, 0.03); }
.decision-box.amber:hover { box-shadow: 0 8px 24px rgba(245, 158, 11, 0.06); border-color: rgba(245, 158, 11, 0.4); transform: translateY(-2px); }

.decision-content { flex: 1; min-width: 0; }
.decision-title { font-size: 1.25rem; font-weight: 800; margin-bottom: 12px; display: flex; justify-content: space-between; align-items: center; }
.decision-text { font-size: 1.05rem; line-height: 1.6; font-weight: 500; margin: 0; color: var(--color-text-secondary); }
.decision-footer { margin-top: 16px; font-size: 0.8rem; opacity: 0.8; border-top: 1px dashed currentColor; padding-top: 12px; }
.ai-badge { background: rgba(0,0,0,0.08); padding: 6px 12px; border-radius: 8px; font-size: 0.65rem; text-transform: uppercase; font-weight: 800; letter-spacing: 0.1em; display: flex; align-items: center; gap: 4px; }
.table-container { margin-top: 24px; background: var(--color-background-primary); border-radius: 12px; overflow-x: auto; border: 1px solid var(--color-border-tertiary); box-shadow: 0 4px 15px rgba(0,0,0,0.03); }
</style>
