<script>
  export let activeTab = 'overview';
</script>

<p style="margin-top: 12px; margin-bottom: 12px;"><em>Employee performance analysis dashboard: summary of productivity, service efficiency, customer satisfaction, and sales contribution.</em></p>

<details class="guide-acc" style="margin-top:12px; margin-bottom:12px;">
  <summary>💡 How to choose a subpage</summary>
  <div class="guide-body">
    <p style="margin-top: 4px; margin-bottom: 16px; font-weight: 500; color: var(--color-text-secondary);">
      Use this guide to select the layer of employee performance analysis according to your operational needs.
    </p>
    <div class="guide-grid" style="grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 12px;">
      <div class="guide-card blue">
        <div class="guide-card-icon">🏠</div>
        <div class="guide-card-content">
          <div class="guide-card-label">Macro</div>
          <h4 class="guide-card-title">Overview</h4>
          <p class="guide-card-desc">View general productivity trends and daily performance.</p>
        </div>
      </div>
      <div class="guide-card teal">
        <div class="guide-card-icon">🎯</div>
        <div class="guide-card-content">
          <div class="guide-card-label">Operational Mode</div>
          <h4 class="guide-card-title">Tactical Actions</h4>
          <p class="guide-card-desc">Direct action list: which staff need to be assisted or rotated immediately.</p>
        </div>
      </div>
      <div class="guide-card purple">
        <div class="guide-card-icon">🔭</div>
        <div class="guide-card-content">
          <div class="guide-card-label">Policy Mode</div>
          <h4 class="guide-card-title">Strategic Evaluation</h4>
          <p class="guide-card-desc">Comprehensive evaluation, training needs, and long-term promotion strategy.</p>
        </div>
      </div>
    </div>
  </div>
</details>

<div class="evidence-tabs-container">
  <a href="/07-employee-performance" class="tab-button {activeTab === 'overview' ? 'active' : ''}">🏠 Overview</a>
  <a href="/07-employee-performance/02-tactical-action" class="tab-button {activeTab === 'taktis' ? 'active' : ''}">🎯 Tactical Actions</a>
  <a href="/07-employee-performance/03-analysis" class="tab-button {activeTab === 'strategis' ? 'active' : ''}">🔭 Analysis</a>
  <a href="/07-employee-performance/04-data-directory" class="tab-button {activeTab === 'direktori' ? 'active' : ''}">🗂️ Data Directory</a>
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
