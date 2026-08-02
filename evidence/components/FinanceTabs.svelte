<script>
  export let activeTab = 'overview';
</script>

<p style="margin-top: 12px; margin-bottom: 12px; color: var(--color-text-secondary);"><em>Bedah lebih detail rincian biaya per cabang dan rekomendasi aksinya.</em></p>

<details class="guide-acc" style="margin-top:12px; margin-bottom:12px;">
  <summary>💡 Cara Navigasi Laporan Keuangan</summary>
  <div class="guide-body">
    <p style="margin-top: 4px; margin-bottom: 16px; font-weight: 500; color: var(--color-text-secondary);">
      Pilih sub-modul di bawah ini untuk melihat detail pergerakan tiap jenis biaya.
    </p>
    <div class="guide-grid" style="grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 12px;">
      <div class="guide-card blue">
        <div class="guide-card-icon">🏠</div>
        <div class="guide-card-content">
          <div class="guide-card-label">Makro</div>
          <h4 class="guide-card-title">Ringkasan</h4>
          <p class="guide-card-desc">Evaluasi Net Margin dan kesehatan tren profitabilitas secara umum.</p>
        </div>
      </div>
      <div class="guide-card orange">
        <div class="guide-card-icon">🥩</div>
        <div class="guide-card-content">
          <div class="guide-card-label">Biaya Operasional</div>
          <h4 class="guide-card-title">Rincian Biaya</h4>
          <p class="guide-card-desc">Detail pergerakan harga supplier, efisiensi payroll, dan utilitas operasional.</p>
        </div>
      </div>
      <div class="guide-card teal" style="background: linear-gradient(135deg, rgba(20, 184, 166, 0.08), rgba(45, 212, 191, 0.06)); border-color: #14b8a6;">
        <div class="guide-card-icon">📈</div>
        <div class="guide-card-content">
          <div class="guide-card-label">Evaluasi Panjang</div>
          <h4 class="guide-card-title">Tren</h4>
          <p class="guide-card-desc">Baca fenomena musiman dan tren margin YoY vs Kuartal.</p>
        </div>
      </div>
    </div>
  </div>
</details>

<div class="evidence-tabs-container">
  <a href="/01-laporan-keuangan" class="tab-button {activeTab === 'overview' ? 'active' : ''}">🏠 Ringkasan</a>
  <a href="/01-laporan-keuangan/01-rincian-biaya" class="tab-button {activeTab === 'rincian-biaya' ? 'active' : ''}">🧾 Rincian Biaya</a>
  <a href="/01-laporan-keuangan/02-tren" class="tab-button {activeTab === 'jangka-panjang' ? 'active' : ''}">📈 Tren</a>
</div>

<style>
:global(aside a[href="/01-laporan-keuangan"]),
:global(aside a[href="/01-laporan-keuangan/"]),
:global(#mobileScrollable a[href="/01-laporan-keuangan"]),
:global(#mobileScrollable a[href="/01-laporan-keuangan/"]) {
  background: linear-gradient(135deg, rgba(13, 148, 136, 0.08), rgba(20, 184, 166, 0.06)) !important;
  color: #0f766e !important;
  font-weight: 700 !important;
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.4) !important;
  border-left: 3px solid #0d9488 !important;
  padding-left: 12px !important;
}

:global([data-theme='dark'] aside a[href="/01-laporan-keuangan"]),
:global([data-theme='dark'] aside a[href="/01-laporan-keuangan/"]),
:global([data-theme='dark'] #mobileScrollable a[href="/01-laporan-keuangan"]),
:global([data-theme='dark'] #mobileScrollable a[href="/01-laporan-keuangan/"]) {
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
