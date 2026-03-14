---
title: Performa Menu
---

# 🍽️ Performa Menu

## Top Menu — 30 Hari Terakhir

```sql top_menu
SELECT
    menu_name,
    category,
    price_tier,
    SUM(total_qty_sold)     AS total_qty,
    SUM(total_revenue)      AS total_revenue
FROM restaurant.menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '30 days'
GROUP BY menu_name, category, price_tier
ORDER BY total_qty DESC
```

<BarChart
    data={top_menu}
    x="menu_name"
    y="total_qty"
    series="category"
    title="Qty Terjual per Menu (30 Hari)"
    swapXY=true
/>

---

## Tren Menu — Week over Week

```sql menu_wow
SELECT
    menu_name,
    category,
    SUM(total_qty_sold)                         AS qty_total,
    ROUND(AVG(qty_wow_change) * 100, 1)         AS avg_wow_change
FROM restaurant.menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '30 days'
GROUP BY menu_name, category
ORDER BY avg_wow_change ASC
```

<DataTable data={menu_wow}>
    <Column id="menu_name" title="Menu"/>
    <Column id="category" title="Kategori"/>
    <Column id="qty_total" title="Total Qty" fmt="#,##0"/>
    <Column id="avg_wow_change" title="WoW Change %" fmt="+0.0%;-0.0%;0.0%" contentType="delta"/>
</DataTable>

---

## 💡 Hidden Gem — Margin Bagus, Volume Rendah

```sql hidden_gem
SELECT
    menu_name,
    category,
    price,
    price_tier,
    SUM(total_qty_sold)     AS total_qty,
    SUM(total_revenue)      AS total_revenue
FROM restaurant.menu_performance
WHERE price_tier IN ('premium', 'bundle')
GROUP BY menu_name, category, price, price_tier
ORDER BY total_qty ASC
LIMIT 5
```

<DataTable data={hidden_gem}>
    <Column id="menu_name" title="Menu"/>
    <Column id="price" title="Harga" fmt="Rp #,##0"/>
    <Column id="price_tier" title="Tier"/>
    <Column id="total_qty" title="Total Qty" fmt="#,##0"/>
    <Column id="total_revenue" title="Total Revenue" fmt="Rp #,##0"/>
</DataTable>

> 💡 Menu di atas memiliki harga premium tapi volume penjualan rendah.
> Berpotensi untuk ditingkatkan melalui promosi atau penempatan menu yang lebih strategis.

---

## Tren Menu Declining

```sql declining_menu
SELECT
    menu_name,
    order_date,
    total_qty_sold,
    qty_30d_rolling
FROM restaurant.menu_performance
WHERE menu_name IN (
    SELECT menu_name
    FROM restaurant.menu_performance
    WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '30 days'
    GROUP BY menu_name
    HAVING AVG(qty_wow_change) < -0.05
)
AND order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '90 days'
ORDER BY order_date, menu_name
```

<LineChart
    data={declining_menu}
    x="order_date"
    y="qty_30d_rolling"
    series="menu_name"
    title="Menu dengan Tren Menurun (90 Hari)"
/>