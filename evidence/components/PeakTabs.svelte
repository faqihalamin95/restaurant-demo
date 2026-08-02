<script>
  export let activeTab = 'jam-sibuk';
</script>

<p style="margin-top: 12px; margin-bottom: 12px;"><em>Dashboard permintaan pelanggan: analisis jam sibuk, pola harian, volatilitas traffic, dan tren musiman.</em></p>

<details class="guide-acc" style="margin-top:12px; margin-bottom:12px;">
  <summary>💡 Cara memilih subpage</summary>
  <div class="guide-body">
    <p style="margin-top: 4px; margin-bottom: 16px; font-weight: 500; color: var(--color-text-secondary);">
      Navigasikan analisis traffic Anda dari ringkasan harian hingga pola musiman jangka panjang.
    </p>
    <div class="guide-grid" style="grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 12px;">
      <div class="guide-card blue">
        <div class="guide-card-icon">🏠</div>
        <div class="guide-card-content">
          <div class="guide-card-label">Ringkasan</div>
          <h4 class="guide-card-title">Status Utama &amp; Prediksi</h4>
          <p class="guide-card-desc">Baca cepat rangkuman traffic, jam sibuk, dan prediksi operasional.</p>
        </div>
      </div>
      <div class="guide-card orange">
        <div class="guide-card-icon">🏪</div>
        <div class="guide-card-content">
          <div class="guide-card-label">Micro & Macro</div>
          <h4 class="guide-card-title">Deep Dive</h4>
          <p class="guide-card-desc">Bedah tren jam demi jam dan analisis jangka panjang pergeseran kuartal per cabang.</p>
        </div>
      </div>
    </div>
  </div>
</details>

<div class="evidence-tabs-container">
  <a href="/04-peak-hours" class="tab-button {activeTab === 'ringkasan' ? 'active' : ''}">🏠 Ringkasan</a>
  <a href="/04-peak-hours/deepdive" class="tab-button {activeTab === 'deepdive' ? 'active' : ''}">🏪 Deep Dive</a>
</div>

<style>
:global(aside a[href="/04-peak-hours"]),
:global(aside a[href="/04-peak-hours/"]),
:global(#mobileScrollable a[href="/04-peak-hours"]),
:global(#mobileScrollable a[href="/04-peak-hours/"]) {
  background: linear-gradient(135deg, rgba(13, 148, 136, 0.08), rgba(20, 184, 166, 0.06)) !important;
  color: #0f766e !important;
  font-weight: 700 !important;
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.4) !important;
  border-left: 3px solid #0d9488 !important;
  padding-left: 12px !important;
}

:global([data-theme='dark'] aside a[href="/04-peak-hours"]),
:global([data-theme='dark'] aside a[href="/04-peak-hours/"]),
:global([data-theme='dark'] #mobileScrollable a[href="/04-peak-hours"]),
:global([data-theme='dark'] #mobileScrollable a[href="/04-peak-hours/"]) {
  background: linear-gradient(135deg, rgba(20, 184, 166, 0.15), rgba(45, 212, 191, 0.08)) !important;
  color: #2dd4bf !important;
  border-left-color: #14b8a6 !important;
}


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
