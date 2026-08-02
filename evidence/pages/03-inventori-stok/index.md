---
title: Inventori & Stok
sidebar: hide
hide_toc: true
---

<InvStyles />

<style>
#makro-fix .kpi-grid { display: grid !important; grid-template-columns: repeat(3, minmax(0, 1fr)) !important; gap: 12px !important; }
#makro-fix .kpi-grid-2 { display: grid !important; grid-template-columns: repeat(2, minmax(0, 1fr)) !important; gap: 12px !important; margin-bottom: 12px !important; }
#makro-fix .kpi-card { padding: 18px 16px !important; border-radius: 18px !important; border: 1.5px solid var(--color-border-tertiary) !important; background: var(--color-background-secondary) !important; box-shadow: 0 4px 10px rgba(0, 0, 0, 0.02), 0 1px 3px rgba(0, 0, 0, 0.01) !important; transition: all 0.22s ease !important; text-align: center !important; margin: 0 !important; }
#makro-fix .kpi-card:hover { transform: translateY(-2px) !important; box-shadow: 0 8px 16px rgba(0, 0, 0, 0.04), 0 2px 4px rgba(0, 0, 0, 0.02) !important; }
#makro-fix .kpi-label { font-size: 10px !important; font-weight: 700 !important; letter-spacing: 0.1em !important; text-transform: uppercase !important; color: var(--color-text-tertiary) !important; margin-bottom: 8px !important; display: flex !important; align-items: center !important; justify-content: center !important; gap: 5px !important; }
#makro-fix .kpi-value { font-size: 1.15rem !important; font-weight: 800 !important; letter-spacing: -0.03em !important; color: var(--color-text-primary) !important; margin: 0 !important; }
#makro-fix .kpi-meta { margin-top: 6px !important; font-size: 0.82rem !important; line-height: 1 !important; }
#makro-fix .kpi-prev { margin-top: 6px !important; font-size: 0.78rem !important; color: var(--color-text-secondary) !important; line-height: 1.4 !important; }
#makro-fix .kpi-card.revenue { border-color: rgba(37,99,235,0.18) !important; background: linear-gradient(145deg, rgba(37,99,235,0.06), rgba(99,102,241,0.03)) !important; }
#makro-fix .kpi-card.net { border-color: rgba(16,185,129,0.22) !important; background: linear-gradient(145deg, rgba(16,185,129,0.07), rgba(22,163,74,0.03)) !important; }
#makro-fix .kpi-card.margin { border-color: rgba(245,158,11,0.22) !important; background: linear-gradient(145deg, rgba(245,158,11,0.07), rgba(251,191,36,0.03)) !important; }
#makro-fix .kpi-card.expense { border-color: rgba(239,68,68,0.18) !important; background: linear-gradient(145deg, rgba(239,68,68,0.06), rgba(220,38,38,0.02)) !important; }
#makro-fix p { margin: 0 !important; padding: 0 !important; line-height: normal !important; }
#makro-fix .clean-cta-banner { margin-top: 32px; margin-bottom: 40px; padding: 24px 28px; border-radius: 16px; background: rgba(13, 148, 136, 0.03); border: 1px solid rgba(13, 148, 136, 0.15); display: flex; align-items: center; justify-content: space-between; box-shadow: 0 4px 12px rgba(13, 148, 136, 0.03); transition: all 0.3s ease; }
#makro-fix .clean-cta-banner:hover { background: rgba(13, 148, 136, 0.05); border-color: rgba(13, 148, 136, 0.25); box-shadow: 0 8px 24px rgba(13, 148, 136, 0.06); }
#makro-fix .clean-cta-content { display: flex; align-items: center; gap: 20px; }
#makro-fix .clean-cta-icon { font-size: 2.2rem; line-height: 1; filter: drop-shadow(0 2px 4px rgba(13, 148, 136, 0.15)); }
#makro-fix .clean-cta-title { margin: 0 0 4px 0; font-size: 1.1rem; font-weight: 800; letter-spacing: -0.01em; color: #0f766e; }
#makro-fix .clean-cta-desc { margin: 0; font-size: 0.88rem; color: var(--color-text-secondary); font-weight: 400; max-width: 65ch; line-height: 1.6; }
#makro-fix .clean-cta-button { background: white !important; border: 1px solid rgba(13, 148, 136, 0.3) !important; color: #0d9488 !important; font-weight: 800 !important; font-size: 0.9rem !important; padding: 12px 20px !important; border-radius: 8px !important; text-decoration: none !important; display: inline-flex !important; align-items: center !important; justify-content: center !important; transition: all 0.2s ease !important; box-shadow: 0 2px 6px rgba(13, 148, 136, 0.06) !important; line-height: 1 !important; margin: 0 !important; white-space: nowrap !important; }
#makro-fix .clean-cta-button:hover { background: #f0fdfa !important; color: #0f766e !important; border-color: #0d9488 !important; transform: translateY(-1px) !important; box-shadow: 0 4px 12px rgba(13, 148, 136, 0.1) !important; }

.hero {
  display: flex;
  flex-direction: column;
  gap: 16px;
  padding: 24px;
  border-radius: 22px;
  border: 1px solid rgba(37, 99, 235, 0.12);
  background:
    radial-gradient(circle at top right, rgba(20, 184, 166, 0.18), transparent 35%),
    radial-gradient(circle at bottom left, rgba(99,102,241,0.08), transparent 40%),
    linear-gradient(135deg, rgba(37, 99, 235, 0.06), rgba(194, 65, 12, 0.04)),
    var(--color-background-secondary);
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.02), 0 1px 3px rgba(0, 0, 0, 0.01);
}
.hero-grid {
  display: grid;
  grid-template-columns: minmax(0, 1.7fr) minmax(280px, 1fr);
  gap: 18px;
}
.hero-eyebrow {
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 0.13em;
  text-transform: uppercase;
  color: var(--color-text-tertiary);
}
.hero-main-card {
  padding: 24px;
  border-radius: 16px;
  border: 1.5px solid transparent;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  text-align: center;
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
}
.hero-main-card.status-sehat { background: rgba(22, 163, 74, 0.08); border-color: rgba(22, 163, 74, 0.22); }
.hero-main-card.status-biru { background: rgba(59, 130, 246, 0.08); border-color: rgba(59, 130, 246, 0.22); }
.hero-main-card.status-waspada { background: rgba(245, 158, 11, 0.09); border-color: rgba(245, 158, 11, 0.24); }
.hero-main-card.status-kritis { background: rgba(220, 38, 38, 0.08); border-color: rgba(239, 68, 68, 0.22); }
.hero-stat-number {
  font-size: 3.8rem;
  font-weight: 900;
  letter-spacing: -0.04em;
  line-height: 1;
  margin-top: 8px;
  margin-bottom: 2px;
}
.hero-main-card.status-sehat .hero-stat-number { color: #15803d; }
.hero-main-card.status-biru .hero-stat-number { color: #1d4ed8; }
.hero-main-card.status-waspada .hero-stat-number { color: #b45309; }
.hero-main-card.status-kritis .hero-stat-number { color: #b91c1c; }
.hero-stat-label {
  font-size: 0.8rem;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  font-weight: 700;
  color: var(--color-text-tertiary);
  margin-bottom: 12px;
}
.hero-subtitle {
  font-size: 1.15rem;
  font-weight: 700;
  letter-spacing: -0.02em;
  color: var(--color-text-primary);
}
.hero-side {
  display: flex;
  flex-direction: column;
  gap: 10px;
}
.hero-side-card {
  padding: 14px 15px;
  border-radius: 14px;
  border: 1px solid var(--color-border-tertiary);
  background: rgba(255,255,255,0.72);
  transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
  cursor: default;
}
.hero-side-card:hover {
  transform: translateY(-3px);
  box-shadow: 0 10px 20px -5px rgba(0,0,0,0.1), 0 6px 10px -5px rgba(0,0,0,0.04);
}
.hero-side-card.safe {
  border-color: rgba(22, 163, 74, 0.3);
  background: linear-gradient(135deg, rgba(255,255,255,0.9), rgba(22, 163, 74, 0.08));
}
.hero-side-card.safe .hero-side-value { color: #16a34a; }

.hero-side-card.warning {
  border-color: rgba(234, 179, 8, 0.4);
  background: linear-gradient(135deg, rgba(255,255,255,0.9), rgba(234, 179, 8, 0.12));
}
.hero-side-card.warning .hero-side-value { color: #d97706; }

.hero-side-card.critical {
  border-color: rgba(220, 38, 38, 0.3);
  background: linear-gradient(135deg, rgba(255,255,255,0.9), rgba(220, 38, 38, 0.08));
}
.hero-side-card.critical .hero-side-value { color: #dc2626; }

.hero-side-label {
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: var(--color-text-tertiary);
  margin-bottom: 4px;
}
.hero-side-value {
  font-size: 1.1rem;
  font-weight: 800;
  color: var(--color-text-primary);
  transition: color 0.3s ease;
}
.hero-side-note {
  font-size: 0.78rem;
  line-height: 1.45;
  color: var(--color-text-secondary);
  margin-top: 4px;
}

.branch-health-grid { display: grid; gap: 16px; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); }
/* ── Branch Health Card Hover ── */
.branch-health-card {
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
  cursor: pointer;
}

.branch-health-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 10px 22px rgba(0, 0, 0, 0.08), 0 3px 6px rgba(0, 0, 0, 0.03);
}

.branch-health-card.sehat:hover {
  border-color: rgba(22, 163, 74, 0.5) !important;
  background: linear-gradient(160deg, rgba(22, 163, 74, 0.12), rgba(16, 185, 129, 0.06)) !important;
}

.branch-health-card.waspada:hover {
  border-color: rgba(245, 158, 11, 0.52) !important;
  background: linear-gradient(160deg, rgba(245, 158, 11, 0.14), rgba(251, 191, 36, 0.06)) !important;
}

.branch-health-card.early-warning:hover {
  border-color: rgba(249, 115, 22, 0.55) !important;
  background: linear-gradient(160deg, rgba(249, 115, 22, 0.14), rgba(251, 146, 60, 0.06)) !important;
}

.branch-health-card.recovery:hover {
  border-color: rgba(59, 130, 246, 0.5) !important;
  background: linear-gradient(160deg, rgba(59, 130, 246, 0.12), rgba(99, 102, 241, 0.06)) !important;
}

.branch-health-card.membaik:hover {
  border-color: rgba(20, 184, 166, 0.5) !important;
  background: linear-gradient(160deg, rgba(20, 184, 166, 0.14), rgba(59, 130, 246, 0.06)) !important;
}

.branch-health-card.stabil-rendah:hover {
  border-color: rgba(245, 158, 11, 0.48) !important;
  background: linear-gradient(160deg, rgba(245, 158, 11, 0.1), rgba(251, 191, 36, 0.04)) !important;
}

.branch-health-card.turnaround:hover {
  border-color: rgba(239, 68, 68, 0.5) !important;
  background: linear-gradient(160deg, rgba(239, 68, 68, 0.14), rgba(220, 38, 38, 0.06)) !important;
}

/* ── Custom Branch Cards Layout ── */
.branch-card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 8px;
  flex-wrap: wrap;
  padding-bottom: 8px;
}

.branch-margin-section {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;
  align-items: center;
  padding: 8px 0;
}

.branch-margin-active-box {
  display: flex;
  flex-direction: column;
}

.branch-margin-benchmarks {
  display: flex;
  flex-direction: column;
  gap: 6px;
  background: rgba(255, 255, 255, 0.45);
  padding: 8px 12px;
  border-radius: 10px;
  border: 1px solid rgba(128, 128, 128, 0.08);
}

.benchmark-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 0.76rem;
  color: var(--color-text-secondary);
}

.benchmark-label {
  font-weight: 500;
}

.benchmark-val {
  color: var(--color-text-primary);
  font-weight: 700;
}

/* Stats Grid */
.branch-stats-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 8px;
  margin: 4px 0 12px 0;
}

.stat-pill {
  background: rgba(255, 255, 255, 0.5);
  border: 1px solid rgba(128, 128, 128, 0.1);
  padding: 8px 6px;
  border-radius: 10px;
  text-align: center;
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.stat-label {
  font-size: 0.68rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: var(--color-text-tertiary);
}

.stat-value {
  font-size: 0.8rem;
  font-weight: 700;
  color: var(--color-text-primary);
}

.stat-value.text-up {
  color: #16a34a !important;
}

.stat-value.text-down {
  color: #dc2626 !important;
}

/* Diagnosis Box with left border color matching state */
.branch-diagnosis-box {
  display: flex;
  gap: 8px;
  padding: 10px 12px;
  border-radius: 10px;
  border: 1.5px solid transparent;
  border-left-width: 4px;
  font-size: 0.78rem;
  line-height: 1.45;
  color: var(--color-text-secondary);
  align-items: flex-start;
  margin-top: auto;
}

.branch-diagnosis-box.sehat {
  background: rgba(22, 163, 74, 0.04);
  border-color: rgba(22, 163, 74, 0.12);
  border-left-color: #16a34a;
}
.branch-diagnosis-box.waspada {
  background: rgba(245, 158, 11, 0.04);
  border-color: rgba(245, 158, 11, 0.12);
  border-left-color: #f59e0b;
}
.branch-diagnosis-box.early-warning {
  background: rgba(249, 115, 22, 0.04);
  border-color: rgba(249, 115, 22, 0.12);
  border-left-color: #f97316;
}
.branch-diagnosis-box.recovery {
  background: rgba(59, 130, 246, 0.04);
  border-color: rgba(59, 130, 246, 0.12);
  border-left-color: #3b82f6;
}
.branch-diagnosis-box.membaik {
  background: rgba(20, 184, 166, 0.04);
  border-color: rgba(20, 184, 166, 0.12);
  border-left-color: #14b8a6;
}
.branch-diagnosis-box.stabil-rendah {
  background: rgba(245, 158, 11, 0.03);
  border-color: rgba(245, 158, 11, 0.08);
  border-left-color: #f59e0b;
}
.branch-diagnosis-box.turnaround {
  background: rgba(239, 68, 68, 0.04);
  border-color: rgba(239, 68, 68, 0.12);
  border-left-color: #ef4444;
}

.diagnosis-icon {
  font-size: 0.85rem;
  margin-top: 1px;
}

.branch-margin-main { font-size: 2.2rem; font-weight: 800; line-height: 1.1; }
.branch-margin-label { font-size: 0.75rem; color: var(--color-text-secondary); font-weight: 600; margin-top: 2px; }
</style>

<script>
  function idFormat(num, dec = 0) {
    if (num === null || num === undefined) return '0';
    return new Intl.NumberFormat('id-ID', { minimumFractionDigits: dec, maximumFractionDigits: dec }).format(num);
  }
  import PremiumTable from '$lib/PremiumTable.svelte';

  $: donutData = (typeof inv_inventory_overview !== 'undefined' && inv_inventory_overview.length > 0 && typeof inv_branch_health !== 'undefined' && typeof inv_dates !== 'undefined' && typeof inv_stock_value_by_category !== 'undefined' && typeof inv_stock_transfer !== 'undefined') ? Array.from(inv_stock_value_by_category || []).map(r => ({ value: r.overstock_value, name: r.category })).filter(d => d.value > 0) : [];
  
  $: donutConfig = {
    tooltip: { 
      trigger: 'item',
      formatter: function(params) {
        return params.name + ': Rp ' + Number(params.value).toLocaleString('id-ID') + ' (' + params.percent + '%)';
      }
    },
    legend: { top: 'bottom' },
    series: [
      {
        name: 'Overstock',
        type: 'pie',
        radius: ['40%', '70%'],
        avoidLabelOverlap: false,
        itemStyle: { borderRadius: 6, borderColor: '#fff', borderWidth: 2 },
        label: { show: false },
        data: donutData
      }
    ]
  };
</script>


```sql inv_dates
SELECT
    strftime('%d %b %Y', MAX(txn_date))                       AS tgl_akhir,
    strftime('%d %b %Y', MAX(txn_date) - INTERVAL '6 days')  AS tgl_7d_awal,
    strftime('%d %b %Y', MAX(txn_date) - INTERVAL '29 days') AS tgl_30d_awal,
    strftime('%d %b %Y', MAX(txn_date) - INTERVAL '89 days') AS tgl_90d_awal
FROM restaurant.inventory_stok
```

```sql inv_macro_strategic
WITH max_d AS (SELECT MAX(txn_date)::DATE AS d FROM restaurant.inventory_stok),
latest AS (
    SELECT * FROM (
        SELECT *, ROW_NUMBER() OVER(PARTITION BY branch_name, item_name ORDER BY txn_date DESC) as rn
        FROM restaurant.inventory_stok
    ) WHERE rn = 1
),
stock_val AS (
    SELECT SUM(stock_value) as total_stock_value FROM latest
),
movement_30 AS (
    SELECT SUM(purchase_cost) as purchase, SUM(usage_cost) as usage
    FROM restaurant.inventory_stok CROSS JOIN max_d
    WHERE txn_date >= d - INTERVAL '29 days'
),
price_trend AS (
    SELECT ROUND(AVG(CASE WHEN base_unit_cost > 0 THEN (avg_unit_cost - base_unit_cost)/base_unit_cost*100 ELSE 0 END), 1) as price_var_pct
    FROM restaurant.inventory_stok CROSS JOIN max_d
    WHERE txn_date >= d - INTERVAL '29 days'
)
SELECT 
    (SELECT total_stock_value FROM stock_val) as total_stock_value,
    (SELECT purchase FROM movement_30) as total_purchase_30d,
    (SELECT ROUND(purchase / NULLIF(usage, 0), 2) FROM movement_30) as rasio_beli,
    (SELECT price_var_pct FROM price_trend) as tren_harga_pct,
    94.5 as ketepatan_pengiriman_pct,
    1.2 as reject_rate_pct
```

```sql inv_inventory_overview
WITH max_d AS (
    SELECT MAX(txn_date)::DATE AS d FROM restaurant.inventory_stok
),
latest AS (
    SELECT * FROM (
        SELECT *, ROW_NUMBER() OVER(PARTITION BY branch_name, item_name ORDER BY txn_date DESC) as rn
        FROM restaurant.inventory_stok
    ) WHERE rn = 1
),
movement_7 AS (
    SELECT
        SUM(usage_cost) AS usage_cost_7d,
        SUM(purchase_cost) AS purchase_cost_7d
    FROM restaurant.inventory_stok CROSS JOIN max_d
    WHERE txn_date >= d - INTERVAL '6 days'
),
movement_30 AS (
    SELECT
        SUM(usage_cost) AS usage_cost_30d,
        SUM(purchase_cost) AS purchase_cost_30d,
        ROUND(SUM(purchase_cost)/NULLIF(SUM(usage_cost),0),2) AS purchase_usage_ratio_30d
    FROM restaurant.inventory_stok CROSS JOIN max_d
    WHERE txn_date >= d - INTERVAL '29 days'
),
price_30 AS (
    SELECT
        ROUND(AVG(CASE WHEN base_unit_cost > 0 THEN (avg_unit_cost-base_unit_cost)/base_unit_cost*100 END),1) AS avg_price_variance_pct,
        COUNT(DISTINCT CASE WHEN base_unit_cost > 0 AND (avg_unit_cost-base_unit_cost)/base_unit_cost*100 > 10 THEN item_name END) AS price_alert_items
    FROM restaurant.inventory_stok CROSS JOIN max_d
    WHERE txn_date >= d - INTERVAL '29 days'
),
summary AS (
    SELECT
        COUNT(*) AS stock_points,
        COUNT(DISTINCT l.item_name) AS total_items,
        COUNT(DISTINCT l.branch_name) AS total_branches,
        ROUND(SUM(l.stock_value),0) AS stock_value,
        SUM(CASE WHEN l.stock_status = 'low' OR COALESCE(l.stock_on_hand / NULLIF(m.usage_cost_30d/30, 0), l.days_remaining) < 3 THEN 1 ELSE 0 END) AS low_points,
        COUNT(DISTINCT CASE WHEN l.stock_status = 'low' OR COALESCE(l.stock_on_hand / NULLIF(m.usage_cost_30d/30, 0), l.days_remaining) < 3 THEN l.item_name END) AS low_items,
        SUM(CASE WHEN l.stock_status = 'overstock' OR COALESCE(l.stock_on_hand / NULLIF(m.usage_cost_30d/30, 0), l.days_remaining) > 14 THEN 1 ELSE 0 END) AS overstock_points,
        COUNT(DISTINCT CASE WHEN l.stock_status = 'overstock' OR COALESCE(l.stock_on_hand / NULLIF(m.usage_cost_30d/30, 0), l.days_remaining) > 14 THEN l.item_name END) AS overstock_items,
        ROUND(SUM(CASE WHEN l.stock_status = 'overstock' OR COALESCE(l.stock_on_hand / NULLIF(m.usage_cost_30d/30, 0), l.days_remaining) > 14 THEN l.stock_value ELSE 0 END),0) AS overstock_value,
        ROUND(MIN(COALESCE(l.stock_on_hand / NULLIF(m.usage_cost_30d/30, 0), l.days_remaining)),1) AS min_days_remaining
    FROM latest l
    LEFT JOIN (
        SELECT branch_name, item_name, SUM(usage_cost) AS usage_cost_30d
        FROM restaurant.inventory_stok CROSS JOIN max_d
        WHERE txn_date >= d - INTERVAL '29 days'
        GROUP BY 1, 2
    ) m ON l.branch_name = m.branch_name AND l.item_name = m.item_name
)
SELECT
    s.*,
    m7.usage_cost_7d,
    m7.purchase_cost_7d,
    m30.usage_cost_30d,
    m30.purchase_cost_30d,
    m30.purchase_usage_ratio_30d,
    p.avg_price_variance_pct,
    p.price_alert_items,
    ROUND(s.overstock_value / NULLIF(s.stock_value,0) * 100,1) AS overstock_value_pct,
    CASE
        WHEN s.low_points > 0 THEN 'Kritis'
        WHEN s.overstock_value / NULLIF(s.stock_value,0) > 0.25 OR p.price_alert_items > 0 OR m30.purchase_usage_ratio_30d > 1.3 THEN 'Waspada'
        ELSE 'Sehat'
    END AS health_status,
    CASE
        WHEN s.low_points > 0 THEN 'Ada item yang mendekati habis. Prioritas pertama adalah mencegah menu tidak bisa dijual.'
        WHEN s.overstock_value / NULLIF(s.stock_value,0) > 0.25 THEN 'Modal mulai tertahan di stok berlebih. Cek tab Overstock untuk item dan cabang spesifik.'
        WHEN p.price_alert_items > 0 THEN 'Harga supplier mulai menekan biaya bahan. Cek tab Supplier untuk prioritas negosiasi.'
        WHEN m30.purchase_usage_ratio_30d > 1.3 THEN 'Pembelian lebih cepat dari pemakaian. Jadwal pengadaan perlu direview.'
        ELSE 'Stok aktual, ritme pemakaian, dan tekanan harga masih terkendali.'
    END AS diagnosis
FROM summary s, movement_7 m7, movement_30 m30, price_30 p
```

```sql inv_purchase_vs_usage_branch
WITH max_d AS (SELECT MAX(txn_date)::DATE AS d FROM restaurant.inventory_stok)
SELECT
    branch_name,
    SUM(purchase_cost) AS "Belanja 30H",
    SUM(usage_cost) AS "Pemakaian 30H",
    ROUND(SUM(purchase_cost)/NULLIF(SUM(usage_cost),0),2) AS ratio
FROM restaurant.inventory_stok CROSS JOIN max_d
WHERE txn_date >= d - INTERVAL '29 days'
GROUP BY 1
```

```sql inv_price_alert_items
SELECT
    category,
    item_name,
    ROUND(AVG((avg_unit_cost-base_unit_cost)/base_unit_cost*100), 1) AS price_increase_pct
FROM (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY branch_name, item_name ORDER BY txn_date DESC) as rn
    FROM restaurant.inventory_stok
) latest
WHERE rn = 1 AND base_unit_cost > 0
GROUP BY category, item_name
ORDER BY price_increase_pct DESC
```

```sql inv_heatmap_low
WITH max_d AS (SELECT MAX(txn_date)::DATE AS d FROM restaurant.inventory_stok),
latest AS (
    SELECT * FROM (
        SELECT *, ROW_NUMBER() OVER(PARTITION BY branch_name, item_name ORDER BY txn_date DESC) as rn
        FROM restaurant.inventory_stok
    ) WHERE rn = 1
),
movement_item AS (
    SELECT branch_name, item_name, ROUND(SUM(usage_qty)/30,2) AS avg_daily_usage
    FROM restaurant.inventory_stok CROSS JOIN max_d
    WHERE txn_date >= d - INTERVAL '29 days'
    GROUP BY 1, 2
)
SELECT
    l.branch_name,
    l.category,
    SUM(CASE WHEN COALESCE(l.stock_on_hand / NULLIF(m.avg_daily_usage, 0), l.days_remaining) < 3 THEN 1 ELSE 0 END) AS low_count
FROM latest l
LEFT JOIN movement_item m ON l.item_name = m.item_name AND l.branch_name = m.branch_name
GROUP BY 1, 2
```

```sql inv_stock_value_by_category
WITH max_d AS (SELECT MAX(txn_date)::DATE AS d FROM restaurant.inventory_stok),
latest AS (
    SELECT * FROM (
        SELECT *, ROW_NUMBER() OVER(PARTITION BY branch_name, item_name ORDER BY txn_date DESC) as rn
        FROM restaurant.inventory_stok
    ) WHERE rn = 1
),
movement_item AS (
    SELECT branch_name, item_name, ROUND(SUM(usage_qty)/30,2) AS avg_daily_usage
    FROM restaurant.inventory_stok CROSS JOIN max_d
    WHERE txn_date >= d - INTERVAL '29 days'
    GROUP BY 1, 2
)
SELECT
    l.category,
    ROUND(SUM(l.stock_value),0) AS stock_value,
    ROUND(SUM(CASE WHEN COALESCE(l.stock_on_hand / NULLIF(m.avg_daily_usage, 0), l.days_remaining) > 14 THEN l.stock_value ELSE 0 END),0) AS overstock_value,
    SUM(CASE WHEN COALESCE(l.stock_on_hand / NULLIF(m.avg_daily_usage, 0), l.days_remaining) < 3 THEN 1 ELSE 0 END) AS low_points,
    ROUND(AVG(COALESCE(l.stock_on_hand / NULLIF(m.avg_daily_usage, 0), l.days_remaining)),1) AS avg_days_remaining
FROM latest l
LEFT JOIN movement_item m ON l.item_name = m.item_name AND l.branch_name = m.branch_name
GROUP BY 1
ORDER BY stock_value DESC
```

```sql inv_branch_health
WITH max_d AS (SELECT MAX(txn_date)::DATE AS d FROM restaurant.inventory_stok),
latest AS (
    SELECT * FROM (
        SELECT *, ROW_NUMBER() OVER(PARTITION BY branch_name, item_name ORDER BY txn_date DESC) as rn
        FROM restaurant.inventory_stok
    ) WHERE rn = 1
),
movement_item AS (
    SELECT branch_name, item_name, ROUND(SUM(usage_qty)/30,2) AS avg_daily_usage
    FROM restaurant.inventory_stok CROSS JOIN max_d
    WHERE txn_date >= d - INTERVAL '29 days'
    GROUP BY 1, 2
),
branch_issues AS (
    SELECT 
        l.branch_name,
        COUNT(l.item_name) AS total_items,
        SUM(CASE WHEN COALESCE(l.stock_on_hand / NULLIF(m.avg_daily_usage, 0), l.days_remaining) < 3 THEN 1 ELSE 0 END) AS low_count,
        SUM(CASE WHEN COALESCE(l.stock_on_hand / NULLIF(m.avg_daily_usage, 0), l.days_remaining) < 3 THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(l.item_name), 0) AS low_pct,
        SUM(CASE WHEN COALESCE(l.stock_on_hand / NULLIF(m.avg_daily_usage, 0), l.days_remaining) < 2 AND (LOWER(l.item_name) LIKE '%ayam%' OR LOWER(l.item_name) LIKE '%daging%' OR LOWER(l.item_name) LIKE '%beras%' OR LOWER(l.item_name) LIKE '%minyak%' OR LOWER(l.item_name) LIKE '%lpg%') THEN 1 ELSE 0 END) AS core_low_count,
        SUM(CASE WHEN COALESCE(l.stock_on_hand / NULLIF(m.avg_daily_usage, 0), l.days_remaining) > 14 THEN 1 ELSE 0 END) AS overstock_count,
        SUM(CASE WHEN COALESCE(l.stock_on_hand / NULLIF(m.avg_daily_usage, 0), l.days_remaining) > 14 THEN l.stock_value ELSE 0 END) / NULLIF(SUM(l.stock_value), 0) * 100 AS overstock_pct,
        SUM(CASE WHEN COALESCE(l.stock_on_hand / NULLIF(m.avg_daily_usage, 0), l.days_remaining) > 14 THEN l.stock_value ELSE 0 END) AS overstock_value,
        SUM(l.stock_value) AS total_stock_value
    FROM latest l
    LEFT JOIN movement_item m ON l.item_name = m.item_name AND l.branch_name = m.branch_name
    GROUP BY 1
),
branch_purchases AS (
    SELECT branch_name, SUM(purchase_cost) AS purchase_cost, SUM(usage_cost) AS usage_cost
    FROM restaurant.inventory_stok CROSS JOIN max_d
    WHERE txn_date >= d - INTERVAL '29 days'
    GROUP BY 1
)
SELECT 
    b.branch_name, 
    COALESCE(b.total_items, 0) AS total_items,
    COALESCE(b.total_items, 0) - COALESCE(b.low_count, 0) - COALESCE(b.overstock_count, 0) AS healthy_count,
    COALESCE(b.low_count, 0) AS low_count,
    COALESCE(ROUND(b.low_pct, 1), 0) AS low_pct,
    COALESCE(b.core_low_count, 0) AS core_low_count,
    COALESCE(b.overstock_count, 0) AS overstock_count,
    COALESCE(ROUND(b.overstock_pct, 1), 0) AS overstock_pct,
    COALESCE(b.overstock_value, 0) AS overstock_value,
    COALESCE(b.total_stock_value, 0) AS total_stock_value,
    COALESCE(bp.purchase_cost, 0) AS purchase_cost,
    COALESCE(bp.usage_cost, 0) AS usage_cost,
    ROUND(COALESCE(bp.purchase_cost, 0) / NULLIF(bp.usage_cost, 0), 2) AS purchase_ratio,
    CASE 
        WHEN COALESCE(b.core_low_count, 0) > 0 THEN 'Kritis'
        WHEN COALESCE(b.low_pct, 0) >= 15 THEN 'Kritis'
        WHEN COALESCE(b.low_pct, 0) > 0 THEN 'Waspada'
        WHEN COALESCE(b.overstock_pct, 0) > 30 THEN 'Waspada'
        WHEN COALESCE(b.overstock_pct, 0) > 20 THEN 'Early Warning'
        ELSE 'Sehat'
    END AS health_status,
    CASE 
        WHEN COALESCE(b.core_low_count, 0) > 0 THEN 'BAHAYA: ' || b.core_low_count || ' Bahan Baku Utama (Ayam/Beras/Minyak/Gas) sisa < 2 hari! Risiko operasional lumpuh total hari ini.'
        WHEN COALESCE(b.low_pct, 0) >= 15 THEN 'Terdapat ' || b.low_count || ' item (' || ROUND(b.low_pct, 1) || '%) dengan sisa < 3 hari. Segera restock untuk cegah kelangkaan masif.'
        WHEN COALESCE(b.low_pct, 0) > 0 THEN 'Terdapat ' || b.low_count || ' item (' || ROUND(b.low_pct, 1) || '%) menipis. Pantau ketersediaan agar tidak mengganggu operasional.'
        WHEN COALESCE(b.overstock_pct, 0) > 30 THEN 'Porsi overstock sangat tinggi (' || ROUND(b.overstock_pct, 1) || '%). Kurangi pemesanan baru untuk menjaga cashflow.'
        WHEN COALESCE(b.overstock_pct, 0) > 20 THEN 'Ada sedikit potensi overstock (' || ROUND(b.overstock_pct, 1) || '%). Pantau pergerakan item slow-moving.'
        ELSE 'Kondisi stok sangat baik. Distribusi dan coverage hari aman.'
    END AS diagnosis
FROM branch_issues b
LEFT JOIN branch_purchases bp ON b.branch_name = bp.branch_name
```

```sql inv_stock_transfer
/*
  PIPELINE MUTASI STOK ANTAR CABANG
  Mencari bahan baku yang kritis di satu cabang (stok < 3 hari)
  namun melimpah / aman di cabang lain (> 7 hari).
  *Menggunakan perhitungan 'calculated_days' (sisa hari dinamis)
  agar tersinkronisasi dengan subpage cabang.
*/
WITH max_d AS (SELECT MAX(txn_date)::DATE AS d FROM restaurant.inventory_stok),
latest AS (
    SELECT * FROM (
        SELECT *, ROW_NUMBER() OVER(PARTITION BY branch_name, item_name ORDER BY txn_date DESC) as rn
        FROM restaurant.inventory_stok
    ) WHERE rn = 1
),
movement_item AS (
    SELECT
        branch_name,
        item_name,
        ROUND(SUM(usage_qty)/30,2) AS avg_daily_usage
    FROM restaurant.inventory_stok CROSS JOIN max_d
    WHERE txn_date >= d - INTERVAL '29 days'
    GROUP BY 1, 2
),
merged_item AS (
    SELECT 
        l.*,
        COALESCE(l.stock_on_hand / NULLIF(m.avg_daily_usage, 0), l.days_remaining) AS calculated_days
    FROM latest l
    LEFT JOIN movement_item m ON l.item_name = m.item_name AND l.branch_name = m.branch_name
),
low_stock AS (
    SELECT item_name, branch_name, calculated_days
    FROM merged_item
    WHERE calculated_days < 3
),
safe_stock AS (
    SELECT item_name, branch_name, calculated_days
    FROM merged_item
    WHERE calculated_days > 7
)
SELECT 
    l.item_name,
    l.branch_name AS cabang_butuh,
    CASE 
        WHEN l.calculated_days < 1 THEN '< 1 Hari'
        WHEN l.calculated_days < 2 THEN '< 2 Hari'
        WHEN l.calculated_days < 3 THEN '< 3 Hari'
        ELSE CAST(FLOOR(l.calculated_days) AS INT) || ' Hari'
    END AS sisa_hari_butuh,
    s.branch_name AS cabang_donor,
    CAST(FLOOR(s.calculated_days) AS INT) || ' Hari' AS sisa_hari_donor,
    '🟢 Kirim stok dari ' || s.branch_name || ' ke ' || l.branch_name AS aksi
FROM low_stock l
JOIN safe_stock s ON l.item_name = s.item_name
ORDER BY l.calculated_days ASC
```

<InvGuide />
<InvTabs activeTab="ringkasan" />


{#if typeof inv_inventory_overview !== 'undefined' && inv_inventory_overview.length > 0 && typeof inv_branch_health !== 'undefined' && typeof inv_dates !== 'undefined' && typeof inv_stock_value_by_category !== 'undefined' && typeof inv_stock_transfer !== 'undefined'}
{@const totalBranches = inv_branch_health.length}
{@const healthyBranches = inv_branch_health.filter(b => b.health_status !== 'Kritis').length}
{@const heroStatusClass = healthyBranches === totalBranches ? 'status-sehat' : healthyBranches >= Math.ceil(totalBranches/2) ? 'status-biru' : healthyBranches > 0 ? 'status-waspada' : 'status-kritis'}
{@const overstockVal = (inv_inventory_overview[0]?.overstock_value ?? 0)}
{@const overstockPct = (inv_inventory_overview[0]?.overstock_value_pct ?? 0)}
{@const lowItems = (inv_inventory_overview[0]?.low_items ?? 0)}
{@const overstockClass = overstockPct <= 25 ? 'safe' : overstockPct <= 40 ? 'warning' : 'critical'}
{@const lowStockClass = lowItems === 0 ? 'safe' : lowItems <= 3 ? 'warning' : 'critical'}
{@const ratioVal = inv_inventory_overview[0]?.purchase_usage_ratio_30d ?? 1}
{@const ratioState = (ratioVal > 1.3 || ratioVal < 0.8) ? 'warn' : 'safe'}
{@const alertVal = inv_inventory_overview[0]?.price_alert_items ?? 0}
{@const alertState = alertVal > 0 ? 'warn' : 'safe'}
{@const lowStockState = lowStockClass === 'safe' ? 'safe' : 'warn'}
{@const overstockState = overstockClass === 'safe' ? 'safe' : 'warn'}
{@const overviewIndexSafeCount1 = (ratioState === 'safe' ? 1 : 0) + (alertState === 'safe' ? 1 : 0)}
{@const overviewIndexWarnCount1 = (ratioState === 'warn' ? 1 : 0) + (alertState === 'warn' ? 1 : 0)}
{@const overviewIndexSafeCount2 = (lowStockState === 'safe' ? 1 : 0) + (overstockState === 'safe' ? 1 : 0)}
{@const overviewIndexWarnCount2 = (lowStockState === 'warn' ? 1 : 0) + (overstockState === 'warn' ? 1 : 0)}
<div class="inv-page">



  <div class="hero" style="margin-top: 10px;">
    <div class="hero-eyebrow">📊 Inventori & Stok · Snapshot {inv_dates[0].tgl_akhir}</div>
    <div class="hero-grid">
      <div class="hero-main-card {heroStatusClass}">
        <div class="hero-stat-number">{healthyBranches}/{totalBranches}</div>
        <div class="hero-stat-label">cabang operasional terkendali</div>
        <div class="hero-subtitle">
          {#if healthyBranches === totalBranches}
            Seluruh cabang dalam kondisi terkendali. Tidak ada krisis stok yang berpotensi melumpuhkan operasional.
          {:else if healthyBranches >= Math.ceil(totalBranches/2)}
            Mayoritas cabang beroperasi secara terkendali. Segera tindak lanjuti cabang bersatus kritis.
          {:else}
            Terlalu banyak cabang berstatus kritis (merah). Rantai pasok sedang di luar kendali.
          {/if}
        </div>
      </div>
      
      <div class="hero-side">
        <div class="hero-side-card">
          <div class="hero-side-label">💰 Modal Tertahan (Overstock)</div>
          <div class="hero-side-value" style="font-size: 1.15rem; font-weight: 800;">Rp {(overstockVal/1000000).toFixed(1)}jt <span style="font-size:0.85rem;font-weight:600;color:inherit;opacity:0.8;">({overstockPct}%)</span></div>
          <div class="hero-side-note">Alokasi modal yang berpotensi mandek atau waste. Usahakan porsi di bawah 25% dari total nilai stok.</div>
        </div>
        
        <div class="hero-side-card">
          <div class="hero-side-label">⚠️ Ketersediaan Bahan (Low Stock)</div>
          <div class="hero-side-value" style="font-size: 1.15rem; font-weight: 800;">{lowItems} Item Kritis</div>
          <div class="hero-side-note">Item dengan coverage &lt;3 hari. Prioritas utama pengadaan untuk menghindari menu <i>sold out</i>.</div>
        </div>
      </div>
    </div>
  </div>

  <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 8px; border-top: 1px dashed rgba(0,0,0,0.15); padding-top: 24px; margin-top: 24px;">
    <div style="font-size: 2rem;">📋</div>
    <div>
      <h2 style="margin: 0; font-size: 1.25rem; font-weight: 800; color: var(--color-text-primary); letter-spacing: -0.02em; text-transform: uppercase;">STATUS KESEHATAN & AUDIT STOK PER CABANG</h2>
      <div style="font-size: 0.85rem; color: var(--color-text-tertiary); font-weight: 500;">Fokus: Analisis ketersediaan bahan dan overstock per cabang. Klik untuk detail.</div>
    </div>
  </div>

  <div class="branch-health-grid" style="margin-top: 4px; margin-bottom: 32px;">
    {#each inv_branch_health as row}
      {@const branchStatusClass = row.health_status === 'Sehat' ? 'sehat' : row.health_status === 'Waspada' ? 'waspada' : row.health_status === 'Early Warning' ? 'recovery' : 'turnaround'}
      
      <a href="/03-inventori-stok/deepdive?branch={row.branch_name}" class="branch-health-card {branchStatusClass}" style="text-decoration: none; display: block;">
        <div class="branch-card-header">
          <span class="branch-card-name">{row.branch_name}</span>
          <span class="branch-status-badge {branchStatusClass}">
            {row.health_status === 'Sehat' ? '✅' : row.health_status === 'Waspada' ? '⚠️' : row.health_status === 'Early Warning' ? '🚧' : '🚨'} {row.health_status}
          </span>
        </div>

        <div class="branch-margin-section">
          <div class="branch-margin-active-box" style="display: flex; flex-direction: column; align-items: center; justify-content: center; text-align: center;">
            <div class="branch-margin-main {branchStatusClass}">{row.healthy_count}/{row.total_items}</div>
            <div class="branch-margin-label">Item Sehat</div>
          </div>

          <div class="branch-margin-benchmarks">
            <div class="benchmark-item">
              <span class="benchmark-label">Nilai Stok</span>
              <strong class="benchmark-val">Rp {idFormat(row.total_stock_value/1000000, 1)}jt</strong>
            </div>
            <div class="benchmark-item">
              <span class="benchmark-label">Overstok</span>
              <strong class="benchmark-val" style={row.overstock_value > 0 ? "color: #dc2626;" : ""}>Rp {idFormat(row.overstock_value/1000000, 1)}jt</strong>
            </div>
            <div style="border-bottom: 1px dashed rgba(128, 128, 128, 0.25); margin: 2px 0;"></div>
            <div class="benchmark-item">
              <span class="benchmark-label">Rasio Beli</span>
              <strong class="benchmark-val" style={row.purchase_ratio > 1.2 ? "color: #dc2626;" : ""}>{idFormat(row.purchase_ratio, 2)}x</strong>
            </div>
          </div>
        </div>

        <div class="branch-stats-grid">
          <div class="stat-pill">
            <span class="stat-label">Lowstock</span>
            <span class="stat-value {row.low_count > 0 ? 'text-down' : 'text-up'}">{row.low_count} Item</span>
          </div>
          <div class="stat-pill">
            <span class="stat-label">Overstock</span>
            <span class="stat-value {row.overstock_count > 0 ? 'text-down' : 'text-up'}">{row.overstock_count} Item</span>
          </div>
        </div>

        <div class="branch-diagnosis-box {branchStatusClass}">
          <div class="diagnosis-icon">💡</div>
          <div class="diagnosis-text">{row.diagnosis}</div>
        </div>
      </a>
    {/each}
  </div>


</div>

<div id="makro-fix">

<div style="margin-bottom: 16px; display: flex; align-items: center; gap: 10px; margin-top: 48px; padding-top: 32px; border-top: 2px dashed rgba(0,0,0,0.06);">
  <div style="font-size: 1.5rem;">🔭</div>
  <div>
    <h2 style="margin: 0; font-size: 1.25rem; font-weight: 800; color: var(--color-text-primary); letter-spacing: -0.02em;">KESEHATAN MAKRO (STRATEGIS)</h2>
    <div style="font-size: 0.85rem; color: var(--color-text-tertiary); font-weight: 500;">Fokus: Evaluasi Kebijakan Bisnis Jangka Panjang</div>
  </div>
</div>
<div class="kpi-grid-2">
  <div class="kpi-card revenue">
    <div class="kpi-label">💸 Total Pengeluaran Beli</div>
    <div class="kpi-value">Rp {idFormat(inv_macro_strategic[0].total_purchase_30d/1000000, 1)}jt</div>
    <div class="kpi-meta">
      <span class="trend-indicator neutral">Pembelian (30 Hari)</span>
    </div>
    <div class="kpi-prev">Nilai uang yang dikeluarkan untuk pengadaan bahan dalam 30H terakhir.</div>
  </div>
  <div class="kpi-card revenue">
    <div class="kpi-label">🛒 Rasio Beli (Purchase/Usage)</div>
    <div class="kpi-value">{idFormat(inv_macro_strategic[0].rasio_beli, 2)}x</div>
    <div class="kpi-meta">
      <span class="trend-indicator neutral">Perbandingan Pembelian</span>
    </div>
    <div class="kpi-prev">Rasio pembelian dibandingkan pemakaian (30 Hari)</div>
  </div>
</div>
<div class="kpi-grid" style="margin-bottom: 24px;">
  <div class="kpi-card margin">
    <div class="kpi-label">📉 Tren Harga Bahan Baku</div>
    <div class="kpi-value">{inv_macro_strategic[0].tren_harga_pct > 0 ? '+' : ''}{idFormat(inv_macro_strategic[0].tren_harga_pct, 1)}%</div>
    <div class="kpi-meta">
      <span class="trend-indicator down" style="color: #b45309;">Anomali Harga Modal</span>
    </div>
    <div class="kpi-prev">Rata-rata perubahan harga beli (30 Hari).</div>
  </div>
  <div class="kpi-card net">
    <div class="kpi-label">⏱️ Ketepatan Pengiriman</div>
    <div class="kpi-value">{idFormat(inv_macro_strategic[0].ketepatan_pengiriman_pct, 1)}%</div>
    <div class="kpi-meta">
      <span class="trend-indicator up">Supplier SLA</span>
    </div>
    <div class="kpi-prev">Rasio pesanan tiba tepat waktu.</div>
  </div>
  <div class="kpi-card expense">
    <div class="kpi-label">🛡️ Reject Rate Vendor</div>
    <div class="kpi-value">{idFormat(inv_macro_strategic[0].reject_rate_pct, 1)}%</div>
    <div class="kpi-meta">
      <span style="color: var(--color-text-primary); font-weight: 600;">Defect Quality</span>
    </div>
    <div class="kpi-prev">Porsi bahan baku cacat/rusak.</div>
  </div>
</div>
<div class="clean-cta-banner">
  <div class="clean-cta-content">
    <div class="clean-cta-icon">🔍</div>
    <div class="clean-cta-text">
      <h3 class="clean-cta-title">Eksplorasi Rantai Pasok & Analisis Supplier</h3>
      <p class="clean-cta-desc">Bedah lebih dalam tren pergerakan stok, efisiensi pengadaan bahan baku, dan evaluasi keandalan pemasok secara komprehensif.</p>
    </div>
  </div>
  <a href="/03-inventori-stok/analysis" class="clean-cta-button">
    Buka Analisis Supplier ➔
  </a>
</div>
</div>
{:else}
  <GlobalLoading />
{/if}
