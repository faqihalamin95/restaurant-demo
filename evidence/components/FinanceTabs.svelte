<script>
  export let activeTab = 'overview';
  export let lang = 'id';

  const t = {
    id: {
      desc: "Bedah lebih detail rincian biaya per cabang dan rekomendasi aksinya.",
      guideTitle: "💡 Cara Navigasi Laporan Keuangan",
      guideDesc: "Pilih sub-modul di bawah ini untuk melihat detail pergerakan tiap jenis biaya.",
      macroLabel: "Makro",
      macroTitle: "Ringkasan",
      macroDesc: "Evaluasi Net Margin dan kesehatan tren profitabilitas secara umum.",
      opsLabel: "Biaya Operasional",
      opsTitle: "Rincian Biaya",
      opsDesc: "Detail pergerakan harga supplier, efisiensi payroll, dan utilitas operasional.",
      evalLabel: "Evaluasi Panjang",
      evalTitle: "Tren",
      evalDesc: "Baca fenomena musiman dan tren margin YoY vs Kuartal.",
      tabOverview: "🏠 Ringkasan",
      tabDetails: "🧾 Rincian Biaya",
      tabTrends: "📈 Tren",
      linkOverview: "/id/01-laporan-keuangan",
      linkDetails: "/id/01-laporan-keuangan/01-rincian-biaya",
      linkTrends: "/id/01-laporan-keuangan/02-tren"
    },
    en: {
      desc: "Examine cost details per branch and their recommended actions in more detail.",
      guideTitle: "💡 How to Navigate Financial Reports",
      guideDesc: "Select a sub-module below to view the movement details of each cost type.",
      macroLabel: "Macro",
      macroTitle: "Summary",
      macroDesc: "Evaluate Net Margin and general profitability trend health.",
      opsLabel: "Operational Costs",
      opsTitle: "Cost Details",
      opsDesc: "Detailed movement of supplier prices, payroll efficiency, and operational utilities.",
      evalLabel: "Long-term Evaluation",
      evalTitle: "Trends",
      evalDesc: "Read seasonal phenomena and YoY vs Quarterly margin trends.",
      tabOverview: "🏠 Summary",
      tabDetails: "🧾 Cost Details",
      tabTrends: "📈 Trends",
      linkOverview: "/en/01-financial-report",
      linkDetails: "/en/01-financial-report/01-cost-details",
      linkTrends: "/en/01-financial-report/02-trends"
    }
  };
</script>

<p style="margin-top: 12px; margin-bottom: 12px; color: var(--color-text-secondary);"><em>{t[lang].desc}</em></p>

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
      <div class="guide-card orange">
        <div class="guide-card-icon">🥩</div>
        <div class="guide-card-content">
          <div class="guide-card-label">{t[lang].opsLabel}</div>
          <h4 class="guide-card-title">{t[lang].opsTitle}</h4>
          <p class="guide-card-desc">{t[lang].opsDesc}</p>
        </div>
      </div>
      <div class="guide-card teal" style="background: linear-gradient(135deg, rgba(20, 184, 166, 0.08), rgba(45, 212, 191, 0.06)); border-color: #14b8a6;">
        <div class="guide-card-icon">📈</div>
        <div class="guide-card-content">
          <div class="guide-card-label">{t[lang].evalLabel}</div>
          <h4 class="guide-card-title">{t[lang].evalTitle}</h4>
          <p class="guide-card-desc">{t[lang].evalDesc}</p>
        </div>
      </div>
    </div>
  </div>
</details>

<div class="evidence-tabs-container">
  <a href={t[lang].linkOverview} class="tab-button {activeTab === 'overview' ? 'active' : ''}">{t[lang].tabOverview}</a>
  <a href={t[lang].linkDetails} class="tab-button {activeTab === 'rincian-biaya' ? 'active' : ''}">{t[lang].tabDetails}</a>
  <a href={t[lang].linkTrends} class="tab-button {activeTab === 'jangka-panjang' ? 'active' : ''}">{t[lang].tabTrends}</a>
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
