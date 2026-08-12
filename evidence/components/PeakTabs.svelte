<script>
  export let activeTab = 'jam-sibuk';
  export let lang = 'id';

  const t = {
    id: {
      desc: "Dashboard permintaan pelanggan: analisis jam sibuk, pola harian, volatilitas traffic, dan tren musiman.",
      guideTitle: "💡 Cara memilih subpage",
      guideDesc: "Navigasikan analisis traffic Anda dari ringkasan harian hingga pola musiman jangka panjang.",
      summaryLabel: "Ringkasan",
      summaryTitle: "Status Utama & Prediksi",
      summaryDesc: "Baca cepat rangkuman traffic, jam sibuk, dan prediksi operasional.",
      deepLabel: "Micro & Macro",
      deepTitle: "Deep Dive",
      deepDesc: "Bedah tren jam demi jam dan analisis jangka panjang pergeseran kuartal per cabang.",
      tabSummary: "🏠 Ringkasan",
      tabDeepDive: "🏪 Deep Dive",
      linkSummary: "/id/04-peak-hours",
      linkDeepDive: "/id/04-peak-hours/deepdive"
    },
    en: {
      desc: "Customer demand dashboard: peak hours analysis, daily patterns, traffic volatility, and seasonal trends.",
      guideTitle: "💡 How to choose a subpage",
      guideDesc: "Navigate your traffic analysis from daily summaries to long-term seasonal patterns.",
      summaryLabel: "Summary",
      summaryTitle: "Main Status & Predictions",
      summaryDesc: "Quickly read traffic summaries, peak hours, and operational predictions.",
      deepLabel: "Micro & Macro",
      deepTitle: "Deep Dive",
      deepDesc: "Dissect hour-by-hour trends and long-term analysis of quarterly shifts per branch.",
      tabSummary: "🏠 Summary",
      tabDeepDive: "🏪 Deep Dive",
      linkSummary: "/en/04-peak-hours",
      linkDeepDive: "/en/04-peak-hours/deepdive"
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
    <div class="guide-grid" style="grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 12px;">
      <div class="guide-card blue">
        <div class="guide-card-icon">🏠</div>
        <div class="guide-card-content">
          <div class="guide-card-label">{t[lang].summaryLabel}</div>
          <h4 class="guide-card-title">{t[lang].summaryTitle}</h4>
          <p class="guide-card-desc">{t[lang].summaryDesc}</p>
        </div>
      </div>
      <div class="guide-card orange">
        <div class="guide-card-icon">🏪</div>
        <div class="guide-card-content">
          <div class="guide-card-label">{t[lang].deepLabel}</div>
          <h4 class="guide-card-title">{t[lang].deepTitle}</h4>
          <p class="guide-card-desc">{t[lang].deepDesc}</p>
        </div>
      </div>
    </div>
  </div>
</details>

<div class="evidence-tabs-container">
  <a href={t[lang].linkSummary} class="tab-button {activeTab === 'ringkasan' ? 'active' : ''}">{t[lang].tabSummary}</a>
  <a href={t[lang].linkDeepDive} class="tab-button {activeTab === 'deepdive' ? 'active' : ''}">{t[lang].tabDeepDive}</a>
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
