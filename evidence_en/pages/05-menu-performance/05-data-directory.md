---
title: Data Directory
---

<script>
  import SectionCard from '$lib/SectionCard.svelte';
</script>

<MenuTabs activeTab="direktori" />

```sql menu_branch_list_all
SELECT branch_name FROM (
  SELECT 0 as sort_order, 'All Branches' as branch_name
  UNION ALL
  SELECT 1 as sort_order, branch_name FROM restaurant.mart_menu_branch_list
) ORDER BY sort_order, branch_name
```

<SectionCard 
  eyebrow="<span style='font-size: 12px;'>🏪 Location Filter</span>" 
  title="Branch Transaction Data Room" 
  description="Granular transaction records and performance metrics filtered by specific branch location."
>
    <ButtonGroup name="focus_branch">
      {#each menu_branch_list_all as branch}
        <ButtonGroupItem value={branch.branch_name} valueLabel={branch.branch_name} />
      {/each}
    </ButtonGroup>
</SectionCard>

```sql raw_data
SELECT 
    order_date,
    branch_name,
    menu_name,
    category,
    price_tier,
    total_qty_sold,
    total_revenue
FROM restaurant.menu_performance
WHERE ('${inputs.focus_branch?.value ?? inputs.focus_branch}' = 'All Branches' OR branch_name = '${inputs.focus_branch?.value ?? inputs.focus_branch}')
  AND '${inputs.focus_branch?.value ?? inputs.focus_branch}' != 'undefined'
ORDER BY order_date DESC
LIMIT 5000
```

<div style="margin-top: 32px;">
    {#if raw_data.length > 0}
        <DataTable data={raw_data} search="true" rows="15">
            <Column id="order_date" title="Date" />
            <Column id="branch_name" title="Branch Location" />
            <Column id="menu_name" title="Item Name" />
            <Column id="category" title="Category" />
            <Column id="price_tier" title="Unit Price" />
            <Column id="total_qty_sold" title="Order Volume" align="right" fmt="#,##0" />
            <Column id="total_revenue" title="Gross Revenue" align="right" fmt="#,##0" />
        </DataTable>
    {:else}
        <div style="padding: 40px; text-align: center; border: 1px dashed rgba(0,0,0,0.1); border-radius: 12px; color: var(--color-text-secondary);">
            <em>No transaction records loaded. Select a location to display branch data.</em>
        </div>
    {/if}
</div>
