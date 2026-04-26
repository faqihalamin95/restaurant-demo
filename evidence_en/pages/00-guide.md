---
title: Dashboard Guide
---

<div style="display:flex;justify-content:space-between;align-items:center;background:rgba(128,128,128,0.05);border:1px solid rgba(128,128,128,0.2);padding:12px 20px;border-radius:10px;margin-bottom:24px;">
  <span style="font-size:0.9em;">Already familiar with this dashboard?</span>
  <a href="/" style="font-size:0.85em;text-decoration:none;border:1px solid rgba(128,128,128,0.3);padding:6px 14px;border-radius:6px;background:rgba(128,128,128,0.05);">
    Skip to dashboard →
  </a>
</div>

_Two minutes here will make the data a lot easier to read._

---

## Welcome to the Restaurant Analytics Dashboard

This dashboard brings all your business data into one place — revenue, menu performance, peak hours, staff, and profitability by location. Everything updates automatically every morning.

```sql live_snapshot
SELECT
    SUM(total_revenue)        AS revenue_yesterday,
    SUM(total_orders)         AS orders_yesterday,
    COUNT(DISTINCT branch_id) AS active_locations
FROM restaurant_en.daily_revenue
WHERE order_date = (SELECT MAX(order_date) FROM restaurant_en.daily_revenue)
```

```sql last_updated
SELECT STRFTIME('%B %d, %Y', MAX(order_date)) AS last_date
FROM restaurant_en.daily_revenue
```

<BigValue data={live_snapshot} value="revenue_yesterday"  title="Yesterday's Revenue"  fmt="$#,##0.00" />
<BigValue data={live_snapshot} value="orders_yesterday"   title="Yesterday's Orders"   fmt="#,##0" />
<BigValue data={live_snapshot} value="active_locations"   title="Active Locations" />

_Data as of {last_updated[0].last_date}. Refreshed automatically every morning._

---

## How to Read This Dashboard

### 📊 1 — Charts & Graphs

<div style="background:rgba(22,163,74,0.08);border-left:4px solid #16a34a;padding:12px 16px;border-radius:0 8px 8px 0;margin:12px 0 20px 0;font-size:0.9em;">

🖱️ <strong>Hover</strong> over any point or bar to see the exact number.<br/>
🏷️ <strong>Click a name</strong> in the legend to hide or show that series — useful when you want to focus on one location.<br/>
🔍 <strong>Double-click</strong> a legend name to isolate it and hide everything else at once.

</div>

```sql chart_sample
SELECT
    order_date,
    branch_name,
    total_revenue
FROM restaurant_en.daily_revenue
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant_en.daily_revenue) - INTERVAL '13 days'
ORDER BY order_date, branch_name
```

<LineChart
    data={chart_sample}
    x="order_date"
    y="total_revenue"
    series="branch_name"
    title="Try it: hover over a point, then click a location name in the legend"
    yFmt="$#,##0.00"
    xAxisTitle="Date"
    yAxisTitle="Revenue ($)"
/>

---

### 📋 2 — Data Tables

<div style="background:rgba(37,99,235,0.08);border-left:4px solid #2563eb;padding:12px 16px;border-radius:0 8px 8px 0;margin:12px 0 20px 0;font-size:0.9em;">

↔️ <strong>Wide tables</strong>: scroll left and right to see columns hidden off-screen.<br/>
📄 <strong>Long tables</strong>: use the <strong>← →</strong> pagination buttons at the bottom-right corner to move between pages.<br/>
🔼 <strong>Click a column header</strong> to sort ascending or descending.

</div>

```sql table_sample
SELECT
    branch_name                                                           AS location,
    SUM(total_revenue)                                                    AS total_revenue,
    SUM(total_orders)                                                     AS total_orders,
    ROUND(SUM(total_revenue) / NULLIF(SUM(total_orders), 0), 2)          AS avg_order_value,
    SUM(delivery_orders)                                                  AS delivery,
    SUM(dine_in_orders)                                                   AS dine_in,
    SUM(takeaway_orders)                                                  AS takeaway,
    COUNT(DISTINCT order_date)                                            AS active_days
FROM restaurant_en.daily_revenue
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant_en.daily_revenue) - INTERVAL '30 days'
GROUP BY branch_name
ORDER BY total_revenue DESC
```

<DataTable data={table_sample}>
    <Column id="location"        title="Location"/>
    <Column id="total_revenue"   title="Revenue"          fmt="$#,##0.00"/>
    <Column id="total_orders"    title="Orders"           fmt="#,##0"/>
    <Column id="avg_order_value" title="Avg Order Value"  fmt="$#,##0.00"/>
    <Column id="delivery"        title="Delivery"         fmt="#,##0"/>
    <Column id="dine_in"         title="Dine-in"          fmt="#,##0"/>
    <Column id="takeaway"        title="Takeaway"         fmt="#,##0"/>
    <Column id="active_days"     title="Active Days"      fmt="#,##0"/>
</DataTable>

_👆 Click any column header to sort. On mobile, swipe the table left to see Delivery, Dine-in, and Takeaway columns._

---

### 📱 3 — On Mobile / Tablet

<div style="background:rgba(245,158,11,0.08);border-left:4px solid #f59e0b;padding:12px 16px;border-radius:0 8px 8px 0;margin:12px 0 20px 0;font-size:0.9em;">

📲 All pages are mobile-friendly.<br/>
👆 Tap any chart to see the numbers.<br/>
↔️ Swipe tables horizontally to see all columns.<br/>
📄 Pagination buttons appear below long tables — scroll down if you don't see them.

</div>

---

## Page Map

Use the **left sidebar** (or the ☰ menu icon on mobile) to navigate between pages.

| Page | Business Question |
|---|---|
| 🏠 **Overview** | How is the business performing today? |
| 💵 **Financial Report** | What is the net revenue and profit margin per location? |
| 🏪 **Branch Performance** | Which locations are growing, flat, or underperforming? |
| ⏰ **Peak Hours** | When do customers arrive? What's tomorrow's forecast? |
| 🍽️ **Menu Performance** | What's selling, what's declining, what has hidden potential? |
| 🎖️ **Member Behavior** | Who are the most loyal customers, and who is at churn risk? |
| 👨‍💼 **Employee Performance** | Staff productivity, attendance, and shift analysis |

---

## Glossary

| Term | Meaning |
|---|---|
| **Gross Revenue** | Total sales before any cost deductions |
| **Net Revenue** | Revenue after subtracting ingredients, labor, and overhead |
| **Net Margin** | Net revenue as a percentage of gross revenue |
| **SDOW Avg** | Same-Day-of-Week average — Monday compared to Mondays, removing weekday/weekend bias |
| **WoW** | Week-over-Week — this week vs last week |
| **Star** | High volume & high revenue menu item — protect quality and stock |
| **Puzzle** | High revenue but low orders — promote more aggressively |
| **Plow Horse** | Popular but low revenue — candidate for a price increase or bundling |
| **Dog** | Low volume & low revenue — evaluate for removal or reformulation |
| **Churn Risk** | Member with no transaction in 14–30 days (threshold varies by tier) |
| **Lunch Peak** | 11 AM–1 PM, highest-traffic midday period |
| **Dinner Peak** | 5 PM–8 PM, highest-traffic evening period |
| **Buy/Use Ratio** | Purchased qty ÷ used qty — ratio >1.5 signals overstock risk |

---

<div style="text-align:center;margin:40px 0 20px 0;">
  <a href="/" style="display:inline-block;background:#1D9E75;color:white;padding:14px 36px;border-radius:10px;text-decoration:none;font-weight:700;font-size:1.05em;">
    Go to Dashboard →
  </a>
</div>

_Dashboard data refreshes automatically every morning._
