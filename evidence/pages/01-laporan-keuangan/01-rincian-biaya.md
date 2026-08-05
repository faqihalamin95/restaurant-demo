---
title: Rincian Biaya
---

<script>


  onMount(() => {
    setTimeout(() => {
      const urlParams = new URLSearchParams(window.location.search);
      const tabQuery = urlParams.get('tab');
      if (tabQuery) {
        let targetText = '';
        if (tabQuery === 'bahan') targetText = 'Biaya Bahan Baku';
        else if (tabQuery === 'sdm') targetText = 'Biaya SDM';
        else if (tabQuery === 'ops') targetText = 'Biaya Operasional';

        if (targetText) {
          const tabButtons = document.querySelectorAll('button');
          for (let btn of tabButtons) {
            if (btn.textContent.includes(targetText)) {
              btn.click();
              // Clean up the URL so it doesn't stick
              window.history.replaceState({}, document.title, window.location.pathname);
              break;
            }
          }
        }
      }
    }, 150);
  });

  let activeBahanBranch = 'Semua Cabang';
  let worstBranchBahan = null;
  let bestBranchBahan = null;
  let macroCogsPct = 0;
  let activeTierBahan = 0;

  $: if (cogs_by_branch && cogs_by_branch.length > 0) {
      let sorted = [...cogs_by_branch].sort((a,b) => b.cogs_pct - a.cogs_pct);
      worstBranchBahan = sorted[0]; 
      bestBranchBahan = sorted[sorted.length - 1]; 
  }

  $: if (cogs_kpi && cogs_kpi.length > 0) {
      macroCogsPct = cogs_kpi[0].cogs_pct_30d;
      if (macroCogsPct > 35) activeTierBahan = 5;
      else if (macroCogsPct > 30) activeTierBahan = 4;
      else if (macroCogsPct >= 25) activeTierBahan = 3;
      else activeTierBahan = 2;
  }

  let worstBranchSDM = null;
  let bestBranchSDM = null;
  let macroLaborCost = 0;
  let activeTierSDM = 0; // 1: <15, 2: 15-20, 3: 20-30, 4: 30-35, 5: >35
  let activeCompositionBranch = 'Semua Cabang';

  $: if (branch_labor_cost && branch_labor_cost.length > 0) {
      let sorted = [...branch_labor_cost].sort((a,b) => b.labor_cost_pct - a.labor_cost_pct);
      worstBranchSDM = sorted[0]; 
      bestBranchSDM = sorted[sorted.length - 1]; 
      
      let totalRev = branch_labor_cost.reduce((acc, curr) => acc + curr.total_revenue, 0);
      let totalPay = branch_labor_cost.reduce((acc, curr) => acc + curr.total_payroll, 0);
      macroLaborCost = totalRev > 0 ? (totalPay / totalRev) * 100 : 0;

      if (macroLaborCost > 35) activeTierSDM = 5;
      else if (macroLaborCost > 30) activeTierSDM = 4;
      else if (macroLaborCost < 15) activeTierSDM = 1;
      else if (macroLaborCost < 20) activeTierSDM = 2;
      else activeTierSDM = 3;
  }

  let activeOpsBranch = 'Semua Cabang';
  let worstBranchOps = { branch_name: "N/A", ops_pct: 0 };
  let bestBranchOps = null;
  let macroOpsPct = 0;
  let activeTierOps = 0;
  let enrichedBranches = [];

  $: if (ops_by_branch && ops_by_branch.length > 0) {
      let sorted = [...ops_by_branch].sort((a,b) => b.ops_pct - a.ops_pct);
      worstBranchOps = sorted[0]; 
      bestBranchOps = sorted[sorted.length - 1]; 
      
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
        activeTierOps = 2; // Minim
      } else if (macroOpsPct <= 30) {
        activeTierOps = 3; // Ideal
      } else if (macroOpsPct <= 35) {
        activeTierOps = 4; // Pantau
      } else {
        activeTierOps = 5; // Bahaya
      }
  }
</script>



<FinanceTabs activeTab="rincian-biaya" />


<Tabs id="rincian-biaya-tabs" fullWidth=true>

<Tab label="🥩 Biaya Bahan Baku">




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

{#if worstBranchBahan && bestBranchBahan && cogs_kpi}
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
            <p style="margin-top: 0; margin-bottom: 12px;">Bulan ini, rata-rata rasio bahan pokok sangat tinggi (<strong>{macroCogsPct.toFixed(1)}%</strong>). Angka di atas 35% mengindikasikan pemborosan ekstrem atau pencurian/kerusakan stok yang menggerus profit bersih perusahaan. Kondisi terparah saat ini terjadi di <strong>{worstBranchBahan.branch_name} ({worstBranchBahan.cogs_pct}%)</strong>.</p>
            <p style="margin: 0;"><strong>Saran:</strong> Segera audit resep, timbangan porsi, dan laporan stok rusak (spoilage) di cabang-cabang yang merah. <em>(Catatan: Angka ini hanya alat bantu. Pastikan kecocokannya dengan kondisi asli di restoran).</em></p>
        {:else if macroCogsPct > 30}
            <p style="margin-top: 0; margin-bottom: 12px;">Rata-rata rasio bahan pokok terlihat mulai membengkak (<strong>{macroCogsPct.toFixed(1)}%</strong>). Walau masih beroperasi, angka di atas batas standar 30% berisiko menekan margin. Ini mulai terlihat di <strong>{worstBranchBahan.branch_name} ({worstBranchBahan.cogs_pct}%)</strong>.</p>
            <p style="margin: 0;"><strong>Saran:</strong> Cek fluktuasi harga pemasok terbaru dan perketat kontrol porsi masakan di dapur. <em>(Catatan: Angka ini hanya alat bantu. Pastikan kecocokannya dengan kondisi asli di restoran).</em></p>
        {:else if macroCogsPct >= 25}
            <p style="margin-top: 0; margin-bottom: 12px;">Seluruh komponen pengeluaran dapur sangat terjaga (<strong>{macroCogsPct.toFixed(1)}%</strong>) sesuai target 30%. Perusahaan menikmati margin kotor yang optimal. Prestasi efisiensi terbaik dicapai oleh <strong>{bestBranchBahan.branch_name} ({bestBranchBahan.cogs_pct}%)</strong>.</p>
            <p style="margin: 0;"><strong>Saran:</strong> Pertahankan standar SOP operasional saat ini dan jadikan cabang terbaik sebagai tolak ukur. <em>(Catatan: Terus pantau kepuasan pelanggan di lapangan).</em></p>
        {:else}
            <p style="margin-top: 0; margin-bottom: 12px;">Rasio pengeluaran bahan sangat minim (<strong>{macroCogsPct.toFixed(1)}%</strong>), jauh di bawah standar rata-rata 30%. Secara laba sangat bagus, namun pastikan hal ini bukan akibat pengurangan kualitas porsi bahan yang bisa mengecewakan pelanggan. Angka terendah dicatat <strong>{bestBranchBahan.branch_name} ({bestBranchBahan.cogs_pct}%)</strong>.</p>
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
    
    <div class="insight-card target-card orange {activeTierBahan === 2 ? 'active-tier' : 'inactive-tier'}">
      <div class="insight-header" style="flex-direction: column; text-align: center; gap: 4px;">
        <span class="insight-icon">👀</span>
        <span class="insight-title" style="font-size: 0.85rem;">Pantau Bawah (&lt;25%)</span>
      </div>
      <div class="insight-body" style="font-size: 0.8rem; text-align: center; color: var(--color-text-secondary); line-height: 1.4; margin-top: 8px;">
        Rasio di bawah target. Verifikasi konsistensi standar porsi.
      </div>
    </div>
    
    <div class="insight-card target-card green {activeTierBahan === 3 ? 'active-tier' : 'inactive-tier'}">
      <div class="insight-header" style="flex-direction: column; text-align: center; gap: 4px;">
        <span class="insight-icon">⭐</span>
        <span class="insight-title" style="font-size: 0.85rem;">Zona Ideal (25-30%)</span>
      </div>
      <div class="insight-body" style="font-size: 0.8rem; text-align: center; color: var(--color-text-secondary); line-height: 1.4; margin-top: 8px;">
        Rasio efisien. Pertahankan standar resep saat ini.
      </div>
    </div>
    
    <div class="insight-card target-card orange {activeTierBahan === 4 ? 'active-tier' : 'inactive-tier'}">
      <div class="insight-header" style="flex-direction: column; text-align: center; gap: 4px;">
        <span class="insight-icon">⚠️</span>
        <span class="insight-title" style="font-size: 0.85rem;">Pantau Atas (30-35%)</span>
      </div>
      <div class="insight-body" style="font-size: 0.8rem; text-align: center; color: var(--color-text-secondary); line-height: 1.4; margin-top: 8px;">
        Rasio mulai naik. Tinjau ulang pemakaian bahan baku harian.
      </div>
    </div>
    
    <div class="insight-card target-card red {activeTierBahan === 5 ? 'active-tier' : 'inactive-tier'}">
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
    <div class="clean-cta-icon">🏪</div>
    <div class="clean-cta-text">
      <h3 class="clean-cta-title">Investigasi Rincian Biaya Cabang</h3>
      <p class="clean-cta-desc">Bedah lebih detail rincian biaya per cabang dan temukan rekomendasi aksinya.</p>
    </div>
  </div>
  <a href="/02-branch-performance/deepdive" class="clean-cta-button">
    Buka Deep Dive Cabang ➔
  </a>
</div>



{:else}
  <GlobalLoading />
{/if}



</Tab>
<Tab label="👥 Biaya SDM & Payroll">



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

{#if worstBranchSDM && bestBranchSDM}
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
            Bulan ini, rata-rata rasio gaji membengkak di atas batas kritis (35%). Secara perhitungan, ini menandakan pemborosan besar karena terlalu banyak pekerja dibandingkan pesanan. Beban tertinggi terlihat di <strong>{worstBranchSDM.branch_name} ({worstBranchSDM.labor_cost_pct}%)</strong>. <br/><br/>
            <strong>Saran:</strong> Pertimbangkan untuk memangkas jam kerja staf paruh waktu (part-time) segera. <em>(Catatan: Angka ini hanya alat bantu. Pastikan kecocokannya dengan kondisi asli di restoran).</em>
        {:else if macroLaborCost > 30}
            Bulan ini, rata-rata rasio gaji mulai melewati batas wajar (20-30%). Jika dibiarkan, pengeluaran gaji perlahan akan menggerogoti keuntungan restoran. Angka tertinggi terlihat di <strong>{worstBranchSDM.branch_name} ({worstBranchSDM.labor_cost_pct}%)</strong>. <br/><br/>
            <strong>Saran:</strong> Pertimbangkan untuk menyetop lembur yang tidak perlu. <em>(Catatan: Angka ini hanya alat bantu. Pastikan kecocokannya dengan kondisi asli di restoran).</em>
        {:else if macroLaborCost < 15}
            Rata-rata rasio gaji turun drastis menyentuh batas kritis di bawah 15%. Ini pertanda restoran sangat kekurangan staf, yang bisa memicu karyawan kelelahan ekstrim dan keluhan pelanggan. Hal ini paling parah di <strong>{bestBranchSDM.branch_name} ({bestBranchSDM.labor_cost_pct}%)</strong>. <br/><br/>
            <strong>Saran:</strong> Pertimbangkan untuk segera merekrut atau menambah karyawan baru. <em>(Catatan: Angka ini hanya alat bantu. Pastikan kecocokannya dengan kondisi asli di restoran).</em>
        {:else if macroLaborCost < 20}
            Rata-rata rasio gaji terlihat cukup rendah (<strong>{macroLaborCost.toFixed(1)}%</strong>). Walau menguntungkan secara keuangan, angka di bawah 20% bisa memicu kelelahan staf dan antrean panjang. Ini mulai terlihat di <strong>{bestBranchSDM.branch_name} ({bestBranchSDM.labor_cost_pct}%)</strong>. <br/><br/>
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

<div style="margin-bottom: 64px;">
  <div style="font-weight: 700; color: var(--color-text-primary); margin-bottom: 24px; font-size: 1.1rem; text-align: center;">Sistem Peringatan Dini (Zona Efisiensi Gaji)</div>
  <div class="insight-grid" style="grid-template-columns: repeat(5, minmax(0, 1fr)); gap: 12px; padding: 12px 0;">
    
    <div class="insight-card target-card red {activeTierSDM === 1 ? 'active-tier' : 'inactive-tier'}">
      <div class="insight-header" style="flex-direction: column; text-align: center; gap: 4px;">
        <span class="insight-icon">🔥</span>
        <span class="insight-title" style="font-size: 0.85rem;">Risiko Kritis (&lt;15%)</span>
      </div>
      <div class="insight-body" style="font-size: 0.8rem; text-align: center; color: var(--color-text-secondary); line-height: 1.4; margin-top: 8px;">
        Kapasitas staf rendah. Evaluasi kebutuhan penambahan personel.
      </div>
    </div>

    <div class="insight-card target-card orange {activeTierSDM === 2 ? 'active-tier' : 'inactive-tier'}">
      <div class="insight-header" style="flex-direction: column; text-align: center; gap: 4px;">
        <span class="insight-icon">👀</span>
        <span class="insight-title" style="font-size: 0.85rem;">Pantau Bawah (15-20%)</span>
      </div>
      <div class="insight-body" style="font-size: 0.8rem; text-align: center; color: var(--color-text-secondary); line-height: 1.4; margin-top: 8px;">
        Rasio mendekati batas bawah. Pantau beban kerja staf.
      </div>
    </div>

    <div class="insight-card target-card green {activeTierSDM === 3 ? 'active-tier' : 'inactive-tier'}">
      <div class="insight-header" style="flex-direction: column; text-align: center; gap: 4px;">
        <span class="insight-icon">⭐</span>
        <span class="insight-title" style="font-size: 0.85rem;">Zona Ideal (20-30%)</span>
      </div>
      <div class="insight-body" style="font-size: 0.8rem; text-align: center; color: var(--color-text-secondary); line-height: 1.4; margin-top: 8px;">
        Proporsi ideal. Pertahankan efisiensi penjadwalan.
      </div>
    </div>

    <div class="insight-card target-card orange {activeTierSDM === 4 ? 'active-tier' : 'inactive-tier'}">
      <div class="insight-header" style="flex-direction: column; text-align: center; gap: 4px;">
        <span class="insight-icon">⚠️</span>
        <span class="insight-title" style="font-size: 0.85rem;">Pantau Atas (30-35%)</span>
      </div>
      <div class="insight-body" style="font-size: 0.8rem; text-align: center; color: var(--color-text-secondary); line-height: 1.4; margin-top: 8px;">
        Rasio meningkat. Tinjau ulang pemakaian jam lembur.
      </div>
    </div>

    <div class="insight-card target-card red {activeTierSDM === 5 ? 'active-tier' : 'inactive-tier'}">
      <div class="insight-header" style="flex-direction: column; text-align: center; gap: 4px;">
        <span class="insight-icon">📉</span>
        <span class="insight-title" style="font-size: 0.85rem;">Pemborosan (&gt;35%)</span>
      </div>
      <div class="insight-body" style="font-size: 0.8rem; text-align: center; color: var(--color-text-secondary); line-height: 1.4; margin-top: 8px;">
        Proporsi berlebih. Analisis tingkat efektivitas staf.
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
      
      <details class="guide-acc" style="margin-top: 16px; margin-bottom: 24px;">
        <summary>💡 Konteks Data & Cara Membaca</summary>
        <div class="guide-body" style="padding: 16px;">
          <p style="margin-top: 4px; margin-bottom: 16px; font-weight: 500; color: var(--color-text-secondary);">
            Jika metrik di atas mengevaluasi kesehatan restoran <strong>secara keseluruhan</strong> (Makro), tabel di bawah membedah masalah tersebut <strong>ke masing-masing cabang</strong> (Mikro). Angka Rupiah yang muncul adalah target finansial yang bisa Anda selamatkan atau pakai untuk alokasi <i>hiring</i>.
          </p>
          <div class="guide-grid" style="grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 16px; display: grid;">
            <div class="guide-card orange">
              <div class="guide-card-icon">📉</div>
              <div class="guide-card-content">
                <div class="guide-card-label">Status: Pemborosan</div>
                <h4 class="guide-card-title">Target Efisiensi Lembur</h4>
                <p class="guide-card-desc">Jika muncul Nilai Varian <strong>Rp 5.000.000</strong>, artinya Anda ditargetkan untuk <strong>memangkas jam lembur</strong> senilai 5 juta bulan ini.</p>
              </div>
            </div>
            <div class="guide-card purple">
              <div class="guide-card-icon">🔥</div>
              <div class="guide-card-content">
                <div class="guide-card-label">Status: Risiko Kritis</div>
                <h4 class="guide-card-title">Sinyal Penambahan Staf</h4>
                <p class="guide-card-desc">Pakai dana <strong>Rp 5.000.000</strong> tersebut untuk <strong>merekrut pekerja tambahan</strong> alih-alih menguras tenaga staf dengan lembur berlebih.</p>
              </div>
            </div>
          </div>
        </div>
      </details>

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
                      Proporsi gaji berada di atas target. Pertimbangkan penyesuaian jam kerja agar rasio kembali ideal.
                    {:else if row.labor_cost_pct > 30}
                      Tren biaya meningkat. Evaluasi alokasi jadwal lembur untuk menstabilkan beban.
                    {:else if row.labor_cost_pct < 15}
                      Rasio gaji cukup rendah. Pertimbangkan alokasi rekrutmen tambahan untuk menjaga kualitas pelayanan.
                    {:else if row.labor_cost_pct < 20}
                      Kapasitas staf cukup padat. Dana ini dapat dipertimbangkan untuk kebutuhan operasional paruh waktu.
                    {:else}
                      Alokasi dana dan penjadwalan staf tercatat optimal dan berimbang.
                    {/if}
                  </span>
                  {#if row.variance_rp != null && row.variance_rp !== 0}
                    {#if row.labor_cost_pct > 30}
                      <span style="color: #ef4444; font-size: 0.75rem; margin-right: 4px; vertical-align: middle;">▼</span>
                    {:else if row.labor_cost_pct < 20}
                      <span style="color: #22c55e; font-size: 0.75rem; margin-right: 4px; vertical-align: middle;">▲</span>
                    {/if}
                    Rp {Math.round(Number(row.variance_rp)).toLocaleString('id-ID')}
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

```sql labor_composition
WITH max_d AS (SELECT MAX(metric_date)::DATE AS d FROM restaurant.daily_net_revenue),
raw_data AS (
  SELECT branch_name, salary_cost, overtime_cost, meal_allowance_cost, labor_total_cost
  FROM restaurant.daily_net_revenue CROSS JOIN max_d
  WHERE metric_date >= max_d.d - INTERVAL '29 days'
),
agg_branches AS (
  SELECT 
    branch_name,
    SUM(salary_cost) as total_salary,
    SUM(overtime_cost) as total_overtime,
    SUM(meal_allowance_cost) as total_allowance,
    SUM(labor_total_cost) as total_labor
  FROM raw_data
  GROUP BY branch_name
),
agg_all AS (
  SELECT 
    'Semua Cabang' as branch_name,
    SUM(salary_cost) as total_salary,
    SUM(overtime_cost) as total_overtime,
    SUM(meal_allowance_cost) as total_allowance,
    SUM(labor_total_cost) as total_labor
  FROM raw_data
),
combined AS (
  SELECT * FROM agg_all
  UNION ALL
  SELECT * FROM agg_branches
)
SELECT 
  branch_name,
  total_salary,
  total_overtime,
  total_allowance,
  total_labor,
  ROUND(total_salary / NULLIF(total_labor, 0) * 100, 1) as pct_salary,
  ROUND(total_overtime / NULLIF(total_labor, 0) * 100, 1) as pct_overtime,
  ROUND(total_allowance / NULLIF(total_labor, 0) * 100, 1) as pct_allowance
FROM combined
ORDER BY CASE WHEN branch_name = 'Semua Cabang' THEN 0 ELSE 1 END, total_labor DESC
```

<hr style="margin: 48px 0; border: 0; border-top: 1px dashed rgba(0,0,0,0.1);" />

<div class="diagnostics-header" style="margin-bottom: 24px;">
  <div class="diagnostics-eyebrow">🧬 STRUKTUR KOMPOSISI BIAYA</div>
<h2 class="diagnostics-title">Proporsi Biaya SDM (Gaji vs Lembur vs Tunjangan)</h2>
  <p class="diagnostics-copy">Analisis komposisi persentase untuk melacak secara persis darimana pembengkakan biaya berasal (apakah over-lembur, atau beban gaji pokok memang sudah ketinggian).</p>
</div>

<div style="display: flex; gap: 8px; flex-wrap: wrap; margin-bottom: 24px;">
  {#each labor_composition as row}
    {#if row.total_labor !== undefined}
      <button 
        style="padding: 8px 16px; border-radius: 20px; font-size: 0.9rem; font-weight: 600; cursor: pointer; border: 1px solid {activeCompositionBranch === row.branch_name ? '#3b82f6' : '#e2e8f0'}; background: {activeCompositionBranch === row.branch_name ? '#eff6ff' : '#ffffff'}; color: {activeCompositionBranch === row.branch_name ? '#1d4ed8' : '#64748b'}; transition: all 0.2s ease;"
        on:click={() => activeCompositionBranch = row.branch_name}
      >
        {row.branch_name}
      </button>
    {/if}
  {/each}
</div>

<div style="display: flex; flex-direction: column; gap: 16px; margin-bottom: 48px;">
  {#each labor_composition as row}
    {#if row.total_labor !== undefined && row.branch_name === activeCompositionBranch}
    <div class="interactive-card" style="padding: 20px; background: white; border-radius: 12px; border: 1px solid var(--color-border-primary); box-shadow: 0 1px 3px rgba(0,0,0,0.05);">
      <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 12px;">
        <div style="font-weight: 700; color: var(--color-text-primary); font-size: 1.1rem;">{row.branch_name}</div>
        <div style="font-size: 0.9rem; color: var(--color-text-tertiary); font-weight: 500;">Total Biaya SDM: Rp {Math.round(row.total_labor || 0).toLocaleString('id-ID')}</div>
      </div>
      
      <div style="display: flex; height: 28px; border-radius: 8px; overflow: hidden; margin-bottom: 16px; box-shadow: inset 0 1px 3px rgba(0,0,0,0.1);">
        <div style="width: {row.pct_salary}%; background: linear-gradient(90deg, #3b82f6, #60a5fa); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.75rem; font-weight: 700;" title="Gaji Pokok: Rp {Math.round(row.total_salary || 0).toLocaleString('id-ID')}">
          {#if row.pct_salary > 10}{row.pct_salary}%{/if}
        </div>
        <div style="width: {row.pct_allowance}%; background: linear-gradient(90deg, #10b981, #34d399); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.75rem; font-weight: 700;" title="Tunjangan: Rp {Math.round(row.total_allowance || 0).toLocaleString('id-ID')}">
          {#if row.pct_allowance > 5}{row.pct_allowance}%{/if}
        </div>
        <div style="width: {row.pct_overtime}%; background: linear-gradient(90deg, #f59e0b, #fbbf24); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.75rem; font-weight: 700;" title="Lembur: Rp {Math.round(row.total_overtime || 0).toLocaleString('id-ID')}">
          {#if row.pct_overtime > 5}{row.pct_overtime}%{/if}
        </div>
      </div>
      
      <div style="display: flex; flex-wrap: wrap; gap: 16px; font-size: 0.85rem; color: var(--color-text-secondary);">
        <div style="display: flex; align-items: center; gap: 6px;">
          <div style="width: 12px; height: 12px; border-radius: 3px; background: #3b82f6;"></div>
          <span>Gaji Pokok <strong>Rp {Math.round(row.total_salary || 0).toLocaleString('id-ID')}</strong></span>
        </div>
        <div style="display: flex; align-items: center; gap: 6px;">
          <div style="width: 12px; height: 12px; border-radius: 3px; background: #10b981;"></div>
          <span>Tunjangan <strong>Rp {Math.round(row.total_allowance || 0).toLocaleString('id-ID')}</strong></span>
        </div>
        <div style="display: flex; align-items: center; gap: 6px;">
          <div style="width: 12px; height: 12px; border-radius: 3px; background: #f59e0b;"></div>
          <span>Lembur <strong>Rp {Math.round(row.total_overtime || 0).toLocaleString('id-ID')}</strong></span>
        </div>
      </div>
    </div>
    {/if}
  {/each}
</div>

<!-- CTA to Data Directory -->
      <div class="clean-cta-banner">
        <div class="clean-cta-content">
          <div class="clean-cta-icon">🏪</div>
          <div class="clean-cta-text">
            <h3 class="clean-cta-title">Investigasi Rincian Biaya Cabang</h3>
            <p class="clean-cta-desc">Bedah lebih detail rincian biaya per cabang dan temukan rekomendasi aksinya.</p>
          </div>
        </div>
        <a href="/02-branch-performance/deepdive" class="clean-cta-button">
          Buka Deep Dive Cabang ➔
        </a>
      </div>


{:else}
  <GlobalLoading />
{/if}



</Tab>
<Tab label="⚙️ Biaya Operasional">


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



{#if worstBranchOps && bestBranchOps && ops_kpi}
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
            <p style="margin-top: 0; margin-bottom: 12px;">Bulan ini, rata-rata rasio operasional sangat tinggi (<strong>{macroOpsPct.toFixed(1)}%</strong>). Angka di atas batas kritis 35% mengindikasikan lonjakan ekstrem pada tagihan utilitas atau pengeluaran tetap lainnya. Kondisi terparah saat ini terjadi di <strong>{worstBranchOps.branch_name} ({worstBranchOps.ops_pct}%)</strong>.</p>
            <p style="margin: 0;"><strong>Saran:</strong> Segera lakukan audit utilitas dan tekan pengeluaran promosi yang tidak memberikan ROI positif. <em>(Catatan: Angka ini hanya alat bantu. Pastikan kecocokannya dengan kondisi asli di restoran).</em></p>
        {:else if macroOpsPct > 30}
            <p style="margin-top: 0; margin-bottom: 12px;">Rata-rata rasio operasional terlihat mulai membengkak (<strong>{macroOpsPct.toFixed(1)}%</strong>). Walau masih dalam batas toleransi, angka di atas batas standar 30% berisiko menekan margin bersih. Ini mulai terlihat di <strong>{worstBranchOps.branch_name} ({worstBranchOps.ops_pct}%)</strong>.</p>
            <p style="margin: 0;"><strong>Saran:</strong> Perketat kontrol pemakaian utilitas (AC, lampu) dan tunda pengeluaran operasional non-esensial. <em>(Catatan: Angka ini hanya alat bantu. Pastikan kecocokannya dengan kondisi asli di restoran).</em></p>
        {:else if macroOpsPct >= 25}
            <p style="margin-top: 0; margin-bottom: 12px;">Pengeluaran utilitas dan biaya tetap sangat sehat (<strong>{macroOpsPct.toFixed(1)}%</strong>) mematuhi batas aman operasional. Prestasi efisiensi operasional terbaik dicapai oleh <strong>{bestBranchOps.branch_name} ({bestBranchOps.ops_pct}%)</strong>.</p>
            <p style="margin: 0;"><strong>Saran:</strong> Pertahankan kedisiplinan pemakaian utilitas saat ini tanpa mengorbankan kenyamanan pengunjung. <em>(Catatan: Terus pantau kepuasan pelanggan di lapangan).</em></p>
        {:else}
            <p style="margin-top: 0; margin-bottom: 12px;">Rasio pengeluaran operasional sangat minim (<strong>{macroOpsPct.toFixed(1)}%</strong>), jatuh di bawah standar minimal 25%. Secara laba terlihat menguntungkan, namun bisa berarti AC sering dimatikan, restoran gelap, atau nihil aktivitas promosi. Angka terendah dicatat <strong>{bestBranchOps.branch_name} ({bestBranchOps.ops_pct}%)</strong>.</p>
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
    
    <div class="insight-card target-card orange {activeTierOps === 2 ? 'active-tier' : 'inactive-tier'}">
      <div class="insight-header" style="flex-direction: column; text-align: center; gap: 4px;">
        <span class="insight-icon">👀</span>
        <span class="insight-title" style="font-size: 0.85rem;">Pantau Bawah (&lt;25%)</span>
      </div>
      <div class="insight-body" style="font-size: 0.8rem; text-align: center; color: var(--color-text-secondary); line-height: 1.4; margin-top: 8px;">
        Proporsi di bawah target. Tinjau alokasi biaya pemeliharaan dasar.
      </div>
    </div>
    
    <div class="insight-card target-card green {activeTierOps === 3 ? 'active-tier' : 'inactive-tier'}">
      <div class="insight-header" style="flex-direction: column; text-align: center; gap: 4px;">
        <span class="insight-icon">⭐</span>
        <span class="insight-title" style="font-size: 0.85rem;">Zona Ideal (25-30%)</span>
      </div>
      <div class="insight-body" style="font-size: 0.8rem; text-align: center; color: var(--color-text-secondary); line-height: 1.4; margin-top: 8px;">
        Pengeluaran efisien. Pertahankan pola operasional saat ini.
      </div>
    </div>
    
    <div class="insight-card target-card orange {activeTierOps === 4 ? 'active-tier' : 'inactive-tier'}">
      <div class="insight-header" style="flex-direction: column; text-align: center; gap: 4px;">
        <span class="insight-icon">⚠️</span>
        <span class="insight-title" style="font-size: 0.85rem;">Pantau Atas (30-35%)</span>
      </div>
      <div class="insight-body" style="font-size: 0.8rem; text-align: center; color: var(--color-text-secondary); line-height: 1.4; margin-top: 8px;">
        Proporsi meningkat. Tinjau tren tagihan utilitas bulanan.
      </div>
    </div>
    
    <div class="insight-card target-card red {activeTierOps === 5 ? 'active-tier' : 'inactive-tier'}">
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
    <div class="clean-cta-icon">🏪</div>
    <div class="clean-cta-text">
      <h3 class="clean-cta-title">Investigasi Rincian Biaya Cabang</h3>
      <p class="clean-cta-desc">Bedah lebih detail rincian biaya per cabang dan temukan rekomendasi aksinya.</p>
    </div>
  </div>
  <a href="/02-branch-performance/deepdive" class="clean-cta-button">
    Buka Deep Dive Cabang ➔
  </a>
</div>
{:else}
  <GlobalLoading />
{/if}



</Tab>

</Tabs>


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

.trend-indicator {
  font-size: 0.82rem;
  font-weight: 700;
  display: inline-flex;
  align-items: center;
  gap: 3px;
}
.trend-indicator.up { color: #16a34a; }
.trend-indicator.down { color: #dc2626; }
.trend-indicator.neutral { color: var(--color-text-tertiary); }

.cost-grid {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 12px;
}
.cost-card {
  padding: 16px;
  border-radius: 16px;
  border: 1px solid var(--color-border-tertiary);
  background: linear-gradient(180deg, rgba(255,255,255,0.82), rgba(255,255,255,0.6));
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 0 1px 3px rgba(0,0,0,0.05);
  display: flex;
  flex-direction: column;
}
.cost-card:hover {
  transform: translateY(-3px);
  box-shadow: 0 10px 25px -5px rgba(13, 148, 136, 0.15), 0 8px 10px -6px rgba(13, 148, 136, 0.1);
  border-color: rgba(13, 148, 136, 0.4);
}
.cost-label {
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: var(--color-text-tertiary);
  margin-bottom: 8px;
  display: flex;
  align-items: center;
  gap: 5px;
}
.cost-value {
  font-size: 1.9rem;
  font-weight: 800;
  letter-spacing: -0.03em;
}
.cost-target {
  margin-top: 3px;
  font-size: 0.8rem;
  color: var(--color-text-secondary);
}
.progress-track {
  position: relative;
  margin-top: 12px;
  height: 8px;
  border-radius: 999px;
  background: rgba(0,0,0,0.08);
  overflow: hidden;
}
.progress-fill {
  height: 100%;
  border-radius: inherit;
}
.progress-target {
  position: absolute;
  top: -2px;
  bottom: -2px;
  width: 2px;
  background: rgba(0,0,0,0.22);
}
.progress-scale {
  display: flex;
  justify-content: space-between;
  margin-top: 6px;
  font-size: 10px;
  color: var(--color-text-tertiary);
}
.cost-note {
  margin-top: 10px;
  font-size: 0.83rem;
  line-height: 1.4;
  color: var(--color-text-secondary);
  display: flex;
  flex-direction: column;
  gap: 2px;
}
</style>
