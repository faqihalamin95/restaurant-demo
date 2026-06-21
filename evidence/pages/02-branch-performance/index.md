---
title: Performa Cabang
---


```sql branch_list
SELECT * FROM restaurant.branch_index_branch_list
```

```sql branch_dates
SELECT * FROM restaurant.branch_index_branch_dates
```

```sql branch_health_overview
SELECT * FROM restaurant.branch_index_branch_health_overview
```

```sql branch_summary_y
SELECT * FROM restaurant.branch_index_branch_summary_y
```

```sql branch_summary_7d
SELECT * FROM restaurant.branch_index_branch_summary_7d
```

```sql branch_summary_30d
SELECT * FROM restaurant.branch_index_branch_summary_30d
```

```sql branch_orders_comparison
SELECT * FROM restaurant.branch_index_branch_orders_comparison
```

```sql branch_summary_mtd
SELECT * FROM restaurant.branch_index_branch_summary_mtd
```

```sql branch_summary_90d
SELECT * FROM restaurant.branch_index_branch_summary_90d
```

```sql branch_orders_comparison_mtd
SELECT * FROM restaurant.branch_index_branch_orders_comparison_mtd
```

```sql branch_orders_comparison_90d
SELECT * FROM restaurant.branch_index_branch_orders_comparison_90d
```

```sql branch_orders_comparison_detail_30d
SELECT * FROM restaurant.branch_index_branch_orders_comparison_detail_30d
```

```sql branch_orders_comparison_detail_mtd
SELECT * FROM restaurant.branch_index_branch_orders_comparison_detail_mtd
```

```sql branch_orders_comparison_detail_90d
SELECT * FROM restaurant.branch_index_branch_orders_comparison_detail_90d
```

```sql branch_health_classification
SELECT * FROM restaurant.branch_index_branch_health_classification
```

```sql branch_status_counts
SELECT * FROM restaurant.branch_index_branch_status_counts
```

```sql branch_concentration
SELECT * FROM restaurant.branch_index_branch_concentration
```

_Dashboard portofolio cabang: kesehatan margin, pertumbuhan, profitabilitas, strategi, dan prioritas aksi._

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

<div class="evidence-tabs-container">
  <a href="/02-branch-performance" class="tab-button active">🏠 Ringkasan</a>
  <a href="/02-branch-performance/deepdive" class="tab-button ">🏪 Deep Dive</a>
  <a href="/02-branch-performance/analysis" class="tab-button ">🔭 Analisis Lanjutan</a>
</div>


{#if branch_health_classification.length > 0 && branch_status_counts.length > 0 && branch_list.length > 0 && branch_concentration.length > 0 && branch_orders_comparison.length > 0 && branch_dates.length > 0}

{@const branchOverviewRows = branch_summary_30d}
{@const branchBestName = branchOverviewRows[0]?.branch_name ?? 'Belum ada data'}
{@const branchTotalOrdersAll = branchOverviewRows.reduce((sum, row) => sum + (row.total_orders ?? 0), 0)}
{@const branchTotalRevenueAll = branchOverviewRows.reduce((sum, row) => sum + (row.total_revenue ?? 0), 0)}
{@const branchAovAll = Math.round(branchTotalRevenueAll / Math.max(branchTotalOrdersAll, 1))}
{@const branchRevenueValues = branchOverviewRows.map(row => row.total_revenue ?? 0).filter(v => v > 0)}
{@const branchMinRevenue = branchRevenueValues.reduce((min, v) => Math.min(min, v), branchRevenueValues[0] ?? 0)}
{@const branchMaxRevenue = branchRevenueValues.reduce((max, v) => Math.max(max, v), 0)}
{@const branchGapPct = branchMinRevenue > 0 ? Math.round((branchMaxRevenue - branchMinRevenue) / branchMinRevenue * 100) : 0}
{@const branchAovState = branchAovAll >= 50000 ? 'safe' : branchAovAll >= 35000 ? 'warn' : 'critical'}
{@const branchGapState = branchGapPct < 50 ? 'safe' : branchGapPct <= 100 ? 'warn' : 'critical'}
{@const branchOrdersDropPct = branch_orders_comparison[0]?.pct_change ?? 0}
{@const branchOrdersDropState = branchOrdersDropPct <= -15 ? 'critical' : branchOrdersDropPct <= -5 ? 'warn' : 'safe'}
{@const branchIndexStatus = branchAovState === 'critical' || branchGapState === 'critical' || branchOrdersDropState === 'critical' ? 'critical' : branchAovState === 'warn' || branchGapState === 'warn' || branchOrdersDropState === 'warn' ? 'warn' : 'safe'}
{@const branchIndexStates = [branchAovState, branchGapState, branchOrdersDropState]}
{@const branchIndexSafeCount = branchIndexStates.filter(s => s === 'safe').length}
{@const branchIndexWarnCount = branchIndexStates.filter(s => s === 'warn').length}
{@const branchIndexCriticalCount = branchIndexStates.filter(s => s === 'critical').length}
  {@const overviewPeriodRows = inputs.period === 'mtd' ? branch_summary_mtd : inputs.period === '90d' ? branch_summary_90d : branch_summary_30d}
  {@const overviewOrdersComp = inputs.period === 'mtd' ? branch_orders_comparison_mtd : inputs.period === '90d' ? branch_orders_comparison_90d : branch_orders_comparison}
  {@const guideOrdersDetail = inputs.period === 'mtd' ? branch_orders_comparison_detail_mtd : inputs.period === '90d' ? branch_orders_comparison_detail_90d : branch_orders_comparison_detail_30d}
  
  {@const overviewBestName = overviewPeriodRows[0]?.branch_name ?? 'Belum ada data'}
  {@const overviewTotalOrdersAll = overviewPeriodRows.reduce((sum, row) => sum + (row.total_orders ?? 0), 0)}
  {@const overviewTotalRevenueAll = overviewPeriodRows.reduce((sum, row) => sum + (row.total_revenue ?? 0), 0)}
  {@const overviewAovAll = Math.round(overviewTotalRevenueAll / Math.max(overviewTotalOrdersAll, 1))}
  {@const overviewRevenueValues = overviewPeriodRows.map(row => row.total_revenue ?? 0).filter(v => v > 0)}
  {@const overviewMinRevenue = overviewRevenueValues.reduce((min, v) => Math.min(min, v), overviewRevenueValues[0] ?? 0)}
  {@const overviewMaxRevenue = overviewRevenueValues.reduce((max, v) => Math.max(max, v), 0)}
  {@const overviewGapPct = overviewMinRevenue > 0 ? Math.round((overviewMaxRevenue - overviewMinRevenue) / overviewMinRevenue * 100) : 0}
  {@const overviewAovState = overviewAovAll >= 50000 ? 'safe' : overviewAovAll >= 35000 ? 'warn' : 'critical'}
  {@const overviewGapState = overviewGapPct < 50 ? 'safe' : overviewGapPct <= 100 ? 'warn' : 'critical'}
  {@const overviewOrdersDropPct = overviewOrdersComp[0]?.pct_change ?? 0}
  {@const overviewOrdersDropState = overviewOrdersDropPct <= -15 ? 'critical' : overviewOrdersDropPct <= -5 ? 'warn' : 'safe'}
  {@const overviewIndexStatus = overviewAovState === 'critical' || overviewGapState === 'critical' || overviewOrdersDropState === 'critical' ? 'critical' : overviewAovState === 'warn' || overviewGapState === 'warn' || overviewOrdersDropState === 'warn' ? 'warn' : 'safe'}
  {@const overviewIndexStates = [overviewAovState, overviewGapState, overviewOrdersDropState]}
  {@const overviewIndexSafeCount = overviewIndexStates.filter(s => s === 'safe').length}
  {@const overviewIndexWarnCount = overviewIndexStates.filter(s => s === 'warn').length}
  {@const overviewIndexCriticalCount = overviewIndexStates.filter(s => s === 'critical').length}

<div class="branch-page">

<ButtonGroup name=period>
    <ButtonGroupItem valueLabel="📅 Bulan Ini" value="mtd" />
    <ButtonGroupItem valueLabel="📊 30 Hari" value="30d" default />
    <ButtonGroupItem valueLabel="🔭 90 Hari" value="90d" />
  </ButtonGroup>

  <!-- Executive Summary -->
  <div class="overview-status-card {overviewIndexStatus}" style="margin-top: 10px;">
    <div>
      <div class="overview-status-label">Status Utama · Performa Cabang {inputs.period === 'mtd' ? 'Bulan Ini' : inputs.period === '90d' ? '90H' : '30H'}</div>
      <h2 class="overview-status-title">
        {#if overviewIndexStatus === 'safe'}Performa cabang terlihat sehat dari volume order, AOV, dan gap. ✅
        {:else if overviewIndexStatus === 'warn'}Volume, AOV, atau gap cabang perlu diperhatikan. ⚠️
        {:else}Volume order, AOV, atau gap cabang sudah masuk area kritis. 🚨{/if}
      </h2>
      <p class="overview-status-copy">
        Cabang terbaik saat ini <strong>{overviewBestName}</strong>. Total order semua cabang <strong>{overviewTotalOrdersAll.toLocaleString('id-ID')}</strong>, AOV rata-rata <strong>Rp {overviewAovAll.toLocaleString('id-ID')}</strong>, dan gap revenue antar cabang <strong>{overviewGapPct}%</strong>. Ini meneruskan cara baca dari beranda: mulai dari kualitas transaksi dan ketimpangan cabang, baru lanjut ke margin.
      </p>
      <div class="overview-status-action">
        <strong>Mulai dari sini:</strong>
        {#if overviewOrdersDropState === 'critical'}cek penurunan volume order di <strong>Deep Dive</strong> atau <strong>Pusat Aksi</strong>.
        {:else if overviewGapState === 'critical'}cek cabang terbawah di <strong>Deep Dive</strong>, lalu buka <strong>Analisis Lanjutan</strong> untuk melihat apakah gap juga muncul di margin.
        {:else if overviewGapState === 'warn'}cek cabang bawah sebelum gap membesar. Buka <strong>Deep Dive</strong> untuk audit cabang, lalu <strong>Analisis Lanjutan</strong> jika perlu membaca margin 30H/90H.
        {:else if overviewAovState !== 'safe'}cek AOV per cabang dan peluang upselling sebelum masuk audit margin.
        {:else}gunakan cabang terbaik sebagai benchmark, lalu buka analisis lanjutan hanya jika ingin audit margin dan struktur cabang.{/if}
      </div>
    </div>
    <div class="overview-status-metrics">
      <div class="overview-status-metric">
        <div class="overview-status-metric-label">📅 Periode Aktif</div>
        <div class="overview-status-metric-value">{inputs.period === 'mtd' ? branch_dates[0].tgl_mtd_awal : inputs.period === '90d' ? branch_dates[0].tgl_90_awal : branch_dates[0].tgl_30_awal} - {branch_dates[0].tgl_akhir}</div>
        <div class="overview-status-metric-note">Ini window paling stabil untuk keputusan operasional: cukup panjang untuk melihat pola, cukup dekat untuk bereaksi.</div>
      </div>
      <div class="overview-status-metric">
        <div class="overview-status-metric-label">🏪 Cabang Terbaik</div>
        <div class="overview-status-metric-value">{overviewBestName}</div>
        <div class="overview-status-metric-note">Bukan sekadar ranking; gunakan sebagai acuan untuk mencari pola operasional yang bisa ditiru cabang lain.</div>
      </div>
    </div>
  </div>

  <div class="overview-summary">
    <div class="overview-summary-head">
      <div class="overview-summary-label">Ringkasan 3 Indikator Utama</div>
      <div class="overview-badges">
        <span class="overview-badge safe">✓ {overviewIndexSafeCount} sehat</span>
        <span class="overview-badge warn">! {overviewIndexWarnCount} waspada</span>
        <span class="overview-badge critical">x {overviewIndexCriticalCount} kritis</span>
      </div>
    </div>
    <div class="overview-list">
      <div class="overview-row {overviewAovState}">
        <div class="overview-icon">{overviewAovState === 'safe' ? '✅' : overviewAovState === 'warn' ? '⚠️' : '🚨'}</div>
        <div><span class="overview-row-title">AOV Cabang</span> <span class="overview-row-copy">- <span class="overview-row-value">Rp {overviewAovAll.toLocaleString('id-ID')}</span>. Sehat = ≥Rp50.000, Waspada = Rp35.000-49.999, Kritis = di bawah Rp35.000.</span></div>
      </div>
      <div class="overview-row {overviewOrdersDropState}">
        <div class="overview-icon">{overviewOrdersDropState === 'safe' ? '✅' : overviewOrdersDropState === 'warn' ? '⚠️' : '🚨'}</div>
        <div><span class="overview-row-title">Orders Drop</span> <span class="overview-row-copy">- <span class="overview-row-value">{overviewOrdersComp[0].orders_this_period.toLocaleString('id-ID')} order</span> | <span class="overview-row-value">{overviewOrdersDropPct > 0 ? '+' : ''}{overviewOrdersDropPct}% vs {inputs.period === 'mtd' ? 'bulan lalu (mtd)' : inputs.period === '90d' ? '90h sebelumnya' : '30h sebelumnya'}</span>. Sehat = ≥-5%, Waspada = -5% s/d -15%, Kritis = di bawah -15%.</span></div>
      </div>
      <div class="overview-row {overviewGapState}">
        <div class="overview-icon">{overviewGapState === 'safe' ? '✅' : overviewGapState === 'warn' ? '⚠️' : '🚨'}</div>
        <div><span class="overview-row-title">Gap Antar Cabang</span> <span class="overview-row-copy">- <span class="overview-row-value">{overviewGapPct}% gap revenue</span>. Sehat = &lt;50%, Waspada = 50-100%, Kritis = di atas 100%.</span></div>
      </div>
    </div>
  </div>

  <!-- Section 1: Volume & Kualitas Transaksi (Direct Layout Card) -->
  <div class="section-card" style="margin-top: 16px;">
    <div class="section-head">
      <div>
        <div class="section-eyebrow">📈 Volume & Kualitas Transaksi ({inputs.period === 'mtd' ? 'Bulan Ini' : inputs.period === '90d' ? '90 Hari' : '30 Hari'})</div>
        <h3 class="section-title">Bagaimana keaktifan operasional dan rata-rata nilai belanja di tiap cabang?</h3>
        <p class="section-copy">Volume order menunjukkan seberapa aktif aktivitas transaksi di setiap cabang, sedangkan AOV mengukur kualitas rata-rata belanja per kunjungan. Dua metrik ini menggambarkan produktivitas harian outlet.</p>
      </div>
    </div>

    <!-- Grid untuk data order dan AOV -->
    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); gap: 24px; margin-top: 16px;">
      <!-- Chart 1: Volume (Orders Drop) -->
      <div>
        <BarChart 
          data={guideOrdersDetail} 
          x="branch_name" 
          y={inputs.period === 'mtd' ? ["Bulan Lalu (mtd)", "Bulan Ini"] : inputs.period === '90d' ? ["90h Lalu", "90h Sekarang"] : ["30h Lalu", "30h Sekarang"]} 
          type="grouped" 
          title="Perbandingan Volume Order" 
          xAxisTitle="Cabang" 
          yAxisTitle="Orders" 
          yFmt="#,##0"
        />
        <div style="font-size: 0.75rem; color: var(--color-text-secondary); margin-top: 8px; line-height: 1.45;">
          *Bandingkan volume order {inputs.period === 'mtd' ? 'Bulan Ini' : inputs.period === '90d' ? '90h Sekarang' : '30h Sekarang'} (kanan) vs {inputs.period === 'mtd' ? 'Bulan Lalu (mtd)' : inputs.period === '90d' ? '90h Lalu' : '30h Lalu'} (kiri).
        </div>
      </div>

      <!-- Chart 2: Kualitas (AOV) -->
      <div>
        <BarChart 
          data={overviewPeriodRows} 
          x="branch_name" 
          y="avg_order_value" 
          title="Nilai Transaksi (AOV)" 
          xAxisTitle="Cabang" 
          yAxisTitle="AOV (Rp)" 
          yFmt="#,##0"
        >
          <ReferenceLine y={50000} label="Sehat (≥50k)" lineType="dashed" color="#10B981" />
          <ReferenceLine y={35000} label="Kritis (<35k)" lineType="dashed" color="#EF4444" />
        </BarChart>
        <div style="font-size: 0.75rem; color: var(--color-text-secondary); margin-top: 8px; line-height: 1.45;">
          *Batas kelayakan transaksi (target sehat Rp50.000, batas kritis Rp35.000).
        </div>
      </div>
    </div>
  </div>

  <!-- Section 2: Ketimpangan Pendapatan (Direct Layout Card) -->
  <div class="section-card" style="margin-top: 16px;">
    <div class="section-head">
      <div>
        <div class="section-eyebrow">⚖️ Ketimpangan Pendapatan ({inputs.period === 'mtd' ? 'Bulan Ini' : inputs.period === '90d' ? '90 Hari' : '30 Hari'})</div>
        <h3 class="section-title">Berapa kontribusi omzet tiap cabang dan seberapa timpang jaraknya?</h3>
        <p class="section-copy">Sebaran pendapatan kotor menunjukkan kontribusi nilai omzet dari tiap cabang. Selisih yang terlalu jauh antara cabang tertinggi dan terendah memicu tingginya ketimpangan performa (gap) antar cabang.</p>
      </div>
    </div>

    <!-- Grafik sebaran pendapatan (gap) -->
    <div style="margin-top: 16px;">
      <BarChart 
        data={overviewPeriodRows} 
        x="branch_name" 
        y="total_revenue" 
        title="Sebaran Pendapatan (Gap)" 
        xAxisTitle="Cabang" 
        yAxisTitle="Revenue (Rp)" 
        yFmt="#,##0"
      />
      <div style="font-size: 0.75rem; color: var(--color-text-secondary); margin-top: 8px; line-height: 1.45;">
        *Ketimpangan ditunjukkan dari beda tinggi pendapatan kotor antar cabang.
      </div>
    </div>
  </div>

  <!-- Panduan Konseptual (Collapsible) -->
  <details class="guide-acc"  style="margin-top:12px;">
  <summary>💡 Kenapa AOV, total order, dan gap jadi angka utama?</summary>
<div class="guide-body">
      <p style="margin-top: 4px; margin-bottom: 16px; font-weight: 500; color: var(--color-text-secondary);">
        AOV, total order, dan gap adalah pengetahuan dasar sebelum membaca analisis cabang yang lebih berat. Ketiga angka ini sengaja diselaraskan dengan beranda agar owner memiliki alur analisis yang konsisten.
      </p>
      <div class="guide-grid" style="grid-template-columns: repeat(2, minmax(0, 1fr));">
        <div class="guide-card blue">
          <div class="guide-card-icon">💵</div>
          <div class="guide-card-content">
            <div class="guide-card-label">AOV</div>
            <h4 class="guide-card-title">Kualitas Transaksi</h4>
            <p class="guide-card-desc">AOV menjawab apakah pelanggan membeli cukup banyak/nilai cukup tinggi per kunjungan. Target sehatnya <strong>Rp50.000 ke atas</strong>.</p>
          </div>
        </div>
        <div class="guide-card orange">
          <div class="guide-card-icon">📈</div>
          <div class="guide-card-content">
            <div class="guide-card-label">Total Order</div>
            <h4 class="guide-card-title">Volume Aktivitas</h4>
            <p class="guide-card-desc">Membaca volume/frekuensi transaksi operasional untuk mendeteksi keaktifan cabang dan adanya tren penurunan transaksi (Orders Drop).</p>
          </div>
        </div>
        <div class="guide-card purple">
          <div class="guide-card-icon">⚖️</div>
          <div class="guide-card-content">
            <div class="guide-card-label">Gap Cabang</div>
            <h4 class="guide-card-title">Ketimpangan Performa</h4>
            <p class="guide-card-desc">Gap membaca jarak revenue cabang tertinggi dan terendah. Gap besar berarti cabang bawah perlu dicek lebih dekat.<br><strong style="font-size: 0.73rem; display: block; margin-top: 5px; color: var(--color-text-tertiary);">*Rumus gap: (revenue tertinggi - revenue terendah) / revenue terendah × 100%.</strong></p>
          </div>
        </div>
        <div class="guide-card teal">
          <div class="guide-card-icon">🚀</div>
          <div class="guide-card-content">
            <div class="guide-card-label">Lanjutannya</div>
            <h4 class="guide-card-title">Baru Cek Margin</h4>
            <p class="guide-card-desc">Jika AOV/total order/gap memberi sinyal, lanjut ke margin 30H vs 90H untuk melihat apakah masalahnya operasional, biaya, atau struktural.</p>
          </div>
        </div>
      </div>
    </div>
</details>

  <details class="acc-strategic" style="margin-top:14px;">
    <summary>📈 Status Margin Cabang · Diagnosis Aktif 30H vs Baseline 90H</summary>
    <div class="acc-body">
      <div class="strategic-stack" style="margin-top:0;">
        <div class="strategic-header">
          <div class="strategic-eyebrow">Status Margin Cabang</div>
          <h3 class="strategic-title" style="margin-top:0;">Setelah AOV dan gap, mari diagnosis performa margin di tingkat cabang</h3>
          <p class="strategic-copy">Sementara parameter waktu di Ringkasan cockpit di atas bersifat dinamis, analisis margin di bawah ini sengaja dikunci ke perbandingan 30H (aktif) vs 90H (baseline recent) untuk mendiagnosis apakah masalah bersifat sementara atau struktural.</p>
        </div>

        <div class="overview-summary" style="margin:14px 0 0;">
          <div class="overview-summary-head">
            <div class="overview-summary-label">Ringkasan Status Margin Cabang</div>
            <div class="overview-badges">
              <span class="overview-badge safe">✓ {branch_status_counts[0].sehat_count + branch_status_counts[0].recovery_count} sehat/recovery</span>
              <span class="overview-badge warn">! {branch_status_counts[0].waspada_count + branch_status_counts[0].early_warning_count + branch_status_counts[0].membaik_count + branch_status_counts[0].stabil_rendah_count} perlu dipantau</span>
              <span class="overview-badge critical">x {branch_status_counts[0].turnaround_count} turnaround</span>
            </div>
          </div>
          <div class="overview-list">
            <div class="overview-row {branch_status_counts[0].sehat_count + branch_status_counts[0].recovery_count > 0 ? 'safe' : 'warn'}">
              <div class="overview-icon">✅</div>
              <div><span class="overview-row-title">Cabang sehat/recovery</span> <span class="overview-row-copy">- <span class="overview-row-value">{branch_status_counts[0].sehat_count + branch_status_counts[0].recovery_count} cabang</span>. Ini cabang yang bisa dipertahankan sebagai standar operasional atau benchmark.</span></div>
            </div>
            <div class="overview-row {branch_status_counts[0].waspada_count + branch_status_counts[0].early_warning_count + branch_status_counts[0].membaik_count + branch_status_counts[0].stabil_rendah_count > 0 ? 'warn' : 'safe'}">
              <div class="overview-icon">{branch_status_counts[0].waspada_count + branch_status_counts[0].early_warning_count + branch_status_counts[0].membaik_count + branch_status_counts[0].stabil_rendah_count > 0 ? '⚠️' : '✅'}</div>
              <div><span class="overview-row-title">Cabang perlu dipantau</span> <span class="overview-row-copy">- <span class="overview-row-value">{branch_status_counts[0].waspada_count + branch_status_counts[0].early_warning_count + branch_status_counts[0].membaik_count + branch_status_counts[0].stabil_rendah_count} cabang</span>. Termasuk cabang yang melunak, membaik tapi belum sehat, atau stabil rendah.</span></div>
            </div>
            <div class="overview-row {branch_status_counts[0].turnaround_count > 0 ? 'critical' : 'safe'}">
              <div class="overview-icon">{branch_status_counts[0].turnaround_count > 0 ? '🚨' : '✅'}</div>
              <div><span class="overview-row-title">Cabang turnaround</span> <span class="overview-row-copy">- <span class="overview-row-value">{branch_status_counts[0].turnaround_count} cabang</span>. Jika ada, ini masuk prioritas tindakan sebelum optimasi lain.</span></div>
            </div>
          </div>
        </div>

        <details class="guide-acc"  style="margin-top:14px;">
  <summary>💡 Cara membaca status cabang</summary>
<div class="guide-body">
            
      <div class="guide-grid" style="grid-template-columns: repeat(3, minmax(0, 1fr));">
        <div class="guide-card teal">
          <div class="guide-card-icon">✅</div>
          <div class="guide-card-content">
            <div class="guide-card-label">SEHAT</div>
            <h4 class="guide-card-title">Sehat</h4>
            <p class="guide-card-desc">margin 30H ≥ 15% dan baseline 90H ≥ 15%. Benchmark untuk cabang lain.</p>
          </div>
        </div>
        <div class="guide-card orange">
          <div class="guide-card-icon">⚠️</div>
          <div class="guide-card-content">
            <div class="guide-card-label">WASPADA</div>
            <h4 class="guide-card-title">Waspada</h4>
            <p class="guide-card-desc">margin 30H 10-15%, baseline 90H masih sehat. Cabang yang biasanya sehat mulai melunak.</p>
          </div>
        </div>
        <div class="guide-card orange">
          <div class="guide-card-icon">🚨</div>
          <div class="guide-card-content">
            <div class="guide-card-label">EARLY WARNING</div>
            <h4 class="guide-card-title">Early Warning</h4>
            <p class="guide-card-desc">margin 30H &lt; 10%, tapi baseline 90H masih sehat. Penurunan baru, bukan masalah lama.</p>
          </div>
        </div>
        <div class="guide-card blue">
          <div class="guide-card-icon">🔵</div>
          <div class="guide-card-content">
            <div class="guide-card-label">RECOVERY</div>
            <h4 class="guide-card-title">Recovery</h4>
            <p class="guide-card-desc">margin 30H ≥ 15%, baseline 90H masih rendah. Sudah sehat sekarang, tapi historinya masih perlu dipantau.</p>
          </div>
        </div>
        <div class="guide-card teal">
          <div class="guide-card-icon">🟢</div>
          <div class="guide-card-content">
            <div class="guide-card-label">MEMBAIK</div>
            <h4 class="guide-card-title">Membaik</h4>
            <p class="guide-card-desc">margin 30H 10-15%, baseline 90H &lt; 10%. Ada pemulihan dari kondisi lemah, tapi belum sehat.</p>
          </div>
        </div>
        <div class="guide-card orange">
          <div class="guide-card-icon">🟡</div>
          <div class="guide-card-content">
            <div class="guide-card-label">STABIL RENDAH</div>
            <h4 class="guide-card-title">Stabil Rendah</h4>
            <p class="guide-card-desc">margin 30H dan 90H sama-sama 10-15%. Bukan krisis, tapi belum optimal.</p>
          </div>
        </div>
        <div class="guide-card purple">
          <div class="guide-card-icon">🚨</div>
          <div class="guide-card-content">
            <div class="guide-card-label">TURNAROUND</div>
            <h4 class="guide-card-title">Turnaround</h4>
            <p class="guide-card-desc">margin 30H dan 90H sama-sama lemah. Perlu pembenahan struktural.</p>
          </div>
        </div>
      </div>

            Margin 30H adalah status aktif. Margin 90H adalah baseline recent. Margin historis tetap ditampilkan sebagai konteks fundamental, bukan penentu status utama.
          </div>
</details>

        <!-- Detail Status per Cabang Section -->
        <div class="strategic-header" style="margin-top:24px; padding-top:20px; border-top: 1px dashed rgba(0,0,0,0.15);">
          <div class="strategic-eyebrow">Detail Status per Cabang</div>
          <h3 class="strategic-title" style="margin-top:0;">Cabang mana yang sehat, perlu dipantau, atau masuk turnaround?</h3>
          <p class="strategic-copy">Kartu di bawah ini adalah bukti per cabang dari ringkasan margin di atas. Menggunakan analisis perbandingan 30 Hari (aktif) vs 90 Hari (baseline recent) untuk memotret perkembangan operasional terbaru per cabang.</p>
        </div>

        <div class="branch-health-grid" style="margin-top:14px;">
          {#each branch_health_classification as row}
            {@const branchStatusClass = row.health_status === 'Sehat' ? 'sehat' : row.health_status === 'Waspada' ? 'waspada' : row.health_status === 'Early Warning' ? 'early-warning' : row.health_status === 'Recovery' ? 'recovery' : row.health_status === 'Membaik' ? 'membaik' : row.health_status === 'Stabil Rendah' ? 'stabil-rendah' : 'turnaround'}
            <div class="branch-health-card {branchStatusClass}">
              <div style="display:flex;align-items:center;justify-content:space-between;gap:8px;flex-wrap:wrap;">
                <span class="branch-card-name">{row.branch_name}</span>
                <span class="branch-status-badge {branchStatusClass}">{row.health_status === 'Sehat' ? '✅' : row.health_status === 'Waspada' ? '⚠️' : row.health_status === 'Early Warning' ? '🟠' : row.health_status === 'Recovery' ? '🔵' : row.health_status === 'Membaik' ? '🟢' : row.health_status === 'Stabil Rendah' ? '🟡' : '🚨'} {row.health_status}</span>
              </div>
              <div>
                <div class="branch-margin-main {branchStatusClass}">{row.active_margin_pct}%</div>
                <div class="branch-margin-label">Margin Aktif 30H</div>
              </div>
              <div class="branch-margin-structural">
                <span>Margin 90H:</span>
                <strong>{row.recent_margin_pct}%</strong>
                <span>Historis:</span>
                <strong>{row.historical_margin_pct}%</strong>
              </div>
              <div class="branch-stats-row">
                <span>Revenue: Rp {(row.active_revenue/1000000).toFixed(1)}jt</span>
                <span>Orders: {row.active_orders?.toLocaleString('id-ID')}</span>
                <span>vs Baseline: {row.baseline_change_pct >= 0 ? '+' : ''}{row.baseline_change_pct}%</span>
              </div>
              <div class="branch-diagnosis">{row.diagnosis}</div>
              <div class="branch-next-link">→ {row.recommended_next_page}</div>
            </div>
          {/each}
        </div>

        <details class="guide-acc"  style="margin-top:14px;">
  <summary>💡 Kenapa margin 30H dibandingkan dengan 90H?</summary>
<div class="guide-body">
            
      <div class="guide-grid" style="grid-template-columns: repeat(3, minmax(0, 1fr));">
        <div class="guide-card blue">
          <div class="guide-card-icon">💡</div>
          <div class="guide-card-content">
            <div class="guide-card-label">ITEM 1</div>
            <h4 class="guide-card-title">Item 1</h4>
            <p class="guide-card-desc">Margin 30H menunjukkan kondisi aktif yang perlu diputuskan sekarang.</p>
          </div>
        </div>
        <div class="guide-card orange">
          <div class="guide-card-icon">💡</div>
          <div class="guide-card-content">
            <div class="guide-card-label">ITEM 2</div>
            <h4 class="guide-card-title">Item 2</h4>
            <p class="guide-card-desc">Margin 90H menunjukkan baseline recent: apakah masalahnya baru atau sudah menetap beberapa bulan.</p>
          </div>
        </div>
        <div class="guide-card teal">
          <div class="guide-card-icon">💡</div>
          <div class="guide-card-content">
            <div class="guide-card-label">ITEM 3</div>
            <h4 class="guide-card-title">Item 3</h4>
            <p class="guide-card-desc">Jika 30H lemah tapi 90H sehat, masalahnya early warning dan masih bisa dikoreksi cepat.</p>
          </div>
        </div>
        <div class="guide-card purple">
          <div class="guide-card-icon">💡</div>
          <div class="guide-card-content">
            <div class="guide-card-label">ITEM 4</div>
            <h4 class="guide-card-title">Item 4</h4>
            <p class="guide-card-desc">Jika 30H dan 90H sama-sama lemah, masalahnya sudah lebih struktural.</p>
          </div>
        </div>
        <div class="guide-card blue">
          <div class="guide-card-icon">💡</div>
          <div class="guide-card-content">
            <div class="guide-card-label">ITEM 5</div>
            <h4 class="guide-card-title">Item 5</h4>
            <p class="guide-card-desc">Margin historis tetap dipakai sebagai konteks fundamental, bukan sebagai alarm utama.</p>
          </div>
        </div>
      </div>

          </div>
</details>
      </div>
    </div>
  </details>

</div>

{:else}
<div class="section-card">
  <div class="section-head">
    <div class="section-eyebrow">⚠️ Data Belum Siap</div>
    <h3 class="section-title">Dashboard cabang belum bisa dirender penuh</h3>
    <p class="section-copy">Dataset klasifikasi cabang atau status counts belum tersedia. Cek apakah query <code>branch_health_classification</code> dan <code>branch_status_counts</code> sudah berjalan dan menghasilkan baris data.</p>
  </div>
</div>
{/if}
