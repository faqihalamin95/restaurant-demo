---
title: Deepdive
---

<script>
  import PremiumTable from '$lib/PremiumTable.svelte';
  import SectionCard from '$lib/SectionCard.svelte';
  import SectionHeader from '$lib/SectionHeader.svelte';
</script>



<InvGuide />

<InvTabs activeTab="deepdive" />

```sql branch_list
SELECT DISTINCT branch_name FROM restaurant.inventory_stok ORDER BY branch_name
```

<SectionCard 
  eyebrow="<span style='font-size: 12px;'>🏪 Pilih Cabang</span>" 
  title="Pusat Kendali Inventori Per Cabang" 
  description="Pilih cabang tertentu untuk melihat detail barang rawan habis, barang overstock, dan posisi stok gudang saat ini."
>
  <ButtonGroup name="cabang">
    {#each branch_list as branch, i}
      <ButtonGroupItem value={branch.branch_name} valueLabel={branch.branch_name} default={i === 0} />
    {/each}
  </ButtonGroup>
</SectionCard>

```sql branch_health
WITH max_d AS (SELECT MAX(txn_date)::DATE AS d FROM restaurant.inventory_stok),
latest AS (
    SELECT * FROM (
        SELECT *, ROW_NUMBER() OVER(PARTITION BY branch_name, item_name ORDER BY txn_date DESC) as rn
        FROM restaurant.inventory_stok
    ) WHERE rn = 1
),
movement_item AS (
    SELECT
        branch_name,
        item_name,
        ROUND(SUM(usage_qty)/30,2) AS avg_daily_usage
    FROM restaurant.inventory_stok CROSS JOIN max_d
    WHERE txn_date >= d - INTERVAL '29 days'
    GROUP BY 1, 2
),
merged_item AS (
    SELECT 
        l.*,
        COALESCE(m.avg_daily_usage, 0) AS avg_daily_usage,
        COALESCE(l.stock_on_hand / NULLIF(m.avg_daily_usage, 0), l.days_remaining) AS calculated_days
    FROM latest l
    LEFT JOIN movement_item m ON l.item_name = m.item_name AND l.branch_name = m.branch_name
),
movement_branch AS (
    SELECT
        branch_name,
        SUM(CASE WHEN txn_date >= d - INTERVAL '29 days' THEN usage_cost ELSE 0 END) AS usage_cost_30d,
        SUM(CASE WHEN txn_date >= d - INTERVAL '29 days' THEN purchase_cost ELSE 0 END) AS purchase_cost_30d
    FROM restaurant.inventory_stok CROSS JOIN max_d
    GROUP BY branch_name
)
SELECT
    i.branch_name,
    COALESCE(ROUND(SUM(CASE WHEN i.calculated_days > 14 THEN i.stock_value ELSE 0 END),0), 0) AS overstock_value,
    COALESCE(SUM(CASE WHEN i.calculated_days < 3 THEN 1 ELSE 0 END), 0) AS low_points,
    COALESCE(ROUND(MAX(b.purchase_cost_30d)/NULLIF(MAX(b.usage_cost_30d),0),2), 0) AS purchase_usage_ratio_30d
FROM merged_item i
LEFT JOIN movement_branch b ON i.branch_name = b.branch_name
GROUP BY i.branch_name
```

<SectionHeader 
  eyebrow="⏱️ KESEHATAN OPERASIONAL"
  title="Ringkasan Kinerja Inventori Cabang"
  description="Metrik operasional penting dari performa gudang harian jangka pendek hingga jangka menengah untuk mendeteksi anomali secara dini."
/>

{#if typeof branch_list !== 'undefined' && branch_list.length > 0}
{@const activeCabang = inputs.cabang?.value ?? inputs.cabang}
{@const isCabangSelected = activeCabang && !String(activeCabang).includes('An Input has not been set')}

{#if !isCabangSelected}
  <div style="padding: 60px 20px; text-align: center; background: var(--color-background-secondary); border: 1px dashed var(--color-border-tertiary); border-radius: 12px; margin-top: 24px;">
    <h3 style="margin-top: 0;">👈 Silakan pilih cabang terlebih dahulu</h3>
    <p style="color: var(--color-text-secondary); margin-bottom: 0;">Pilih salah satu cabang pada menu di atas untuk mulai menganalisis inventori gudang.</p>
  </div>
{:else}

{#if branch_health.length > 0}
  {@const branchHealthRow = branch_health.find(r => r.branch_name === activeCabang) || { overstock_value: 0, low_points: 0, purchase_usage_ratio_30d: 0 }}

  {@const overstockVal = branchHealthRow.overstock_value}
  {@const overstockStatus = overstockVal === 0 ? 'sehat' : overstockVal < 5000000 ? 'waspada' : 'kritis'}

  {@const lowPoints = branchHealthRow.low_points}
  {@const lowStatus = lowPoints === 0 ? 'sehat' : lowPoints <= 2 ? 'waspada' : 'kritis'}

  {@const ratio = branchHealthRow.purchase_usage_ratio_30d}
  {@const ratioStatus = (ratio >= 0.8 && ratio <= 1.3) ? 'sehat' : (ratio < 0.8 || ratio <= 1.5) ? 'waspada' : 'kritis'}

  <div class="period-strip" style="grid-template-columns: repeat(3, minmax(0, 1fr)); margin-bottom: 32px;">
    <div class="period-pill {overstockStatus}">
      <div class="period-pill-label">📦 Nilai Overstock (Uang Mati)</div>
      <div class="period-pill-value" style="font-size: 1.05rem;">
        <span class="pill-badge {overstockStatus}">
          {overstockStatus === 'sehat' ? '✅ Sehat' : overstockStatus === 'waspada' ? '⚠️ Waspada' : '🚨 Kritis'}
        </span>
        Rp {overstockVal.toLocaleString('id-ID')}
      </div>
      <div class="period-pill-copy" style="font-size: 0.76rem; line-height: 1.45;">
        Barang numpuk &gt;14 hari di gudang {activeCabang}.
      </div>
    </div>
    <div class="period-pill {lowStatus}">
      <div class="period-pill-label">🚨 Item Kritis (Low Stock)</div>
      <div class="period-pill-value" style="font-size: 1.05rem;">
        <span class="pill-badge {lowStatus}">
          {lowStatus === 'sehat' ? '✅ Sehat' : lowStatus === 'waspada' ? '⚠️ Waspada' : '🚨 Kritis'}
        </span>
        {lowPoints} item
      </div>
      <div class="period-pill-copy" style="font-size: 0.76rem; line-height: 1.45;">
        Barang akan habis &lt; 3 hari dan berisiko sold-out.
      </div>
    </div>
    <div class="period-pill {ratioStatus}">
      <div class="period-pill-label">⚖️ Rasio Beli/Pakai (30 Hari)</div>
      <div class="period-pill-value" style="font-size: 1.05rem;">
        <span class="pill-badge {ratioStatus}">
          {ratioStatus === 'sehat' ? '✅ Sehat' : ratioStatus === 'waspada' ? '⚠️ Waspada' : '🚨 Kritis'}
        </span>
        {ratio}x
      </div>
      <div class="period-pill-copy" style="font-size: 0.76rem; line-height: 1.45;">
        Batas aman operasional: 0.8x - 1.3x.
      </div>
    </div>
  </div>
{/if}


```sql branch_lowstock
WITH max_d AS (SELECT MAX(txn_date)::DATE AS d FROM restaurant.inventory_stok),
movement AS (
    SELECT
        branch_name,
        item_name,
        ROUND(SUM(usage_qty)/30,2) AS avg_daily_usage
    FROM restaurant.inventory_stok CROSS JOIN max_d
    WHERE txn_date >= d - INTERVAL '29 days'
    GROUP BY 1, 2
),
latest AS (
    SELECT * FROM (
        SELECT *, ROW_NUMBER() OVER(PARTITION BY branch_name, item_name ORDER BY txn_date DESC) as rn
        FROM restaurant.inventory_stok
    ) WHERE rn = 1
),
merged AS (
    SELECT 
        l.*,
        COALESCE(m.avg_daily_usage, 0) AS avg_daily_usage,
        COALESCE(l.stock_on_hand / NULLIF(m.avg_daily_usage, 0), l.days_remaining) AS calculated_days
    FROM latest l
    LEFT JOIN movement m ON l.item_name = m.item_name AND l.branch_name = m.branch_name
),
safe_branches AS (
    SELECT 
        item_name,
        STRING_AGG(branch_name, ', ') AS list_donor
    FROM merged 
    WHERE calculated_days > 7
    GROUP BY item_name
)
SELECT
    m.branch_name,
    m.item_name,
    m.category,
    m.stock_on_hand,
    m.unit,
    m.calculated_days AS days_remaining,
    CASE 
        WHEN m.calculated_days < 1 THEN '< 1 hari'
        WHEN m.calculated_days < 3 THEN '< 3 hari'
        ELSE '< 5 hari'
    END AS estimasi_hari,
    m.avg_daily_usage,
    m.stock_value,
    CASE
        WHEN s.list_donor IS NOT NULL THEN 'Mutasi Stok'
        ELSE 'PO Darurat'
    END AS saran_aksi,
    COALESCE(s.list_donor, '-') AS cabang_donor,
    CASE
        WHEN m.calculated_days < 1 THEN 'Tidak cukup untuk esok hari'
        WHEN m.calculated_days < 3 THEN 'Stok kritis, reorder segera'
        ELSE 'Jaga stok agar tidak kurang dari 3 hari'
    END AS status
FROM merged m
LEFT JOIN safe_branches s ON m.item_name = s.item_name
WHERE m.calculated_days <= 5
ORDER BY m.calculated_days ASC
```

```sql branch_overstock
WITH max_d AS (SELECT MAX(txn_date)::DATE AS d FROM restaurant.inventory_stok),
movement AS (
    SELECT
        branch_name,
        item_name,
        ROUND(SUM(usage_qty)/30,2) AS avg_daily_usage
    FROM restaurant.inventory_stok CROSS JOIN max_d
    WHERE txn_date >= d - INTERVAL '29 days'
    GROUP BY 1, 2
),
latest AS (
    SELECT * FROM (
        SELECT *, ROW_NUMBER() OVER(PARTITION BY branch_name, item_name ORDER BY txn_date DESC) as rn
        FROM restaurant.inventory_stok
    ) WHERE rn = 1
),
merged AS (
    SELECT 
        l.*,
        COALESCE(m.avg_daily_usage, 0) AS avg_daily_usage,
        COALESCE(l.stock_on_hand / NULLIF(m.avg_daily_usage, 0), l.days_remaining) AS calculated_days
    FROM latest l
    LEFT JOIN movement m ON l.item_name = m.item_name AND l.branch_name = m.branch_name
)
SELECT
    branch_name,
    item_name,
    category,
    stock_on_hand,
    unit,
    calculated_days AS days_remaining,
    ROUND(calculated_days, 0)::INT || ' hari' AS coverage_hari,
    stock_value,
    CASE
        WHEN calculated_days > 30 THEN 'Uang Mati (>30 Hari)'
        WHEN calculated_days > 21 THEN 'Overstock Berat'
        ELSE 'Overstock Ringan'
    END AS status
FROM merged
WHERE calculated_days > 14
ORDER BY stock_value DESC
```

```sql branch_actual
WITH max_d AS (SELECT MAX(txn_date)::DATE AS d FROM restaurant.inventory_stok),
movement AS (
    SELECT
        branch_name,
        item_name,
        ROUND(SUM(usage_qty)/30,2) AS avg_daily_usage
    FROM restaurant.inventory_stok CROSS JOIN max_d
    WHERE txn_date >= d - INTERVAL '29 days'
    GROUP BY 1, 2
),
latest AS (
    SELECT * FROM (
        SELECT *, ROW_NUMBER() OVER(PARTITION BY branch_name, item_name ORDER BY txn_date DESC) as rn
        FROM restaurant.inventory_stok
    ) WHERE rn = 1
),
merged AS (
    SELECT 
        l.*,
        COALESCE(m.avg_daily_usage, 0) AS avg_daily_usage,
        COALESCE(l.stock_on_hand / NULLIF(m.avg_daily_usage, 0), l.days_remaining) AS calculated_days
    FROM latest l
    LEFT JOIN movement m ON l.item_name = m.item_name AND l.branch_name = m.branch_name
)
SELECT
    branch_name,
    item_name,
    category,
    avg_daily_usage,
    stock_on_hand,
    unit,
    stock_value,
    CASE 
        WHEN calculated_days < 1 THEN '< 1 hari'
        WHEN calculated_days < 3 THEN '< 3 hari'
        ELSE ROUND(calculated_days, 0)::INT || ' hari'
    END AS estimasi_hari,
    calculated_days AS days_remaining
FROM merged
ORDER BY item_name ASC
```

<Tabs fullWidth=true>
  <Tab label="📋 Stok Aktual (Buku Besar)">
    <div style="margin-top: 16px;">
      <SectionHeader 
        eyebrow="📋 BUKU BESAR GUDANG"
        title="Buku Besar Stok Gudang - {activeCabang}"
        description="Catatan lengkap dan detail metrik untuk seluruh item inventori di cabang ini."
      />
      <PremiumTable 
        data={branch_actual.filter(d => d.branch_name === activeCabang)} 
        pageSize={100}
        columns={[
          { key: 'item_name', title: 'Bahan Baku' },
          { key: 'category', title: 'Kategori' },
          { key: 'avg_daily_usage', title: 'Avg Pakai/Hari', format: '#,##0.0' },
          { key: 'stock_on_hand', title: 'Stok', format: '#,##0.0' },
          { key: 'unit', title: 'Satuan' },
          { key: 'stock_value', title: 'Total Nilai (Rp)', type: 'currency' },
          { key: 'estimasi_hari', title: 'Coverage' }
        ]}
      />
    </div>
  </Tab>

  <Tab label="🚨 Darurat (Low Stock)">
    <div style="margin-top: 16px;">
      {#if branch_lowstock.filter(d => d.branch_name === activeCabang).length > 0}
        <SectionHeader 
          eyebrow="🚨 KONDISI DARURAT"
          title="Daftar Bahan Rawan Habis - {activeCabang}"
          description="Pantauan item yang berisiko sold-out dalam waktu dekat dan butuh tindakan segera."
        />
        <PremiumTable 
          data={branch_lowstock.filter(d => d.branch_name === activeCabang)} 
          rowColor={(row) => row.days_remaining < 1 ? 'rgba(239, 68, 68, 0.15)' : row.days_remaining < 3 ? 'rgba(234, 179, 8, 0.15)' : null}
          columns={[
            { key: 'item_name', title: 'Bahan Baku' },
            { key: 'category', title: 'Kategori' },
            { key: 'avg_daily_usage', title: 'Avg Pakai/Hari', format: '#,##0.0' },
            { key: 'stock_on_hand', title: 'Stok', format: '#,##0.0' },
            { key: 'estimasi_hari', title: 'Coverage' },
            { key: 'saran_aksi', title: 'Tindakan' },
            { key: 'cabang_donor', title: 'Tersedia Berlebih Di' }
          ]}
        />
      {:else}
        <div class="action-empty" style="text-align: center; padding: 48px 24px; background: rgba(22, 163, 74, 0.05); border: 1px dashed rgba(22, 163, 74, 0.3); border-radius: 12px; margin-top: 24px;">
          <div style="font-size: 3rem; margin-bottom: 12px;">✅</div>
          <div class="title" style="font-size: 1.25rem; font-weight: 700; color: #166534; margin-bottom: 4px;">Stok Aman Terkendali</div>
          <div class="subtitle" style="color: #15803d;">Tidak ada bahan baku kritis di {activeCabang} saat ini.</div>
        </div>
      {/if}
    </div>
  </Tab>

  <Tab label="📦 Uang Mati (Overstock)">
    <div style="margin-top: 16px;">
      {#if branch_overstock.filter(d => d.branch_name === activeCabang).length > 0}
        <SectionHeader 
          eyebrow="📦 PENUMPUKAN MODAL"
          title="Daftar Barang Overstock - {activeCabang}"
          description="Identifikasi barang dengan perputaran lambat yang membebani kapasitas gudang dan arus kas."
        />
        <PremiumTable 
          data={branch_overstock.filter(d => d.branch_name === activeCabang)} 
          rowColor={(row) => row.days_remaining > 30 ? 'rgba(239, 68, 68, 0.15)' : row.days_remaining > 21 ? 'rgba(234, 179, 8, 0.15)' : null}
          columns={[
            { key: 'item_name', title: 'Bahan Baku' },
            { key: 'category', title: 'Kategori' },
            { key: 'stock_on_hand', title: 'Stok', format: '#,##0.0' },
            { key: 'unit', title: 'Satuan' },
            { key: 'stock_value', title: 'Nilai Rupiah Tertahan', type: 'currency' },
            { key: 'coverage_hari', title: 'Coverage' },
            { key: 'status', title: 'Klasifikasi' }
          ]}
        />
      {:else}
        <div class="action-empty" style="text-align: center; padding: 48px 24px; background: rgba(22, 163, 74, 0.05); border: 1px dashed rgba(22, 163, 74, 0.3); border-radius: 12px; margin-top: 24px;">
          <div style="font-size: 3rem; margin-bottom: 12px;">✅</div>
          <div class="title" style="font-size: 1.25rem; font-weight: 700; color: #166534; margin-bottom: 4px;">Arus Kas Sangat Sehat</div>
          <div class="subtitle" style="color: #15803d;">Tidak ada indikasi overstock (uang mati) di {activeCabang} saat ini.</div>
        </div>
      {/if}
    </div>
  </Tab>
</Tabs>

{/if}

{:else}
  <GlobalLoading />
{/if}
