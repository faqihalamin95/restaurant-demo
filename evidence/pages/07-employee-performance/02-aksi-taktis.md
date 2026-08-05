---
title: Aksi Taktis
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
        WHEN total_overtime_hours >= 20 THEN '> 20 Jam'
        WHEN total_overtime_hours >= 10 THEN '10 - 20 Jam'
        ELSE '< 10 Jam'
    END as rentang_lembur,
    COUNT(*) as jumlah_pegawai
FROM restaurant.top_overtime_employees_period
WHERE period = '30d'
GROUP BY 1
ORDER BY 
    CASE rentang_lembur 
        WHEN '< 10 Jam' THEN 1
        WHEN '10 - 20 Jam' THEN 2
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
    WHEN 'Kritis' THEN 1 
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
ORDER BY CASE risk_label WHEN 'Kritis' THEN 1 WHEN 'Tinggi' THEN 2 ELSE 3 END
```

```sql attendance_branch
SELECT branch_name, COUNT(employee_name) as jumlah_pegawai
FROM restaurant.attendance_problem_period
WHERE period = '30d'
GROUP BY 1
ORDER BY jumlah_pegawai ASC
```

<script>
  function idFormat(num, dec = 0) {
    if (num === null || num === undefined) return '0';
    return new Intl.NumberFormat('id-ID', { minimumFractionDigits: dec, maximumFractionDigits: dec }).format(num);
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
    targetDisiplinCount = attendance_problem.filter(d => d.risk_label === 'Kritis' || d.risk_label === 'Tinggi').length;
    criticalDisiplinCount = attendance_problem.filter(d => d.risk_label === 'Kritis').length;
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
               name: 'Pegawai', type: 'bar', barWidth: '45%', showBackground: true, backgroundStyle: { color: 'rgba(239, 68, 68, 0.05)', borderRadius: [8, 8, 0, 0] },
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
               name: 'Jam Lembur', type: 'bar', showBackground: true, backgroundStyle: { color: 'rgba(239, 68, 68, 0.05)', borderRadius: [0, 8, 8, 0] },
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
               name: 'Pegawai', type: 'bar', barWidth: '45%', showBackground: true, backgroundStyle: { color: 'rgba(245, 158, 11, 0.05)', borderRadius: [8, 8, 0, 0] },
               data: attendance_distribution.map((d) => ({ value: d.jumlah_pegawai, itemStyle: { color: d.risk_label === 'Kritis' ? '#ef4444' : '#f59e0b', borderRadius: [8, 8, 0, 0] } })),
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
               name: 'Pegawai Bermasalah', type: 'bar', showBackground: true, backgroundStyle: { color: 'rgba(245, 158, 11, 0.05)', borderRadius: [0, 8, 8, 0] },
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
    <div class="diagnostics-eyebrow">⚠️ Pembinaan Staf</div>
    <span class="toc-anchor-marker"></span>

## Pelanggaran Disiplin (Absen & Telat)
<h2 class="diagnostics-title">Pelanggaran Disiplin (Absen & Telat)</h2>
    <p class="diagnostics-copy">Daftar staf yang paling sering absen atau terlambat. Temukan pola pelanggarannya dan jadwalkan 1-on-1 coaching sebelum mengganggu kualitas pelayanan FOH/BOH.</p>
  </div>
  
  <details id="acc-disiplin" class="acc-strategic">
    <summary>📊 Selami Data Pembinaan Disiplin</summary>

    <div class="acc-body">
      <div style="display: flex; flex-direction: column; gap: 24px;">
        
        <!-- 1. Kesimpulan (Insight) -->
        <div>
          <div class="section-head tight" style="margin-bottom: 12px;">
            <div>
              <div class="section-eyebrow">⚠️ Ringkasan Pelanggaran</div>
              <h3 class="section-title">Tingkat Ketidakdisiplinan & Target Coaching</h3>
              <p class="section-copy">Menampilkan kesimpulan tingkat pelanggaran kehadiran (absen & telat) dan jumlah staf yang harus segera diberi teguran.</p>
            </div>
          </div>

          <div class="insight-grid">
            <div class="insight-card {lateState === 'safe' ? 'safe' : lateState === 'warn' ? 'warn' : 'kritis'}">
              <div class="insight-header">
                <span class="insight-icon">{lateState === 'safe' ? '🛡️' : lateState === 'warn' ? '⚠️' : '🚨'}</span>
                <span class="insight-title">Tingkat Indisipliner</span>
              </div>
              <div class="insight-body">
                <div class="insight-number">{idFormat(latePct, 1)}<span class="insight-percent">%</span></div>
                <div class="insight-status-badge {lateState === 'safe' ? 'safe' : lateState === 'warn' ? 'warn' : 'kritis'}">{lateState === 'safe' ? 'SEHAT' : lateState === 'warn' ? 'WASPADA' : 'KRITIS'}</div>
              </div>
              <div class="insight-footer">
                {#if lateState === 'safe'}
                  Formasi shift operasional terjaga dengan sangat baik. Hampir tidak ada gangguan absensi.
                {:else if lateState === 'warn'}
                  Ada sedikit gangguan formasi shift akibat <strong>{totalInsiden} insiden</strong> telat/bolos bulan ini.
                {:else}
                  Tercatat akumulasi memprihatinkan sebanyak <strong>{totalInsiden} insiden</strong> telat dan bolos!
                {/if}
              </div>
            </div>

            <div class="insight-card target-card {criticalDisiplinCount > 0 ? 'kritis' : targetDisiplinCount > 0 ? 'warn' : 'neutral'}">
              <div class="insight-header">
                <span class="insight-icon">🎯</span>
                <span class="insight-title">Target Coaching Utama</span>
              </div>
              <div class="insight-body">
                <div class="insight-number">{targetDisiplinCount}<span class="insight-percent">&nbsp;Staf</span></div>
                <div class="insight-status-badge {criticalDisiplinCount > 0 ? 'kritis' : targetDisiplinCount > 0 ? 'warn' : 'neutral'}">INTERVENSI</div>
              </div>
              <div class="insight-footer">
                {#if lateState === 'safe' && targetDisiplinCount > 0}
                  Secara makro disiplin sangat baik, namun {targetDisiplinCount} staf ini mulai menunjukkan bibit indisipliner berulang.
                {:else if targetDisiplinCount > 0}
                  Prioritaskan memanggil {targetDisiplinCount} staf paling indisipliner ini untuk 1-on-1 coaching segera.
                {:else}
                  Tidak ada staf yang melakukan pelanggaran disiplin fatal.
                {/if}
              </div>
            </div>
          </div>

          <details class="guide-acc" style="margin-top: 16px; margin-bottom: 0;">
            <summary>💡 Parameter AI: Penentuan Status & Target</summary>
            <div class="guide-body" style="padding: 16px;">
              <p style="margin-top: 4px; margin-bottom: 16px; font-weight: 500; color: var(--color-text-secondary);">
                Sistem tidak menggunakan perasaan, melainkan patokan data kuantitatif untuk memicu alarm kedisiplinan:
              </p>
              
              <div class="guide-grid" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 16px;">
                <div class="guide-card blue">
                  <div class="guide-card-icon">🛡️</div>
                  <div class="guide-card-content">
                    <div class="guide-card-label">Tingkat Indisipliner</div>
                    <h4 class="guide-card-title">Filter Makro</h4>
                    <p class="guide-card-copy">Mengukur rasio insiden keterlambatan terhadap total kehadiran harian:</p>
                    <ul style="margin: 12px 0 0 0; padding: 0; font-size: 13px; color: var(--color-text-secondary); line-height: 1.6; display: flex; flex-direction: column; gap: 6px;">
                      <li style="display: flex; align-items: flex-start; gap: 8px;"><span style="color: #94a3b8; font-size: 14px; line-height: 1;">•</span> <div><strong>&lt; 10%:</strong> Sehat (Formasi shift aman)</div></li>
                      <li style="display: flex; align-items: flex-start; gap: 8px;"><span style="color: #94a3b8; font-size: 14px; line-height: 1;">•</span> <div><strong>10% - 20%:</strong> Waspada (Budaya telat muncul)</div></li>
                      <li style="display: flex; align-items: flex-start; gap: 8px;"><span style="color: #94a3b8; font-size: 14px; line-height: 1;">•</span> <div><strong>&gt; 20%:</strong> Kritis (Ancaman operasional)</div></li>
                    </ul>
                  </div>
                </div>

                <div class="guide-card red">
                  <div class="guide-card-icon">🎯</div>
                  <div class="guide-card-content">
                    <div class="guide-card-label">Target Coaching Utama</div>
                    <h4 class="guide-card-title">Filter Mikro</h4>
                    <p class="guide-card-copy">Mendeteksi staf dengan rekor absen/telat paling parah secara individual:</p>
                    <ul style="margin: 12px 0 0 0; padding: 0; font-size: 13px; color: var(--color-text-secondary); line-height: 1.6; display: flex; flex-direction: column; gap: 6px;">
                      <li style="display: flex; align-items: flex-start; gap: 8px;"><span style="color: #94a3b8; font-size: 14px; line-height: 1;">•</span> <div><strong>Level Tinggi:</strong> &ge; 2 Bolos atau &ge; 4 Telat / bulan</div></li>
                      <li style="display: flex; align-items: flex-start; gap: 8px;"><span style="color: #94a3b8; font-size: 14px; line-height: 1;">•</span> <div><strong>Level Kritis:</strong> &ge; 3 Bolos atau &ge; 6 Telat / bulan</div></li>
                    </ul>
                  </div>
                </div>
              </div>
              <div style="margin-top: 16px; padding: 12px; background: rgba(226, 232, 240, 0.4); border-radius: 8px; font-size: 13px; color: var(--color-text-secondary); border-left: 3px solid #94a3b8;">
                <strong>Dampak Bisnis Jangka Panjang:</strong> Satu staf kasir yang telat 15 menit saja saat jam sibuk berisiko menciptakan antrean panjang dan menurunkan tingkat kepuasan pelanggan secara instan.
              </div>
            </div>
          </details>

        </div>

        <!-- 2. Rekomendasi Aksi (Decision Box) -->
        <div>
          <div class="section-head tight" style="margin-bottom: 16px;">
            <div>
              <div class="section-eyebrow">📝 Eksekusi Taktis</div>
              <h3 class="section-title">Panduan Coaching & Intervensi</h3>
              <p class="section-copy">Langkah prioritas untuk mendisiplinkan staf yang berulang kali merusak formasi shift operasional.</p>
            </div>
          </div>
          <div class="decision-box {lateColor}">
            <div class="decision-content">
              <div class="decision-title">
                <span style="display: flex; align-items: center; gap: 8px;">
                  <span style="font-size: 1.1em;">{lateState === 'safe' && targetDisiplinCount === 0 ? '✅' : targetDisiplinCount > 0 ? '⚠️' : '🚨'}</span>
                  {lateState === 'safe' && targetDisiplinCount === 0 ? 'Kedisiplinan Terjaga' : targetDisiplinCount > 0 ? 'Intervensi Individu Dibutuhkan' : 'Krisis Disiplin!'}
                </span>
                <div class="ai-badge">✨ AI Generated</div>
              </div>
              <p class="decision-text">
                {#if lateState === 'safe' && targetDisiplinCount === 0}
                  Sangat luar biasa, persentase telat dan bolos harian di bawah ambang batas normal. Tim Anda sangat solid. Namun, teguran ringan tetap bisa dilakukan kepada nama-nama di bawah ini:
                {:else if lateState === 'safe' && targetDisiplinCount > 0}
                  Secara makro budaya disiplin tim masih baik, namun <strong>{targetDisiplinCount} staf</strong> ini mulai menunjukkan rekor indisipliner (absen/telat berulang) yang rawan menular. Lakukan pendekatan 1-on-1:
                {:else if lateState === 'warn'}
                  Ada <strong>{targetDisiplinCount} staf</strong> yang merusak jadwal operasional akibat telat dan bolos. Segera panggil mereka untuk sesi 1-on-1 coaching agar tidak menular ke staf lain:
                {:else}
                  <strong>Krisis Disiplin!</strong> Tingkat pelanggaran absensi merusak formasi operasional harian restoran. SP (Surat Peringatan) harus segera diterbitkan kepada <strong>{targetDisiplinCount} staf prioritas</strong> berikut:
                {/if}
              </p>
              
              <div class="table-container">
                <DataTable data={attendance_problem} rows={10} search={true}>
                  <Column id="nama_staf_html" title="Nama Staf" contentType="html" />
                  <Column id="role" title="Posisi" />
                  <Column id="branch_name" title="Cabang" />
                  <Column id="total_absent" title="Total Bolos" align="center" />
                  <Column id="total_late" title="Total Telat" align="center" />
                  <Column id="risk_label" title="Level Risiko" align="center" />
                  <Column id="recommended_action" title="Rekomendasi Aksi" />
                </DataTable>
              </div>

              <div class="decision-footer">
                <em>*Disclaimer: Rekomendasi hukuman AI berpatokan pada frekuensi akumulatif insiden tanpa mengetahui alasan spesifik (seperti sakit). Lakukan validasi silang sebelum menindak.</em>
              </div>
            </div>
          </div>
        </div>

        <!-- 3. Data Pendukung (Grafik) -->
        <div>
          <div class="section-head tight" style="margin-bottom: 12px;">
            <div>
              <div class="section-eyebrow">📊 Profil Pelanggaran</div>
              <h3 class="section-title">Sebaran Risiko Disiplin</h3>
              <p class="section-copy">Visualisasi tingkat keparahan kedisiplinan dan kontribusi pelanggaran dari setiap cabang.</p>
            </div>
          </div>
          <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 24px;">
             <div style="background: linear-gradient(180deg, var(--color-background-primary), var(--color-background-secondary)); padding: 24px; border-radius: 16px; border: 1px solid var(--color-border-tertiary); box-shadow: 0 4px 12px rgba(0,0,0,0.02);">
               <h4 style="font-size: 13px; font-weight: 700; letter-spacing: 0.05em; text-transform: uppercase; color: var(--color-text-tertiary); margin-top: 0; margin-bottom: 24px;">Tingkat Keparahan Disiplin</h4>
               <ECharts config={chartOptionAttendance} height="260px" />
           </div>
           <div style="background: linear-gradient(180deg, var(--color-background-primary), var(--color-background-secondary)); padding: 24px; border-radius: 16px; border: 1px solid var(--color-border-tertiary); box-shadow: 0 4px 12px rgba(0,0,0,0.02);">
             <h4 style="font-size: 13px; font-weight: 700; letter-spacing: 0.05em; text-transform: uppercase; color: var(--color-text-tertiary); margin-top: 0; margin-bottom: 24px;">Sebaran Pegawai Bermasalah per Cabang</h4>
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
    <div class="diagnostics-eyebrow">🚨 Peringatan SDM</div>
    <span class="toc-anchor-marker"></span>

## Risiko Burnout & Flight Risk
<h2 class="diagnostics-title">Risiko Burnout & Flight Risk</h2>
    <p class="diagnostics-copy">Daftar staf yang mengalami tekanan lembur berlebihan bulan ini. Segera rotasi shift mereka untuk menghindari kelelahan kronis atau risiko resign mendadak.</p>
  </div>
  
  <details id="acc-burnout" class="acc-strategic">
    <summary>📊 Selami Data Risiko Burnout</summary>

    <div class="acc-body">
      <div style="display: flex; flex-direction: column; gap: 24px;">
        
        <!-- 1. Kesimpulan (Insight) -->
        <div>
          <div class="section-head tight" style="margin-bottom: 12px;">
            <div>
              <div class="section-eyebrow">🚨 Ringkasan Risiko</div>
              <h3 class="section-title">Tingkat Tekanan Lembur & Target Rotasi</h3>
              <p class="section-copy">Menampilkan kesimpulan beban lembur restoran secara keseluruhan beserta jumlah staf yang butuh dirotasi secepatnya.</p>
            </div>
          </div>
          
          <div class="insight-grid">
            <div class="insight-card {overtimeState === 'safe' ? 'safe' : overtimeState === 'warn' ? 'warn' : 'kritis'}">
              <div class="insight-header">
                <span class="insight-icon">{overtimeState === 'safe' ? '🛡️' : overtimeState === 'warn' ? '⚠️' : '🚨'}</span>
                <span class="insight-title">Tingkat Tekanan Lembur</span>
              </div>
              <div class="insight-body">
                <div class="insight-number">{idFormat(overtimePct, 1)}<span class="insight-percent">%</span></div>
                <div class="insight-status-badge {overtimeState === 'safe' ? 'safe' : overtimeState === 'warn' ? 'warn' : 'kritis'}">{overtimeState === 'safe' ? 'SEHAT' : overtimeState === 'warn' ? 'WASPADA' : 'KRITIS'}</div>
              </div>
              <div class="insight-footer">
                {#if overtimeState === 'safe'}
                  Ketergantungan operasional restoran terhadap shift ekstra (overtime) masih sangat aman.
                {:else if overtimeState === 'warn'}
                  Kapasitas lembur mulai mendekati ambang batas wajar.
                {:else}
                  Kritis! Mayoritas shift berjalan dengan mengandalkan tenaga lembur.
                {/if}
              </div>
            </div>

            <div class="insight-card target-card {criticalBurnoutCount > 0 ? 'kritis' : targetBurnoutCount > 0 ? 'warn' : 'neutral'}">
              <div class="insight-header">
                <span class="insight-icon">🎯</span>
                <span class="insight-title">Target Rotasi Prioritas</span>
              </div>
              <div class="insight-body">
                <div class="insight-number">{targetBurnoutCount}<span class="insight-percent">&nbsp;Staf</span></div>
                <div class="insight-status-badge {criticalBurnoutCount > 0 ? 'kritis' : targetBurnoutCount > 0 ? 'warn' : 'neutral'}">BURNOUT RISK</div>
              </div>
              <div class="insight-footer">
                {#if overtimeState === 'safe' && targetBurnoutCount > 0}
                  Meski rata-rata restoran aman, beban lembur menumpuk secara ekstrem pada {targetBurnoutCount} staf ini.
                {:else if targetBurnoutCount > 0}
                  Prioritaskan merotasi atau meliburkan {targetBurnoutCount} staf ini akhir pekan ini sebelum mereka burnout.
                {:else}
                  Distribusi shift merata, tidak ada staf yang menanggung beban ekstrem.
                {/if}
              </div>
            </div>
          </div>

          <details class="guide-acc" style="margin-top: 16px; margin-bottom: 0;">
            <summary>💡 Parameter AI: Penentuan Status & Target</summary>
            <div class="guide-body" style="padding: 16px;">
              <p style="margin-top: 4px; margin-bottom: 16px; font-weight: 500; color: var(--color-text-secondary);">
                Untuk menjaga objektivitas, AI memonitor risiko lembur dengan dua lapisan filter metrik yang kaku:
              </p>
              
              <div class="guide-grid" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 16px;">
                <div class="guide-card blue">
                  <div class="guide-card-icon">🛡️</div>
                  <div class="guide-card-content">
                    <div class="guide-card-label">Tingkat Tekanan Lembur</div>
                    <h4 class="guide-card-title">Filter Makro</h4>
                    <p class="guide-card-copy">Mengukur persentase shift operasional yang diisi dengan jam lembur:</p>
                    <ul style="margin: 12px 0 0 0; padding: 0; font-size: 13px; color: var(--color-text-secondary); line-height: 1.6; display: flex; flex-direction: column; gap: 6px;">
                      <li style="display: flex; align-items: flex-start; gap: 8px;"><span style="color: #94a3b8; font-size: 14px; line-height: 1;">•</span> <div><strong>&lt; 35%:</strong> Sehat (Kapasitas ideal)</div></li>
                      <li style="display: flex; align-items: flex-start; gap: 8px;"><span style="color: #94a3b8; font-size: 14px; line-height: 1;">•</span> <div><strong>35% - 50%:</strong> Waspada (Mulai kurang staf)</div></li>
                      <li style="display: flex; align-items: flex-start; gap: 8px;"><span style="color: #94a3b8; font-size: 14px; line-height: 1;">•</span> <div><strong>&gt; 50%:</strong> Kritis (Kekurangan staf sistemik)</div></li>
                    </ul>
                  </div>
                </div>

                <div class="guide-card red">
                  <div class="guide-card-icon">🎯</div>
                  <div class="guide-card-content">
                    <div class="guide-card-label">Target Rotasi Prioritas</div>
                    <h4 class="guide-card-title">Filter Mikro</h4>
                    <p class="guide-card-copy">Sistem mendeteksi anomali akumulasi lembur individu (Target Zona Merah):</p>
                    <ul style="margin: 12px 0 0 0; padding: 0; font-size: 13px; color: var(--color-text-secondary); line-height: 1.6; display: flex; flex-direction: column; gap: 6px;">
                      <li style="display: flex; align-items: flex-start; gap: 8px;"><span style="color: #94a3b8; font-size: 14px; line-height: 1;">•</span> <div><strong>&lt; 10 Jam:</strong> Zona Aman (Toleransi wajar)</div></li>
                      <li style="display: flex; align-items: flex-start; gap: 8px;"><span style="color: #94a3b8; font-size: 14px; line-height: 1;">•</span> <div><strong>10 - 20 Jam:</strong> Waspada (Pantau kelelahan)</div></li>
                      <li style="display: flex; align-items: flex-start; gap: 8px;"><span style="color: #94a3b8; font-size: 14px; line-height: 1;">•</span> <div><strong>&gt; 20 Jam:</strong> Kritis (Risiko <em>burnout</em> ekstrem)</div></li>
                    </ul>
                  </div>
                </div>
              </div>
              <div style="margin-top: 16px; padding: 12px; background: rgba(226, 232, 240, 0.4); border-radius: 8px; font-size: 13px; color: var(--color-text-secondary); border-left: 3px solid #94a3b8;">
                <strong>Dampak Bisnis Jangka Panjang:</strong> Shift lembur memang bisa menutupi kekurangan staf secara instan, tapi jika dibiarkan ini akan merusak fokus staf dan berdampak pada tingginya <em>human-error</em> (pesanan salah, komplain naik).
              </div>
            </div>
          </details>

        </div>

        <!-- 2. Rekomendasi Aksi (Decision Box) -->
        <div>
          <div class="section-head tight" style="margin-bottom: 16px;">
            <div>
              <div class="section-eyebrow">📝 Eksekusi Taktis</div>
              <h3 class="section-title">Langkah Penyelamatan Staf</h3>
              <p class="section-copy">Daftar staf prioritas yang butuh rotasi jadwal secepatnya didukung dengan analisis otomatis sistem.</p>
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
                    Operasional Terkendali
                  {:else if overtimeState === 'safe' && targetBurnoutCount > 0}
                    Perhatian: Risiko Burnout Individu
                  {:else if overtimeState === 'warn'}
                    Waspada Kekurangan Staf
                  {:else}
                    Krisis Operasional & Burnout Massal!
                  {/if}
                </span>
                <div class="ai-badge">✨ AI Generated</div>
              </div>
              <p class="decision-text">
                {#if overtimeState === 'safe' && targetBurnoutCount === 0}
                  Tekanan lembur sangat terkendali dan merata. Tidak ada indikasi kelelahan kronis massal. Berikut adalah staf dengan overtime tertinggi bulan ini untuk sekadar Anda pantau:
                {:else if overtimeState === 'safe' && targetBurnoutCount > 0}
                  Secara umum formasi operasional aman, namun beban kerja menumpuk secara ekstrem pada <strong>{targetBurnoutCount} staf</strong>. Segera rotasi jadwal atau liburkan nama-nama berikut akhir pekan ini sebelum memicu kelelahan fisik fatal:
                {:else if overtimeState === 'warn'}
                  Tingginya persentase jam lembur mengindikasikan restoran ini mulai kekurangan tenaga kerja reguler. Beban operasional terberat saat ini dipikul oleh <strong>{targetBurnoutCount} staf</strong> berikut. Segera evaluasi kecukupan jumlah karyawan Anda:
                {:else}
                  Bahaya! Formasi operasional Anda terlalu bergantung pada shift ekstra. Sistem mendeteksi <strong>{targetBurnoutCount} staf</strong> berada di ambang batas kelelahan fatal dan berisiko resign/sakit mendadak. Pertimbangkan bantuan staf harian (daily worker) segera untuk menolong nama-nama berikut:
                {/if}
              </p>
              
              <div class="table-container">
                <DataTable data={burnout_risk} rows={10} search={true}>
                  <Column id="employee_name" title="Nama Staf" />
                  <Column id="role" title="Posisi" />
                  <Column id="branch_name" title="Cabang" />
                  <Column id="jam_lembur_html" title="Total OT (Jam)" align="center" contentType="html" />
                  <Column id="overtime_days" title="Sesi OT (Hari)" align="center" />
                  <Column id="recommended_action" title="Tindakan yang Disarankan" />
                </DataTable>
              </div>
              
              <div class="decision-footer">
                <em>*Disclaimer: Sistem mendeteksi ambang batas overtime berdasarkan regulasi shift sehat mingguan.</em>
              </div>
            </div>
          </div>
        </div>

        <!-- 3. Data Pendukung (Grafik) -->
        <div>
          <div class="section-head tight" style="margin-bottom: 12px;">
            <div>
              <div class="section-eyebrow">📊 Profil Beban Kerja</div>
              <h3 class="section-title">Sebaran Jam Lembur</h3>
              <p class="section-copy">Melihat distribusi total jam lembur yang dilakukan oleh para staf berisiko selama 30 hari terakhir.</p>
            </div>
          </div>
          <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 24px;">
             <div style="background: linear-gradient(180deg, var(--color-background-primary), var(--color-background-secondary)); padding: 24px; border-radius: 16px; border: 1px solid var(--color-border-tertiary); box-shadow: 0 4px 12px rgba(0,0,0,0.02);">
               <h4 style="font-size: 13px; font-weight: 700; letter-spacing: 0.05em; text-transform: uppercase; color: var(--color-text-tertiary); margin-top: 0; margin-bottom: 24px;">Tingkat Keparahan Lembur</h4>
               <ECharts config={chartOptionBurnout} height="260px" />
           </div>
           <div style="background: linear-gradient(180deg, var(--color-background-primary), var(--color-background-secondary)); padding: 24px; border-radius: 16px; border: 1px solid var(--color-border-tertiary); box-shadow: 0 4px 12px rgba(0,0,0,0.02);">
             <h4 style="font-size: 13px; font-weight: 700; letter-spacing: 0.05em; text-transform: uppercase; color: var(--color-text-tertiary); margin-top: 0; margin-bottom: 24px;">Total Lembur Berdasarkan Cabang</h4>
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
