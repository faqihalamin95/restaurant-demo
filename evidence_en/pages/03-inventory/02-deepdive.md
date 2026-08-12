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
SELECT DISTINCT branch_name FROM restaurant.inventory_stock ORDER BY branch_name
```

<SectionCard 
  eyebrow="<span style='font-size: 12px;'>🏪 Select Branch</span>" 
  title="Branch Inventory Control Center" 
  description="Select an outlet to inspect location-specific stockout risks, overstock capital exposure, and physical inventory balances."
>
  <ButtonGroup name="location">
    {#each branch_list as branch, i}
      <ButtonGroupItem value={branch.branch_name} valueLabel={branch.branch_name} default={i === 0} />
    {/each}
  </ButtonGroup>
</SectionCard>

```sql branch_health
WITH max_d AS (SELECT MAX(txn_date)::DATE AS d FROM restaurant.inventory_stock),
latest AS (
    SELECT * FROM (
        SELECT *, ROW_NUMBER() OVER(PARTITION BY branch_name, item_name ORDER BY txn_date DESC) as rn
        FROM restaurant.inventory_stock
    ) WHERE rn = 1
),
movement_item AS (
    SELECT
        branch_name,
        item_name,
        ROUND(SUM(usage_qty)/30,2) AS avg_daily_usage
    FROM restaurant.inventory_stock CROSS JOIN max_d
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
    FROM restaurant.inventory_stock CROSS JOIN max_d
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
  eyebrow="⏱️ OPERATIONAL HEALTH"
  title="Branch Inventory Performance Summary"
  description="Tracks short-term stock velocity, depletion run-rates, and inventory variances to flag operational anomalies early."
/>

{#if typeof branch_list !== 'undefined' && branch_list.length > 0}
{@const activeLocation = inputs.location?.value ?? inputs.location}
{@const isLocationSelected = activeLocation && !String(activeLocation).includes('An Input has not been set')}

{#if !isLocationSelected}
  <div style="padding: 60px 20px; text-align: center; background: var(--color-background-secondary); border: 1px dashed var(--color-border-tertiary); border-radius: 12px; margin-top: 24px;">
    <h3 style="margin-top: 0;">👈 Please select a branch first</h3>
    <p style="color: var(--color-text-secondary); margin-bottom: 0;">Select one of the branches from the menu above to start analyzing warehouse inventory.</p>
  </div>
{:else}

{#if branch_health.length > 0}
  {@const branchHealthRow = branch_health.find(r => r.branch_name === activeLocation) || { overstock_value: 0, low_points: 0, purchase_usage_ratio_30d: 0 }}

  {@const overstockVal = branchHealthRow.overstock_value}
  {@const overstockStatus = overstockVal === 0 ? 'sehat' : overstockVal < 5000000 ? 'waspada' : 'kritis'}

  {@const lowPoints = branchHealthRow.low_points}
  {@const lowStatus = lowPoints === 0 ? 'sehat' : lowPoints <= 2 ? 'waspada' : 'kritis'}

  {@const ratio = branchHealthRow.purchase_usage_ratio_30d}
  {@const ratioStatus = (ratio >= 0.8 && ratio <= 1.3) ? 'sehat' : (ratio < 0.8 || ratio <= 1.5) ? 'waspada' : 'kritis'}

  <div class="period-strip" style="grid-template-columns: repeat(3, minmax(0, 1fr)); margin-bottom: 32px;">
    <div class="period-pill {overstockStatus}">
      <div class="period-pill-label">📦 Overstock Valuation (Deadstock)</div>
      <div class="period-pill-value" style="font-size: 1.05rem;">
        <span class="pill-badge {overstockStatus}">
          {overstockStatus === 'sehat' ? '✅ Healthy' : overstockStatus === 'waspada' ? '⚠️ Warning' : '🚨 Critical'}
        </span>
        Rp {overstockVal.toLocaleString('en-US')}
      </div>
      <div class="period-pill-copy" style="font-size: 0.76rem; line-height: 1.45;">
        Inventory holding period &gt;14 days at {activeLocation}.
      </div>
    </div>
    <div class="period-pill {lowStatus}">
      <div class="period-pill-label">🚨 Stockout Risk (Depletion Alert)</div>
      <div class="period-pill-value" style="font-size: 1.05rem;">
        <span class="pill-badge {lowStatus}">
          {lowStatus === 'sehat' ? '✅ Healthy' : lowStatus === 'waspada' ? '⚠️ Warning' : '🚨 Critical'}
        </span>
        {lowPoints} item
      </div>
      <div class="period-pill-copy" style="font-size: 0.76rem; line-height: 1.45;">
        Coverage &lt;3 days remaining. Imminent menu stockout risk.
      </div>
    </div>
    <div class="period-pill {ratioStatus}">
      <div class="period-pill-label">⚖️ Purchase-to-Usage Ratio (30D)</div>
      <div class="period-pill-value" style="font-size: 1.05rem;">
        <span class="pill-badge {ratioStatus}">
          {ratioStatus === 'sehat' ? '✅ Healthy' : ratioStatus === 'waspada' ? '⚠️ Warning' : '🚨 Critical'}
        </span>
        {ratio}x
      </div>
      <div class="period-pill-copy" style="font-size: 0.76rem; line-height: 1.45;">
        Optimal operational target: 0.8x – 1.3x.
      </div>
    </div>
  </div>
{/if}


```sql branch_lowstock
WITH max_d AS (SELECT MAX(txn_date)::DATE AS d FROM restaurant.inventory_stock),
movement AS (
    SELECT
        branch_name,
        item_name,
        ROUND(SUM(usage_qty)/30,2) AS avg_daily_usage
    FROM restaurant.inventory_stock CROSS JOIN max_d
    WHERE txn_date >= d - INTERVAL '29 days'
    GROUP BY 1, 2
),
latest AS (
    SELECT * FROM (
        SELECT *, ROW_NUMBER() OVER(PARTITION BY branch_name, item_name ORDER BY txn_date DESC) as rn
        FROM restaurant.inventory_stock
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
        WHEN m.calculated_days < 1 THEN '< 1 day'
        WHEN m.calculated_days < 3 THEN '< 3 days'
        ELSE '< 5 days'
    END AS estimasi_hari,
    m.avg_daily_usage,
    m.stock_value,
    CASE
        WHEN s.list_donor IS NOT NULL THEN 'Stock Mutation'
        ELSE 'Emergency PO'
    END AS saran_aksi,
    COALESCE(s.list_donor, '-') AS location_donor,
    CASE
        WHEN m.calculated_days < 1 THEN 'Not enough for tomorrow'
        WHEN m.calculated_days < 3 THEN 'Critical stock, reorder immediately'
        ELSE 'Keep stock above 3 days'
    END AS status
FROM merged m
LEFT JOIN safe_branches s ON m.item_name = s.item_name
WHERE m.calculated_days <= 5
ORDER BY m.calculated_days ASC
```

```sql branch_overstock
WITH max_d AS (SELECT MAX(txn_date)::DATE AS d FROM restaurant.inventory_stock),
movement AS (
    SELECT
        branch_name,
        item_name,
        ROUND(SUM(usage_qty)/30,2) AS avg_daily_usage
    FROM restaurant.inventory_stock CROSS JOIN max_d
    WHERE txn_date >= d - INTERVAL '29 days'
    GROUP BY 1, 2
),
latest AS (
    SELECT * FROM (
        SELECT *, ROW_NUMBER() OVER(PARTITION BY branch_name, item_name ORDER BY txn_date DESC) as rn
        FROM restaurant.inventory_stock
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
    ROUND(calculated_days, 0)::INT || ' days' AS coverage_hari,
    stock_value,
    CASE
        WHEN calculated_days > 30 THEN 'Dead Money (>30 Days)'
        WHEN calculated_days > 21 THEN 'Heavy Overstock'
        ELSE 'Light Overstock'
    END AS status
FROM merged
WHERE calculated_days > 14
ORDER BY stock_value DESC
```

```sql branch_actual
WITH max_d AS (SELECT MAX(txn_date)::DATE AS d FROM restaurant.inventory_stock),
movement AS (
    SELECT
        branch_name,
        item_name,
        ROUND(SUM(usage_qty)/30,2) AS avg_daily_usage
    FROM restaurant.inventory_stock CROSS JOIN max_d
    WHERE txn_date >= d - INTERVAL '29 days'
    GROUP BY 1, 2
),
latest AS (
    SELECT * FROM (
        SELECT *, ROW_NUMBER() OVER(PARTITION BY branch_name, item_name ORDER BY txn_date DESC) as rn
        FROM restaurant.inventory_stock
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
        WHEN calculated_days < 1 THEN '< 1 day'
        WHEN calculated_days < 3 THEN '< 3 days'
        ELSE ROUND(calculated_days, 0)::INT || ' days'
    END AS estimasi_hari,
    calculated_days AS days_remaining
FROM merged
ORDER BY item_name ASC
```

<Tabs fullWidth=true>
  <Tab label="📋 Actual Stock (Ledger)">
    <div style="margin-top: 16px;">
      <SectionHeader 
        eyebrow="📋 INVENTORY LEDGER"
        title="Warehouse Stock Ledger - {activeLocation}"
        description="Itemized physical stock counts, unit valuation, depletion run-rates, and stockout risk indicators for this outlet."
      />
      <PremiumTable 
        data={branch_actual.filter(d => d.branch_name === activeLocation)} 
        pageSize={100}
        columns={[
          { key: 'item_name', title: 'Raw Material' },
          { key: 'category', title: 'Category' },
          { key: 'avg_daily_usage', title: 'Avg Daily Usage', format: '#,##0.0' },
          { key: 'stock_on_hand', title: 'On-Hand Stock', format: '#,##0.0' },
          { key: 'unit', title: 'Unit' },
          { key: 'stock_value', title: 'Stock Valuation', type: 'currency' },
          { key: 'estimasi_hari', title: 'Est. Runway (Days)' }
        ]}
      />
    </div>
  </Tab>

  <Tab label="🚨 Stockout Risks">
    <div style="margin-top: 16px;">
      {#if branch_lowstock.filter(d => d.branch_name === activeLocation).length > 0}
        <SectionHeader 
          eyebrow="🚨 DEPLETION ALERT"
          title="List of Items Prone to Run Out - {activeLocation}"
          description="Identifies high-velocity ingredients near safety stock limits. Immediate purchase order (PO) issuance or inter-branch transfer required."
        />
        <PremiumTable 
          data={branch_lowstock.filter(d => d.branch_name === activeLocation)} 
          rowColor={(row) => row.days_remaining < 1 ? 'rgba(239, 68, 68, 0.15)' : row.days_remaining < 3 ? 'rgba(234, 179, 8, 0.15)' : null}
          columns={[
            { key: 'item_name', title: 'Raw Material' },
            { key: 'category', title: 'Category' },
            { key: 'avg_daily_usage', title: 'Avg Daily Usage', format: '#,##0.0' },
            { key: 'stock_on_hand', title: 'On-Hand Stock', format: '#,##0.0' },
            { key: 'estimasi_hari', title: 'Est. Runway (Days)' },
            { key: 'saran_aksi', title: 'Recommended Action' },
            { key: 'location_donor', title: 'Surplus Source Location' }
          ]}
        />
      {:else}
        <div class="action-empty" style="text-align: center; padding: 48px 24px; background: rgba(22, 163, 74, 0.05); border: 1px dashed rgba(22, 163, 74, 0.3); border-radius: 12px; margin-top: 24px;">
          <div style="font-size: 3rem; margin-bottom: 12px;">✅</div>
          <div class="title" style="font-size: 1.25rem; font-weight: 700; color: #166534; margin-bottom: 4px;">Optimal Inventory Runway</div>
          <div class="subtitle" style="color: #15803d;">All raw materials at {activeLocation} are currently operating above critical depletion thresholds.</div>
        </div>
      {/if}
    </div>
  </Tab>

  <Tab label="📦 Capital Exposure">
    <div style="margin-top: 16px;">
      {#if branch_overstock.filter(d => d.branch_name === activeLocation).length > 0}
        <SectionHeader 
          eyebrow="📦 CAPITAL EXPOSURE"
          title="Overstock & Deadstock Inventory - {activeLocation}"
          description="Identifies slow-moving inventory exceeding 14-day hold thresholds, locking up working capital and increasing spoilage risk."
        />
        <PremiumTable 
          data={branch_overstock.filter(d => d.branch_name === activeLocation)} 
          rowColor={(row) => row.days_remaining > 30 ? 'rgba(239, 68, 68, 0.15)' : row.days_remaining > 21 ? 'rgba(234, 179, 8, 0.15)' : null}
          columns={[
            { key: 'item_name', title: 'Raw Material' },
            { key: 'category', title: 'Category' },
            { key: 'stock_on_hand', title: 'On-Hand Stock', format: '#,##0.0' },
            { key: 'unit', title: 'Unit' },
            { key: 'stock_value', title: 'Tied-Up Capital', type: 'currency' },
            { key: 'coverage_hari', title: 'Days on Hand (DOH)' },
            { key: 'status', title: 'Holding Status' }
          ]}
        />
      {:else}
        <div class="action-empty" style="text-align: center; padding: 48px 24px; background: rgba(22, 163, 74, 0.05); border: 1px dashed rgba(22, 163, 74, 0.3); border-radius: 12px; margin-top: 24px;">
          <div style="font-size: 3rem; margin-bottom: 12px;">✅</div>
          <div class="title" style="font-size: 1.25rem; font-weight: 700; color: #166534; margin-bottom: 4px;">Optimal Working Capital</div>
          <div class="subtitle" style="color: #15803d;">All inventory holdings at {activeLocation} are operating within healthy turnover limits. No tied-up capital detected.</div>
        </div>
      {/if}
    </div>
  </Tab>
</Tabs>

{/if}

{:else}
  <GlobalLoading />
{/if}
