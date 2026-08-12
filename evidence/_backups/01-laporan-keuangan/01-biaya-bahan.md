---
title: Laporan Keuangan
sidebar_link: false
---

<FinanceTabs activeTab="bahan" />

<script>
  let activeBahanBranch = 'Semua Cabang';
  let worstBranch = null;
  let bestBranch = null;
  let macroCogsPct = 0;
  let activeTier = 0;

  $: if (cogs_by_branch && cogs_by_branch.length > 0) {
      let sorted = [...cogs_by_branch].sort((a,b) => b.cogs_pct - a.cogs_pct);
      worstBranch = sorted[0]; 
      bestBranch = sorted[sorted.length - 1]; 
  }

  $: if (cogs_kpi && cogs_kpi.length > 0) {
      macroCogsPct = cogs_kpi[0].cogs_pct_30d;
      if (macroCogsPct > 35) activeTier = 5;
      else if (macroCogsPct > 30) activeTier = 4;
      else if (macroCogsPct >= 25) activeTier = 3;
      else activeTier = 2;
  }
</script>

```sql cogs_kpi
WITH date_boundaries AS (
  SELECT 
    DATE_TRUNC('month', MAX(metric_date)::DATE) AS start_mtd,
    MAX(metric_date)::DATE - INTERVAL '29 days' AS start_30d
  FROM restaurant.daily_net_revenue
)
SELECT
  SUM(CASE WHEN metric_date >= b.start_30d THEN inventory_usage_cost ELSE 0 END) AS cogs_30d,
  SUM(CASE WHEN metric_date >= b.start_30d THEN gross_revenue ELSE 0 END) AS rev_30d,
  ROUND(SUM(CASE WHEN metric_date >= b.start_30d THEN inventory_usage_cost ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= b.start_30d THEN gross_revenue ELSE 0 END),0) * 100, 1) as cogs_pct_30d,
  SUM(CASE WHEN metric_date >= b.start_mtd THEN inventory_usage_cost ELSE 0 END) AS cogs_mtd,
  ROUND(SUM(CASE WHEN metric_date >= b.start_mtd THEN inventory_usage_cost ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= b.start_mtd THEN gross_revenue ELSE 0 END),0) * 100, 1) as cogs_pct_mtd
FROM restaurant.daily_net_revenue CROSS JOIN date_boundaries b
```


```sql cogs_by_category
WITH max_d AS (SELECT MAX(txn_date)::DATE AS d FROM restaurant.inventory_stok)
SELECT 
  category,
  SUM(usage_cost) AS total_cogs
FROM restaurant.inventory_stok CROSS JOIN max_d
WHERE txn_date >= max_d.d - INTERVAL '29 days'
GROUP BY category
ORDER BY total_cogs DESC
```

```sql cogs_by_branch
WITH max_d AS (SELECT MAX(txn_date)::DATE AS d FROM restaurant.inventory_stok),
branch_cogs AS (
  SELECT 
    branch_name,
    SUM(usage_cost) AS total_cogs
  FROM restaurant.inventory_stok CROSS JOIN max_d
  WHERE txn_date >= max_d.d - INTERVAL '29 days'
  GROUP BY branch_name
),
date_boundaries AS (
  SELECT MAX(metric_date)::DATE - INTERVAL '29 days' AS start_30d
  FROM restaurant.daily_net_revenue
),
branch_rev AS (
  SELECT
    branch_name,
    SUM(gross_revenue) AS total_rev
  FROM restaurant.daily_net_revenue CROSS JOIN date_boundaries b
  WHERE metric_date >= b.start_30d
  GROUP BY branch_name
)
SELECT 
  c.branch_name,
  c.total_cogs,
  r.total_rev,
  ROUND(c.total_cogs / NULLIF(r.total_rev, 0) * 100, 1) AS cogs_pct,
  CASE
    WHEN ROUND(c.total_cogs / NULLIF(r.total_rev, 0) * 100, 1) > 35 THEN '📉 Pemborosan'
    WHEN ROUND(c.total_cogs / NULLIF(r.total_rev, 0) * 100, 1) > 30 THEN '⚠️ Pantau Atas'
    WHEN ROUND(c.total_cogs / NULLIF(r.total_rev, 0) * 100, 1) < 25 THEN '🔥 Porsi Menyusut'
    ELSE '⭐ Zona Ideal'
  END as variance_status,
  (c.total_cogs) - (r.total_rev * 0.30) as variance_rp
FROM branch_cogs c
JOIN branch_rev r ON c.branch_name = r.branch_name
ORDER BY cogs_pct DESC
```

```sql top_cost_items
WITH max_d AS (SELECT MAX(txn_date)::DATE AS d FROM restaurant.inventory_stok)
SELECT 
  item_name AS "Nama Bahan",
  category AS "Kategori",
  SUM(usage_qty) AS "Volume Pemakaian",
  SUM(usage_cost) AS "Total Biaya (Rp)"
FROM restaurant.inventory_stok CROSS JOIN max_d
WHERE txn_date >= max_d.d - INTERVAL '29 days'
GROUP BY item_name, category
ORDER BY SUM(usage_cost) DESC
LIMIT 10
```

{#if worstBranch && bestBranch && cogs_kpi}
<div class="diagnostics-header" style="margin-top: 24px; margin-bottom: 24px;">
  <div class="diagnostics-eyebrow">🧠 DIAGNOSTIK UTAMA</div>
  <h2 class="diagnostics-title">Sintesis Efisiensi Bahan Baku Makro</h2>
  <p class="diagnostics-copy">Evaluasi menyeluruh terhadap rasio HPP, pemborosan bahan, dan kesehatan struktural biaya dapur restoran bulan ini.</p>
</div>

<div class="insight-container" style="margin-bottom: 48px;">
  <div class="insight-box {macroCogsPct > 35 ? 'red' : (macroCogsPct > 30 || macroCogsPct < 25 ? 'orange' : 'green')}">
    <div class="insight-headline">
        {#if macroCogsPct > 35}
            🚨 Kritis: Pemborosan Bahan Ekstrem ({macroCogsPct.toFixed(1)}%)
        {:else if macroCogsPct > 30}
            ⚠️ Peringatan: Biaya Bahan Mulai Tinggi ({macroCogsPct.toFixed(1)}%)
        {:else if macroCogsPct < 25}
            ⚠️ Waspada: Porsi Bahan Menyusut ({macroCogsPct.toFixed(1)}%)
        {:else}
            ✅ Ideal: Pengeluaran Bahan Seimbang ({macroCogsPct.toFixed(1)}%)
        {/if}
    </div>
    <div class="insight-copy">
        {#if macroCogsPct > 35}
            <p style="margin-top: 0; margin-bottom: 12px;">Bulan ini, rata-rata rasio bahan pokok sangat tinggi (<strong>{macroCogsPct.toFixed(1)}%</strong>). Angka di atas 35% mengindikasikan pemborosan ekstrem atau pencurian/kerusakan stok yang menggerus profit bersih perusahaan. Kondisi terparah saat ini terjadi di <strong>{worstBranch.branch_name} ({worstBranch.cogs_pct}%)</strong>.</p>
            <p style="margin: 0;"><strong>Saran:</strong> Segera audit resep, timbangan porsi, dan laporan stok rusak (spoilage) di cabang-cabang yang merah. <em>(Catatan: Angka ini hanya alat bantu. Pastikan kecocokannya dengan kondisi asli di restoran).</em></p>
        {:else if macroCogsPct > 30}
            <p style="margin-top: 0; margin-bottom: 12px;">Rata-rata rasio bahan pokok terlihat mulai membengkak (<strong>{macroCogsPct.toFixed(1)}%</strong>). Walau masih beroperasi, angka di atas batas standar 30% berisiko menekan margin. Ini mulai terlihat di <strong>{worstBranch.branch_name} ({worstBranch.cogs_pct}%)</strong>.</p>
            <p style="margin: 0;"><strong>Saran:</strong> Cek fluktuasi harga pemasok terbaru dan perketat kontrol porsi masakan di dapur. <em>(Catatan: Angka ini hanya alat bantu. Pastikan kecocokannya dengan kondisi asli di restoran).</em></p>
        {:else if macroCogsPct >= 25}
            <p style="margin-top: 0; margin-bottom: 12px;">Seluruh komponen pengeluaran dapur sangat terjaga (<strong>{macroCogsPct.toFixed(1)}%</strong>) sesuai target 30%. Perusahaan menikmati margin kotor yang optimal. Prestasi efisiensi terbaik dicapai oleh <strong>{bestBranch.branch_name} ({bestBranch.cogs_pct}%)</strong>.</p>
            <p style="margin: 0;"><strong>Saran:</strong> Pertahankan standar SOP operasional saat ini dan jadikan cabang terbaik sebagai tolak ukur. <em>(Catatan: Terus pantau kepuasan pelanggan di lapangan).</em></p>
        {:else}
            <p style="margin-top: 0; margin-bottom: 12px;">Rasio pengeluaran bahan sangat minim (<strong>{macroCogsPct.toFixed(1)}%</strong>), jauh di bawah standar rata-rata 30%. Secara laba sangat bagus, namun pastikan hal ini bukan akibat pengurangan kualitas porsi bahan yang bisa mengecewakan pelanggan. Angka terendah dicatat <strong>{bestBranch.branch_name} ({bestBranch.cogs_pct}%)</strong>.</p>
            <p style="margin: 0;"><strong>Saran:</strong> Pastikan SOP penyajian dipatuhi dan tidak ada bahan (daging/sayur) yang dipotong porsinya demi menghemat. <em>(Catatan: Angka ini hanya alat bantu. Pastikan kecocokannya dengan kondisi asli di restoran).</em></p>
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
             <div class="zone" style="width: 50%; background: #fed7aa;"></div>
             <div class="zone" style="width: 10%; background: #bbf7d0;"></div>
             <div class="zone" style="width: 10%; background: #fed7aa;"></div>
             <div class="zone" style="width: 30%; background: #fecaca;"></div>
             <div class="macro-marker" style="left: {Math.min(macroCogsPct / 50 * 100, 100)}%;">
               <div class="macro-marker-pin">📍 {macroCogsPct.toFixed(1)}%</div>
               <div class="macro-marker-line"></div>
             </div>
           </div>
        </div>
    </div>
  </div>
</div>


<div style="margin-bottom: 64px;">
  <div style="font-weight: 700; color: var(--color-text-primary); margin-bottom: 24px; font-size: 1.1rem; text-align: center;">Sistem Peringatan Dini (Zona COGS)</div>
  <div class="insight-grid" style="grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 12px; padding: 12px 0;">
    
    <div class="insight-card target-card orange {activeTier === 2 ? 'active-tier' : 'inactive-tier'}">
      <div class="insight-header" style="flex-direction: column; text-align: center; gap: 4px;">
        <span class="insight-icon">👀</span>
        <span class="insight-title" style="font-size: 0.85rem;">Pantau Bawah (&lt;25%)</span>
      </div>
      <div class="insight-body" style="font-size: 0.8rem; text-align: center; color: var(--color-text-secondary); line-height: 1.4; margin-top: 8px;">
        Rasio di bawah target. Verifikasi konsistensi standar porsi.
      </div>
    </div>
    
    <div class="insight-card target-card green {activeTier === 3 ? 'active-tier' : 'inactive-tier'}">
      <div class="insight-header" style="flex-direction: column; text-align: center; gap: 4px;">
        <span class="insight-icon">⭐</span>
        <span class="insight-title" style="font-size: 0.85rem;">Zona Ideal (25-30%)</span>
      </div>
      <div class="insight-body" style="font-size: 0.8rem; text-align: center; color: var(--color-text-secondary); line-height: 1.4; margin-top: 8px;">
        Rasio efisien. Pertahankan standar resep saat ini.
      </div>
    </div>
    
    <div class="insight-card target-card orange {activeTier === 4 ? 'active-tier' : 'inactive-tier'}">
      <div class="insight-header" style="flex-direction: column; text-align: center; gap: 4px;">
        <span class="insight-icon">⚠️</span>
        <span class="insight-title" style="font-size: 0.85rem;">Pantau Atas (30-35%)</span>
      </div>
      <div class="insight-body" style="font-size: 0.8rem; text-align: center; color: var(--color-text-secondary); line-height: 1.4; margin-top: 8px;">
        Rasio mulai naik. Tinjau ulang pemakaian bahan baku harian.
      </div>
    </div>
    
    <div class="insight-card target-card red {activeTier === 5 ? 'active-tier' : 'inactive-tier'}">
      <div class="insight-header" style="flex-direction: column; text-align: center; gap: 4px;">
        <span class="insight-icon">📉</span>
        <span class="insight-title" style="font-size: 0.85rem;">Pemborosan (&gt;35%)</span>
      </div>
      <div class="insight-body" style="font-size: 0.8rem; text-align: center; color: var(--color-text-secondary); line-height: 1.4; margin-top: 8px;">
        Proporsi di atas standar. Analisis potensi inefisiensi pengadaan.
      </div>
    </div>

  </div>
</div>

<div class="diagnostics-header" style="margin-bottom: 24px;">
  <div class="diagnostics-eyebrow">🔬 BEDAH KAPASITAS & COGS CABANG</div>
  <h2 class="diagnostics-title">Pemetaan Pemborosan Bahan</h2>
  <p class="diagnostics-copy">Tabel di bawah menyoroti cabang mana yang mengalami pemborosan bahan mentah dibandingkan dengan target ideal 30% dari omzet.</p>
</div>

<div style="margin-top: 32px; margin-bottom: 48px;">
  <details class="guide-acc" style="margin-top: 16px; margin-bottom: 24px;">
    <summary>💡 Konteks Data & Cara Membaca</summary>
    <div class="guide-body" style="padding: 16px;">
      <p style="margin-top: 4px; margin-bottom: 16px; font-weight: 500; color: var(--color-text-secondary);">
        Jika metrik di atas mengevaluasi kesehatan restoran <strong>secara keseluruhan</strong> (Makro), tabel di bawah membedah masalah tersebut <strong>ke masing-masing cabang</strong> (Mikro). Angka Rupiah yang muncul adalah target finansial yang bisa Anda selamatkan atau pakai untuk evaluasi <i>supplier</i>.
      </p>
      <div class="guide-grid" style="grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 16px; display: grid;">
        <div class="guide-card orange">
          <div class="guide-card-icon">📉</div>
          <div class="guide-card-content">
            <div class="guide-card-label">Status: Pemborosan</div>
            <h4 class="guide-card-title">Indikasi Kebocoran</h4>
            <p class="guide-card-desc">Jika muncul Nilai Varian <strong>Rp 5.000.000</strong>, artinya Anda ditargetkan untuk <strong>menyelidiki kebocoran stok dapur/porsi</strong> senilai 5 juta bulan ini.</p>
          </div>
        </div>
        <div class="guide-card teal">
          <div class="guide-card-icon">🏆</div>
          <div class="guide-card-content">
            <div class="guide-card-label">Status: Hemat</div>
            <h4 class="guide-card-title">Retensi Performa</h4>
            <p class="guide-card-desc">Anda berhasil mempertahankan efisiensi <strong>5 juta</strong> dibanding target teoritis (30% dari omzet). Pertahankan standar resep ini!</p>
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
        <th style="text-align: center;">Rasio COGS (%)</th>
        <th>Status Kesehatan</th>
        <th style="text-align: right;">Nilai Varian (Rp)</th>
      </tr>
    </thead>
    <tbody>
      {#each cogs_by_branch as row, i}
        <tr class="premium-row">
          <td style="font-weight: 700; color: var(--color-text-primary);">{row.branch_name}</td>
          <td style="text-align: center; font-weight: 600;">{row.cogs_pct}%</td>
          <td>
            {#if row.cogs_pct > 35}
              <span class="badge badge-red">{row.variance_status}</span>
            {:else if row.cogs_pct > 30}
              <span class="badge badge-orange">{row.variance_status}</span>
            {:else if row.cogs_pct < 25}
              <span class="badge badge-red">{row.variance_status}</span>
            {:else}
              <span class="badge badge-green">{row.variance_status}</span>
            {/if}
          </td>
          <td style="text-align: right; font-weight: 800; color: var(--color-text-primary);" class="hover-tooltip {i < cogs_by_branch.length / 2 ? 'tooltip-down' : 'tooltip-up'}">
            <span class="tooltip-text">
              {#if row.cogs_pct > 35}
                Proporsi pengeluaran bahan berada di atas rata-rata. Disarankan untuk memantau proses produksi dapur.
              {:else if row.cogs_pct > 30}
                Terdapat tren kenaikan biaya bahan. Evaluasi harga pemasok atau efisiensi pemakaian.
              {:else if row.cogs_pct < 25}
                Rasio bahan cukup rendah. Pastikan ukuran porsi dan spesifikasi bahan tetap sesuai standar kualitas.
              {:else}
                Penggunaan bahan mentah tercatat stabil dan proporsional.
              {/if}
            </span>
            {#if row.variance_rp != null && row.variance_rp !== 0 && row.variance_status !== '⭐ Zona Ideal'}
              {#if row.cogs_pct > 30}
                <span style="color: #ef4444; font-size: 0.75rem; margin-right: 4px; vertical-align: middle;">▼</span>
              {:else if row.cogs_pct < 25}
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

```sql bahan_composition
WITH max_d AS (SELECT MAX(metric_date)::DATE AS d FROM restaurant.daily_net_revenue),
raw_data AS (
  SELECT branch_name, inventory_usage_cost, inventory_purchase_cost, inventory_total_cost
  FROM restaurant.daily_net_revenue CROSS JOIN max_d
  WHERE metric_date >= max_d.d - INTERVAL '29 days'
),
agg_branches AS (
  SELECT 
    branch_name,
    SUM(inventory_usage_cost) as total_usage,
    SUM(inventory_purchase_cost) as total_purchase,
    SUM(inventory_total_cost) as total_inv
  FROM raw_data
  GROUP BY branch_name
),
agg_all AS (
  SELECT 
    'Semua Cabang' as branch_name,
    SUM(inventory_usage_cost) as total_usage,
    SUM(inventory_purchase_cost) as total_purchase,
    SUM(inventory_total_cost) as total_inv
  FROM raw_data
),
combined AS (
  SELECT * FROM agg_all
  UNION ALL
  SELECT * FROM agg_branches
)
SELECT 
  branch_name,
  total_usage,
  total_purchase,
  total_inv,
  ROUND(total_usage / NULLIF(total_inv, 0) * 100, 1) as pct_usage,
  ROUND(total_purchase / NULLIF(total_inv, 0) * 100, 1) as pct_purchase
FROM combined
ORDER BY CASE WHEN branch_name = 'Semua Cabang' THEN 0 ELSE 1 END, total_inv DESC
```

<hr style="margin: 48px 0; border: 0; border-top: 1px dashed rgba(0,0,0,0.1);" />

<div class="diagnostics-header" style="margin-bottom: 24px;">
  <div class="diagnostics-eyebrow">🧬 STRUKTUR KOMPOSISI BIAYA</div>
  <h2 class="diagnostics-title">Proporsi Biaya Bahan (Pemakaian vs Pembelian)</h2>
  <p class="diagnostics-copy">Pantau aliran arus kas inventaris: apakah tingginya biaya bahan didominasi oleh pemakaian (barang benar-benar dimasak/terjual), atau karena penumpukan stok baru (restock) di gudang.</p>
</div>

<div style="display: flex; gap: 8px; flex-wrap: wrap; margin-bottom: 24px;">
  {#each bahan_composition as row}
    {#if row.total_inv !== undefined}
      <button 
        style="padding: 8px 16px; border-radius: 20px; font-size: 0.9rem; font-weight: 600; cursor: pointer; border: 1px solid {activeBahanBranch === row.branch_name ? '#3b82f6' : '#e2e8f0'}; background: {activeBahanBranch === row.branch_name ? '#eff6ff' : '#ffffff'}; color: {activeBahanBranch === row.branch_name ? '#1d4ed8' : '#64748b'}; transition: all 0.2s ease;"
        on:click={() => activeBahanBranch = row.branch_name}
      >
        {row.branch_name}
      </button>
    {/if}
  {/each}
</div>

<div style="display: flex; flex-direction: column; gap: 16px; margin-bottom: 48px;">
  {#each bahan_composition as row}
    {#if row.total_inv !== undefined && row.branch_name === activeBahanBranch}
    <div class="interactive-card" style="padding: 20px; background: white; border-radius: 12px; border: 1px solid var(--color-border-primary); box-shadow: 0 1px 3px rgba(0,0,0,0.05);">
      <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 12px;">
        <div style="font-weight: 700; color: var(--color-text-primary); font-size: 1.1rem;">{row.branch_name}</div>
        <div style="font-size: 0.9rem; color: var(--color-text-tertiary); font-weight: 500;">Total Kas Bahan: Rp {Math.round(row.total_inv || 0).toLocaleString('id-ID')}</div>
      </div>
      
      <div style="display: flex; height: 28px; border-radius: 8px; overflow: hidden; margin-bottom: 16px; box-shadow: inset 0 1px 3px rgba(0,0,0,0.1);">
        <div style="width: {row.pct_usage}%; background: linear-gradient(90deg, #3b82f6, #60a5fa); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.75rem; font-weight: 700;" title="Bahan Terpakai (Usage): Rp {Math.round(row.total_usage || 0).toLocaleString('id-ID')}">
          {#if row.pct_usage > 10}{row.pct_usage}%{/if}
        </div>
        <div style="width: {row.pct_purchase}%; background: linear-gradient(90deg, #10b981, #34d399); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.75rem; font-weight: 700;" title="Pembelian/Restock Baru: Rp {Math.round(row.total_purchase || 0).toLocaleString('id-ID')}">
          {#if row.pct_purchase > 5}{row.pct_purchase}%{/if}
        </div>
      </div>
      
      <div style="display: flex; flex-wrap: wrap; gap: 16px; font-size: 0.85rem; color: var(--color-text-secondary);">
        <div style="display: flex; align-items: center; gap: 6px;">
          <div style="width: 12px; height: 12px; border-radius: 3px; background: #3b82f6;"></div>
          <span>Pemakaian Terjual/Terpakai <strong>Rp {Math.round(row.total_usage || 0).toLocaleString('id-ID')}</strong></span>
        </div>
        <div style="display: flex; align-items: center; gap: 6px;">
          <div style="width: 12px; height: 12px; border-radius: 3px; background: #10b981;"></div>
          <span>Pembelian / Restock Gudang <strong>Rp {Math.round(row.total_purchase || 0).toLocaleString('id-ID')}</strong></span>
        </div>
      </div>
    </div>
    {/if}
  {/each}
</div>
<div class="clean-cta-banner">
  <div class="clean-cta-content">
    <div class="clean-cta-icon">📦</div>
    <div class="clean-cta-text">
      <h3 class="clean-cta-title">Investigasi Stok & Bahan Baku</h3>
      <p class="clean-cta-desc">Lacak asal pemborosan bahan dari Top barang paling boros, selidiki resep, dan cek riwayat pemakaian inventori secara detail.</p>
    </div>
  </div>
  <a href="/03-inventori-stok" class="clean-cta-button">
    Buka Direktori Inventori ➔
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
  background: #111827;
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
  color: #111827;
  font-size: 1.05rem;
}
@media (max-width: 1024px) {
  .insight-grid { grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)) !important; }
}

/* Premium Custom Table CSS */
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
