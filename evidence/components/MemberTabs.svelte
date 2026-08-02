<script>
  export let activeTab = 'overview';
</script>

<p style="margin-top: 12px; margin-bottom: 12px;"><em>Dashboard analisis perilaku member: ringkasan akuisisi, segmentasi RFM, pola belanja, dan efisiensi promosi.</em></p>

<details class="guide-acc" style="margin-top:12px; margin-bottom:12px;">
  <summary>💡 Cara memilih subpage</summary>
  <div class="guide-body">
    <p style="margin-top: 4px; margin-bottom: 16px; font-weight: 500; color: var(--color-text-secondary);">
      Gunakan panduan ini untuk memilih lapisan analisis perilaku member sesuai kebutuhan operasional Anda.
    </p>
    <div class="guide-grid" style="grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 12px;">
      <div class="guide-card blue">
        <div class="guide-card-icon">🏠</div>
        <div class="guide-card-content">
          <div class="guide-card-label">Makro</div>
          <h4 class="guide-card-title">Ringkasan</h4>
          <p class="guide-card-desc">Melihat perbandingan nilai member vs non-member dan efektivitas sumber akuisisi.</p>
        </div>
      </div>
      <div class="guide-card teal">
        <div class="guide-card-icon">🎯</div>
        <div class="guide-card-content">
          <div class="guide-card-label">Mode Operasional</div>
          <h4 class="guide-card-title">Aksi Taktis</h4>
          <p class="guide-card-desc">Daftar *to-do list* harian/mingguan: siapa yang harus ditelepon (rawan *churn*) dan promo apa yang harus dimatikan.</p>
        </div>
      </div>
      <div class="guide-card purple">
        <div class="guide-card-icon">🔭</div>
        <div class="guide-card-content">
          <div class="guide-card-label">Mode Kebijakan</div>
          <h4 class="guide-card-title">Evaluasi Strategis</h4>
          <p class="guide-card-desc">Evaluasi makro bulanan: pergerakan tren belanja AOV dan efektivitas desain program loyalitas jangka panjang.</p>
        </div>
      </div>
      <div class="guide-card orange">
        <div class="guide-card-icon">🗂️</div>
        <div class="guide-card-content">
          <div class="guide-card-label">Data Mentah</div>
          <h4 class="guide-card-title">Direktori Member</h4>
          <p class="guide-card-desc">Mode *God View* untuk mencari nama spesifik, memfilter, dan membedah database seluruh pelanggan secara bebas.</p>
        </div>
      </div>
    </div>
  </div>
</details>

<div class="evidence-tabs-container">
  <a href="/06-member-behavior" class="tab-button {activeTab === 'overview' ? 'active' : ''}">🏠 Ringkasan</a>
  <a href="/06-member-behavior/02-aksi-taktis" class="tab-button {activeTab === 'taktis' ? 'active' : ''}">🎯 Aksi Taktis</a>
  <a href="/06-member-behavior/03-evaluasi-strategis" class="tab-button {activeTab === 'strategis' ? 'active' : ''}">🔭 Evaluasi Strategis</a>
  <a href="/06-member-behavior/04-direktori-member" class="tab-button {activeTab === 'direktori' ? 'active' : ''}">🗂️ Direktori Member</a>
</div>

<style>
:global(aside a[href="/06-member-behavior"]),
:global(aside a[href="/06-member-behavior/"]),
:global(#mobileScrollable a[href="/06-member-behavior"]),
:global(#mobileScrollable a[href="/06-member-behavior/"]) {
  background: linear-gradient(135deg, rgba(13, 148, 136, 0.08), rgba(20, 184, 166, 0.06)) !important;
  color: #0f766e !important;
  font-weight: 700 !important;
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.4) !important;
  border-left: 3px solid #0d9488 !important;
  padding-left: 12px !important;
}

:global([data-theme='dark'] aside a[href="/06-member-behavior"]),
:global([data-theme='dark'] aside a[href="/06-member-behavior/"]),
:global([data-theme='dark'] #mobileScrollable a[href="/06-member-behavior"]),
:global([data-theme='dark'] #mobileScrollable a[href="/06-member-behavior/"]) {
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
