---
title: Direktori Data

---

<InvGuide />



```sql raw_inventory
SELECT *
FROM restaurant.inventory_stok
WHERE (branch_name = '${inputs.selected_cabang?.value || inputs.selected_cabang || '%'}' OR '${inputs.selected_cabang?.value || inputs.selected_cabang || '%'}' = '%')
ORDER BY txn_date DESC, branch_name ASC, item_name ASC
```

```sql cabang_list
SELECT DISTINCT branch_name AS Cabang FROM restaurant.inventory_stok ORDER BY branch_name ASC
```

{#if typeof cabang_list !== 'undefined' && cabang_list.length > 0}

<div class="branch-analysis-body">

<div style="margin-top: 32px; margin-bottom: 24px; max-width: 300px;">
  <Dropdown 
    data={cabang_list} 
    name="selected_cabang" 
    value="Cabang"
    title="Filter Cabang" 
    selectAllByDefault=true 
  />
</div>

<div class="section-head tight" style="margin-bottom: 12px; margin-top: 24px;">
  <div>
    <h3 class="section-title">📦 Raw Data Inventori</h3>
  </div>
</div>
<div class="section-card">
  <DataTable data={raw_inventory} search=true rows=20>
    <Column id="txn_date" title="Tanggal Transaksi"/>
    <Column id="branch_name" title="Cabang"/>
    <Column id="item_name" title="Nama Barang"/>
    <Column id="category" title="Kategori"/>
    <Column id="stock_on_hand" title="Stok Tersisa" fmt="#,##0"/>
    <Column id="stock_value" title="Nilai Stok" fmt="#,##0"/>
    <Column id="usage_qty" title="Pemakaian (Qty)" fmt="#,##0"/>
    <Column id="usage_cost" title="Biaya Pemakaian" fmt="#,##0"/>
    <Column id="purchase_qty" title="Pembelian (Qty)" fmt="#,##0"/>
    <Column id="purchase_cost" title="Biaya Pembelian" fmt="#,##0"/>
    <Column id="supplier_name" title="Supplier"/>
  </DataTable>
</div>

</div>

{:else}
  <GlobalLoading />
{/if}
