---
title: Inventory & Stock
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
  function usFormat(num, dec = 0) {
    if (num === null || num === undefined) return '0';
    return new Intl.NumberFormat('en-US', { minimumFractionDigits: dec, maximumFractionDigits: dec }).format(num);
  }
  import PremiumTable from '$lib/PremiumTable.svelte';

  $: donutData = (typeof inv_inventory_overview !== 'undefined' && inv_inventory_overview.length > 0 && typeof inv_branch_health !== 'undefined' && typeof inv_dates !== 'undefined' && typeof inv_stock_value_by_category !== 'undefined' && typeof inv_stock_transfer !== 'undefined') ? Array.from(inv_stock_value_by_category || []).map(r => ({ value: r.overstock_value, name: r.category })).filter(d => d.value > 0) : [];
  
  $: donutConfig = {
    tooltip: { 
      trigger: 'item',
      formatter: function(params) {
        return params.name + ': Rp ' + Number(params.value).toLocaleString('en-US') + ' (' + params.percent + '%)';
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
FROM restaurant.inventory_stock
```

```sql inv_macro_strategic
WITH max_d AS (SELECT MAX(txn_date)::DATE AS d FROM restaurant.inventory_stock),
latest AS (
    SELECT * FROM (
        SELECT *, ROW_NUMBER() OVER(PARTITION BY branch_name, item_name ORDER BY txn_date DESC) as rn
        FROM restaurant.inventory_stock
    ) WHERE rn = 1
),
stock_val AS (
    SELECT SUM(stock_value) as total_stock_value FROM latest
),
movement_30 AS (
    SELECT SUM(purchase_cost) as purchase, SUM(usage_cost) as usage
    FROM restaurant.inventory_stock CROSS JOIN max_d
    WHERE txn_date >= d - INTERVAL '29 days'
),
price_trend AS (
    SELECT ROUND(AVG(CASE WHEN base_unit_cost > 0 THEN (avg_unit_cost - base_unit_cost)/base_unit_cost*100 ELSE 0 END), 1) as price_var_pct
    FROM restaurant.inventory_stock CROSS JOIN max_d
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
    SELECT MAX(txn_date)::DATE AS d FROM restaurant.inventory_stock
),
latest AS (
    SELECT * FROM (
        SELECT *, ROW_NUMBER() OVER(PARTITION BY branch_name, item_name ORDER BY txn_date DESC) as rn
        FROM restaurant.inventory_stock
    ) WHERE rn = 1
),
movement_7 AS (
    SELECT
        SUM(usage_cost) AS usage_cost_7d,
        SUM(purchase_cost) AS purchase_cost_7d
    FROM restaurant.inventory_stock CROSS JOIN max_d
    WHERE txn_date >= d - INTERVAL '6 days'
),
movement_30 AS (
    SELECT
        SUM(usage_cost) AS usage_cost_30d,
        SUM(purchase_cost) AS purchase_cost_30d,
        ROUND(SUM(purchase_cost)/NULLIF(SUM(usage_cost),0),2) AS purchase_usage_ratio_30d
    FROM restaurant.inventory_stock CROSS JOIN max_d
    WHERE txn_date >= d - INTERVAL '29 days'
),
price_30 AS (
    SELECT
        ROUND(AVG(CASE WHEN base_unit_cost > 0 THEN (avg_unit_cost-base_unit_cost)/base_unit_cost*100 END),1) AS avg_price_variance_pct,
        COUNT(DISTINCT CASE WHEN base_unit_cost > 0 AND (avg_unit_cost-base_unit_cost)/base_unit_cost*100 > 10 THEN item_name END) AS price_alert_items
    FROM restaurant.inventory_stock CROSS JOIN max_d
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
        FROM restaurant.inventory_stock CROSS JOIN max_d
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
        WHEN s.low_points > 0 THEN 'Critical'
        WHEN s.overstock_value / NULLIF(s.stock_value,0) > 0.25 OR p.price_alert_items > 0 OR m30.purchase_usage_ratio_30d > 1.3 THEN 'Warning'
        ELSE 'Healthy'
    END AS health_status,
    CASE
        WHEN s.low_points > 0 THEN 'There are items nearing depletion. First priority is to prevent unsellable menu items.'
        WHEN s.overstock_value / NULLIF(s.stock_value,0) > 0.25 THEN 'Capital is starting to be held up in overstock. Check the Overstock tab for specific items and branches.'
        WHEN p.price_alert_items > 0 THEN 'Supplier prices are starting to pressure ingredient costs. Check the Supplier tab for negotiation priorities.'
        WHEN m30.purchase_usage_ratio_30d > 1.3 THEN 'Purchases are faster than usage. Procurement schedule needs review.'
        ELSE 'Actual stock, usage rhythm, and price pressure are still under control.'
    END AS diagnosis
FROM summary s, movement_7 m7, movement_30 m30, price_30 p
```

```sql inv_purchase_vs_usage_branch
WITH max_d AS (SELECT MAX(txn_date)::DATE AS d FROM restaurant.inventory_stock)
SELECT
    branch_name,
    SUM(purchase_cost) AS "Purchase 30D",
    SUM(usage_cost) AS "Usage 30D",
    ROUND(SUM(purchase_cost)/NULLIF(SUM(usage_cost),0),2) AS ratio
FROM restaurant.inventory_stock CROSS JOIN max_d
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
    FROM restaurant.inventory_stock
) latest
WHERE rn = 1 AND base_unit_cost > 0
GROUP BY category, item_name
ORDER BY price_increase_pct DESC
```

```sql inv_heatmap_low
WITH max_d AS (SELECT MAX(txn_date)::DATE AS d FROM restaurant.inventory_stock),
latest AS (
    SELECT * FROM (
        SELECT *, ROW_NUMBER() OVER(PARTITION BY branch_name, item_name ORDER BY txn_date DESC) as rn
        FROM restaurant.inventory_stock
    ) WHERE rn = 1
),
movement_item AS (
    SELECT branch_name, item_name, ROUND(SUM(usage_qty)/30,2) AS avg_daily_usage
    FROM restaurant.inventory_stock CROSS JOIN max_d
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
WITH max_d AS (SELECT MAX(txn_date)::DATE AS d FROM restaurant.inventory_stock),
latest AS (
    SELECT * FROM (
        SELECT *, ROW_NUMBER() OVER(PARTITION BY branch_name, item_name ORDER BY txn_date DESC) as rn
        FROM restaurant.inventory_stock
    ) WHERE rn = 1
),
movement_item AS (
    SELECT branch_name, item_name, ROUND(SUM(usage_qty)/30,2) AS avg_daily_usage
    FROM restaurant.inventory_stock CROSS JOIN max_d
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
WITH max_d AS (SELECT MAX(txn_date)::DATE AS d FROM restaurant.inventory_stock),
latest AS (
    SELECT * FROM (
        SELECT *, ROW_NUMBER() OVER(PARTITION BY branch_name, item_name ORDER BY txn_date DESC) as rn
        FROM restaurant.inventory_stock
    ) WHERE rn = 1
),
movement_item AS (
    SELECT branch_name, item_name, ROUND(SUM(usage_qty)/30,2) AS avg_daily_usage
    FROM restaurant.inventory_stock CROSS JOIN max_d
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
        STRING_AGG(CASE WHEN COALESCE(l.stock_on_hand / NULLIF(m.avg_daily_usage, 0), l.days_remaining) < 2 AND (LOWER(l.item_name) LIKE '%ayam%' OR LOWER(l.item_name) LIKE '%daging%' OR LOWER(l.item_name) LIKE '%beras%' OR LOWER(l.item_name) LIKE '%minyak%' OR LOWER(l.item_name) LIKE '%lpg%') THEN l.item_name END, ', ') AS core_low_items,
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
    FROM restaurant.inventory_stock CROSS JOIN max_d
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
        WHEN COALESCE(b.core_low_count, 0) > 0 THEN 'Critical'
        WHEN COALESCE(b.low_pct, 0) >= 15 THEN 'Critical'
        WHEN COALESCE(b.low_pct, 0) > 0 THEN 'Warning'
        WHEN COALESCE(b.overstock_pct, 0) > 30 THEN 'Warning'
        WHEN COALESCE(b.overstock_pct, 0) > 20 THEN 'Early Warning'
        ELSE 'Healthy'
    END AS health_status,
    CASE 
        WHEN COALESCE(b.core_low_count, 0) > 0 THEN '<strong>CRITICAL EMERGENCY:</strong> ' || b.core_low_count || ' core ingredients (' || b.core_low_items || ') have <2 days of coverage remaining. Imminent risk of menu item stockouts today.'
        WHEN COALESCE(b.low_pct, 0) >= 15 THEN '<strong>HIGH RISK:</strong> ' || b.low_count || ' ingredients (' || ROUND(b.low_pct, 1) || '%) are under 3 days of operational runway. Immediate PO issuance required to avoid supply disruptions.'
        WHEN COALESCE(b.low_pct, 0) > 0 THEN '<strong>LOW STOCK WARNING:</strong> ' || b.low_count || ' ingredients (' || ROUND(b.low_pct, 1) || '%) are below safety thresholds. Monitor depletion rates to ensure service continuity.'
        WHEN COALESCE(b.overstock_pct, 0) > 30 THEN '<strong>CAPITAL RISK:</strong> Overstock exposure reached ' || ROUND(b.overstock_pct, 1) || '% of total inventory value. Freeze new purchase orders to optimize working capital.'
        WHEN COALESCE(b.overstock_pct, 0) > 20 THEN '<strong>ELEVATED HOLDING:</strong> Minor overstock detected (' || ROUND(b.overstock_pct, 1) || '% of inventory value). Review slow-moving inventory to mitigate spoilage risk.'
        ELSE '<strong>OPTIMAL STATUS:</strong> Inventory is well-balanced across all categories. Stock coverage and reorder points are within target SLAs.'
    END AS diagnosis
FROM branch_issues b
LEFT JOIN branch_purchases bp ON b.branch_name = bp.branch_name
```

```sql inv_stock_transfer
/*
  PIPELINE MUTASI STOK ANTAR CABANG
  Mencari bahan baku yang kritis di satu location (stock < 3 hari)
  namun melimpah / aman di location lain (> 7 hari).
  *Menggunakan perhitungan 'calculated_days' (sisa hari dinamis)
  agar tersinkronisasi dengan subpage location.
*/
WITH max_d AS (SELECT MAX(txn_date)::DATE AS d FROM restaurant.inventory_stock),
latest AS (
    SELECT * FROM (
        SELECT *, ROW_NUMBER() OVER(PARTITION BY branch_name, item_name ORDER BY txn_date DESC) as rn
        FROM restaurant.inventory_stock
    ) WHERE rn = 1
),
movement_item AS (
    SELECT
        branch_name,
        item_name,
        ROUND(SUM(usage_qty)/30,2) AS avg_daily_usage
    FROM restaurant.inventory_stock CROSS JOIN max_d
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
    l.branch_name AS location_butuh,
    CASE 
        WHEN l.calculated_days < 1 THEN '< 1 Day'
        WHEN l.calculated_days < 2 THEN '< 2 Days'
        WHEN l.calculated_days < 3 THEN '< 3 Days'
        ELSE CAST(FLOOR(l.calculated_days) AS INT) || ' Days'
    END AS sisa_hari_butuh,
    s.branch_name AS location_donor,
    CAST(FLOOR(s.calculated_days) AS INT) || ' Days' AS sisa_hari_donor,
    '🟢 Send stock from ' || s.branch_name || ' to ' || l.branch_name AS aksi
FROM low_stock l
JOIN safe_stock s ON l.item_name = s.item_name
ORDER BY l.calculated_days ASC
```

<InvGuide />
<InvTabs activeTab="ringkasan" />


{#if typeof inv_inventory_overview !== 'undefined' && inv_inventory_overview.length > 0 && typeof inv_branch_health !== 'undefined' && typeof inv_dates !== 'undefined' && typeof inv_stock_value_by_category !== 'undefined' && typeof inv_stock_transfer !== 'undefined'}
{@const totalBranches = inv_branch_health.length}
{@const healthyBranches = inv_branch_health.filter(b => b.health_status !== 'Critical').length}
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
    <div class="hero-eyebrow">📦 Inventory & Stock Diagnostics · Snapshot {inv_dates[0].tgl_akhir}</div>
    <div class="hero-grid">
      <div class="hero-main-card {heroStatusClass}">
        <div class="hero-stat-number">{healthyBranches}/{totalBranches}</div>
        <div class="hero-stat-label">Locations Meeting Stock SLAs</div>
        <div class="hero-subtitle">
          {#if healthyBranches === totalBranches}
            All locations are within operational safety thresholds. No active stockout risks detected.
          {:else if healthyBranches >= Math.ceil(totalBranches/2)}
            Most locations are operating within target thresholds. Priority intervention required for critical branches.
          {:else}
            Widespread stock failure detected across multiple locations. Immediate supply chain remediation required.
          {/if}
        </div>
      </div>
      
      <div class="hero-side">
        <div class="hero-side-card">
          <div class="hero-side-label">💰 Tied-Up Capital (Overstock)</div>
          <div class="hero-side-value" style="font-size: 1.15rem; font-weight: 800;">Rp {(overstockVal/1000000).toFixed(1)}M <span style="font-size:0.85rem;font-weight:600;color:inherit;opacity:0.8;">({overstockPct}%)</span></div>
          <div class="hero-side-note">Capital locked in excess inventory. Target holding under 25% of total stock valuation to mitigate spoilage risk.</div>
        </div>
        
        <div class="hero-side-card">
          <div class="hero-side-label">⚠️ Stockout Exposure (Critical Items)</div>
          <div class="hero-side-value" style="font-size: 1.15rem; font-weight: 800;">{lowItems} Ingredients</div>
          <div class="hero-side-note">Ingredients with &lt;3 days of operational runway. High-priority reorder required to prevent menu item stockouts.</div>
        </div>
      </div>
    </div>
  </div>

  <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 8px; border-top: 1px dashed rgba(0,0,0,0.15); padding-top: 24px; margin-top: 24px;">
    <div style="font-size: 2rem;">📋</div>
    <div>
      <h2 style="margin: 0; font-size: 1.25rem; font-weight: 800; color: var(--color-text-primary); letter-spacing: -0.02em; text-transform: uppercase;">
        BRANCH STOCK HEALTH MONITOR
      </h2>
      <div style="font-size: 0.85rem; color: var(--color-text-tertiary); font-weight: 500;">
        Evaluates stock availability, depletion risks, and overstock exposure per location. Select a branch to drill down into itemized stock records.
      </div>
    </div>
  </div>

  <div class="branch-health-grid" style="margin-top: 4px; margin-bottom: 32px;">
    {#each inv_branch_health as row}
      {@const branchStatusClass = row.health_status === 'Healthy' ? 'sehat' : row.health_status === 'Warning' ? 'waspada' : row.health_status === 'Early Warning' ? 'recovery' : 'turnaround'}
      
      <a href="/03-inventory/02-deepdive?branch={row.branch_name}" class="branch-health-card {branchStatusClass}" style="text-decoration: none; display: block;">
        <div class="branch-card-header">
          <span class="branch-card-name">{row.branch_name}</span>
          <span class="branch-status-badge {branchStatusClass}">
            {row.health_status === 'Healthy' ? '✅' : row.health_status === 'Warning' ? '⚠️' : row.health_status === 'Early Warning' ? '🚧' : '🚨'} {row.health_status}
          </span>
        </div>

        <div class="branch-margin-section">
          <div class="branch-margin-active-box" style="display: flex; flex-direction: column; align-items: center; justify-content: center; text-align: center;">
            <div class="branch-margin-main {branchStatusClass}">{row.healthy_count}/{row.total_items}</div>
            <div class="branch-margin-label">Healthy Items</div>
          </div>

          <div class="branch-margin-benchmarks">
            <div class="benchmark-item">
              <span class="benchmark-label">Stock Value</span>
              <strong class="benchmark-val">Rp {usFormat(row.total_stock_value/1000000, 1)}M</strong>
            </div>
            <div class="benchmark-item">
              <span class="benchmark-label">Overstock</span>
              <strong class="benchmark-val" style={row.overstock_value > 0 ? "color: #dc2626;" : ""}>Rp {usFormat(row.overstock_value/1000000, 1)}M</strong>
            </div>
            <div style="border-bottom: 1px dashed rgba(128, 128, 128, 0.25); margin: 2px 0;"></div>
            <div class="benchmark-item">
              <span class="benchmark-label">Purchase Ratio</span>
              <strong class="benchmark-val" style={row.purchase_ratio > 1.2 ? "color: #dc2626;" : ""}>{usFormat(row.purchase_ratio, 2)}x</strong>
            </div>
          </div>
        </div>

        <div class="branch-stats-grid">
          <div class="stat-pill">
            <span class="stat-label">Lowstock</span>
            <span class="stat-value {row.low_count > 0 ? 'text-down' : 'text-up'}">{row.low_count} Items</span>
          </div>
          <div class="stat-pill">
            <span class="stat-label">Overstock</span>
            <span class="stat-value {row.overstock_count > 0 ? 'text-down' : 'text-up'}">{row.overstock_count} Items</span>
          </div>
        </div>

        <div class="branch-diagnosis-box {branchStatusClass}">
          <div class="diagnosis-icon">💡</div>
          <div class="diagnosis-text">{@html row.diagnosis}</div>
        </div>
      </a>
    {/each}
  </div>


</div>

<div id="makro-fix">

<div style="margin-bottom: 16px; display: flex; align-items: center; gap: 10px; margin-top: 48px; padding-top: 32px; border-top: 2px dashed rgba(0,0,0,0.06);">
  <div style="font-size: 1.5rem;">🔭</div>
  <div>
    <h2 style="margin: 0; font-size: 1.25rem; font-weight: 800; color: var(--color-text-primary); letter-spacing: -0.02em;">
      STRATEGIC HEALTH METRICS
    </h2>
    <div style="font-size: 0.85rem; color: var(--color-text-tertiary); font-weight: 500;">
      Evaluates portfolio-wide capital efficiency, purchase-to-usage thresholds, and long-term supply chain policy adherence.
    </div>
  </div>
</div>
<div class="kpi-grid-2">
  <div class="kpi-card revenue">
    <div class="kpi-label">💸 Gross Procurement Spend</div>
    <div class="kpi-value">Rp {usFormat(inv_macro_strategic[0].total_purchase_30d/1000000, 1)}M</div>
    <div class="kpi-meta">
      <span class="trend-indicator neutral">Trailing 30 Days</span>
    </div>
    <div class="kpi-prev">Total raw material spend across all branches.</div>
  </div>
  <div class="kpi-card revenue">
    <div class="kpi-label">🛒 Purchase-to-Usage Ratio</div>
    <div class="kpi-value">{usFormat(inv_macro_strategic[0].rasio_beli, 2)}x</div>
    <div class="kpi-meta">
      <span class="trend-indicator neutral">Ideal Benchmark: 0.95x – 1.05x</span>
    </div>
    <div class="kpi-prev">Procurement vs. kitchen consumption rate.</div>
  </div>
</div>
<div class="kpi-grid" style="margin-bottom: 24px;">
  <div class="kpi-card margin">
    <div class="kpi-label">📈 Raw Material Price Volatility</div>
    <div class="kpi-value">{inv_macro_strategic[0].tren_harga_pct > 0 ? '+' : ''}{usFormat(inv_macro_strategic[0].tren_harga_pct, 1)}%</div>
    <div class="kpi-meta">
      <span class="trend-indicator down" style="color: #b45309;">PPV (30 Days)</span>
    </div>
    <div class="kpi-prev">Avg. unit cost inflation across key ingredients.</div>
  </div>
  <div class="kpi-card net">
    <div class="kpi-label">⏱️ On-Time Delivery (OTD) Rate</div>
    <div class="kpi-value">{usFormat(inv_macro_strategic[0].ketepatan_pengiriman_pct, 1)}%</div>
    <div class="kpi-meta">
      <span class="trend-indicator up">SLA Benchmark: &gt;95%</span>
    </div>
    <div class="kpi-prev">Vendor orders arrived within lead time.</div>
  </div>
  <div class="kpi-card expense">
    <div class="kpi-label">🛡️ Inbound Rejection Rate</div>
    <div class="kpi-value">{usFormat(inv_macro_strategic[0].reject_rate_pct, 1)}%</div>
    <div class="kpi-meta">
      <span style="color: var(--color-text-primary); font-weight: 600;">SLA Benchmark: &lt;2%</span>
    </div>
    <div class="kpi-prev">Deliveries rejected due to quality defects.</div>
  </div>
</div>
<div class="clean-cta-banner">
  <div class="clean-cta-content">
    <div class="clean-cta-icon">🔍</div>
    <div class="clean-cta-text">
      <h3 class="clean-cta-title">Supplier & Procurement Analytics</h3>
      <p class="clean-cta-desc">Audit price variance trends, evaluate vendor OTIF performance, and optimize ingredient procurement costs.</p>
    </div>
  </div>
  <a href="/03-inventory/03-analysis" class="clean-cta-button">
    Explore Supplier Analytics ➔
  </a>
</div>
</div>
{:else}
  <GlobalLoading />
{/if}
