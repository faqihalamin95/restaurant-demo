import re

filepath = "/home/faqih/projects/restaurant-demo/evidence/pages/03-inventori-stok/index.md"
with open(filepath, 'r') as f:
    content = f.read()

# Update SQL
old_sql_select = """SELECT 
    (SELECT total_stock_value FROM stock_val) as total_stock_value,"""

new_sql_select = """SELECT 
    (SELECT total_stock_value FROM stock_val) as total_stock_value,
    (SELECT purchase FROM movement_30) as total_purchase_30d,"""
content = content.replace(old_sql_select, new_sql_select)

# Update HTML Card
old_card = """  <div class="kpi-card revenue">
    <div class="kpi-label">📦 Nilai Stok Aktual</div>
    <div class="kpi-value">Rp {idFormat(inv_macro_strategic[0].total_stock_value/1000000, 1)}jt</div>
    <div class="kpi-meta">
      <span class="trend-indicator neutral">Total Modal Terikat</span>
    </div>
    <div class="kpi-prev">Nilai dari seluruh bahan baku di semua cabang.</div>
  </div>"""

new_card = """  <div class="kpi-card revenue">
    <div class="kpi-label">💸 Total Pengeluaran Beli</div>
    <div class="kpi-value">Rp {idFormat(inv_macro_strategic[0].total_purchase_30d/1000000, 1)}jt</div>
    <div class="kpi-meta">
      <span class="trend-indicator neutral">Pembelian (30 Hari)</span>
    </div>
    <div class="kpi-prev">Nilai uang yang dikeluarkan untuk pengadaan bahan dalam 30H terakhir.</div>
  </div>"""
content = content.replace(old_card, new_card)

with open(filepath, 'w') as f:
    f.write(content)
print("Done")
