<script>
  export let activeTab = 'ringkasan';
</script>

<p style="margin-top: 12px; margin-bottom: 12px;"><em>Dashboard performa menu: analisis matriks portofolio, prioritas menu, pergerakan tren, dan rekomendasi aksi operasional.</em></p>

<details class="guide-acc" style="margin-top:12px; margin-bottom:12px;">
  <summary>💡 Cara memilih subpage</summary>
  <div class="guide-body">
    <p style="margin-top: 4px; margin-bottom: 16px; font-weight: 500; color: var(--color-text-secondary);">
      Gunakan panduan ini untuk memilih lapisan analisis menu sesuai kebutuhan operasional Anda.
    </p>
    <div class="guide-grid" style="grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 12px;">
      <div class="guide-card blue">
        <div class="guide-card-icon">🏠</div>
        <div class="guide-card-content">
          <div class="guide-card-label">Makro</div>
          <h4 class="guide-card-title">Ringkasan</h4>
          <p class="guide-card-desc">Melihat kesehatan menu restoran secara keseluruhan.</p>
        </div>
      </div>
      <div class="guide-card teal">
        <div class="guide-card-icon">🏪</div>
        <div class="guide-card-content">
          <div class="guide-card-label">Meso</div>
          <h4 class="guide-card-title">Deep Dive</h4>
          <p class="guide-card-desc">Melihat peta sebaran menu sekaligus kesimpulan aksinya.</p>
        </div>
      </div>
      <div class="guide-card purple">
        <div class="guide-card-icon">📈</div>
        <div class="guide-card-content">
          <div class="guide-card-label">Mikro & Historis</div>
          <h4 class="guide-card-title">Rapor Menu</h4>
          <p class="guide-card-desc">Melihat daftar menu yang meroket/anjlok, lalu membedah performa individualnya secara mendalam.</p>
        </div>
      </div>
      <div class="guide-card orange">
        <div class="guide-card-icon">📂</div>
        <div class="guide-card-content">
          <div class="guide-card-label">Raw Data</div>
          <h4 class="guide-card-title">Direktori Data</h4>
          <p class="guide-card-desc">Eksplorasi data mentah performa menu per cabang.</p>
        </div>
      </div>
    </div>
  </div>
</details>

<div class="evidence-tabs-container">
  <a href="/05-menu-performance" class="tab-button {activeTab === 'ringkasan' ? 'active' : ''}">🏠 Ringkasan</a>
  <a href="/05-menu-performance/deepdive" class="tab-button {activeTab === 'deepdive' ? 'active' : ''}">🏪 Deep Dive</a>
  <a href="/05-menu-performance/evaluasi" class="tab-button {activeTab === 'evaluasi' ? 'active' : ''}">🔭 Evaluasi Strategis</a>
  <a href="/05-menu-performance/rapor" class="tab-button {activeTab === 'rapor' ? 'active' : ''}">📈 Rapor Menu</a>
  <a href="/05-menu-performance/direktori" class="tab-button {activeTab === 'direktori' ? 'active' : ''}">📂 Direktori Data</a>
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
