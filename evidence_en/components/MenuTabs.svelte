<script>
  export let activeTab = 'ringkasan';
</script>

<p style="margin-top: 12px; margin-bottom: 12px;"><em>Item-level portfolio breakdown: evaluate matrix positioning, menu priority, trend movement, and operational performance metrics across categories.</em></p>

<details class="guide-acc" style="margin-top:12px; margin-bottom:12px;">
  <summary>💡 How to choose a subpage</summary>
  <div class="guide-body">
    <p style="margin-top: 4px; margin-bottom: 16px; font-weight: 500; color: var(--color-text-secondary);">
      Use this guide to select the layer of menu analysis according to your operational needs.
    </p>
    <div class="guide-grid" style="grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 12px;">
      <div class="guide-card blue">
        <div class="guide-card-icon">🏠</div>
        <div class="guide-card-content">
          <div class="guide-card-label">Macro</div>
          <h4 class="guide-card-title">Overview</h4>
          <p class="guide-card-desc">View the overall health of the restaurant menu.</p>
        </div>
      </div>
      <div class="guide-card teal">
        <div class="guide-card-icon">🏪</div>
        <div class="guide-card-content">
          <div class="guide-card-label">Meso</div>
          <h4 class="guide-card-title">Deep Dive</h4>
          <p class="guide-card-desc">View the menu distribution map along with the conclusions for action.</p>
        </div>
      </div>
      <div class="guide-card purple">
        <div class="guide-card-icon">📈</div>
        <div class="guide-card-content">
          <div class="guide-card-label">Micro & Historical</div>
          <h4 class="guide-card-title">Report Card</h4>
          <p class="guide-card-desc">View the list of skyrocketing/plummeting menus, then dissect their individual performance in depth.</p>
        </div>
      </div>
      <div class="guide-card orange">
        <div class="guide-card-icon">📂</div>
        <div class="guide-card-content">
          <div class="guide-card-label">Raw Data</div>
          <h4 class="guide-card-title">Data Directory</h4>
          <p class="guide-card-desc">Explore raw data of menu performance per branch.</p>
        </div>
      </div>
    </div>
  </div>
</details>

<div class="evidence-tabs-container">
  <a href="/05-menu-performance" class="tab-button {activeTab === 'ringkasan' ? 'active' : ''}">🏠 Overview</a>
  <a href="/05-menu-performance/02-deepdive" class="tab-button {activeTab === 'deepdive' ? 'active' : ''}">🏪 Deep Dive</a>
  <a href="/05-menu-performance/03-analysis" class="tab-button {activeTab === 'evaluasi' ? 'active' : ''}">🔭 Analysis</a>
  <a href="/05-menu-performance/04-report-card" class="tab-button {activeTab === 'rapor' ? 'active' : ''}">📈 Report Card</a>
  <a href="/05-menu-performance/05-data-directory" class="tab-button {activeTab === 'direktori' ? 'active' : ''}">📂 Data Directory</a>
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
