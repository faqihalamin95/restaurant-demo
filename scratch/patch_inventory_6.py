import re

filepath = "/home/faqih/projects/restaurant-demo/evidence/pages/03-inventori-stok/index.md"
with open(filepath, 'r') as f:
    content = f.read()

# 1. Remove border-bottom from .branch-card-header
old_css_header = """.branch-card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 8px;
  flex-wrap: wrap;
  padding-bottom: 8px;
  border-bottom: 1px dashed rgba(128, 128, 128, 0.15);
}"""

new_css_header = """.branch-card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 8px;
  flex-wrap: wrap;
  padding-bottom: 8px;
}"""
content = content.replace(old_css_header, new_css_header)


# 2. Update the HTML block to remove the bottom dashline and the extra pills
old_html = """        <div class="branch-margin-section" style="border-bottom: 1px dashed rgba(128, 128, 128, 0.15); margin-bottom: 8px; padding-bottom: 12px;">
          <div class="branch-margin-active-box" style="display: flex; flex-direction: column; align-items: center; justify-content: center; text-align: center;">
            <div class="branch-margin-main {branchStatusClass}">{row.healthy_count}/{row.total_items}</div>
            <div class="branch-margin-label">Item Sehat</div>
          </div>

          <div class="branch-margin-benchmarks">
            <div class="benchmark-item">
              <span class="benchmark-label">Nilai Stok</span>
              <strong class="benchmark-val">Rp {(row.total_stock_value/1000000).toFixed(1)}jt</strong>
            </div>
            <div class="benchmark-item">
              <span class="benchmark-label">Nilai Overstok</span>
              <strong class="benchmark-val" style={row.overstock_value > 0 ? "color: #dc2626;" : ""}>Rp {(row.overstock_value/1000000).toFixed(1)}jt</strong>
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
          <div class="stat-pill">
            <span class="stat-label">Beli (30H)</span>
            <span class="stat-value">Rp {(row.purchase_cost/1000000).toFixed(1)}jt</span>
          </div>
          <div class="stat-pill">
            <span class="stat-label">Rasio Beli</span>
            <span class="stat-value {row.purchase_ratio > 1.2 ? 'text-down' : 'text-up'}">{row.purchase_ratio}x</span>
          </div>
        </div>"""

new_html = """        <div class="branch-margin-section">
          <div class="branch-margin-active-box" style="display: flex; flex-direction: column; align-items: center; justify-content: center; text-align: center;">
            <div class="branch-margin-main {branchStatusClass}">{row.healthy_count}/{row.total_items}</div>
            <div class="branch-margin-label">Item Sehat</div>
          </div>

          <div class="branch-margin-benchmarks">
            <div class="benchmark-item">
              <span class="benchmark-label">Nilai Stok</span>
              <strong class="benchmark-val">Rp {(row.total_stock_value/1000000).toFixed(1)}jt</strong>
            </div>
            <div class="benchmark-item">
              <span class="benchmark-label">Nilai Overstok</span>
              <strong class="benchmark-val" style={row.overstock_value > 0 ? "color: #dc2626;" : ""}>Rp {(row.overstock_value/1000000).toFixed(1)}jt</strong>
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
        </div>"""
content = content.replace(old_html, new_html)

with open(filepath, 'w') as f:
    f.write(content)
print("Done")
