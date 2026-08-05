---
title: Analysis
---

<script>
  import DiagnosticsHeader from '$lib/DiagnosticsHeader.svelte';
  import SectionHeader from '$lib/SectionHeader.svelte';
  import SectionCard from '$lib/SectionCard.svelte';
  import PremiumTable from '$lib/PremiumTable.svelte';
  import GlobalLoading from '$lib/GlobalLoading.svelte';

  function idFormat(num, dec = 0) {
    if (num === null || num === undefined) return '0';
    return new Intl.NumberFormat('id-ID', { minimumFractionDigits: dec, maximumFractionDigits: dec }).format(num);
  }

  let concentrationN = 1;
  let concentrationPct = 0;
  let concentrationNetPct = 0;

  let boxColorClass = "amber";
  let iconHeadline = "🔍";
  let executiveHeadline = "Observasi: Konsentrasi Laba & Beban Portofolio";
  let kalInti = "";

  let resCount = 0;
  let decCount = 0;

  $: if (typeof branch_summary_30d !== 'undefined' && branch_summary_30d.length > 0 && typeof branch_macro_strategic !== 'undefined' && branch_macro_strategic.length > 0 && typeof branch_health_overview !== 'undefined' && branch_health_overview.length > 0) {
      const sortedByRev = [...branch_summary_30d].sort((a, b) => b.total_revenue - a.total_revenue);
      const totalBranches = sortedByRev.length;
      
      // Dinamis: Top 1 untuk <=3 cabang, Top 2 untuk <=7, Top 3 untuk >7
      if (totalBranches <= 3) concentrationN = 1;
      else if (totalBranches <= 7) concentrationN = 2;
      else concentrationN = 3;

      let topNRev = 0;
      let totalRev = 0;
      let topNNet = 0;
      let totalNet = 0;
      
      for (let i = 0; i < totalBranches; i++) {
          totalRev += sortedByRev[i].total_revenue;
          totalNet += sortedByRev[i].net_revenue;
          if (i < concentrationN) {
              topNRev += sortedByRev[i].total_revenue;
              topNNet += sortedByRev[i].net_revenue;
          }
      }
      
      concentrationPct = totalRev > 0 ? (topNRev / totalRev) * 100 : 0;
      concentrationNetPct = totalNet > 0 ? (topNNet / totalNet) * 100 : (topNNet > 0 ? 100 : 0);

      // Algoritma 4 Skenario (Fair Share & Gap)
      const fairShare = (concentrationN / totalBranches) * 100;
      const revIndex = concentrationPct / fairShare;
      const gap = concentrationNetPct - concentrationPct;
      
      let zona = "Tersebar Merata";
      if (revIndex > 1.35) zona = "Sangat Terpusat";
      else if (revIndex >= 1.15) zona = "Mulai Terkonsentrasi";

      resCount = branch_macro_strategic[0].resilient_count || 0;
      decCount = branch_health_overview[0].declining_30d || 0;
      let aov = idFormat(branch_macro_strategic[0].network_aov_30d);

      if (gap > 10) {
          // Skenario A: Parasite Network (Omzet Tersebar, Laba Terpusat)
          boxColorClass = "red";
          iconHeadline = "🚨";
          executiveHeadline = "Observasi: Jaringan Parasit & Subsidi Silang";
          kalInti = `Bulan ini, <strong>${concentrationN} cabang utama</strong> menyumbang <strong>${idFormat(concentrationPct, 1)}%</strong> omzet jaringan. Namun secara mengejutkan, mereka memikul hingga <strong>${idFormat(concentrationNetPct, 1)}% dari total Laba Bersih</strong> perusahaan di tengah rata-rata transaksi Rp ${aov}/struk. Ketimpangan ini mengindikasikan adanya subsidi silang ekstrem, di mana cabang dominan terpaksa menutup kebocoran margin dari cabang-cabang terbawah dalam ekosistem.`;
          
          if (concentrationNetPct > 100) {
              kalInti += `<br><br><span style="font-size: 0.85rem; color: var(--color-text-tertiary);"><em>*Catatan: Persentase kontribusi laba yang melampaui 100% adalah indikator matematis bahwa terdapat cabang lain di dalam jaringan yang saat ini sedang beroperasi dalam kondisi minus/merugi.</em></span>`;
          }
      } 
      else if (gap < -10) {
          // Skenario B: Inefficient Giants (Omzet Terpusat, Laba Tersebar)
          boxColorClass = "amber";
          iconHeadline = "⚠️";
          executiveHeadline = "Observasi: Ilusi Volume Transaksi (Inefisiensi Margin)";
          kalInti = `Meskipun <strong>${concentrationN} cabang utama</strong> berhasil mendominasi <strong>${idFormat(concentrationPct, 1)}%</strong> dari total omzet, kontribusi laba bersihnya justru tertinggal secara proporsional di angka <strong>${idFormat(concentrationNetPct, 1)}%</strong>. Rata-rata transaksi jaringan berjalan stabil di angka Rp ${aov}/struk. Fenomena ini mengindikasikan bahwa tingginya volume penjualan di cabang raksasa dibarengi dengan inefisiensi beban operasional yang menggerus profitabilitasnya.`;
      } 
      else {
          // Skenario Seimbang (Gap dalam batas +/- 10%)
          if (zona === "Sangat Terpusat") {
              // Skenario C: Fragile Empire
              boxColorClass = "amber";
              iconHeadline = "⚠️";
              executiveHeadline = "Observasi: Pemusatan Risiko (Fragile Empire)";
              kalInti = `Porsi omzet dan laba berjalan lurus: <strong>${concentrationN} cabang utama</strong> menopang <strong>${idFormat(concentrationPct, 1)}% omzet</strong> sekaligus <strong>${idFormat(concentrationNetPct, 1)}% laba bersih</strong> jaringan. Rata-rata transaksi bergerak di angka Rp ${aov}/struk. Tingkat ketergantungan absolut ini memicu "Pemusatan Risiko" (CR${concentrationN}) yang sangat pekat, sehingga stabilitas kas perusahaan bertumpu sepenuhnya pada urat nadi segelintir lokasi tersebut.`;
          } else {
              // Skenario D: Resilient Ecosystem
              boxColorClass = "blue";
              iconHeadline = "✅";
              executiveHeadline = "Observasi: Ekosistem Tahan Banting (Standardisasi Sehat)";
              kalInti = `Standardisasi operasional terbukti prima. Sumbangan <strong>${idFormat(concentrationPct, 1)}% omzet</strong> dari <strong>${concentrationN} cabang utama</strong> berbanding lurus dengan porsi laba bersihnya yang tersebar sehat di kisaran <strong>${idFormat(concentrationNetPct, 1)}%</strong> (AOV: Rp ${aov}/struk). Keseimbangan rasio ini membuktikan ketiadaan monopoli risiko tunggal, menandakan ekosistem portofolio yang tangguh dan terdesentralisasi dengan baik.`;
          }
      }
  }
</script>

<style>
.warning-banner {
  background: linear-gradient(135deg, rgba(245, 158, 11, 0.12), rgba(251, 191, 36, 0.04));
  border: 1px solid rgba(245, 158, 11, 0.3);
  border-left: 4px solid #f59e0b;
  border-radius: 12px;
  padding: 16px 20px;
  margin-top: 16px;
  margin-bottom: 24px;
  display: flex;
  gap: 16px;
  align-items: flex-start;
  box-shadow: 0 4px 12px rgba(0,0,0,0.02);
  transition: all 0.22s ease;
}
.warning-banner-title { margin: 0 0 6px 0; color: #b45309; font-size: 0.95rem; font-weight: 700; }
.warning-banner-desc { margin: 0; color: var(--color-text-secondary); font-size: 0.85rem; line-height: 1.6; }

.diagnostics-stack { display: flex; flex-direction: column; gap: 24px; }
.diagnostics-header { margin-bottom: 8px; }
.diagnostics-eyebrow { font-size: 11px; font-weight: 700; letter-spacing: 0.1em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 8px; }
.diagnostics-title { margin: 0 0 8px 0; font-size: 1.5rem; letter-spacing: -0.02em; color: var(--color-text-primary); line-height: 1.2; }
.diagnostics-copy { margin: 0; font-size: 0.9rem; color: var(--color-text-secondary); line-height: 1.6; max-width: 80ch; }

.chart-insight-bar { margin-top: 14px; padding: 14px 16px; border-radius: 14px; border: 1px solid rgba(99,102,241,0.15); background: linear-gradient(135deg, rgba(99,102,241,0.05), rgba(139,92,246,0.03)); font-size: 0.88rem; line-height: 1.7; color: var(--color-text-secondary); }

.risk-section { display: flex; flex-direction: column; gap: 20px; margin-bottom: 32px; }

.risk-row {
  border-radius: 20px;
  overflow: hidden;
  box-shadow: 0 2px 12px rgba(0,0,0,0.03);
  transition: border-color 0.3s ease, box-shadow 0.3s ease;
}

/* Row color themes */
.risk-row.purple-theme { background: linear-gradient(135deg, rgba(168,85,247,0.03), rgba(168,85,247,0.008)); border: 1.5px solid rgba(168,85,247,0.12); }
.risk-row.blue-theme { background: linear-gradient(135deg, rgba(59,130,246,0.03), rgba(59,130,246,0.008)); border: 1.5px solid rgba(59,130,246,0.12); }
.risk-row.slate-theme { background: linear-gradient(135deg, rgba(15,23,42,0.03), rgba(15,23,42,0.008)); border: 1.5px solid rgba(15,23,42,0.08); }

/* Hover: outline only */
.risk-row.purple-theme:hover { border-color: rgba(168,85,247,0.35); box-shadow: 0 4px 20px rgba(168,85,247,0.06); }
.risk-row.blue-theme:hover { border-color: rgba(59,130,246,0.35); box-shadow: 0 4px 20px rgba(59,130,246,0.06); }
.risk-row.slate-theme:hover { border-color: rgba(15,23,42,0.20); box-shadow: 0 4px 20px rgba(15,23,42,0.04); }

.risk-row-header { display: flex; align-items: center; gap: 12px; padding: 18px 24px; }
.risk-row.purple-theme .risk-row-header { border-bottom: 1px solid rgba(168,85,247,0.08); }
.risk-row.blue-theme .risk-row-header { border-bottom: 1px solid rgba(59,130,246,0.08); }
.risk-row.slate-theme .risk-row-header { border-bottom: 1px solid rgba(15,23,42,0.06); }

.risk-row-icon { font-size: 1.15rem; width: 36px; height: 36px; display: flex; align-items: center; justify-content: center; border-radius: 11px; flex-shrink: 0; }
.risk-row.purple-theme .risk-row-icon { background: rgba(168,85,247,0.10); }
.risk-row.blue-theme .risk-row-icon { background: rgba(59,130,246,0.10); }
.risk-row.slate-theme .risk-row-icon { background: rgba(15,23,42,0.06); }

.risk-row-title { margin: 0; font-size: 1.02rem; font-weight: 800; color: var(--color-text-primary); letter-spacing: -0.02em; }

/* Pills: 3-column grid */
.risk-pills { display: grid; grid-template-columns: repeat(3, 1fr); }
.risk-pills.cols-2 { grid-template-columns: repeat(2, 1fr); }
.risk-pill {
  display: flex; flex-direction: column; align-items: center; text-align: center;
  gap: 10px; padding: 20px 16px;
  border-right: 1px solid rgba(0,0,0,0.04);
  transition: background 0.25s ease;
}
.risk-pill:last-child { border-right: none; }
.risk-row.purple-theme .risk-pill:hover { background: rgba(168,85,247,0.05); }
.risk-row.blue-theme .risk-pill:hover { background: rgba(59,130,246,0.05); }
.risk-row.slate-theme .risk-pill:hover { background: rgba(15,23,42,0.03); }

.risk-pill-anchor {
  font-size: 1.15rem;
  width: 44px; height: 44px; border-radius: 50%;
  display: flex; align-items: center; justify-content: center;
}
.risk-row.purple-theme .risk-pill-anchor { background: rgba(168,85,247,0.10); }
.risk-row.blue-theme .risk-pill-anchor { background: rgba(59,130,246,0.10); }
.risk-row.slate-theme .risk-pill-anchor { background: rgba(15,23,42,0.06); }

.risk-pill-content { display: flex; flex-direction: column; gap: 4px; }
.risk-pill-content strong { font-size: 0.85rem; font-weight: 800; color: var(--color-text-primary); letter-spacing: -0.01em; }
.risk-pill-content span { font-size: 0.8rem; line-height: 1.5; color: var(--color-text-secondary); }

/* Fun fact footer */
.risk-funfact {
  display: flex; align-items: flex-start; gap: 12px;
  padding: 14px 24px;
  border-top: 1px dashed rgba(0,0,0,0.06);
  background: rgba(0,0,0,0.015);
}
.risk-funfact-icon { font-size: 0.9rem; margin-top: 2px; flex-shrink: 0; }
.risk-funfact-content { display: flex; flex-direction: column; gap: 2px; }
.risk-funfact-content span { font-size: 0.78rem; line-height: 1.5; color: var(--color-text-secondary); }
.risk-funfact-content cite { font-size: 0.7rem; color: var(--color-text-tertiary); font-style: italic; }

/* Quadrant Legends */
.quadrant-grid {
  display: grid; 
  grid-template-columns: repeat(2, 1fr); 
  gap: 16px; 
  margin-bottom: 32px;
}
.quadrant-card {
  padding: 16px;
  border-radius: 12px;
  display: flex;
  flex-direction: column;
  gap: 6px;
  transition: transform 0.2s ease, box-shadow 0.2s ease;
  border-left: 4px solid;
}
.quadrant-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0,0,0,0.05);
}
.quadrant-title {
  font-weight: 700;
  font-size: 0.9rem;
  display: flex;
  align-items: center;
  gap: 8px;
}
.quadrant-desc {
  font-size: 0.8rem;
  color: var(--color-text-secondary);
  line-height: 1.5;
  margin: 0;
}
.quad-stars {
  background: linear-gradient(135deg, rgba(16,185,129,0.05), rgba(16,185,129,0.01));
  border-color: #10b981;
}
.quad-stars .quadrant-title { color: #047857; }

.quad-decaying {
  background: linear-gradient(135deg, rgba(245,158,11,0.05), rgba(245,158,11,0.01));
  border-color: #f59e0b;
}
.quad-decaying .quadrant-title { color: #b45309; }

.quad-leaking {
  background: linear-gradient(135deg, rgba(99,102,241,0.05), rgba(99,102,241,0.01));
  border-color: #6366f1;
}
.quad-leaking .quadrant-title { color: #4338ca; }

.quad-parasites {
  background: linear-gradient(135deg, rgba(239,68,68,0.05), rgba(239,68,68,0.01));
  border-color: #ef4444;
}
.quad-parasites .quadrant-title { color: #b91c1c; }
</style>

```sql branch_summary_30d
SELECT * FROM restaurant.branch_index_branch_summary_30d
```

```sql branch_macro_strategic
SELECT * FROM restaurant.branch_index_macro_strategic
```

```sql ytd_matrix_data
SELECT * FROM restaurant.ytd_matrix
```

```sql branch_health_overview
SELECT * FROM restaurant.branch_index_branch_health_overview
```

```sql branch_health_classification
SELECT * FROM restaurant.branch_index_branch_health_classification
ORDER BY health_status ASC, active_margin_pct DESC
```

```sql profitability_period_compare
SELECT * FROM restaurant.branch_analysis_profitability_period_compare
```

```sql subsidi_silang_data
WITH total AS (
  SELECT SUM(total_revenue) as sum_rev, SUM(net_revenue) as sum_net 
  FROM restaurant.branch_index_branch_summary_30d
)
SELECT 
  b.branch_name,
  b.total_revenue,
  b.net_revenue,
  ROUND(b.net_revenue / NULLIF(b.total_revenue, 0) * 100, 1) as net_margin_pct,
  ROUND(b.total_revenue / t.sum_rev * 100, 1) as rev_contribution_pct,
  ROUND(b.net_revenue / t.sum_net * 100, 1) as net_contribution_pct
FROM restaurant.branch_index_branch_summary_30d b
CROSS JOIN total t
ORDER BY b.total_revenue DESC
```

{#if typeof branch_summary_30d !== 'undefined' && typeof branch_macro_strategic !== 'undefined' && typeof ytd_matrix_data !== 'undefined' && typeof branch_health_overview !== 'undefined' && typeof branch_health_classification !== 'undefined' && typeof profitability_period_compare !== 'undefined' && typeof subsidi_silang_data !== 'undefined'}

<div class="branch-analysis-body">

_Dashboard portofolio cabang: kesehatan margin, pertumbuhan, profitabilitas, strategi, dan prioritas aksi._

<details class="guide-acc"  style="margin-top:12px;">
  <summary>💡 Cara memilih subpage</summary>
<div class="guide-body">
    <p style="margin-top: 4px; margin-bottom: 16px; font-weight: 500; color: var(--color-text-secondary);">
      Navigasikan analisis performa cabang Anda dari ringkasan kesehatan finansial hingga audit granular per outlet.
    </p>
    <div class="guide-grid" style="grid-template-columns: repeat(3, minmax(0, 1fr));">
      <div class="guide-card blue">
        <div class="guide-card-icon">🏠</div>
        <div class="guide-card-content">
          <div class="guide-card-label">Ringkasan</div>
          <h4 class="guide-card-title">Status Utama &amp; Gap</h4>
          <p class="guide-card-desc">Baca cepat volume order, AOV, dan gap ketimpangan antar cabang di seluruh outlet.</p>
        </div>
      </div>
      <div class="guide-card orange">
        <div class="guide-card-icon">🏪</div>
        <div class="guide-card-content">
          <div class="guide-card-label">Deep Dive</div>
          <h4 class="guide-card-title">Audit Per Cabang</h4>
          <p class="guide-card-desc">Audit cabang satu per satu: status margin harian, cogs, tren belanja, dan data pendukung.</p>
        </div>
      </div>
      <div class="guide-card teal">
        <div class="guide-card-icon">🔭</div>
        <div class="guide-card-content">
          <div class="guide-card-label">Analisis</div>
          <h4 class="guide-card-title">Strategi Portofolio</h4>
          <p class="guide-card-desc">Baca analisis pertumbuhan jangka panjang, profitabilitas, dan strategi portofolio cabang.</p>
        </div>
      </div>
    </div>
    <div style="font-size: 0.75rem; color: var(--color-text-secondary); margin-top: 12px;">
      *Total bisnis tetap paling pas dibaca di halaman <a class="inline-link" href="/01-laporan-keuangan">Laporan Keuangan</a>.
    </div>
  </div>
</details>

<div class="evidence-tabs-container">
  <a href="/02-branch-performance" class="tab-button">🏠 Ringkasan</a>
  <a href="/02-branch-performance/deepdive" class="tab-button">🏪 Deep Dive</a>
  <a href="/02-branch-performance/analysis" class="tab-button active">🔭 Evaluasi Strategis</a>
  <a href="/02-branch-performance/direktori-data" class="tab-button">📁 Direktori Data</a>
</div>

  <!-- Panel 1: Kesimpulan (Makro) -->
  <div class="decision-box {boxColorClass}" style="margin-top: 32px; margin-bottom: 48px;">
    <div class="decision-content">
      <div class="decision-title">
        <span style="display: flex; align-items: center; gap: 8px;">
          💡 Insight Operasional & Rekomendasi
        </span>
        <div class="ai-badge">✨ AI Generated</div>
      </div>
      
          <p class="decision-text" style="color: var(--color-text-primary); margin-bottom: 12px;">
            <strong>{iconHeadline} {executiveHeadline}</strong>
          </p>
          
          <p class="decision-text" style="color: var(--color-text-primary); margin-bottom: 16px;">
            {@html kalInti}
          </p>
          

          <div class="metrics-row" style="margin-top: 24px;">
              <div class="metric-pill">⚖️ Dominasi Cabang: {concentrationN} Teratas</div>
              <div class="metric-pill">📊 Kontribusi Omzet: {idFormat(concentrationPct, 1)}%</div>
              <div class="metric-pill">💰 Penopang Laba: {idFormat(concentrationNetPct, 1)}%</div>
              <div class="metric-pill">📉 Tren Menurun: {idFormat(decCount)} Cabang</div>
          </div>

          <div class="decision-footer" style="margin-top: 24px;">
            <em>*Disclaimer: Analisis ini dikalkulasi secara otomatis oleh AI berdasarkan perbandingan rasio portofolio omzet dan profitabilitas lintas cabang selama 30 hari terakhir. Gunakan sebagai petunjuk arah (compass), namun tetap selaraskan dengan strategi ekspansi perusahaan.</em>
          </div>
    </div>
  </div>

  <!-- RISIKO STRUKTURAL SECTION -->
  <div class="diagnostics-header" style="margin-top: 48px; margin-bottom: 24px;">
    <div class="diagnostics-eyebrow">⚠️ DINAMIKA PORTOFOLIO CABANG</div>
    <div class="toc-anchor" style="position: absolute; opacity: 0; pointer-events: none; margin: 0; padding: 0; height: 0; overflow: hidden; font-size: 0px;">

## Membedah Risiko Konsentrasi, Ekspansi, & Subsidi Silang

</div>
<h2 class="diagnostics-title">Membedah Risiko Konsentrasi, Ekspansi, & Subsidi Silang</h2>
    <p class="diagnostics-copy">Memahami bagaimana ketergantungan pada segelintir cabang utama dan jebakan ekspansi buta dapat meruntuhkan fondasi arus kas seluruh jaringan bisnis Anda.</p>
  </div>

  <div class="risk-section">

    <div class="risk-row purple-theme">
      <div class="risk-row-header">
        <span class="risk-row-icon">⚖️</span>
        <h4 class="risk-row-title">Bahaya Pemusatan Risiko (Concentration Risk)</h4>
      </div>
      <div class="risk-pills">
        <div class="risk-pill">
          <span class="risk-pill-anchor">🏢</span>
          <div class="risk-pill-content">
            <strong>Single Point of Failure</strong>
            <span>Bergantung mutlak pada 1-2 cabang menciptakan kerentanan ekstrem terhadap insiden lokal</span>
          </div>
        </div>
        <div class="risk-pill">
          <span class="risk-pill-anchor">🎭</span>
          <div class="risk-pill-content">
            <strong>Ilusi Pertumbuhan</strong>
            <span>Laporan omzet grup yang meroket menutupi fakta bahwa gerai satelit lainnya perlahan mati</span>
          </div>
        </div>
        <div class="risk-pill">
          <span class="risk-pill-anchor">🎯</span>
          <div class="risk-pill-content">
            <strong>Dikte Pemilik Lahan</strong>
            <span>Mudah diperas landlord cabang utama karena arus kas tak bisa hidup tanpa titik lokasi tersebut</span>
          </div>
        </div>
      </div>
      <div class="risk-funfact">
        <span class="risk-funfact-icon">📎</span>
        <div class="risk-funfact-content">
          <span>Ketergantungan pendapatan perusahaan di atas <strong>60%</strong> pada kurang dari 3 titik lokasi meningkatkan risiko kebangkrutan sistemik hingga <strong>2x lipat</strong>.</span>
          <cite>Prinsip Kerentanan Portofolio Ritel</cite>
        </div>
      </div>
    </div>

    <div class="risk-row blue-theme">
      <div class="risk-row-header">
        <span class="risk-row-icon">🕸️</span>
        <h4 class="risk-row-title">Jebakan Ekspansi & Subsidi Silang</h4>
      </div>
      <div class="risk-pills">
        <div class="risk-pill">
          <span class="risk-pill-anchor">🩸</span>
          <div class="risk-pill-content">
            <strong>Subsidi Silang Berdarah</strong>
            <span>Margin murni kerja keras cabang flagship habis dibakar untuk menambal kerugian cabang bawah</span>
          </div>
        </div>
        <div class="risk-pill">
          <span class="risk-pill-anchor">🦈</span>
          <div class="risk-pill-content">
            <strong>Kanibalisasi Trafik</strong>
            <span>Buka cabang baru yang terlalu dekat hanya memecah pelanggan ke 2 kasir dengan 2x lipat biaya sewa</span>
          </div>
        </div>
        <div class="risk-pill">
          <span class="risk-pill-anchor">🐘</span>
          <div class="risk-pill-content">
            <strong>Raksasa Tak Efisien</strong>
            <span>Gerai megah punya omzet raksasa namun persentase marginnya sering kalah telak dari gerai ruko kecil</span>
          </div>
        </div>
      </div>
      <div class="risk-funfact">
        <span class="risk-funfact-icon">📎</span>
        <div class="risk-funfact-content">
          <span>Membuka gerai satelit dalam radius kanibalisasi yang salah dapat menggerus margin operasional keseluruhan grup bisnis sebesar <strong>15%-25%</strong> pada tahun pertama.</span>
          <cite>HBR — Retail Cannibalization Dynamics</cite>
        </div>
      </div>
    </div>
  </div>

  <!-- Panel 2: Analisis Kinerja Lintas Cabang -->
  
  <div class="toc-anchor" style="position: absolute; opacity: 0; pointer-events: none; margin: 0; padding: 0; height: 0; overflow: hidden; font-size: 0px;">

## Pusat Data Ekstra & Perspektif Strategis

</div>
<SectionHeader 
  eyebrow="📑 Ruang Data Pendukung"
  title="Pusat Data Ekstra & Perspektif Strategis"
  description="Gunakan lensa tambahan di bawah ini untuk membedah komposisi mesin pendapatan serta melacak pola tren kesehatan bisnis dalam jangka panjang (Kuartalan & YoY)."
/>

<div class="data-wrapper">
  <Tabs id="analisis_makro_tabs" fullWidth=true>

    <Tab label="⚖️ Aliran Subsidi Silang">
      <div style="margin-top: 24px; margin-bottom: 24px;">
        <BarChart 
          data={subsidi_silang_data} 
          x="branch_name" 
          y="net_revenue" 
          swapXY={true}
          title="Laba Bersih Absolut per Cabang (Rupiah)" 
          xAxisTitle="Nilai Laba Bersih" 
        />
      </div>

      <div>
        <h4 style="margin-bottom: 12px; font-weight: 700; font-size: 1rem;">Aliran Subsidi Silang: Proporsi Omzet vs Penopang Laba</h4>
        <PremiumTable 
          data={subsidi_silang_data} 
          pageSize={10} 
          columns={[
            { title: "Cabang", key: "branch_name", align: "left", bold: true },
            { title: "Omzet (30H)", key: "total_revenue", align: "right", type: "currency" },
            { title: "Porsi Omzet", key: "rev_contribution_pct", align: "right", type: "pct" },
            { title: "Laba Bersih (30H)", key: "net_revenue", align: "right", type: "currency" },
            { title: "Porsi Laba Bersih", key: "net_contribution_pct", align: "right", type: "pct", colorRules: "growth" },
            { title: "Margin Murni", key: "net_margin_pct", align: "right", type: "pct", showPlus: true, colorRules: "growth" }
          ]} 
        />
      </div>
    </Tab>
    
    <Tab label="📍 Matriks Prioritas">
      <div style="margin-top: 24px; margin-bottom: 24px;">
        <ScatterPlot 
          data={ytd_matrix_data} 
          x="active_margin_pct" 
          y="baseline_change_pct" 
          xFmt="num1"
          yFmt="num1"
          series="branch_name" 
          xAxisTitle="Margin YTD (%)" 
          yAxisTitle="Tren Order (YTD vs YoY %)" 
          title="Matriks Prioritas Jangka Panjang: Margin vs Tren Pengunjung"
        />
      </div>

      <!-- Legenda Kuadran -->
      <div class="quadrant-grid">
        <div class="quadrant-card quad-stars">
          <div class="quadrant-title">↗️ Kanan Atas (The Stars)</div>
          <p class="quadrant-desc"><strong>Margin Tinggi + Pengunjung Naik:</strong><br/>Cabang andalan yang berkontribusi positif pada profitabilitas dan pangsa pasar.</p>
        </div>
        <div class="quadrant-card quad-decaying">
          <div class="quadrant-title">↘️ Kanan Bawah (Decaying Giants)</div>
          <p class="quadrant-desc"><strong>Margin Tinggi + Pengunjung Turun:</strong><br/>Cabang yang masih memberikan margin positif namun secara perlahan mulai mengalami penyusutan pelanggan.</p>
        </div>
        <div class="quadrant-card quad-leaking">
          <div class="quadrant-title">↖️ Kiri Atas (Leaking Bucket)</div>
          <p class="quadrant-desc"><strong>Margin Tipis/Minus + Pengunjung Naik:</strong><br/>Cabang berkinerja tinggi dalam volume order, namun rentan oleh kebocoran pada margin dan beban biaya.</p>
        </div>
        <div class="quadrant-card quad-parasites">
          <div class="quadrant-title">↙️ Kiri Bawah (The Parasites)</div>
          <p class="quadrant-desc"><strong>Margin Minus + Pengunjung Turun:</strong><br/>Cabang dengan kondisi operasional defisit yang siklus operasinya disokong murni dari subsidi silang.</p>
        </div>
      </div>

      <div>
        <h4 style="margin-bottom: 12px; font-weight: 700; font-size: 1rem;">Perbandingan Kinerja Struktural (YTD vs Previous YTD)</h4>
        <PremiumTable 
          data={ytd_matrix_data} 
          pageSize={10} 
          columns={[
            { title: "Cabang", key: "branch_name", align: "left", bold: true },
            { title: "Status Kesehatan", key: "health_status", align: "center", colorRules: "health" },
            { title: "Margin YTD", key: "active_margin_pct", prevKey: "prev_margin_pct", align: "right", type: "margin_growth" },
            { title: "Order YTD", key: "active_orders", prevKey: "prev_orders", align: "right", type: "number_growth" }
          ]} 
        />
        <div style="margin-top: 12px; font-size: 0.8rem; color: var(--color-text-secondary); background: rgba(0,0,0,0.02); padding: 8px 12px; border-radius: 6px; display: inline-block;">
          📌 <strong>Catatan:</strong> Metrik Margin dan Order menggunakan perhitungan <em>Year-To-Date (YTD)</em>. Angka pertumbuhan (▲/▼) membandingkan kinerja kalender berjalan tahun ini dengan hari yang sama pada tahun sebelumnya, sehingga terbebas dari bias musiman.
        </div>
      </div>
    </Tab>

  </Tabs>
</div>

</div>

{:else}
  <GlobalLoading />
{/if}
