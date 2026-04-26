---
title: Menu Performance
---

_Sales analysis, trends, and menu engineering insights._

```sql periode_30d
SELECT
    STRFTIME('%b %d, %Y', MAX(order_date) - INTERVAL '29 days') AS date_from,
    STRFTIME('%b %d, %Y', MAX(order_date))                       AS date_to
FROM restaurant_en.menu_performance
```

```sql best_menu_30d
SELECT menu_name, SUM(total_qty_sold) AS total_qty
FROM restaurant_en.menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant_en.menu_performance) - INTERVAL '30 days'
GROUP BY menu_name ORDER BY total_qty DESC LIMIT 1
```

```sql best_revenue_30d
SELECT menu_name, SUM(total_revenue) AS total_revenue
FROM restaurant_en.menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant_en.menu_performance) - INTERVAL '30 days'
GROUP BY menu_name ORDER BY total_revenue DESC LIMIT 1
```

```sql summary_menu
SELECT COUNT(DISTINCT menu_name) AS total_items
FROM restaurant_en.menu_performance
WHERE order_date = (SELECT MAX(order_date) FROM restaurant_en.menu_performance)
```

```sql menu_alert_declining
SELECT menu_name, ROUND(qty_wow_change * 100, 1) AS pct_change
FROM restaurant_en.menu_performance
WHERE order_date = (SELECT MAX(order_date) FROM restaurant_en.menu_performance)
  AND qty_wow_change < -0.20
ORDER BY qty_wow_change ASC LIMIT 3
```

```sql menu_alert_rising
SELECT menu_name, ROUND(qty_wow_change * 100, 1) AS pct_change
FROM restaurant_en.menu_performance
WHERE order_date = (SELECT MAX(order_date) FROM restaurant_en.menu_performance)
  AND qty_wow_change > 0.20
ORDER BY qty_wow_change DESC LIMIT 1
```

---

## Last 30 Days Summary

<span style="font-size:0.85em;color:var(--color-text-secondary)">{periode_30d[0].date_from} – {periode_30d[0].date_to}</span>

<BigValue data={best_menu_30d}    value="menu_name"     title="Best-Selling Item" />
<BigValue data={best_menu_30d}    value="total_qty"     title="Units Sold"               fmt="#,##0" />
<BigValue data={best_revenue_30d} value="menu_name"     title="Top Revenue Item" />
<BigValue data={best_revenue_30d} value="total_revenue" title="Revenue from That Item"   fmt="$#,##0.00" />
<BigValue data={summary_menu}     value="total_items"   title="Active Menu Items" />

{#if menu_alert_declining.length > 0}
<div style="display:flex;flex-direction:column;gap:8px;margin:16px 0;">
{#each menu_alert_declining as row}
<div style="background:rgba(220,38,38,0.08);border-left:4px solid #dc2626;padding:12px 16px;border-radius:6px;">
🚨 <strong>{row.menu_name}</strong> — sales down <strong>{row.pct_change}%</strong> vs last week. Consider a promotion or recipe review. Check whether the decline is chain-wide or location-specific before acting.
</div>
{/each}
</div>
{/if}

{#if menu_alert_rising.length > 0}
<div style="background:rgba(22,163,74,0.08);border-left:4px solid #16a34a;padding:12px 16px;border-radius:6px;margin:8px 0;">
✅ <strong>{menu_alert_rising[0].menu_name}</strong> — sales up <strong>{menu_alert_rising[0].pct_change}%</strong> vs last week. Ensure sufficient stock.
</div>
{/if}

---

## Volume vs Revenue Contribution (Last 30 Days)

```sql top_by_volume
SELECT
    menu_name, category,
    SUM(total_qty_sold) AS total_qty
FROM restaurant_en.menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant_en.menu_performance) - INTERVAL '30 days'
GROUP BY menu_name, category
ORDER BY total_qty DESC LIMIT 10
```

```sql top_by_revenue
SELECT
    menu_name, category,
    SUM(total_revenue) AS total_revenue
FROM restaurant_en.menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant_en.menu_performance) - INTERVAL '30 days'
GROUP BY menu_name, category
ORDER BY total_revenue DESC LIMIT 10
```

<Grid cols=2>
<div>

### Top 10 by Volume

<BarChart
    data={top_by_volume}
    x="menu_name"
    y="total_qty"
    swapXY=true
    title="Best-Selling Items"
    xAxisTitle="Units Sold"
    colorPalette={['#4f86c6']}
/>

</div>
<div>

### Top 10 by Revenue

<BarChart
    data={top_by_revenue}
    x="menu_name"
    y="total_revenue"
    swapXY=true
    title="Top Revenue Items ($)"
    yFmt="$#,##0.00"
    xAxisTitle="Revenue ($)"
    colorPalette={['#e07b39']}
/>

</div>
</Grid>

_If the Volume and Revenue top-10 lists don't overlap much, there's a gap between what sells and what makes money — the high-volume, low-revenue items are upselling or bundling candidates._

---

## Category & Price Tier Contribution (Last 30 Days)

```sql category_summary_30d
SELECT
    category,
    COUNT(DISTINCT menu_name)                                            AS total_items,
    SUM(total_qty_sold)                                                  AS total_qty,
    SUM(total_revenue)                                                   AS total_revenue,
    ROUND(SUM(total_revenue) / NULLIF(SUM(total_qty_sold), 0), 2)       AS avg_realized_price,
    ROUND(SUM(total_revenue) / NULLIF(SUM(SUM(total_revenue)) OVER (), 0) * 100, 1) AS pct_revenue
FROM restaurant_en.menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant_en.menu_performance) - INTERVAL '30 days'
GROUP BY category
ORDER BY total_revenue DESC
```

```sql price_tier_summary_30d
SELECT
    price_tier,
    COUNT(DISTINCT menu_name)                                            AS total_items,
    SUM(total_qty_sold)                                                  AS total_qty,
    SUM(total_revenue)                                                   AS total_revenue,
    ROUND(SUM(total_revenue) / NULLIF(SUM(SUM(total_revenue)) OVER (), 0) * 100, 1) AS pct_revenue
FROM restaurant_en.menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant_en.menu_performance) - INTERVAL '30 days'
GROUP BY price_tier
ORDER BY total_revenue DESC
```

<Grid cols=2>
<div>

### By Category

<BarChart
    data={category_summary_30d}
    x="category"
    y="total_revenue"
    title="Revenue by Category ($)"
    yFmt="$#,##0.00"
    xAxisTitle="Category"
    yAxisTitle="Revenue ($)"
/>

</div>
<div>

### By Price Tier

<BarChart
    data={price_tier_summary_30d}
    x="price_tier"
    y="total_revenue"
    title="Revenue by Price Tier ($)"
    yFmt="$#,##0.00"
    xAxisTitle="Tier"
    yAxisTitle="Revenue ($)"
/>

</div>
</Grid>

<Grid cols=2>
<div>

<DataTable data={category_summary_30d}>
    <Column id="category"           title="Category"/>
    <Column id="total_items"        title="Items"          fmt="#,##0"/>
    <Column id="total_qty"          title="Units Sold"     fmt="#,##0"/>
    <Column id="total_revenue"      title="Revenue"        fmt="$#,##0.00"/>
    <Column id="avg_realized_price" title="Avg Realized Price" fmt="$#,##0.00"/>
    <Column id="pct_revenue"        title="% Revenue"      fmt="0.0\%"/>
</DataTable>

</div>
<div>

<DataTable data={price_tier_summary_30d}>
    <Column id="price_tier"    title="Tier"/>
    <Column id="total_items"   title="Items"      fmt="#,##0"/>
    <Column id="total_qty"     title="Units Sold" fmt="#,##0"/>
    <Column id="total_revenue" title="Revenue"    fmt="$#,##0.00"/>
    <Column id="pct_revenue"   title="% Revenue"  fmt="0.0\%"/>
</DataTable>

</div>
</Grid>

### Menu Reference — Category & Price Tier

```sql menu_reference
SELECT
    menu_name,
    category,
    price_tier,
    ROUND(AVG(price), 2) AS price
FROM restaurant_en.menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant_en.menu_performance) - INTERVAL '30 days'
GROUP BY menu_name, category, price_tier
ORDER BY category, price DESC
```

<DataTable data={menu_reference} search=true>
    <Column id="menu_name"  title="Item"/>
    <Column id="category"   title="Category"/>
    <Column id="price_tier" title="Tier"/>
    <Column id="price"      title="Price" fmt="$#,##0.00"/>
</DataTable>

---

## Top Item by Location (Last 30 Days)

```sql top_by_location
SELECT
    branch_name,
    MAX(CASE WHEN rn_qty = 1 THEN menu_name END) AS top_volume_item,
    MAX(CASE WHEN rn_qty = 1 THEN total_qty END)  AS top_volume_qty,
    MAX(CASE WHEN rn_rev = 1 THEN menu_name END)  AS top_revenue_item,
    MAX(CASE WHEN rn_rev = 1 THEN total_rev END)  AS top_revenue_value
FROM (
    SELECT
        branch_name, menu_name,
        SUM(total_qty_sold)                                                             AS total_qty,
        SUM(total_revenue)                                                              AS total_rev,
        ROW_NUMBER() OVER (PARTITION BY branch_name ORDER BY SUM(total_qty_sold) DESC) AS rn_qty,
        ROW_NUMBER() OVER (PARTITION BY branch_name ORDER BY SUM(total_revenue) DESC)  AS rn_rev
    FROM restaurant_en.menu_performance
    WHERE order_date >= (SELECT MAX(order_date) FROM restaurant_en.menu_performance) - INTERVAL '30 days'
    GROUP BY branch_name, menu_name
)
GROUP BY branch_name
ORDER BY branch_name
```

<DataTable data={top_by_location}>
    <Column id="branch_name"       title="Location"/>
    <Column id="top_volume_item"   title="Best-Selling Item"/>
    <Column id="top_volume_qty"    title="Units Sold"       fmt="#,##0"/>
    <Column id="top_revenue_item"  title="Top Revenue Item"/>
    <Column id="top_revenue_value" title="Revenue"          fmt="$#,##0.00"/>
</DataTable>

---

## Menu Engineering — Item Classification (Last 30 Days)

```sql menu_engineering
SELECT
    menu_name, category,
    SUM(total_qty_sold) AS total_qty,
    SUM(total_revenue)  AS total_revenue,
    CASE
        WHEN SUM(total_qty_sold) >= MEDIAN(SUM(total_qty_sold)) OVER ()
             AND SUM(total_revenue) >= MEDIAN(SUM(total_revenue)) OVER ()
        THEN 'Star'
        WHEN SUM(total_qty_sold) >= MEDIAN(SUM(total_qty_sold)) OVER ()
             AND SUM(total_revenue) < MEDIAN(SUM(total_revenue)) OVER ()
        THEN 'Plow Horse'
        WHEN SUM(total_qty_sold) < MEDIAN(SUM(total_qty_sold)) OVER ()
             AND SUM(total_revenue) >= MEDIAN(SUM(total_revenue)) OVER ()
        THEN 'Puzzle'
        ELSE 'Dog'
    END AS classification
FROM restaurant_en.menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant_en.menu_performance) - INTERVAL '30 days'
GROUP BY menu_name, category
```

```sql menu_engineering_table
SELECT classification, menu_name, category, total_qty, total_revenue
FROM (
    SELECT
        menu_name, category,
        SUM(total_qty_sold) AS total_qty,
        SUM(total_revenue)  AS total_revenue,
        CASE
            WHEN SUM(total_qty_sold) >= MEDIAN(SUM(total_qty_sold)) OVER ()
                 AND SUM(total_revenue) >= MEDIAN(SUM(total_revenue)) OVER ()
            THEN 'Star'
            WHEN SUM(total_qty_sold) >= MEDIAN(SUM(total_qty_sold)) OVER ()
                 AND SUM(total_revenue) < MEDIAN(SUM(total_revenue)) OVER ()
            THEN 'Plow Horse'
            WHEN SUM(total_qty_sold) < MEDIAN(SUM(total_qty_sold)) OVER ()
                 AND SUM(total_revenue) >= MEDIAN(SUM(total_revenue)) OVER ()
            THEN 'Puzzle'
            ELSE 'Dog'
        END AS classification
    FROM restaurant_en.menu_performance
    WHERE order_date >= (SELECT MAX(order_date) FROM restaurant_en.menu_performance) - INTERVAL '30 days'
    GROUP BY menu_name, category
)
ORDER BY CASE classification WHEN 'Star' THEN 1 WHEN 'Puzzle' THEN 2 WHEN 'Plow Horse' THEN 3 ELSE 4 END, total_revenue DESC
```

<ScatterPlot
    data={menu_engineering}
    x="total_qty"
    y="total_revenue"
    series="classification"
    pointName="menu_name"
    xAxisTitle="Units Sold"
    yAxisTitle="Total Revenue ($)"
    title="Menu Engineering — Volume vs Revenue"
    yFmt="$#,##0.00"
/>

<DataTable data={menu_engineering_table}>
    <Column id="classification" title="Class"/>
    <Column id="menu_name"      title="Item"/>
    <Column id="category"       title="Category"/>
    <Column id="total_qty"      title="Units Sold"  fmt="#,##0"/>
    <Column id="total_revenue"  title="Revenue"     fmt="$#,##0.00"/>
</DataTable>

_**Star** — high volume & high revenue: protect quality and stock. **Puzzle** — high revenue but low orders: promote more aggressively. **Plow Horse** — popular but low revenue: consider a price increase or bundling. **Dog** — low on both: evaluate for removal or reformulation._

---

## Week-over-Week Trend

```sql menu_wow
SELECT
    menu_name, category,
    SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant_en.menu_performance) - INTERVAL '6 days'
        THEN total_qty_sold END)                                        AS qty_this_week,
    SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant_en.menu_performance) - INTERVAL '13 days'
         AND order_date < (SELECT MAX(order_date) FROM restaurant_en.menu_performance) - INTERVAL '6 days'
        THEN total_qty_sold END)                                        AS qty_last_week,
    ROUND(
        (SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant_en.menu_performance) - INTERVAL '6 days'
            THEN total_qty_sold END)
        - SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant_en.menu_performance) - INTERVAL '13 days'
             AND order_date < (SELECT MAX(order_date) FROM restaurant_en.menu_performance) - INTERVAL '6 days'
            THEN total_qty_sold END))
        / NULLIF(SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant_en.menu_performance) - INTERVAL '13 days'
             AND order_date < (SELECT MAX(order_date) FROM restaurant_en.menu_performance) - INTERVAL '6 days'
            THEN total_qty_sold END), 0) * 100
    , 1) AS pct_change_qty,
    SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant_en.menu_performance) - INTERVAL '6 days'
        THEN total_revenue END)                                         AS rev_this_week,
    SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant_en.menu_performance) - INTERVAL '13 days'
         AND order_date < (SELECT MAX(order_date) FROM restaurant_en.menu_performance) - INTERVAL '6 days'
        THEN total_revenue END)                                         AS rev_last_week,
    ROUND(
        (SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant_en.menu_performance) - INTERVAL '6 days'
            THEN total_revenue END)
        - SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant_en.menu_performance) - INTERVAL '13 days'
             AND order_date < (SELECT MAX(order_date) FROM restaurant_en.menu_performance) - INTERVAL '6 days'
            THEN total_revenue END))
        / NULLIF(SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant_en.menu_performance) - INTERVAL '13 days'
             AND order_date < (SELECT MAX(order_date) FROM restaurant_en.menu_performance) - INTERVAL '6 days'
            THEN total_revenue END), 0) * 100
    , 1) AS pct_change_revenue
FROM restaurant_en.menu_performance
GROUP BY menu_name, category
ORDER BY pct_change_qty ASC
```

<DataTable data={menu_wow}>
    <Column id="menu_name"        title="Item"/>
    <Column id="category"         title="Category"/>
    <Column id="qty_this_week"    title="Units This Week"  fmt="#,##0"/>
    <Column id="qty_last_week"    title="Units Last Week"  fmt="#,##0"/>
    <Column id="pct_change_qty"   title="Δ Units"          fmt="+0.0;-0.0" contentType="delta"/>
    <Column id="rev_this_week"    title="Rev. This Week"   fmt="$#,##0.00"/>
    <Column id="rev_last_week"    title="Rev. Last Week"   fmt="$#,##0.00"/>
    <Column id="pct_change_revenue" title="Δ Revenue"      fmt="+0.0;-0.0" contentType="delta"/>
</DataTable>

---

## Declining Items (Last 90 Days)

```sql declining_trend
WITH declining_menus AS (
    SELECT menu_name FROM restaurant_en.menu_performance
    WHERE order_date >= (SELECT MAX(order_date) FROM restaurant_en.menu_performance) - INTERVAL '90 days'
    GROUP BY menu_name
    HAVING
        SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant_en.menu_performance) - INTERVAL '30 days'
            THEN total_qty_sold ELSE 0 END)
        < SUM(CASE WHEN order_date < (SELECT MAX(order_date) FROM restaurant_en.menu_performance) - INTERVAL '60 days'
            THEN total_qty_sold ELSE 0 END)
),
daily_sales AS (
    SELECT order_date, menu_name, SUM(total_qty_sold) AS qty_daily
    FROM restaurant_en.menu_performance
    WHERE menu_name IN (SELECT menu_name FROM declining_menus)
      AND order_date >= (SELECT MAX(order_date) FROM restaurant_en.menu_performance) - INTERVAL '90 days'
    GROUP BY order_date, menu_name
)
SELECT
    order_date,
    menu_name,
    AVG(qty_daily) OVER (
        PARTITION BY menu_name
        ORDER BY order_date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS rolling_avg_qty
FROM daily_sales
ORDER BY order_date, menu_name
```

{#if declining_trend.length > 0}

<LineChart
    data={declining_trend}
    x="order_date"
    y="rolling_avg_qty"
    series="menu_name"
    title="Declining Menu Items — 7-Day Rolling Avg Units Sold"
    xAxisTitle="Date"
    yAxisTitle="Avg Units Sold (7-Day)"
/>

_A line continuously trending downward signals sustained loss of customer interest — consider a promotion, recipe reformulation, or removal._

### Decline by Location

```sql declining_by_branch
SELECT
    branch_name,
    menu_name,
    SUM(CASE WHEN order_date < (SELECT MAX(order_date) FROM restaurant_en.menu_performance) - INTERVAL '60 days'
        THEN total_qty_sold ELSE 0 END) AS qty_first_30d,
    SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant_en.menu_performance) - INTERVAL '30 days'
        THEN total_qty_sold ELSE 0 END) AS qty_last_30d,
    ROUND(
        (SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant_en.menu_performance) - INTERVAL '30 days'
            THEN total_qty_sold ELSE 0 END)
        - SUM(CASE WHEN order_date < (SELECT MAX(order_date) FROM restaurant_en.menu_performance) - INTERVAL '60 days'
            THEN total_qty_sold ELSE 0 END))
        / NULLIF(SUM(CASE WHEN order_date < (SELECT MAX(order_date) FROM restaurant_en.menu_performance) - INTERVAL '60 days'
            THEN total_qty_sold ELSE 0 END), 0) * 100
    , 1) AS pct_change
FROM restaurant_en.menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant_en.menu_performance) - INTERVAL '90 days'
GROUP BY branch_name, menu_name
HAVING pct_change < 0
ORDER BY pct_change ASC
```

<DataTable data={declining_by_branch}>
    <Column id="branch_name"  title="Location"/>
    <Column id="menu_name"    title="Item"/>
    <Column id="qty_first_30d" title="First 30 Days" fmt="#,##0"/>
    <Column id="qty_last_30d"  title="Last 30 Days"  fmt="#,##0"/>
    <Column id="pct_change"    title="Change"        fmt="+0.0;-0.0" contentType="delta"/>
</DataTable>

_A decline in one location only needs a different response than a chain-wide drop — check here before acting._

{:else}
<div style="background:rgba(22,163,74,0.08);border-left:4px solid #16a34a;padding:12px 16px;border-radius:6px;">
✅ <strong>No items with a declining trend</strong> in the last 90 days — all items are stable or growing.
</div>
{/if}
