---
title: Data Directory
---

<InvGuide />

<InvTabs activeTab="data-directory" />

```sql raw_inventory
SELECT *
FROM restaurant.inventory_stock
WHERE (branch_name = '${inputs.selected_location?.value || inputs.selected_location || '%'}' OR '${inputs.selected_location?.value || inputs.selected_location || '%'}' = '%')
ORDER BY txn_date DESC, branch_name ASC, item_name ASC
```

```sql location_list
SELECT DISTINCT branch_name AS Location FROM restaurant.inventory_stock ORDER BY branch_name ASC
```

{#if typeof location_list !== 'undefined' && location_list.length > 0}

<div class="branch-analysis-body">

<div style="margin-top: 32px; margin-bottom: 24px; max-width: 300px;">
  <Dropdown 
    data={location_list} 
    name="selected_location" 
    value="Location"
    title="Branch Filter" 
    selectAllByDefault=true 
  />
</div>

<div class="section-head tight" style="margin-bottom: 12px; margin-top: 24px;">
  <div>
    <h3 class="section-title">📦 Detailed Inventory Ledger</h3>
  </div>
</div>
<div class="section-card">
  <DataTable data={raw_inventory} search=true rows=20>
    <!-- Identitas & Lokasi -->
    <Column id="txn_date" title="Transaction Date"/>
    <Column id="branch_name" title="Branch Location"/>
    <Column id="item_name" title="Raw Material / Item"/>
    <Column id="category" title="Category"/>
    <Column id="unit" title="UOM"/> <!-- Unit of Measure: kg, liter, pcs -->

    <!-- Kelompok Kuantitas Fisik (Clustered Physical Quantities) -->
    <Column id="stock_on_hand" title="On-Hand Qty" fmt="#,##0"/>
    <Column id="usage_qty" title="Consumption Qty" fmt="#,##0"/>
    <Column id="purchase_qty" title="Procured Qty" fmt="#,##0"/>

    <!-- Kelompok Nilai Finansial (Clustered Financial Valuations) -->
    <Column id="stock_value" title="Inventory Valuation" fmt="#,##0"/>
    <Column id="usage_cost" title="Consumption Value" fmt="#,##0"/>
    <Column id="purchase_cost" title="Procurement Cost" fmt="#,##0"/>

    <!-- Vendor -->
    <Column id="supplier_name" title="Primary Vendor"/>
  </DataTable>
</div>

</div>

{:else}
  <GlobalLoading />
{/if}
