<script>
  export let activeTab = 'overview';
</script>

<p style="margin-top: 12px; margin-bottom: 12px;"><em>Dashboard analisis performa pegawai: ringkasan produktivitas, efisiensi pelayanan, kepuasan pelanggan, dan kontribusi penjualan.</em></p>

<details class="guide-acc" style="margin-top:12px; margin-bottom:12px;">
  <summary>💡 Cara memilih subpage</summary>
  <div class="guide-body">
    <p style="margin-top: 4px; margin-bottom: 16px; font-weight: 500; color: var(--color-text-secondary);">
      Gunakan panduan ini untuk memilih lapisan analisis performa pegawai sesuai kebutuhan operasional Anda.
    </p>
    <div class="guide-grid" style="grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 12px;">
      <div class="guide-card blue">
        <div class="guide-card-icon">🏠</div>
        <div class="guide-card-content">
          <div class="guide-card-label">Makro</div>
          <h4 class="guide-card-title">Ringkasan</h4>
          <p class="guide-card-desc">Melihat tren produktivitas umum dan kinerja harian.</p>
        </div>
      </div>
      <div class="guide-card teal">
        <div class="guide-card-icon">🎯</div>
        <div class="guide-card-content">
          <div class="guide-card-label">Mode Operasional</div>
          <h4 class="guide-card-title">Aksi Taktis</h4>
          <p class="guide-card-desc">Daftar tindakan langsung: staf mana yang perlu dibantu atau dirotasi segera.</p>
        </div>
      </div>
      <div class="guide-card purple">
        <div class="guide-card-icon">🔭</div>
        <div class="guide-card-content">
          <div class="guide-card-label">Mode Kebijakan</div>
          <h4 class="guide-card-title">Evaluasi Strategis</h4>
          <p class="guide-card-desc">Evaluasi komprehensif, kebutuhan pelatihan, dan strategi promosi jangka panjang.</p>
        </div>
      </div>
    </div>
  </div>
</details>

<div class="evidence-tabs-container">
  <a href="/07-employee-performance" class="tab-button {activeTab === 'overview' ? 'active' : ''}">🏠 Ringkasan</a>
  <a href="/07-employee-performance/02-aksi-taktis" class="tab-button {activeTab === 'taktis' ? 'active' : ''}">🎯 Aksi Taktis</a>
  <a href="/07-employee-performance/03-evaluasi-strategis" class="tab-button {activeTab === 'strategis' ? 'active' : ''}">🔭 Evaluasi Strategis</a>
  <a href="/07-employee-performance/05-direktori-data" class="tab-button {activeTab === 'direktori' ? 'active' : ''}">🗂️ Direktori Data</a>
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
