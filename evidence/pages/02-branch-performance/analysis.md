---
title: Performa Cabang
sidebar_link: false
---

<script>
  import DiagnosticsHeader from '$lib/DiagnosticsHeader.svelte';
  import SectionHeader from '$lib/SectionHeader.svelte';
  import SectionCard from '$lib/SectionCard.svelte';
</script>

<style>
/* Paksa menu sidebar parent tetap aktif (hijau) saat berada di subpage ini menggunakan :global() */
:global(aside a[href="/02-branch-performance"]),
:global(#mobileScrollable a[href="/02-branch-performance"]) {
  background: linear-gradient(135deg, rgba(13, 148, 136, 0.08), rgba(20, 184, 166, 0.06)) !important;
  color: #0f766e !important;
  font-weight: 700 !important;
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.4) !important;
  border-left: 3px solid #0d9488 !important;
  padding-left: 12px !important;
}

:global([data-theme='dark'] aside a[href="/02-branch-performance"]),
:global([data-theme='dark'] #mobileScrollable a[href="/02-branch-performance"]) {
  background: linear-gradient(135deg, rgba(20, 184, 166, 0.15), rgba(45, 212, 191, 0.08)) !important;
  color: #2dd4bf !important;
  border-left-color: #14b8a6 !important;
}

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
}
.warning-banner-title {
  margin: 0 0 6px 0;
  color: #b45309;
  font-size: 0.95rem;
  font-weight: 700;
  letter-spacing: 0.02em;
}
.warning-banner-desc {
  margin: 0;
  color: var(--color-text-secondary);
  font-size: 0.85rem;
  line-height: 1.6;
}
:global([data-theme='dark']) .warning-banner {
  background: linear-gradient(135deg, rgba(245, 158, 11, 0.15), rgba(251, 191, 36, 0.05));
  border-color: rgba(245, 158, 11, 0.4);
}
:global([data-theme='dark']) .warning-banner-title {
  color: #fbbf24;
}
</style>

```sql branch_aov_order_monthly
SELECT * FROM restaurant.branch_analysis_branch_aov_order_monthly
```

```sql portfolio_inflation_adjusted
SELECT * FROM restaurant.branch_analysis_portfolio_inflation_adjusted
```

```sql latest_month_inflation_adjusted
SELECT * FROM restaurant.branch_analysis_latest_month_inflation_adjusted
```

```sql monthly_inflation_adjusted
SELECT * FROM restaurant.branch_analysis_monthly_inflation_adjusted
```

```sql branch_min_max_daily
SELECT * FROM restaurant.branch_analysis_branch_min_max_daily
```

```sql latest_growth_driver
SELECT * FROM restaurant.branch_analysis_latest_growth_driver
```

```sql branch_wow
SELECT * FROM restaurant.branch_analysis_branch_wow
```

```sql profitability_period_compare
SELECT * FROM restaurant.branch_analysis_profitability_period_compare
```

```sql branch_concentration
SELECT * FROM restaurant.branch_analysis_branch_concentration
```


<div class="branch-analysis-body">

  <!-- Hero Banner -->
  <div style="margin-bottom: 24px;">
    <div class="subpage-hero-eyebrow">🔭 ANALISIS DEKOMPOSISI &amp; STRUKTURAL</div>
    <h1 class="subpage-hero-title">Analisis Lanjutan Performa Cabang</h1>
    <p class="subpage-hero-copy">Analisis makro dan mikro komprehensif mengenai penggerak omzet bulanan, perbandingan riil nominal revenue akibat inflasi, serta pemetaan stabilitas pendapatan harian cabang.</p>
  </div>

  <!-- Tab Navigation -->
  <div class="evidence-tabs-container">
    <a href="/02-branch-performance" class="tab-button">🏠 Ringkasan</a>
    <a href="/02-branch-performance/deepdive" class="tab-button">🏪 Deep Dive</a>
    <a href="/02-branch-performance/analysis" class="tab-button active">🔭 Analisis Lanjutan</a>
  </div>

  <details class="guide-acc"  style="margin-top:12px; margin-bottom:12px;">
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

  <!-- Global Incomplete Month Warning -->
  <div class="warning-banner">
    <div style="font-size: 1.5rem; line-height: 1.1;">📢</div>
    <div>
      <h4 class="warning-banner-title">Informasi Penting: Data Bulan Berjalan Dikecualikan</h4>
      <p class="warning-banner-desc">
        Guna menghindari kesimpulan yang salah (misleading), data pada bulan berjalan yang belum selesai/lengkap sengaja <strong>tidak ditampilkan</strong> pada grafik bulanan di halaman ini. Evaluasi bulanan hanya membandingkan bulan-bulan operasional yang telah selesai secara penuh (30 atau 31 hari penuh).
      </p>
    </div>
  </div>

  <!-- Executive Summary Cards -->
  <div class="period-strip" style="margin-bottom: 24px;">
    {#if branch_wow.length > 0}
      <div class="period-pill sehat">
        <div class="period-pill-label">🚀 Momentum Terbaik (WoW)</div>
        <div class="period-pill-value">{branch_wow[0].branch_name} ({branch_wow[0].pct_change >= 0 ? '+' : ''}{branch_wow[0].pct_change}%)</div>
        <div class="period-pill-copy">Pertumbuhan WoW terkuat. Cabang terlemah minggu ini adalah {branch_wow[branch_wow.length - 1].branch_name} ({branch_wow[branch_wow.length - 1].pct_change}%).</div>
      </div>
    {/if}

    {#if profitability_period_compare.length > 0}
      <div class="period-pill kritis">
        <div class="period-pill-label">⚠️ Margin Terlemah (30H)</div>
        <div class="period-pill-value">{profitability_period_compare[0].branch_name} ({profitability_period_compare[0].margin_30d}%)</div>
        <div class="period-pill-copy">Margin laba terendah 30 hari terakhir. Perhatikan jika margin 30H jauh di bawah margin historisnya ({profitability_period_compare[0].margin_historical}%).</div>
      </div>
    {/if}

    {#if branch_concentration.length > 0}
      <div class="period-pill waspada">
        <div class="period-pill-label">💎 Cabang Dominan (30H)</div>
        <div class="period-pill-value">{branch_concentration[0].top_branch_30d} ({branch_concentration[0].top_share_30d}%)</div>
        <div class="period-pill-copy">Memegang kontribusi terbesar dari total revenue 30H. Disusul oleh {branch_concentration[0].second_branch_30d} ({branch_concentration[0].second_share_30d}%).</div>
      </div>
    {/if}
  </div>

  <!-- Panel 1: Driver Omzet Bulanan (Orders vs AOV) -->
  <DiagnosticsHeader 
    eyebrow="👥 Tren Driver Omzet"
    title="Apakah Omzet Naik Karena Pelanggan Bertambah atau Cuma Karena Harga Naik?"
    description="Menampilkan tren pergerakan volume order dan rata-rata AOV secara bulanan untuk mengidentifikasi apakah performa didorong oleh peningkatan volume kunjungan pelanggan atau kenaikan rata-rata nilai transaksi."
  />

    <div style="display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 24px; margin-bottom: 24px;">
      <div>
        <LineChart data={branch_aov_order_monthly} x="order_month" y="total_orders" series="branch_name" title="Tren Volume Order Bulanan per Cabang" yFmt="#,##0" xAxisTitle="Bulan" yAxisTitle="Jumlah Order" />
        <div class="chart-insight-bar">
          📌 <strong>Trafik Bulanan:</strong> Menunjukkan pertumbuhan basis pelanggan riil. Tren yang meningkat menandakan loyalitas dan daya tarik pasar yang makin kuat.
        </div>
      </div>
      <div>
        <LineChart data={branch_aov_order_monthly} x="order_month" y="avg_order_value" series="branch_name" title="Tren Rata-rata AOV Bulanan per Cabang" yFmt="#,##0" xAxisTitle="Bulan" yAxisTitle="AOV (Rp)" />
        <div class="chart-insight-bar">
          📌 <strong>Nilai Belanja Bulanan:</strong> Menunjukkan keberhasilan kru outlet dalam melakukan upselling atau efektivitas paket menu bundling.
        </div>
      </div>
    </div>

    <details class="acc-strategic">
      <summary>💡 Insight &amp; Diagnostik Driver Omzet</summary>
      <div class="acc-body">
        {#if latest_growth_driver && latest_growth_driver.length > 0}
        {@const topRev = [...latest_growth_driver].sort((a,b) => b.revenue_growth_pct - a.revenue_growth_pct)[0]}
        {@const topOrder = [...latest_growth_driver].sort((a,b) => b.order_growth_pct - a.order_growth_pct)[0]}
        {@const topAov = [...latest_growth_driver].sort((a,b) => b.aov_growth_pct - a.aov_growth_pct)[0]}
        
        <div class="signal-card {topRev.revenue_growth_pct >= 0 ? 'safe' : 'critical'}" style="margin-bottom:16px;">
          <div class="signal-label">
            {topRev.revenue_growth_pct >= 0 ? '✅' : '🚨'} Performa Cabang Terbaik
          </div>
          <div class="signal-title">{topRev.branch_name} memimpin dengan pertumbuhan revenue {topRev.revenue_growth_pct > 0 ? '+' : ''}{topRev.revenue_growth_pct}%.</div>
          <div class="signal-copy">
            Berasal dari pertumbuhan order {topOrder.order_growth_pct > 0 ? '+' : ''}{topOrder.order_growth_pct}% dan AOV {topAov.aov_growth_pct > 0 ? '+' : ''}{topAov.aov_growth_pct}%.
          </div>
        </div>

        <div class="mini-grid" style="margin-bottom:16px; display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 12px;">
          <div class="mini-card" style="padding: 16px; border-radius: 12px; border: 1px solid var(--color-border-tertiary); background: var(--color-background-secondary);">
            <div class="kpi-label" style="font-size: 10px; font-weight: 700; color: var(--color-text-tertiary); margin-bottom: 8px;">📈 Top Revenue Growth</div>
            <div class="mini-value" style="font-size: 1.25rem; font-weight: 800; margin-bottom: 4px;">{topRev.revenue_growth_pct}%</div>
            <div class="mini-note" style="font-size: 0.75rem; color: var(--color-text-secondary);">Dicapai oleh {topRev.branch_name}.</div>
          </div>
          <div class="mini-card" style="padding: 16px; border-radius: 12px; border: 1px solid var(--color-border-tertiary); background: var(--color-background-secondary);">
            <div class="kpi-label" style="font-size: 10px; font-weight: 700; color: var(--color-text-tertiary); margin-bottom: 8px;">🛒 Top Order Growth</div>
            <div class="mini-value" style="font-size: 1.25rem; font-weight: 800; margin-bottom: 4px;">{topOrder.order_growth_pct}%</div>
            <div class="mini-note" style="font-size: 0.75rem; color: var(--color-text-secondary);">Dicapai oleh {topOrder.branch_name}.</div>
          </div>
          <div class="mini-card" style="padding: 16px; border-radius: 12px; border: 1px solid var(--color-border-tertiary); background: var(--color-background-secondary);">
            <div class="kpi-label" style="font-size: 10px; font-weight: 700; color: var(--color-text-tertiary); margin-bottom: 8px;">💳 Top AOV Growth</div>
            <div class="mini-value" style="font-size: 1.25rem; font-weight: 800; margin-bottom: 4px;">{topAov.aov_growth_pct}%</div>
            <div class="mini-note" style="font-size: 0.75rem; color: var(--color-text-secondary);">Dicapai oleh {topAov.branch_name}.</div>
          </div>
        </div>
        {/if}
      </div>
    </details>

    <div class="table-container" style="margin-top: 16px; margin-bottom: 32px;">
      <h4 style="margin-bottom: 12px; font-weight: 700; font-size: 1rem;">Tabel Driver Pertumbuhan Bulanan (MoM) Cabang</h4>
      <DataTable data={latest_growth_driver} search=true>
        <Column id="branch_name" title="Cabang"/>
        <Column id="revenue_growth_pct" title="Pertumbuhan Revenue" fmt="+0.0;-0.0" contentType="delta"/>
        <Column id="order_growth_pct" title="Pertumbuhan Order" fmt="+0.0;-0.0" contentType="delta"/>
        <Column id="aov_growth_pct" title="Pertumbuhan AOV" fmt="+0.0;-0.0" contentType="delta"/>
      </DataTable>
    </div>

  <!-- Panel 2: Nominal vs Real Revenue in Rupiah -->
  <DiagnosticsHeader 
    eyebrow="📊 Dampak Makro"
    title="Apakah Profit Kita Nyata, Atau Diam-diam Dimakan Inflasi?"
    description="Menghitung seberapa besar nilai pendapatan operasional Anda terkikis oleh inflasi operasional bulanan (deflator benchmark 0.3% per bulan) sejak awal periode data."
  />

    <div style="display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 24px; margin-bottom: 24px;">
      <div>
        <LineChart data={portfolio_inflation_adjusted} x="order_month" y={["nominal_revenue","real_revenue"]} title="Total Revenue Portofolio: Nominal vs. Riil (Seluruh Cabang)" yFmt="#,##0" xAxisTitle="Bulan" yAxisTitle="Revenue (Rp)" />
        <div class="chart-insight-bar">
          📌 <strong>Erosi Portofolio:</strong> Celah di antara kedua garis menunjukkan akumulasi daya beli dan profitabilitas yang hilang akibat kenaikan inflasi makro.
        </div>
      </div>
      <div>
        <BarChart data={latest_month_inflation_adjusted} x="branch_name" y={["nominal_revenue","real_revenue"]} type="grouped" title="Revenue Nominal vs. Riil per Cabang (Bulan Terbaru)" yFmt="#,##0" xAxisTitle="Cabang" yAxisTitle="Revenue (Rp)" />
        <div class="chart-insight-bar">
          📌 <strong>Kehilangan per Cabang:</strong> Membandingkan langsung seberapa besar penurunan nilai riil pendapatan untuk setiap cabang di bulan aktif terakhir.
        </div>
      </div>
    </div>

    <details class="acc-strategic">
      <summary>💡 Insight &amp; Diagnostik Inflasi</summary>
      <div class="acc-body">
        {#if monthly_inflation_adjusted && monthly_inflation_adjusted.length > 0}
        {@const maxLossBranch = [...monthly_inflation_adjusted].sort((a,b) => b.inflation_loss - a.inflation_loss)[0]}
        
        <div class="signal-card {maxLossBranch.inflation_loss > 0 ? 'warn' : 'safe'}" style="margin-bottom:16px;">
          <div class="signal-label">
            {maxLossBranch.inflation_loss > 0 ? '⚠️' : '✅'} Cabang Paling Terdampak
          </div>
          <div class="signal-title">{maxLossBranch.branch_name} mencatat erosi terbesar akibat inflasi.</div>
          <div class="signal-copy">
            Jika garis Nominal dan Riil semakin menjauh, dampak inflasi biaya sedang menggerus profitabilitas cabang ini dengan agresif meskipun pendapatan di atas kertas terlihat tumbuh.
          </div>
        </div>

        <div class="mini-grid" style="margin-bottom:16px; display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 12px;">
          <div class="mini-card" style="padding: 16px; border-radius: 12px; border: 1px solid var(--color-border-tertiary); background: var(--color-background-secondary);">
            <div class="kpi-label" style="font-size: 10px; font-weight: 700; color: var(--color-text-tertiary); margin-bottom: 8px;">🔻 Kerugian Inflasi Maksimal</div>
            <div class="mini-value" style="font-size: 1.25rem; font-weight: 800; margin-bottom: 4px; color: #dc2626;">Rp {maxLossBranch.inflation_loss.toLocaleString('id-ID')}</div>
            <div class="mini-note" style="font-size: 0.75rem; color: var(--color-text-secondary);">Dialami oleh {maxLossBranch.branch_name} pada {maxLossBranch.order_month}.</div>
          </div>
          <div class="mini-card" style="padding: 16px; border-radius: 12px; border: 1px solid var(--color-border-tertiary); background: var(--color-background-secondary);">
            <div class="kpi-label" style="font-size: 10px; font-weight: 700; color: var(--color-text-tertiary); margin-bottom: 8px;">💡 Aksi Lanjutan</div>
            <div class="mini-value" style="font-size: 1.05rem; font-weight: 800; margin-bottom: 4px;">Evaluasi Harga (Repricing)</div>
            <div class="mini-note" style="font-size: 0.75rem; color: var(--color-text-secondary);">Sinyal kuat untuk segera menegosiasi ulang supplier bahan.</div>
          </div>
        </div>
        {/if}
      </div>
    </details>

    <div class="table-container" style="margin-top: 16px; margin-bottom: 32px;">
      <h4 style="margin-bottom: 12px; font-weight: 700; font-size: 1rem;">Histori Laba Tergerus Inflasi per Cabang</h4>
      <DataTable data={monthly_inflation_adjusted} search=true>
        <Column id="branch_name" title="Cabang"/>
        <Column id="order_month" title="Bulan" fmt="yyyy-mm"/>
        <Column id="nominal_revenue" title="Revenue Nominal (Rp)" fmt="#,##0"/>
        <Column id="real_revenue" title="Revenue Riil (Rp)" fmt="#,##0"/>
        <Column id="inflation_loss" title="Nilai Tergerus Inflasi (Rp)" fmt="#,##0"/>
      </DataTable>
    </div>

  <!-- Panel 3: Min vs Avg vs Max Daily Revenue -->
  <DiagnosticsHeader 
    eyebrow="🧭 Konsistensi Harian"
    title="Seburuk Apa Fluktuasi Kas Harian Kita? (Stres Tes Operasional)"
    description="Menunjukkan batas terendah harian, rata-rata harian, dan batas tertinggi harian pendapatan kas harian selama 30 hari terakhir. Digunakan untuk melihat stabilitas pendapatan harian."
  />

    <BarChart data={branch_min_max_daily} x="branch_name" y={["min_daily_revenue","avg_daily_revenue","max_daily_revenue"]} type="grouped" title="Rentang Fluktuasi Pendapatan Harian per Cabang (30H)" yFmt="#,##0" xAxisTitle="Cabang" yAxisTitle="Revenue (Rp)" />
    <div class="chart-insight-bar">
      📌 <strong>Cara Membaca Rentang:</strong> Cabang dengan rentang batang yang <strong>rapat/sempit</strong> mengindikasikan tingkat pendapatan harian yang stabil dan konsisten. Cabang dengan rentang batang yang <strong>sangat renggang/lebar</strong> memiliki fluktuasi harian yang ekstrem dan berisiko tinggi.
    </div>

    <details class="acc-strategic">
      <summary>💡 Insight &amp; Diagnostik Fluktuasi Harian</summary>
      <div class="acc-body">
        {#if branch_min_max_daily && branch_min_max_daily.length > 0}
        {@const maxFluct = [...branch_min_max_daily].sort((a,b) => b.fluctuation_pct - a.fluctuation_pct)[0]}
        
        <div class="signal-card {maxFluct.fluctuation_pct >= 2.0 ? 'critical' : maxFluct.fluctuation_pct >= 1.0 ? 'warn' : 'safe'}" style="margin-bottom:16px;">
          <div class="signal-label">
            {maxFluct.fluctuation_pct >= 2.0 ? '🚨' : maxFluct.fluctuation_pct >= 1.0 ? '⚠️' : '✅'} Peringatan Fluktuasi Ekstrem
          </div>
          <div class="signal-title">Cabang {maxFluct.branch_name} sangat tidak stabil dengan fluktuasi mencapai {(maxFluct.fluctuation_pct * 100).toFixed(1)}%.</div>
          <div class="signal-copy">
            Rentang batas terendah dan tertinggi yang terlampau lebar mengakibatkan beban manajemen staf (staffing) dan manajemen stok bahan menjadi sangat rawan *waste* (kebocoran).
          </div>
        </div>

        <div class="mini-grid" style="margin-bottom:16px; display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 12px;">
          <div class="mini-card" style="padding: 16px; border-radius: 12px; border: 1px solid var(--color-border-tertiary); background: var(--color-background-secondary);">
            <div class="kpi-label" style="font-size: 10px; font-weight: 700; color: var(--color-text-tertiary); margin-bottom: 8px;">📊 Stabilitas Terburuk</div>
            <div class="mini-value" style="font-size: 1.25rem; font-weight: 800; margin-bottom: 4px; color: #dc2626;">Cabang {maxFluct.branch_name}</div>
            <div class="mini-note" style="font-size: 0.75rem; color: var(--color-text-secondary);">Rasio fluktuasi {(maxFluct.fluctuation_pct * 100).toFixed(1)}%. Risiko staffing tinggi.</div>
          </div>
          <div class="mini-card" style="padding: 16px; border-radius: 12px; border: 1px solid var(--color-border-tertiary); background: var(--color-background-secondary);">
            <div class="kpi-label" style="font-size: 10px; font-weight: 700; color: var(--color-text-tertiary); margin-bottom: 8px;">📉 Kerugian Fluktuasi</div>
            <div class="mini-value" style="font-size: 1.25rem; font-weight: 800; margin-bottom: 4px; color: #dc2626;">Rp {maxFluct.daily_range_revenue.toLocaleString('id-ID')}</div>
            <div class="mini-note" style="font-size: 0.75rem; color: var(--color-text-secondary);">Beda hari tersepi dan teramai mencapai sejauh ini.</div>
          </div>
        </div>
        {/if}
      </div>
    </details>

    <div class="table-container" style="margin-top: 16px; margin-bottom: 32px;">
      <h4 style="margin-bottom: 12px; font-weight: 700; font-size: 1rem;">Tabel Audit Fluktuasi Kas &amp; Rentang Harian Cabang</h4>
      <DataTable data={branch_min_max_daily} search=true>
        <Column id="branch_name" title="Cabang"/>
        <Column id="min_daily_revenue" title="Pendapatan Terendah (Rp)" fmt="#,##0"/>
        <Column id="avg_daily_revenue" title="Pendapatan Rata-rata (Rp)" fmt="#,##0"/>
        <Column id="max_daily_revenue" title="Pendapatan Tertinggi (Rp)" fmt="#,##0"/>
        <Column id="daily_range_revenue" title="Rentang Harian (Rp)" fmt="#,##0"/>
        <Column id="fluctuation_pct" title="Rasio Fluktuasi (%)" fmt="0.0\%"/>
      </DataTable>
    </div>

</div>

