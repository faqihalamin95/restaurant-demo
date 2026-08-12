<script>
  export let activeTab = 'ringkasan';
</script>

<div class="evidence-tabs-container">
  <a href="/03-inventory" class="tab-button {activeTab === 'ringkasan' ? 'active' : ''}">🏠 Overview</a>
  <a href="/03-inventory/02-deepdive" class="tab-button {activeTab === 'deepdive' ? 'active' : ''}">🏪 Deep Dive</a>
  <a href="/03-inventory/03-analysis" class="tab-button {activeTab === 'analysis' ? 'active' : ''}">🔭 Analysis</a>
  <a href="/03-inventory/04-data-directory" class="tab-button {activeTab === 'data-directory' ? 'active' : ''}">📁 Data Directory</a>
</div>
<style>
</style>
