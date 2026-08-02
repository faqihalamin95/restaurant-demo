---
sidebar: hide
title: Performa Pegawai
---
<EmployeeTabs activeTab="direktori" />

```sql top_sales
SELECT 
    employee_name, 
    MAX(role) as role, 
    MAX(branch_name) as branch_name, 
    SUM(total_revenue) as val
FROM restaurant.employee_shift_performance
WHERE attendance_date >= (SELECT MAX(attendance_date) - INTERVAL 30 DAY FROM restaurant.employee_shift_performance)
GROUP BY employee_name
ORDER BY val DESC 
LIMIT 5
```

```sql top_overtime
SELECT 
    employee_name, 
    MAX(role) as role, 
    MAX(branch_name) as branch_name, 
    SUM(overtime_hours) as val
FROM restaurant.employee_shift_performance
WHERE attendance_date >= (SELECT MAX(attendance_date) - INTERVAL 30 DAY FROM restaurant.employee_shift_performance)
GROUP BY employee_name
HAVING SUM(overtime_hours) > 0
ORDER BY val DESC 
LIMIT 5
```

<!-- LEADERBOARDS SECTION -->
<div class="diagnostics-header" style="margin-top: 24px; margin-bottom: 24px;">
  <div class="diagnostics-eyebrow">🏆 LEADERBOARDS</div>
  <h2 class="diagnostics-title">Peringkat Staf (Top 5)</h2>
  <p class="diagnostics-copy">Sorotan karyawan terbaik berdasarkan pencetakan omzet tertinggi, serta daftar staf dengan akumulasi beban lembur paling rawan.</p>
</div>

<div class="leaderboards-container">
  <!-- Top Sales -->
  <div class="lb-panel">
    <div class="lb-header green">
      <div class="lb-header-icon">👑</div>
      <div>
        <h3 class="lb-title">Top Omzet</h3>
        <p class="lb-desc">Pencetak penjualan terbanyak.</p>
      </div>
    </div>
    <div class="lb-body">
      {#each top_sales as row, i}
        <div class="lb-row">
          <div class="lb-rank">#{i + 1}</div>
          <div class="lb-info">
            <div class="lb-name">{row.employee_name}</div>
            <div class="lb-meta">{row.role} • {row.branch_name}</div>
          </div>
          <div class="lb-score green-text">Rp {(row.val / 1000000).toFixed(1)}M</div>
        </div>
      {/each}
    </div>
  </div>

  <!-- Top Overtime (Burnout Risk) -->
  <div class="lb-panel">
    <div class="lb-header red">
      <div class="lb-header-icon">🔥</div>
      <div>
        <h3 class="lb-title">Risiko Burnout</h3>
        <p class="lb-desc">Akumulasi lembur tertinggi.</p>
      </div>
    </div>
    <div class="lb-body">
      {#each top_overtime as row, i}
        <div class="lb-row">
          <div class="lb-rank">#{i + 1}</div>
          <div class="lb-info">
            <div class="lb-name">{row.employee_name}</div>
            <div class="lb-meta">{row.role} • {row.branch_name}</div>
          </div>
          <div class="lb-score red-text">{row.val} Jam</div>
        </div>
      {/each}
    </div>
  </div>
</div>

<hr style="margin: 48px 0; border: 0; border-top: 1px dashed rgba(0,0,0,0.15);" />

```sql master_roster
SELECT 
    employee_name as "Nama Pegawai",
    MAX(role) as "Peran",
    MAX(branch_name) as "Cabang Utama",
    COUNT(*) as "Total Shift",
    SUM(overtime_hours) as "Total Lembur (Jam)",
    SUM(CASE WHEN attendance_status IN ('late', 'absent', 'leave') THEN 1 ELSE 0 END) as "Kasus Disiplin",
    SUM(base_salary) as "Gaji Pokok (Rp)",
    SUM(total_revenue) as "Total Omzet (Rp)"
FROM restaurant.employee_shift_performance
WHERE attendance_date >= (SELECT MAX(attendance_date) - INTERVAL 30 DAY FROM restaurant.employee_shift_performance)
GROUP BY employee_name
ORDER BY "Total Omzet (Rp)" DESC
```

<!-- MASTER ROSTER -->
<div class="diagnostics-header" style="margin-bottom: 24px;">
  <div class="diagnostics-eyebrow">📋 DATABASE KARYAWAN</div>
  <h2 class="diagnostics-title">Master Roster HRD</h2>
  <p class="diagnostics-copy">Tabel agregasi seluruh karyawan yang aktif, merangkum total shift, pelanggaran disiplin, dan performa finansial secara keseluruhan.</p>
</div>

<div style="background: white; border-radius: 16px; border: 1px solid #e2e8f0; padding: 20px; box-shadow: 0 4px 6px rgba(0,0,0,0.02); margin-bottom: 64px;">
  <DataTable data={master_roster} search="true" rows=15 download="true">
    <Column id="Nama Pegawai" />
    <Column id="Peran" />
    <Column id="Cabang Utama" />
    <Column id="Total Shift" align="center" />
    <Column id="Total Lembur (Jam)" align="center" />
    <Column id="Kasus Disiplin" align="center" />
    <Column id="Gaji Pokok (Rp)" align="right" fmt="#,##0" />
    <Column id="Total Omzet (Rp)" align="right" fmt="#,##0" />
  </DataTable>
</div>

<hr style="margin: 48px 0; border: 0; border-top: 1px dashed rgba(0,0,0,0.15);" />

<!-- Page Header -->
<div class="diagnostics-header" style="margin-top: 24px; margin-bottom: 32px;">
  <div class="diagnostics-eyebrow">🗂️ DIREKTORI DATA & BUKU RAPOR</div>
  <h2 class="diagnostics-title">Profil & Evaluasi Kinerja Karyawan</h2>
  <p class="diagnostics-copy">Akses rapor individu setiap karyawan secara instan. Menampilkan agregasi data performa, kedisiplinan, dan peringkat karyawan untuk periode <strong>30 Hari Terakhir</strong>.</p>
</div>

```sql employee_list
SELECT DISTINCT 
    employee_name as value, 
    employee_name as label
FROM restaurant.employee_shift_performance 
WHERE attendance_date >= (SELECT MAX(attendance_date) - INTERVAL 30 DAY FROM restaurant.employee_shift_performance)
ORDER BY employee_name
```

<!-- EMPLOYEE SELECTOR -->
<div class="profile-selector-container" style="background: linear-gradient(145deg, #ffffff, #f8fafc); border: 1px solid #e2e8f0; border-radius: 12px; padding: 16px 24px; display: flex; align-items: center; gap: 20px; margin-bottom: 24px; box-shadow: 0 4px 12px rgba(0,0,0,0.03);">
  <div class="selector-label" style="display: flex; align-items: center; gap: 10px;">
    <span style="font-size: 1.1rem; background: #f1f5f9; padding: 8px; border-radius: 8px;">🔍</span>
    <strong style="color: #0f172a; font-size: 0.95rem; text-transform: uppercase; letter-spacing: 0.05em;">Cari Buku Rapor:</strong>
  </div>
  <div style="flex-grow: 1; max-width: 320px;">
    <Dropdown name="emp_filter" data={employee_list} />
  </div>
  <div style="font-size: 0.85rem; color: #64748b; font-style: italic;">
    *Pilih nama karyawan untuk melihat rapor kinerjanya.
  </div>
</div>

```sql emp_stats
SELECT 
    employee_name,
    MAX(role) as role,
    MAX(branch_name) as home_branch,
    COUNT(*) as total_shifts,
    SUM(overtime_hours) as total_overtime,
    SUM(CASE WHEN attendance_status IN ('absent', 'leave') THEN 1 ELSE 0 END) as total_absen,
    SUM(CASE WHEN attendance_status = 'late' THEN 1 ELSE 0 END) as total_late,
    SUM(total_revenue) as generated_revenue,
    SUM(orders_handled) as total_orders
FROM restaurant.employee_shift_performance
WHERE attendance_date >= (SELECT MAX(attendance_date) - INTERVAL 30 DAY FROM restaurant.employee_shift_performance)
GROUP BY employee_name
ORDER BY employee_name ASC
```

```sql emp_history
SELECT 
    employee_name,
    attendance_date as "Tanggal",
    branch_name as "Cabang",
    shift_name as "Shift",
    CASE attendance_status
        WHEN 'present' THEN '✅ Hadir'
        WHEN 'late' THEN '🏃 Terlambat'
        WHEN 'absent' THEN '🪑 Absen'
        WHEN 'leave' THEN '⛱️ Cuti'
    END as "Status",
    overtime_hours as "Lembur",
    orders_handled as "Pesanan",
    total_revenue as "Omzet"
FROM restaurant.employee_shift_performance
WHERE attendance_date >= (SELECT MAX(attendance_date) - INTERVAL 30 DAY FROM restaurant.employee_shift_performance)
ORDER BY attendance_date DESC
```

<script>
  // Robust fallback: if Dropdown fails to output a string, fallback to the first employee
  $: dropdownValue = inputs.emp_filter;
  $: selectedEmpName = typeof dropdownValue === 'string' && dropdownValue.trim() !== '' 
      ? dropdownValue 
      : (dropdownValue?.value || (emp_stats && emp_stats.length > 0 ? emp_stats[0].employee_name : null));
      
  // Comparison Metrics Calculation
  $: otherEmpStats = emp_stats ? emp_stats.filter(e => e.employee_name !== selectedEmpName) : [];
  $: otherEmpCount = otherEmpStats.length || 1;
  $: avgOthersOvertime = otherEmpStats.reduce((sum, e) => sum + e.total_overtime, 0) / otherEmpCount;
  $: totalOthersRevenue = otherEmpStats.reduce((sum, e) => sum + e.generated_revenue, 0);
  $: totalOthersShifts = otherEmpStats.reduce((sum, e) => sum + e.total_shifts, 0) || 1;
  $: avgOthersRevenuePerShift = totalOthersRevenue / totalOthersShifts;

  $: activeEmpStats = emp_stats ? emp_stats.filter(e => e.employee_name === selectedEmpName).map(e => {
      const avgRevenue = e.generated_revenue / e.total_shifts;
      const avgOrders = e.total_orders / e.total_shifts;
      const weighted_cases = e.total_absen + (e.total_late * 0.5);
      const disciplineRate = 100 - ((weighted_cases / e.total_shifts) * 100);
      const avgOvertime = e.total_overtime / e.total_shifts;
      
      // Delta calculations
      const deltaRev = avgRevenue - avgOthersRevenuePerShift;
      const deltaRevPct = (deltaRev / avgOthersRevenuePerShift) * 100;
      const isRevUp = deltaRev >= 0;
      const deltaRevColor = isRevUp ? '#10b981' : '#ef4444';
      const deltaRevIcon = isRevUp ? '▲' : '▼';

      const deltaOt = e.total_overtime - avgOthersOvertime;
      const isOtUp = deltaOt >= 0;
      const deltaOtColor = isOtUp ? '#ef4444' : '#10b981'; // Overtime higher = bad (red), lower = good (green)
      const deltaOtIcon = isOtUp ? '▲' : '▼';

      return {
          ...e,
          avgRevenue,
          avgOrders,
          disciplineRate,
          avgOvertime,
          deltaRevPct,
          deltaRevColor,
          deltaRevIcon,
          deltaOt,
          deltaOtColor,
          deltaOtIcon
      };
  }) : [];
  
  // Generate True 30-Day Calendar Array & Date Strings
  $: maxDateObj = emp_history && emp_history.length > 0 && emp_history[0].Tanggal ? new Date(emp_history[0].Tanggal) : new Date();
  
  const monthNames = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
  $: endDateStr = maxDateObj.getDate() + ' ' + monthNames[maxDateObj.getMonth()] + ' ' + maxDateObj.getFullYear();
  $: startDateObj = new Date(maxDateObj.getTime() - (29 * 24 * 60 * 60 * 1000));
  $: startDateStr = startDateObj.getDate() + ' ' + monthNames[startDateObj.getMonth()] + ' ' + startDateObj.getFullYear();

  $: activeEmpHistoryFull = emp_history ? emp_history.filter(h => h.employee_name === selectedEmpName).map(h => {
      let dateObj = new Date(h.Tanggal);
      let tglStr = String(dateObj.getDate()).padStart(2, '0') + ' ' + monthNames[dateObj.getMonth()].substring(0,3) + ' ' + String(dateObj.getFullYear()).substring(2);
      
      let isAbsent = h.Status === '🪑 Absen' || h.Status === '⛱️ Cuti';
      
      return {
          ...h,
          Tanggal_Fmt: tglStr,
          Pesanan_Real: isAbsent ? null : h.Pesanan,
          Omzet_Real: isAbsent ? null : h.Omzet,
          Lembur_Real: (isAbsent || h.Lembur === 0) ? null : h.Lembur
      };
  }) : [];
  
  // Generate True 30-Day Calendar Array & Date Strings

  $: activeCalendar = Array.from({length: 30}, (_, i) => {
      let d = new Date(maxDateObj);
      d.setDate(d.getDate() - (29 - i));
      
      let dateString = d.getFullYear() + '-' + String(d.getMonth()+1).padStart(2,'0') + '-' + String(d.getDate()).padStart(2,'0');
      const dayNames = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];
      let dayName = dayNames[d.getDay()];
      let dateNum = d.getDate();
      
      // Match with employee shift history
      const shift = activeEmpHistoryFull.find(s => {
          if (!s.Tanggal) return false;
          let sd = new Date(s.Tanggal);
          let sdString = sd.getFullYear() + '-' + String(sd.getMonth()+1).padStart(2,'0') + '-' + String(sd.getDate()).padStart(2,'0');
          return sdString === dateString;
      });
      
      let color = '#10b981'; 
      let label = 'Tepat Waktu';
      let bgColor = 'white';

      if (!shift) {
          color = '#94a3b8'; 
          label = 'Libur / Tidak Ada Shift';
          bgColor = '#f8fafc';
      }
      else if (shift.Status === '🪑 Absen' || shift.Status === '⛱️ Cuti') { color = '#ef4444'; label = shift.Status; }
      else if (shift.Status === '🏃 Terlambat') { color = '#f59e0b'; label = 'Terlambat'; }
      else if (shift.Lembur > 0) { color = '#8b5cf6'; label = `Lembur ${shift.Lembur}j`; }
      
      return { dateNum, dayName, dateString, color, bgColor, label, shift };
  });

  // Calculate Calendar Summaries for the Legend
  $: countHadir = activeCalendar ? activeCalendar.filter(d => d.color === '#10b981').length : 0;
  $: countLembur = activeCalendar ? activeCalendar.filter(d => d.color === '#8b5cf6').length : 0;
  $: countTerlambat = activeCalendar ? activeCalendar.filter(d => d.color === '#f59e0b').length : 0;
  $: countAbsen = activeCalendar ? activeCalendar.filter(d => d.color === '#ef4444').length : 0;
  $: countLibur = activeCalendar ? activeCalendar.filter(d => d.color === '#94a3b8').length : 0;
</script>

<!-- SCORECARD SECTION -->
{#if activeEmpStats && activeEmpStats.length > 0}
  <ScorecardVariant 
    empData={activeEmpStats[0]} 
    {startDateStr} {endDateStr} 
    {avgOthersRevenuePerShift} {avgOthersOvertime} 
    theme="apple" 
  />

  <!-- Full Width History & Calendar -->
  <div class="history-section" style="background: linear-gradient(135deg, rgba(99,102,241,0.04), rgba(139,92,246,0.03)); border-radius: 20px; border: 1.5px solid rgba(99, 102, 241, 0.18); padding: 24px; box-shadow: 0 4px 10px rgba(0,0,0,0.02); margin-top: 32px;">
    
    <div class="section-head" style="margin-bottom: 24px;">
      <div class="section-eyebrow" style="font-size: 12px; font-weight: 700; letter-spacing: 0.11em; text-transform: uppercase; color: #0f172a; margin-bottom: 4px; display: flex; align-items: center; gap: 5px;">
        <span>🕒 HISTORI & KEHADIRAN</span>
      </div>
      <h3 class="section-title" style="margin: 0; font-size: 1.15rem; font-weight: 800; letter-spacing: -0.02em; color: #0f172a;">Rincian Historis Karyawan</h3>
      <p class="section-copy" style="margin: 4px 0 0; font-size: 0.87rem; line-height: 1.7; color: #0f172a;">
        Detail pergerakan shift harian, catatan keterlambatan, dan pencapaian pesanan selama 30 hari ke belakang.
      </p>
    </div>

    <!-- Real Calendar Grid -->
    <h4 style="margin: 0 0 16px 0; font-size: 0.95rem; color: #0f172a; font-weight: 800; text-transform: uppercase;">📅 Kalender Kehadiran</h4>
    <div class="streak-container">
      <div class="real-calendar-grid">
        {#each activeCalendar as day}
          <div class="cal-day" style="border-top: 4px solid {day.color}; background: {day.bgColor}; opacity: {day.bgColor === 'white' ? '1' : '0.6'};" 
               title="{day.dayName}, {day.dateString} - {day.label}">
            <div class="cal-day-name">{day.dayName}</div>
            <div class="cal-date-num" style="color: {day.color}">{day.dateNum}</div>
          </div>
        {/each}
      </div>
      <div class="streak-legend">
        <div class="legend-item"><div class="legend-color" style="background:#10b981;">{countHadir}</div> Hadir</div>
        <div class="legend-item"><div class="legend-color" style="background:#8b5cf6;">{countLembur}</div> Lembur</div>
        <div class="legend-item"><div class="legend-color" style="background:#f59e0b;">{countTerlambat}</div> Terlambat</div>
        <div class="legend-item"><div class="legend-color" style="background:#ef4444;">{countAbsen}</div> Absen</div>
        <div class="legend-item"><div class="legend-color" style="background:#94a3b8;">{countLibur}</div> Libur</div>
      </div>
    </div>

    <h4 style="margin: 0 0 16px 0; font-size: 0.95rem; color: #0f172a; font-weight: 800; text-transform: uppercase;">📋 Tabel Rincian Shift</h4>
    <div style="background: transparent; border-radius: 12px; border: 1px solid var(--color-border-tertiary, #e2e8f0); overflow-x: auto; overflow-y: auto; max-height: 400px; box-shadow: 0 2px 4px rgba(0,0,0,0.02);">
      <table style="width:100%; border-collapse:collapse; font-size:0.88rem; text-align:left;">
        <thead style="position: sticky; top: 0; z-index: 2; background: #f1f5f9;">
          <tr style="border-bottom: 1.5px solid #e2e8f0;">
            <th style="padding:10px 14px; font-weight:700; color:#0f172a; background: #f1f5f9;">Tanggal</th>
            <th style="padding:10px 14px; font-weight:700; color:#0f172a; background: #f1f5f9;">Shift</th>
            <th style="padding:10px 14px; font-weight:700; color:#0f172a; background: #f1f5f9;">Status</th>
            <th style="padding:10px 14px; font-weight:700; text-align:center; color:#0f172a; background: #f1f5f9;">Jml Pesanan</th>
            <th style="padding:10px 14px; font-weight:700; text-align:right; color:#0f172a; background: #f1f5f9;">Omzet (Rp)</th>
            <th style="padding:10px 14px; font-weight:700; text-align:center; color:#0f172a; background: #f1f5f9;">Lembur (Jam)</th>
          </tr>
        </thead>
        <tbody>
          {#each activeEmpHistoryFull as row}
          <tr style="border-bottom:1px solid var(--color-border-tertiary, #e2e8f0);">
            <td style="padding:10px 14px; font-weight:normal; color:var(--color-text-secondary, #475569);">{row.Tanggal_Fmt}</td>
            <td style="padding:10px 14px; font-weight:600; color:var(--color-text-primary, #0f172a);">{row.Shift}</td>
            <td style="padding:10px 14px; font-weight:normal; color:var(--color-text-primary, #0f172a);">{row.Status}</td>
            <td style="padding:10px 14px; text-align:center; font-weight:700; color:var(--color-text-primary, #0f172a);">{row.Pesanan_Real !== null ? row.Pesanan_Real : '-'}</td>
            <td style="padding:10px 14px; text-align:right; font-family:monospace; font-weight:700;">{row.Omzet_Real !== null ? Intl.NumberFormat('id-ID').format(row.Omzet_Real) : '-'}</td>
            <td style="padding:10px 14px; text-align:center; font-family:monospace; font-weight:700;">{row.Lembur_Real !== null && row.Lembur_Real > 0 ? row.Lembur_Real : '-'}</td>
          </tr>
          {/each}
        </tbody>
      </table>
    </div>
  </div>
{/if}

<style>
/* ── Unified Master Card ── */
.unified-card {
  background: white;
  border-radius: 16px;
  border: 1px solid #e2e8f0;
  box-shadow: 0 10px 25px rgba(0,0,0,0.04);
  margin-bottom: 32px;
  overflow: hidden;
}
.unified-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px 24px;
  background: #f8fafc;
  border-bottom: 1px solid #e2e8f0;
}
.uh-title {
  font-weight: 900;
  color: #0f172a;
  text-transform: uppercase;
  font-size: 0.95rem;
  letter-spacing: 0.05em;
}
.uh-date {
  font-size: 0.85rem;
  font-weight: 600;
  color: #64748b;
  display: flex;
  align-items: center;
  gap: 12px;
}
@media (max-width: 600px) {
  .unified-header { flex-direction: column; align-items: flex-start; gap: 12px; }
}
.unified-body {
  padding: 24px;
  display: grid;
  grid-template-columns: 320px 1fr;
  gap: 24px;
}
@media (max-width: 900px) {
  .unified-body { grid-template-columns: 1fr; }
}

/* ── Selector ── */
.profile-selector-container {
  display: flex;
  align-items: center;
  background: white;
  padding: 16px 24px;
  border-radius: 12px;
  border: 1px solid #e2e8f0;
  margin-bottom: 24px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.03);
}
.selector-label {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-right: 20px;
  color: #0f172a;
}

/* ── Scorecard Layout ── */
.scorecard-top-row {
  display: grid;
  grid-template-columns: 320px 1fr;
  gap: 24px;
  margin-bottom: 24px;
}
@media (max-width: 900px) {
  .scorecard-top-row {
    grid-template-columns: 1fr;
  }
}

/* ── ID Card ── */
.id-card {
  background: white;
  border-radius: 12px;
  border: 1px solid #e2e8f0;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  align-items: center;
  position: relative;
}
.id-card-header {
  width: 100%;
  height: 80px;
  background: linear-gradient(135deg, #3b82f6, #1d4ed8);
}
.id-avatar {
  width: 90px;
  height: 90px;
  border-radius: 50%;
  background: white;
  border: 4px solid white;
  box-shadow: 0 4px 10px rgba(0,0,0,0.1);
  margin-top: -45px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 2.2rem;
  font-weight: 900;
  color: #3b82f6;
  z-index: 2;
}
.id-name {
  margin: 16px 0 4px 0;
  font-size: 1.4rem;
  font-weight: 800;
  color: #0f172a;
  text-align: center;
  padding: 0 16px;
}
.id-role {
  font-size: 0.95rem;
  font-weight: 700;
  color: #64748b;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  margin-bottom: 8px;
}
.id-branch {
  font-size: 0.9rem;
  color: #475569;
  background: #f1f5f9;
  padding: 4px 12px;
  border-radius: 12px;
  margin-bottom: 24px;
  font-weight: 500;
}
.id-stats-mini {
  display: flex;
  width: 100%;
  border-top: 1px solid #e2e8f0;
  background: #f8fafc;
}
.id-stat-box {
  flex: 1;
  padding: 16px;
  text-align: center;
}
.id-stat-box:first-child {
  border-right: 1px solid #e2e8f0;
}
.id-stat-val {
  font-size: 1.3rem;
  font-weight: 800;
  color: #0f172a;
}
.id-stat-lbl {
  font-size: 0.75rem;
  font-weight: 600;
  color: #64748b;
  text-transform: uppercase;
  margin-top: 4px;
}

/* ── Detailed Metrics ── */
.metrics-stack {
  display: flex;
  flex-direction: column;
  gap: 16px;
  justify-content: space-between;
}
.metric-box {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 20px;
  background: #f8fafc;
  border-radius: 12px;
  border: 1px solid #e2e8f0;
  flex-grow: 1;
}
.metric-box.green { border-left: 5px solid #10b981; }
.metric-box.orange { border-left: 5px solid #f59e0b; }
.metric-box.red { border-left: 5px solid #ef4444; }

.mb-icon {
  font-size: 1.8rem;
  width: 56px;
  height: 56px;
  background: white;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}
.mb-label {
  font-size: 0.85rem;
  font-weight: 700;
  color: #64748b;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  margin-bottom: 6px;
}
.mb-value {
  font-size: 1.6rem;
  font-weight: 900;
  color: #0f172a;
}

/* ── Activity Streak Calendar ── */
.streak-container {
  background: rgba(255, 255, 255, 0.4);
  backdrop-filter: blur(12px);
  border-radius: 16px;
  border: 1px solid rgba(255, 255, 255, 0.8);
  padding: 24px;
  margin-bottom: 32px;
  box-shadow: 0 4px 6px rgba(0,0,0,0.02);
}
.streak-header {
  font-size: 1rem;
  font-weight: 800;
  color: #1e293b;
  text-transform: uppercase;
  margin-bottom: 20px;
}
.real-calendar-grid {
  display: grid;
  grid-template-columns: repeat(10, 1fr);
  gap: 10px;
}
@media (max-width: 900px) {
  .real-calendar-grid { grid-template-columns: repeat(7, 1fr); }
}
@media (max-width: 500px) {
  .real-calendar-grid { grid-template-columns: repeat(5, 1fr); }
}
.cal-day {
  border: 1px solid #e2e8f0;
  border-radius: 8px;
  padding: 8px 4px;
  text-align: center;
  box-shadow: 0 1px 2px rgba(0,0,0,0.02);
  transition: transform 0.2s, box-shadow 0.2s;
  cursor: pointer;
}
.cal-day:hover {
  transform: translateY(-3px);
  box-shadow: 0 4px 12px rgba(0,0,0,0.08);
  opacity: 1 !important;
  z-index: 10;
}
.cal-day-name {
  font-size: 0.7rem;
  text-transform: uppercase;
  color: #64748b;
  font-weight: 800;
  margin-bottom: 4px;
}
.cal-date-num {
  font-size: 1.3rem;
  font-weight: 900;
}

.streak-legend {
  display: flex;
  flex-wrap: wrap;
  gap: 20px;
  margin-top: 24px;
  padding-top: 16px;
  border-top: 1px dashed #e2e8f0;
  font-size: 0.85rem;
  font-weight: 700;
  color: #475569;
}
.legend-item {
  display: flex;
  align-items: center;
  gap: 8px;
}
.legend-color {
  min-width: 22px;
  height: 22px;
  border-radius: 4px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-size: 0.75rem;
  font-weight: 800;
  padding: 0 4px;
}

.history-section {
  background: #f8fafc;
  border: 1px solid #e2e8f0;
  border-radius: 16px;
  padding: 24px;
  margin-bottom: 48px;
}

/* ── Leaderboards ── */
.leaderboards-container {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 24px;
}
@media (max-width: 768px) {
  .leaderboards-container {
    grid-template-columns: 1fr;
  }
}
.lb-panel {
  background: white;
  border-radius: 16px;
  border: 1px solid #e2e8f0;
  overflow: hidden;
  box-shadow: 0 4px 12px rgba(0,0,0,0.03);
}
.lb-header {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 20px;
  border-bottom: 1px solid #e2e8f0;
}
.lb-header.green { background: linear-gradient(135deg, rgba(16,185,129,0.08), rgba(5,150,105,0.02)); }
.lb-header.red { background: linear-gradient(135deg, rgba(239,68,68,0.08), rgba(220,38,38,0.02)); }

.lb-header-icon {
  font-size: 1.8rem;
  width: 48px;
  height: 48px;
  background: white;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 2px 6px rgba(0,0,0,0.05);
}
.lb-title {
  margin: 0;
  font-size: 1.15rem;
  font-weight: 800;
  color: #0f172a;
}
.lb-desc {
  margin: 4px 0 0 0;
  font-size: 0.85rem;
  color: #64748b;
}
.lb-body {
  padding: 12px 20px;
}
.lb-row {
  display: flex;
  align-items: center;
  padding: 12px 0;
  border-bottom: 1px dashed #e2e8f0;
}
.lb-row:last-child {
  border-bottom: none;
}
.lb-rank {
  font-size: 1.2rem;
  font-weight: 900;
  color: #94a3b8;
  width: 40px;
}
.lb-row:nth-child(1) .lb-rank { color: #f59e0b; font-size: 1.4rem; }
.lb-row:nth-child(2) .lb-rank { color: #94a3b8; }
.lb-row:nth-child(3) .lb-rank { color: #b45309; }

.lb-info {
  flex-grow: 1;
}
.lb-name {
  font-weight: 800;
  color: #0f172a;
  font-size: 1rem;
}
.lb-meta {
  font-size: 0.8rem;
  color: #64748b;
  margin-top: 2px;
}
.lb-score {
  font-weight: 900;
  font-size: 1.1rem;
  text-align: right;
}
.green-text { color: #10b981; }
.red-text { color: #ef4444; }
</style>
