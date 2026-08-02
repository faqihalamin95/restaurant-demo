---
sidebar: hide
hide_toc: true
title: Direktori Member
---
<MemberTabs activeTab="direktori" />

<script>
  // Tidak perlu import manual jika menggunakan komponen native Evidence
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
      ELSE CAST(avg_visit_interval_days AS VARCHAR) || ' hari' 
    END AS ritme_kunjungan,
    CAST(recency_days AS VARCHAR) || ' hari lalu' AS last_order_label,
    CASE 
      WHEN tier = 'Gold' OR (tier IN ('Silver', 'Bronze') AND total_spend > (SELECT p75 FROM spend_p75)) THEN
        CASE 
          WHEN delay_days <= 7 OR delay_days IS NULL THEN 'Aktif'
          WHEN delay_days > 7 AND delay_days <= 14 THEN 'Waspada'
          ELSE 'Kritis'
        END
      ELSE
        CASE 
          WHEN delay_days <= 7 OR delay_days IS NULL THEN 'Aktif'
          ELSE 'Pasif'
        END
    END as status,
    CASE 
      WHEN tier = 'Gold' OR (tier IN ('Silver', 'Bronze') AND total_spend > (SELECT p75 FROM spend_p75)) THEN
        CASE 
          WHEN delay_days <= 7 OR delay_days IS NULL THEN '🟢 Aktif'
          WHEN delay_days > 7 AND delay_days <= 14 THEN '🟡 Waspada'
          ELSE '🔴 Kritis'
        END
      ELSE
        CASE 
          WHEN delay_days <= 7 OR delay_days IS NULL THEN '🟢 Aktif'
          ELSE '⚪ Pasif'
        END
    END as status_label,
    CASE
      WHEN tier = 'Gold' OR (tier IN ('Silver', 'Bronze') AND total_spend > (SELECT p75 FROM spend_p75)) THEN
        CASE 
          WHEN delay_days <= 7 OR delay_days IS NULL THEN '✨ Maintain'
          WHEN delay_days > 7 AND delay_days <= 14 THEN '📲 Kirim Promo'
          ELSE '📞 Follow Up'
        END
      ELSE
        CASE 
          WHEN delay_days <= 7 OR delay_days IS NULL THEN '✨ Maintain'
          ELSE '💤 Biarkan'
        END
    END as action_label
  FROM base
)
SELECT * FROM final_base
WHERE (tier = '${inputs.tier_filter?.value || inputs.tier_filter || 'Semua'}' OR '${inputs.tier_filter?.value || inputs.tier_filter || 'Semua'}' = 'Semua')
  AND (status = '${inputs.status_filter?.value || inputs.status_filter || 'Semua'}' OR '${inputs.status_filter?.value || inputs.status_filter || 'Semua'}' = 'Semua')
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
  <Dropdown name="tier_filter" defaultValue="Semua">
    <DropdownOption value="Semua" valueLabel="Semua Tier" />
    <DropdownOption value="Gold" />
    <DropdownOption value="Silver" />
    <DropdownOption value="Bronze" />
  </Dropdown>
  <Dropdown name="status_filter" defaultValue="Semua">
    <DropdownOption value="Semua" valueLabel="Semua Status" />
    <DropdownOption value="Aktif" />
    <DropdownOption value="Waspada" />
    <DropdownOption value="Kritis" />
    <DropdownOption value="Pasif" />
  </Dropdown>
</div>

{#if all_members && all_members.length > 0}
<div class="directory-container">
  <div class="diagnostics-header" style="margin-bottom: 24px; margin-top: 24px;">
    <div class="diagnostics-eyebrow">🗂️ EKSPLORASI DATA</div>
    <h2 class="diagnostics-title">Database Seluruh Member</h2>
    <p class="diagnostics-copy">Gunakan fitur penyaringan cerdas di bawah ini untuk mengkurasi data spesifik dan menganalisis segmentasi member Anda.</p>
  </div>

  <!-- Smart Filters -->
  <div class="filter-panel">
    <div class="filter-group">
      <div class="filter-label">Filter Tier Member:</div>
      <Dropdown name="tier_filter" defaultValue="Semua">
        <DropdownOption value="Semua" valueLabel="Semua Tier" />
        <DropdownOption value="Gold" />
        <DropdownOption value="Silver" />
        <DropdownOption value="Bronze" />
      </Dropdown>
    </div>
    
    <div class="filter-group">
      <div class="filter-label">Filter Status:</div>
      <Dropdown name="status_filter" defaultValue="Semua">
        <DropdownOption value="Semua" valueLabel="Semua Status" />
        <DropdownOption value="Aktif" />
        <DropdownOption value="Waspada" />
        <DropdownOption value="Kritis" />
        <DropdownOption value="Pasif" />
      </Dropdown>
    </div>
  </div>

  <!-- Mini Charts / Segmentations -->
  <div class="chart-card" style="margin-top: 24px;">
    <h3 class="chart-title">Analisis Demografi & Perilaku Member</h3>
    
    <div class="charts-inner-grid">
      <!-- Chart 1: Tier Composition -->
      <div class="chart-section">
        <h4 class="chart-subtitle">Komposisi Tier</h4>
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
        <h4 class="chart-subtitle">Pemetaan LTV vs Absen (Hari)</h4>
        <ECharts height="300px" config={{
            tooltip: { formatter: '{b}' },
            grid: { left: '5%', right: '8%', top: '10%', bottom: '15%', containLabel: true },
            xAxis: { 
                name: 'Total Belanja', 
                nameLocation: 'middle',
                nameGap: 30,
                type: 'value', 
                splitLine: { lineStyle: { type: 'dashed', color: '#e2e8f0' } },
                axisLabel: {
                    formatter: function (value) {
                        if (value >= 1000000) return (value / 1000000) + ' Jt';
                        if (value >= 1000) return (value / 1000) + ' Rb';
                        return value;
                    }
                }
            },
            yAxis: { 
                name: 'Absen (Hari)', 
                type: 'value', 
                splitLine: { lineStyle: { type: 'dashed', color: '#e2e8f0' } } 
            },
            series: [{
                type: 'scatter',
                symbolSize: 12,
                itemStyle: {
                    color: function(params) {
                        let status = params.value[2];
                        if (status === 'Aktif') return '#22c55e';
                        if (status === 'Waspada') return '#eab308';
                        if (status === 'Kritis') return '#ef4444';
                        return '#94a3b8'; // gray for Pasif
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

  <!-- Panduan Parameter Status -->
  <details class="guide-acc" style="margin-top: 32px; margin-bottom: 24px;">
    <summary>💡 Panduan Parameter Status & Tindakan</summary>
    <div class="guide-body">
      <p style="margin-top: 4px; margin-bottom: 16px; font-weight: 500; color: var(--color-text-secondary);">
        Berikut adalah logika sistem dalam mengklasifikasikan status pada tabel direktori. 
      </p>
      
      <div style="margin-bottom: 24px; padding: 14px 18px; border-radius: 12px; background: linear-gradient(135deg, rgba(99,102,241,0.06), rgba(139,92,246,0.02)); border: 1px solid rgba(99,102,241,0.25); font-size: 0.9rem; line-height: 1.6; color: var(--color-text-secondary);">
        <strong style="color: var(--color-text-primary); display: flex; align-items: center; gap: 6px; margin-bottom: 6px; font-size: 0.95rem;">
          <span>🧠</span> Personalisasi AI Dinamis
        </strong>
        Angka "Keterlambatan" (Telat) ini bersifat <strong>dinamis dan unik untuk setiap pelanggan</strong>. Sistem cerdas kami tidak menggunakan standar baku, melainkan menghitung selisih antara hari sejak kunjungan terakhir member dengan <i>rata-rata siklus kunjungan normal mereka sendiri</i>. <br/>
        <span style="display: inline-block; margin-top: 6px; font-size: 0.85rem; padding: 4px 8px; background: rgba(0,0,0,0.04); border-radius: 6px;">Contoh: Jika Si A biasa datang tiap 3 hari dan hari ini hari ke-10, maka AI mencatat ia telat 7 hari.</span>
      </div>
      <div class="guide-grid" style="grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 12px;">
        <div class="guide-card teal">
          <div class="guide-card-icon">🟢</div>
          <div class="guide-card-content">
            <div class="guide-card-label">Aktif (Aman)</div>
            <h4 class="guide-card-title">Telat ≤ 7 Hari</h4>
            <p class="guide-card-desc">Member masih datang sesuai ritme personalnya. Tidak perlu intervensi.</p>
          </div>
        </div>
        <div class="guide-card orange">
          <div class="guide-card-icon">🟡</div>
          <div class="guide-card-content">
            <div class="guide-card-label">Waspada (Tinggi)</div>
            <h4 class="guide-card-title">Telat 8-14 Hari</h4>
            <p class="guide-card-desc">Member VIP (Gold/Top Silver) yang mulai menghilang. Rekomendasi: promo ringan via WA.</p>
          </div>
        </div>
        <div class="guide-card red">
          <div class="guide-card-icon">🔴</div>
          <div class="guide-card-content">
            <div class="guide-card-label">Kritis (Bahaya)</div>
            <h4 class="guide-card-title">Telat > 14 Hari</h4>
            <p class="guide-card-desc">Member VIP rawan pindah kompetitor. Rekomendasi: <i>follow-up</i> personal segera sebelum hilang.</p>
          </div>
        </div>
        <div class="guide-card slate">
          <div class="guide-card-icon">⚪</div>
          <div class="guide-card-content">
            <div class="guide-card-label">Pasif (Abaikan)</div>
            <h4 class="guide-card-title">Bukan High-Value</h4>
            <p class="guide-card-desc">Member Bronze/Silver kecil yang telat. Sistem memfilternya agar staf tak buang waktu <i>follow-up</i>.</p>
          </div>
        </div>
      </div>
    </div>
  </details>

  <!-- Rich DataTable -->
  <div class="table-card" style="margin-top: 32px;">
    <DataTable data={all_members} search="true" rows=15 rowLines="true">
      <Column id="kode_member" title="Kode" />
      <Column id="tier_label" title="Tier" />
      <Column id="total_orders" title="Total Kunjungan" align="center" />
      <Column id="total_spend" title="Total Belanja (LTV)" fmt="Rp#,##0" />
      <Column id="avg_order_value" title="Rata-rata (AOV)" fmt="Rp#,##0" />
      <Column id="last_order_label" title="Terakhir Datang" align="center" />
      <Column id="ritme_kunjungan" title="Ritme Normal" align="center" />
      <Column id="status_label" title="Status" />
      <Column id="action_label" title="Saran Aksi" />
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

  :global([data-theme='dark']) .filter-panel {
    background: rgba(20, 20, 25, 0.65);
    border-color: rgba(20, 184, 166, 0.15);
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

  :global([data-theme='dark']) .chart-card {
    background: rgba(20, 20, 25, 0.45);
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

  :global([data-theme='dark']) .table-card {
    background: rgba(20, 20, 25, 0.45);
  }

  .guide-card.red { border-color: rgba(239,68,68,0.16); background: linear-gradient(135deg, rgba(239,68,68,0.04), rgba(255,255,255,0.8)); }
  .guide-card.slate { border-color: rgba(148,163,184,0.16); background: linear-gradient(135deg, rgba(148,163,184,0.04), rgba(255,255,255,0.8)); }
</style>
