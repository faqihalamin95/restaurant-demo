---
title: Menu Performance
---

# 🍽️ Menu Performance

## Top Menu Items — Last 30 Days

```sql top_menu
SELECT
    menu_name,
    category,
    price_tier,
    SUM(total_qty_sold)     AS total_qty,
    SUM(total_revenue)      AS total_revenue
FROM restaurant_en.menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant_en.menu_performance) - INTERVAL '30 days'
GROUP BY menu_name, category, price_tier
ORDER BY total_qty DESC
```

<BarChart
    data={top_menu}
    x="menu_name"
    y="total_qty"
    series="category"
    title="Units Sold by Menu Item (30 Days)"
    swapXY=true
/>

---

## Week-over-Week Trend

```sql menu_wow
SELECT
    menu_name,
    category,
    SUM(total_qty_sold)                         AS qty_total,
    ROUND(AVG(qty_wow_change) * 100, 1)         AS avg_wow_change
FROM restaurant_en.menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant_en.menu_performance) - INTERVAL '30 days'
GROUP BY menu_name, category
ORDER BY avg_wow_change ASC
```

<DataTable data={menu_wow}>
    <Column id="menu_name" title="Menu Item"/>
    <Column id="category" title="Category"/>
    <Column id="qty_total" title="Total Units" fmt="#,##0"/>
    <Column id="avg_wow_change" title="WoW Change %" fmt="+0.0%;-0.0%;0.0%" contentType="delta"/>
</DataTable>

---

## 💡 Hidden Gem — High Margin, Low Volume

```sql hidden_gem
SELECT
    menu_name,
    category,
    price,
    price_tier,
    SUM(total_qty_sold)     AS total_qty,
    SUM(total_revenue)      AS total_revenue
FROM restaurant_en.menu_performance
WHERE price_tier IN ('premium', 'bundle')
GROUP BY menu_name, category, price, price_tier
ORDER BY total_qty ASC
LIMIT 5
```

<DataTable data={hidden_gem}>
    <Column id="menu_name" title="Menu Item"/>
    <Column id="price" title="Price" fmt="$#,##0.00"/>
    <Column id="price_tier" title="Tier"/>
    <Column id="total_qty" title="Total Units" fmt="#,##0"/>
    <Column id="total_revenue" title="Total Revenue" fmt="$#,##0.00"/>
</DataTable>

> 💡 These items have premium pricing but low order volume.
> Consider featuring them more prominently on the menu or running targeted promotions.

---

## Declining Menu Items

```sql declining_menu
SELECT
    menu_name,
    order_date,
    total_qty_sold,
    qty_30d_rolling
FROM restaurant_en.menu_performance
WHERE menu_name IN (
    SELECT menu_name
    FROM restaurant_en.menu_performance
    WHERE order_date >= (SELECT MAX(order_date) FROM restaurant_en.menu_performance) - INTERVAL '30 days'
    GROUP BY menu_name
    HAVING AVG(qty_wow_change) < -0.05
)
AND order_date >= (SELECT MAX(order_date) FROM restaurant_en.menu_performance) - INTERVAL '90 days'
ORDER BY order_date, menu_name
```

<LineChart
    data={declining_menu}
    x="order_date"
    y="qty_30d_rolling"
    series="menu_name"
    title="Menu Items with Declining Trend (90 Days)"
/>