<script>
  export let activeTab = 'ringkasan';
  export let lang = 'id';

  const t = {
    id: {
      desc: "Dashboard performa menu: analisis matriks portofolio, prioritas menu, pergerakan tren, dan rekomendasi aksi operasional.",
      guideTitle: "💡 Cara memilih subpage",
      guideDesc: "Gunakan panduan ini untuk memilih lapisan analisis menu sesuai kebutuhan operasional Anda.",
      macroLabel: "Makro",
      macroTitle: "Ringkasan",
      macroDesc: "Melihat kesehatan menu restoran secara keseluruhan.",
      mesoLabel: "Meso",
      mesoTitle: "Deep Dive",
      mesoDesc: "Melihat peta sebaran menu sekaligus kesimpulan aksinya.",
      microLabel: "Mikro & Historis",
      microTitle: "Rapor Menu",
      microDesc: "Melihat daftar menu yang meroket/anjlok, lalu membedah performa individualnya secara mendalam.",
      rawLabel: "Raw Data",
      rawTitle: "Direktori Data",
      rawDesc: "Eksplorasi data mentah performa menu per cabang.",
      tabSummary: "🏠 Ringkasan",
      tabDeepDive: "🏪 Deep Dive",
      tabEvaluation: "🔭 Evaluasi Strategis",
      tabReport: "📈 Rapor Menu",
      tabDirectory: "📂 Direktori Data",
      linkSummary: "/id/05-menu-performance",
      linkDeepDive: "/id/05-menu-performance/deepdive",
      linkEvaluation: "/id/05-menu-performance/evaluasi",
      linkReport: "/id/05-menu-performance/rapor",
      linkDirectory: "/id/05-menu-performance/direktori"
    },
    en: {
      desc: "Menu performance dashboard: portfolio matrix analysis, menu priorities, trend movements, and operational action recommendations.",
      guideTitle: "💡 How to choose a subpage",
      guideDesc: "Use this guide to choose the layer of menu analysis according to your operational needs.",
      macroLabel: "Macro",
      macroTitle: "Summary",
      macroDesc: "View the overall health of the restaurant's menu.",
      mesoLabel: "Meso",
      mesoTitle: "Deep Dive",
      mesoDesc: "View the menu distribution map along with its action conclusions.",
      microLabel: "Micro & Historical",
      microTitle: "Menu Report",
      microDesc: "See the list of skyrocketing/plummeting menus, then deeply dissect their individual performance.",
      rawLabel: "Raw Data",
      rawTitle: "Data Directory",
      rawDesc: "Explore raw menu performance data per branch.",
      tabSummary: "🏠 Summary",
      tabDeepDive: "🏪 Deep Dive",
      tabEvaluation: "🔭 Strategic Evaluation",
      tabReport: "📈 Menu Report",
      tabDirectory: "📂 Data Directory",
      linkSummary: "/en/05-menu-performance",
      linkDeepDive: "/en/05-menu-performance/deepdive",
      linkEvaluation: "/en/05-menu-performance/evaluation",
      linkReport: "/en/05-menu-performance/report",
      linkDirectory: "/en/05-menu-performance/directory"
    }
  };
</script>

<p style="margin-top: 12px; margin-bottom: 12px;"><em>{t[lang].desc}</em></p>

<details class="guide-acc" style="margin-top:12px; margin-bottom:12px;">
  <summary>{t[lang].guideTitle}</summary>
  <div class="guide-body">
    <p style="margin-top: 4px; margin-bottom: 16px; font-weight: 500; color: var(--color-text-secondary);">
      {t[lang].guideDesc}
    </p>
    <div class="guide-grid" style="grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 12px;">
      <div class="guide-card blue">
        <div class="guide-card-icon">🏠</div>
        <div class="guide-card-content">
          <div class="guide-card-label">{t[lang].macroLabel}</div>
          <h4 class="guide-card-title">{t[lang].macroTitle}</h4>
          <p class="guide-card-desc">{t[lang].macroDesc}</p>
        </div>
      </div>
      <div class="guide-card teal">
        <div class="guide-card-icon">🏪</div>
        <div class="guide-card-content">
          <div class="guide-card-label">{t[lang].mesoLabel}</div>
          <h4 class="guide-card-title">{t[lang].mesoTitle}</h4>
          <p class="guide-card-desc">{t[lang].mesoDesc}</p>
        </div>
      </div>
      <div class="guide-card purple">
        <div class="guide-card-icon">📈</div>
        <div class="guide-card-content">
          <div class="guide-card-label">{t[lang].microLabel}</div>
          <h4 class="guide-card-title">{t[lang].microTitle}</h4>
          <p class="guide-card-desc">{t[lang].microDesc}</p>
        </div>
      </div>
      <div class="guide-card orange">
        <div class="guide-card-icon">📂</div>
        <div class="guide-card-content">
          <div class="guide-card-label">{t[lang].rawLabel}</div>
          <h4 class="guide-card-title">{t[lang].rawTitle}</h4>
          <p class="guide-card-desc">{t[lang].rawDesc}</p>
        </div>
      </div>
    </div>
  </div>
</details>

<div class="evidence-tabs-container">
  <a href={t[lang].linkSummary} class="tab-button {activeTab === 'ringkasan' ? 'active' : ''}">{t[lang].tabSummary}</a>
  <a href={t[lang].linkDeepDive} class="tab-button {activeTab === 'deepdive' ? 'active' : ''}">{t[lang].tabDeepDive}</a>
  <a href={t[lang].linkEvaluation} class="tab-button {activeTab === 'evaluasi' ? 'active' : ''}">{t[lang].tabEvaluation}</a>
  <a href={t[lang].linkReport} class="tab-button {activeTab === 'rapor' ? 'active' : ''}">{t[lang].tabReport}</a>
  <a href={t[lang].linkDirectory} class="tab-button {activeTab === 'direktori' ? 'active' : ''}">{t[lang].tabDirectory}</a>
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
