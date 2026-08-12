<script>
  export let activeTab = 'jam-sibuk';
</script>

<p style="margin-top: 12px; margin-bottom: 12px;"><em>Executive customer demand intelligence: peak hour throughput, daily consumption variance, and quarterly seasonality.</em></p>

<details class="guide-acc" style="margin-top:12px; margin-bottom:12px;">
  <summary>💡 How to choose a subpage</summary>
  <div class="guide-body">
    <p style="margin-top: 4px; margin-bottom: 16px; font-weight: 500; color: var(--color-text-secondary);">
      Select an analytical lens to transition between high-level operational summaries and granular temporal trends.
    </p>
    <div class="guide-grid" style="grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 12px;">
      <div class="guide-card blue">
        <div class="guide-card-icon">🏠</div>
        <div class="guide-card-content">
          <div class="guide-card-label">Overview</div>
          <h4 class="guide-card-title">Executive Demand Summary</h4>
          <p class="guide-card-desc">Consolidated demand metrics, peak throughput windows, and short-term operational forecasts.</p>
        </div>
      </div>
      <div class="guide-card orange">
        <div class="guide-card-icon">🏪</div>
        <div class="guide-card-content">
          <div class="guide-card-label">Temporal &amp; Granular Analytics</div>
          <h4 class="guide-card-title">Deep Dive</h4>
          <p class="guide-card-desc">Hour-by-hour operational volume breakdown and long-term quarterly demand seasonality per branch.</p>
        </div>
      </div>
    </div>
  </div>
</details>

<div class="evidence-tabs-container">
  <a href="/04-peak-hours" class="tab-button {activeTab === 'ringkasan' ? 'active' : ''}">🏠 Overview</a>
  <a href="/04-peak-hours/02-deepdive" class="tab-button {activeTab === 'deepdive' ? 'active' : ''}">🏪 Deep Dive</a>
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
