<script>
  export let activeTab = 'ringkasan';
  export let lang = 'id';

  const t = {
    id: {
      tabSummary: "🏠 Ringkasan",
      tabDeepDive: "🏪 Deep Dive",
      tabAnalysis: "🔭 Evaluasi Strategis",
      tabDirectory: "📁 Direktori Data",
      linkSummary: "/03-inventori-stok",
      linkDeepDive: "/03-inventori-stok/deepdive",
      linkAnalysis: "/03-inventori-stok/analysis",
      linkDirectory: "/03-inventori-stok/direktori-data"
    },
    en: {
      tabSummary: "🏠 Summary",
      tabDeepDive: "🏪 Deep Dive",
      tabAnalysis: "🔭 Strategic Evaluation",
      tabDirectory: "📁 Data Directory",
      linkSummary: "/en/03-inventory",
      linkDeepDive: "/en/03-inventory/deepdive",
      linkAnalysis: "/en/03-inventory/analysis",
      linkDirectory: "/en/03-inventory/data-directory"
    }
  };
</script>

<div class="evidence-tabs-container">
  <a href={t[lang].linkSummary} class="tab-button {activeTab === 'ringkasan' ? 'active' : ''}">{t[lang].tabSummary}</a>
  <a href={t[lang].linkDeepDive} class="tab-button {activeTab === 'deepdive' ? 'active' : ''}">{t[lang].tabDeepDive}</a>
  <a href={t[lang].linkAnalysis} class="tab-button {activeTab === 'analysis' ? 'active' : ''}">{t[lang].tabAnalysis}</a>
  <a href={t[lang].linkDirectory} class="tab-button {activeTab === 'direktori-data' ? 'active' : ''}">{t[lang].tabDirectory}</a>
</div>
<style>
</style>
