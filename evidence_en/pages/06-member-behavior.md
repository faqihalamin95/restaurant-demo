---
title: Member Behavior
---

_Purchase patterns for loyalty members — by tier, frequency, and spend value._

```sql periode_90d
SELECT
    STRFTIME('%b %d, %Y', MAX(order_date) - INTERVAL '89 days') AS date_from,
    STRFTIME('%b %d, %Y', MAX(order_date))                       AS date_to
FROM restaurant_en.member_purchase_behavior
```

```sql member_summary_90d
SELECT
    COUNT(DISTINCT member_id)                                  AS total_active_members,
    SUM(total_orders)                                          AS total_member_orders,
    SUM(total_spend)                                           AS total_member_spend,
    ROUND(SUM(total_spend) / NULLIF(SUM(total_orders), 0), 2) AS avg_order_value
FROM restaurant_en.member_purchase_behavior
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant_en.member_purchase_behavior) - INTERVAL '90 days'
```

```sql churn_count
SELECT
    COUNT(DISTINCT member_name)                                          AS churn_risk_count,
    SUM(CASE WHEN tier = 'Gold'   THEN 1 ELSE 0 END)                    AS gold_churn,
    SUM(CASE WHEN tier = 'Silver' THEN 1 ELSE 0 END)                    AS silver_churn
FROM (
    SELECT member_name, tier, MIN(recency_days) AS days_since_txn
    FROM restaurant_en.member_purchase_behavior
    WHERE order_date >= (SELECT MAX(order_date) FROM restaurant_en.member_purchase_behavior) - INTERVAL '90 days'
    GROUP BY member_name, tier
    HAVING
        (tier = 'Gold'   AND MIN(recency_days) >= 14) OR
        (tier = 'Silver' AND MIN(recency_days) >= 21) OR
        (tier = 'Bronze' AND MIN(recency_days) >= 30)
)
```

---

## Last 90 Days Summary

<span style="font-size:0.85em;color:var(--color-text-secondary)">{periode_90d[0].date_from} – {periode_90d[0].date_to}</span>

<div style="background:rgba(22,163,74,0.08);border-left:4px solid #1D9E75;padding:12px 16px;border-radius:6px;margin:12px 0;font-size:0.9em;line-height:1.6;">
💡 <strong>Why track loyal customers?</strong><br/>
Most restaurants have regulars — but without data, you don't know who they are, how often they visit, or when they start drifting away. A member program doesn't create loyal customers; it <strong>identifies the ones you already have</strong> so you can keep them before they leave without you noticing.
</div>

<BigValue data={member_summary_90d} value="total_active_members" title="Active Members"         fmt="#,##0" />
<BigValue data={member_summary_90d} value="total_member_orders"  title="Member Orders"          fmt="#,##0" />
<BigValue data={member_summary_90d} value="total_member_spend"   title="Total Member Spend"     fmt="$#,##0.00" />
<BigValue data={member_summary_90d} value="avg_order_value"      title="Avg Order Value"        fmt="$#,##0.00" />

{#if churn_count[0].churn_risk_count > 0}
<div style="background:rgba(248,201,0,0.1);border-left:4px solid #f8c900;padding:12px 16px;border-radius:6px;margin:16px 0;">
🟡 <strong>{churn_count[0].churn_risk_count} members at churn risk</strong> — no transaction in the past 14–30 days (threshold varies by tier).
{#if churn_count[0].gold_churn > 0} Includes <strong>{churn_count[0].gold_churn} Gold members</strong> — priority outreach.{/if}
{#if churn_count[0].silver_churn > 0} And <strong>{churn_count[0].silver_churn} Silver members</strong>.{/if}
See the full list at the bottom of this page.
</div>
{/if}

---

## Spend by Tier (Last 90 Days)

```sql tier_spending_90d
SELECT
    tier,
    COUNT(DISTINCT member_id)      AS total_members,
    SUM(total_orders)              AS total_orders,
    SUM(total_spend)               AS total_spend,
    ROUND(AVG(avg_order_value), 2) AS avg_order_value
FROM restaurant_en.member_purchase_behavior
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant_en.member_purchase_behavior) - INTERVAL '90 days'
GROUP BY 1
ORDER BY total_spend DESC
```

```sql tier_wow
SELECT
    tier,
    SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant_en.member_purchase_behavior) - INTERVAL '6 days'
        THEN total_spend END)                                                   AS spend_this_week,
    SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant_en.member_purchase_behavior) - INTERVAL '13 days'
         AND order_date < (SELECT MAX(order_date) FROM restaurant_en.member_purchase_behavior) - INTERVAL '6 days'
        THEN total_spend END)                                                   AS spend_last_week,
    ROUND(
        (SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant_en.member_purchase_behavior) - INTERVAL '6 days'
            THEN total_spend END)
        - SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant_en.member_purchase_behavior) - INTERVAL '13 days'
             AND order_date < (SELECT MAX(order_date) FROM restaurant_en.member_purchase_behavior) - INTERVAL '6 days'
            THEN total_spend END))
        / NULLIF(SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant_en.member_purchase_behavior) - INTERVAL '13 days'
             AND order_date < (SELECT MAX(order_date) FROM restaurant_en.member_purchase_behavior) - INTERVAL '6 days'
            THEN total_spend END), 0) * 100
    , 1) AS pct_change
FROM restaurant_en.member_purchase_behavior
GROUP BY 1
ORDER BY tier
```

<Grid cols=2>
<div>

### Total Spend by Tier

<BarChart
    data={tier_spending_90d}
    x="tier"
    y="total_spend"
    title="Total Member Spend by Tier ($)"
    yFmt="$#,##0.00"
    xAxisTitle="Tier"
    yAxisTitle="Total Spend ($)"
/>

</div>
<div>

### This Week vs Last Week

<DataTable data={tier_wow}>
    <Column id="tier"             title="Tier"/>
    <Column id="spend_this_week"  title="This Week"  fmt="$#,##0.00"/>
    <Column id="spend_last_week"  title="Last Week"  fmt="$#,##0.00"/>
    <Column id="pct_change"       title="Change"     fmt="+0.0;-0.0" contentType="delta"/>
</DataTable>

</div>
</Grid>

<DataTable data={tier_spending_90d}>
    <Column id="tier"            title="Tier"/>
    <Column id="total_members"   title="Members"        fmt="#,##0"/>
    <Column id="total_orders"    title="Orders"         fmt="#,##0"/>
    <Column id="total_spend"     title="Total Spend"    fmt="$#,##0.00"/>
    <Column id="avg_order_value" title="Avg Order Value" fmt="$#,##0.00"/>
</DataTable>

_Gold members drive disproportionate revenue despite being few — prioritize retention programs for them. Bronze members at scale are an upgrade opportunity through loyalty incentives._

---

## Top Members — Highest Spend (Last 90 Days)

```sql top_member_90d
SELECT
    member_name,
    tier,
    city,
    SUM(total_orders)                    AS total_orders,
    ROUND(SUM(total_orders) / 12.86, 1)  AS orders_per_week,
    SUM(total_spend)                     AS total_spend,
    ROUND(AVG(avg_order_value), 2)       AS avg_order_value,
    MIN(recency_days)                    AS days_since_last_visit
FROM restaurant_en.member_purchase_behavior
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant_en.member_purchase_behavior) - INTERVAL '90 days'
GROUP BY 1, 2, 3
ORDER BY total_spend DESC
LIMIT 25
```

<DataTable data={top_member_90d} rows=25>
    <Column id="member_name"           title="Member"/>
    <Column id="tier"                  title="Tier"/>
    <Column id="city"                  title="City"/>
    <Column id="total_orders"          title="Orders"          fmt="#,##0"/>
    <Column id="orders_per_week"       title="Freq (orders/wk)" fmt="0.0"/>
    <Column id="total_spend"           title="Total Spend"     fmt="$#,##0.00"/>
    <Column id="avg_order_value"       title="Avg Order Value" fmt="$#,##0.00"/>
    <Column id="days_since_last_visit" title="Days Since Visit" fmt="#,##0"/>
</DataTable>

_High-frequency + low spend = upselling opportunity. Low-frequency + high AOV = frequency program candidate (e.g., punch card, visit bonus)._

---

## Cohort Analysis — Members by Join Month

```sql cohort_total
SELECT
    DATE_TRUNC('month', join_date)                                           AS cohort_month,
    COUNT(DISTINCT member_id)                                                AS total_members,
    ROUND(SUM(total_spend) / NULLIF(COUNT(DISTINCT member_id), 0), 2)       AS avg_spend_per_member,
    ROUND(SUM(total_orders) / NULLIF(COUNT(DISTINCT member_id), 0) / 12.86, 1) AS avg_weekly_frequency
FROM restaurant_en.member_purchase_behavior
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant_en.member_purchase_behavior) - INTERVAL '90 days'
GROUP BY 1
ORDER BY 1
```

```sql cohort_summary
SELECT
    DATE_TRUNC('month', join_date)                                           AS cohort_month,
    tier,
    COUNT(DISTINCT member_id)                                                AS total_members,
    ROUND(SUM(total_spend) / NULLIF(COUNT(DISTINCT member_id), 0), 2)       AS avg_spend_per_member,
    ROUND(SUM(total_orders) / NULLIF(COUNT(DISTINCT member_id), 0) / 12.86, 1) AS avg_weekly_frequency
FROM restaurant_en.member_purchase_behavior
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant_en.member_purchase_behavior) - INTERVAL '90 days'
GROUP BY 1, 2
ORDER BY 1, 2
```

<Grid cols=2>
<div>

### Avg Spend per Member by Cohort

<LineChart
    data={cohort_total}
    x="cohort_month"
    y="avg_spend_per_member"
    title="Avg Spend per Member — by Join Month ($)"
    yFmt="$#,##0.00"
    xAxisTitle="Join Month"
    yAxisTitle="Avg Spend ($)"
/>

</div>
<div>

### Weekly Frequency by Cohort

<LineChart
    data={cohort_total}
    x="cohort_month"
    y="avg_weekly_frequency"
    title="Avg Weekly Frequency — by Join Month"
    yFmt="0.0"
    xAxisTitle="Join Month"
    yAxisTitle="Orders/Week"
/>

</div>
</Grid>

<DataTable data={cohort_summary}>
    <Column id="cohort_month"          title="Join Month"/>
    <Column id="tier"                  title="Tier"/>
    <Column id="total_members"         title="Members"         fmt="#,##0"/>
    <Column id="avg_spend_per_member"  title="Avg Spend"       fmt="$#,##0.00"/>
    <Column id="avg_weekly_frequency"  title="Freq (orders/wk)" fmt="0.0"/>
</DataTable>

_Ideal pattern: newer cohorts show higher spend and frequency — the loyalty program is getting more effective over time. The reverse means new member quality is declining._

---

## Churn Risk Members

```sql churn_risk
SELECT
    member_name, tier, city,
    SUM(total_orders)                                    AS total_orders,
    ROUND(SUM(total_orders) / 12.86, 1)                  AS orders_per_week,
    SUM(total_spend)                                     AS total_spend,
    ROUND(AVG(avg_order_value), 2)                       AS avg_order_value,
    MIN(recency_days)                                    AS days_since_last_visit,
    CASE tier WHEN 'Gold' THEN 14 WHEN 'Silver' THEN 21 ELSE 30 END AS churn_threshold_days
FROM restaurant_en.member_purchase_behavior
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant_en.member_purchase_behavior) - INTERVAL '90 days'
GROUP BY 1, 2, 3
HAVING
    (tier = 'Gold'   AND MIN(recency_days) >= 14) OR
    (tier = 'Silver' AND MIN(recency_days) >= 21) OR
    (tier = 'Bronze' AND MIN(recency_days) >= 30)
ORDER BY total_spend DESC, days_since_last_visit DESC
LIMIT 25
```

{#if churn_risk.length > 0}

<DataTable data={churn_risk}>
    <Column id="member_name"           title="Member"/>
    <Column id="tier"                  title="Tier"/>
    <Column id="city"                  title="City"/>
    <Column id="orders_per_week"       title="Freq (orders/wk)" fmt="0.0"/>
    <Column id="total_spend"           title="Total Spend"     fmt="$#,##0.00"/>
    <Column id="avg_order_value"       title="Avg Order Value" fmt="$#,##0.00"/>
    <Column id="days_since_last_visit" title="Days Since Visit" fmt="#,##0"/>
    <Column id="churn_threshold_days"  title="Churn Threshold" fmt="#,##0"/>
</DataTable>

_Thresholds: Gold 14 days, Silver 21 days, Bronze 30 days — calibrated to normal visit frequency per tier. High-frequency members who suddenly stop are more urgent than infrequent ones._

{:else}
<div style="background:rgba(22,163,74,0.08);border-left:4px solid #16a34a;padding:12px 16px;border-radius:6px;">
✅ <strong>No members at churn risk</strong> — all members have transacted within their tier's threshold.
</div>
{/if}
