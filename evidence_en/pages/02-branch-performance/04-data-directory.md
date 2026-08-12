---
title: Data Directory
---

<script>
  import DiagnosticsHeader from '$lib/DiagnosticsHeader.svelte';
  import SectionHeader from '$lib/SectionHeader.svelte';
  import SectionCard from '$lib/SectionCard.svelte';
  import PremiumTable from '$lib/PremiumTable.svelte';
  import GlobalLoading from '$lib/GlobalLoading.svelte';
</script>

<style>
</style>

```sql revenue_log
SELECT *
FROM restaurant.direktori_revenue_log
WHERE (Cabang = '${inputs.selected_location?.value || inputs.selected_location || '%'}' OR '${inputs.selected_location?.value || inputs.selected_location || '%'}' = '%')
ORDER BY Tanggal DESC, Cabang ASC
```

```sql overhead_log
SELECT *
FROM restaurant.direktori_overhead_log
WHERE (Cabang = '${inputs.selected_location?.value || inputs.selected_location || '%'}' OR '${inputs.selected_location?.value || inputs.selected_location || '%'}' = '%')
ORDER BY Tanggal DESC, Cabang ASC
```

```sql location_list
SELECT DISTINCT Cabang FROM restaurant.direktori_revenue_log ORDER BY Cabang ASC
```

{#if typeof revenue_log !== 'undefined' && typeof overhead_log !== 'undefined'}

<div class="branch-analysis-body">

_Multi-location portfolio breakdown: evaluate margin health, revenue growth, unit profitability, and strategic action priorities across branches._

<details class="guide-acc"  style="margin-top:12px; margin-bottom:12px;">
  <summary>💡 How to choose a subpage</summary>
    <div class="guide-body">
      <p style="margin-top: 4px; margin-bottom: 16px; font-weight: 500; color: var(--color-text-secondary);">
        Seamlessly navigate location performance, from high-level financial health down to granular outlet audits.
      </p>
      <div class="guide-grid" style="grid-template-columns: repeat(3, minmax(0, 1fr));">
        <div class="guide-card blue">
          <div class="guide-card-icon">🏠</div>
          <div class="guide-card-content">
            <div class="guide-card-label">Overview</div>
            <h4 class="guide-card-title">Core Metrics &amp; Variance</h4>
            <p class="guide-card-desc">Quickly monitor order volume, AOV, and performance variance across all outlets.</p>
          </div>
        </div>
        <div class="guide-card orange">
          <div class="guide-card-icon">🏪</div>
          <div class="guide-card-content">
            <div class="guide-card-label">Deep Dive</div>
            <h4 class="guide-card-title">Branch Audit</h4>
            <p class="guide-card-desc">Granular outlet analysis: daily margins, COGS breakdown, expenditure trends, and supporting data.</p>
          </div>
        </div>
        <div class="guide-card teal">
          <div class="guide-card-icon">🔭</div>
          <div class="guide-card-content">
            <div class="guide-card-label">Analysis</div>
            <h4 class="guide-card-title">Portfolio Strategy</h4>
            <p class="guide-card-desc">Evaluate long-term growth trajectories, unit profitability, and location-level strategic alignment.</p>
          </div>
        </div>
      </div>
      <div style="font-size: 0.75rem; color: var(--color-text-secondary); margin-top: 12px;">
        *For aggregate multi-unit financial health, visit the <a class="inline-link" href="/01-financial-report">Financial Report</a> page.
      </div>
    </div>
</details>

<div class="evidence-tabs-container">
  <a href="/02-branch-performance" class="tab-button">🏠 Overview</a>
  <a href="/02-branch-performance/02-deepdive" class="tab-button">🏪 Deep Dive</a>
  <a href="/02-branch-performance/03-analysis" class="tab-button">🔭 Analysis</a>
  <a href="/02-branch-performance/04-data-directory" class="tab-button active">📁 Data Directory</a>
</div>


<div style="margin-top: 32px; margin-bottom: 24px; max-width: 300px;">
  <Dropdown 
    data={location_list} 
    name="selected_location" 
    value="Cabang"
    title="Filter Locations" 
    selectAllByDefault=true 
  />
</div>

<Tabs id="direktori_tabs" fullWidth=true>
  <Tab label="📊 Daily Cash Settlement Log">
    <div class="section-card" style="margin-top: 16px;">
      <DataTable data={revenue_log} search=true rows=20>
        <Column id="Tanggal" title="Date" />
        <Column id="Cabang" title="Location" />
        <Column id="Jumlah_Transaksi" title="Ticket Count" fmt="#,##0" />
        <Column id="Rata_Rata_Struk" title="Average Ticket (AOV)" fmt="#,##0" />
        <Column id="Omzet_Kotor" title="Gross Revenue" fmt="#,##0" />
        <Column id="Diskon_Promo" title="Discounts & Promos" fmt="#,##0" />
        <Column id="Pajak_PB1" title="Sales Tax (PB1)" fmt="#,##0" />
        <Column id="Net_Setoran" title="Net Cash Deposit" fmt="#,##0" />
      </DataTable>
    </div>
  </Tab>
  
  <Tab label="⚡ Operational Opex Ledger">
    <div class="section-card" style="margin-top: 16px;">
      <DataTable data={overhead_log} search=true rows=20>
        <Column id="Tanggal" title="Date" />
        <Column id="Cabang" title="Location" />
        <Column id="Sewa_Gedung" title="Occupancy / Rent" fmt="#,##0" />
        <Column id="Tagihan_Listrik" title="Electricity" fmt="#,##0" />
        <Column id="Tagihan_Air" title="Water" fmt="#,##0" />
        <Column id="Internet_Telekomunikasi" title="Internet & Telecom" fmt="#,##0" />
        <Column id="Maintenance_Lainnya" title="R&M / Maintenance" fmt="#,##0" />
        <Column id="Total_Overhead" title="Total Overhead" fmt="#,##0" />
      </DataTable>
    </div>
  </Tab>
</Tabs>

</div>

{:else}
  <GlobalLoading />
{/if}
