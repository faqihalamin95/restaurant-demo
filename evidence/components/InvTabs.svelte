<script>
  export let activeTab = 'ringkasan';
</script>

<div class="evidence-tabs-container">
  <a href="/03-inventori-stok" class="tab-button {activeTab === 'ringkasan' ? 'active' : ''}">🏠 Ringkasan</a>
  <a href="/03-inventori-stok/deepdive" class="tab-button {activeTab === 'deepdive' ? 'active' : ''}">🏪 Deep Dive</a>
  <a href="/03-inventori-stok/analysis" class="tab-button {activeTab === 'analysis' ? 'active' : ''}">🔭 Evaluasi Strategis</a>
  <a href="/03-inventori-stok/direktori-data" class="tab-button {activeTab === 'direktori-data' ? 'active' : ''}">📁 Direktori Data</a>
</div>
<style>
:global(aside a[href="/03-inventori-stok"]),
:global(aside a[href="/03-inventori-stok/"]),
:global(#mobileScrollable a[href="/03-inventori-stok"]),
:global(#mobileScrollable a[href="/03-inventori-stok/"]) {
  background: linear-gradient(135deg, rgba(13, 148, 136, 0.08), rgba(20, 184, 166, 0.06)) !important;
  color: #0f766e !important;
  font-weight: 700 !important;
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.4) !important;
  border-left: 3px solid #0d9488 !important;
  padding-left: 12px !important;
}

:global([data-theme='dark'] aside a[href="/03-inventori-stok"]),
:global([data-theme='dark'] aside a[href="/03-inventori-stok/"]),
:global([data-theme='dark'] #mobileScrollable a[href="/03-inventori-stok"]),
:global([data-theme='dark'] #mobileScrollable a[href="/03-inventori-stok/"]) {
  background: linear-gradient(135deg, rgba(20, 184, 166, 0.15), rgba(45, 212, 191, 0.08)) !important;
  color: #2dd4bf !important;
  border-left-color: #14b8a6 !important;
}
</style>
