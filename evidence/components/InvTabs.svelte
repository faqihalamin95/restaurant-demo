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
</style>
