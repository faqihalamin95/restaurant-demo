---
title: Peak Hours
---

_Know when customers arrive and optimize operations accordingly._

```sql periode_30d
SELECT
    STRFTIME('%b %d, %Y', MAX(order_date) - INTERVAL '29 days') AS date_from,
    STRFTIME('%b %d, %Y', MAX(order_date))                       AS date_to
FROM restaurant_en.peak_hours
```

```sql peak_summary
SELECT
    day_part           AS busiest_period,
    SUM(total_orders)  AS total_orders
FROM restaurant_en.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant_en.peak_hours) - INTERVAL '30 days'
GROUP BY day_part
ORDER BY total_orders DESC
LIMIT 1
```

```sql peak_hour_summary
SELECT
    order_hour         AS busiest_hour,
    SUM(total_orders)  AS total_orders
FROM restaurant_en.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant_en.peak_hours) - INTERVAL '30 days'
GROUP BY order_hour
ORDER BY total_orders DESC
LIMIT 1
```

```sql peak_order_type
SELECT
    order_type         AS top_order_type,
    SUM(total_orders)  AS total_orders
FROM restaurant_en.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant_en.peak_hours) - INTERVAL '30 days'
GROUP BY order_type
ORDER BY total_orders DESC
LIMIT 1
```

```sql quiet_period
SELECT
    day_part           AS quietest_period,
    SUM(total_orders)  AS total_orders
FROM restaurant_en.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant_en.peak_hours) - INTERVAL '30 days'
GROUP BY day_part
ORDER BY total_orders ASC
LIMIT 1
```

```sql daypart_summary
SELECT
    day_part AS period,
    CASE day_part
        WHEN 'Morning'    THEN '8:00 AM – 10:00 AM'
        WHEN 'Lunch Peak' THEN '11:00 AM – 1:00 PM'
        WHEN 'Afternoon'  THEN '2:00 PM – 4:00 PM'
        WHEN 'Dinner Peak' THEN '5:00 PM – 8:00 PM'
        WHEN 'Late Night' THEN '9:00 PM – 10:00 PM'
        ELSE '-'
    END AS time_range,
    SUM(total_orders)                                            AS total_orders,
    SUM(total_revenue)                                           AS total_revenue,
    ROUND(SUM(total_revenue) / NULLIF(SUM(total_orders), 0), 2) AS avg_order_value
FROM restaurant_en.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant_en.peak_hours) - INTERVAL '30 days'
GROUP BY day_part
ORDER BY total_orders DESC
```

---

## Last 30 Days Summary

<span style="font-size:0.85em;color:var(--color-text-secondary)">{periode_30d[0].date_from} – {periode_30d[0].date_to}</span>

<BigValue data={peak_summary}      value="busiest_period"  title="Busiest Period" />
<BigValue data={peak_hour_summary} value="busiest_hour"    title="Busiest Hour" />
<BigValue data={peak_order_type}   value="top_order_type"  title="Top Order Type" />
<BigValue data={peak_hour_summary} value="total_orders"    title="Orders at Peak Hour" fmt="#,##0" />

{#if quiet_period.length > 0 && peak_summary.length > 0}
<div style="background:rgba(22,163,74,0.08);border-left:4px solid #16a34a;padding:12px 16px;border-radius:6px;margin:16px 0;">
📊 Busiest period: <strong>{peak_summary[0].busiest_period}</strong> with <strong>{peak_summary[0].total_orders}</strong> orders. Quietest: <strong>{quiet_period[0].quietest_period}</strong> with <strong>{quiet_period[0].total_orders}</strong> orders — a promotion opportunity to drive traffic during slow hours.
</div>
{/if}

---

## Order Distribution by Hour (Last 30 Days)

```sql hourly_all
SELECT
    order_hour,
    day_part,
    SUM(total_orders)  AS total_orders,
    SUM(total_revenue) AS total_revenue
FROM restaurant_en.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant_en.peak_hours) - INTERVAL '30 days'
GROUP BY order_hour, day_part
ORDER BY order_hour
```

<Grid cols=2>
<div>

### Orders by Hour

<BarChart
    data={hourly_all}
    x="order_hour"
    y="total_orders"
    series="day_part"
    title="Total Orders by Hour"
    xAxisTitle="Hour"
    yAxisTitle="Total Orders"
/>

</div>
<div>

### Revenue by Hour

<BarChart
    data={hourly_all}
    x="order_hour"
    y="total_revenue"
    series="day_part"
    title="Total Revenue by Hour ($)"
    yFmt="$#,##0.00"
    xAxisTitle="Hour"
    yAxisTitle="Revenue ($)"
/>

</div>
</Grid>

### Summary by Period

<DataTable data={daypart_summary}>
    <Column id="period"          title="Period"/>
    <Column id="time_range"      title="Hours"/>
    <Column id="total_orders"    title="Total Orders"   fmt="#,##0"/>
    <Column id="total_revenue"   title="Revenue"        fmt="$#,##0.00"/>
    <Column id="avg_order_value" title="Avg Order Value" fmt="$#,##0.00"/>
</DataTable>

_The two charts may not align — a period with fewer orders isn't necessarily low-revenue. Dinner Peak, for example, tends to have fewer transactions but a higher average ticket due to dine-in dominance. Use the **Avg Order Value** column to prioritize staffing: high-AOV periods need experienced team members, not just headcount._

---

## Weekday vs Weekend (Last 30 Days)

```sql weekday_vs_weekend
SELECT
    order_hour,
    CASE WHEN DAYOFWEEK(order_date) IN (1, 7) THEN 'Weekend' ELSE 'Weekday' END AS day_type,
    SUM(total_orders) AS total_orders
FROM restaurant_en.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant_en.peak_hours) - INTERVAL '30 days'
GROUP BY order_hour, day_type
ORDER BY order_hour, day_type
```

```sql daypart_weekday_weekend
SELECT
    day_part AS period,
    CASE WHEN DAYOFWEEK(order_date) IN (1, 7) THEN 'Weekend' ELSE 'Weekday' END AS day_type,
    SUM(total_orders)  AS total_orders,
    SUM(total_revenue) AS total_revenue
FROM restaurant_en.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant_en.peak_hours) - INTERVAL '30 days'
GROUP BY day_part, day_type
ORDER BY day_part, day_type
```

<Grid cols=2>
<div>

### Orders per Hour — Weekday vs Weekend

<BarChart
    data={weekday_vs_weekend}
    x="order_hour"
    y="total_orders"
    series="day_type"
    type="grouped"
    title="Orders by Hour — Weekday vs Weekend"
    xAxisTitle="Hour"
    yAxisTitle="Total Orders"
/>

</div>
<div>

### Period Contribution

<BarChart
    data={daypart_weekday_weekend}
    x="period"
    y="total_orders"
    series="day_type"
    type="grouped"
    title="Period — Weekday vs Weekend"
    xAxisTitle="Period"
    yAxisTitle="Total Orders"
/>

</div>
</Grid>

_Weekends typically shift traffic — lunch is busier and dine-in increases. If weekday and weekend patterns look nearly identical, the location is likely in a transit or office area._

---

## Order Type by Hour (Last 30 Days)

```sql order_type_hourly
SELECT
    order_hour,
    order_type,
    SUM(total_orders) AS total_orders
FROM restaurant_en.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant_en.peak_hours) - INTERVAL '30 days'
GROUP BY order_hour, order_type
ORDER BY order_hour
```

```sql order_type_by_branch
SELECT
    branch_name,
    day_part AS period,
    order_type,
    SUM(total_orders) AS total_orders
FROM restaurant_en.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant_en.peak_hours) - INTERVAL '30 days'
GROUP BY branch_name, day_part, order_type
ORDER BY branch_name, day_part, order_type
```

<Grid cols=2>
<div>

### Order Type by Hour

<BarChart
    data={order_type_hourly}
    x="order_hour"
    y="total_orders"
    series="order_type"
    type="stacked"
    title="Dine-in vs Delivery vs Takeaway by Hour"
    xAxisTitle="Hour"
    yAxisTitle="Total Orders"
/>

</div>
<div>

### By Location & Period

<DataTable data={order_type_by_branch}>
    <Column id="branch_name"  title="Location"/>
    <Column id="period"       title="Period"/>
    <Column id="order_type"   title="Order Type"/>
    <Column id="total_orders" title="Orders" fmt="#,##0"/>
</DataTable>

</div>
</Grid>

---

## Peak Hours by Location (Last 30 Days)

```sql peak_by_branch
SELECT
    branch_name,
    day_part AS period,
    SUM(total_orders) AS total_orders
FROM restaurant_en.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant_en.peak_hours) - INTERVAL '30 days'
GROUP BY branch_name, day_part
ORDER BY branch_name, total_orders DESC
```

<BarChart
    data={peak_by_branch}
    x="period"
    y="total_orders"
    series="branch_name"
    type="grouped"
    title="Period Distribution by Location"
    xAxisTitle="Period"
    yAxisTitle="Total Orders"
/>

_Each location may have a different peak hour depending on its neighborhood and customer demographics. Use this data as the basis for per-location staffing schedules._

---

## Tomorrow's Order Forecast

```sql tomorrow
SELECT
    STRFTIME('%B %d, %Y', CURRENT_DATE + INTERVAL '1 day') AS tomorrow_date,
    DAYNAME(CURRENT_DATE + INTERVAL '1 day')                AS day_name
FROM (SELECT 1) t
```

```sql forecast_tomorrow
SELECT
    order_hour,
    branch_name,
    ROUND(AVG(daily_total), 0) AS forecast_orders
FROM (
    SELECT
        order_date,
        order_hour,
        branch_name,
        SUM(total_orders) AS daily_total
    FROM restaurant_en.peak_hours
    WHERE DAYNAME(order_date) = DAYNAME(CURRENT_DATE + INTERVAL '1 day')
      AND order_date >= (SELECT MAX(order_date) FROM restaurant_en.peak_hours) - INTERVAL '30 days'
    GROUP BY order_date, order_hour, branch_name
)
GROUP BY order_hour, branch_name
ORDER BY order_hour, branch_name
```

### {tomorrow[0].tomorrow_date} — {tomorrow[0].day_name}

<BarChart
    data={forecast_tomorrow}
    x="order_hour"
    y="forecast_orders"
    series="branch_name"
    type="stacked"
    title="Forecast: Total Orders by Hour Tomorrow — by Location"
    xAxisTitle="Hour"
    yAxisTitle="Forecast Orders"
/>

_Forecast based on the average of all {tomorrow[0].day_name}s in the last 30 days. Use this to plan staffing headcount and stock prep the evening before._
