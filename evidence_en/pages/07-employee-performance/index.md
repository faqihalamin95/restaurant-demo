---
title: Employee Performance
---
<EmployeeTabs activeTab="overview" />

```sql workforce_overview
SELECT * FROM restaurant.workforce_health_overview
```

```sql burnout_risk
SELECT COUNT(*) as count 
FROM restaurant.top_overtime_employees_period
WHERE period = '30d' AND total_overtime_hours >= 10
```

```sql total_employees
SELECT COUNT(DISTINCT employee_id) as count
FROM restaurant.employee_shift_performance
WHERE attendance_date >= (SELECT MAX(attendance_date) - INTERVAL '29 days' FROM restaurant.employee_shift_performance)
```



<script>
  function usFormat(num, dec = 0) {
    if (num === null || num === undefined) return '0';
    return new Intl.NumberFormat('en-US', { minimumFractionDigits: dec, maximumFractionDigits: dec }).format(num);
  }

  let attendanceRate = 0;
  let overtimePct = 0;
  let overtimeHours = 0;
  let latePct = 0;
  let lateCount = 0;
  let revPerHour = 0;
  let absentCount = 0;
  let problemEmployees = 0;
  let pressureShift = '-';
  let pressureBranch = '-';
  let focus30d = '-';
  let tglAwal = '09 Jun 2026';
  let tglAkhir = '08 Jul 2026';

  $: if (workforce_overview && workforce_overview.length > 0) {
     attendanceRate = workforce_overview[0].attendance_30d;
     overtimePct = workforce_overview[0].overtime_pct_30d;
     overtimeHours = workforce_overview[0].overtime_hours_30d;
     latePct = workforce_overview[0].late_30d;
     lateCount = workforce_overview[0].late_count_30d;
     revPerHour = workforce_overview[0].rev_per_hour_30d;
     absentCount = workforce_overview[0].absent_30d;
     problemEmployees = workforce_overview[0].problem_employees_30d;
     pressureShift = workforce_overview[0].pressure_shift_30d;
     pressureBranch = workforce_overview[0].pressure_branch_30d;
     focus30d = workforce_overview[0].focus_30d;
  }

  let burnoutEmployees = 0;
  $: if (burnout_risk && burnout_risk.length > 0) {
     burnoutEmployees = burnout_risk[0].count;
  }

  let totalEmp = 100; // fallback
  $: if (total_employees && total_employees.length > 0) {
     totalEmp = total_employees[0].count || 100;
  }


  let heroStatusClass = 'status-sehat';
  $: if (attendanceRate >= 92) heroStatusClass = 'status-sehat';
  else if (attendanceRate >= 85) heroStatusClass = 'status-waspada';
  else heroStatusClass = 'status-kritis';

  let lateState = 'safe';
  $: {
    let problemPct = (problemEmployees / totalEmp) * 100;
    if (problemPct >= 15) lateState = 'critical'; // >= 15% dari total pegawai
    else if (problemPct >= 5) lateState = 'warn'; // 5% - 15% dari total pegawai
    else lateState = 'safe';
  }

  let overtimeState = 'safe';
  $: {
    let burnoutPct = (burnoutEmployees / totalEmp) * 100;
    if (burnoutPct >= 15) overtimeState = 'critical';
    else if (burnoutPct >= 5) overtimeState = 'warn';
    else overtimeState = 'safe';
  }
  
  let safeCount = 0;
  let warnCount = 0;
  let criticalCount = 0;
  $: {
    let s = 0, w = 0, c = 0;
    
    if (lateState === 'safe') s++;
    else if (lateState === 'warn') w++;
    else c++;

    if (overtimeState === 'safe') s++;
    else if (overtimeState === 'warn') w++;
    else c++;

    safeCount = s;
    warnCount = w;
    criticalCount = c;
  }
</script>

{#if workforce_overview && workforce_overview.length > 0}

<div class="hero" style="margin-bottom: 32px; margin-top: 10px;">
  <div class="hero-eyebrow">👥 Employee Performance (Last 30 Days) · {tglAwal} - {tglAkhir}</div>
  <div class="hero-grid">
    <div class="hero-main-card {heroStatusClass}">
      <div class="hero-stat-number">{usFormat(attendanceRate, 1)}%</div>
      <div class="hero-stat-label">ATTENDANCE RATE</div>
      <div class="hero-subtitle">
        {#if heroStatusClass === 'status-sehat'}
          Labor deployment efficiency is operating within optimal baseline thresholds.
        {:else if heroStatusClass === 'status-waspada'}
          Shift fulfillment is adequate, though localized staffing gaps require attention.
        {:else}
          Critical labor shortages detected; immediate FOH service risk identified.
        {/if}
      </div>
    </div>
    <div class="hero-side">
      <div class="hero-side-card">
        <div class="hero-side-label">⏱️ Overtime Burden (OT)</div>
        <div class="hero-side-value">{usFormat(overtimeHours)} Hours</div>
        <div class="hero-side-note">Aggregate overtime hours logged to subsidize active staffing gaps.</div>
      </div>
      <div class="hero-side-card">
        <div class="hero-side-label">⚠️ Attendance Variance</div>
        <div class="hero-side-value">{usFormat(lateCount)} Late | {usFormat(absentCount)} Absent</div>
        <div class="hero-side-note">Recorded disciplinary infractions impacting front-line service velocity.</div>
      </div>
    </div>
  </div>
</div>

<div style="margin-top: 32px; margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">
  <div style="font-size: 1.5rem;">🎯</div>
  <div>
    <h2 style="margin: 0; font-size: 1.25rem; font-weight: 800; color: var(--color-text-primary); letter-spacing: -0.02em;">TACTICAL OPERATIONAL DIRECTIVES</h2>
    <div style="font-size: 0.85rem; color: var(--color-text-tertiary); font-weight: 500;">Algorithmic labor workflows and immediate execution priorities for branch management.</div>
  </div>
</div>

<details class="guide-acc" open="true" style="margin-bottom: 24px; margin-top: 8px;">
  <summary>📖 Analytics Page Operational Guide</summary>
  <div class="guide-body">
    <div style="display: flex; align-items: center; gap: 12px; padding: 8px 0; width: 100%;">
      <!-- Step 1 Card -->
      <div class="interactive-card" style="flex: 1 1 0%; min-width: 0; background: #f4f8fb; border: 1px solid #e1ecf4; border-radius: 16px; padding: 20px; position: relative;">
        <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 12px;">
          <div style="position: relative;">
            <div style="font-size: 1.4rem; height: 40px; width: 40px; display: flex; align-items: center; justify-content: center; background: white; border-radius: 12px; box-shadow: 0 2px 8px rgba(124, 168, 209, 0.15);">🩺</div>
            <div style="position: absolute; width: 20px; height: 20px; background: #7ca8d1; color: white; border-radius: 50%; font-size: 0.7rem; font-weight: 800; display: flex; align-items: center; justify-content: center; box-shadow: 0 2px 4px rgba(124, 168, 209, 0.3); border: 2px solid white; top: -6px; right: -6px;">1</div>
          </div>
          <div style="font-weight: 800; color: var(--color-text-primary); font-size: 1rem;">Status Surveillance</div>
        </div>
        <div style="display: flex; flex-direction: column; gap: 6px; margin-bottom: 10px; user-select: none;">
          <div style="background: rgba(22,163,74,0.06); border: 1px solid rgba(22,163,74,0.15); border-radius: 6px; padding: 4px 8px; display: flex; align-items: center; gap: 8px; pointer-events: none;">
            <span style="font-size: 0.75rem;">✅</span>
            <div style="height: 4px; background: #cbd5e1; border-radius: 2px; width: 45%;"></div>
          </div>
          <div style="background: rgba(234,179,8,0.08); border: 1px solid rgba(234,179,8,0.2); border-radius: 6px; padding: 4px 8px; display: flex; align-items: center; gap: 8px; pointer-events: none;">
            <span style="font-size: 0.75rem;">⚠️</span>
            <div style="height: 4px; background: #cbd5e1; border-radius: 2px; width: 60%;"></div>
          </div>
        </div>
        <div style="font-size: 0.85rem; color: var(--color-text-secondary); line-height: 1.6;">
          Evaluate <strong>core metric indicators</strong> and prioritize operational exceptions highlighted in <strong>warning</strong> or <strong>critical</strong> states.
        </div>
      </div>
      
      <!-- Arrow 1 -->
      <div style="font-size: 1.5rem; color: #cbd5e1; font-weight: bold; flex-shrink: 0; display: flex; align-items: center; justify-content: center;">➔</div>
      
      <!-- Step 2 Card -->
      <div class="interactive-card" style="flex: 1 1 0%; min-width: 0; background: #f9f5fa; border: 1px solid #eee1f1; border-radius: 16px; padding: 20px; position: relative;">
        <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 12px;">
          <div style="position: relative;">
            <div style="font-size: 1.4rem; height: 40px; width: 40px; display: flex; align-items: center; justify-content: center; background: white; border-radius: 12px; box-shadow: 0 2px 8px rgba(178, 139, 194, 0.15);">👆</div>
            <div style="position: absolute; width: 20px; height: 20px; background: #b28bc2; color: white; border-radius: 50%; font-size: 0.7rem; font-weight: 800; display: flex; align-items: center; justify-content: center; box-shadow: 0 2px 4px rgba(178, 139, 194, 0.3); border: 2px solid white; top: -6px; right: -6px;">2</div>
          </div>
          <div style="font-weight: 800; color: var(--color-text-primary); font-size: 1rem;">Granular Drill-Down</div>
        </div>
        <div style="position: relative; margin-bottom: 10px; user-select: none;">
          <div style="display: flex; flex-direction: column; gap: 6px;">
            <div style="background: rgba(22,163,74,0.06); border: 1px solid rgba(22,163,74,0.15); border-radius: 6px; padding: 4px 8px; display: flex; align-items: center; gap: 8px; pointer-events: none; opacity: 0.5;">
              <span style="font-size: 0.75rem;">✅</span>
              <div style="height: 4px; background: #cbd5e1; border-radius: 2px; width: 45%;"></div>
            </div>
            <div style="background: rgba(234,179,8,0.08); border: 1px solid rgba(234,179,8,0.2); border-radius: 6px; padding: 4px 8px; display: flex; align-items: center; gap: 8px; pointer-events: none;">
              <span style="font-size: 0.75rem;">⚠️</span>
              <div style="height: 4px; background: #cbd5e1; border-radius: 2px; width: 60%;"></div>
            </div>
          </div>
          <div style="position: absolute; right: 15%; bottom: -10px; font-size: 1.2rem; filter: drop-shadow(0 2px 4px rgba(0,0,0,0.15)); transform: rotate(-15deg);">
            👆
          </div>
        </div>
        <div style="font-size: 0.85rem; color: var(--color-text-secondary); line-height: 1.6;">
          Select any <strong>indicator row</strong> to isolate its underlying <strong>driver metrics</strong> and drill into <strong>granular root-cause records</strong>.
        </div>
      </div>

      <!-- Arrow 2 -->
      <div style="font-size: 1.5rem; color: #cbd5e1; font-weight: bold; flex-shrink: 0; display: flex; align-items: center; justify-content: center;">➔</div>

      <!-- Step 3 Card -->
      <div class="interactive-card" style="flex: 1 1 0%; min-width: 0; background: #f4fbf7; border: 1px solid #dcf2e5; border-radius: 16px; padding: 20px; position: relative;">
        <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 12px;">
          <div style="position: relative;">
            <div style="font-size: 1.4rem; height: 40px; width: 40px; display: flex; align-items: center; justify-content: center; background: white; border-radius: 12px; box-shadow: 0 2px 8px rgba(123, 191, 153, 0.15);">🎯</div>
            <div style="position: absolute; width: 20px; height: 20px; background: #7bbf99; color: white; border-radius: 50%; font-size: 0.7rem; font-weight: 800; display: flex; align-items: center; justify-content: center; box-shadow: 0 2px 4px rgba(123, 191, 153, 0.3); border: 2px solid white; top: -6px; right: -6px;">3</div>
          </div>
          <div style="font-weight: 800; color: var(--color-text-primary); font-size: 1rem;">Directive Execution</div>
        </div>
        <div style="height: 52px; margin-bottom: 10px; background: rgba(123, 191, 153, 0.05); border: 1px solid rgba(123, 191, 153, 0.2); border-radius: 6px; padding: 4px; pointer-events: none; user-select: none; position: relative; overflow: hidden; display: flex; align-items: center; justify-content: center;">
          <svg viewBox="0 0 100 40" preserveAspectRatio="none" style="width: 100%; height: 80%; overflow: visible; opacity: 0.8;">
            <line x1="0" y1="20" x2="100" y2="20" stroke="#7bbf99" stroke-width="0.5" stroke-dasharray="2,2" opacity="0.4" />
            <line x1="0" y1="40" x2="100" y2="40" stroke="#7bbf99" stroke-width="0.5" stroke-dasharray="2,2" opacity="0.4" />
            <polyline points="0,35 20,25 40,28 60,15 80,18 100,5" fill="none" stroke="#7bbf99" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" />
            <circle cx="100" cy="5" r="3" fill="#7bbf99" />
          </svg>
        </div>
        <div style="font-size: 0.85rem; color: var(--color-text-secondary); line-height: 1.6;">
          Review supporting evidence and deploy system-generated <strong>tactical directives</strong> to optimize retention performance.
        </div>
      </div>
    </div>
  </div>
</details>

<div class="menu-health">
  <div class="menu-health-head">
    <div class="menu-health-label">Executive Indicator Surveillance</div>
    <div class="menu-health-badges">
      <span class="menu-health-badge safe">✓ {safeCount} healthy</span>
      <span class="menu-health-badge warn">! {warnCount} warning</span>
      <span class="menu-health-badge critical">x {criticalCount} critical</span>
    </div>
  </div>
  <div class="menu-health-list">
    <a href="/07-employee-performance/02-tactical-action#disiplin" style="text-decoration: none; color: inherit;">
      <div class="menu-health-row {lateState}">
        <div class="menu-health-icon">{lateState === 'safe' ? '✅' : lateState === 'warn' ? '⚠️' : '🚨'}</div>
        <div style="width: 100%;">
          <span class="menu-health-title">Disciplinary Compliance Variance</span> 
          <span class="menu-health-copy">- <span class="menu-health-value">{problemEmployees} staff flagged for critical disciplinary deviations.</span> Mandatory 1-on-1 performance coaching or formal HR documentation required.</span>
        </div>
      </div>
    </a>
    <a href="/07-employee-performance/02-tactical-action#burnout" style="text-decoration: none; color: inherit;">
      <div class="menu-health-row {overtimeState}">
        <div class="menu-health-icon">{overtimeState === 'safe' ? '✅' : overtimeState === 'warn' ? '⚠️' : '🚨'}</div>
        <div style="width: 100%;">
          <span class="menu-health-title">Workforce Burnout & Fatigue Risk</span> 
          <span class="menu-health-copy">- <span class="menu-health-value">{burnoutEmployees} staff operating at critical overtime thresholds (>10 hours).</span> Immediate shift roster optimization recommended to mitigate attrition risk.</span>
        </div>
      </div>
    </a>
  </div>
</div>

<details class="guide-acc" style="margin-top: 16px; margin-bottom: 24px;">
  <summary>💡 Methodological Context: Discipline & Overtime Benchmarking</summary>
  <div class="guide-body" style="padding: 16px;">
    <p style="margin-top: 4px; margin-bottom: 16px; font-weight: 500; color: var(--color-text-secondary);">
      These metrics serve as leading indicators for structural labor inefficiencies that degrade FOH service velocity and inflate operational payroll expenses.
    </p>
    <div class="guide-grid" style="grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 16px;">
      <div class="guide-card blue">
        <div class="guide-card-icon">📉</div>
        <div class="guide-card-content">
          <div class="guide-card-label">Tardiness & Absenteeism</div>
          <h4 class="guide-card-title">Service Velocity Degradation</h4>
          <p class="guide-card-desc">A single 15-minute tardiness incident during peak throughput windows initiates compounding queue delays, severely impacting guest satisfaction (CSAT) scores.</p>
        </div>
      </div>
      <div class="guide-card purple">
        <div class="guide-card-icon">🥵</div>
        <div class="guide-card-content">
          <div class="guide-card-label">Sustained Overtime</div>
          <h4 class="guide-card-title">Burnout & Error Propagation</h4>
          <p class="guide-card-desc">While overtime temporarily subsidizes staffing deficits, sustained deployment degrades cognitive focus, precipitating high-margin human errors (voids, comps, and misfires).</p>
        </div>
      </div>
    </div>
  </div>
</details>

<div style="margin-bottom: 16px; display: flex; align-items: center; gap: 10px; margin-top: 48px; padding-top: 32px; border-top: 2px dashed rgba(0,0,0,0.06);">
  <div style="font-size: 1.5rem;">🔭</div>
  <div>
    <h2 style="margin: 0; font-size: 1.25rem; font-weight: 800; color: var(--color-text-primary); letter-spacing: -0.02em;">STRATEGIC HEALTH METRICS</h2>
    <div style="font-size: 0.85rem; color: var(--color-text-tertiary); font-weight: 500;">Macro-level evaluation of labor efficiency and organizational workforce policies.</div>
  </div>
</div>



<div class="kpi-grid-2" style="margin-bottom: 12px;">
  <div class="kpi-card margin">
    <div class="kpi-label">🚨 Critical Shift Risk</div>
    <div class="kpi-value">{pressureShift}</div>
    <div class="kpi-prev" style="margin-top: 12px;">Daypart exhibiting peak disciplinary variance.</div>
  </div>
  <div class="kpi-card margin">
    <div class="kpi-label">🏢 Vulnerable Location</div>
    <div class="kpi-value">{pressureBranch}</div>
    <div class="kpi-prev" style="margin-top: 12px;">Operating unit with highest acute labor deficits.</div>
  </div>
</div>
<div class="kpi-grid" style="margin-bottom: 24px;">
  <div class="kpi-card revenue">
    <div class="kpi-label">💰 Labor Productivity (RPH)</div>
    <div class="kpi-value">Rp {usFormat(revPerHour)}</div>
    <div class="kpi-prev" style="margin-top: 12px;">Aggregate revenue generated per scheduled labor hour.</div>
  </div>
  <div class="kpi-card expense">
    <div class="kpi-label">🕒 Overtime Dependence</div>
    <div class="kpi-value">{usFormat(overtimePct, 1)}%</div>
    <div class="kpi-prev" style="margin-top: 12px;">Percentage of total operational coverage reliant on OT.</div>
  </div>
  <div class="kpi-card expense">
    <div class="kpi-label">📉 Compliance Variance</div>
    <div class="kpi-value">{usFormat(latePct, 1)}%</div>
    <div class="kpi-prev" style="margin-top: 12px;">Aggregate ratio of schedule violations to total shifts.</div>
  </div>
</div>

<div class="clean-cta-banner">
  <div class="clean-cta-content">
    <div class="clean-cta-icon">🔍</div>
    <div class="clean-cta-text">
      <h3 class="clean-cta-title">Macro Analytics</h3>
      <p class="clean-cta-desc">Dissect labor utilization effectiveness, track compliance trends, and identify scalable scheduling optimization strategies.</p>
    </div>
  </div>
  <a href="/07-employee-performance/03-analysis" class="clean-cta-button">
    Access Strategic Evaluation ➔
  </a>
</div>

{:else}
  <GlobalLoading />
{/if}

<style>
.loading-overlay {
  position: fixed;
  top: 0; left: 0; right: 0; bottom: 0;
  background: var(--color-background-primary, #ffffff);
  z-index: 9999;
  display: flex;
  align-items: center;
  justify-content: center;
}
@keyframes pulseLoader {
  0% { transform: scale(0.95); box-shadow: 0 0 0 0 rgba(13, 148, 136, 0.4); }
  70% { transform: scale(1); box-shadow: 0 0 0 15px rgba(13, 148, 136, 0); }
  100% { transform: scale(0.95); box-shadow: 0 0 0 0 rgba(13, 148, 136, 0); }
}
@keyframes fadeIn {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}
.loader-pulse {
  width: 44px;
  height: 44px;
  border-radius: 50%;
  background: linear-gradient(135deg, #0f766e, #14b8a6);
  animation: pulseLoader 1.5s infinite;
}

.clean-cta-banner {
  margin-top: 32px;
  margin-bottom: 40px;
  padding: 24px 28px;
  border-radius: 16px;
  background: rgba(13, 148, 136, 0.03);
  border: 1px solid rgba(13, 148, 136, 0.15);
  display: flex;
  align-items: center;
  justify-content: space-between;
  box-shadow: 0 4px 12px rgba(13, 148, 136, 0.03);
  transition: all 0.3s ease;
}

.clean-cta-banner:hover {
  background: rgba(13, 148, 136, 0.05);
  border-color: rgba(13, 148, 136, 0.25);
  box-shadow: 0 8px 24px rgba(13, 148, 136, 0.06);
}

.clean-cta-content {
  display: flex;
  align-items: center;
  gap: 20px;
}

.clean-cta-icon {
  font-size: 2.2rem;
  line-height: 1;
  filter: drop-shadow(0 2px 4px rgba(13, 148, 136, 0.15));
}

.clean-cta-title {
  margin: 0 0 4px 0;
  font-size: 1.1rem;
  font-weight: 800;
  letter-spacing: -0.01em;
  color: #0f766e;
}

.clean-cta-desc {
  margin: 0;
  font-size: 0.88rem;
  color: var(--color-text-secondary);
  font-weight: 400;
  max-width: 65ch;
  line-height: 1.6;
}

.clean-cta-button {
  background: white !important;
  border: 1px solid rgba(13, 148, 136, 0.3) !important;
  color: #0d9488 !important;
  font-weight: 800 !important;
  font-size: 0.9rem !important;
  padding: 12px 20px !important;
  border-radius: 8px !important;
  text-decoration: none !important;
  display: inline-flex !important;
  align-items: center !important;
  justify-content: center !important;
  transition: all 0.2s ease !important;
  box-shadow: 0 2px 6px rgba(13, 148, 136, 0.06) !important;
  line-height: 1 !important;
  margin: 0 !important;
  white-space: nowrap !important;
}

.clean-cta-button:hover {
  background: #f0fdfa !important; /* light teal background */
  color: #0f766e !important;
  border-color: #0d9488 !important;
  transform: translateY(-1px) !important;
  box-shadow: 0 4px 12px rgba(13, 148, 136, 0.1) !important;
}

.premium-cta-button:hover .arrow {
  transform: translateX(5px) !important;
}
.interactive-card {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -1px rgba(0, 0, 0, 0.03);
}
.interactive-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 12px 20px -5px rgba(0, 0, 0, 0.1), 0 8px 10px -5px rgba(0, 0, 0, 0.04);
}

.hero { display: flex; flex-direction: column; gap: 16px; margin-top: 10px; }
.section-card { padding: 16px; border-radius: 16px; border: 1px solid var(--color-border-tertiary); background: var(--color-background-secondary); }
.strategic-title { margin: 0 0 10px; font-size: 1.5rem; line-height: 1.1; letter-spacing: -0.035em; color: var(--color-text-primary); }
.section-eyebrow { font-size: 10px; font-weight: 700; letter-spacing: 0.12em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 6px; display: flex; align-items: center; gap: 6px; }
.section-head.tight { margin-bottom: 12px; }

/* ── Hero CSS ── */
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

.hero-main-card.status-sehat .hero-stat-number { color: #15803d; }
.hero-main-card.status-waspada .hero-stat-number { color: #b45309; }
.hero-main-card.status-kritis .hero-stat-number { color: #b91c1c; }

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

/* ── Menu Health CSS ── */
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
.menu-health-row.special { background: rgba(2,132,199,0.045); border-color: rgba(2,132,199,0.14); }
.menu-health-icon { width: 18px; flex: 0 0 18px; margin-top: 1px; font-size: 14px; line-height: 1.2; text-align: center; }
.menu-health-title { font-weight: 850; color: var(--color-text-primary); }
.menu-health-copy { color: var(--color-text-secondary); }
.menu-health-value { font-weight: 850; color: var(--color-text-primary); }

/* ── KPI Grid ── */
.trend-indicator { font-size: 0.82rem; font-weight: 700; display: inline-flex; align-items: center; gap: 3px; }
.trend-indicator.up { color: #16a34a; }
.trend-indicator.down { color: #dc2626; }
.trend-indicator.neutral { color: var(--color-text-tertiary); }

.kpi-grid { display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 12px; }
.kpi-grid-2 { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 12px; }
.kpi-card { padding: 18px 16px; border-radius: 18px; border: 1.5px solid var(--color-border-tertiary); background: var(--color-background-secondary); box-shadow: 0 4px 10px rgba(0, 0, 0, 0.02), 0 1px 3px rgba(0, 0, 0, 0.01); transition: all 0.22s ease; text-align: center; }
.kpi-card:hover { transform: translateY(-2px); box-shadow: 0 8px 16px rgba(0, 0, 0, 0.04), 0 2px 4px rgba(0, 0, 0, 0.02); }
.kpi-label { font-size: 10px; font-weight: 700; letter-spacing: 0.1em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 8px; display: flex; align-items: center; justify-content: center; gap: 5px; }
.kpi-value { font-size: 1.15rem; font-weight: 800; letter-spacing: -0.03em; color: var(--color-text-primary); }
.kpi-meta { margin-top: 6px; font-size: 0.82rem; line-height: 1; }
.kpi-prev { margin-top: 6px; font-size: 0.78rem; color: var(--color-text-secondary); line-height: 1.4; }
.kpi-card.revenue { border-color: rgba(37,99,235,0.18); background: linear-gradient(145deg, rgba(37,99,235,0.06), rgba(99,102,241,0.03)); }
.kpi-card.net { border-color: rgba(16,185,129,0.22); background: linear-gradient(145deg, rgba(16,185,129,0.07), rgba(22,163,74,0.03)); }
.kpi-card.margin { border-color: rgba(245,158,11,0.22); background: linear-gradient(145deg, rgba(245,158,11,0.07), rgba(251,191,36,0.03)); }
.kpi-card.expense { border-color: rgba(239,68,68,0.18); background: linear-gradient(145deg, rgba(239,68,68,0.06), rgba(220,38,38,0.02)); }

.diagnostics-stack { display: flex; flex-direction: column; gap: 16px; margin-top: 14px; }
.diagnostics-header { padding: 0 2px; margin-bottom: 2px; }
.diagnostics-eyebrow { font-size: 10px; font-weight: 700; letter-spacing: 0.12em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 6px; display: flex; align-items: center; gap: 6px; }
.diagnostics-title { font-size: 1.3rem; font-weight: 800; letter-spacing: -0.025em; color: var(--color-text-primary); margin: 0 0 4px; }
.diagnostics-copy { font-size: 0.9rem; line-height: 1.7; color: var(--color-text-secondary); max-width: 68ch; margin: 0; }

/* ── Signal grid ── */
.signal-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 14px;
}

.signal-card {
  padding: 18px;
  border-radius: 16px;
  border: 1px solid var(--color-border-tertiary);
  background: var(--color-background-secondary);
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
}

.signal-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.04), 0 2px 4px rgba(0, 0, 0, 0.02);
}

.signal-card.safe {
  border-color: rgba(22, 163, 74, 0.25);
  background: linear-gradient(135deg, rgba(22,163,74,0.08), rgba(16,185,129,0.03));
}

.signal-card.warn {
  border-color: rgba(245, 158, 11, 0.3);
  background: linear-gradient(135deg, rgba(245,158,11,0.09), rgba(251,191,36,0.03));
}

.signal-card.critical {
  border-color: rgba(239, 68, 68, 0.25);
  background: linear-gradient(135deg, rgba(239,68,68,0.09), rgba(220,38,38,0.03));
}

.signal-card.neutral {
  border-color: rgba(99, 102, 241, 0.2);
  background: linear-gradient(135deg, rgba(99,102,241,0.07), rgba(139,92,246,0.03));
}

.signal-label {
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 0.09em;
  text-transform: uppercase;
  color: var(--color-text-tertiary);
  margin-bottom: 6px;
  display: flex;
  align-items: center;
  gap: 5px;
}

.signal-title {
  font-size: 1rem;
  font-weight: 800;
  letter-spacing: -0.02em;
  color: var(--color-text-primary);
  margin-bottom: 6px;
}

.signal-copy {
  font-size: 0.9rem;
  line-height: 1.7;
  color: var(--color-text-secondary);
}
</style>
