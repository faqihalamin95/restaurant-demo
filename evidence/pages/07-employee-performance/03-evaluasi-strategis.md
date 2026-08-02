---
title: Evaluasi Strategis
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
  CASE WHEN hari_hadir >= 26 THEN '🚨 Overworked' ELSE '✅ Aman' END as burnout_risk
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
  pressure_branch_30d as cabang_rawan,
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
    let revText = `Rp ${idFormat(wm.revenue_per_hour)}`;
    let lemburText = `${idFormat(wm.lembur, 1)}%`;
    let indiText = `${idFormat(wm.keterlambatan, 1)}%`;

    if (wm.fokus_intervensi === 'Coverage risk') {
        boxColorClass = "red";
        iconHeadline = "🔍";
        executiveHeadline = "Observasi: Defisit Kapasitas Staf (Krisis Coverage)";
        kalInti = `Bulan ini, setiap pegawai restoran rata-rata menghasilkan pendapatan <strong>${revText}/jam</strong>. Dari sisi operasional, terjadi tekanan akibat absen/telat yang mencapai <strong>${indiText}</strong>.`;
        kalDampak = `Kekosongan jadwal ini terpaksa ditambal dengan menyuruh sisa staf lembur hingga <strong>${lemburText}</strong>. Kondisi paling parah dialami oleh <strong>${wm.cabang_rawan}</strong> saat <strong>shift ${wm.shift_rawan}</strong>, yang jika dibiarkan akan segera memicu kelelahan ekstrem (burnout) pada staf.`;
    } 
    else if (wm.fokus_intervensi === 'Overtime pressure') {
        boxColorClass = "amber";
        iconHeadline = "⚠️";
        executiveHeadline = "Observasi: Ketergantungan Struktural pada Lembur";
        kalInti = `Dengan produktivitas <strong>${revText}/jam</strong> per pegawai restoran, kedisiplinan operasional terjaga sangat baik (pelanggaran hanya <strong>${indiText}</strong>).`;
        kalDampak = `Akan tetapi, beban lembur melonjak drastis hingga <strong>${lemburText}</strong>. Kondisi ini paling terasa berat di <strong>${wm.cabang_rawan}</strong> (khususnya <strong>shift ${wm.shift_rawan}</strong>), menandakan bahwa ramainya pesanan di sana sudah melebihi jumlah staf yang berjaga.`;
    }
    else if (wm.fokus_intervensi === 'Keterlambatan') {
        boxColorClass = "amber";
        iconHeadline = "⚠️";
        executiveHeadline = "Observasi: Degradasi Disiplin Kehadiran";
        kalInti = `Bulan ini, setiap pegawai restoran rata-rata menghasilkan pendapatan <strong>${revText}/jam</strong>. Namun, kedisiplinan staf menunjukkan tren pelonggaran dengan rasio telat/bolos menyentuh <strong>${indiText}</strong>.`;
        kalDampak = `Meski beban lembur masih wajar (<strong>${lemburText}</strong>), masalah indisipliner ini paling sering terjadi di <strong>${wm.cabang_rawan}</strong> saat <strong>shift ${wm.shift_rawan}</strong>, yang sangat berisiko merusak ritme dan kecepatan pelayanan.`;
    }
    else {
        boxColorClass = "green";
        iconHeadline = "✅";
        executiveHeadline = "Observasi: Keseimbangan Formasi & Beban Kerja";
        kalInti = `Bulan ini, setiap pegawai restoran rata-rata menghasilkan pendapatan <strong>${revText}/jam</strong> dengan rasio operasional yang prima.`;
        kalDampak = `Kedisiplinan sangat baik (hanya <strong>${indiText}</strong>) dan beban lembur wajar (<strong>${lemburText}</strong>). Bahkan, area yang berpotensi rawan seperti <strong>${wm.cabang_rawan}</strong> pada <strong>shift ${wm.shift_rawan}</strong> pun berhasil beroperasi dengan sangat mulus bulan ini.`;
    }
  }
  
  function idFormat(num, dec = 0) {
    if (num === null || num === undefined) return '0';
    return new Intl.NumberFormat('id-ID', { minimumFractionDigits: dec, maximumFractionDigits: dec }).format(num);
  }
</script>

<div class="diagnostics-header" style="margin-top: 24px; margin-bottom: 24px;">
  <div class="diagnostics-eyebrow">🧠 DIAGNOSTIK UTAMA</div>
  <h2 class="diagnostics-title">Sintesis Efisiensi & Produktivitas Makro</h2>
  <p class="diagnostics-copy">Evaluasi menyeluruh terhadap kapasitas operasional, profitabilitas tenaga kerja, dan kesehatan struktural jam kerja bulan ini.</p>
</div>

<!-- Narrative Box -->
<div class="decision-box {boxColorClass}">
  <div class="decision-content">
    <div class="decision-title">
      <span style="display: flex; align-items: center; gap: 8px;">
        💡 Insight Operasional & Rekomendasi
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
            <div class="metric-pill">🚨 Rawan: {wm.shift_rawan}</div>
            <div class="metric-pill">🏢 Cabang: {wm.cabang_rawan}</div>
            <div class="metric-pill">💰 Rev/Jam: Rp {idFormat(wm.revenue_per_hour)}</div>
            <div class="metric-pill">🕒 Lembur: {idFormat(wm.lembur, 1)}%</div>
            <div class="metric-pill">📉 Bolos/Telat: {idFormat(wm.keterlambatan, 1)}%</div>
        </div>

        <div class="decision-footer" style="margin-top: 24px;">
          <em>*Disclaimer: Analisis ini dikalkulasi secara otomatis oleh AI berdasarkan perbandingan rasio overtime, absensi, dan keterlambatan selama 30 hari terakhir. Gunakan sebagai petunjuk arah (compass), namun tetap validasi keadaan di lapangan.</em>
        </div>
  </div>
</div>


<!-- RISIKO STRUKTURAL SECTION -->
<div class="diagnostics-header" style="margin-top: 48px; margin-bottom: 24px;">
  <div class="diagnostics-eyebrow">⚠️ RISIKO STRUKTURAL</div>
  <h2 class="diagnostics-title">Dampak Overtime & Indisipliner</h2>
  <p class="diagnostics-copy">Memahami bagaimana ketergantungan pada jam kerja ekstra dan masalah kehadiran staf secara langsung menggerus margin profitabilitas serta kualitas layanan restoran.</p>
</div>

<div class="risk-section">

  <div class="risk-row purple-theme">
    <div class="risk-row-header">
      <span class="risk-row-icon">🕒</span>
      <h4 class="risk-row-title">Dampak Jangka Panjang Overtime</h4>
    </div>
    <div class="risk-pills">
      <div class="risk-pill">
        <span class="risk-pill-anchor">💸</span>
        <div class="risk-pill-content">
          <strong>Biaya Membengkak</strong>
          <span>Tarif lembur jauh lebih mahal dari jam kerja normal, menggerus <i>margin payroll</i></span>
        </div>
      </div>
      <div class="risk-pill">
        <span class="risk-pill-anchor">🧠</span>
        <div class="risk-pill-content">
          <strong>Fokus Menurun</strong>
          <span>Akumulasi kelelahan meningkatkan risiko kesalahan order dan kecelakaan kerja</span>
        </div>
      </div>
      <div class="risk-pill">
        <span class="risk-pill-anchor">🚪</span>
        <div class="risk-pill-content">
          <strong>Staf Terbaik Pergi</strong>
          <span>Beban berlebihan mendorong karyawan andalan mencari tempat kerja lain</span>
        </div>
      </div>
    </div>
    <div class="risk-funfact">
      <span class="risk-funfact-icon">📎</span>
      <div class="risk-funfact-content">
        <span>Di Indonesia, tarif lembur jam pertama = <strong>1,5x</strong> upah/jam, dan jam berikutnya = <strong>2x</strong> upah/jam.</span>
        <cite>PP 35/2021 — Peraturan Pemerintah tentang Waktu Kerja & Lembur</cite>
      </div>
    </div>
  </div>

  <div class="risk-row blue-theme">
    <div class="risk-row-header">
      <span class="risk-row-icon">📉</span>
      <h4 class="risk-row-title">Efek Domino Keterlambatan</h4>
    </div>
    <div class="risk-pills">
      <div class="risk-pill">
        <span class="risk-pill-anchor">⚡</span>
        <div class="risk-pill-content">
          <strong>Beban Ganda</strong>
          <span>Satu staf telat = rekan satu shift menanggung pekerjaan ekstra</span>
        </div>
      </div>
      <div class="risk-pill">
        <span class="risk-pill-anchor">🍳</span>
        <div class="risk-pill-content">
          <strong>Prep-work Terganggu</strong>
          <span>Persiapan bahan tertunda, kualitas dan kecepatan sajian terancam</span>
        </div>
      </div>
      <div class="risk-pill">
        <span class="risk-pill-anchor">⏱️</span>
        <div class="risk-pill-content">
          <strong>Pelanggan Menunggu</strong>
          <span><i>Speed of service</i> melambat, risiko kehilangan pelanggan di jam sibuk</span>
        </div>
      </div>
    </div>
    <div class="risk-funfact">
      <span class="risk-funfact-icon">📎</span>
      <div class="risk-funfact-content">
        <span>Bekerja lebih dari 12 jam/hari meningkatkan risiko kecelakaan kerja hingga <strong>37%</strong>.</span>
        <cite>Dembe et al., Occupational & Environmental Medicine, 2005</cite>
      </div>
    </div>
  </div>

  <div class="risk-row slate-theme">
    <div class="risk-row-header">
      <span class="risk-row-icon">🔄</span>
      <h4 class="risk-row-title">Pola yang Perlu Diwaspadai</h4>
    </div>
    <div class="risk-pills cols-2">
      <div class="risk-pill">
        <span class="risk-pill-anchor">🔁</span>
        <div class="risk-pill-content">
          <strong>Siklus Tersembunyi</strong>
          <span>Overtime → Kelelahan → Telat/Bolos → butuh Overtime lagi</span>
        </div>
      </div>
      <div class="risk-pill">
        <span class="risk-pill-anchor">💡</span>
        <div class="risk-pill-content">
          <strong>Kuncinya</strong>
          <span>Kenali pola ini lebih awal dan putus siklusnya sebelum berdampak luas</span>
        </div>
      </div>
    </div>
    <div class="risk-funfact">
      <span class="risk-funfact-icon">📎</span>
      <div class="risk-funfact-content">
        <span>Sektor restoran & akomodasi konsisten mencatat <strong>tingkat turnover tertinggi</strong> di antara seluruh industri.</span>
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
