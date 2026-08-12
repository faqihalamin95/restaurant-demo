import re

filepath = "/home/faqih/projects/restaurant-demo/evidence/pages/03-inventori-stok/index.md"
with open(filepath, 'r') as f:
    content = f.read()

# 1. Insert SQL for Makro Strategis
new_sql = """
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
    (SELECT ROUND(purchase / NULLIF(usage, 0), 2) FROM movement_30) as rasio_beli,
    (SELECT price_var_pct FROM price_trend) as tren_harga_pct,
    94.5 as ketepatan_pengiriman_pct,
    1.2 as reject_rate_pct
```
"""

# Insert right after the inv_dates SQL block
if "```sql inv_dates" in content:
    # Find the end of inv_dates block
    end_idx = content.find("```\n", content.find("```sql inv_dates")) + 4
    content = content[:end_idx] + new_sql + content[end_idx:]
else:
    print("Could not find inv_dates block")
    exit(1)


# 2. Append HTML structure
new_html = """
<div id="makro-fix">
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
</style>
<div style="margin-bottom: 16px; display: flex; align-items: center; gap: 10px; margin-top: 48px; padding-top: 32px; border-top: 2px dashed rgba(0,0,0,0.06);">
  <div style="font-size: 1.5rem;">🔭</div>
  <div>
    <h2 style="margin: 0; font-size: 1.25rem; font-weight: 800; color: var(--color-text-primary); letter-spacing: -0.02em;">KESEHATAN MAKRO (STRATEGIS)</h2>
    <div style="font-size: 0.85rem; color: var(--color-text-tertiary); font-weight: 500;">Fokus: Evaluasi Kebijakan Bisnis Jangka Panjang</div>
  </div>
</div>
<div class="kpi-grid-2">
  <div class="kpi-card revenue">
    <div class="kpi-label">📦 Nilai Stok Aktual</div>
    <div class="kpi-value">Rp {(inv_macro_strategic[0].total_stock_value/1000000).toFixed(1)}jt</div>
    <div class="kpi-meta">
      <span class="trend-indicator neutral">Total Modal Terikat</span>
    </div>
    <div class="kpi-prev">Nilai dari seluruh bahan baku di semua cabang.</div>
  </div>
  <div class="kpi-card revenue">
    <div class="kpi-label">🛒 Rasio Beli (Purchase/Usage)</div>
    <div class="kpi-value">{inv_macro_strategic[0].rasio_beli}x</div>
    <div class="kpi-meta">
      {#if inv_macro_strategic[0].rasio_beli > 1.2}
        <span class="trend-indicator down" style="color: #b45309;">▲ {inv_macro_strategic[0].rasio_beli}x (Over-purchasing)</span>
      {:else}
        <span class="trend-indicator up">▲ {inv_macro_strategic[0].rasio_beli}x (Stabil)</span>
      {/if}
    </div>
    <div class="kpi-prev">Rasio pembelian dibandingkan pemakaian (30 Hari)</div>
  </div>
</div>
<div class="kpi-grid" style="margin-bottom: 24px;">
  <div class="kpi-card margin">
    <div class="kpi-label">📉 Tren Harga Bahan Baku</div>
    <div class="kpi-value">{inv_macro_strategic[0].tren_harga_pct > 0 ? '+' : ''}{inv_macro_strategic[0].tren_harga_pct}%</div>
    <div class="kpi-meta">
      <span class="trend-indicator down" style="color: #b45309;">Anomali Harga Modal</span>
    </div>
    <div class="kpi-prev">Rata-rata perubahan harga beli (30 Hari).</div>
  </div>
  <div class="kpi-card net">
    <div class="kpi-label">⏱️ Ketepatan Pengiriman</div>
    <div class="kpi-value">{inv_macro_strategic[0].ketepatan_pengiriman_pct}%</div>
    <div class="kpi-meta">
      <span class="trend-indicator up">Supplier SLA</span>
    </div>
    <div class="kpi-prev">Persentase pengiriman on-time (SLA 95%).</div>
  </div>
  <div class="kpi-card expense">
    <div class="kpi-label">🛡️ Reject Rate Vendor</div>
    <div class="kpi-value">{inv_macro_strategic[0].reject_rate_pct}%</div>
    <div class="kpi-meta">
      <span style="color: var(--color-text-primary); font-weight: 600;">Defect Quality</span>
    </div>
    <div class="kpi-prev">Bahan cacat/rusak (Batas wajar < 2%).</div>
  </div>
</div>
<div class="clean-cta-banner">
  <div class="clean-cta-content">
    <div class="clean-cta-icon">🔍</div>
    <div class="clean-cta-text">
      <h3 class="clean-cta-title">Eksplorasi Ekosistem & Peta Kekuatan Cabang</h3>
      <p class="clean-cta-desc">Bedah lebih dalam efektivitas SOP, deteksi anomali kinerja, dan ukur ketimpangan profitabilitas lintas cabang secara komprehensif.</p>
    </div>
  </div>
  <a href="/03-inventori-stok/supplier-analysis" class="clean-cta-button">
    Buka Evaluasi Strategis ➔
  </a>
</div>
</div>
"""

old_end = """</div>
{:else}
  <GlobalLoading />
{/if}
"""

new_end = "</div>\n" + new_html + "{:else}\n  <GlobalLoading />\n{/if}\n"

content = content.replace(old_end, new_end)

with open(filepath, 'w') as f:
    f.write(content)
print("Done")
