<script>
  export let activeTab = 'overview';
</script>

<p style="margin-top: 12px; margin-bottom: 12px; color: var(--color-text-secondary);"><em>Detailed breakdown of costs per branch and actionable recommendations.</em></p>

<details class="guide-acc" style="margin-top:12px; margin-bottom:12px;">
  <summary>💡 How to Navigate the Financial Report</summary>
  <div class="guide-body">
    <p style="margin-top: 4px; margin-bottom: 16px; font-weight: 500; color: var(--color-text-secondary);">
      Select a sub-module below to view the detailed movement of each cost type.
    </p>
    <div class="guide-grid" style="grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 12px;">
      <div class="guide-card blue">
        <div class="guide-card-icon">🏠</div>
        <div class="guide-card-content">
          <div class="guide-card-label">Macro</div>
          <h4 class="guide-card-title">Overview</h4>
          <p class="guide-card-desc">Evaluate Net Margin and overall profitability health trends.</p>
        </div>
      </div>
      <div class="guide-card orange">
        <div class="guide-card-icon">🥩</div>
        <div class="guide-card-content">
          <div class="guide-card-label">Operational Costs</div>
          <h4 class="guide-card-title">Cost Breakdown</h4>
          <p class="guide-card-desc">Detailed movement of supplier prices, payroll efficiency, and operational utilities.</p>
        </div>
      </div>
      <div class="guide-card teal" style="background: linear-gradient(135deg, rgba(20, 184, 166, 0.08), rgba(45, 212, 191, 0.06)); border-color: #14b8a6;">
        <div class="guide-card-icon">📈</div>
        <div class="guide-card-content">
          <div class="guide-card-label">Long-Term Evaluation</div>
          <h4 class="guide-card-title">Trends</h4>
          <p class="guide-card-desc">Read seasonal phenomena and YoY vs Quarterly margin trends.</p>
        </div>
      </div>
    </div>
  </div>
</details>

<div class="evidence-tabs-container">
  <a href="/01-financial-report" class="tab-button {activeTab === 'overview' ? 'active' : ''}">🏠 Overview</a>
  <a href="/01-financial-report/02-cost-breakdown" class="tab-button {activeTab === 'cost-breakdown' ? 'active' : ''}">🧾 Cost Breakdown</a>
  <a href="/01-financial-report/03-trend" class="tab-button {activeTab === 'jangka-panjang' ? 'active' : ''}">📈 Trends</a>
</div>

<style>
.evidence-tabs-container {
  display: inline-flex;
  background-color: var(--color-background-tertiary, #f3f4f6);
  padding: 4px;
  border-radius: 12px;
  gap: 2px;
  border: 1px solid var(--color-border-tertiary, #e5e7eb);
  margin-top: 10px;
  margin-bottom: 16px;
  flex-wrap: wrap;
}

.tab-button {
  padding: 6px 14px;
  font-size: 0.85rem;
  font-weight: 600;
  color: var(--color-text-secondary, #4b5563);
  text-decoration: none;
  border-radius: 9px;
  transition: all 0.2s ease;
  display: inline-flex;
  align-items: center;
  gap: 6px;
}

.tab-button:hover {
  color: var(--color-text-primary, #111827);
  background-color: rgba(255, 255, 255, 0.4);
}

.tab-button.active {
  color: var(--color-text-primary, #111827);
  background-color: var(--color-background-primary, #ffffff);
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1), 0 1px 2px rgba(0, 0, 0, 0.06);
}
</style>
