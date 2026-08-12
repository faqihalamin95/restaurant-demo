---
title: Performa Pegawai
sidebar_link: false
---
<script>
  let worstBranch = null;
  let bestBranch = null;
  let macroLaborCost = 0;
  let activeTier = 0; // 1: <15, 2: 15-20, 3: 20-30, 4: 30-35, 5: >35

  $: if (branch_labor_cost && branch_labor_cost.length > 0) {
      let sorted = [...branch_labor_cost].sort((a,b) => b.labor_cost_pct - a.labor_cost_pct);
      worstBranch = sorted[0]; 
      bestBranch = sorted[sorted.length - 1]; 
      
      let totalRev = branch_labor_cost.reduce((acc, curr) => acc + curr.total_revenue, 0);
      let totalPay = branch_labor_cost.reduce((acc, curr) => acc + curr.total_payroll, 0);
      macroLaborCost = totalRev > 0 ? (totalPay / totalRev) * 100 : 0;

      if (macroLaborCost > 35) activeTier = 5;
      else if (macroLaborCost > 30) activeTier = 4;
      else if (macroLaborCost < 15) activeTier = 1;
      else if (macroLaborCost < 20) activeTier = 2;
      else activeTier = 3;
  }
</script>

<EmployeeTabs activeTab="payroll" />

<div class="diagnostics-header" style="margin-top: 24px; margin-bottom: 24px;">
  <div class="diagnostics-eyebrow">🧠 DIAGNOSTIK UTAMA</div>
  <h2 class="diagnostics-title">Sintesis Efisiensi & Produktivitas Makro</h2>
  <p class="diagnostics-copy">Evaluasi menyeluruh terhadap kapasitas operasional, profitabilitas tenaga kerja, dan kesehatan struktural beban gaji bulan ini.</p>
</div>

```sql branch_labor_cost
WITH max_d AS (SELECT MAX(metric_date) AS d FROM restaurant.daily_net_revenue)
SELECT 
  branch_name,
  SUM(gross_revenue) as total_revenue,
  SUM(labor_total_cost) as total_payroll,
  ROUND(SUM(labor_total_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) as labor_cost_pct,
  ROUND(SUM(gross_revenue) / NULLIF(SUM(labor_total_cost), 0), 2) as roi_multiplier,
  CASE
    WHEN ROUND(SUM(labor_total_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) > 30 THEN 
        SUM(labor_total_cost) - (SUM(gross_revenue) * 0.30)
    WHEN ROUND(SUM(labor_total_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) < 20 THEN 
        (SUM(gross_revenue) * 0.20) - SUM(labor_total_cost)
    ELSE 0
  END as variance_rp,
  CASE
    WHEN ROUND(SUM(labor_total_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) > 35 THEN '📉 Pemborosan'
    WHEN ROUND(SUM(labor_total_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) > 30 THEN '⚠️ Pantau Atas'
    WHEN ROUND(SUM(labor_total_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) < 15 THEN '🔥 Risiko Kritis'
    WHEN ROUND(SUM(labor_total_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) < 20 THEN '👀 Pantau Bawah'
    ELSE '⭐ Zona Ideal'
  END as variance_status
FROM restaurant.daily_net_revenue CROSS JOIN max_d
WHERE metric_date >= max_d.d - INTERVAL '29 days'
GROUP BY branch_name
ORDER BY labor_cost_pct DESC
```

```sql overtime_risk
SELECT 
  branch_name,
  total_overtime_hours,
  avg_overtime_per_person,
  overtime_session_pct,
  absent_count,
  late_count,
  pressure_score,
  CASE 
    WHEN pressure_score > 25 THEN '🔥 Burnout Kritis'
    WHEN pressure_score > 15 THEN '⚠️ Waspada'
    ELSE '⭐ Sehat'
  END as risk_status
FROM restaurant.overtime_by_branch_period
WHERE period = '30d'
ORDER BY pressure_score DESC
```

{#if worstBranch && bestBranch}
<div class="insight-container" style="margin-bottom: 48px;">
  <div class="insight-box {macroLaborCost > 35 || macroLaborCost < 15 ? 'red' : (macroLaborCost > 30 || macroLaborCost < 20 ? 'orange' : 'green')}">
    <div class="insight-headline">
        {#if macroLaborCost > 35}
            🚨 Kritis: Pemborosan Gaji Fatal ({macroLaborCost.toFixed(1)}%)
        {:else if macroLaborCost > 30}
            ⚠️ Peringatan: Beban Gaji Mulai Tinggi ({macroLaborCost.toFixed(1)}%)
        {:else if macroLaborCost < 15}
            🚨 Kritis: Kekurangan Staf Ekstrem ({macroLaborCost.toFixed(1)}%)
        {:else if macroLaborCost < 20}
            ⚠️ Peringatan: Staf Mulai Kewalahan ({macroLaborCost.toFixed(1)}%)
        {:else}
            ✅ Ideal: Pengeluaran Gaji Seimbang ({macroLaborCost.toFixed(1)}%)
        {/if}
    </div>
    <div class="insight-copy">
        {#if macroLaborCost > 35}
            Bulan ini, rata-rata rasio gaji membengkak di atas batas kritis (35%). Secara perhitungan, ini menandakan pemborosan besar karena terlalu banyak pekerja dibandingkan pesanan. Beban tertinggi terlihat di <strong>{worstBranch.branch_name} ({worstBranch.labor_cost_pct}%)</strong>. <br/><br/>
            <strong>Saran:</strong> Pertimbangkan untuk memangkas jam kerja staf paruh waktu (part-time) segera. <em>(Catatan: Angka ini hanya alat bantu. Pastikan kecocokannya dengan kondisi asli di restoran).</em>
        {:else if macroLaborCost > 30}
            Bulan ini, rata-rata rasio gaji mulai melewati batas wajar (20-30%). Jika dibiarkan, pengeluaran gaji perlahan akan menggerogoti keuntungan restoran. Angka tertinggi terlihat di <strong>{worstBranch.branch_name} ({worstBranch.labor_cost_pct}%)</strong>. <br/><br/>
            <strong>Saran:</strong> Pertimbangkan untuk menyetop lembur yang tidak perlu. <em>(Catatan: Angka ini hanya alat bantu. Pastikan kecocokannya dengan kondisi asli di restoran).</em>
        {:else if macroLaborCost < 15}
            Rata-rata rasio gaji turun drastis menyentuh batas kritis di bawah 15%. Ini pertanda restoran sangat kekurangan staf, yang bisa memicu karyawan kelelahan ekstrim dan keluhan pelanggan. Hal ini paling parah di <strong>{bestBranch.branch_name} ({bestBranch.labor_cost_pct}%)</strong>. <br/><br/>
            <strong>Saran:</strong> Pertimbangkan untuk segera merekrut atau menambah karyawan baru. <em>(Catatan: Angka ini hanya alat bantu. Pastikan kecocokannya dengan kondisi asli di restoran).</em>
        {:else if macroLaborCost < 20}
            Rata-rata rasio gaji terlihat cukup rendah (<strong>{macroLaborCost.toFixed(1)}%</strong>). Walau menguntungkan secara keuangan, angka di bawah 20% bisa memicu kelelahan staf dan antrean panjang. Ini mulai terlihat di <strong>{bestBranch.branch_name} ({bestBranch.labor_cost_pct}%)</strong>. <br/><br/>
            <strong>Saran:</strong> Pertimbangkan untuk menyiapkan opsi pekerja tambahan (part-time) untuk berjaga-jaga saat ramai. <em>(Catatan: Angka ini hanya alat bantu. Pastikan kecocokannya dengan kondisi asli di restoran).</em>
        {:else}
            Rata-rata rasio gaji berada di angka <strong>{macroLaborCost.toFixed(1)}%</strong>. Angka ini sangat pas, artinya pengeluaran untuk bayar gaji sudah seimbang dengan pemasukan restoran. <br/><br/>
            <strong>Saran:</strong> Pertahankan jadwal kerja yang ada saat ini. <em>(Catatan: Terus pantau kenyamanan kerja karyawan di lapangan).</em>
        {/if}

        <div class="macro-progress-container">
           <div class="progress-labels">
             <span>0%</span>
             <span>15%</span>
             <span>20%</span>
             <span>30%</span>
             <span>35%</span>
             <span>50%</span>
           </div>
           <div class="macro-progress-bar">
             <div class="zone" style="width: 30%; background: #fecaca;"></div>
             <div class="zone" style="width: 10%; background: #fed7aa;"></div>
             <div class="zone" style="width: 20%; background: #bbf7d0;"></div>
             <div class="zone" style="width: 10%; background: #fed7aa;"></div>
             <div class="zone" style="width: 30%; background: #fecaca;"></div>
             <div class="macro-marker" style="left: {Math.min(macroLaborCost / 50 * 100, 100)}%;">
               <div class="macro-marker-pin">📍 {macroLaborCost.toFixed(1)}%</div>
               <div class="macro-marker-line"></div>
             </div>
           </div>
        </div>
    </div>
  </div>
</div>
{/if}

<div style="margin-bottom: 64px;">
  <div style="font-weight: 700; color: var(--color-text-primary); margin-bottom: 24px; font-size: 1.1rem; text-align: center;">Sistem Peringatan Dini (Zona Efisiensi Gaji)</div>
  <div class="insight-grid" style="grid-template-columns: repeat(5, minmax(0, 1fr)); gap: 12px; padding: 12px 0;">
    
    <div class="insight-card target-card red {activeTier === 1 ? 'active-tier' : 'inactive-tier'}">
      <div class="insight-header" style="flex-direction: column; text-align: center; gap: 4px;">
        <span class="insight-icon">🔥</span>
        <span class="insight-title" style="font-size: 0.85rem;">Risiko Kritis (&lt;15%)</span>
      </div>
      <div class="insight-body" style="font-size: 0.8rem; text-align: center; color: var(--color-text-secondary); line-height: 1.4; margin-top: 8px;">
        Staf kurang. Segera tambah orang.
      </div>
    </div>

    <div class="insight-card target-card orange {activeTier === 2 ? 'active-tier' : 'inactive-tier'}">
      <div class="insight-header" style="flex-direction: column; text-align: center; gap: 4px;">
        <span class="insight-icon">👀</span>
        <span class="insight-title" style="font-size: 0.85rem;">Pantau Bawah (15-20%)</span>
      </div>
      <div class="insight-body" style="font-size: 0.8rem; text-align: center; color: var(--color-text-secondary); line-height: 1.4; margin-top: 8px;">
        Rentan kewalahan. Siapkan part-time.
      </div>
    </div>

    <div class="insight-card target-card green {activeTier === 3 ? 'active-tier' : 'inactive-tier'}">
      <div class="insight-header" style="flex-direction: column; text-align: center; gap: 4px;">
        <span class="insight-icon">⭐</span>
        <span class="insight-title" style="font-size: 0.85rem;">Zona Ideal (20-30%)</span>
      </div>
      <div class="insight-body" style="font-size: 0.8rem; text-align: center; color: var(--color-text-secondary); line-height: 1.4; margin-top: 8px;">
        Seimbang. Pertahankan jadwal.
      </div>
    </div>

    <div class="insight-card target-card orange {activeTier === 4 ? 'active-tier' : 'inactive-tier'}">
      <div class="insight-header" style="flex-direction: column; text-align: center; gap: 4px;">
        <span class="insight-icon">⚠️</span>
        <span class="insight-title" style="font-size: 0.85rem;">Pantau Atas (30-35%)</span>
      </div>
      <div class="insight-body" style="font-size: 0.8rem; text-align: center; color: var(--color-text-secondary); line-height: 1.4; margin-top: 8px;">
        Beban naik. Setop lembur.
      </div>
    </div>

    <div class="insight-card target-card red {activeTier === 5 ? 'active-tier' : 'inactive-tier'}">
      <div class="insight-header" style="flex-direction: column; text-align: center; gap: 4px;">
        <span class="insight-icon">📉</span>
        <span class="insight-title" style="font-size: 0.85rem;">Pemborosan (&gt;35%)</span>
      </div>
      <div class="insight-body" style="font-size: 0.8rem; text-align: center; color: var(--color-text-secondary); line-height: 1.4; margin-top: 8px;">
        Terlalu banyak staf. Pangkas part-time.
      </div>
    </div>

  </div>
</div>

<hr style="margin: 48px 0; border: 0; border-top: 1px dashed rgba(0,0,0,0.1);" />

<div class="diagnostics-header" style="margin-bottom: 24px;">
  <div class="diagnostics-eyebrow">🔬 ANALISIS PENDUKUNG (DEEP-DIVE)</div>
  <h2 class="diagnostics-title">Bedah Kapasitas & Profitabilitas Cabang</h2>
  <p class="diagnostics-copy">Membedah metrik beban pengeluaran payroll per cabang secara mendetail.</p>
</div>

<!-- Main Financial Variance Table -->
<div style="margin-top: 32px; margin-bottom: 48px;">
      
      <!-- Visualization Card for Context -->
      <div class="interactive-card" style="background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 16px; padding: 20px; margin-bottom: 24px; position: relative; box-shadow: 0 4px 6px rgba(0,0,0,0.02);">
        <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 16px;">
          <div style="position: relative;">
            <div style="font-size: 1.4rem; height: 40px; width: 40px; display: flex; align-items: center; justify-content: center; background: white; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.05);">💡</div>
          </div>
          <div style="font-weight: 800; color: var(--color-text-primary); font-size: 1.05rem;">Konteks Data & Cara Membaca</div>
        </div>
        <div style="font-size: 0.95rem; color: var(--color-text-secondary); line-height: 1.6; margin-bottom: 12px;">
          Jika metrik di atas mengevaluasi kesehatan restoran <strong>secara keseluruhan</strong> (Makro), tabel di bawah membedah masalah tersebut <strong>ke masing-masing cabang</strong> (Mikro). Angka Rupiah yang muncul adalah target finansial yang bisa Anda selamatkan atau pakai untuk alokasi <i>hiring</i>.
        </div>
        <div style="background: white; border: 1px dashed #cbd5e1; border-radius: 8px; padding: 12px 16px; font-size: 0.85rem; color: var(--color-text-tertiary); line-height: 1.5;">
          <strong style="color: var(--color-text-primary);">Contoh Pembacaan:</strong> Jika cabang memiliki Nilai Varian <strong>Rp 5.000.000</strong> dengan status 📉 <em>Pemborosan</em>, artinya Anda ditargetkan untuk <strong>memangkas jam lembur</strong> senilai 5 juta bulan ini. Jika statusnya 🔥 <em>Risiko Kritis</em>, pakai dana 5 juta tersebut untuk <strong>merekrut pekerja tambahan</strong>.
        </div>
      </div>

      <!-- Custom Premium Table -->
      <div class="premium-table-container">
        <table class="premium-table">
          <thead>
            <tr>
              <th>Cabang</th>
              <th style="text-align: center;">Rasio Gaji (%)</th>
              <th>Status Kesehatan</th>
              <th style="text-align: right;">Nilai Varian (Rp)</th>
            </tr>
          </thead>
          <tbody>
            {#each branch_labor_cost as row, i}
              <tr class="premium-row">
                <td style="font-weight: 700; color: var(--color-text-primary);">{row.branch_name}</td>
                <td style="text-align: center; font-weight: 600;">{row.labor_cost_pct}%</td>
                <td>
                  {#if row.labor_cost_pct > 35}
                    <span class="badge badge-red">{row.variance_status}</span>
                  {:else if row.labor_cost_pct > 30}
                    <span class="badge badge-orange">{row.variance_status}</span>
                  {:else if row.labor_cost_pct < 15}
                    <span class="badge badge-red">{row.variance_status}</span>
                  {:else if row.labor_cost_pct < 20}
                    <span class="badge badge-orange">{row.variance_status}</span>
                  {:else}
                    <span class="badge badge-green">{row.variance_status}</span>
                  {/if}
                </td>
                <td style="text-align: right; font-weight: 800; color: var(--color-text-primary);" class="hover-tooltip {i < branch_labor_cost.length / 2 ? 'tooltip-down' : 'tooltip-up'}">
                  <span class="tooltip-text">
                    {#if row.labor_cost_pct > 35}
                      Biaya gaji berlebih. Pertimbangkan memangkas jam lembur senilai angka ini agar rasio kembali ideal.
                    {:else if row.labor_cost_pct > 30}
                      Beban biaya mulai naik. Evaluasi kembali alokasi jadwal lembur untuk menekan angka ini.
                    {:else if row.labor_cost_pct < 15}
                      Rasio gaji sangat rendah. Dana ini dapat dialokasikan untuk rekrutmen demi menjaga kualitas pelayanan.
                    {:else if row.labor_cost_pct < 20}
                      Kapasitas staf cukup padat. Dana ini aman digunakan jika cabang membutuhkan <i>part-time</i> tambahan.
                    {:else}
                      Alokasi dana dan penjadwalan staf berada pada tingkat efisiensi yang optimal.
                    {/if}
                  </span>
                  {#if row.variance_rp != null && row.variance_rp !== 0}
                    {#if row.labor_cost_pct > 30}
                      <span style="color: #ef4444; font-size: 0.75rem; margin-right: 4px; vertical-align: middle;">▼</span>
                    {:else if row.labor_cost_pct < 20}
                      <span style="color: #22c55e; font-size: 0.75rem; margin-right: 4px; vertical-align: middle;">▲</span>
                    {/if}
                    Rp {Number(row.variance_rp).toLocaleString('id-ID')}
                  {:else}
                    -
                  {/if}
                </td>
              </tr>
            {/each}
          </tbody>
        </table>
      </div>

    </div>

<style>
.insight-container {
  display: flex;
  flex-direction: column;
}
.insight-box {
  padding: 24px 32px;
  border-radius: 12px;
  border-left: 4px solid transparent;
}
.insight-box.blue {
  background-color: #eff6ff;
  border-left-color: #3b82f6;
}
.insight-box.red {
  background-color: #fef2f2;
  border-left-color: #ef4444;
}
.insight-box.orange {
  background-color: #fff7ed;
  border-left-color: #f97316;
}
.insight-box.green {
  background-color: #f0fdf4;
  border-left-color: #22c55e;
}
.insight-headline {
  font-weight: 800;
  font-size: 1.25rem;
  margin-bottom: 12px;
  color: var(--color-text-primary);
}
.insight-copy {
  font-size: 1rem;
  line-height: 1.7;
  color: var(--color-text-secondary);
}

/* Custom Progress Bar CSS */
.macro-progress-container {
  width: 100%;
  margin-top: 48px;
  margin-bottom: 12px;
  padding: 0 12px;
}
.progress-labels {
  display: flex;
  justify-content: space-between;
  font-size: 0.75rem;
  font-weight: 700;
  margin-bottom: 8px;
  color: var(--color-text-tertiary, #9ca3af);
  text-transform: uppercase;
  letter-spacing: 0.05em;
}
.macro-progress-bar {
  display: flex;
  height: 14px;
  width: 100%;
  border-radius: 8px;
  overflow: visible;
  position: relative;
  background: #f3f4f6;
  box-shadow: inset 0 2px 4px rgba(0,0,0,0.05);
}
.macro-progress-bar .zone {
  height: 100%;
}
.macro-progress-bar .zone:first-child { border-radius: 8px 0 0 8px; }
.macro-progress-bar .zone:last-child { border-radius: 0 8px 8px 0; }
.macro-marker {
  position: absolute;
  top: -30px;
  transform: translateX(-50%);
  display: flex;
  flex-direction: column;
  align-items: center;
  z-index: 10;
  transition: left 0.5s cubic-bezier(0.4, 0, 0.2, 1);
}
.macro-marker-pin {
  background: var(--color-text-primary, #111827);
  color: white;
  padding: 4px 10px;
  border-radius: 6px;
  font-size: 0.8rem;
  font-weight: 800;
  box-shadow: 0 4px 12px rgba(0,0,0,0.15);
  white-space: nowrap;
}
.macro-marker-line {
  width: 2px;
  height: 20px;
  background: var(--color-text-primary, #111827);
  border-radius: 1px;
}

/* 5 Cards CSS */
.insight-grid {
  display: grid;
  gap: 16px;
}
.insight-card {
  padding: 20px 16px;
  background: #ffffff;
  border-radius: 12px;
  border: 1px solid var(--color-border-tertiary);
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
}
.inactive-tier {
  opacity: 0.45;
  filter: grayscale(80%);
  transform: scale(0.96);
}
.inactive-tier:hover {
  opacity: 0.8;
  filter: grayscale(0%);
}
.active-tier {
  opacity: 1;
  transform: scale(1.05);
  z-index: 10;
  background: #ffffff;
  box-shadow: 0 12px 30px -5px rgba(0, 0, 0, 0.15), 0 8px 10px -6px rgba(0, 0, 0, 0.1);
}
.active-tier::before {
  content: "📍 POSISI SAAT INI";
  position: absolute;
  top: -14px;
  left: 50%;
  transform: translateX(-50%);
  background: var(--color-text-primary, #111827);
  color: white;
  font-size: 0.65rem;
  font-weight: 800;
  padding: 4px 12px;
  border-radius: 12px;
  letter-spacing: 0.05em;
  white-space: nowrap;
  box-shadow: 0 4px 6px rgba(0,0,0,0.1);
}
.active-tier.green { border: 2px solid #22c55e; box-shadow: 0 12px 30px rgba(34, 197, 94, 0.25); }
.active-tier.orange { border: 2px solid #f97316; box-shadow: 0 12px 30px rgba(249, 115, 22, 0.25); }
.active-tier.red { border: 2px solid #ef4444; box-shadow: 0 12px 30px rgba(239, 68, 68, 0.25); }
.insight-header {
  display: flex;
  align-items: center;
  gap: 12px;
}
.insight-icon {
  font-size: 1.8rem;
  margin-bottom: 4px;
}
.insight-title {
  font-weight: 800;
  color: var(--color-text-primary);
  font-size: 1.05rem;
}
@media (max-width: 1024px) {
  .insight-grid { grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)) !important; }
}

/* Callout Box CSS */
.variance-callout {
  background: linear-gradient(to right, rgba(15, 118, 110, 0.04), transparent);
  border-left: 4px solid #0f766e;
  padding: 16px 24px;
  border-radius: 0 12px 12px 0;
  margin-bottom: 24px;
}
.variance-callout-header {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 12px;
  color: var(--color-text-primary);
}
.variance-callout-list {
  margin: 0;
  padding-left: 28px;
  color: var(--color-text-secondary);
  font-size: 0.95rem;
  line-height: 1.7;
}

/* Premium Custom Table CSS */
.premium-table-container {
  overflow-x: auto;
  border-radius: 12px;
  border: 1px solid var(--color-border-tertiary);
  box-shadow: 0 4px 12px rgba(0,0,0,0.02);
  background: #f8fafc;
  margin-bottom: 32px;
}
.premium-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 0.95rem;
}
.premium-table th {
  text-align: left;
  padding: 16px 20px;
  background: #f1f5f9;
  color: var(--color-text-secondary);
  font-weight: 800;
  font-size: 0.85rem;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  border-bottom: 1px solid #e2e8f0;
}
.premium-row {
  transition: all 0.2s ease;
  border-bottom: 1px solid #e2e8f0;
  background: #f8fafc;
}
.premium-row:hover {
  background: #f1f5f9;
}
.premium-row td {
  padding: 16px 20px;
  color: var(--color-text-secondary);
}
.premium-row:last-child {
  border-bottom: none;
}

/* Badges */
.badge {
  display: inline-flex;
  align-items: center;
  padding: 4px 12px;
  border-radius: 16px;
  font-size: 0.85rem;
  font-weight: 700;
}
.badge-red {
  background: #fef2f2;
  color: #ef4444;
  border: 1px solid #fee2e2;
}
.badge-blue {
  background: #eff6ff;
  color: #3b82f6;
  border: 1px solid #dbeafe;
}
.badge-green {
  background: #f0fdf4;
  color: #22c55e;
  border: 1px solid #dcfce7;
}
.badge-orange {
  background: #fff7ed;
  color: #ea580c;
  border: 1px solid #ffedd5;
}

.hover-tooltip {
  position: relative;
  cursor: help;
}
.hover-tooltip .tooltip-text {
  visibility: hidden;
  width: max-content;
  max-width: 220px;
  background-color: #1e293b;
  color: #fff;
  text-align: center;
  border-radius: 8px;
  padding: 8px 12px;
  position: absolute;
  z-index: 10;
  bottom: 125%;
  right: 0;
  opacity: 0;
  transition: opacity 0.2s ease-in-out, transform 0.2s ease-in-out;
  transform: translateY(4px);
  font-size: 0.75rem;
  font-weight: 600;
  box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -4px rgba(0, 0, 0, 0.1);
  pointer-events: none;
}
.hover-tooltip .tooltip-text::after {
  content: "";
  position: absolute;
  top: 100%;
  right: 15px;
  border-width: 5px;
  border-style: solid;
  border-color: #1e293b transparent transparent transparent;
}
.hover-tooltip:hover .tooltip-text {
  visibility: visible;
  opacity: 1;
  transform: translateY(0);
}

/* Smart Tooltip Placement based on dynamic half */
.hover-tooltip.tooltip-down .tooltip-text {
  bottom: auto;
  top: 125%;
  transform: translateY(-4px);
}
.hover-tooltip.tooltip-down:hover .tooltip-text {
  transform: translateY(0);
}
.hover-tooltip.tooltip-down .tooltip-text::after {
  top: auto;
  bottom: 100%;
  border-color: transparent transparent #1e293b transparent;
}

/* Leaderboard CSS */
.leaderboard-container {
  background: white;
  border-radius: 16px;
  border: 1px solid var(--color-border-tertiary);
  padding: 24px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.02);
}
.leaderboard-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
}
.leaderboard-card {
  display: flex;
  align-items: center;
  gap: 20px;
  padding: 16px;
  border-radius: 12px;
  background: #f8fafc;
  border: 1px solid #e2e8f0;
  transition: transform 0.2s, box-shadow 0.2s;
}
.leaderboard-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 12px rgba(0,0,0,0.04);
  background: white;
}
.lb-rank {
  font-size: 1.8rem;
  width: 40px;
  text-align: center;
  flex-shrink: 0;
}
.lb-content {
  flex-grow: 1;
}
.lb-branch {
  font-size: 1.1rem;
  font-weight: 800;
  color: var(--color-text-primary);
  margin-bottom: 4px;
}
.lb-desc {
  font-size: 0.85rem;
  color: var(--color-text-secondary);
}
.lb-score {
  font-size: 1.5rem;
  font-weight: 900;
  letter-spacing: -0.02em;
}
.score-green { color: #16a34a; }
.score-orange { color: #ea580c; }
.score-red { color: #dc2626; }

.lb-bar-bg {
  height: 8px;
  background: #e2e8f0;
  border-radius: 4px;
  overflow: hidden;
  width: 100%;
}
.lb-bar-fill {
  height: 100%;
  border-radius: 4px;
  transition: width 1s ease-out;
}
.fill-green { background: linear-gradient(90deg, #22c55e, #16a34a); }
.fill-orange { background: linear-gradient(90deg, #f97316, #ea580c); }
.fill-red { background: linear-gradient(90deg, #ef4444, #dc2626); }
</style>
