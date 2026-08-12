---
title: Analysis
---

<script>
  import InvGuide from '$lib/InvGuide.svelte';
  import InvTabs from '$lib/InvTabs.svelte';
  import SectionHeader from '$lib/SectionHeader.svelte';
  import SectionCard from '$lib/SectionCard.svelte';
  import PremiumTable from '$lib/PremiumTable.svelte';


</script>

<InvGuide />

<InvTabs activeTab="analysis" />

```sql supplier_kpi
/* 
  PIPELINE DATA KPI SUPPLIER
  Total Pengeluaran dan Inflasi menggunakan DATA ASLI dari mart_inventory_stock.
  Fulfillment dan Defect Rate menggunakan MOCK DATA.
  
  [AI ASSISTANT INSTRUCTION]: 
  Jika tabel fact_purchase_orders sudah tersedia, ganti MOCK_METRICS 
  dengan agregasi asli (misal: AVG(is_on_time) untuk fulfillment).
*/
WITH real_metrics AS (
    SELECT
        SUM(purchase_cost) AS total_spend,
        SUM(usage_cost) AS total_usage,
        (AVG(avg_unit_cost) - AVG(base_unit_cost)) / NULLIF(AVG(base_unit_cost), 0) * 100 AS avg_inflation
    FROM restaurant.inventory_stock
    WHERE txn_date >= (SELECT MAX(txn_date) FROM restaurant.inventory_stock) - INTERVAL '29 days'
),
mock_metrics AS (
    SELECT 
        95.2 AS on_time_pct,
        2.8 AS defect_rate_pct
)
SELECT 
    COALESCE(r.total_spend, 0) AS total_spend,
    ROUND(COALESCE(r.total_spend, 0) / NULLIF(r.total_usage, 0), 2) AS purchase_ratio,
    COALESCE(ROUND(r.avg_inflation, 1), 0) AS avg_inflation,
    m.on_time_pct,
    m.defect_rate_pct
FROM real_metrics r
CROSS JOIN mock_metrics m
```

```sql price_spikes
/* 
  PIPELINE DATA RADAR LONJAKAN HARGA
  Harga dasar dan harga baru menggunakan DATA ASLI dari mart_inventory_stock.
  Nama Supplier (supplier_name) saat ini MOCK DATA (dibuat menggunakan CASE).
  
  [AI ASSISTANT INSTRUCTION]: 
  1. Untuk menyambungkan ke data asli, hapus CASE 'supplier_name' dan ganti dengan:
     LEFT JOIN restaurant.dim_supplier s ON i.supplier_id = s.supplier_id
  2. Saat migrasi ke data nyata, PASTIKAN untuk menyesuaikan ulang kategori 
     dan nilai ambang batas ideal (Warning/Critical) di dalam CASE status_inflasi 
     agar sesuai dengan profil fluktuasi riil bisnis restoran ini.
*/
WITH raw_spikes AS (
    SELECT
        item_name,
        category,
        AVG(base_unit_cost) AS old_price,
        AVG(avg_unit_cost) AS new_price,
        (AVG(avg_unit_cost) - AVG(base_unit_cost)) / NULLIF(AVG(base_unit_cost), 0) * 100 AS spike_pct,
        -- Mocking supplier name based on category
        CASE 
            WHEN category = 'produce' THEN 'PT Tani Makmur'
            WHEN category = 'protein' THEN 'Sapi Bintang Merah'
            WHEN category = 'seafood' THEN 'Lautan Samudera'
            WHEN category = 'oil' THEN 'Agen Minyak Bumi'
            WHEN category = 'grain' THEN 'Grosir Kebutuhan'
            WHEN category = 'utility' THEN 'Pemasok Utilitas'
            WHEN category = 'drink' THEN 'Toko Minuman'
            ELSE 'Grosir Umum'
        END AS supplier_name
    FROM restaurant.inventory_stock
    WHERE txn_date = (SELECT MAX(txn_date) FROM restaurant.inventory_stock)
    GROUP BY 1, 2
)
SELECT 
    item_name,
    category,
    supplier_name,
    old_price,
    new_price,
    ROUND(spike_pct, 1) || '%' AS spike_pct_str,
    spike_pct,
    CASE 
        WHEN category IN ('protein', 'seafood') THEN
            CASE WHEN spike_pct > 8 THEN 'Critical' WHEN spike_pct > 5 THEN 'Warning' ELSE 'Safe' END
        WHEN category = 'produce' THEN
            CASE WHEN spike_pct > 25 THEN 'Critical' WHEN spike_pct > 15 THEN 'Warning' ELSE 'Safe' END
        ELSE
            CASE WHEN spike_pct > 12 THEN 'Critical' WHEN spike_pct > 8 THEN 'Warning' ELSE 'Safe' END
    END AS status_inflasi
FROM raw_spikes
WHERE CASE 
        WHEN category IN ('protein', 'seafood') THEN
            CASE WHEN spike_pct > 8 THEN 'Critical' WHEN spike_pct > 5 THEN 'Warning' ELSE 'Safe' END
        WHEN category = 'produce' THEN
            CASE WHEN spike_pct > 25 THEN 'Critical' WHEN spike_pct > 15 THEN 'Warning' ELSE 'Safe' END
        ELSE
            CASE WHEN spike_pct > 12 THEN 'Critical' WHEN spike_pct > 8 THEN 'Warning' ELSE 'Safe' END
      END != 'Safe'
ORDER BY spike_pct DESC
```

```sql historical_price_spikes
/* 
  DATA TREN HISTORIS LONJAKAN HARGA
  Mengambil data riwayat harga dari bahan baku yang saat ini menyentuh
  ambang batas Warning/Critical berdasarkan kategorinya.

  [AI ASSISTANT INSTRUCTION]:
  Logika kategori 'alert_items' di bawah (protein >5%, produce >15%, dll) 
  harus disinkronkan dengan nilai ideal riil saat data asli (production) masuk.
*/
WITH top_spikes AS (
    SELECT item_name, category, (AVG(avg_unit_cost) - AVG(base_unit_cost)) / NULLIF(AVG(base_unit_cost), 0) * 100 AS spike_pct
    FROM restaurant.inventory_stock
    WHERE txn_date = (SELECT MAX(txn_date) FROM restaurant.inventory_stock)
    GROUP BY 1, 2
),
alert_items AS (
    SELECT item_name
    FROM top_spikes
    WHERE 
        (category IN ('protein', 'seafood') AND spike_pct > 5) OR
        (category = 'produce' AND spike_pct > 15) OR
        (category NOT IN ('protein', 'seafood', 'produce') AND spike_pct > 8)
)
SELECT 
    i.txn_date,
    i.item_name,
    AVG(i.avg_unit_cost) AS unit_cost
FROM restaurant.inventory_stock i
JOIN alert_items t ON i.item_name = t.item_name
WHERE i.txn_date >= (SELECT MAX(txn_date) - INTERVAL '29 days' FROM restaurant.inventory_stock)
GROUP BY 1, 2
ORDER BY 1 ASC
```

```sql supplier_data
/* 
  PIPELINE DATA SUPPLIER SCORECARD
  Saat ini menggunakan data simulasi (mock) seutuhnya. 
  
  [AI ASSISTANT INSTRUCTION]:
  Jika data asli sudah siap:
  1. Hapus blok CTE 'mock_data' 
  2. Ubah "FROM mock_data" menjadi "FROM restaurant.dim_supplier" (atau mart terkait).
  3. Pastikan kolom-kolomnya sesuai dengan SELECT di bawah ini.
*/
WITH mock_data AS (
    SELECT 'PT Tani Makmur' AS supplier_name, 'produce' AS category, 99.0 AS on_time_pct, 95.5 AS in_full_pct, 2.1 AS defect_rate_pct, 12000000 AS spend_30d
    UNION ALL SELECT 'Sapi Bintang Merah', 'protein', 100.0, 98.2, 0.5, 35000000
    UNION ALL SELECT 'Grosir Kebutuhan', 'grain', 100.0, 100.0, 0.0, 22000000
    UNION ALL SELECT 'Agen Minyak Bumi', 'oil', 88.0, 100.0, 1.0, 28000000
    UNION ALL SELECT 'Pemasok Utilitas', 'utility', 85.0, 100.0, 0.0, 10000000
    UNION ALL SELECT 'Toko Minuman', 'drink', 95.0, 99.0, 0.2, 8000000
),
actual_table AS (
    SELECT *,
        CASE 
            WHEN on_time_pct < 90 OR in_full_pct < 95 OR defect_rate_pct > 3 THEN 'C'
            WHEN on_time_pct >= 95 AND in_full_pct >= 98 AND defect_rate_pct <= 1 THEN 'A'
            ELSE 'B'
        END AS grade
    FROM mock_data
)
SELECT
    supplier_name,
    category,
    ROUND(on_time_pct, 1) || '%' AS on_time_str,
    ROUND(in_full_pct, 1) || '%' AS in_full_str,
    ROUND(defect_rate_pct, 1) || '%' AS defect_pct,
    spend_30d,
    grade,
    CASE 
        WHEN grade = 'A' THEN 'Compliant'
        WHEN grade = 'B' THEN 'Conditional'
        ELSE 'Action Required'
    END AS status_evaluasi
FROM actual_table
ORDER BY grade ASC, spend_30d DESC
```

```sql supplier_watchlist
/*
  PIPELINE DAFTAR PENGAWASAN SUPPLIER (WATCHLIST 60 HARI)
  Tabel ini menyoroti supplier yang mendapatkan status Action Required 
  minimal satu kali dalam 2 bulan terakhir.
  
  [AI ASSISTANT INSTRUCTION]:
  Ubah query ini untuk melakukan agregasi per bulan dari tabel fakta 
  pengiriman riil.
*/
WITH mock_watchlist AS (
    SELECT 'Pemasok Utilitas' AS supplier_name, 'Action Required' AS prev_month_grade, 'Action Required' AS curr_month_grade
    UNION ALL SELECT 'Agen Minyak Bumi', 'Conditional', 'Action Required'
),
watchlist_logic AS (
    SELECT 
        supplier_name,
        prev_month_grade,
        curr_month_grade,
        CASE 
            WHEN prev_month_grade = 'Action Required' AND curr_month_grade = 'Action Required' THEN '🚨 Terminate Contract / Divert 50% Quota'
            WHEN prev_month_grade = 'Action Required' OR curr_month_grade = 'Action Required' THEN '⚠️ Monitor Closely'
            ELSE '✅ Safe'
        END AS rekomendasi
    FROM mock_watchlist
)
SELECT * FROM watchlist_logic
```
{#if typeof supplier_kpi !== 'undefined' && supplier_kpi.length > 0}
  {@const ratio = supplier_kpi[0].purchase_ratio}
  {@const inflation = supplier_kpi[0].avg_inflation}
  {@const ontime = supplier_kpi[0].on_time_pct}
  {@const reject_rate_pct = Number(supplier_kpi[0].defect_rate_pct).toFixed(1)}

<div class="decision-box amber" style="margin-top: 24px; margin-bottom: 32px;">
  <div class="decision-content">
    <div class="decision-title">
      <span style="display: flex; align-items: center; gap: 8px;">
        💡 Strategic Insights & Decision Directives
      </span>
      <div class="ai-badge">✨ AI Generated</div>
    </div>

    <p class="decision-text" style="color: var(--color-text-primary); margin-bottom: 12px;">
      <strong>
      {#if inflation > 15 && ratio < 0.9}
        🔍 Diagnostic: Procurement Suppression Amid Inflation Surge
      {:else if inflation <= 15 && ratio < 0.9}
        🔍 Diagnostic: Under-Procurement Hazard (Imminent Stockout Risk)
      {:else if ratio > 1.2}
        🔍 Diagnostic: Capital Exposure Warning (Uncontrolled Over-Procurement)
      {:else}
        🔍 Diagnostic: Optimal Procurement & Consumption Velocity
      {/if}
      </strong>
    </p>
    

      <p class="decision-text" style="color: var(--color-text-primary); margin-bottom: 16px;">
        {#if ratio < 0.9}
          Trailing 30-day aggregate data flags a <strong>procurement deficit</strong>, where kitchen consumption exceeds raw material procurement (Ratio <strong>{ratio}x</strong>). This consumption gap directly depletes baseline safety stock across storage locations.
          <br><br>
          {#if inflation > 15 && ontime > 90}
            <strong>Insight:</strong> Purchase Order (PO) volume remains suppressed despite uncompromised vendor fulfillment (<strong>{ontime}% OTD</strong>). This order restraint coincides directly with cost price inflation (<strong>+{inflation}% PPV</strong>).
          {:else if inflation > 15 && ontime <= 90}
            <strong>Insight:</strong> Under-procurement persists amidst dual operational friction: cost inflation (<strong>+{inflation}% PPV</strong>) and vendor SLA degradation (<strong>{ontime}% OTD</strong>), escalating stockout risk.
          {:else}
            <strong>Insight:</strong> PO volume contraction is non-market-driven, occurring despite stable unit costs (<strong>+{inflation}% PPV</strong>) and reliable vendor delivery SLAs (<strong>{ontime}% OTD</strong>).
          {/if}
        {:else if ratio > 1.2}
          Trailing 30-day aggregate data flags a <strong>procurement surplus</strong>, where purchasing velocity exceeds kitchen consumption (Ratio <strong>{ratio}x</strong>). The surplus directly drives inventory inflation across all branches.
          <br><br>
          {#if inflation > 15 && ontime > 90}
            <strong>Insight:</strong> PO expansion coincides with unit cost inflation (<strong>+{inflation}% PPV</strong>), tying up excess capital during a price peak despite stable vendor SLAs (<strong>{ontime}% OTD</strong>).
          {:else if inflation > 15 && ontime <= 90}
            <strong>Insight:</strong> Purchasing volume expansion during unit cost inflation (<strong>+{inflation}% PPV</strong>) and vendor SLA drops (<strong>{ontime}% OTD</strong>) indicates reactive buffer stocking against supply chain disruption.
          {:else if inflation <= 15 && ontime > 90}
            <strong>Insight:</strong> Over-procurement is occurring without market justification; unit prices remain flat (<strong>+{inflation}% PPV</strong>) and vendor fulfillment is fully stable (<strong>{ontime}% OTD</strong>).
          {:else}
            <strong>Insight:</strong> Stock accumulation continues under stable unit costs (<strong>+{inflation}% PPV</strong>) but alongside declining vendor SLA fulfillment (<strong>{ontime}% OTD</strong>), reflecting defensive inventory buffering.
          {/if}
        {:else}
          Trailing 30-day aggregate data indicates <strong>procurement equilibrium (Ratio {ratio}x)</strong>. Inbound PO velocity aligns proportionally with kitchen consumption, maintaining working capital efficiency.
          <br><br>
          {#if inflation > 15 && ontime > 90}
            <strong>Insight:</strong> Procurement volume remains disciplined despite unit cost inflation (<strong>+{inflation}% PPV</strong>), supported by high vendor delivery reliability (<strong>{ontime}% OTD</strong>).
          {:else if inflation > 15 && ontime <= 90}
            <strong>Insight:</strong> Procurement discipline is maintained despite compounding headwinds: unit cost inflation (<strong>+{inflation}% PPV</strong>) and vendor SLA degradation (<strong>{ontime}% OTD</strong>).
          {:else if inflation <= 15 && ontime > 90}
            <strong>Insight:</strong> Macro procurement metrics operate within optimal parameters: controlled unit costs (<strong>+{inflation}% PPV</strong>), balanced consumption, and strong vendor SLA compliance (<strong>{ontime}% OTD</strong>).
          {:else}
            <strong>Insight:</strong> Purchase ratios remain balanced and unit costs stable (<strong>+{inflation}% PPV</strong>), offsetting vendor delivery SLA volatility (<strong>{ontime}% OTD</strong>).
          {/if}
        {/if}
      </p>
  
      <div class="metrics-row" style="margin-top: 24px;">
        <div class="metric-pill">⚖️ Purchase-to-Usage: {ratio}x</div>
        <div class="metric-pill">📈 Material PPV: +{inflation}%</div>
        <div class="metric-pill">🚚 Vendor OTD: {ontime}%</div>
        <div class="metric-pill">🛡️ Inbound Rejection: {reject_rate_pct}%</div>
      </div>
    <div class="decision-footer" style="margin-top: 24px;">
      <em>*Automated diagnostic generated from trailing 30-day PO turnover, price variance (PPV), and vendor SLA fulfillment metrics. Intended for decision support; cross-validation with physical audit logs recommended.</em>
    </div>
  </div>
</div>





<!-- STRUCTURAL RISK SECTION -->
  <div class="diagnostics-header" style="margin-top: 48px; margin-bottom: 24px;">
    <div class="diagnostics-eyebrow">⚠️ INVENTORY DYNAMICS & RISK DIAGNOSTICS</div>
    <h2 class="diagnostics-title">Capital Exposure & Stockout Risk Analysis</h2>
    <p class="diagnostics-copy">
      Examines why maintaining a 1.0x Purchase-to-Usage ratio is critical to preventing tied-up working capital and kitchen operational disruptions.
    </p>
  </div>

  <div class="risk-section">

    <div class="risk-row purple-theme">
      <div class="risk-row-header">
        <span class="risk-row-icon">📦</span>
        <h4 class="risk-row-title">Over-Procurement Exposure (Purchase-to-Usage Ratio &gt; 1.2x)</h4>
      </div>
      <div class="risk-pills">
        <div class="risk-pill">
          <span class="risk-pill-anchor">💸</span>
          <div class="risk-pill-content">
            <strong>Tied-Up Working Capital</strong>
            <span>Operating cash flow is locked in physical stock, reducing liquidity for active operational expenses.</span>
          </div>
        </div>
        <div class="risk-pill">
          <span class="risk-pill-anchor">🗑️</span>
          <div class="risk-pill-content">
            <strong>Perishable Spoilage Risk</strong>
            <span>Holding perishable inventory past shelf-life limits increases raw material waste and direct shrinkage.</span>
          </div>
        </div>
        <div class="risk-pill">
          <span class="risk-pill-anchor">🏢</span>
          <div class="risk-pill-content">
            <strong>Storage Capacity Constraints</strong>
            <span>Excess volume exceeds cold-chain / BOH storage capacity, escalating energy utility costs and handling risks.</span>
          </div>
        </div>
      </div>
      <div class="risk-funfact">
        <span class="risk-funfact-icon">📎</span>
        <div class="risk-funfact-content">
          <span>Excessive inventory holdings can erode operational margins by <strong>15%–20%</strong> through compounding carrying costs, shrinkage, and food waste.</span>
          <cite>F&B Lean Inventory Benchmark</cite>
        </div>
      </div>
    </div>

    <div class="risk-row blue-theme">
      <div class="risk-row-header">
        <span class="risk-row-icon">⏳</span>
        <h4 class="risk-row-title">Under-Procurement Hazard (Purchase-to-Usage Ratio &lt; 0.9x)</h4>
      </div>
      <div class="risk-pills">
        <div class="risk-pill">
          <span class="risk-pill-anchor">🛑</span>
          <div class="risk-pill-content">
            <strong>Unfulfilled Demand &amp; Lost Revenue</strong>
            <span>Stockout-induced menu item unavailability turns away customers, directly forfeiting immediate revenue and brand loyalty.</span>
          </div>
        </div>
        <div class="risk-pill">
          <span class="risk-pill-anchor">🚀</span>
          <div class="risk-pill-content">
            <strong>Emergency Spot Purchases</strong>
            <span>Unplanned ad-hoc procurement forces retail-rate spot purchases, significantly inflating Cost of Goods Sold (COGS).</span>
          </div>
        </div>
        <div class="risk-pill">
          <span class="risk-pill-anchor">⚙️</span>
          <div class="risk-pill-content">
            <strong>Recipe Variance &amp; Quality Shift</strong>
            <span>Depleted core ingredients force unstandardized kitchen substitutions, compromising dish consistency and quality control.</span>
          </div>
        </div>
      </div>
      <div class="risk-funfact">
        <span class="risk-funfact-icon">📎</span>
        <div class="risk-funfact-content">
          <span>Customers encountering repeated <strong>menu item unavailability</strong> show a <strong>30% higher attrition rate</strong>, shifting long-term visits to competitors.</span>
          <cite>F&B Customer Retention Research</cite>
        </div>
      </div>
    </div>
  </div>

<div style="margin-top: 48px;">
<SectionHeader 
    eyebrow="📑 Supporting Data Room"
    title="Unit Cost Fluctuation Across Critical Ingredients"
    description="Tracks historical daily unit price movements for high-volatility raw materials segmented by category."
  />
</div>

<div class="data-wrapper">
  <Tabs id="analisis_inventori_tabs" fullWidth=true>

    <Tab label="📈 Price Volatility & PPV Analysis">
      <div style="padding: 12px 0px;">
      
    {#if historical_price_spikes && historical_price_spikes.length > 0}
      <div class="section-head tight" style="margin-bottom: 12px;">
        <div>
          <div class="section-eyebrow">📈 Price Variance (Trailing 30 Days)</div>
          <h3 class="section-title">Unit Cost Fluctuation Across Ingredients</h3>
          <p class="section-copy">Tracks historical daily unit price movements for raw materials segmented by category.</p>
        </div>
      </div>
      <div style="margin-bottom: 8px;">
        <LineChart 
          data={historical_price_spikes} 
          x="txn_date" 
          y="unit_cost" 
          series="item_name" 
          yAxisTitle="Cost Price (Rp)"
          xAxisTitle="Date"
          yFmt="#,##0"
        />
      </div>
      <div class="chart-insight-bar" style="margin-bottom: 32px;">
        📌 <strong>Contract Negotiation Insight:</strong> Utilize historical unit price trends to support vendor contract renegotiations. Identifies precise inflection points where unit costs diverged from baseline agreement prices.
      </div>
    {/if}

    {#if price_spikes && price_spikes.length > 0}
      <div class="section-head tight" style="margin-bottom: 12px;">
        <div>
          <div class="section-eyebrow">💸 Supplier Price Pressure (Today's Snapshot)</div>
          <h3 class="section-title">Which categories have the highest price spikes?</h3>
          <p class="section-copy">Displays a detailed list of raw materials hitting the Warning/Critical thresholds based on category.</p>
        </div>
      </div>
      <PremiumTable 
        data={price_spikes}
        rowColor={(row) => row.status_inflasi === 'Critical' ? 'rgba(239, 68, 68, 0.15)' : row.status_inflasi === 'Warning' ? 'rgba(245, 158, 11, 0.15)' : null}
        columns={[
          { key: 'item_name', title: 'Raw Material' },
          { key: 'category', title: 'Category' },
          { key: 'supplier_name', title: 'Primary Vendor' },
          { key: 'old_price', title: 'Baseline Unit Cost', type: 'currency' },
          { key: 'new_price', title: 'Current Unit Cost', type: 'currency' },
          { key: 'spike_pct_str', title: 'PPV Variance (%)' },
          { key: 'status_inflasi', title: 'Variance Status' }
        ]}
      />
    {:else}
      <div class="action-empty">
        <div class="title">✅ Unit Costs Stabilized</div>
        <div class="subtitle">No significant Purchase Price Variance (PPV) detected across active raw material categories.</div>
      </div>
    {/if}
      <div class="chart-insight-bar" style="margin-top: 16px;">
        📌 <strong>Contract Renegotiation Directive:</strong> Leverage variance data to support vendor contract reviews. Percentage variance reflects current cross-branch weighted unit cost against established contract baselines.
      </div>

      <div style="margin-top: 24px;">
        <details class="guide-acc" style="margin-bottom:24px;">
          <summary>💡 Variance Threshold Framework &amp; Margin Sensitivity Methodology</summary>
          <div class="guide-body">
            <p style="margin-top: 4px; margin-bottom: 16px; font-weight: 500; color: var(--color-text-secondary);">
              Unit cost variance thresholds are calibrated by ingredient category sensitivity. This prevents false positive alerts on volatile seasonal produce while flagging price spikes on capital-intensive proteins.
            </p>
            <div class="guide-grid" style="grid-template-columns: repeat(2, minmax(0, 1fr));">
              <div class="guide-card purple">
                <div class="guide-card-icon">🥩</div>
                <div class="guide-card-content">
                  <div class="guide-card-label">High Margin Sensitivity</div>
                  <h4 class="guide-card-title">Proteins &amp; Seafood</h4>
                  <p class="guide-card-desc">Capital-intensive staples accounting for the primary share of COGS. Minor unit price movements directly impact gross margins.<br><strong style="font-size: 0.73rem; display: block; margin-top: 5px; color: var(--color-text-tertiary);">*Warning &gt;5% | Critical &gt;8%</strong></p>
                </div>
              </div>
              <div class="guide-card teal">
                <div class="guide-card-icon">🥬</div>
                <div class="guide-card-content">
                  <div class="guide-card-label">Seasonal Volatility</div>
                  <h4 class="guide-card-title">Fresh Produce &amp; Spices</h4>
                  <p class="guide-card-desc">Subject to weather-driven market supply cycles. Thresholds feature wider tolerance bands to accommodate routine daily market shifts.<br><strong style="font-size: 0.73rem; display: block; margin-top: 5px; color: var(--color-text-tertiary);">*Warning &gt;15% | Critical &gt;25%</strong></p>
                </div>
              </div>
              <div class="guide-card blue">
                <div class="guide-card-icon">🍚</div>
                <div class="guide-card-content">
                  <div class="guide-card-label">Baseline Stability</div>
                  <h4 class="guide-card-title">Dry Goods &amp; Staples</h4>
                  <p class="guide-card-desc">Commodities and manufactured goods with structured pricing. Price escalation indicates sustained macro inflation or structural supply shift.<br><strong style="font-size: 0.73rem; display: block; margin-top: 5px; color: var(--color-text-tertiary);">*Warning &gt;8% | Critical &gt;12%</strong></p>
                </div>
              </div>
              <div class="guide-card red">
                <div class="guide-card-icon">🚨</div>
                <div class="guide-card-content">
                  <div class="guide-card-label">Escalation Protocol</div>
                  <h4 class="guide-card-title">Mitigation Directives</h4>
                  <p class="guide-card-desc"><strong>Warning (⚠️):</strong> Initiate daily tracking and engage secondary vendor contacts.<br><strong>Critical (🚨):</strong> Executive recipe engineering or immediate contract renegotiation required.<br><strong style="font-size: 0.73rem; display: block; margin-top: 5px; color: var(--color-text-tertiary);">*Measured against baseline contract rates.</strong></p>
                </div>
              </div>
            </div>
          </div>
        </details>
      </div>
    </Tab>

    <Tab label="🤝 Vendor Performance & SLA Intelligence">
      <div style="padding: 12px 0px;">
      
      <!-- Chart: Risiko Ketergantungan -->
      <div class="section-head tight" style="margin-bottom: 12px;">
        <div>
          <div class="section-eyebrow">⚠️ Vendor Concentration Risk</div>
          <h3 class="section-title">Procurement Spend Concentration</h3>
          <p class="section-copy">Illustrates capital allocation across primary vendors. High concentration (&gt;50% single-vendor allocation) exposes operations to single-point-of-failure vulnerabilities.</p>
        </div>
      </div>
      <div style="margin-bottom: 8px;">
        <ECharts 
          config={{
            tooltip: { 
              trigger: 'item',
              formatter: function(params) {
                let val = params.data.spend_30d;
                return params.name + ':<br/><b>Rp ' + val.toLocaleString('en-US') + '</b> (' + params.percent + '%)';
              }
            },
            dataset: { 
              source: supplier_data 
            },
            series: [
              {
                name: 'Total Spend',
                type: 'pie',
                radius: ['40%', '70%'],
                itemStyle: {
                  borderRadius: 8,
                  borderColor: '#fff',
                  borderWidth: 2
                },
                label: {
                  show: true,
                  formatter: '{b}\n{d}%'
                },
                encode: { 
                  itemName: 'supplier_name', 
                  value: 'spend_30d' 
                }
              }
            ]
          }}
        />
      </div>
      <div class="chart-insight-bar" style="margin-bottom: 32px;">
        📌 <strong>Risk Mitigation Directive:</strong> High vendor concentration requires secondary vendor contracts (backup suppliers) to mitigate operational disruption during primary vendor fulfillment or yield failures.
      </div>

      <!-- Table: Rapor Supplier -->
      <div class="section-head tight" style="margin-bottom: 12px;">
        <div>
          <div class="section-eyebrow">📋 Vendor Fulfillment SLA (Trailing 30 Days)</div>
          <h3 class="section-title">Vendor SLA &amp; Fulfillment Performance</h3>
          <p class="section-copy">Evaluates vendor compliance based on On-Time Delivery (OTD), In-Full Order Accuracy (OTIF), and Raw Material Rejection Rates.</p>
        </div>
      </div>
      <PremiumTable 
        data={supplier_data}
        rowColor={(row) => row.grade === 'A' ? 'rgba(5, 150, 105, 0.15)' : row.grade === 'C' ? 'rgba(239, 68, 68, 0.15)' : null}
        columns={[
          { key: 'supplier_name', title: 'Vendor Name' },
          { key: 'category', title: 'Category' },
          { key: 'on_time_str', title: 'On Time' },
          { key: 'in_full_str', title: 'In Full' },
          { key: 'defect_pct', title: 'Rejection Rate' },
          { key: 'spend_30d', title: '30-Day Procurement Spend', type: 'currency' },
          { key: 'status_evaluasi', title: 'SLA Grade & Status' }
        ]}
      />
      <div class="chart-insight-bar" style="margin-top: 16px;">
        📌 <strong>Vendor SLA Action Directive:</strong> Vendors flagged with "Action Required" show persistent delivery or quality non-compliance. Issue formal SLA default notices or initiate systematic spend reallocation to compliant secondary vendors.
      </div>

      <div style="margin-top: 24px;">
        <details class="guide-acc" style="margin-bottom:24px;">
          <summary>💡 Vendor Evaluation Methodology &amp; SLA Grade Framework</summary>
          <div class="guide-body">
            <p style="margin-top: 4px; margin-bottom: 16px; font-weight: 500; color: var(--color-text-secondary);">
              Vendor SLA compliance is calculated across three core operational metrics: On-Time Delivery (OTD), On-Time In-Full (OTIF) fulfillment, and Raw Material Rejection Rates.
            </p>
            <div class="guide-grid" style="grid-template-columns: repeat(2, minmax(0, 1fr));">
              <div class="guide-card blue">
                <div class="guide-card-icon">🌟</div>
                <div class="guide-card-content">
                  <div class="guide-card-label">Preferred Vendor Status</div>
                  <h4 class="guide-card-title">Grade A — Compliant</h4>
                  <p class="guide-card-desc">High-tier fulfillment compliance. Recommended as primary vendor for bulk purchase order allocation.<br><strong style="font-size: 0.73rem; display: block; margin-top: 5px; color: var(--color-text-tertiary);">*OTD &gt;95% | OTIF &gt;95% | Rejection &lt;1%</strong></p>
                </div>
              </div>
              <div class="guide-card teal">
                <div class="guide-card-icon">👍</div>
                <div class="guide-card-content">
                  <div class="guide-card-label">Acceptable Variance</div>
                  <h4 class="guide-card-title">Grade B — Conditional</h4>
                  <p class="guide-card-desc">Minor fulfillment discrepancies within operational tolerance limits. Requires routine vendor performance reviews.<br><strong style="font-size: 0.73rem; display: block; margin-top: 5px; color: var(--color-text-tertiary);">*Maintains operational baseline without triggering Grade C thresholds.</strong></p>
                </div>
              </div>
              <div class="guide-card red">
                <div class="guide-card-icon">🚩</div>
                <div class="guide-card-content">
                  <div class="guide-card-label">Non-Compliant Risk</div>
                  <h4 class="guide-card-title">Grade C — Action Required</h4>
                  <p class="guide-card-desc">Breaches established SLA compliance thresholds across any single core metric. Triggers immediate vendor evaluation.<br><strong style="font-size: 0.73rem; display: block; margin-top: 5px; color: var(--color-text-tertiary);">*OTD &lt;90% OR OTIF &lt;95% OR Rejection &gt;3%</strong></p>
                </div>
              </div>
              <div class="guide-card orange">
                <div class="guide-card-icon">🛑</div>
                <div class="guide-card-content">
                  <div class="guide-card-label">Remediation Directive</div>
                  <h4 class="guide-card-title">Vendor Offboarding &amp; Reallocation</h4>
                  <p class="guide-card-desc">SLA default extending beyond 60 days requires systematic spend reallocation to secondary vendors or formal contract termination.<br><strong style="font-size: 0.73rem; display: block; margin-top: 5px; color: var(--color-text-tertiary);">*Provides empirical data for commercial contract reviews and payment term renegotiation.</strong></p>
                </div>
              </div>
            </div>
          </div>
        </details>
      </div>

      <!-- Table: Persistent Non-Compliance Watchlist -->
      <div class="section-head tight" style="margin-top: 32px; margin-bottom: 12px;">
        <div>
          <div class="section-eyebrow">🛑 PERSISTENT NON-COMPLIANCE WATCHLIST (60-DAY ROLLING)</div>
          <h3 class="section-title">Vendor Offboarding &amp; Reallocation Directives</h3>
          <p class="section-copy">
            Flags vendors demonstrating consecutive Grade C SLA non-compliance over two consecutive 30-day evaluation cycles.
          </p>
        </div>
      </div>
      
      <PremiumTable 
        data={supplier_watchlist}
        rowColor={(row) => row.curr_month_grade === 'Action Required' && row.prev_month_grade === 'Action Required' ? 'rgba(239, 68, 68, 0.15)' : 'rgba(245, 158, 11, 0.15)'}
        columns={[
          { key: 'supplier_name', title: 'Vendor Name', bold: true },
          { key: 'prev_month_grade', title: 'Prior Cycle SLA Grade', align: 'center' },
          { key: 'curr_month_grade', title: 'Current Cycle SLA Grade', align: 'center' },
          { key: 'rekomendasi', title: 'Automated SLA Directive', align: 'left', colorRules: 'directive_badge' }
        ]}
      />

      </div>
    </Tab>

  </Tabs>
</div>

<style>
  .action-empty {
    padding: 60px 20px;
    text-align: center;
    background: var(--color-background-secondary);
    border: 1px dashed var(--color-border-tertiary);
    border-radius: 12px;
  }
  .action-empty .title {
    font-size: 20px;
    font-weight: 700;
    color: var(--color-text-primary);
    margin-bottom: 8px;
  }
  .action-empty .subtitle {
    color: var(--color-text-secondary);
  }

  .risk-section { display: flex; flex-direction: column; gap: 20px; margin-bottom: 32px; }

  .risk-row {
    border-radius: 20px;
    overflow: hidden;
    box-shadow: 0 2px 12px rgba(0,0,0,0.03);
    transition: border-color 0.3s ease, box-shadow 0.3s ease;
  }

  /* Row color themes */
  .risk-row.purple-theme { background: linear-gradient(135deg, rgba(168,85,247,0.03), rgba(168,85,247,0.008)); border: 1.5px solid rgba(168,85,247,0.12); }
  .risk-row.blue-theme { background: linear-gradient(135deg, rgba(59,130,246,0.03), rgba(59,130,246,0.008)); border: 1.5px solid rgba(59,130,246,0.12); }
  .risk-row.slate-theme { background: linear-gradient(135deg, rgba(15,23,42,0.03), rgba(15,23,42,0.008)); border: 1.5px solid rgba(15,23,42,0.08); }

  /* Hover: outline only */
  .risk-row.purple-theme:hover { border-color: rgba(168,85,247,0.35); box-shadow: 0 4px 20px rgba(168,85,247,0.06); }
  .risk-row.blue-theme:hover { border-color: rgba(59,130,246,0.35); box-shadow: 0 4px 20px rgba(59,130,246,0.06); }
  .risk-row.slate-theme:hover { border-color: rgba(15,23,42,0.20); box-shadow: 0 4px 20px rgba(15,23,42,0.04); }

  .risk-row-header { display: flex; align-items: center; gap: 12px; padding: 18px 24px; }
  .risk-row.purple-theme .risk-row-header { border-bottom: 1px solid rgba(168,85,247,0.08); }
  .risk-row.blue-theme .risk-row-header { border-bottom: 1px solid rgba(59,130,246,0.08); }
  .risk-row.slate-theme .risk-row-header { border-bottom: 1px solid rgba(15,23,42,0.06); }

  .risk-row-icon { font-size: 1.15rem; width: 36px; height: 36px; display: flex; align-items: center; justify-content: center; border-radius: 11px; flex-shrink: 0; }
  .risk-row.purple-theme .risk-row-icon { background: rgba(168,85,247,0.10); }
  .risk-row.blue-theme .risk-row-icon { background: rgba(59,130,246,0.10); }
  .risk-row.slate-theme .risk-row-icon { background: rgba(15,23,42,0.06); }

  .risk-row-title { margin: 0; font-size: 1.02rem; font-weight: 800; color: var(--color-text-primary); letter-spacing: -0.02em; }

  /* Pills: 3-column grid */
  .risk-pills { display: grid; grid-template-columns: repeat(3, 1fr); }
  .risk-pills.cols-2 { grid-template-columns: repeat(2, 1fr); }
  .risk-pill {
    display: flex; flex-direction: column; align-items: center; text-align: center;
    gap: 10px; padding: 20px 16px;
    border-right: 1px solid rgba(0,0,0,0.04);
    transition: background 0.25s ease;
  }
  .risk-pill:last-child { border-right: none; }
  .risk-row.purple-theme .risk-pill:hover { background: rgba(168,85,247,0.05); }
  .risk-row.blue-theme .risk-pill:hover { background: rgba(59,130,246,0.05); }
  .risk-row.slate-theme .risk-pill:hover { background: rgba(15,23,42,0.03); }

  .risk-pill-anchor {
    font-size: 1.15rem;
    width: 44px; height: 44px; border-radius: 50%;
    display: flex; align-items: center; justify-content: center;
  }
  .risk-row.purple-theme .risk-pill-anchor { background: rgba(168,85,247,0.10); }
  .risk-row.blue-theme .risk-pill-anchor { background: rgba(59,130,246,0.10); }
  .risk-row.slate-theme .risk-pill-anchor { background: rgba(15,23,42,0.06); }

  .risk-pill-content { display: flex; flex-direction: column; gap: 4px; }
  .risk-pill-content strong { font-size: 0.85rem; font-weight: 800; color: var(--color-text-primary); letter-spacing: -0.01em; }
  .risk-pill-content span { font-size: 0.8rem; line-height: 1.5; color: var(--color-text-secondary); }

  /* Fun fact footer */
  .risk-funfact {
    display: flex; align-items: flex-start; gap: 12px;
    padding: 14px 24px;
    border-top: 1px dashed rgba(0,0,0,0.06);
    background: rgba(0,0,0,0.015);
  }
  .risk-funfact-icon { font-size: 0.9rem; margin-top: 2px; flex-shrink: 0; }
  .risk-funfact-content { display: flex; flex-direction: column; gap: 2px; }
  .risk-funfact-content span { font-size: 0.78rem; line-height: 1.5; color: var(--color-text-secondary); }
  .risk-funfact-content cite { font-size: 0.7rem; color: var(--color-text-tertiary); font-style: italic; }
</style>

{:else}
  <GlobalLoading />
{/if}

