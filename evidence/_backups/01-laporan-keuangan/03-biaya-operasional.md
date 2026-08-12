---
title: Laporan Keuangan
sidebar_link: false
---

<FinanceTabs activeTab="operasional" />

```sql ops_kpi
SELECT 
  SUM(operational_total_cost)/SUM(gross_revenue)*100 as ops_pct_30d
FROM restaurant.daily_net_revenue
WHERE metric_date >= (SELECT MAX(metric_date) FROM restaurant.daily_net_revenue) - INTERVAL '29 days'
```

```sql ops_by_branch
WITH max_d AS (SELECT MAX(metric_date)::DATE AS d FROM restaurant.daily_net_revenue)
SELECT 
  branch_name,
  SUM(gross_revenue) as total_rev,
  SUM(operational_total_cost) as total_ops,
  ROUND(SUM(operational_total_cost)/SUM(gross_revenue)*100, 1) as ops_pct
FROM restaurant.daily_net_revenue CROSS JOIN max_d
WHERE metric_date >= max_d.d - INTERVAL '29 days'
GROUP BY branch_name
ORDER BY ops_pct DESC
```

<script>
  let activeOpsBranch = 'Semua Cabang';
  let worstBranch = { branch_name: "N/A", ops_pct: 0 };
  let bestBranch = null;
  let macroOpsPct = 0;
  let activeTier = 0;
  let enrichedBranches = [];

  $: if (ops_by_branch && ops_by_branch.length > 0) {
      let sorted = [...ops_by_branch].sort((a,b) => b.ops_pct - a.ops_pct);
      worstBranch = sorted[0]; 
      bestBranch = sorted[sorted.length - 1]; 
      
      enrichedBranches = sorted.map(row => {
        let targetOps = row.total_rev * 0.30;
        let varianceRp = row.total_ops - targetOps;
        let varianceStatus = "⭐ Zona Ideal";
        if (row.ops_pct > 35) varianceStatus = "📉 Pemborosan";
        else if (row.ops_pct > 30) varianceStatus = "⚠️ Pantau Atas";
        else if (row.ops_pct < 25) varianceStatus = "👀 Pantau Bawah";
        
        return {
          ...row,
          variance_status: varianceStatus,
          variance_rp: varianceRp
        };
      });
  }

  $: if (ops_kpi && ops_kpi.length > 0) {
      macroOpsPct = ops_kpi[0].ops_pct_30d;
      if (macroOpsPct < 25) {
        activeTier = 2; // Minim
      } else if (macroOpsPct <= 30) {
        activeTier = 3; // Ideal
      } else if (macroOpsPct <= 35) {
        activeTier = 4; // Pantau
      } else {
        activeTier = 5; // Bahaya
      }
  }
</script>

{#if worstBranch && bestBranch && ops_kpi}
<div class="diagnostics-header" style="margin-top: 24px; margin-bottom: 24px;">
  <div class="diagnostics-eyebrow">🧠 DIAGNOSTIK UTAMA</div>
  <h2 class="diagnostics-title">Sintesis Efisiensi Operasional Makro</h2>
  <p class="diagnostics-copy">Evaluasi menyeluruh terhadap batas aman pengeluaran utilitas, biaya tetap, dan kesehatan anggaran operasional restoran bulan ini.</p>
</div>

<div class="insight-container" style="margin-bottom: 48px;">
  <div class="insight-box {macroOpsPct > 35 ? 'red' : (macroOpsPct > 30 || macroOpsPct < 25 ? 'orange' : 'green')}">
    <div class="insight-headline">
        {#if macroOpsPct > 35}
            🚨 Kritis: Pemborosan Utilitas & Operasional ({macroOpsPct.toFixed(1)}%)
        {:else if macroOpsPct > 30}
            ⚠️ Waspada: Beban Operasional Membengkak ({macroOpsPct.toFixed(1)}%)
        {:else if macroOpsPct >= 25}
            ✅ Ideal: Pengeluaran Operasional Efisien ({macroOpsPct.toFixed(1)}%)
        {:else}
            👀 Pantau: Biaya Operasional Terlalu Minim ({macroOpsPct.toFixed(1)}%)
        {/if}
    </div>
    <div class="insight-copy">
        {#if macroOpsPct > 35}
            <p style="margin-top: 0; margin-bottom: 12px;">Bulan ini, rata-rata rasio operasional sangat tinggi (<strong>{macroOpsPct.toFixed(1)}%</strong>). Angka di atas batas kritis 35% mengindikasikan lonjakan ekstrem pada tagihan utilitas atau pengeluaran tetap lainnya. Kondisi terparah saat ini terjadi di <strong>{worstBranch.branch_name} ({worstBranch.ops_pct}%)</strong>.</p>
            <p style="margin: 0;"><strong>Saran:</strong> Segera lakukan audit utilitas dan tekan pengeluaran promosi yang tidak memberikan ROI positif. <em>(Catatan: Angka ini hanya alat bantu. Pastikan kecocokannya dengan kondisi asli di restoran).</em></p>
        {:else if macroOpsPct > 30}
            <p style="margin-top: 0; margin-bottom: 12px;">Rata-rata rasio operasional terlihat mulai membengkak (<strong>{macroOpsPct.toFixed(1)}%</strong>). Walau masih dalam batas toleransi, angka di atas batas standar 30% berisiko menekan margin bersih. Ini mulai terlihat di <strong>{worstBranch.branch_name} ({worstBranch.ops_pct}%)</strong>.</p>
            <p style="margin: 0;"><strong>Saran:</strong> Perketat kontrol pemakaian utilitas (AC, lampu) dan tunda pengeluaran operasional non-esensial. <em>(Catatan: Angka ini hanya alat bantu. Pastikan kecocokannya dengan kondisi asli di restoran).</em></p>
        {:else if macroOpsPct >= 25}
            <p style="margin-top: 0; margin-bottom: 12px;">Pengeluaran utilitas dan biaya tetap sangat sehat (<strong>{macroOpsPct.toFixed(1)}%</strong>) mematuhi batas aman operasional. Prestasi efisiensi operasional terbaik dicapai oleh <strong>{bestBranch.branch_name} ({bestBranch.ops_pct}%)</strong>.</p>
            <p style="margin: 0;"><strong>Saran:</strong> Pertahankan kedisiplinan pemakaian utilitas saat ini tanpa mengorbankan kenyamanan pengunjung. <em>(Catatan: Terus pantau kepuasan pelanggan di lapangan).</em></p>
        {:else}
            <p style="margin-top: 0; margin-bottom: 12px;">Rasio pengeluaran operasional sangat minim (<strong>{macroOpsPct.toFixed(1)}%</strong>), jatuh di bawah standar minimal 25%. Secara laba terlihat menguntungkan, namun bisa berarti AC sering dimatikan, restoran gelap, atau nihil aktivitas promosi. Angka terendah dicatat <strong>{bestBranch.branch_name} ({bestBranch.ops_pct}%)</strong>.</p>
            <p style="margin: 0;"><strong>Saran:</strong> Pastikan kenyamanan pelanggan (suhu ruangan, penerangan, kebersihan) tidak dikorbankan demi menghemat biaya operasional. <em>(Catatan: Angka ini hanya alat bantu. Pastikan kecocokannya dengan kondisi asli di restoran).</em></p>
        {/if}

        <div class="macro-progress-container">
           <div class="progress-labels">
             <span>0%</span>
             <span>25%</span>
             <span>30%</span>
             <span>35%</span>
             <span>50%</span>
           </div>
           <div class="macro-progress-bar">
             <div class="zone" style="width: 50%; background: #fdba74;"></div>
             <div class="zone" style="width: 10%; background: #86efac;"></div>
             <div class="zone" style="width: 10%; background: #fcd34d;"></div>
             <div class="zone" style="width: 30%; background: #fca5a5;"></div>
             <div class="macro-marker" style="left: {macroOpsPct > 50 ? 100 : (macroOpsPct / 50 * 100)}%;">
               <div class="macro-marker-pin">📍 {macroOpsPct.toFixed(1)}%</div>
               <div class="macro-marker-line"></div>
             </div>
           </div>
        </div>
    </div>
  </div>
</div>

<div style="margin-bottom: 64px;">
  <div style="font-weight: 700; color: var(--color-text-primary); margin-bottom: 24px; font-size: 1.1rem; text-align: center;">Sistem Peringatan Dini (Zona Operasional)</div>
  <div class="insight-grid" style="grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 12px; padding: 12px 0;">
    
    <div class="insight-card target-card orange {activeTier === 2 ? 'active-tier' : 'inactive-tier'}">
      <div class="insight-header" style="flex-direction: column; text-align: center; gap: 4px;">
        <span class="insight-icon">👀</span>
        <span class="insight-title" style="font-size: 0.85rem;">Pantau Bawah (&lt;25%)</span>
      </div>
      <div class="insight-body" style="font-size: 0.8rem; text-align: center; color: var(--color-text-secondary); line-height: 1.4; margin-top: 8px;">
        Proporsi di bawah target. Tinjau alokasi biaya pemeliharaan dasar.
      </div>
    </div>
    
    <div class="insight-card target-card green {activeTier === 3 ? 'active-tier' : 'inactive-tier'}">
      <div class="insight-header" style="flex-direction: column; text-align: center; gap: 4px;">
        <span class="insight-icon">⭐</span>
        <span class="insight-title" style="font-size: 0.85rem;">Zona Ideal (25-30%)</span>
      </div>
      <div class="insight-body" style="font-size: 0.8rem; text-align: center; color: var(--color-text-secondary); line-height: 1.4; margin-top: 8px;">
        Pengeluaran efisien. Pertahankan pola operasional saat ini.
      </div>
    </div>
    
    <div class="insight-card target-card orange {activeTier === 4 ? 'active-tier' : 'inactive-tier'}">
      <div class="insight-header" style="flex-direction: column; text-align: center; gap: 4px;">
        <span class="insight-icon">⚠️</span>
        <span class="insight-title" style="font-size: 0.85rem;">Pantau Atas (30-35%)</span>
      </div>
      <div class="insight-body" style="font-size: 0.8rem; text-align: center; color: var(--color-text-secondary); line-height: 1.4; margin-top: 8px;">
        Proporsi meningkat. Tinjau tren tagihan utilitas bulanan.
      </div>
    </div>
    
    <div class="insight-card target-card red {activeTier === 5 ? 'active-tier' : 'inactive-tier'}">
      <div class="insight-header" style="flex-direction: column; text-align: center; gap: 4px;">
        <span class="insight-icon">📉</span>
        <span class="insight-title" style="font-size: 0.85rem;">Pemborosan (&gt;35%)</span>
      </div>
      <div class="insight-body" style="font-size: 0.8rem; text-align: center; color: var(--color-text-secondary); line-height: 1.4; margin-top: 8px;">
        Indikasi inefisiensi. Lakukan audit pengeluaran non-esensial.
      </div>
    </div>

  </div>
</div>

<div class="diagnostics-header" style="margin-bottom: 24px;">
  <div class="diagnostics-eyebrow" style="color: var(--color-text-tertiary); font-weight: 700; font-size: 0.8rem; letter-spacing: 0.05em; margin-bottom: 4px;">PERBANDINGAN CABANG</div>
  <h2 class="diagnostics-title" style="margin: 0; font-size: 1.2rem; font-weight: 800; color: var(--color-text-primary);">Rapor Efisiensi Operasional (30 Hari)</h2>
  <p class="diagnostics-copy" style="margin: 4px 0 0 0; font-size: 0.9rem; color: var(--color-text-secondary);">Target Rasio Biaya Operasional: Idealnya 30% dari Total Pendapatan per cabang.</p>
</div>

<div style="margin-top: 32px; margin-bottom: 48px;">
  <details class="guide-acc" style="margin-top: 16px; margin-bottom: 24px;">
    <summary>💡 Konteks Data & Cara Membaca</summary>
    <div class="guide-body" style="padding: 16px;">
      <p style="margin-top: 4px; margin-bottom: 16px; font-weight: 500; color: var(--color-text-secondary);">
        Jika metrik di atas mengevaluasi kesehatan restoran <strong>secara keseluruhan</strong> (Makro), tabel di bawah membedah masalah tersebut <strong>ke masing-masing cabang</strong> (Mikro). Angka Rupiah yang muncul adalah target finansial yang bisa Anda selamatkan dari beban <i>overhead</i>.
      </p>
      <div class="guide-grid" style="grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 16px; display: grid;">
        <div class="guide-card orange">
          <div class="guide-card-icon">📉</div>
          <div class="guide-card-content">
            <div class="guide-card-label">Status: Pemborosan</div>
            <h4 class="guide-card-title">Target Efisiensi Overhead</h4>
            <p class="guide-card-desc">Jika muncul Nilai Varian <strong>Rp 5.000.000</strong>, artinya Anda ditargetkan untuk <strong>memangkas tagihan utilitas/overhead</strong> senilai 5 juta bulan ini.</p>
          </div>
        </div>
        <div class="guide-card teal">
          <div class="guide-card-icon">✅</div>
          <div class="guide-card-content">
            <div class="guide-card-label">Status: Ideal</div>
            <h4 class="guide-card-title">Batas Aman Tercapai</h4>
            <p class="guide-card-desc">Proporsi operasional berada dalam batas sehat. Fokuskan perhatian pada pemeliharaan AC/mesin rutin agar tetap hemat daya di masa depan.</p>
          </div>
        </div>
      </div>
    </div>
  </details>

  <div class="premium-table-container">
  <table class="premium-table">
    <thead>
      <tr>
        <th>Cabang</th>
        <th style="text-align: center;">% Ops</th>
        <th>Status Kesehatan</th>
        <th style="text-align: right;">Nilai Varian (Rp)</th>
      </tr>
    </thead>
    <tbody>
      {#each enrichedBranches as row, i}
        <tr class="premium-row">
          <td style="font-weight: 700; color: var(--color-text-primary);">{row.branch_name}</td>
          <td style="text-align: center; font-weight: 600;">{row.ops_pct}%</td>
          <td>
            {#if row.ops_pct > 35}
              <span class="badge badge-red">{row.variance_status}</span>
            {:else if row.ops_pct > 30}
              <span class="badge badge-orange">{row.variance_status}</span>
            {:else if row.ops_pct < 25}
              <span class="badge badge-orange">{row.variance_status}</span>
            {:else}
              <span class="badge badge-green">{row.variance_status}</span>
            {/if}
          </td>
          <td style="text-align: right; font-weight: 800; color: var(--color-text-primary);" class="hover-tooltip {i < enrichedBranches.length / 2 ? 'tooltip-down' : 'tooltip-up'}">
            <span class="tooltip-text">
              {#if row.ops_pct > 35}
                Proporsi pengeluaran membengkak. Disarankan untuk meninjau efisiensi penggunaan utilitas.
              {:else if row.ops_pct > 30}
                Tren biaya meningkat. Pantau pola pemakaian operasional harian.
              {:else if row.ops_pct < 25}
                Anggaran ops cukup rendah. Pastikan alokasi pemeliharaan fasilitas tetap terpenuhi.
              {:else}
                Pengeluaran operasional tercatat efisien dan proporsional.
              {/if}
            </span>
            {#if row.variance_rp != null && row.variance_rp !== 0 && row.variance_status !== '⭐ Zona Ideal'}
              {#if row.ops_pct > 30}
                <span style="color: #ef4444; font-size: 0.75rem; margin-right: 4px; vertical-align: middle;">▼</span>
              {:else if row.ops_pct < 25}
                <span style="color: #22c55e; font-size: 0.75rem; margin-right: 4px; vertical-align: middle;">▲</span>
              {/if}
              Rp {Math.round(Math.abs(Number(row.variance_rp))).toLocaleString('id-ID')}
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


```sql ops_composition
WITH max_d AS (SELECT MAX(metric_date)::DATE AS d FROM restaurant.daily_net_revenue),
raw_data AS (
  SELECT branch_name, building_rent_daily, electricity_cost, water_cost, other_utilities_cost, operational_total_cost
  FROM restaurant.daily_net_revenue CROSS JOIN max_d
  WHERE metric_date >= max_d.d - INTERVAL '29 days'
),
agg_branches AS (
  SELECT 
    branch_name,
    SUM(building_rent_daily) as total_rent,
    SUM(electricity_cost) as total_electricity,
    SUM(water_cost) as total_water,
    SUM(other_utilities_cost) as total_other,
    SUM(operational_total_cost) as total_ops
  FROM raw_data
  GROUP BY branch_name
),
agg_all AS (
  SELECT 
    'Semua Cabang' as branch_name,
    SUM(building_rent_daily) as total_rent,
    SUM(electricity_cost) as total_electricity,
    SUM(water_cost) as total_water,
    SUM(other_utilities_cost) as total_other,
    SUM(operational_total_cost) as total_ops
  FROM raw_data
),
combined AS (
  SELECT * FROM agg_all
  UNION ALL
  SELECT * FROM agg_branches
)
SELECT 
  branch_name,
  total_rent,
  total_electricity,
  total_water,
  total_other,
  total_ops,
  ROUND(total_rent / NULLIF(total_ops, 0) * 100, 1) as pct_rent,
  ROUND(total_electricity / NULLIF(total_ops, 0) * 100, 1) as pct_electricity,
  ROUND(total_water / NULLIF(total_ops, 0) * 100, 1) as pct_water,
  ROUND(total_other / NULLIF(total_ops, 0) * 100, 1) as pct_other
FROM combined
ORDER BY CASE WHEN branch_name = 'Semua Cabang' THEN 0 ELSE 1 END, total_ops DESC
```

<hr style="margin: 48px 0; border: 0; border-top: 1px dashed rgba(0,0,0,0.1);" />

<div class="diagnostics-header" style="margin-bottom: 24px;">
  <div class="diagnostics-eyebrow">🧬 STRUKTUR KOMPOSISI BIAYA</div>
  <h2 class="diagnostics-title">Proporsi Biaya Operasional (Sewa vs Listrik vs Air vs Lainnya)</h2>
  <p class="diagnostics-copy">Bedah sumber pembengkakan utilitas atau biaya overhead lainnya untuk mengetahui pos pengeluaran mana yang butuh efisiensi segera.</p>
</div>

<div style="display: flex; gap: 8px; flex-wrap: wrap; margin-bottom: 24px;">
  {#each ops_composition as row}
    {#if row.total_ops !== undefined}
      <button 
        style="padding: 8px 16px; border-radius: 20px; font-size: 0.9rem; font-weight: 600; cursor: pointer; border: 1px solid {activeOpsBranch === row.branch_name ? '#3b82f6' : '#e2e8f0'}; background: {activeOpsBranch === row.branch_name ? '#eff6ff' : '#ffffff'}; color: {activeOpsBranch === row.branch_name ? '#1d4ed8' : '#64748b'}; transition: all 0.2s ease;"
        on:click={() => activeOpsBranch = row.branch_name}
      >
        {row.branch_name}
      </button>
    {/if}
  {/each}
</div>

<div style="display: flex; flex-direction: column; gap: 16px; margin-bottom: 48px;">
  {#each ops_composition as row}
    {#if row.total_ops !== undefined && row.branch_name === activeOpsBranch}
    <div class="interactive-card" style="padding: 20px; background: white; border-radius: 12px; border: 1px solid var(--color-border-primary); box-shadow: 0 1px 3px rgba(0,0,0,0.05);">
      <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 12px;">
        <div style="font-weight: 700; color: var(--color-text-primary); font-size: 1.1rem;">{row.branch_name}</div>
        <div style="font-size: 0.9rem; color: var(--color-text-tertiary); font-weight: 500;">Total Operasional: Rp {Math.round(row.total_ops || 0).toLocaleString('id-ID')}</div>
      </div>
      
      <div style="display: flex; height: 28px; border-radius: 8px; overflow: hidden; margin-bottom: 16px; box-shadow: inset 0 1px 3px rgba(0,0,0,0.1);">
        <div style="width: {row.pct_rent}%; background: linear-gradient(90deg, #3b82f6, #60a5fa); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.75rem; font-weight: 700;" title="Sewa Bangunan: Rp {Math.round(row.total_rent || 0).toLocaleString('id-ID')}">
          {#if row.pct_rent > 5}{row.pct_rent}%{/if}
        </div>
        <div style="width: {row.pct_electricity}%; background: linear-gradient(90deg, #10b981, #34d399); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.75rem; font-weight: 700;" title="Listrik: Rp {Math.round(row.total_electricity || 0).toLocaleString('id-ID')}">
          {#if row.pct_electricity > 5}{row.pct_electricity}%{/if}
        </div>
        <div style="width: {row.pct_water}%; background: linear-gradient(90deg, #f59e0b, #fbbf24); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.75rem; font-weight: 700;" title="Air: Rp {Math.round(row.total_water || 0).toLocaleString('id-ID')}">
          {#if row.pct_water > 5}{row.pct_water}%{/if}
        </div>
        <div style="width: {row.pct_other}%; background: linear-gradient(90deg, #ef4444, #f87171); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.75rem; font-weight: 700;" title="Lain-lain: Rp {Math.round(row.total_other || 0).toLocaleString('id-ID')}">
          {#if row.pct_other > 5}{row.pct_other}%{/if}
        </div>
      </div>
      
      <div style="display: flex; flex-wrap: wrap; gap: 16px; font-size: 0.85rem; color: var(--color-text-secondary);">
        <div style="display: flex; align-items: center; gap: 6px;">
          <div style="width: 12px; height: 12px; border-radius: 3px; background: #3b82f6;"></div>
          <span>Sewa Bangunan <strong>Rp {Math.round(row.total_rent || 0).toLocaleString('id-ID')}</strong></span>
        </div>
        <div style="display: flex; align-items: center; gap: 6px;">
          <div style="width: 12px; height: 12px; border-radius: 3px; background: #10b981;"></div>
          <span>Listrik <strong>Rp {Math.round(row.total_electricity || 0).toLocaleString('id-ID')}</strong></span>
        </div>
        <div style="display: flex; align-items: center; gap: 6px;">
          <div style="width: 12px; height: 12px; border-radius: 3px; background: #f59e0b;"></div>
          <span>Air <strong>Rp {Math.round(row.total_water || 0).toLocaleString('id-ID')}</strong></span>
        </div>
        <div style="display: flex; align-items: center; gap: 6px;">
          <div style="width: 12px; height: 12px; border-radius: 3px; background: #ef4444;"></div>
          <span>Lainnya (Marketing, dsb) <strong>Rp {Math.round(row.total_other || 0).toLocaleString('id-ID')}</strong></span>
        </div>
      </div>
    </div>
    {/if}
  {/each}
</div>

<div class="clean-cta-banner">
  <div class="clean-cta-content">
    <div class="clean-cta-icon">🏢</div>
    <div class="clean-cta-text">
      <h3 class="clean-cta-title">Eksplorasi Detail Performa Cabang</h3>
      <p class="clean-cta-desc">Lacak rincian tagihan utilitas, promosi, dan evaluasi ROI budget marketing di masing-masing cabang.</p>
    </div>
  </div>
  <a href="#" class="clean-cta-button" style="opacity: 0.7; cursor: not-allowed;" title="Modul sedang dalam pengembangan">
    Buka Direktori Performa Cabang ➔
  </a>
</div>
{:else}
  <GlobalLoading />
{/if}

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
  border: 1px solid #e2e8f0;
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
}
.insight-icon {
  font-size: 28px;
  line-height: 1;
}
.insight-title {
  font-weight: 800;
  color: var(--color-text-primary, #111827);
  line-height: 1.2;
}

/* Premium Table CSS */
.premium-table-container {
  overflow-x: auto;
  border-radius: 12px;
  border: 1px solid #e2e8f0;
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
  color: #475569;
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
  color: #475569;
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

/* CTA Banner */
.clean-cta-banner {
  margin-top: 32px;
  margin-bottom: 40px;
  padding: 24px 28px;
  border-radius: 16px;
  background: rgba(13, 148, 136, 0.03);
  border: 1px solid rgba(13, 148, 136, 0.15);
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  justify-content: space-between;
  gap: 24px;
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
  flex: 1;
  min-width: 0;
}

.clean-cta-icon {
  font-size: 2.2rem;
  line-height: 1;
  filter: drop-shadow(0 2px 4px rgba(13, 148, 136, 0.15));
  flex-shrink: 0;
}

.clean-cta-text {
  min-width: 0;
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
  color: #475569;
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
  flex-shrink: 0 !important;
  transition: all 0.2s ease !important;
  box-shadow: 0 2px 6px rgba(13, 148, 136, 0.06) !important;
  line-height: 1 !important;
  margin: 0 !important;
  white-space: nowrap !important;
}

.clean-cta-button:hover {
  background: #f0fdfa !important;
  color: #0f766e !important;
  border-color: #0d9488 !important;
  transform: translateY(-1px) !important;
  box-shadow: 0 4px 12px rgba(13, 148, 136, 0.1) !important;
}
</style>
