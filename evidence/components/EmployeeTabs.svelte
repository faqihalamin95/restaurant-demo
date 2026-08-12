<script>
  export let activeTab = 'overview';
  export let lang = 'id';

  const t = {
    id: {
      desc: "Dashboard analisis performa pegawai: ringkasan produktivitas, efisiensi pelayanan, kepuasan pelanggan, dan kontribusi penjualan.",
      guideTitle: "💡 Cara memilih subpage",
      guideDesc: "Gunakan panduan ini untuk memilih lapisan analisis performa pegawai sesuai kebutuhan operasional Anda.",
      macroLabel: "Makro",
      macroTitle: "Ringkasan",
      macroDesc: "Melihat tren produktivitas umum dan kinerja harian.",
      opsLabel: "Mode Operasional",
      opsTitle: "Aksi Taktis",
      opsDesc: "Daftar tindakan langsung: staf mana yang perlu dibantu atau dirotasi segera.",
      policyLabel: "Mode Kebijakan",
      policyTitle: "Evaluasi Strategis",
      policyDesc: "Evaluasi komprehensif, kebutuhan pelatihan, dan strategi promosi jangka panjang.",
      tabOverview: "🏠 Ringkasan",
      tabTactical: "🎯 Aksi Taktis",
      tabStrategic: "🔭 Evaluasi Strategis",
      tabDirectory: "🗂️ Direktori Data",
      linkOverview: "/id/07-employee-performance",
      linkTactical: "/id/07-employee-performance/02-aksi-taktis",
      linkStrategic: "/id/07-employee-performance/03-evaluasi-strategis",
      linkDirectory: "/id/07-employee-performance/05-direktori-data"
    },
    en: {
      desc: "Employee performance analysis dashboard: summary of productivity, service efficiency, customer satisfaction, and sales contribution.",
      guideTitle: "💡 How to choose a subpage",
      guideDesc: "Use this guide to choose the layer of employee performance analysis according to your operational needs.",
      macroLabel: "Macro",
      macroTitle: "Summary",
      macroDesc: "View general productivity trends and daily performance.",
      opsLabel: "Operational Mode",
      opsTitle: "Tactical Actions",
      opsDesc: "List of direct actions: which staff need help or immediate rotation.",
      policyLabel: "Policy Mode",
      policyTitle: "Strategic Evaluation",
      policyDesc: "Comprehensive evaluation, training needs, and long-term promotion strategies.",
      tabOverview: "🏠 Summary",
      tabTactical: "🎯 Tactical Actions",
      tabStrategic: "🔭 Strategic Evaluation",
      tabDirectory: "🗂️ Data Directory",
      linkOverview: "/en/07-employee-performance",
      linkTactical: "/en/07-employee-performance/02-tactical-action",
      linkStrategic: "/en/07-employee-performance/03-strategic-evaluation",
      linkDirectory: "/en/07-employee-performance/04-data-directory"
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
    <div class="guide-grid" style="grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 12px;">
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
