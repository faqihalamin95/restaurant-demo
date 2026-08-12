<script>
  export let activeTab = 'overview';
</script>

<p style="margin-top: 12px; margin-bottom: 12px;"><em>Member behavior analysis dashboard: evaluate RFM segmentation positioning, acquisition velocity, spending patterns, and promotional campaign efficiency.</em></p>

<details class="guide-acc" style="margin-top:12px; margin-bottom:12px;">
  <summary>💡 How to choose a subpage</summary>
  <div class="guide-body">
    <p style="margin-top: 4px; margin-bottom: 16px; font-weight: 500; color: var(--color-text-secondary);">
      Use this guide to select the layer of member behavior analysis according to your operational needs.
    </p>
    <div class="guide-grid" style="grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 12px;">
      <div class="guide-card blue">
        <div class="guide-card-icon">🏠</div>
        <div class="guide-card-content">
          <div class="guide-card-label">Macro</div>
          <h4 class="guide-card-title">Overview</h4>
          <p class="guide-card-desc">Assess member vs non-member revenue contribution and evaluate acquisition channel effectiveness.</p>
        </div>
      </div>
      <div class="guide-card teal">
        <div class="guide-card-icon">🎯</div>
        <div class="guide-card-content">
          <div class="guide-card-label">Operational Mode</div>
          <h4 class="guide-card-title">Tactical Actions</h4>
          <p class="guide-card-desc">Daily/weekly action list: identify churn-risk members for re-engagement and flag underperforming promotions for deactivation.</p>
        </div>
      </div>
      <div class="guide-card purple">
        <div class="guide-card-icon">🔭</div>
        <div class="guide-card-content">
          <div class="guide-card-label">Policy Mode</div>
          <h4 class="guide-card-title">Strategic Evaluation</h4>
          <p class="guide-card-desc">Monthly macro evaluation: track AOV spending trajectory shifts and measure long-term loyalty program design effectiveness.</p>
        </div>
      </div>
      <div class="guide-card orange">
        <div class="guide-card-icon">🗂️</div>
        <div class="guide-card-content">
          <div class="guide-card-label">Raw Data</div>
          <h4 class="guide-card-title">Member Directory</h4>
          <p class="guide-card-desc">Full-access mode: search, filter, and drill down into the complete customer database at individual record level.</p>
        </div>
      </div>
    </div>
  </div>
</details>

<div class="evidence-tabs-container">
  <a href="/06-member-behavior" class="tab-button {activeTab === 'overview' ? 'active' : ''}">🏠 Overview</a>
  <a href="/06-member-behavior/02-tactical-action" class="tab-button {activeTab === 'taktis' ? 'active' : ''}">🎯 Tactical Actions</a>
  <a href="/06-member-behavior/03-analysis" class="tab-button {activeTab === 'strategis' ? 'active' : ''}">🔭 Analysis</a>
  <a href="/06-member-behavior/04-data-directory" class="tab-button {activeTab === 'direktori' ? 'active' : ''}">🗂️ Member Directory</a>
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
