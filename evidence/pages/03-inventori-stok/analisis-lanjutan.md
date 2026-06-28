---
title: Inventori & Stok
sidebar_link: false
---


```sql inv_dates
SELECT * FROM restaurant.inv_analisis_inv_dates
```

```sql inv_supplier_alerts
SELECT * FROM restaurant.inv_analisis_a_supplier_alerts
```

```sql inv_price_trend_weekly
SELECT * FROM restaurant.inv_analisis_inv_price_trend_weekly
```

```sql inv_price_trend_weekly_focus
SELECT * FROM restaurant.inv_analisis_b_price_trend_weekly_focus
```

```sql inv_volatility_summary
SELECT * FROM restaurant.inv_analisis_inv_volatility_summary
```

<div class="evidence-tabs-container">
  <a href="/03-inventori-stok" class="tab-button">🏠 Ringkasan</a>
  <a href="/03-inventori-stok/stok-aktual" class="tab-button">📦 Stok Aktual</a>
  <a href="/03-inventori-stok/branch" class="tab-button">🏪 Cabang</a>
  <a href="/03-inventori-stok/analisis-lanjutan" class="tab-button active">🔭 Analisis Lanjutan</a>
</div>

<div class="inv-page">

  <div class="subpage-hero">
    <div class="subpage-hero-eyebrow">🔎 ANALISIS LANJUTAN</div>
    <h3 class="subpage-hero-title">Audit Harga Supplier &amp; Volatilitas</h3>
    <p class="subpage-hero-copy">Gunakan bagian ini untuk melacak kenaikan harga beli dari baseline kontrak supplier dan volatilitas bahan baku.</p>
  </div>

  <div class="section-card" style="margin-top: 16px;">
    <div class="section-head">
      <div class="section-eyebrow">⚠️ ALERT HARGA BELI SUPPLIER (30H)</div>
      <h3 class="section-title">Item dengan Kenaikan Harga Terbesar</h3>
      <p class="section-copy">Harga rata-rata pembelian aktual yang melebihi 10% dari baseline harga dasar kontrak supplier.</p>
    </div>
    <DataTable data={inv_supplier_alerts} search=true rows=10>
      <Column id="item_name" title="Bahan" />
      <Column id="category" title="Kategori" />
      <Column id="base_unit_cost" title="Harga Dasar" fmt="#,##0" />
      <Column id="avg_unit_cost" title="Harga Rata-Rata" fmt="#,##0" />
      <Column id="price_variance_pct" title="Variance (%)" fmt="0.0" />
      <Column id="usage_cost_30d" title="Pemakaian 30H" fmt="#,##0" />
      <Column id="estimated_price_impact" title="Estimasi Dampak" fmt="#,##0" />
      <Column id="severity" title="Status" />
    </DataTable>
  </div>

  <div class="section-card" style="margin-top: 16px;">
    <div class="section-head">
      <div class="section-eyebrow">📈 Tren Harga &amp; Volatilitas (90H)</div>
      <h3 class="section-title">Rincian Volatilitas &amp; Tren Harga Historis</h3>
      <p class="section-copy">Analisis volatilitas membantu mengidentifikasi bahan baku dengan fluktuasi harga tinggi untuk penyesuaian strategi purchasing.</p>
    </div>
    <Grid cols=2>
      <div>
        <DataTable data={inv_volatility_summary} search=true rows=8>
          <Column id="item_name" title="Bahan" />
          <Column id="harga_min" title="Min" fmt="#,##0" />
          <Column id="harga_maks" title="Maks" fmt="#,##0" />
          <Column id="harga_rata" title="Rata-rata" fmt="#,##0" />
          <Column id="volatilitas_pct" title="Volatilitas (%)" fmt="0.0" />
          <Column id="selisih_vs_dasar_pct" title="Selisih vs Dasar (%)" fmt="0.0" />
          <Column id="kategori_volatilitas" title="Volatilitas" />
        </DataTable>
      </div>
      <div>
        {#if inv_price_trend_weekly_focus.length > 0}
          <LineChart data={inv_price_trend_weekly_focus} x="minggu" y="harga_rata_beli" series="item_name" title="Tren Harga Beli Mingguan (Top Alert)" xAxisTitle="Minggu" yAxisTitle="Harga Rata-Rata (Rp)" colorPalette={['#2563eb', '#475569', '#818cf8', '#0d9488', '#64748b', '#94a3b8']} />
        {/if}
      </div>
    </Grid>
  </div>

</div>
