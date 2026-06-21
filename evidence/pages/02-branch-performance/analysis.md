---
title: Performa Cabang
sidebar_link: false
---

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
  <div class="hero-banner">
    <div class="hero-banner-eyebrow">🔭 ANALISIS DEKOMPOSISI &amp; STRUKTURAL</div>
    <h3 class="hero-banner-title">Analisis Lanjutan Performa Cabang</h3>
    <p class="hero-banner-desc">Analisis makro dan mikro komprehensif mengenai penggerak omzet bulanan, perbandingan riil nominal revenue akibat inflasi, serta pemetaan stabilitas pendapatan harian cabang.</p>
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
  <details class="guide-acc"  open>
  <summary>💡 Informasi Penting: Data Bulan Berjalan Dikecualikan</summary>
<div class="guide-body">
      Guna menghindari kesimpulan yang salah (misleading), data pada bulan berjalan yang belum selesai/lengkap sengaja <strong>tidak ditampilkan</strong> pada grafik bulanan di halaman ini. Evaluasi bulanan hanya membandingkan bulan-bulan operasional yang telah selesai secara penuh (30 atau 31 hari penuh).
    </div>
</details>

  <!-- Executive Summary Cards -->
  <div class="stats-cards-grid">
    {#if branch_wow.length > 0}
      <div class="stats-card growth">
        <span class="stats-card-label">🚀 Momentum Terbaik (WoW)</span>
        <span class="stats-card-title">{branch_wow[0].branch_name} ({branch_wow[0].pct_change >= 0 ? '+' : ''}{branch_wow[0].pct_change}%)</span>
        <span class="stats-card-desc">Pertumbuhan WoW terkuat. Cabang terlemah minggu ini adalah {branch_wow[branch_wow.length - 1].branch_name} ({branch_wow[branch_wow.length - 1].pct_change}%).</span>
      </div>
    {/if}

    {#if profitability_period_compare.length > 0}
      <div class="stats-card profit">
        <span class="stats-card-label">⚠️ Margin Terlemah (30H)</span>
        <span class="stats-card-title">{profitability_period_compare[0].branch_name} ({profitability_period_compare[0].margin_30d}%)</span>
        <span class="stats-card-desc">Margin laba terendah 30 hari terakhir. Perhatikan jika margin 30H jauh di bawah margin historisnya ({profitability_period_compare[0].margin_historical}%).</span>
      </div>
    {/if}

    {#if branch_concentration.length > 0}
      <div class="stats-card strategy">
        <span class="stats-card-label">💎 Cabang Dominan (30H)</span>
        <span class="stats-card-title">{branch_concentration[0].top_branch_30d} ({branch_concentration[0].top_share_30d}%)</span>
        <span class="stats-card-desc">Memegang kontribusi terbesar dari total revenue 30H. Disusul oleh {branch_concentration[0].second_branch_30d} ({branch_concentration[0].second_share_30d}%).</span>
      </div>
    {/if}
  </div>

  <!-- Panel 1: Driver Omzet Bulanan (Orders vs AOV) -->
  <div class="panel-card">
    <h3 class="panel-title">👥 Tren Driver Omzet: Analisis Bulanan Trafik vs. Nilai Belanja</h3>
    <p class="panel-desc">Menampilkan tren pergerakan volume order dan rata-rata AOV secara bulanan untuk mengidentifikasi apakah performa didorong oleh peningkatan volume kunjungan pelanggan atau kenaikan rata-rata nilai transaksi.</p>

    <div class="double-charts-grid">
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

    <!-- Mini Interpretation Accordion -->
    <details class="guide-acc" >
  <summary>💡 Panduan Interpretasi Grafik Driver Omzet</summary>
<div class="guide-body">
        
      <div class="guide-grid" style="grid-template-columns: repeat(3, minmax(0, 1fr));">
        <div class="guide-card blue">
          <div class="guide-card-icon">💵</div>
          <div class="guide-card-content">
            <div class="guide-card-label">GRAFIK ORDER NAIK + GRAFIK AOV NAIK:</div>
            <h4 class="guide-card-title">Grafik Order Naik + Grafik AOV Naik:</h4>
            <p class="guide-card-desc">Grafik Order Naik + Grafik AOV Naik: Kondisi prima. Cabang sukses mendatangkan pelanggan baru sekaligus meningkatkan nilai belanja per transaksi (bundling/upsell berhasil).</p>
          </div>
        </div>
        <div class="guide-card blue">
          <div class="guide-card-icon">💵</div>
          <div class="guide-card-content">
            <div class="guide-card-label">GRAFIK ORDER TURUN + GRAFIK AOV NAIK:</div>
            <h4 class="guide-card-title">Grafik Order Turun + Grafik AOV Naik:</h4>
            <p class="guide-card-desc">Grafik Order Turun + Grafik AOV Naik: Alarm bahaya. Pelanggan mulai berkurang, namun omzet diselamatkan karena kenaikan harga menu atau pelanggan membeli produk mahal. Perlu audit kepuasan pelanggan.</p>
          </div>
        </div>
        <div class="guide-card blue">
          <div class="guide-card-icon">💵</div>
          <div class="guide-card-content">
            <div class="guide-card-label">GRAFIK ORDER NAIK + GRAFIK AOV TURUN:</div>
            <h4 class="guide-card-title">Grafik Order Naik + Grafik AOV Turun:</h4>
            <p class="guide-card-desc">Grafik Order Naik + Grafik AOV Turun: Promosi mendatangkan massa, tetapi mereka hanya memesan menu murah/diskonan. Upaya upselling staf outlet perlu dievaluasi.</p>
          </div>
        </div>
      </div>

      </div>
</details>

    <details class="acc-strategic" open>
      <summary>📈 Tabel Driver Pertumbuhan Bulanan (MoM) Cabang</summary>
      <div class="acc-body">
        <div class="table-container">
          <DataTable data={latest_growth_driver} search=true>
            <Column id="branch_name" title="Cabang"/>
            <Column id="revenue_growth_pct" title="Pertumbuhan Revenue" fmt="+0.0;-0.0" contentType="delta"/>
            <Column id="order_growth_pct" title="Pertumbuhan Order" fmt="+0.0;-0.0" contentType="delta"/>
            <Column id="aov_growth_pct" title="Pertumbuhan AOV" fmt="+0.0;-0.0" contentType="delta"/>
          </DataTable>
        </div>
      </div>
    </details>
  </div>

  <!-- Panel 2: Nominal vs Real Revenue in Rupiah -->
  <div class="panel-card">
    <h3 class="panel-title">📊 Dampak Makro: Nilai Omzet Nominal vs. Nilai Riil (Rupiah Loss)</h3>
    <p class="panel-desc">Menghitung seberapa besar nilai pendapatan operasional Anda terkikis oleh inflasi operasional bulanan (deflator benchmark 0.3% per bulan) sejak awal periode data.</p>

    <div class="double-charts-grid">
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

    <!-- Mini Interpretation Accordion -->
    <details class="guide-acc" >
  <summary>💡 Panduan Interpretasi Grafik Erosi Inflasi</summary>
<div class="guide-body">
        
      <div class="guide-grid" style="grid-template-columns: repeat(2, minmax(0, 1fr));">
        <div class="guide-card blue">
          <div class="guide-card-icon">💡</div>
          <div class="guide-card-content">
            <div class="guide-card-label">GARIS NOMINAL DAN RIIL SALING MENJAUH:</div>
            <h4 class="guide-card-title">Garis Nominal dan Riil Saling Menjauh:</h4>
            <p class="guide-card-desc">Garis Nominal dan Riil Saling Menjauh: Dampak kenaikan inflasi biaya operasional sedang agresif menggerus profit bisnis. Omzet tampak naik di kasir, tetapi daya beli riil uang Anda menyusut.</p>
          </div>
        </div>
        <div class="guide-card orange">
          <div class="guide-card-icon">💡</div>
          <div class="guide-card-content">
            <div class="guide-card-label">GARIS RIIL MENURUN TAJAM:</div>
            <h4 class="guide-card-title">Garis Riil Menurun Tajam:</h4>
            <p class="guide-card-desc">Garis Riil Menurun Tajam: Sinyal kuat untuk segera melakukan negosiasi ulang kontrak dengan supplier bahan baku utama atau meninjau harga jual (*repricing*) demi melindungi keuntungan riil.</p>
          </div>
        </div>
      </div>

      </div>
</details>

    <details class="acc-strategic" open>
      <summary>📈 Tabel Histori Laba Tergerus Inflasi per Cabang</summary>
      <div class="acc-body">
        <div class="table-container">
          <DataTable data={monthly_inflation_adjusted} search=true>
            <Column id="branch_name" title="Cabang"/>
            <Column id="order_month" title="Bulan" fmt="yyyy-mm"/>
            <Column id="nominal_revenue" title="Revenue Nominal (Rp)" fmt="#,##0"/>
            <Column id="real_revenue" title="Revenue Riil (Rp)" fmt="#,##0"/>
            <Column id="inflation_loss" title="Nilai Tergerus Inflasi (Rp)" fmt="#,##0"/>
          </DataTable>
        </div>
      </div>
    </details>
  </div>

  <!-- Panel 3: Min vs Avg vs Max Daily Revenue -->
  <div class="panel-card">
    <h3 class="panel-title">🧭 Konsistensi Harian: Rentang Fluktuasi Pendapatan Harian (Min vs. Rata-rata vs. Max)</h3>
    <p class="panel-desc">Menunjukkan batas terendah harian, rata-rata harian, dan batas tertinggi harian pendapatan kas harian selama 30 hari terakhir. Digunakan untuk melihat stabilitas pendapatan tanpa kebingungan rumus statistik.</p>

    <BarChart data={branch_min_max_daily} x="branch_name" y={["min_daily_revenue","avg_daily_revenue","max_daily_revenue"]} type="grouped" title="Rentang Fluktuasi Pendapatan Harian per Cabang (30H)" yFmt="#,##0" xAxisTitle="Cabang" yAxisTitle="Revenue (Rp)" />
    <div class="chart-insight-bar">
      📌 <strong>Cara Membaca Rentang:</strong> Cabang dengan rentang batang yang <strong>rapat/sempit</strong> mengindikasikan tingkat pendapatan harian yang stabil dan konsisten. Cabang dengan rentang batang yang <strong>sangat renggang/lebar</strong> memiliki fluktuasi harian yang ekstrem dan berisiko tinggi.
    </div>

    <!-- Mini Interpretation Accordion -->
    <details class="guide-acc" >
  <summary>💡 Panduan Interpretasi Grafik Rentang Harian</summary>
<div class="guide-body">
        
      <div class="guide-grid" style="grid-template-columns: repeat(2, minmax(0, 1fr));">
        <div class="guide-card blue">
          <div class="guide-card-icon">💡</div>
          <div class="guide-card-content">
            <div class="guide-card-label">RENTANG BATANG MIN DAN MAX RAPAT:</div>
            <h4 class="guide-card-title">Rentang Batang Min dan Max Rapat:</h4>
            <p class="guide-card-desc">Rentang Batang Min dan Max Rapat: Cabang memiliki kas harian sangat stabil. Memudahkan alokasi penjadwalan staf dan meminimalkan risiko bahan baku basi/terbuang.</p>
          </div>
        </div>
        <div class="guide-card orange">
          <div class="guide-card-icon">💡</div>
          <div class="guide-card-content">
            <div class="guide-card-label">RENTANG BATANG MIN DAN MAX SANGAT LEBAR:</div>
            <h4 class="guide-card-title">Rentang Batang Min dan Max Sangat Lebar:</h4>
            <p class="guide-card-desc">Rentang Batang Min dan Max Sangat Lebar: Fluktuasi ekstrem. Ada risiko kekurangan stok saat puncak keramaian mendadak, atau pemborosan jam kerja pegawai saat toko sepi secara tiba-tiba.</p>
          </div>
        </div>
      </div>

      </div>
</details>

    <details class="acc-strategic" open>
      <summary>📈 Tabel Audit Fluktuasi Kas &amp; Rentang Harian Cabang</summary>
      <div class="acc-body">
        <div class="table-container">
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
    </details>
  </div>

</div>

