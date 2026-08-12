import re

with open('/home/faqih/projects/restaurant-demo/evidence/pages/03-inventori-stok/index.md', 'r') as f:
    content = f.read()

# Add inv_branch_health query
query = """```sql inv_branch_health
WITH max_d AS (SELECT MAX(txn_date)::DATE AS d FROM restaurant.inventory_stok),
branch_low AS (
    SELECT branch_name, COUNT(*) AS low_count
    FROM restaurant.inventory_stok CROSS JOIN max_d
    WHERE txn_date = d AND (stock_status = 'low' OR days_remaining < 3)
    GROUP BY 1
),
all_branches AS (
    SELECT DISTINCT branch_name FROM restaurant.inventory_stok
)
SELECT 
    a.branch_name, 
    COALESCE(b.low_count, 0) AS low_count
FROM all_branches a
LEFT JOIN branch_low b ON a.branch_name = b.branch_name
```
"""

# Insert query after inv_stock_value_by_category
content = re.sub(r'(```sql inv_stock_value_by_category.*?```\n)', r'\1\n' + query, content, flags=re.DOTALL)

new_hero = """
{@const totalBranches = inv_branch_health.length}
{@const healthyBranches = inv_branch_health.filter(b => b.low_count === 0).length}
{@const heroStatusClass = healthyBranches === totalBranches ? 'status-sehat' : healthyBranches >= Math.ceil(totalBranches/2) ? 'status-biru' : healthyBranches > 0 ? 'status-waspada' : 'status-kritis'}
{@const overstockVal = (inv_inventory_overview[0]?.overstock_value ?? 0)}
{@const overstockPct = (inv_inventory_overview[0]?.overstock_value_pct ?? 0)}
{@const lowItems = (inv_inventory_overview[0]?.low_items ?? 0)}

<style>
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
}
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
}
.hero-side-note {
  font-size: 0.78rem;
  line-height: 1.45;
  color: var(--color-text-secondary);
  margin-top: 4px;
}
</style>

  <div class="hero" style="margin-top: 10px;">
    <div class="hero-eyebrow">📊 Inventori & Stok · Snapshot Aktual</div>
    <div class="hero-grid">
      <div class="hero-main-card {heroStatusClass}">
        <div class="hero-stat-number">{healthyBranches}/{totalBranches}</div>
        <div class="hero-stat-label">stok cabang sehat</div>
        <div class="hero-subtitle">
          {#if healthyBranches === totalBranches}
            Stok sehat di seluruh cabang. Tidak ada item rawan habis.
          {:else if healthyBranches >= Math.ceil(totalBranches/2)}
            Mayoritas cabang dalam kondisi stok aman dan siap operasional.
          {:else}
            Sebagian besar cabang mengalami kelangkaan bahan baku.
          {/if}
        </div>
      </div>
      <div class="hero-side">
        <div class="hero-side-card">
          <div class="hero-side-label">💰 Modal Tertahan (Overstock)</div>
          <div class="hero-side-value">Rp {(overstockVal/1000000).toFixed(1)}jt <span style="font-size:0.85rem;font-weight:600;color:var(--color-text-secondary);">({overstockPct}%)</span></div>
          <div class="hero-side-note">Alokasi modal yang berpotensi mandek atau waste. Usahakan porsi di bawah 25% dari total nilai stok.</div>
        </div>
        <div class="hero-side-card">
          <div class="hero-side-label">⚠️ Ketersediaan Bahan (Low Stock)</div>
          <div class="hero-side-value">{lowItems} Item Kritis</div>
          <div class="hero-side-note">Item dengan coverage &lt;3 hari. Prioritas utama pengadaan untuk menghindari menu <i>sold out</i>.</div>
        </div>
      </div>
    </div>
  </div>
"""

# Replace old inv-hero
content = re.sub(r'<div class="inv-hero">.*?</div>\n    </div>\n  </div>', new_hero, content, flags=re.DOTALL)

with open('/home/faqih/projects/restaurant-demo/evidence/pages/03-inventori-stok/index.md', 'w') as f:
    f.write(content)
