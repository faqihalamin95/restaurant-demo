---
title: Laporan Keuangan
---

```sql fin_dates
SELECT * FROM restaurant.fin_dates
```

```sql fin_kpi
SELECT * FROM restaurant.fin_kpi
```

```sql fin_cost_pct
SELECT * FROM restaurant.fin_cost_pct
```

```sql fin_kpi_mtd
SELECT * FROM restaurant.fin_kpi_mtd
```

```sql fin_cost_mtd
SELECT * FROM restaurant.fin_cost_mtd
```

```sql fin_margin_daily_mtd
SELECT * FROM restaurant.fin_margin_daily_mtd
```

```sql fin_nama_bulan
SELECT * FROM restaurant.fin_nama_bulan
```

```sql fin_margin_daily_30d
SELECT * FROM restaurant.fin_margin_daily_30d
```

```sql fin_margin_daily_90d
SELECT * FROM restaurant.fin_margin_daily_90d
```

```sql fin_quarter
SELECT * FROM restaurant.fin_quarter
```

```sql fin_quarter_comparison
SELECT * FROM restaurant.fin_quarter_comparison
```

```sql fin_yoy
SELECT * FROM restaurant.fin_yoy
```

```sql fin_operational_overview
SELECT * FROM restaurant.fin_operational_overview
```

_Kesehatan finansial bisnis: margin, tekanan biaya, dan konteks musiman dalam satu halaman._

<ButtonGroup name=period>
  <ButtonGroupItem valueLabel="📅 Bulan Ini" value="mtd" />
  <ButtonGroupItem valueLabel="📊 30 Hari" value="30d" default />
  <ButtonGroupItem valueLabel="🔭 90 Hari" value="90d" />
</ButtonGroup>

{#if fin_operational_overview.length > 0}
<div class="finance-page">




  <!-- ══════════════════════════════════════════
       MTD VIEW
  ══════════════════════════════════════════ -->
  {#if inputs.period === 'mtd'}
    <div class="hero">
      <div>
        <div class="hero-eyebrow">💰 Laporan Keuangan · Bulan Berjalan</div>
        {#if fin_kpi_mtd[0].margin_mtd >= 15}
          <h2 class="hero-title">Margin {fin_kpi_mtd[0].margin_mtd}% masih sehat di bulan {fin_nama_bulan[0].nama_bulan}. 🎉</h2>
        {:else if fin_kpi_mtd[0].margin_mtd >= 10}
          <h2 class="hero-title">Margin {fin_kpi_mtd[0].margin_mtd}% masuk zona waspada bulan {fin_nama_bulan[0].nama_bulan}. ⚠️</h2>
        {:else}
          <h2 class="hero-title">Margin {fin_kpi_mtd[0].margin_mtd}% sudah kritis di bulan {fin_nama_bulan[0].nama_bulan}. 🚨</h2>
        {/if}
        <div class="hero-copy">
          {#if fin_operational_overview[0].fokus_mtd === 'Semua biaya dalam batas'}
            Sampai hari ke-{fin_kpi_mtd[0].hari_berjalan}, semua komponen biaya masih berada dalam rentang normal. Fokus utamanya menjaga pace revenue dan memastikan margin sehat ini bertahan sampai tutup bulan.
          {:else}
            Tekanan terbesar datang dari <strong>{fin_operational_overview[0].fokus_mtd?.toLowerCase()}</strong>, sekitar <strong>{fin_operational_overview[0].fokus_gap_mtd}pp</strong> di atas batas normal. Ini belum otomatis membuat bulan gagal, tapi cukup jelas untuk dijadikan prioritas sekarang.
          {/if}
        </div>
      </div>
      <div class="hero-side">
        <div class="hero-side-card">
          <div class="hero-side-label">📅 Periode Aktif</div>
          <div class="hero-side-value">{fin_nama_bulan[0].nama_bulan} · {fin_kpi_mtd[0].hari_berjalan}/{fin_kpi_mtd[0].total_hari_bulan} hari</div>
          <div class="hero-side-note">Masih ada {fin_kpi_mtd[0].total_hari_bulan - fin_kpi_mtd[0].hari_berjalan} hari tersisa untuk mengubah arah margin bulan ini.</div>
        </div>
        <div class="hero-side-card">
          <div class="hero-side-label">🔮 Proyeksi Pace Saat Ini</div>
          <div class="hero-side-value">Rp {(fin_kpi_mtd[0].proyeksi_gross / 1000000).toFixed(1)}jt gross</div>
          <div class="hero-side-note">Net revenue terproyeksi Rp {(fin_kpi_mtd[0].proyeksi_net / 1000000).toFixed(1)}jt. Proyeksi ini linear, cukup untuk baca arah, bukan angka final.</div>
        </div>
      </div>
    </div>

    <div class="kpi-grid">
      <div class="kpi-card revenue">
        <div class="kpi-label">💵 Gross Revenue</div>
        <div class="kpi-value">Rp {fin_kpi_mtd[0].gross_mtd.toLocaleString('id-ID', { maximumFractionDigits: 0 })}</div>
        <div class="kpi-meta">Bulan lalu penuh: Rp {fin_kpi_mtd[0].gross_bulan_lalu.toLocaleString('id-ID', { maximumFractionDigits: 0 })}</div>
      </div>
      <div class="kpi-card net">
        <div class="kpi-label">💰 Net Revenue</div>
        <div class="kpi-value">Rp {fin_kpi_mtd[0].net_mtd.toLocaleString('id-ID', { maximumFractionDigits: 0 })}</div>
        <div class="kpi-meta">Proyeksi akhir bulan: Rp {fin_kpi_mtd[0].proyeksi_net.toLocaleString('id-ID', { maximumFractionDigits: 0 })}</div>
      </div>
      <div class="kpi-card margin">
        <div class="kpi-label">📈 Net Margin</div>
        <div class="kpi-value">{fin_kpi_mtd[0].margin_mtd}%</div>
        <div class="kpi-meta">
          {fin_kpi_mtd[0].margin_mtd >= fin_kpi_mtd[0].margin_bulan_lalu ? '↑ Naik' : '↓ Turun'}
          {Math.abs(Math.round((fin_kpi_mtd[0].margin_mtd - fin_kpi_mtd[0].margin_bulan_lalu) * 10) / 10)}pp vs {fin_nama_bulan[0].nama_bulan_lalu}.
        </div>
      </div>
      <div class="kpi-card cost">
        <div class="kpi-label">💸 Total Biaya</div>
        <div class="kpi-value">Rp {fin_kpi_mtd[0].biaya_mtd.toLocaleString('id-ID', { maximumFractionDigits: 0 })}</div>
        <div class="kpi-meta">Bulan lalu penuh: Rp {fin_kpi_mtd[0].biaya_bulan_lalu.toLocaleString('id-ID', { maximumFractionDigits: 0 })}</div>
      </div>
    </div>

    <div class="signal-grid">
      <div class="signal-card {fin_kpi_mtd[0].margin_mtd >= 15 ? 'safe' : fin_kpi_mtd[0].margin_mtd >= 10 ? 'warn' : 'critical'}">
        <div class="signal-label">
          {fin_kpi_mtd[0].margin_mtd >= 15 ? '✅' : fin_kpi_mtd[0].margin_mtd >= 10 ? '⚠️' : '🚨'} Apa Yang Sehat
        </div>
        <div class="signal-title">
          {#if fin_kpi_mtd[0].margin_mtd >= 15}
            Margin bulan berjalan masih berada di zona sehat.
          {:else if fin_kpi_mtd[0].margin_mtd >= 10}
            Revenue masih cukup menahan margin agar tidak jatuh lebih dalam.
          {:else}
            Sinyal sehat sangat tipis, perlu recovery cepat.
          {/if}
        </div>
        <div class="signal-copy">
          {#if fin_kpi_mtd[0].margin_mtd >= 15}
            Artinya bisnis masih menyisakan ruang laba yang sehat. Fokusnya bukan cari pertumbuhan baru dulu, tapi jaga supaya komponen biaya tidak merayap naik di sisa bulan.
          {:else if fin_operational_overview[0].fokus_mtd !== 'Semua biaya dalam batas'}
            Walau masih tertekan, bulan ini belum sepenuhnya lepas kendali. Masih ada waktu untuk menekan komponen yang paling boros sebelum tutup buku.
          {:else}
            Revenue belum runtuh, tapi struktur biaya sekarang terlalu berat untuk level penjualan saat ini.
          {/if}
        </div>
      </div>
      <div class="signal-card {fin_operational_overview[0].fokus_mtd === 'Semua biaya dalam batas' ? 'neutral' : 'warn'}">
        <div class="signal-label">
          {fin_operational_overview[0].fokus_mtd === 'Semua biaya dalam batas' ? '💡' : '🎯'} Yang Perlu Perhatian
        </div>
        <div class="signal-title">
          {#if fin_operational_overview[0].fokus_mtd === 'Semua biaya dalam batas'}
            Belum ada komponen yang melewati target.
          {:else}
            {fin_operational_overview[0].fokus_mtd} jadi pressure point utama.
          {/if}
        </div>
        <div class="signal-copy">
          {#if fin_operational_overview[0].fokus_mtd === 'Semua biaya dalam batas'}
            Risiko terbesar justru ada di konsistensi pace. Pastikan sisa hari bulan ini tidak diisi diskon, waste, atau lembur berlebih yang menggerus margin.
          {:else}
            Selisih sekitar {fin_operational_overview[0].fokus_gap_mtd}pp di atas ambang normal sudah cukup untuk mengubah hasil akhir bulan kalau dibiarkan berlanjut beberapa hari lagi.
          {/if}
        </div>
      </div>
    </div>

    <div class="section-card">
      <div class="section-head">
        <div>
          <div class="section-eyebrow">💸 Breakdown Biaya</div>
          <h3 class="section-title">Bedah komponen biaya bulan berjalan</h3>
          <p class="section-copy">Dari setiap Rp100 gross revenue bulan {fin_nama_bulan[0].nama_bulan}, berapa yang habis untuk bahan, SDM, dan operasional.</p>
        </div>
      </div>
      <div class="cost-grid">
        <div class="cost-card">
          <div class="cost-label">🥩 Biaya Bahan</div>
          <div class="cost-value" style="color:{fin_cost_mtd[0].bahan_mtd > 32 ? '#dc2626' : '#16a34a'};">{fin_cost_mtd[0].bahan_mtd}%</div>
          <div class="cost-target">🎯 Target normal maks 32%</div>
          <div class="progress-track">
            <div class="progress-fill" style="width:{Math.min(fin_cost_mtd[0].bahan_mtd / 40 * 100, 100)}%; background:{fin_cost_mtd[0].bahan_mtd > 32 ? 'linear-gradient(90deg,#ef4444,#fca5a5)' : 'linear-gradient(90deg,#16a34a,#86efac)'};"></div>
            <div class="progress-target" style="left:{32 / 40 * 100}%;"></div>
          </div>
          <div class="progress-scale"><span>0%</span><span>32%</span><span>40%</span></div>
          <div class="cost-note">Perubahan vs {fin_nama_bulan[0].nama_bulan_lalu}: {fin_cost_mtd[0].delta_bahan > 0 ? '+' : ''}{fin_cost_mtd[0].delta_bahan}pp.</div>
        </div>
        <div class="cost-card">
          <div class="cost-label">👥 Biaya SDM</div>
          <div class="cost-value" style="color:{fin_cost_mtd[0].sdm_mtd > 22 ? '#f59e0b' : '#16a34a'};">{fin_cost_mtd[0].sdm_mtd}%</div>
          <div class="cost-target">🎯 Target normal maks 22%</div>
          <div class="progress-track">
            <div class="progress-fill" style="width:{Math.min(fin_cost_mtd[0].sdm_mtd / 30 * 100, 100)}%; background:{fin_cost_mtd[0].sdm_mtd > 22 ? 'linear-gradient(90deg,#f59e0b,#fde68a)' : 'linear-gradient(90deg,#16a34a,#86efac)'};"></div>
            <div class="progress-target" style="left:{22 / 30 * 100}%;"></div>
          </div>
          <div class="progress-scale"><span>0%</span><span>22%</span><span>30%</span></div>
          <div class="cost-note">Perubahan vs {fin_nama_bulan[0].nama_bulan_lalu}: {fin_cost_mtd[0].delta_sdm > 0 ? '+' : ''}{fin_cost_mtd[0].delta_sdm}pp.</div>
        </div>
        <div class="cost-card">
          <div class="cost-label">⚙️ Biaya Operasional</div>
          <div class="cost-value" style="color:{fin_cost_mtd[0].ops_mtd > 15 ? '#dc2626' : '#16a34a'};">{fin_cost_mtd[0].ops_mtd}%</div>
          <div class="cost-target">🎯 Target normal maks 15%</div>
          <div class="progress-track">
            <div class="progress-fill" style="width:{Math.min(fin_cost_mtd[0].ops_mtd / 25 * 100, 100)}%; background:{fin_cost_mtd[0].ops_mtd > 15 ? 'linear-gradient(90deg,#ef4444,#fca5a5)' : 'linear-gradient(90deg,#16a34a,#86efac)'};"></div>
            <div class="progress-target" style="left:{15 / 25 * 100}%;"></div>
          </div>
          <div class="progress-scale"><span>0%</span><span>15%</span><span>25%</span></div>
          <div class="cost-note">Perubahan vs {fin_nama_bulan[0].nama_bulan_lalu}: {fin_cost_mtd[0].delta_ops > 0 ? '+' : ''}{fin_cost_mtd[0].delta_ops}pp.</div>
        </div>
      </div>
    </div>

    <div class="section-card">
      <div class="section-head tight">
        <div>
          <div class="section-eyebrow">📈 Tren Margin</div>
          <h3 class="section-title">Apakah bulan ini membaik atau hanya bertahan?</h3>
          <p class="section-copy">Chart ini dipakai untuk melihat apakah margin harian konsisten, atau sehat hanya karena beberapa hari yang sangat kuat.</p>
        </div>
      </div>
      <LineChart
        data={fin_margin_daily_mtd}
        x="metric_date"
        y="margin_pct"
        title="Net Margin Harian MTD (%)"
        yFmt="0.0\%"
        xAxisTitle="Tanggal"
        yAxisTitle="Net Margin (%)"
      >
        <ReferenceLine y={15} label="Target 15%" lineType="dashed" color="green" />
        <ReferenceLine y={10} label="Kritis 10%" lineType="dashed" color="red" />
      </LineChart>
    </div>

    <details>
      <summary>💡 Kenapa status bulan ini muncul</summary>
      <div class="acc-body">
        Net margin bulan berjalan paling berguna sebagai radar cepat. Ia belum seadil 30 hari, tapi cukup tajam untuk mendeteksi pressure lebih awal. Kalau margin masih sehat sementara satu komponen biaya sudah naik, itu sinyal untuk bertindak sebelum masalah menjadi hasil akhir bulan.
      </div>
    </details>

    <details>
      <summary>🔧 Langkah konkret yang layak dicek sekarang</summary>
      <div class="acc-body">
        {#if fin_cost_mtd[0].bahan_mtd > 32}
          <p><strong>🥩 Bahan di atas target.</strong> Cek item yang paling banyak mendorong COGS, pola pembelian besar di awal bulan, dan waste yang tidak tertutup kenaikan revenue.</p>
        {/if}
        {#if fin_cost_mtd[0].sdm_mtd > 22}
          <p><strong>👥 SDM di atas target.</strong> Lihat distribusi shift, lembur, dan apakah revenue harian cukup padat untuk menutup biaya tenaga kerja sekarang.</p>
        {/if}
        {#if fin_cost_mtd[0].ops_mtd > 15}
          <p><strong>⚙️ Operasional di atas target.</strong> Biasanya lebih lambat berubah, jadi periksa beban fixed cost, promosi yang tidak efisien, atau hari-hari revenue lemah yang memperbesar rasio biaya.</p>
        {/if}
        {#if fin_cost_mtd[0].bahan_mtd <= 32 && fin_cost_mtd[0].sdm_mtd <= 22 && fin_cost_mtd[0].ops_mtd <= 15}
          ✅ Tidak ada komponen yang melewati target. Fokus terbaik sekarang adalah menjaga disiplin diskon, menjaga pace transaksi, dan memastikan penutupan bulan tidak rusak oleh beberapa hari buruk di akhir periode.
        {/if}
      </div>
    </details>

  <!-- ══════════════════════════════════════════
       90D VIEW
  ══════════════════════════════════════════ -->
  {:else if inputs.period === '90d'}
    <div class="hero">
      <div>
        <div class="hero-eyebrow">🔭 Laporan Keuangan · 90 Hari Terakhir</div>
        {#if fin_kpi[0].margin_90d >= 15}
          <h2 class="hero-title">Margin {fin_kpi[0].margin_90d}% masih sehat untuk horizon 3 bulan. ✅</h2>
        {:else if fin_kpi[0].margin_90d >= 10}
          <h2 class="hero-title">Margin {fin_kpi[0].margin_90d}% menunjukkan tekanan struktural ringan. ⚠️</h2>
        {:else}
          <h2 class="hero-title">Margin {fin_kpi[0].margin_90d}% sudah kritis secara struktural. 🚨</h2>
        {/if}
        <div class="hero-copy">
          {#if fin_operational_overview[0].fokus_90d === 'Semua biaya dalam batas'}
            Dalam 90 hari terakhir, struktur biaya relatif masih terkendali. Yang perlu dibaca sekarang adalah apakah pertumbuhan revenue benar-benar menghasilkan efisiensi, bukan sekadar volume yang lebih besar.
          {:else}
            Dalam horizon 90 hari, tekanan utama datang dari <strong>{fin_operational_overview[0].fokus_90d?.toLowerCase()}</strong>, sekitar <strong>{fin_operational_overview[0].fokus_gap_90d}pp</strong> di atas batas normal. Karena ini sudah berlangsung lebih lama, sinyalnya lebih dekat ke isu struktural daripada noise operasional.
          {/if}
        </div>
      </div>
      <div class="hero-side">
        <div class="hero-side-card">
          <div class="hero-side-label">📅 Periode Aktif</div>
          <div class="hero-side-value">{fin_dates[0].tgl_90d_awal} - {fin_dates[0].tgl_akhir}</div>
          <div class="hero-side-note">Cakupan ini cocok untuk menangkap pola biaya yang sudah berulang, bukan anomali beberapa hari.</div>
        </div>
        <div class="hero-side-card">
          <div class="hero-side-label">📊 Perubahan Revenue</div>
          <div class="hero-side-value">{fin_kpi[0].pct_change_gross_90d > 0 ? '+' : ''}{fin_kpi[0].pct_change_gross_90d}%</div>
          <div class="hero-side-note">Margin berubah {fin_kpi[0].delta_margin_90d > 0 ? '+' : ''}{fin_kpi[0].delta_margin_90d}pp vs 90 hari sebelumnya.</div>
        </div>
      </div>
    </div>

    <div class="kpi-grid">
      <div class="kpi-card revenue">
        <div class="kpi-label">💵 Gross Revenue</div>
        <div class="kpi-value">Rp {fin_kpi[0].gross_90d.toLocaleString('id-ID', { maximumFractionDigits: 0 })}</div>
        <div class="kpi-meta">90 hari sebelumnya: Rp {fin_kpi[0].gross_prev90d.toLocaleString('id-ID', { maximumFractionDigits: 0 })}</div>
      </div>
      <div class="kpi-card net">
        <div class="kpi-label">💰 Net Revenue</div>
        <div class="kpi-value">Rp {fin_kpi[0].net_90d.toLocaleString('id-ID', { maximumFractionDigits: 0 })}</div>
        <div class="kpi-meta">Melihat hasil bersih dari pertumbuhan volume dalam 3 bulan.</div>
      </div>
      <div class="kpi-card margin">
        <div class="kpi-label">📈 Net Margin</div>
        <div class="kpi-value">{fin_kpi[0].margin_90d}%</div>
        <div class="kpi-meta">{fin_kpi[0].delta_margin_90d > 0 ? '↑ Naik' : '↓ Turun'} {Math.abs(fin_kpi[0].delta_margin_90d)}pp vs 90 hari sebelumnya.</div>
      </div>
      <div class="kpi-card cost">
        <div class="kpi-label">💸 Total Biaya</div>
        <div class="kpi-value">Rp {fin_kpi[0].biaya_90d.toLocaleString('id-ID', { maximumFractionDigits: 0 })}</div>
        <div class="kpi-meta">90 hari sebelumnya: Rp {fin_kpi[0].biaya_prev90d.toLocaleString('id-ID', { maximumFractionDigits: 0 })}</div>
      </div>
    </div>

    <div class="signal-grid">
      <div class="signal-card {fin_kpi[0].margin_90d >= 15 ? 'safe' : fin_kpi[0].margin_90d >= 10 ? 'warn' : 'critical'}">
        <div class="signal-label">
          {fin_kpi[0].margin_90d >= 15 ? '✅' : fin_kpi[0].margin_90d >= 10 ? '⚠️' : '🚨'} Apa Yang Sehat
        </div>
        <div class="signal-title">
          {#if fin_kpi[0].margin_90d >= 15 && fin_kpi[0].delta_margin_90d >= 0}
            Margin sehat dan tidak menunjukkan erosi struktural.
          {:else if fin_kpi[0].margin_90d >= 15}
            Margin masih sehat, tapi kualitas efisiensinya mulai melunak.
          {:else}
            Masalahnya bukan lagi hari buruk, tapi pola 3 bulan.
          {/if}
        </div>
        <div class="signal-copy">
          {#if fin_kpi[0].margin_90d >= 15 && fin_kpi[0].delta_margin_90d >= 0}
            Ini pertanda bisnis tidak hanya menjual lebih banyak, tetapi juga masih menyisakan laba yang sehat setelah menutup seluruh biaya utama.
          {:else if fin_kpi[0].margin_90d >= 15}
            Revenue masih kuat, namun margin belum naik seiring volume. Artinya ada biaya yang tumbuh lebih cepat daripada omset.
          {:else}
            Horizon 90 hari memberi bukti yang lebih tebal. Perlu pembenahan model biaya, bukan hanya reaksi mingguan.
          {/if}
        </div>
      </div>
      <div class="signal-card {fin_operational_overview[0].fokus_90d === 'Semua biaya dalam batas' ? 'neutral' : 'warn'}">
        <div class="signal-label">
          {fin_operational_overview[0].fokus_90d === 'Semua biaya dalam batas' ? '💡' : '🎯'} Yang Perlu Perhatian
        </div>
        <div class="signal-title">
          {#if fin_operational_overview[0].fokus_90d === 'Semua biaya dalam batas'}
            Tidak ada komponen yang konsisten melewati target.
          {:else}
            {fin_operational_overview[0].fokus_90d} paling banyak menekan margin 90 hari.
          {/if}
        </div>
        <div class="signal-copy">
          {#if fin_operational_overview[0].fokus_90d === 'Semua biaya dalam batas'}
            Risiko utama ada di sustainability: apakah revenue growth ke depan masih cukup untuk menjaga margin, terutama saat masuk periode musiman yang lebih lemah.
          {:else}
            Karena pressure ini bertahan hingga 3 bulan, ada kemungkinan penyebabnya bersifat sistemik: supplier, pricing, staffing mix, atau beban operasional tetap yang terlalu besar.
          {/if}
        </div>
      </div>
    </div>

    <div class="section-card">
      <div class="section-head">
        <div>
          <div class="section-eyebrow">💸 Breakdown Biaya</div>
          <h3 class="section-title">Biaya 90 hari: mana yang paling menggerus margin?</h3>
          <p class="section-copy">Gunakan view ini untuk membaca masalah yang sudah cukup berulang untuk dianggap struktural.</p>
        </div>
      </div>
      <div class="cost-grid">
        <div class="cost-card">
          <div class="cost-label">🥩 Biaya Bahan</div>
          <div class="cost-value" style="color:{fin_cost_pct[0].bahan_90d > 32 ? '#dc2626' : '#16a34a'};">{fin_cost_pct[0].bahan_90d}%</div>
          <div class="cost-target">🎯 Target normal maks 32%</div>
          <div class="progress-track">
            <div class="progress-fill" style="width:{Math.min(fin_cost_pct[0].bahan_90d / 40 * 100, 100)}%; background:{fin_cost_pct[0].bahan_90d > 32 ? 'linear-gradient(90deg,#ef4444,#fca5a5)' : 'linear-gradient(90deg,#16a34a,#86efac)'};"></div>
            <div class="progress-target" style="left:{32 / 40 * 100}%;"></div>
          </div>
          <div class="progress-scale"><span>0%</span><span>32%</span><span>40%</span></div>
          <div class="cost-note">Perubahan vs 90 hari sebelumnya: {fin_cost_pct[0].delta_bahan_90d > 0 ? '+' : ''}{fin_cost_pct[0].delta_bahan_90d}pp.</div>
        </div>
        <div class="cost-card">
          <div class="cost-label">👥 Biaya SDM</div>
          <div class="cost-value" style="color:{fin_cost_pct[0].sdm_90d > 22 ? '#f59e0b' : '#16a34a'};">{fin_cost_pct[0].sdm_90d}%</div>
          <div class="cost-target">🎯 Target normal maks 22%</div>
          <div class="progress-track">
            <div class="progress-fill" style="width:{Math.min(fin_cost_pct[0].sdm_90d / 30 * 100, 100)}%; background:{fin_cost_pct[0].sdm_90d > 22 ? 'linear-gradient(90deg,#f59e0b,#fde68a)' : 'linear-gradient(90deg,#16a34a,#86efac)'};"></div>
            <div class="progress-target" style="left:{22 / 30 * 100}%;"></div>
          </div>
          <div class="progress-scale"><span>0%</span><span>22%</span><span>30%</span></div>
          <div class="cost-note">Perubahan vs 90 hari sebelumnya: {fin_cost_pct[0].delta_sdm_90d > 0 ? '+' : ''}{fin_cost_pct[0].delta_sdm_90d}pp.</div>
        </div>
        <div class="cost-card">
          <div class="cost-label">⚙️ Biaya Operasional</div>
          <div class="cost-value" style="color:{fin_cost_pct[0].ops_90d > 15 ? '#dc2626' : '#16a34a'};">{fin_cost_pct[0].ops_90d}%</div>
          <div class="cost-target">🎯 Target normal maks 15%</div>
          <div class="progress-track">
            <div class="progress-fill" style="width:{Math.min(fin_cost_pct[0].ops_90d / 25 * 100, 100)}%; background:{fin_cost_pct[0].ops_90d > 15 ? 'linear-gradient(90deg,#ef4444,#fca5a5)' : 'linear-gradient(90deg,#16a34a,#86efac)'};"></div>
            <div class="progress-target" style="left:{15 / 25 * 100}%;"></div>
          </div>
          <div class="progress-scale"><span>0%</span><span>15%</span><span>25%</span></div>
          <div class="cost-note">Perubahan vs 90 hari sebelumnya: {fin_cost_pct[0].delta_ops_90d > 0 ? '+' : ''}{fin_cost_pct[0].delta_ops_90d}pp.</div>
        </div>
      </div>
    </div>

    <div class="section-card">
      <div class="section-head tight">
        <div>
          <div class="section-eyebrow">📈 Tren Margin</div>
          <h3 class="section-title">Tren margin harian 90 hari</h3>
          <p class="section-copy">Semakin sering garis margin menyentuh area di bawah 15%, semakin besar kemungkinan tekanan biaya bukan sekadar kejadian sesaat.</p>
        </div>
      </div>
      <LineChart
        data={fin_margin_daily_90d}
        x="metric_date"
        y="margin_pct"
        title="Net Margin Harian 90 Hari (%)"
        yFmt="0.0\%"
        xAxisTitle="Tanggal"
        yAxisTitle="Net Margin (%)"
      >
        <ReferenceLine y={15} label="Target 15%" lineType="dashed" color="green" />
        <ReferenceLine y={10} label="Kritis 10%" lineType="dashed" color="red" />
      </LineChart>
    </div>

    <details>
      <summary>💡 Kenapa view 90 hari penting</summary>
      <div class="acc-body">
        View 90 hari berguna saat kamu ingin memisahkan noise dari pola. Kalau margin sehat di 30 hari tapi melemah di 90 hari, itu biasanya tanda revenue baru saja membaik namun pondasi biayanya belum benar-benar pulih.
      </div>
    </details>

  <!-- ══════════════════════════════════════════
       30D VIEW (default)
  ══════════════════════════════════════════ -->
  {:else}
    <div class="hero">
      <div>
        <div class="hero-eyebrow">📊 Laporan Keuangan · 30 Hari Terakhir</div>
        {#if fin_kpi[0].margin_30d >= 15}
          <h2 class="hero-title">Margin {fin_kpi[0].margin_30d}% masih sehat untuk basis operasional utama. ✅</h2>
        {:else if fin_kpi[0].margin_30d >= 10}
          <h2 class="hero-title">Margin {fin_kpi[0].margin_30d}% sudah masuk zona waspada dalam 30 hari. ⚠️</h2>
        {:else}
          <h2 class="hero-title">Margin {fin_kpi[0].margin_30d}% sudah kritis secara operasional. 🚨</h2>
        {/if}
        <div class="hero-copy">
          {#if fin_operational_overview[0].fokus_30d === 'Semua biaya dalam batas'}
            Seluruh komponen biaya masih berada dalam batas normal. Artinya persoalan utama bukan struktur biaya, tetapi menjaga momentum revenue dan kualitas eksekusi agar margin tidak melemah di periode berikutnya.
          {:else}
            Tekanan terbesar datang dari <strong>{fin_operational_overview[0].fokus_30d?.toLowerCase()}</strong>, sekitar <strong>{fin_operational_overview[0].fokus_gap_30d}pp</strong> di atas batas normal. Ini cukup jelas untuk dijadikan prioritas manajerial sekarang.
          {/if}
        </div>
      </div>
      <div class="hero-side">
        <div class="hero-side-card">
          <div class="hero-side-label">📅 Periode Aktif</div>
          <div class="hero-side-value">{fin_dates[0].tgl_30d_awal} - {fin_dates[0].tgl_akhir}</div>
          <div class="hero-side-note">Ini window paling stabil untuk keputusan operasional: cukup panjang untuk melihat pola, cukup dekat untuk bereaksi.</div>
        </div>
        <div class="hero-side-card">
          <div class="hero-side-label">📊 Pertumbuhan Revenue</div>
          <div class="hero-side-value">{fin_kpi[0].pct_change_gross_30d > 0 ? '+' : ''}{fin_kpi[0].pct_change_gross_30d}%</div>
          <div class="hero-side-note">Margin berubah {fin_kpi[0].delta_margin_30d > 0 ? '+' : ''}{fin_kpi[0].delta_margin_30d}pp vs 30 hari sebelumnya.</div>
        </div>
      </div>
    </div>

    <div class="kpi-grid">
      <div class="kpi-card revenue">
        <div class="kpi-label">💵 Gross Revenue</div>
        <div class="kpi-value">Rp {fin_kpi[0].gross_30d.toLocaleString('id-ID', { maximumFractionDigits: 0 })}</div>
        <div class="kpi-meta">30 hari sebelumnya: Rp {fin_kpi[0].gross_prev30d.toLocaleString('id-ID', { maximumFractionDigits: 0 })}</div>
      </div>
      <div class="kpi-card net">
        <div class="kpi-label">💰 Net Revenue</div>
        <div class="kpi-value">Rp {fin_kpi[0].net_30d.toLocaleString('id-ID', { maximumFractionDigits: 0 })}</div>
        <div class="kpi-meta">Nilai ini paling dekat dengan uang yang benar-benar tersisa setelah biaya inti.</div>
      </div>
      <div class="kpi-card margin">
        <div class="kpi-label">📈 Net Margin</div>
        <div class="kpi-value">{fin_kpi[0].margin_30d}%</div>
        <div class="kpi-meta">{fin_kpi[0].delta_margin_30d > 0 ? '↑ Naik' : '↓ Turun'} {Math.abs(fin_kpi[0].delta_margin_30d)}pp vs 30 hari sebelumnya.</div>
      </div>
      <div class="kpi-card cost">
        <div class="kpi-label">💸 Total Biaya</div>
        <div class="kpi-value">Rp {fin_kpi[0].biaya_30d.toLocaleString('id-ID', { maximumFractionDigits: 0 })}</div>
        <div class="kpi-meta">30 hari sebelumnya: Rp {fin_kpi[0].biaya_prev30d.toLocaleString('id-ID', { maximumFractionDigits: 0 })}</div>
      </div>
    </div>

    <div class="signal-grid">
      <div class="signal-card {fin_kpi[0].margin_30d >= 15 ? 'safe' : fin_kpi[0].margin_30d >= 10 ? 'warn' : 'critical'}">
        <div class="signal-label">
          {fin_kpi[0].margin_30d >= 15 ? '✅' : fin_kpi[0].margin_30d >= 10 ? '⚠️' : '🚨'} Apa Yang Sehat
        </div>
        <div class="signal-title">
          {#if fin_kpi[0].margin_30d >= 15 && fin_kpi[0].delta_margin_30d >= 0}
            Basis operasional 30 hari masih sehat dan membaik.
          {:else if fin_kpi[0].margin_30d >= 15}
            Margin masih sehat, tetapi kualitas efisiensi belum menguat.
          {:else if fin_kpi[0].margin_30d >= 10}
            Revenue masih cukup menjaga bisnis tetap keluar dari zona kritis.
          {:else}
            Sinyal sehat utama hanya tersisa di volume, bukan efisiensi.
          {/if}
        </div>
        <div class="signal-copy">
          {#if fin_kpi[0].margin_30d >= 15 && fin_kpi[0].delta_margin_30d >= 0}
            Ini kondisi yang paling enak untuk owner: bukan cuma hasilnya sehat, tapi arah perbaikannya juga benar. Tugas berikutnya menjaga disiplin biaya supaya tidak balik turun.
          {:else if fin_kpi[0].margin_30d >= 15}
            Bisnis masih nyaman secara hasil, tetapi revenue growth belum otomatis diikuti struktur biaya yang lebih efisien.
          {:else if fin_kpi[0].margin_30d >= 10}
            Masih ada ruang untuk pemulihan, tapi pressure point harus segera dibereskan agar margin tidak menembus bawah 10%.
          {:else}
            Ketika 30 hari sudah kritis, masalahnya bukan noise harian. Ini sudah cukup untuk memicu evaluasi menyeluruh.
          {/if}
        </div>
      </div>
      <div class="signal-card {fin_operational_overview[0].fokus_30d === 'Semua biaya dalam batas' ? 'neutral' : 'warn'}">
        <div class="signal-label">
          {fin_operational_overview[0].fokus_30d === 'Semua biaya dalam batas' ? '💡' : '🎯'} Yang Perlu Perhatian
        </div>
        <div class="signal-title">
          {#if fin_operational_overview[0].fokus_30d === 'Semua biaya dalam batas'}
            Belum ada komponen biaya yang benar-benar melampaui target.
          {:else}
            {fin_operational_overview[0].fokus_30d} jadi sumber tekanan paling jelas.
          {/if}
        </div>
        <div class="signal-copy">
          {#if fin_operational_overview[0].fokus_30d === 'Semua biaya dalam batas'}
            Ini berarti tekanan margin lebih mungkin datang dari campuran penjualan, diskon, atau kualitas transaksi. Struktur biaya belum memberi alarm merah.
          {:else}
            Selisih sekitar {fin_operational_overview[0].fokus_gap_30d}pp di atas batas normal sudah cukup untuk menjelaskan kenapa margin tidak naik setajam yang diharapkan.
          {/if}
        </div>
      </div>
    </div>

    <div class="section-card">
      <div class="section-head">
        <div>
          <div class="section-eyebrow">💸 Breakdown Biaya</div>
          <h3 class="section-title">Dari setiap Rp100 omzet, berapa yang habis di tiap pos?</h3>
          <p class="section-copy">Ini inti halaman keuangan: cari komponen mana yang paling merusak efisiensi, lalu tindak di situ dulu.</p>
        </div>
      </div>
      <div class="cost-grid">
        <div class="cost-card">
          <div class="cost-label">🥩 Biaya Bahan</div>
          <div class="cost-value" style="color:{fin_cost_pct[0].bahan_30d > 32 ? '#dc2626' : '#16a34a'};">{fin_cost_pct[0].bahan_30d}%</div>
          <div class="cost-target">🎯 Target normal maks 32%</div>
          <div class="progress-track">
            <div class="progress-fill" style="width:{Math.min(fin_cost_pct[0].bahan_30d / 40 * 100, 100)}%; background:{fin_cost_pct[0].bahan_30d > 32 ? 'linear-gradient(90deg,#ef4444,#fca5a5)' : 'linear-gradient(90deg,#16a34a,#86efac)'};"></div>
            <div class="progress-target" style="left:{32 / 40 * 100}%;"></div>
          </div>
          <div class="progress-scale"><span>0%</span><span>32%</span><span>40%</span></div>
          <div class="cost-note">Perubahan vs periode pembanding: {fin_cost_pct[0].delta_bahan_30d > 0 ? '+' : ''}{fin_cost_pct[0].delta_bahan_30d}pp.</div>
        </div>
        <div class="cost-card">
          <div class="cost-label">👥 Biaya SDM</div>
          <div class="cost-value" style="color:{fin_cost_pct[0].sdm_30d > 22 ? '#f59e0b' : '#16a34a'};">{fin_cost_pct[0].sdm_30d}%</div>
          <div class="cost-target">🎯 Target normal maks 22%</div>
          <div class="progress-track">
            <div class="progress-fill" style="width:{Math.min(fin_cost_pct[0].sdm_30d / 30 * 100, 100)}%; background:{fin_cost_pct[0].sdm_30d > 22 ? 'linear-gradient(90deg,#f59e0b,#fde68a)' : 'linear-gradient(90deg,#16a34a,#86efac)'};"></div>
            <div class="progress-target" style="left:{22 / 30 * 100}%;"></div>
          </div>
          <div class="progress-scale"><span>0%</span><span>22%</span><span>30%</span></div>
          <div class="cost-note">Perubahan vs periode pembanding: {fin_cost_pct[0].delta_sdm_30d > 0 ? '+' : ''}{fin_cost_pct[0].delta_sdm_30d}pp.</div>
        </div>
        <div class="cost-card">
          <div class="cost-label">⚙️ Biaya Operasional</div>
          <div class="cost-value" style="color:{fin_cost_pct[0].ops_30d > 15 ? '#dc2626' : '#16a34a'};">{fin_cost_pct[0].ops_30d}%</div>
          <div class="cost-target">🎯 Target normal maks 15%</div>
          <div class="progress-track">
            <div class="progress-fill" style="width:{Math.min(fin_cost_pct[0].ops_30d / 25 * 100, 100)}%; background:{fin_cost_pct[0].ops_30d > 15 ? 'linear-gradient(90deg,#ef4444,#fca5a5)' : 'linear-gradient(90deg,#16a34a,#86efac)'};"></div>
            <div class="progress-target" style="left:{15 / 25 * 100}%;"></div>
          </div>
          <div class="progress-scale"><span>0%</span><span>15%</span><span>25%</span></div>
          <div class="cost-note">Perubahan vs periode pembanding: {fin_cost_pct[0].delta_ops_30d > 0 ? '+' : ''}{fin_cost_pct[0].delta_ops_30d}pp.</div>
        </div>
      </div>
    </div>

    <div class="section-card">
      <div class="section-head tight">
        <div>
          <div class="section-eyebrow">📈 Tren Margin</div>
          <h3 class="section-title">Tren margin 30 hari: stabil sehat atau mulai retak?</h3>
          <p class="section-copy">Bila garis margin sering turun ke bawah 15%, biasanya satu komponen biaya sudah lebih cepat naik daripada kemampuan revenue menutupinya.</p>
        </div>
      </div>
      <LineChart
        data={fin_margin_daily_30d}
        x="metric_date"
        y="margin_pct"
        title="Net Margin Harian 30 Hari (%)"
        yFmt="0.0\%"
        xAxisTitle="Tanggal"
        yAxisTitle="Net Margin (%)"
      >
        <ReferenceLine y={15} label="Target 15%" lineType="dashed" color="green" />
        <ReferenceLine y={10} label="Kritis 10%" lineType="dashed" color="red" />
      </LineChart>
    </div>

    <details>
      <summary>💡 Kenapa 30 hari jadi default view</summary>
      <div class="acc-body">
        Tiga puluh hari adalah sweet spot untuk owner. Ia cukup panjang untuk mengurangi bias hari tertentu, tapi masih cukup dekat untuk mengarahkan tindakan operasional seperti pembelian, penjadwalan staf, pricing, dan promo.
      </div>
    </details>

    <details>
      <summary>🔧 Langkah konkret yang paling masuk akal dari view 30 hari</summary>
      <div class="acc-body">
        {#if fin_cost_pct[0].bahan_30d > 32}
          <p><strong>🥩 Bahan di atas target.</strong> Prioritas pertama: cek item yang paling mendorong COGS, waste, dan pricing menu yang margin-nya tipis.</p>
        {/if}
        {#if fin_cost_pct[0].sdm_30d > 22}
          <p><strong>👥 SDM di atas target.</strong> Lihat apakah jam kerja dan level staffing sebanding dengan kepadatan transaksi di minggu-minggu lemah.</p>
        {/if}
        {#if fin_cost_pct[0].ops_30d > 15}
          <p><strong>⚙️ Operasional di atas target.</strong> Ini sering berarti fixed cost terlalu berat untuk skala penjualan saat ini atau ada biaya rutin yang tidak lagi efisien.</p>
        {/if}
        Untuk melihat variasi antar cabang, buka halaman <a class="inline-link" href="/02-branch-performance">Performa Cabang</a>. Di halaman keuangan ini fokusnya tetap menjaga kesehatan margin total bisnis.
      </div>
    </details>
  {/if}

  <!-- ══════════════════════════════════════════
       PERSPEKTIF STRATEGIS (Accordion)
  ══════════════════════════════════════════ -->
  <div class="strategic-stack">
    <div class="strategic-header">
      <div class="strategic-eyebrow">🔭 Perspektif Strategis</div>
      <h2 class="strategic-title">Baca pola jangka panjang</h2>
      <p class="strategic-copy">Dua lens di bawah ini dirancang untuk pertanyaan yang lebih besar: apakah ada pola musiman yang perlu diantisipasi, dan apakah bisnis benar-benar membaik secara fundamental dari tahun ke tahun?</p>
    </div>

    <!-- Quarter Report Accordion -->
    <details class="acc-strategic">
      <summary>📊 Quarter Report · Baca Fenomena Musiman</summary>
      <div class="acc-body">

        {#each fin_quarter_comparison.slice(0, 1) as q}
          <div class="signal-card {q.margin_pct >= 15 ? 'safe' : q.margin_pct >= 10 ? 'warn' : 'critical'}" style="margin-bottom:16px;">
            <div class="signal-label">
              {q.margin_pct >= 15 ? '✅' : q.margin_pct >= 10 ? '⚠️' : '🚨'} Quarter Terkini
            </div>
            <div class="signal-title">{q.quarter_label} mencatat margin {q.margin_pct}%.</div>
            <div class="signal-copy">
              {#if q.delta_margin_q !== null}
                Margin bergerak {q.delta_margin_q > 0 ? 'naik' : 'turun'} {Math.abs(q.delta_margin_q)}pp dibanding quarter sebelumnya.
              {/if}
              {#if q.margin_pct >= 15}
                Ini memberi sinyal bahwa kualitas laba di level kuartal masih sehat.
              {:else if q.margin_pct >= 10}
                Masih bisa ditoleransi, tapi struktur biaya perlu dijaga sebelum masuk quarter berikutnya.
              {:else}
                Ini sinyal kuat bahwa masalahnya bukan lagi fluktuasi musiman biasa.
              {/if}
            </div>
          </div>
        {/each}

        <div class="mini-grid" style="margin-bottom:16px;">
          {#each fin_quarter_comparison.slice(0, 1) as q}
            <div class="mini-card">
              <div class="kpi-label">💰 Net Revenue</div>
              <div class="mini-value">Rp {q.net.toLocaleString('id-ID', { maximumFractionDigits: 0 })}</div>
              <div class="mini-note">{q.pct_change_net_q !== null ? `${q.pct_change_net_q > 0 ? '+' : ''}${q.pct_change_net_q}% vs quarter lalu` : 'Belum ada pembanding quarter sebelumnya.'}</div>
            </div>
            <div class="mini-card">
              <div class="kpi-label">🥩 Bahan</div>
              <div class="mini-value">{q.bahan_pct}%</div>
              <div class="mini-note">Porsi bahan terhadap gross revenue quarter terkini.</div>
            </div>
            <div class="mini-card">
              <div class="kpi-label">⚙️ Operasional</div>
              <div class="mini-value">{q.ops_pct}%</div>
              <div class="mini-note">Cocok untuk melihat apakah fixed cost mulai terasa berat saat musim berganti.</div>
            </div>
          {/each}
        </div>

        <DataTable data={fin_quarter_comparison}>
          <Column id="quarter_label" title="Quarter"/>
          <Column id="gross" title="Gross Revenue (Rp)" fmt="#,##0"/>
          <Column id="net" title="Net Revenue (Rp)" fmt="#,##0"/>
          <Column id="margin_pct" title="Net Margin (%)" fmt="0.0\%"/>
          <Column id="delta_margin_q" title="vs Quarter Lalu (pp)" fmt="+0.0;-0.0" contentType="delta"/>
          <Column id="bahan_pct" title="Bahan (%)" fmt="0.0\%"/>
          <Column id="sdm_pct" title="SDM (%)" fmt="0.0\%"/>
          <Column id="ops_pct" title="Ops (%)" fmt="0.0\%"/>
        </DataTable>

        <div style="margin-top:18px;">
          <LineChart
            data={fin_quarter}
            x="quarter_label"
            y="margin_pct"
            sort=false
            title="Net Margin per Quarter (%)"
            yFmt="0.0\%"
            xAxisTitle="Quarter"
            yAxisTitle="Net Margin (%)"
          />
          <div class="chart-insight">
            📌 <strong>Cara membaca chart ini:</strong> Perhatikan apakah ada quarter tertentu yang selalu lebih lemah — itu sinyal musiman. Kalau pola margin turun konsisten di Q1 atau Q3, misalnya, itu bukan kesalahan operasional tetapi ritme kalender yang bisa diantisipasi dengan manajemen biaya lebih ketat di periode tersebut.
          </div>
        </div>

        <div style="margin-top:18px;">
          <BarChart
            data={fin_quarter}
            x="quarter_label"
            y={["bahan_pct","sdm_pct","ops_pct"]}
            sort=false
            type="stacked"
            title="Struktur Biaya per Quarter (%)"
            yFmt="0.0\%"
            xAxisTitle="Quarter"
            yAxisTitle="% dari Gross Revenue"
          />
          <div class="chart-insight">
            📌 <strong>Cara membaca chart ini:</strong> Stacked bar memperlihatkan komposisi total beban biaya di tiap quarter. Kalau total bar makin tinggi tapi margin makin turun, artinya biaya tumbuh lebih cepat dari revenue. Fokus pada komponen mana yang "tumbuh" paling cepat antar quarter — bahan, SDM, atau operasional.
          </div>
        </div>

      </div>
    </details>

    <!-- YoY Accordion -->
    <details class="acc-strategic">
      <summary>📅 Year-over-Year · Baca Tren Fundamental</summary>
      <div class="acc-body">

        {#if fin_yoy.length >= 2}
          {#each fin_yoy.slice(0, 1) as yr}
            {#each fin_yoy.slice(1, 2) as yr_prev}
              <div class="signal-card {yr.margin_pct > yr_prev.margin_pct ? 'safe' : yr.margin_pct < yr_prev.margin_pct ? 'warn' : 'neutral'}" style="margin-bottom:16px;">
                <div class="signal-label">
                  {yr.margin_pct > yr_prev.margin_pct ? '📈' : yr.margin_pct < yr_prev.margin_pct ? '📉' : '➡️'} Tahun Terkini
                </div>
                <div class="signal-title">Margin {yr.tahun}: {yr.margin_pct}%.</div>
                <div class="signal-copy">
                  {#if yr.margin_pct > yr_prev.margin_pct}
                    Naik {Math.round((yr.margin_pct - yr_prev.margin_pct) * 10) / 10}pp dibanding {yr_prev.tahun}. Ini tanda baik bahwa perbaikan tidak hanya musiman, tetapi mulai terasa di level fundamental.
                  {:else if yr.margin_pct < yr_prev.margin_pct}
                    Turun {Math.round((yr_prev.margin_pct - yr.margin_pct) * 10) / 10}pp dibanding {yr_prev.tahun}. Artinya pertumbuhan belum otomatis membuat bisnis lebih efisien.
                  {:else}
                    Margin setara dengan {yr_prev.tahun}. Stabil, tetapi belum menunjukkan pergeseran kualitas laba.
                  {/if}
                </div>
              </div>
            {/each}
          {/each}
        {/if}

        <div style="margin-bottom:16px;">
          <DataTable data={fin_yoy}>
            <Column id="tahun" title="Tahun"/>
            <Column id="gross" title="Gross Revenue (Rp)" fmt="#,##0"/>
            <Column id="net" title="Net Revenue (Rp)" fmt="#,##0"/>
            <Column id="margin_pct" title="Net Margin (%)" fmt="0.0\%"/>
            <Column id="bahan_pct" title="Bahan (%)" fmt="0.0\%"/>
            <Column id="sdm_pct" title="SDM (%)" fmt="0.0\%"/>
            <Column id="ops_pct" title="Ops (%)" fmt="0.0\%"/>
          </DataTable>
        </div>

        <LineChart
          data={fin_yoy}
          x="tahun"
          y="margin_pct"
          title="Net Margin per Tahun (%)"
          yFmt="0.0\%"
          xAxisTitle="Tahun"
          yAxisTitle="Net Margin (%)"
        />
        <div class="chart-insight">
          📌 <strong>Cara membaca chart ini:</strong> Tren naik yang konsisten berarti bisnis secara fundamental makin efisien. Tren turun — walaupun revenue naik — biasanya berarti struktur biaya tumbuh lebih cepat dari omset, atau ada beban baru (ekspansi, inflasi SDM, kenaikan harga bahan) yang belum terimbangi oleh kenaikan harga jual.
        </div>

        <div style="margin-top:18px;">
          <BarChart
            data={fin_yoy}
            x="tahun"
            y={["bahan_pct","sdm_pct","ops_pct"]}
            type="stacked"
            title="Struktur Biaya per Tahun (%)"
            yFmt="0.0\%"
            xAxisTitle="Tahun"
            yAxisTitle="% dari Gross Revenue"
          />
          <div class="chart-insight">
            📌 <strong>Cara membaca chart ini:</strong> Kalau total stacked bar naik dari tahun ke tahun, artinya beban biaya makin besar relatif terhadap revenue — sinyal bahwa efisiensi operasional perlu diperhatikan lebih serius. Sebaliknya, total yang menyusut menandakan bisnis makin lean tanpa mengorbankan kualitas.
          </div>
        </div>

      </div>
    </details>

  </div>

</div>
{/if}