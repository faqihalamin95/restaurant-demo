---
title: Employee Performance
---

_Staff productivity, attendance patterns, and shift analysis._

```sql periode_30d
SELECT
    STRFTIME('%b %d, %Y', MAX(attendance_date) - INTERVAL '29 days') AS date_from,
    STRFTIME('%b %d, %Y', MAX(attendance_date))                       AS date_to
FROM restaurant_en.employee_shift_performance
```

```sql employee_summary_30d
SELECT
    COUNT(DISTINCT employee_id)                                             AS total_staff,
    SUM(orders_handled)                                                     AS total_orders_handled,
    SUM(total_revenue)                                                      AS total_revenue_handled,
    ROUND(SUM(total_revenue) / NULLIF(SUM(orders_handled), 0), 2)          AS avg_order_value
FROM restaurant_en.employee_shift_performance
WHERE attendance_date >= (SELECT MAX(attendance_date) FROM restaurant_en.employee_shift_performance) - INTERVAL '30 days'
```

```sql attendance_problem_count
SELECT COUNT(DISTINCT employee_name) AS flagged_staff
FROM (
    SELECT employee_name
    FROM restaurant_en.employee_shift_performance
    WHERE attendance_date >= (SELECT MAX(attendance_date) FROM restaurant_en.employee_shift_performance) - INTERVAL '30 days'
    GROUP BY employee_name
    HAVING
        SUM(CASE WHEN attendance_status = 'absent' THEN 1 ELSE 0 END) >= 2
        OR SUM(CASE WHEN attendance_status = 'late'   THEN 1 ELSE 0 END) >= 4
)
```

```sql attendance_alert_today
SELECT COUNT(*) AS absent_count
FROM restaurant_en.employee_shift_performance
WHERE attendance_date = (SELECT MAX(attendance_date) FROM restaurant_en.employee_shift_performance)
  AND attendance_status = 'absent'
```

---

## Last 30 Days Summary

<span style="font-size:0.85em;color:var(--color-text-secondary)">{periode_30d[0].date_from} – {periode_30d[0].date_to}</span>

<BigValue data={employee_summary_30d} value="total_staff"            title="Active Staff" />
<BigValue data={employee_summary_30d} value="total_orders_handled"   title="Orders Handled (30 Days)"    fmt="#,##0" />
<BigValue data={employee_summary_30d} value="total_revenue_handled"  title="Revenue Handled ($)"         fmt="$#,##0.00" />
<BigValue data={employee_summary_30d} value="avg_order_value"        title="Avg Order Value"             fmt="$#,##0.00" />

{#if attendance_problem_count[0].flagged_staff > 0}
<div style="background:rgba(220,38,38,0.08);border-left:4px solid #dc2626;padding:12px 16px;border-radius:6px;margin:16px 0;">
🔴 <strong>{attendance_problem_count[0].flagged_staff} staff members</strong> with attendance issues in the last 30 days — absent ≥ 2 or late ≥ 4 times. Details at the bottom of this page.
</div>
{:else if attendance_alert_today[0].absent_count >= 3}
<div style="background:rgba(248,201,0,0.1);border-left:4px solid #f8c900;padding:12px 16px;border-radius:6px;margin:16px 0;">
🟡 <strong>{attendance_alert_today[0].absent_count} staff absent</strong> yesterday. Verify no shifts are understaffed.
</div>
{:else}
<div style="background:rgba(22,163,74,0.08);border-left:4px solid #16a34a;padding:12px 16px;border-radius:6px;margin:16px 0;">
✅ <strong>Attendance normal.</strong> No staff with problematic absence patterns in the last 30 days.
</div>
{/if}

---

## Attendance Distribution (Last 30 Days)

```sql attendance_mix_30d
SELECT
    attendance_status,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS pct
FROM restaurant_en.employee_shift_performance
WHERE attendance_date >= (SELECT MAX(attendance_date) FROM restaurant_en.employee_shift_performance) - INTERVAL '30 days'
GROUP BY 1
ORDER BY 2 DESC
```

```sql attendance_by_branch
SELECT
    branch_name,
    attendance_status,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY branch_name), 1) AS pct
FROM restaurant_en.employee_shift_performance
WHERE attendance_date >= (SELECT MAX(attendance_date) FROM restaurant_en.employee_shift_performance) - INTERVAL '30 days'
GROUP BY 1, 2
ORDER BY branch_name, pct DESC
```

<Grid cols=2>
<div>

### Overall

<BarChart
    data={attendance_mix_30d}
    x="attendance_status"
    y="pct"
    yFmt="0.0\%"
    title="Attendance Status — All Locations"
    xAxisTitle="Status"
    yAxisTitle="Percentage (%)"
/>

</div>
<div>

### By Location

<BarChart
    data={attendance_by_branch}
    x="branch_name"
    y="pct"
    yFmt="0.0\%"
    series="attendance_status"
    title="Attendance Status by Location"
    xAxisTitle="Location"
    yAxisTitle="Percentage (%)"
/>

</div>
</Grid>

---

## Daily Attendance Trend (Last 30 Days)

```sql attendance_daily_trend
SELECT
    attendance_date,
    SUM(CASE WHEN attendance_status = 'present' THEN 1 ELSE 0 END) AS present,
    SUM(CASE WHEN attendance_status = 'late'    THEN 1 ELSE 0 END) AS late,
    SUM(CASE WHEN attendance_status = 'absent'  THEN 1 ELSE 0 END) AS absent,
    SUM(CASE WHEN attendance_status = 'leave'   THEN 1 ELSE 0 END) AS on_leave,
    ROUND(
        (SUM(CASE WHEN attendance_status IN ('absent', 'leave') THEN 1 ELSE 0 END) * 100.0)
        / NULLIF(COUNT(*), 0)
    , 1) AS pct_not_present
FROM restaurant_en.employee_shift_performance
WHERE attendance_date >= (SELECT MAX(attendance_date) FROM restaurant_en.employee_shift_performance) - INTERVAL '30 days'
GROUP BY 1
ORDER BY 1
```

```sql attendance_by_dayofweek
SELECT
    DAYNAME(attendance_date)   AS day_name,
    DAYOFWEEK(attendance_date) AS day_order,
    ROUND(AVG(CASE WHEN attendance_status = 'absent' THEN 1.0 ELSE 0 END) * 100, 1) AS avg_pct_absent,
    ROUND(AVG(CASE WHEN attendance_status = 'late'   THEN 1.0 ELSE 0 END) * 100, 1) AS avg_pct_late
FROM restaurant_en.employee_shift_performance
WHERE attendance_date >= (SELECT MAX(attendance_date) FROM restaurant_en.employee_shift_performance) - INTERVAL '30 days'
GROUP BY 1, 2
ORDER BY 2
```

<Grid cols=2>
<div>

### % Not Present — Daily Trend

<LineChart
    data={attendance_daily_trend}
    x="attendance_date"
    y="pct_not_present"
    title="% Not Present (Absent + Leave) per Day"
    yFmt="0.0\%"
    xAxisTitle="Date"
    yAxisTitle="% Not Present"
/>

</div>
<div>

### Pattern by Day of Week

<BarChart
    data={attendance_by_dayofweek}
    x="day_name"
    y={["avg_pct_absent", "avg_pct_late"]}
    type="grouped"
    title="Avg % Absent & Late by Day of Week"
    yFmt="0.0\%"
    xAxisTitle="Day"
    yAxisTitle="Avg (%)"
/>

</div>
</Grid>

---

## Performance by Shift (Last 30 Days)

```sql shift_performance_30d
SELECT
    shift_name,
    SUM(orders_handled)       AS total_orders,
    SUM(total_revenue)        AS total_revenue,
    ROUND(SUM(total_revenue) / NULLIF(SUM(orders_handled), 0), 2) AS avg_order_value
FROM restaurant_en.employee_shift_performance
WHERE attendance_date >= (SELECT MAX(attendance_date) FROM restaurant_en.employee_shift_performance) - INTERVAL '30 days'
GROUP BY 1
ORDER BY total_revenue DESC
```

<Grid cols=2>
<div>

### Revenue by Shift

<BarChart
    data={shift_performance_30d}
    x="shift_name"
    y="total_revenue"
    title="Revenue by Shift — 30 Days ($)"
    yFmt="$#,##0.00"
    xAxisTitle="Shift"
    yAxisTitle="Revenue ($)"
/>

</div>
<div>

<DataTable data={shift_performance_30d}>
    <Column id="shift_name"      title="Shift"/>
    <Column id="total_orders"    title="Orders Handled"  fmt="#,##0"/>
    <Column id="total_revenue"   title="Revenue"         fmt="$#,##0.00"/>
    <Column id="avg_order_value" title="Avg Ticket"      fmt="$#,##0.00"/>
</DataTable>

</div>
</Grid>

_Shifts with a high average ticket suggest staff are effectively upselling. High-volume but low-AOV shifts are upselling program candidates._

---

## Overtime Analysis (Last 30 Days)

_High overtime in a given shift signals understaffing, not high productivity. Don't celebrate overtime — investigate the root cause._

```sql overtime_by_shift
SELECT
    shift_name,
    COUNT(DISTINCT employee_id)                                                     AS total_staff,
    SUM(overtime_hours)                                                              AS total_overtime_hours,
    ROUND(AVG(overtime_hours), 2)                                                    AS avg_ot_per_person,
    ROUND(SUM(CASE WHEN overtime_hours > 0 THEN 1 ELSE 0 END) * 100.0
          / NULLIF(COUNT(*), 0), 1)                                                  AS pct_sessions_with_ot
FROM restaurant_en.employee_shift_performance
WHERE attendance_date >= (SELECT MAX(attendance_date) FROM restaurant_en.employee_shift_performance) - INTERVAL '30 days'
  AND attendance_status IN ('present', 'late')
GROUP BY 1
ORDER BY total_overtime_hours DESC
```

```sql top_overtime_employees
SELECT
    employee_name, role, branch_name, shift_name,
    SUM(overtime_hours)                                             AS total_overtime_hours,
    COUNT(CASE WHEN overtime_hours > 0 THEN 1 END)                 AS ot_days,
    ROUND(AVG(CASE WHEN overtime_hours > 0 THEN overtime_hours END), 1) AS avg_hrs_per_session
FROM restaurant_en.employee_shift_performance
WHERE attendance_date >= (SELECT MAX(attendance_date) FROM restaurant_en.employee_shift_performance) - INTERVAL '30 days'
  AND attendance_status IN ('present', 'late')
GROUP BY 1, 2, 3, 4
HAVING SUM(overtime_hours) > 0
ORDER BY total_overtime_hours DESC
LIMIT 15
```

<DataTable data={overtime_by_shift}>
    <Column id="shift_name"             title="Shift"/>
    <Column id="total_staff"            title="Staff"               fmt="#,##0"/>
    <Column id="total_overtime_hours"   title="Total OT Hours"      fmt="#,##0"/>
    <Column id="avg_ot_per_person"      title="Avg per Person"      fmt="0.00"/>
    <Column id="pct_sessions_with_ot"   title="% Sessions with OT"  fmt="0.0\%"/>
</DataTable>

### Top Overtime Employees

<DataTable data={top_overtime_employees}>
    <Column id="employee_name"        title="Employee"/>
    <Column id="role"                 title="Role"/>
    <Column id="branch_name"          title="Location"/>
    <Column id="shift_name"           title="Shift"/>
    <Column id="total_overtime_hours" title="Total OT Hrs"     fmt="#,##0"/>
    <Column id="ot_days"              title="OT Days"          fmt="#,##0"/>
    <Column id="avg_hrs_per_session"  title="Avg Hrs/Session"  fmt="0.0"/>
</DataTable>

---

## Performance by Role (Last 30 Days)

```sql role_performance_30d
SELECT
    role,
    COUNT(DISTINCT employee_id)       AS total_staff,
    SUM(orders_handled)               AS total_orders,
    SUM(total_revenue)                AS total_revenue,
    ROUND(AVG(avg_ticket), 2)         AS avg_order_value,
    ROUND(SUM(orders_handled) * 1.0 / NULLIF(COUNT(DISTINCT employee_id), 0), 1) AS avg_orders_per_person,
    ROUND(AVG(CASE WHEN attendance_status = 'absent' THEN 1.0 ELSE 0 END) * 100, 1) AS pct_absent,
    ROUND(AVG(CASE WHEN attendance_status = 'late'   THEN 1.0 ELSE 0 END) * 100, 1) AS pct_late
FROM restaurant_en.employee_shift_performance
WHERE attendance_date >= (SELECT MAX(attendance_date) FROM restaurant_en.employee_shift_performance) - INTERVAL '30 days'
GROUP BY 1
ORDER BY total_revenue DESC
```

<DataTable data={role_performance_30d}>
    <Column id="role"                  title="Role"/>
    <Column id="total_staff"           title="Staff"                fmt="#,##0"/>
    <Column id="total_orders"          title="Orders"               fmt="#,##0"/>
    <Column id="avg_orders_per_person" title="Orders/Person"        fmt="0.0"/>
    <Column id="total_revenue"         title="Revenue"              fmt="$#,##0.00"/>
    <Column id="avg_order_value"       title="Avg Ticket"           fmt="$#,##0.00"/>
    <Column id="pct_absent"            title="% Absent"             fmt="0.0\%"/>
    <Column id="pct_late"              title="% Late"               fmt="0.0\%"/>
</DataTable>

---

## Top 20 Employees — Revenue Handled (Last 30 Days)

```sql top_employee_30d
SELECT
    employee_name, role, branch_name, shift_name,
    SUM(orders_handled)                                            AS orders_handled,
    SUM(total_revenue)                                             AS total_revenue,
    ROUND(SUM(total_revenue) / NULLIF(SUM(orders_handled), 0), 2) AS avg_order_value,
    SUM(CASE WHEN attendance_status = 'late'   THEN 1 ELSE 0 END) AS total_late,
    SUM(CASE WHEN attendance_status = 'absent' THEN 1 ELSE 0 END) AS total_absent,
    SUM(overtime_hours)                                            AS total_overtime_hours
FROM restaurant_en.employee_shift_performance
WHERE attendance_date >= (SELECT MAX(attendance_date) FROM restaurant_en.employee_shift_performance) - INTERVAL '30 days'
GROUP BY 1, 2, 3, 4
ORDER BY total_revenue DESC
LIMIT 20
```

<DataTable data={top_employee_30d} rows=20>
    <Column id="employee_name"        title="Employee"/>
    <Column id="role"                 title="Role"/>
    <Column id="branch_name"          title="Location"/>
    <Column id="shift_name"           title="Shift"/>
    <Column id="orders_handled"       title="Orders"          fmt="#,##0"/>
    <Column id="total_revenue"        title="Revenue"         fmt="$#,##0.00"/>
    <Column id="avg_order_value"      title="Avg Ticket"      fmt="$#,##0.00"/>
    <Column id="total_overtime_hours" title="OT Hours"        fmt="#,##0"/>
    <Column id="total_late"           title="Late"            fmt="#,##0"/>
    <Column id="total_absent"         title="Absent"          fmt="#,##0"/>
</DataTable>

---

## Revenue per Hour Worked — Fair Cross-Shift Comparison

_Evening shift staff will always show lower total revenue due to shorter service windows — not because of lower performance. This metric levels the playing field._

```sql revenue_per_hour
WITH shift_hours AS (
    SELECT shift_id, shift_name,
        CASE shift_id WHEN 'S1' THEN 7 WHEN 'S2' THEN 8 WHEN 'S3' THEN 7 ELSE 7 END AS shift_duration_hours
    FROM (SELECT DISTINCT shift_id, shift_name FROM restaurant_en.employee_shift_performance)
),
employee_stats AS (
    SELECT
        e.employee_name, e.role, e.branch_name, e.shift_name, e.shift_id,
        COUNT(CASE WHEN e.attendance_status IN ('present', 'late') THEN 1 END) AS days_worked,
        SUM(e.orders_handled)   AS total_orders,
        SUM(e.total_revenue)    AS total_revenue,
        ROUND(AVG(e.avg_ticket), 2) AS avg_ticket
    FROM restaurant_en.employee_shift_performance e
    WHERE attendance_date >= (SELECT MAX(attendance_date) FROM restaurant_en.employee_shift_performance) - INTERVAL '30 days'
    GROUP BY 1, 2, 3, 4, 5
    HAVING days_worked > 0
)
SELECT
    es.employee_name, es.role, es.branch_name, es.shift_name,
    es.days_worked,
    es.total_orders,
    es.total_revenue,
    es.avg_ticket,
    es.days_worked * sh.shift_duration_hours                                    AS estimated_hours,
    ROUND(es.total_revenue / NULLIF(es.days_worked * sh.shift_duration_hours, 0), 2) AS revenue_per_hour,
    ROUND(es.total_orders  / NULLIF(es.days_worked * sh.shift_duration_hours, 0), 2) AS orders_per_hour
FROM employee_stats es
LEFT JOIN shift_hours sh ON es.shift_id = sh.shift_id
ORDER BY revenue_per_hour DESC
LIMIT 20
```

### Top 20 — Revenue per Hour

<DataTable data={revenue_per_hour} rows=20>
    <Column id="employee_name"    title="Employee"/>
    <Column id="role"             title="Role"/>
    <Column id="branch_name"      title="Location"/>
    <Column id="shift_name"       title="Shift"/>
    <Column id="days_worked"      title="Days Worked"     fmt="#,##0"/>
    <Column id="estimated_hours"  title="Est. Hours"      fmt="#,##0"/>
    <Column id="total_revenue"    title="Revenue"         fmt="$#,##0.00"/>
    <Column id="revenue_per_hour" title="Rev/Hour ↑"      fmt="$#,##0.00"/>
    <Column id="orders_per_hour"  title="Orders/Hour"     fmt="0.00"/>
    <Column id="avg_ticket"       title="Avg Ticket"      fmt="$#,##0.00"/>
</DataTable>

---

## Staff with Attendance Issues (Last 30 Days)

```sql attendance_problem
SELECT
    employee_name, role, branch_name,
    SUM(CASE WHEN attendance_status = 'absent' THEN 1 ELSE 0 END) AS total_absent,
    SUM(CASE WHEN attendance_status = 'late'   THEN 1 ELSE 0 END) AS total_late,
    SUM(CASE WHEN attendance_status = 'leave'  THEN 1 ELSE 0 END) AS total_on_leave,
    COUNT(*)                                                        AS total_work_days
FROM restaurant_en.employee_shift_performance
WHERE attendance_date >= (SELECT MAX(attendance_date) FROM restaurant_en.employee_shift_performance) - INTERVAL '30 days'
GROUP BY 1, 2, 3
HAVING
    SUM(CASE WHEN attendance_status = 'absent' THEN 1 ELSE 0 END) >= 2
    OR SUM(CASE WHEN attendance_status = 'late' THEN 1 ELSE 0 END) >= 4
ORDER BY total_absent DESC, total_late DESC
```

{#if attendance_problem.length > 0}

<DataTable data={attendance_problem}>
    <Column id="employee_name"  title="Employee"/>
    <Column id="role"           title="Role"/>
    <Column id="branch_name"    title="Location"/>
    <Column id="total_work_days" title="Work Days" fmt="#,##0"/>
    <Column id="total_absent"   title="Absent"     fmt="#,##0"/>
    <Column id="total_late"     title="Late"       fmt="#,##0"/>
    <Column id="total_on_leave" title="On Leave"   fmt="#,##0"/>
</DataTable>

_Supervisors with attendance issues have a larger operational impact than individual contributors — address them with higher urgency._

{:else}
<div style="background:rgba(22,163,74,0.08);border-left:4px solid #16a34a;padding:12px 16px;border-radius:6px;">
✅ <strong>No staff with attendance issues</strong> in the last 30 days — ideal conditions.
</div>
{/if}
