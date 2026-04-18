---
title: Inventory & Raw Materials
---

_Monitor usage, purchasing, and ingredient costs by location._

> ⚠️ **Note:** This dashboard shows **inventory flow** based on daily transactions, not physical stock on hand. To see actual warehouse stock, integration with your POS or inventory management system is required.

```sql header_kpi
SELECT
    SUM(usage_cost)                                                AS total_usage_cost,
    SUM(purchase_cost)                                             AS total_purchase_cost,
    COUNT(DISTINCT item_name)                                      AS total_items,
    COUNT(DISTINCT branch_name)                                    AS total_locations
FROM restaurant_en.inventory_stok
WHERE txn_date >= (SELECT MAX(txn_date) FROM restaurant_en.inventory_stok) - INTERVAL '30 days'
```

```sql price_alert_count
SELECT COUNT(DISTINCT item_name) AS flagged_items
FROM (
    SELECT item_name
    FROM restaurant_en.inventory_stok
    WHERE txn_date >= (SELECT MAX(txn_date) FROM restaurant_en.inventory_stok) - INTERVAL '30 days'
    GROUP BY item_name
    HAVING (AVG(avg_unit_cost) - AVG(base_unit_cost)) / NULLIF(AVG(base_unit_cost), 0) * 100 > 10
)
```

```sql overstock_alert_count
SELECT COUNT(DISTINCT branch_name) AS flagged_locations
FROM (
    SELECT branch_name
    FROM restaurant_en.inventory_stok
    WHERE txn_date >= (SELECT MAX(txn_date) FROM restaurant_en.inventory_stok) - INTERVAL '30 days'
    GROUP BY branch_name
    HAVING SUM(purchase_cost) > SUM(usage_cost) * 1.3
)
```

```sql periode_30d
SELECT
    STRFTIME('%b %d, %Y', MAX(txn_date) - INTERVAL '29 days') AS date_from,
    STRFTIME('%b %d, %Y', MAX(txn_date))                       AS date_to
FROM restaurant_en.inventory_stok
```

```sql wow_cost
SELECT
    SUM(CASE WHEN txn_date >= (SELECT MAX(txn_date) FROM restaurant_en.inventory_stok) - INTERVAL '6 days'
        THEN usage_cost END) AS cost_this_week,
    SUM(CASE WHEN txn_date >= (SELECT MAX(txn_date) FROM restaurant_en.inventory_stok) - INTERVAL '13 days'
         AND txn_date <  (SELECT MAX(txn_date) FROM restaurant_en.inventory_stok) - INTERVAL '6 days'
        THEN usage_cost END) AS cost_last_week,
    ROUND(
        (SUM(CASE WHEN txn_date >= (SELECT MAX(txn_date) FROM restaurant_en.inventory_stok) - INTERVAL '6 days'
            THEN usage_cost END)
        - SUM(CASE WHEN txn_date >= (SELECT MAX(txn_date) FROM restaurant_en.inventory_stok) - INTERVAL '13 days'
             AND txn_date <  (SELECT MAX(txn_date) FROM restaurant_en.inventory_stok) - INTERVAL '6 days'
            THEN usage_cost END))
        / NULLIF(SUM(CASE WHEN txn_date >= (SELECT MAX(txn_date) FROM restaurant_en.inventory_stok) - INTERVAL '13 days'
             AND txn_date <  (SELECT MAX(txn_date) FROM restaurant_en.inventory_stok) - INTERVAL '6 days'
            THEN usage_cost END), 0) * 100
    , 1) AS pct_change
FROM restaurant_en.inventory_stok
```

---

## Last 30 Days Summary

<span style="font-size:0.85em;color:var(--color-text-secondary)">{periode_30d[0].date_from} – {periode_30d[0].date_to}</span>

<BigValue data={header_kpi} value="total_usage_cost"    title="Total Usage Cost"    fmt="$#,##0.00" />
<BigValue data={header_kpi} value="total_purchase_cost" title="Total Purchases"     fmt="$#,##0.00" />
<BigValue data={header_kpi} value="total_items"         title="Tracked Ingredients" />
<BigValue data={header_kpi} value="total_locations"     title="Locations Monitored" />

{#if wow_cost[0].pct_change > 10}
<div style="background:rgba(220,38,38,0.08);border-left:4px solid #dc2626;padding:12px 16px;border-radius:6px;margin:8px 0;">
🔴 <strong>Usage cost up {wow_cost[0].pct_change}% this week</strong> vs last week. Check which items are driving the increase in the category table below.
</div>
{:else if wow_cost[0].pct_change < -10}
<div style="background:rgba(22,163,74,0.08);border-left:4px solid #16a34a;padding:12px 16px;border-radius:6px;margin:8px 0;">
✅ <strong>Usage cost down {Math.abs(wow_cost[0].pct_change)}% this week</strong> — efficiency improved or operational volume was lower.
</div>
{:else}
<div style="background:rgba(100,116,139,0.08);border-left:4px solid #888;padding:12px 16px;border-radius:6px;margin:8px 0;">
➡️ <strong>Usage cost stable</strong> — only {wow_cost[0].pct_change}% vs last week.
</div>
{/if}

{#if price_alert_count[0].flagged_items > 0}
<div style="background:rgba(220,38,38,0.08);border-left:4px solid #dc2626;padding:12px 16px;border-radius:6px;margin:16px 0;">
🔴 <strong>{price_alert_count[0].flagged_items} ingredient(s)</strong> with actual purchase price >10% above baseline. Renegotiate with supplier — see Price Comparison section below.
</div>
{:else if overstock_alert_count[0].flagged_locations > 0}
<div style="background:rgba(248,201,0,0.1);border-left:4px solid #f8c900;padding:12px 16px;border-radius:6px;margin:16px 0;">
🟡 <strong>{overstock_alert_count[0].flagged_locations} location(s)</strong> with purchases exceeding usage by >30% — potential overstock or inefficient ordering schedule.
</div>
{:else}
<div style="background:rgba(22,163,74,0.08);border-left:4px solid #16a34a;padding:12px 16px;border-radius:6px;margin:16px 0;">
✅ <strong>All indicators normal.</strong> No significant price spikes or overstock detected in the last 30 days.
</div>
{/if}

---

## Cost by Category (Last 30 Days)

```sql category_summary
SELECT
    category,
    COUNT(DISTINCT item_name)                                                       AS total_items,
    SUM(usage_qty)                                                                  AS total_usage_qty,
    SUM(usage_cost)                                                                 AS total_usage_cost,
    SUM(purchase_cost)                                                              AS total_purchase_cost,
    ROUND(SUM(usage_cost) / NULLIF(SUM(SUM(usage_cost)) OVER (), 0) * 100, 1)      AS pct_of_total,
    ROUND(SUM(purchase_cost) / NULLIF(SUM(usage_cost), 0), 2)                      AS buy_use_ratio
FROM restaurant_en.inventory_stok
WHERE txn_date >= (SELECT MAX(txn_date) FROM restaurant_en.inventory_stok) - INTERVAL '30 days'
GROUP BY category
ORDER BY total_usage_cost DESC
```

```sql category_trend
SELECT
    txn_date,
    category,
    SUM(usage_cost) AS usage_cost
FROM restaurant_en.inventory_stok
WHERE txn_date >= (SELECT MAX(txn_date) FROM restaurant_en.inventory_stok) - INTERVAL '30 days'
GROUP BY 1, 2
ORDER BY 1, 2
```

<Grid cols=2>
<div>

### Usage Cost by Category

<BarChart
    data={category_summary}
    x="category"
    y="total_usage_cost"
    title="Total Usage Cost by Category ($)"
    yFmt="$#,##0.00"
    xAxisTitle="Category"
    yAxisTitle="Cost ($)"
/>

</div>
<div>

### Daily Trend by Category

<LineChart
    data={category_trend}
    x="txn_date"
    y="usage_cost"
    series="category"
    title="Daily Usage Cost by Category ($)"
    yFmt="$#,##0.00"
    xAxisTitle="Date"
    yAxisTitle="Cost ($)"
/>

</div>
</Grid>

<DataTable data={category_summary}>
    <Column id="category"            title="Category"/>
    <Column id="total_items"         title="Items"           fmt="#,##0"/>
    <Column id="total_usage_qty"     title="Qty Used"        fmt="#,##0"/>
    <Column id="total_usage_cost"    title="Usage Cost"      fmt="$#,##0.00"/>
    <Column id="total_purchase_cost" title="Purchase Cost"   fmt="$#,##0.00"/>
    <Column id="pct_of_total"        title="% of Total"      fmt="0.0\%"/>
    <Column id="buy_use_ratio"       title="Buy/Use Ratio"   fmt="0.00"/>
</DataTable>

_**Buy/Use Ratio** should ideally be close to 1.0. Ratios >1.5 suggest purchasing far exceeds usage — overstock risk, especially critical for perishable protein and produce categories._

---

## Usage Cost by Item (Last 30 Days)

```sql usage_by_item
SELECT
    item_name,
    category,
    unit,
    SUM(usage_qty)  AS total_usage_qty,
    SUM(usage_cost) AS total_cost
FROM restaurant_en.inventory_stok
WHERE txn_date >= (SELECT MAX(txn_date) FROM restaurant_en.inventory_stok) - INTERVAL '30 days'
GROUP BY item_name, category, unit
ORDER BY total_cost DESC
```

<Grid cols=2>
<div>

### Cost per Item

<BarChart
    data={usage_by_item}
    x="item_name"
    y="total_cost"
    swapXY=true
    title="Total Usage Cost per Ingredient ($)"
    yFmt="$#,##0.00"
    xAxisTitle="Total Cost ($)"
    colorPalette={['#1D9E75']}
/>

</div>
<div>

### Detail

<DataTable data={usage_by_item}>
    <Column id="item_name"       title="Ingredient"/>
    <Column id="category"        title="Category"/>
    <Column id="unit"            title="Unit"/>
    <Column id="total_usage_qty" title="Qty Used"  fmt="#,##0"/>
    <Column id="total_cost"      title="Cost"      fmt="$#,##0.00"/>
</DataTable>

</div>
</Grid>

---

## Usage vs Purchasing by Location (Last 30 Days)

```sql usage_vs_purchase_branch
SELECT
    branch_name,
    SUM(usage_cost)    AS usage_cost,
    SUM(purchase_cost) AS purchase_cost
FROM restaurant_en.inventory_stok
WHERE txn_date >= (SELECT MAX(txn_date) FROM restaurant_en.inventory_stok) - INTERVAL '30 days'
GROUP BY branch_name
ORDER BY usage_cost DESC
```

<BarChart
    data={usage_vs_purchase_branch}
    x="branch_name"
    y={["usage_cost", "purchase_cost"]}
    type="grouped"
    title="Usage vs Purchase Cost by Location ($)"
    yFmt="$#,##0.00"
    xAxisTitle="Location"
    yAxisTitle="Cost ($)"
/>

---

## Daily Usage Trend (Last 90 Days)

```sql usage_trend_90d
SELECT
    txn_date,
    branch_name,
    SUM(usage_cost) AS usage_cost
FROM restaurant_en.inventory_stok
WHERE txn_date >= (SELECT MAX(txn_date) FROM restaurant_en.inventory_stok) - INTERVAL '90 days'
GROUP BY txn_date, branch_name
ORDER BY txn_date, branch_name
```

<LineChart
    data={usage_trend_90d}
    x="txn_date"
    y="usage_cost"
    series="branch_name"
    title="Daily Usage Cost by Location ($)"
    yFmt="$#,##0.00"
    xAxisTitle="Date"
    yAxisTitle="Usage Cost ($)"
/>

---

## Actual vs Baseline Price Comparison

```sql price_variance
SELECT
    item_name,
    category,
    ROUND(AVG(base_unit_cost), 2)  AS baseline_price,
    ROUND(AVG(avg_unit_cost), 2)   AS actual_price,
    ROUND(
        (AVG(avg_unit_cost) - AVG(base_unit_cost))
        / NULLIF(AVG(base_unit_cost), 0) * 100
    , 1) AS variance_pct
FROM restaurant_en.inventory_stok
WHERE txn_date >= (SELECT MAX(txn_date) FROM restaurant_en.inventory_stok) - INTERVAL '30 days'
GROUP BY item_name, category
ORDER BY variance_pct DESC
```

{#if price_alert_count[0].flagged_items > 0}
<div style="background:rgba(220,38,38,0.08);border-left:4px solid #dc2626;padding:12px 16px;border-radius:6px;margin:8px 0;">
🔴 <strong>{price_alert_count[0].flagged_items} ingredient(s)</strong> with actual price >10% above baseline — flagged in the table below. Prioritize for supplier renegotiation.
</div>
{/if}

<DataTable data={price_variance}>
    <Column id="item_name"      title="Ingredient"/>
    <Column id="category"       title="Category"/>
    <Column id="baseline_price" title="Baseline Price"   fmt="$#,##0.00"/>
    <Column id="actual_price"   title="Actual Price"     fmt="$#,##0.00"/>
    <Column id="variance_pct"   title="Variance"         fmt="+0.0;-0.0" contentType="delta"/>
</DataTable>

---

## Weekly Price Trend (Last 90 Days)

```sql price_trend_weekly
SELECT
    DATE_TRUNC('week', txn_date) AS week,
    item_name,
    category,
    ROUND(AVG(avg_unit_cost), 2)   AS avg_actual_price,
    ROUND(AVG(base_unit_cost), 2)  AS baseline_price
FROM restaurant_en.inventory_stok
WHERE txn_date >= (SELECT MAX(txn_date) FROM restaurant_en.inventory_stok) - INTERVAL '90 days'
GROUP BY 1, 2, 3
ORDER BY 1, 2
```

```sql price_trend_summary
SELECT
    item_name,
    category,
    ROUND(MIN(avg_unit_cost), 2)                                        AS price_low,
    ROUND(MAX(avg_unit_cost), 2)                                        AS price_high,
    ROUND(AVG(avg_unit_cost), 2)                                        AS price_avg,
    ROUND(AVG(base_unit_cost), 2)                                       AS baseline_price,
    ROUND((MAX(avg_unit_cost) - MIN(avg_unit_cost))
        / NULLIF(MIN(avg_unit_cost), 0) * 100, 1)                       AS volatility_pct,
    ROUND((AVG(avg_unit_cost) - AVG(base_unit_cost))
        / NULLIF(AVG(base_unit_cost), 0) * 100, 1)                      AS vs_baseline_pct
FROM restaurant_en.inventory_stok
WHERE txn_date >= (SELECT MAX(txn_date) FROM restaurant_en.inventory_stok) - INTERVAL '90 days'
GROUP BY 1, 2
ORDER BY volatility_pct DESC
```

<LineChart
    data={price_trend_weekly}
    x="week"
    y="avg_actual_price"
    series="item_name"
    title="Weekly Actual Purchase Price by Ingredient ($)"
    yFmt="$#,##0.00"
    xAxisTitle="Week"
    yAxisTitle="Avg Price ($)"
/>

<DataTable data={price_trend_summary}>
    <Column id="item_name"       title="Ingredient"/>
    <Column id="category"        title="Category"/>
    <Column id="baseline_price"  title="Baseline"       fmt="$#,##0.00"/>
    <Column id="price_avg"       title="Avg Actual"     fmt="$#,##0.00"/>
    <Column id="price_low"       title="Low"            fmt="$#,##0.00"/>
    <Column id="price_high"      title="High"           fmt="$#,##0.00"/>
    <Column id="volatility_pct"  title="Volatility"     fmt="0.0\%"/>
    <Column id="vs_baseline_pct" title="vs Baseline"    fmt="+0.0;-0.0" contentType="delta"/>
</DataTable>

_High **volatility** items need closer monitoring and ideally a fixed-price supplier contract. Items consistently **above baseline** are the top renegotiation candidates._

---

## Purchase Efficiency by Item & Location (Last 30 Days)

```sql efficiency_ratio
SELECT
    branch_name,
    item_name,
    category,
    unit,
    ROUND(SUM(usage_qty), 2)                                     AS total_used,
    ROUND(SUM(purchase_qty), 2)                                  AS total_purchased,
    ROUND(SUM(purchase_qty) / NULLIF(SUM(usage_qty), 0), 2)     AS buy_use_ratio,
    SUM(usage_cost)                                              AS usage_cost,
    SUM(purchase_cost)                                           AS purchase_cost
FROM restaurant_en.inventory_stok
WHERE txn_date >= (SELECT MAX(txn_date) FROM restaurant_en.inventory_stok) - INTERVAL '30 days'
GROUP BY 1, 2, 3, 4
HAVING SUM(usage_qty) > 0
ORDER BY buy_use_ratio DESC
```

<DataTable data={efficiency_ratio} rows=15 search=true>
    <Column id="branch_name"   title="Location"/>
    <Column id="item_name"     title="Ingredient"/>
    <Column id="category"      title="Category"/>
    <Column id="unit"          title="Unit"/>
    <Column id="total_used"    title="Qty Used"      fmt="#,##0"/>
    <Column id="total_purchased" title="Qty Purchased" fmt="#,##0"/>
    <Column id="buy_use_ratio" title="Buy/Use Ratio" fmt="0.00"/>
    <Column id="usage_cost"    title="Usage Cost"    fmt="$#,##0.00"/>
    <Column id="purchase_cost" title="Purchase Cost" fmt="$#,##0.00"/>
</DataTable>

_Sort **Buy/Use Ratio** descending — the highest rows represent the largest waste risk. Focus first on protein and produce due to perishability._
