<script>
  export let activeTab = 'overview';
  export let lang = 'id';

  const t = {
    id: {
      desc: "Dashboard analisis perilaku member: ringkasan akuisisi, segmentasi RFM, pola belanja, dan efisiensi promosi.",
      guideTitle: "💡 Cara memilih subpage",
      guideDesc: "Gunakan panduan ini untuk memilih lapisan analisis perilaku member sesuai kebutuhan operasional Anda.",
      macroLabel: "Makro",
      macroTitle: "Ringkasan",
      macroDesc: "Melihat perbandingan nilai member vs non-member dan efektivitas sumber akuisisi.",
      opsLabel: "Mode Operasional",
      opsTitle: "Aksi Taktis",
      opsDesc: "Daftar *to-do list* harian/mingguan: siapa yang harus ditelepon (rawan *churn*) dan promo apa yang harus dimatikan.",
      policyLabel: "Mode Kebijakan",
      policyTitle: "Evaluasi Strategis",
      policyDesc: "Evaluasi makro bulanan: pergerakan tren belanja AOV dan efektivitas desain program loyalitas jangka panjang.",
      rawLabel: "Data Mentah",
      rawTitle: "Direktori Member",
      rawDesc: "Mode *God View* untuk mencari nama spesifik, memfilter, dan membedah database seluruh pelanggan secara bebas.",
      tabOverview: "🏠 Ringkasan",
      tabTactical: "🎯 Aksi Taktis",
      tabStrategic: "🔭 Evaluasi Strategis",
      tabDirectory: "🗂️ Direktori Member",
      linkOverview: "/06-member-behavior",
      linkTactical: "/06-member-behavior/02-aksi-taktis",
      linkStrategic: "/06-member-behavior/03-evaluasi-strategis",
      linkDirectory: "/06-member-behavior/04-direktori-member"
    },
    en: {
      desc: "Member behavior analysis dashboard: acquisition summary, RFM segmentation, spending patterns, and promotion efficiency.",
      guideTitle: "💡 How to choose a subpage",
      guideDesc: "Use this guide to choose the layer of member behavior analysis according to your operational needs.",
      macroLabel: "Macro",
      macroTitle: "Summary",
      macroDesc: "Compare member vs non-member value and effectiveness of acquisition sources.",
      opsLabel: "Operational Mode",
      opsTitle: "Tactical Actions",
      opsDesc: "Daily/weekly *to-do list*: who to call (churn risk) and which promos to turn off.",
      policyLabel: "Policy Mode",
      policyTitle: "Strategic Evaluation",
      policyDesc: "Monthly macro evaluation: AOV spending trend movement and long-term loyalty program design effectiveness.",
      rawLabel: "Raw Data",
      rawTitle: "Member Directory",
      rawDesc: "*God View* mode to search specific names, filter, and freely dissect the entire customer database.",
      tabOverview: "🏠 Summary",
      tabTactical: "🎯 Tactical Actions",
      tabStrategic: "🔭 Strategic Evaluation",
      tabDirectory: "🗂️ Member Directory",
      linkOverview: "/en/06-member-behavior",
      linkTactical: "/en/06-member-behavior/02-tactical-action",
      linkStrategic: "/en/06-member-behavior/03-strategic-evaluation",
      linkDirectory: "/en/06-member-behavior/04-member-directory"
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
    <div class="guide-grid" style="grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 12px;">
      <div class="guide-card blue">
        <div class="guide-card-icon">🏠</div>
        <div class="guide-card-content">
          <div class="guide-card-label">{t[lang].macroLabel}</div>
          <h4 class="guide-card-title">{t[lang].macroTitle}</h4>
          <p class="guide-card-desc">{t[lang].macroDesc}</p>
        </div>
      </div>
      <div class="guide-card teal">
        <div class="guide-card-icon">🎯</div>
        <div class="guide-card-content">
          <div class="guide-card-label">{t[lang].opsLabel}</div>
          <h4 class="guide-card-title">{t[lang].opsTitle}</h4>
          <p class="guide-card-desc">{t[lang].opsDesc}</p>
        </div>
      </div>
      <div class="guide-card purple">
        <div class="guide-card-icon">🔭</div>
        <div class="guide-card-content">
          <div class="guide-card-label">{t[lang].policyLabel}</div>
          <h4 class="guide-card-title">{t[lang].policyTitle}</h4>
          <p class="guide-card-desc">{t[lang].policyDesc}</p>
        </div>
      </div>
      <div class="guide-card orange">
        <div class="guide-card-icon">🗂️</div>
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
  <a href={t[lang].linkOverview} class="tab-button {activeTab === 'overview' ? 'active' : ''}">{t[lang].tabOverview}</a>
  <a href={t[lang].linkTactical} class="tab-button {activeTab === 'taktis' ? 'active' : ''}">{t[lang].tabTactical}</a>
  <a href={t[lang].linkStrategic} class="tab-button {activeTab === 'strategis' ? 'active' : ''}">{t[lang].tabStrategic}</a>
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
