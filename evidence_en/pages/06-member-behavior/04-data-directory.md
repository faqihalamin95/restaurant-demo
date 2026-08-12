---
title: Member Directory
---
<MemberTabs activeTab="direktori" />

<script>
  // No manual import needed if using native Evidence components
</script>

```sql all_members
WITH max_d AS (SELECT MAX(order_date) AS d FROM restaurant.member_purchase_behavior),
members AS (
    SELECT member_id, member_name, tier, city
    FROM restaurant.dim_members
),
orders_180 AS (
    SELECT member_id,
        SUM(total_orders) AS total_orders_180,
        SUM(total_spend) AS total_spend_180,
        ROUND(SUM(total_spend)/NULLIF(SUM(total_orders),0),0) AS avg_order_value_180
    FROM restaurant.member_purchase_behavior CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '179 days'
    GROUP BY member_id
),
visit_days AS (
    SELECT DISTINCT member_id, order_date
    FROM restaurant.member_purchase_behavior CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '179 days'
      AND order_date <= d
),
visit_gaps AS (
    SELECT
        member_id,
        order_date,
        DATEDIFF('day', LAG(order_date) OVER (PARTITION BY member_id ORDER BY order_date), order_date) AS gap_days
    FROM visit_days
),
visit_rhythm AS (
    SELECT
        member_id,
        ROUND(AVG(gap_days),1) AS avg_visit_interval_days
    FROM visit_gaps
    GROUP BY member_id
),
last_order AS (
    SELECT member_id, MAX(order_date) AS last_order_date
    FROM restaurant.member_purchase_behavior CROSS JOIN max_d
    WHERE order_date <= d
    GROUP BY member_id
),
base AS (
    SELECT
        m.member_name, m.tier, m.city,
        COALESCE(o.total_orders_180,0) AS total_orders,
        COALESCE(o.total_spend_180,0) AS total_spend,
        COALESCE(o.avg_order_value_180,0) AS avg_order_value,
        COALESCE(DATEDIFF('day', l.last_order_date, d), 9999) AS recency_days,
        r.avg_visit_interval_days,
        CASE
            WHEN r.avg_visit_interval_days IS NULL THEN NULL
            ELSE ROUND(COALESCE(DATEDIFF('day', l.last_order_date, d), 9999) - r.avg_visit_interval_days, 1)
        END AS delay_days
    FROM members m
    CROSS JOIN max_d
    LEFT JOIN orders_180 o ON m.member_id = o.member_id
    LEFT JOIN visit_rhythm r ON m.member_id = r.member_id
    LEFT JOIN last_order l ON m.member_id = l.member_id
),
spend_p75 AS (
    SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_spend) AS p75
    FROM base WHERE total_spend > 0
),
final_base AS (
  SELECT 
    RIGHT(member_name, 4) as kode_member,
    CASE 
      WHEN tier = 'Gold' THEN '✨ ' || tier
      WHEN tier = 'Silver' THEN '🥈 ' || tier
      ELSE '🥉 ' || tier
    END as tier_label,
    tier,
    total_spend,
    avg_order_value,
    total_orders,
    delay_days,
    CASE 
      WHEN avg_visit_interval_days IS NULL THEN '-' 
      ELSE CAST(avg_visit_interval_days AS VARCHAR) || ' days' 
    END AS ritme_kunjungan,
    CAST(recency_days AS VARCHAR) || ' days ago' AS last_order_label,
    CASE 
      WHEN tier = 'Gold' OR (tier IN ('Silver', 'Bronze') AND total_spend > (SELECT p75 FROM spend_p75)) THEN
        CASE 
          WHEN delay_days <= 7 OR delay_days IS NULL THEN 'Active'
          WHEN delay_days > 7 AND delay_days <= 14 THEN 'At Risk'
          ELSE 'Critical'
        END
      ELSE
        CASE 
          WHEN delay_days <= 7 OR delay_days IS NULL THEN 'Active'
          ELSE 'Passive'
        END
    END as status,
    CASE 
      WHEN tier = 'Gold' OR (tier IN ('Silver', 'Bronze') AND total_spend > (SELECT p75 FROM spend_p75)) THEN
        CASE 
          WHEN delay_days <= 7 OR delay_days IS NULL THEN '🟢 Active'
          WHEN delay_days > 7 AND delay_days <= 14 THEN '🟡 At Risk'
          ELSE '🔴 Critical'
        END
      ELSE
        CASE 
          WHEN delay_days <= 7 OR delay_days IS NULL THEN '🟢 Active'
          ELSE '⚪ Passive'
        END
    END as status_label,
    CASE
      WHEN tier = 'Gold' OR (tier IN ('Silver', 'Bronze') AND total_spend > (SELECT p75 FROM spend_p75)) THEN
        CASE 
          WHEN delay_days <= 7 OR delay_days IS NULL THEN '✨ Maintain'
          WHEN delay_days > 7 AND delay_days <= 14 THEN '📲 Send Promo'
          ELSE '📞 Follow Up'
        END
      ELSE
        CASE 
          WHEN delay_days <= 7 OR delay_days IS NULL THEN '✨ Maintain'
          ELSE '💤 Ignore'
        END
    END as action_label
  FROM base
)
SELECT * FROM final_base
WHERE (tier = '${inputs.tier_filter?.value || inputs.tier_filter || 'All'}' OR '${inputs.tier_filter?.value || inputs.tier_filter || 'All'}' = 'All')
  AND (status = '${inputs.status_filter?.value || inputs.status_filter || 'All'}' OR '${inputs.status_filter?.value || inputs.status_filter || 'All'}' = 'All')
ORDER BY total_spend DESC
```

```sql tier_distribution
SELECT tier, count(*) as count
FROM ${all_members}
GROUP BY tier
ORDER BY count DESC
```

<!-- Dropdown harus selalu render agar input terdaftar di Evidence -->
<div style={all_members && all_members.length > 0 ? '' : 'display:none'}>
  <Dropdown name="tier_filter" defaultValue="All">
    <DropdownOption value="All" valueLabel="All Tiers" />
    <DropdownOption value="Gold" />
    <DropdownOption value="Silver" />
    <DropdownOption value="Bronze" />
  </Dropdown>
  <Dropdown name="status_filter" defaultValue="All">
    <DropdownOption value="All" valueLabel="All Statuses" />
    <DropdownOption value="Active" />
    <DropdownOption value="At Risk" />
    <DropdownOption value="Critical" />
    <DropdownOption value="Passive" />
  </Dropdown>
</div>

{#if all_members && all_members.length > 0}
<div class="directory-container">
  <div class="diagnostics-header" style="margin-bottom: 24px; margin-top: 24px;">
    <div class="diagnostics-eyebrow">🗂️ DATA EXPLORATION</div>
<h2 class="diagnostics-title">Member Cohort Database</h2>
    <p class="diagnostics-copy">Utilize dynamic filtration criteria below to isolate specific guest segments and analyze unit-level behavioral profiles.</p>
  </div>

  <!-- Smart Filters -->
  <div class="filter-panel">
    <div class="filter-group">
      <div class="filter-label">Loyalty Tier Filter:</div>
      <Dropdown name="tier_filter" defaultValue="All">
        <DropdownOption value="All" valueLabel="All Tiers" />
        <DropdownOption value="Gold" />
        <DropdownOption value="Silver" />
        <DropdownOption value="Bronze" />
      </Dropdown>
    </div>
    
    <div class="filter-group">
      <div class="filter-label">Filter Status:</div>
      <Dropdown name="status_filter" defaultValue="All">
        <DropdownOption value="All" valueLabel="All Statuses" />
        <DropdownOption value="Active" />
        <DropdownOption value="At Risk" />
        <DropdownOption value="Critical" />
        <DropdownOption value="Passive" />
      </Dropdown>
    </div>
  </div>

  <!-- Mini Charts / Segmentations -->
  <div class="chart-card" style="margin-top: 24px;">
    <h3 class="chart-title">Cohort Economics & Behavioral Mapping</h3>
    
    <div class="charts-inner-grid">
      <!-- Chart 1: Tier Composition -->
      <div class="chart-section">
        <h4 class="chart-subtitle">Tier Distribution Matrix</h4>
        <ECharts height="300px" config={{
            tooltip: { trigger: 'item' },
            series: [
                {
                    type: 'pie',
                    radius: ['45%', '75%'],
                    itemStyle: {
                        borderRadius: 10,
                        borderColor: '#fff',
                        borderWidth: 2
                    },
                    label: { show: false },
                    data: Array.isArray(tier_distribution) ? tier_distribution.map(d => {
                        let color = '#94a3b8';
                        if (d.tier === 'Gold') color = '#fcd34d';
                        if (d.tier === 'Silver') color = '#cbd5e1';
                        if (d.tier === 'Bronze') color = '#d49a6a';
                        return { value: d.count, name: d.tier, itemStyle: { color: color } };
                    }) : []
                }
            ]
        }} />
      </div>

      <!-- Chart 2: LTV vs Recency -->
      <div class="chart-section">
        <h4 class="chart-subtitle">Lifetime Value (LTV) vs. Recency Degradation</h4>
        <ECharts height="300px" config={{
            tooltip: { formatter: '{b}' },
            grid: { left: '5%', right: '8%', top: '10%', bottom: '15%', containLabel: true },
            xAxis: { 
                name: 'Total Spend', 
                nameLocation: 'middle',
                nameGap: 30,
                type: 'value', 
                splitLine: { lineStyle: { type: 'dashed', color: '#e2e8f0' } },
                axisLabel: {
                    formatter: function (value) {
                        if (value >= 1000000) return (value / 1000000) + ' M';
                        if (value >= 1000) return (value / 1000) + ' K';
                        return value;
                    }
                }
            },
            yAxis: { 
                name: 'Absence (Days)', 
                type: 'value', 
                splitLine: { lineStyle: { type: 'dashed', color: '#e2e8f0' } } 
            },
            series: [{
                type: 'scatter',
                symbolSize: 12,
                itemStyle: {
                    color: function(params) {
                        let status = params.value[2];
                        if (status === 'Active') return '#22c55e';
                        if (status === 'At Risk') return '#eab308';
                        if (status === 'Critical') return '#ef4444';
                        return '#94a3b8'; // gray for Passive
                    },
                    opacity: 0.7
                },
                data: Array.isArray(all_members) ? all_members.map(d => {
                    return {
                        name: d.kode_member + ' (' + d.tier + ')',
                        value: [d.total_spend, d.delay_days, d.status]
                    };
                }) : []
            }]
        }} />
      </div>
    </div>
  </div>

  <!-- Status Parameter Guide -->
  <details class="guide-acc" style="margin-top: 32px; margin-bottom: 24px;">
    <summary>💡 Behavioral Status & Intervention Protocols</summary>
    <div class="guide-body">
      <p style="margin-top: 4px; margin-bottom: 16px; font-weight: 500; color: var(--color-text-secondary);">
        Algorithmic logic governing guest status classification and prescribed operational workflows. 
      </p>
      
      <div style="margin-bottom: 24px; padding: 14px 18px; border-radius: 12px; background: linear-gradient(135deg, rgba(99,102,241,0.06), rgba(139,92,246,0.02)); border: 1px solid rgba(99,102,241,0.25); font-size: 0.9rem; line-height: 1.6; color: var(--color-text-secondary);">
        <strong style="color: var(--color-text-primary); display: flex; align-items: center; gap: 6px; margin-bottom: 6px; font-size: 0.95rem;">
          <span>🧠</span> Algorithmic Velocity Benchmarking
        </strong>
        The "Delay" metric is <strong>dynamically calibrated per individual profile</strong>. Rather than applying a static network-wide benchmark, the model calculates the delta between days since the last transaction and the guest's <i>historical mean visit interval</i>. <br/>
        <span style="display: inline-block; margin-top: 6px; font-size: 0.85rem; padding: 4px 8px; background: rgba(0,0,0,0.04); border-radius: 6px;">Operational Logic: If Guest A exhibits a baseline frequency of every 3 days, and current recency is 10 days, the engine flags a 7-day velocity delay.</span>
      </div>
      <div class="guide-grid" style="grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 12px;">
        <div class="guide-card teal">
          <div class="guide-card-icon">🟢</div>
          <div class="guide-card-content">
            <div class="guide-card-label">Active (Retained)</div>
            <h4 class="guide-card-title">Velocity Delay ≤ 7 Days</h4>
            <p class="guide-card-desc">Guest continues to transact within their statistical baseline. No operational intervention prescribed.</p>
          </div>
        </div>
        <div class="guide-card orange">
          <div class="guide-card-icon">🟡</div>
          <div class="guide-card-content">
            <div class="guide-card-label">At Risk (Degrading)</div>
            <h4 class="guide-card-title">Velocity Delay 8-14 Days</h4>
            <p class="guide-card-desc">High-LTV (Gold/Top Silver) profile exhibiting visit deceleration. Prescribed action: Deploy automated, low-friction win-back incentives.</p>
          </div>
        </div>
        <div class="guide-card red">
          <div class="guide-card-icon">🔴</div>
          <div class="guide-card-content">
            <div class="guide-card-label">Critical (Imminent Churn)</div>
            <h4 class="guide-card-title">Velocity Delay > 14 Days</h4>
            <p class="guide-card-desc">High-LTV profile statistically probable for competitor defection. Prescribed action: Mandate immediate manual FOH or management outreach.</p>
          </div>
        </div>
        <div class="guide-card slate">
          <div class="guide-card-icon">⚪</div>
          <div class="guide-card-content">
            <div class="guide-card-label">Passive (Low Priority)</div>
            <h4 class="guide-card-title">Sub-LTV Threshold</h4>
            <p class="guide-card-desc">Lower-tier profile demonstrating frequency decay. Algorithmic suppression prevents misallocation of staff bandwidth on low-yield follow-ups.</p>
          </div>
        </div>
      </div>
    </div>
  </details>

  <!-- Rich DataTable -->
  <div class="table-card" style="margin-top: 32px;">
    <DataTable data={all_members} search="true" rows=15 rowLines="true">
      <Column id="kode_member" title="Code" />
      <Column id="tier_label" title="Tier" />
      <Column id="total_orders" title="Total Visits" align="center" />
      <Column id="total_spend" title="Total Spend (LTV)" fmt="Rp#,##0" />
      <Column id="avg_order_value" title="Average (AOV)" fmt="Rp#,##0" />
      <Column id="last_order_label" title="Last Visit" align="center" />
      <Column id="ritme_kunjungan" title="Baseline Velocity" align="center" />
      <Column id="status_label" title="Status" />
      <Column id="action_label" title="Prescribed Workflow" />
    </DataTable>
  </div>
</div>
{:else}
  <GlobalLoading />
{/if}

<style>
  .directory-container {
    animation: fadeIn 0.4s ease-out;
  }

  .filter-panel {
    display: flex;
    gap: 32px;
    padding: 20px 24px;
    background: rgba(255, 255, 255, 0.65);
    backdrop-filter: blur(12px);
    border-radius: 16px;
    border: 1px solid rgba(13, 148, 136, 0.15);
    box-shadow: 0 4px 12px rgba(0,0,0,0.02);
  }

  .filter-group {
    display: flex;
    align-items: center;
    gap: 16px;
  }

  .filter-label {
    font-size: 0.85rem;
    font-weight: 800;
    text-transform: uppercase;
    letter-spacing: 0.05em;
    color: var(--color-text-tertiary);
  }

  .charts-inner-grid {
    display: grid;
    grid-template-columns: 1fr 2fr;
    gap: 24px;
    align-items: center;
  }

  .chart-section {
    display: flex;
    flex-direction: column;
    justify-content: center;
  }

  .chart-subtitle {
    font-size: 0.95rem;
    font-weight: 700;
    color: var(--color-text-secondary);
    text-align: center;
    margin: 0 0 16px 0;
  }

  @media (max-width: 768px) {
    .charts-inner-grid {
      grid-template-columns: 1fr;
    }
    .filter-panel {
      flex-direction: column;
      gap: 16px;
    }
  }

  .chart-card {
    background: rgba(255, 255, 255, 0.45);
    border: 1px solid var(--color-border-tertiary);
    border-radius: 16px;
    padding: 24px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.02);
    display: flex;
    flex-direction: column;
    min-height: 340px;
    transition: all 0.3s ease;
  }
  
  .chart-card:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 24px rgba(13, 148, 136, 0.08);
    border-color: rgba(13, 148, 136, 0.2);
  }

  .chart-title {
    font-size: 1.05rem;
    font-weight: 800;
    color: var(--color-text-primary);
    margin: 0 0 16px 0;
    padding-bottom: 12px;
    border-bottom: 1px dashed var(--color-border-tertiary);
  }

  .table-card {
    background: rgba(255, 255, 255, 0.45);
    border: 1px solid var(--color-border-tertiary);
    border-radius: 16px;
    padding: 24px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.02);
  }

  .guide-card.red { border-color: rgba(239,68,68,0.16); background: linear-gradient(135deg, rgba(239,68,68,0.04), rgba(255,255,255,0.8)); }
  .guide-card.slate { border-color: rgba(148,163,184,0.16); background: linear-gradient(135deg, rgba(148,163,184,0.04), rgba(255,255,255,0.8)); }
</style>
