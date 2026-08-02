---
title: Direktori Data
---

<script>
  import DiagnosticsHeader from '$lib/DiagnosticsHeader.svelte';
  import SectionHeader from '$lib/SectionHeader.svelte';
  import SectionCard from '$lib/SectionCard.svelte';
  import PremiumTable from '$lib/PremiumTable.svelte';
  import GlobalLoading from '$lib/GlobalLoading.svelte';
</script>

<style>
/* Paksa menu sidebar parent tetap aktif (hijau) saat berada di subpage ini menggunakan </style>

```sql revenue_log
SELECT *
FROM restaurant.direktori_revenue_log
WHERE (Cabang = '${inputs.selected_cabang?.value || inputs.selected_cabang || '%'}' OR '${inputs.selected_cabang?.value || inputs.selected_cabang || '%'}' = '%')
ORDER BY Tanggal DESC, Cabang ASC
```

```sql overhead_log
SELECT *
FROM restaurant.direktori_overhead_log
WHERE (Cabang = '${inputs.selected_cabang?.value || inputs.selected_cabang || '%'}' OR '${inputs.selected_cabang?.value || inputs.selected_cabang || '%'}' = '%')
ORDER BY Tanggal DESC, Cabang ASC
```

```sql cabang_list
SELECT DISTINCT Cabang FROM restaurant.direktori_revenue_log ORDER BY Cabang ASC
```

{#if typeof revenue_log !== 'undefined' && typeof overhead_log !== 'undefined'}

<div class="branch-analysis-body">

_Dashboard portofolio cabang: kesehatan margin, pertumbuhan, profitabilitas, strategi, dan prioritas aksi._

<details class="guide-acc"  style="margin-top:12px;">
  <summary>💡 Cara memilih subpage</summary>
<div class="guide-body">
    <p style="margin-top: 4px; margin-bottom: 16px; font-weight: 500; color: var(--color-text-secondary);">
      Navigasikan analisis performa cabang Anda dari ringkasan kesehatan finansial hingga audit granular per outlet.
    </p>
    <div class="guide-grid" style="grid-template-columns: repeat(3, minmax(0, 1fr));">
      <div class="guide-card blue">
        <div class="guide-card-icon">🏠</div>
        <div class="guide-card-content">
          <div class="guide-card-label">Ringkasan</div>
          <h4 class="guide-card-title">Status Utama &amp; Gap</h4>
          <p class="guide-card-desc">Baca cepat volume order, AOV, dan gap ketimpangan antar cabang di seluruh outlet.</p>
        </div>
      </div>
      <div class="guide-card orange">
        <div class="guide-card-icon">🏪</div>
        <div class="guide-card-content">
          <div class="guide-card-label">Deep Dive</div>
          <h4 class="guide-card-title">Audit Per Cabang</h4>
          <p class="guide-card-desc">Audit cabang satu per satu: status margin harian, cogs, tren belanja, dan data pendukung.</p>
        </div>
      </div>
      <div class="guide-card teal">
        <div class="guide-card-icon">🔭</div>
        <div class="guide-card-content">
          <div class="guide-card-label">Analisis</div>
          <h4 class="guide-card-title">Strategi Portofolio</h4>
          <p class="guide-card-desc">Baca analisis pertumbuhan jangka panjang, profitabilitas, dan strategi portofolio cabang.</p>
        </div>
      </div>
    </div>
    <div style="font-size: 0.75rem; color: var(--color-text-secondary); margin-top: 12px;">
      *Total bisnis tetap paling pas dibaca di halaman <a class="inline-link" href="/01-laporan-keuangan">Laporan Keuangan</a>.
    </div>
  </div>
</details>

<div class="evidence-tabs-container">
  <a href="/02-branch-performance" class="tab-button">🏠 Ringkasan</a>
  <a href="/02-branch-performance/deepdive" class="tab-button">🏪 Deep Dive</a>
  <a href="/02-branch-performance/analysis" class="tab-button">🔭 Evaluasi Strategis</a>
  <a href="/02-branch-performance/direktori-data" class="tab-button active">📁 Direktori Data</a>
</div>

<div style="margin-top: 32px; margin-bottom: 24px; max-width: 300px;">
  <Dropdown 
    data={cabang_list} 
    name="selected_cabang" 
    value="Cabang"
    title="Filter Cabang" 
    selectAllByDefault=true 
  />
</div>

<Tabs id="direktori_tabs" fullWidth=true>
  <Tab label="📊 Log Setoran Harian">
    <div class="section-card" style="margin-top: 16px;">
      <DataTable data={revenue_log} search=true rows=20>
        <Column id="Tanggal" />
        <Column id="Cabang" />
        <Column id="Jumlah_Transaksi" fmt="#,##0" />
        <Column id="Rata_Rata_Struk" fmt="#,##0" />
        <Column id="Omzet_Kotor" fmt="#,##0" />
        <Column id="Diskon_Promo" fmt="#,##0" />
        <Column id="Pajak_PB1" fmt="#,##0" />
        <Column id="Net_Setoran" fmt="#,##0" />
      </DataTable>
    </div>
  </Tab>
  
  <Tab label="⚡ Log Operasional (Overhead)">
    <div class="section-card" style="margin-top: 16px;">
      <DataTable data={overhead_log} search=true rows=20>
        <Column id="Tanggal" />
        <Column id="Cabang" />
        <Column id="Sewa_Gedung" fmt="#,##0" />
        <Column id="Tagihan_Listrik" fmt="#,##0" />
        <Column id="Tagihan_Air" fmt="#,##0" />
        <Column id="Internet_Telekomunikasi" fmt="#,##0" />
        <Column id="Maintenance_Lainnya" fmt="#,##0" />
        <Column id="Total_Overhead" fmt="#,##0" />
      </DataTable>
    </div>
  </Tab>
</Tabs>

</div>

{:else}
  <GlobalLoading />
{/if}
