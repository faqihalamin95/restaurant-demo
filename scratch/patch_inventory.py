import re

filepath = "/home/faqih/projects/restaurant-demo/evidence/pages/03-inventori-stok/index.md"
with open(filepath, 'r') as f:
    content = f.read()

# 1. Update SQL query
old_sql = """```sql inv_branch_health
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
        SUM(CASE WHEN COALESCE(l.stock_on_hand / NULLIF(m.avg_daily_usage, 0), l.days_remaining) < 3 THEN 1 ELSE 0 END) AS low_count,
        SUM(CASE WHEN COALESCE(l.stock_on_hand / NULLIF(m.avg_daily_usage, 0), l.days_remaining) > 14 THEN 1 ELSE 0 END) AS overstock_count,
        SUM(CASE WHEN COALESCE(l.stock_on_hand / NULLIF(m.avg_daily_usage, 0), l.days_remaining) > 14 THEN l.stock_value ELSE 0 END) / NULLIF(SUM(l.stock_value), 0) * 100 AS overstock_pct
    FROM latest l
    LEFT JOIN movement_item m ON l.item_name = m.item_name AND l.branch_name = m.branch_name
    GROUP BY 1
)
SELECT 
    b.branch_name, 
    COALESCE(b.low_count, 0) AS low_count,
    COALESCE(b.overstock_count, 0) AS overstock_count,
    COALESCE(b.overstock_pct, 0) AS overstock_pct
FROM branch_issues b
```"""

new_sql = """```sql inv_branch_health
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
        SUM(CASE WHEN COALESCE(l.stock_on_hand / NULLIF(m.avg_daily_usage, 0), l.days_remaining) < 3 THEN 1 ELSE 0 END) AS low_count,
        SUM(CASE WHEN COALESCE(l.stock_on_hand / NULLIF(m.avg_daily_usage, 0), l.days_remaining) > 14 THEN 1 ELSE 0 END) AS overstock_count,
        SUM(CASE WHEN COALESCE(l.stock_on_hand / NULLIF(m.avg_daily_usage, 0), l.days_remaining) > 14 THEN l.stock_value ELSE 0 END) / NULLIF(SUM(l.stock_value), 0) * 100 AS overstock_pct,
        SUM(l.stock_value) AS total_stock_value
    FROM latest l
    LEFT JOIN movement_item m ON l.item_name = m.item_name AND l.branch_name = m.branch_name
    GROUP BY 1
)
SELECT 
    b.branch_name, 
    COALESCE(b.low_count, 0) AS low_count,
    COALESCE(b.overstock_count, 0) AS overstock_count,
    COALESCE(ROUND(b.overstock_pct, 1), 0) AS overstock_pct,
    COALESCE(b.total_stock_value, 0) AS total_stock_value,
    CASE 
        WHEN COALESCE(b.low_count, 0) > 0 THEN 'Turnaround'
        WHEN COALESCE(b.overstock_pct, 0) > 30 THEN 'Waspada'
        WHEN COALESCE(b.overstock_pct, 0) > 20 THEN 'Stabil Rendah'
        ELSE 'Sehat'
    END AS health_status,
    CASE 
        WHEN COALESCE(b.low_count, 0) > 0 THEN 'Terdapat ' || b.low_count || ' item dengan sisa < 3 hari. Risiko sold out tinggi, segera restock.'
        WHEN COALESCE(b.overstock_pct, 0) > 30 THEN 'Porsi overstock sangat tinggi (' || ROUND(b.overstock_pct, 1) || '%). Kurangi pemesanan baru untuk menjaga cashflow.'
        WHEN COALESCE(b.overstock_pct, 0) > 20 THEN 'Ada sedikit potensi overstock (' || ROUND(b.overstock_pct, 1) || '%). Pantau pergerakan item slow-moving.'
        ELSE 'Kondisi stok sangat baik. Distribusi dan coverage hari aman.'
    END AS diagnosis
FROM branch_issues b
```"""

content = content.replace(old_sql, new_sql)


# 2. Add CSS
css_to_add = """
.branch-health-grid { display: grid; gap: 16px; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); }
/* ── Branch Health Card Hover ── */
.branch-health-card {
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
  cursor: pointer;
  padding: 16px;
  border-radius: 16px;
  border: 1px solid var(--color-border-tertiary);
  background: var(--color-background-primary);
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

.branch-health-card.stabil-rendah:hover {
  border-color: rgba(245, 158, 11, 0.48) !important;
  background: linear-gradient(160deg, rgba(245, 158, 11, 0.1), rgba(251, 191, 36, 0.04)) !important;
}

.branch-health-card.turnaround:hover {
  border-color: rgba(239, 68, 68, 0.5) !important;
  background: linear-gradient(160deg, rgba(239, 68, 68, 0.14), rgba(220, 38, 38, 0.06)) !important;
}

.branch-card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 8px;
  flex-wrap: wrap;
  padding-bottom: 8px;
  border-bottom: 1px dashed rgba(128, 128, 128, 0.15);
}

.branch-card-name { font-weight: 800; font-size: 1.1rem; color: var(--color-text-primary); }
.branch-status-badge { font-size: 0.75rem; font-weight: 700; padding: 2px 8px; border-radius: 999px; }
.branch-status-badge.sehat { background: rgba(22, 163, 74, 0.1); color: #16a34a; }
.branch-status-badge.waspada { background: rgba(245, 158, 11, 0.1); color: #f59e0b; }
.branch-status-badge.early-warning { background: rgba(249, 115, 22, 0.1); color: #f97316; }
.branch-status-badge.stabil-rendah { background: rgba(245, 158, 11, 0.1); color: #f59e0b; }
.branch-status-badge.turnaround { background: rgba(239, 68, 68, 0.1); color: #ef4444; }

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

.branch-margin-main { font-size: 1.8rem; font-weight: 800; line-height: 1.1; }
.branch-margin-main.sehat { color: #16a34a; }
.branch-margin-main.waspada { color: #f59e0b; }
.branch-margin-main.early-warning { color: #f97316; }
.branch-margin-main.stabil-rendah { color: #f59e0b; }
.branch-margin-main.turnaround { color: #ef4444; }

.branch-margin-label { font-size: 0.75rem; color: var(--color-text-secondary); font-weight: 600; margin-top: 2px;}

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

.benchmark-label { font-weight: 500; }
.benchmark-val { color: var(--color-text-primary); font-weight: 700; }

.branch-stats-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 8px;
  margin: 4px 0;
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
  font-size: 0.85rem;
  font-weight: 700;
  color: var(--color-text-primary);
}
.stat-value.text-up { color: #16a34a !important; }
.stat-value.text-down { color: #dc2626 !important; }

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
  margin-top: 12px;
}

.branch-diagnosis-box.sehat { background: rgba(22, 163, 74, 0.04); border-color: rgba(22, 163, 74, 0.12); border-left-color: #16a34a; }
.branch-diagnosis-box.waspada { background: rgba(245, 158, 11, 0.04); border-color: rgba(245, 158, 11, 0.12); border-left-color: #f59e0b; }
.branch-diagnosis-box.early-warning { background: rgba(249, 115, 22, 0.04); border-color: rgba(249, 115, 22, 0.12); border-left-color: #f97316; }
.branch-diagnosis-box.stabil-rendah { background: rgba(245, 158, 11, 0.03); border-color: rgba(245, 158, 11, 0.08); border-left-color: #f59e0b; }
.branch-diagnosis-box.turnaround { background: rgba(239, 68, 68, 0.04); border-color: rgba(239, 68, 68, 0.12); border-left-color: #ef4444; }
.diagnosis-icon { font-size: 0.85rem; margin-top: 1px; }
"""

css_target = "</style>"
content = content.replace(css_target, css_to_add + "\n" + css_target)


# 3. Add HTML
html_to_add = """
  <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 8px; border-top: 1px dashed rgba(0,0,0,0.15); padding-top: 24px; margin-top: 24px;">
    <div style="font-size: 2rem;">📋</div>
    <div>
      <h2 style="margin: 0; font-size: 1.25rem; font-weight: 800; color: var(--color-text-primary); letter-spacing: -0.02em; text-transform: uppercase;">STATUS KESEHATAN & AUDIT STOK PER CABANG</h2>
      <div style="font-size: 0.85rem; color: var(--color-text-tertiary); font-weight: 500;">Fokus: Analisis ketersediaan bahan dan overstock per cabang. Klik untuk detail.</div>
    </div>
  </div>

  <div class="branch-health-grid" style="margin-top: 4px; margin-bottom: 32px;">
    {#each inv_branch_health as row}
      {@const branchStatusClass = row.health_status === 'Sehat' ? 'sehat' : row.health_status === 'Waspada' ? 'waspada' : row.health_status === 'Turnaround' ? 'turnaround' : 'stabil-rendah'}
      
      <a href="/03-inventori-stok/deepdive?branch={row.branch_name}" class="branch-health-card {branchStatusClass}" style="text-decoration: none; display: block;">
        <div class="branch-card-header">
          <span class="branch-card-name">{row.branch_name}</span>
          <span class="branch-status-badge {branchStatusClass}">
            {row.health_status === 'Sehat' ? '✅' : row.health_status === 'Waspada' ? '⚠️' : row.health_status === 'Turnaround' ? '🚨' : '🟡'} {row.health_status}
          </span>
        </div>

        <div class="branch-margin-section">
          <div class="branch-margin-active-box">
            <div class="branch-margin-main {branchStatusClass}">{row.overstock_pct}%</div>
            <div class="branch-margin-label">Porsi Overstock</div>
          </div>

          <div class="branch-margin-benchmarks">
            <div class="benchmark-item">
              <span class="benchmark-label">Item Low</span>
              <strong class="benchmark-val" style={row.low_count > 0 ? "color: #dc2626;" : "color: #16a34a;"}>{row.low_count}</strong>
            </div>
            <div class="benchmark-item">
              <span class="benchmark-label">Item Over</span>
              <strong class="benchmark-val">{row.overstock_count}</strong>
            </div>
          </div>
        </div>

        <div class="branch-stats-grid">
          <div class="stat-pill">
            <span class="stat-label">Total Nilai</span>
            <span class="stat-value">Rp {(row.total_stock_value/1000000).toFixed(1)}jt</span>
          </div>
          <div class="stat-pill">
            <span class="stat-label">Item Kritis</span>
            <span class="stat-value {row.low_count > 0 ? 'text-down' : 'text-up'}">{row.low_count} Item</span>
          </div>
        </div>

        <div class="branch-diagnosis-box {branchStatusClass}">
          <div class="diagnosis-icon">💡</div>
          <div class="diagnosis-text">{row.diagnosis}</div>
        </div>
      </a>
    {/each}
  </div>
"""

html_target = """        </div>
      </div>
    </div>
  </div>"""

content = content.replace(html_target, html_target + "\n" + html_to_add)

with open(filepath, 'w') as f:
    f.write(content)
print("Done")
