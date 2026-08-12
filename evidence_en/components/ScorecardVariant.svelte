<script>
  export let empData;
  export let startDateStr;
  export let endDateStr;
  export let avgOthersRevenuePerShift;
  export let avgOthersOvertime;
  export let theme = 'apple'; 
</script>

<div class="unified-card theme-apple">
  <div class="section-head" style="padding: 24px 24px 0 24px; margin-bottom: 0;">
    <div class="section-eyebrow" style="font-size: 12px; font-weight: 700; letter-spacing: 0.11em; text-transform: uppercase; color: var(--color-text-primary, #0f172a); margin-bottom: 4px; display: flex; align-items: center; gap: 5px;">
      <span>👤 Profile & Performance</span>
    </div>
    <h3 class="section-title" style="margin: 0; font-size: 1.15rem; font-weight: 800; letter-spacing: -0.02em; color: var(--color-text-primary, #0f172a);">Individual Performance Report</h3>
    <p class="section-copy" style="margin: 4px 0 0; font-size: 0.87rem; line-height: 1.7; color: var(--color-text-secondary, #0f172a);">
      Summary of performance and discipline of the selected individual over the last 30 days ({startDateStr} &mdash; {endDateStr}).
    </p>
  </div>
  
  <div class="unified-body">
    <!-- Left: ID Card Profile -->
    <div class="id-card">
      <div class="id-card-header" style="background: linear-gradient(135deg, #cbd5e1, #94a3b8);"></div>
      <div class="id-avatar">
        {empData.employee_name.substring(0,2).toUpperCase()}
      </div>
      <h3 class="id-name">{empData.employee_name}</h3>
      <div class="id-role">{empData.role}</div>
      <div class="id-branch">📍 {empData.home_branch}</div>
      
      <div class="id-stats-mini">
        <div class="id-stat-box">
          <div class="id-stat-val">{empData.total_shifts}</div>
          <div class="id-stat-lbl">Active Shifts</div>
        </div>
        <div class="id-stat-box">
          <div class="id-stat-val">~{Math.round(empData.avgOrders)}</div>
          <div class="id-stat-lbl">Orders/Shift</div>
        </div>
      </div>
    </div>

    <!-- Right: Detailed Metrics Stack -->
    <div class="metrics-stack">
      <div class="kpi-card revenue">
        <div class="kpi-label">💰 Average Revenue / Shift</div>
        <div class="kpi-value">Rp {Number(Math.round(empData.avgRevenue)).toLocaleString('id-ID')}</div>
        <div class="kpi-prev" style="display: flex; align-items: center; justify-content: center; gap: 6px;">
          <span style="background: {empData.deltaRevColor}20; color: {empData.deltaRevColor}; padding: 2px 6px; border-radius: 4px; font-weight: 800;">
            {empData.deltaRevIcon} {Math.abs(empData.deltaRevPct).toFixed(1)}%
          </span>
          <span class="compare-txt">vs average (Rp {Number(Math.round(avgOthersRevenuePerShift)).toLocaleString('id-ID')})</span>
        </div>
      </div>
      <div class="kpi-card price">
        <div class="kpi-label">⏰ Total Overtime (30 Days)</div>
        <div class="kpi-value">{empData.total_overtime} <span style="font-size:1rem;">Hours</span></div>
        <div class="kpi-prev" style="display: flex; align-items: center; justify-content: center; gap: 6px;">
          <span style="background: {empData.deltaOtColor}20; color: {empData.deltaOtColor}; padding: 2px 6px; border-radius: 4px; font-weight: 800;">
            {empData.deltaOtIcon} {Math.abs(empData.deltaOt).toFixed(1)} Hours
          </span>
          <span class="compare-txt">vs average ({avgOthersOvertime.toFixed(1)} Hours)</span>
        </div>
      </div>
      <div class="kpi-card cost">
        <div class="kpi-label">🏃 Discipline Rate</div>
        <div class="kpi-value">{empData.disciplineRate.toFixed(1)}<span style="font-size:1rem;">%</span></div>
        <div class="kpi-prev" style="margin-top: 12px; display: flex; flex-direction: column; align-items: center; gap: 6px;">
          <div class="prog-bg" style="width: 100%; height: 6px; border-radius: 4px; overflow: hidden; background: #e2e8f0;">
            <div class="prog-bar" style="width: {empData.disciplineRate}%; height: 100%; background: {empData.disciplineRate >= 92 ? '#10b981' : (empData.disciplineRate >= 85 ? '#f59e0b' : '#ef4444')};"></div>
          </div>
          <span class="compare-txt">{empData.total_absen}x Absent, {empData.total_late}x Late</span>
        </div>
      </div>
    </div>
  </div>
</div>

<style>
/* Base Shared CSS */
.unified-card {
  border-radius: 16px;
  margin-bottom: 32px;
  overflow: hidden;
  transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
}
.unified-body { padding: 24px; display: grid; grid-template-columns: 320px 1fr; gap: 24px; }
@media (max-width: 900px) { .unified-body { grid-template-columns: 1fr; } }

.id-card { display: flex; flex-direction: column; align-items: center; position: relative; transition: all 0.3s ease; }
.id-card-header { width: 100%; height: 80px; }
.id-avatar { width: 90px; height: 90px; border-radius: 50%; margin-top: -45px; display: flex; align-items: center; justify-content: center; font-size: 2.2rem; font-weight: 900; z-index: 2; margin-bottom: 12px; }
.id-name { margin: 0 0 4px 0; font-size: 1.4rem; font-weight: 800; text-align: center; padding: 0 16px; }
.id-role { font-size: 0.95rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 8px; }
.id-branch { font-size: 0.9rem; padding: 4px 12px; border-radius: 12px; margin-bottom: 24px; font-weight: 500; }
.id-stats-mini { display: flex; width: 100%; }
.id-stat-box { flex: 1; padding: 16px; text-align: center; }
.id-stat-val { font-size: 1.3rem; font-weight: 800; }
.id-stat-lbl { font-size: 0.75rem; font-weight: 600; text-transform: uppercase; margin-top: 4px; }

.metrics-stack { display: flex; flex-direction: column; gap: 16px; justify-content: space-between; }

/* THEME: Apple 3D Base (For Main Card) */
.theme-apple { 
  background: transparent; 
  border: 1.5px solid var(--color-border-primary, rgba(99, 102, 241, 0.18)); 
  box-shadow: none; 
  color: var(--color-text-primary, #0f172a); 
}
.theme-apple .id-card { background: var(--color-background-secondary, linear-gradient(145deg, #ffffff, #f8fafc)); border: 1px solid var(--color-border-primary, white); border-radius: 16px; box-shadow: none; }
.theme-apple .id-card:hover { transform: scale(1.01) translateY(-2px); box-shadow: 0 15px 30px rgba(0,0,0,0.08); }
.theme-apple .id-name { color: var(--color-text-primary, #0f172a); }
.theme-apple .id-role { color: var(--color-text-secondary, #64748b); }
.theme-apple .id-avatar { background: var(--color-background-secondary, white); border: 4px solid var(--color-border-primary, white); color: var(--color-text-primary, #3b82f6); box-shadow: none; }
.theme-apple .id-stats-mini { background: transparent; border-top: 1px solid var(--color-border-primary, rgba(0,0,0,0.05)); }
.theme-apple .id-stat-val { color: var(--color-text-primary, #0f172a); }
.theme-apple .id-stat-lbl { color: var(--color-text-secondary, #64748b); }
.theme-apple .id-stat-box:first-child { border-right: 1px solid var(--color-border-primary, rgba(0,0,0,0.05)); }
.theme-apple .id-branch { background: var(--color-background-secondary, #f1f5f9); color: var(--color-text-primary, #475569); }

/* KPI CARD STYLES (Copied exactly from Menu Deepdive pergerakan.md) */
.kpi-card {
  padding: 18px 16px; border-radius: 18px; text-align: center;
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.02), 0 1px 3px rgba(0, 0, 0, 0.01);
  position: relative; overflow: hidden; transition: all 0.22s ease;
  flex-grow: 1;
}
.kpi-card:hover { transform: translateY(-2px); box-shadow: 0 8px 16px rgba(0, 0, 0, 0.04), 0 2px 4px rgba(0, 0, 0, 0.02); }

/* Colorful Pastel Cards */
.kpi-card.revenue { border-color: rgba(37, 99, 235, 0.22); background: linear-gradient(145deg, rgba(37,99,235,0.06), rgba(99,102,241,0.03)); }
.kpi-card.revenue .kpi-label { color: #2563eb; }

.kpi-card.price { border-color: rgba(245, 158, 11, 0.22); background: linear-gradient(145deg, rgba(245,158,11,0.07), rgba(251,191,36,0.03)); }
.kpi-card.price .kpi-label { color: #d97706; }

.kpi-card.cost { border-color: rgba(220, 38, 38, 0.22); background: linear-gradient(145deg, rgba(239,68,68,0.07), rgba(220,38,38,0.03)); }
.kpi-card.cost .kpi-label { color: #dc2626; }

.kpi-label { font-size: 11px; font-weight: 800; letter-spacing: 0.05em; text-transform: uppercase; margin-bottom: 8px; text-align: center !important; display: flex; justify-content: center; align-items: center; gap: 4px; }
.kpi-value { font-size: 1.6rem; font-weight: 800; letter-spacing: -0.02em; color: var(--color-text-primary, #0f172a); }
.kpi-prev { margin-top: 8px; font-size: 0.78rem; line-height: 1.5; color: var(--color-text-secondary, #64748b); }
.compare-txt { color: var(--color-text-secondary, #64748b); }
</style>
