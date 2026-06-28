---
title: Inventori & Stok
sidebar_link: false
---


```sql inv_dates
SELECT * FROM restaurant.inv_stok_aktual_inv_dates
```

```sql inv_reorder_items
SELECT * FROM restaurant.inv_stok_aktual_a_reorder_items
```

```sql inv_overstock_items
SELECT * FROM restaurant.inv_stok_aktual_a_overstock_items
```

```sql inv_transfer_candidates
SELECT * FROM restaurant.inv_stok_aktual_b_transfer_candidates
```

```sql inv_reorder_by_branch
SELECT * FROM restaurant.inv_stok_aktual_inv_reorder_by_branch
```

```sql inv_reorder_severity_split
SELECT * FROM restaurant.inv_stok_aktual_inv_reorder_severity_split
```

```sql inv_stock_value_by_category
SELECT * FROM restaurant.inv_stok_aktual_inv_stock_value_by_category
```

<div class="evidence-tabs-container">
  <a href="/03-inventori-stok" class="tab-button">🏠 Ringkasan</a>
  <a href="/03-inventori-stok/stok-aktual" class="tab-button active">📦 Stok Aktual</a>
  <a href="/03-inventori-stok/branch" class="tab-button">🏪 Cabang</a>
  <a href="/03-inventori-stok/analisis-lanjutan" class="tab-button">🔭 Analisis Lanjutan</a>
</div>

<ButtonGroup name=stok_view>
  <ButtonGroupItem valueLabel="🛒 Queue Reorder" value="reorder" default />
  <ButtonGroupItem valueLabel="📦 Overstock & Kas Mati" value="overstock" />
</ButtonGroup>

{#if (inputs.stok_view ?? 'reorder') === 'reorder'}
  {#if inv_reorder_items && inv_reorder_items.length > 0 && inv_reorder_items[0]?.item_name !== null}
    {@const kritisCount = inv_reorder_items.filter(row => row.days_remaining !== null && row.days_remaining < 1.5).length}
    {@const reorderCount = inv_reorder_items.filter(row => row.days_remaining !== null && row.days_remaining >= 1.5 && row.days_remaining < 3.0).length}
    {@const pantauCount = inv_reorder_items.filter(row => row.days_remaining !== null && row.days_remaining >= 3.0).length}
    <div class="inv-page">

      <div class="subpage-hero">
        <div class="subpage-hero-eyebrow">🛒 REORDER BOARD</div>
        <h3 class="subpage-hero-title">Prioritas Pengadaan Barang Rawan Habis</h3>
        <p class="subpage-hero-copy">Daftar item dengan days_remaining &lt;= 5 hari, diurutkan dari coverage terpendek untuk tindakan pencegahan stockout cepat.</p>
      </div>

      <details class="guide-acc"  open>
  <summary>💡 Cara membaca Reorder &amp; Estimasi Hari</summary>
<div class="guide-body">
          <p style="margin-top: 4px; margin-bottom: 16px; font-weight: 500; color: var(--color-text-secondary);">
            Subpage ini menampilkan item-item yang stoknya hampir habis (estimasi coverage di bawah 5 hari). Prioritas diurutkan dari coverage paling pendek.
          </p>
          <div class="guide-grid" style="grid-template-columns: repeat(3, minmax(0, 1fr));">
            <div class="guide-card orange">
              <div class="guide-card-icon">🚨</div>
              <div class="guide-card-content">
                <div class="guide-card-label">Kritis</div>
                <h4 class="guide-card-title">Kritis (&lt; 1.5 Hari)</h4>
                <p class="guide-card-desc">Risiko tinggi kehabisan bahan baku dalam 24 jam. Menu berpotensi tidak dapat dijual. Lakukan PO darurat.</p>
              </div>
            </div>
            <div class="guide-card blue">
              <div class="guide-card-icon">🛒</div>
              <div class="guide-card-content">
                <div class="guide-card-label">Reorder</div>
                <h4 class="guide-card-title">Reorder (&lt; 3.0 Hari)</h4>
                <p class="guide-card-desc">Segera buat purchase order (PO) baru atau jadwalkan transfer stok antar cabang terdekat.</p>
              </div>
            </div>
            <div class="guide-card teal">
              <div class="guide-card-icon">📅</div>
              <div class="guide-card-content">
                <div class="guide-card-label">Monitoring</div>
                <h4 class="guide-card-title">Pantau (&lt;= 5.0 Hari)</h4>
                <p class="guide-card-desc">Stok cukup untuk sisa minggu ini. Masukkan item ke dalam pengajuan PO rutin berikutnya.</p>
              </div>
            </div>
          </div>
        </div>
</details>

      <div class="period-strip" style="margin-top: 14px;">
        <div class="period-pill kritis">
          <div class="period-pill-label">🚨 Kritis Hari Ini</div>
          <div class="period-pill-value">{kritisCount} item</div>
          <div class="period-pill-copy">Coverage &lt; 1.5 hari. Butuh tindakan segera untuk mencegah stockout menu.</div>
        </div>
        <div class="period-pill waspada">
          <div class="period-pill-label">⚠️ Reorder Sekarang</div>
          <div class="period-pill-value">{reorderCount} item</div>
          <div class="period-pill-copy">Coverage &lt; 3.0 hari. Ajukan PO atau transfer stok hari ini.</div>
        </div>
        <div class="period-pill sehat">
          <div class="period-pill-label">📋 Pantau Minggu Ini</div>
          <div class="period-pill-value">{pantauCount} item</div>
          <div class="period-pill-copy">Coverage 3.0 - 5.0 hari. Rencanakan pembelian di jadwal reguler.</div>
        </div>
      </div>

      <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); gap: 18px; margin-top: 16px;">
        <div class="section-card" style="margin-top: 0;">
          <div class="section-head">
            <div class="section-eyebrow">📊 DISTRIBUSI ANOMALI CABANG</div>
            <h3 class="section-title">Kerapuhan Stok per Outlet</h3>
            <p class="section-copy">Bandingkan jumlah item kritis, reorder, dan pantau di setiap cabang.</p>
          </div>
          <BarChart 
            data={inv_reorder_by_branch} 
            x="branch_name" 
            y="item_count" 
            series="status" 
            type="stacked" 
            xAxisTitle="Cabang" 
            yAxisTitle="Jumlah Item" 
            colorPalette={['#ef4444', '#f59e0b', '#14b8a6']} 
          />
        </div>
        <div class="section-card" style="margin-top: 0;">
          <div class="section-head">
            <div class="section-eyebrow">🍩 PROPORSI KEPARAHAN STOK</div>
            <h3 class="section-title">Komposisi Urgensi Pengadaan</h3>
            <p class="section-copy">Proporsi seluruh bahan kritis di semua cabang saat ini.</p>
          </div>
          <ECharts 
            config={ {
                tooltip: {
                    trigger: 'item',
                    formatter: '{b}: {c} item ({d}%)'
                },
                legend: {
                    bottom: '0%',
                    left: 'center'
                },
                series: [
                    {
                        type: 'pie',
                        radius: ['40%', '75%'],
                        avoidLabelOverlap: true,
                        itemStyle: {
                            borderRadius: 8,
                            borderColor: '#fff',
                            borderWidth: 2
                        },
                        label: {
                            show: true,
                            formatter: '{d}%'
                        },
                        data: [
                            { value: inv_reorder_severity_split?.find(r => r.status?.includes('Kritis'))?.item_count ?? 0, name: '🚨 Kritis', itemStyle: { color: '#ef4444' } },
                            { value: inv_reorder_severity_split?.find(r => r.status?.includes('Reorder'))?.item_count ?? 0, name: '⚠️ Reorder', itemStyle: { color: '#f59e0b' } },
                            { value: inv_reorder_severity_split?.find(r => r.status?.includes('Pantau'))?.item_count ?? 0, name: '📋 Pantau', itemStyle: { color: '#14b8a6' } }
                        ].filter(item => item.value > 0)
                    }
                ]
            } } 
          />
        </div>
      </div>

      <div class="section-card" style="margin-top: 16px;">
        <div class="section-head">
          <div class="section-eyebrow">📋 Daftar Detail Rawan Habis</div>
          <h3 class="section-title">Semua Item Rawan Habis di Cabang</h3>
          <p class="section-copy">Diurutkan berdasarkan sisa coverage hari terpendek.</p>
        </div>
        <DataTable data={inv_reorder_items} search=true rows=10>
          <Column id="branch_name" title="Cabang" />
          <Column id="item_name" title="Bahan" />
          <Column id="category" title="Kategori" />
          <Column id="stock_on_hand" title="Stok" fmt="#,##0.0" />
          <Column id="unit" title="Satuan" />
          <Column id="days_remaining" title="Sisa Hari" fmt="0.0" />
          <Column id="avg_daily_usage" title="Avg Pakai/Hari" fmt="#,##0.0" />
          <Column id="stock_value" title="Nilai Stok" fmt="#,##0" />
          <Column id="reorder_status" title="Status" />
        </DataTable>
      </div>

      {#if inv_transfer_candidates && inv_transfer_candidates.length > 0 && inv_transfer_candidates[0]?.item_name !== null}
      <div class="section-card" style="margin-top: 16px;">
        <div class="section-head">
          <div class="section-eyebrow">🔄 REKOMENDASI TRANSFER STOK</div>
          <h3 class="section-title">Transfer Stok Antar Cabang untuk Cegah Pembelian Baru</h3>
          <p class="section-copy">Pindahkan kelebihan stok dari cabang penyuplai ke cabang yang sedang kritis sebelum membuat PO supplier.</p>
        </div>
        <DataTable data={inv_transfer_candidates} search=true rows=5>
          <Column id="item_name" title="Bahan" />
          <Column id="category" title="Kategori" />
          <Column id="branch_need" title="Cabang Membutuhkan" />
          <Column id="need_days" title="Sisa Hari Cabang Butuh" fmt="0.0" />
          <Column id="branch_source" title="Cabang Penyuplai" />
          <Column id="source_days" title="Sisa Hari Penyuplai" fmt="0.0" />
          <Column id="source_stock" title="Stok Penyuplai" fmt="#,##0.0" />
          <Column id="source_stock_value" title="Nilai Stok Penyuplai" fmt="#,##0" />
        </DataTable>
      </div>
      {/if}

    </div>
  {:else}
    <div class="inv-page">
      <div class="action-empty" style="margin-top: 10px;">
        <div class="title">✅ Tidak ada bahan baku kritis. Semua stok aman di atas 5 hari coverage.</div>
      </div>
    </div>
  {/if}
{:else if inputs.stok_view === 'overstock'}
  {#if inv_overstock_items && inv_overstock_items.length > 0}
    <div class="inv-page">

      <div class="subpage-hero">
        <div class="subpage-hero-eyebrow">📦 OVERSTOCK &amp; MODAL KERJA</div>
        <h3 class="subpage-hero-title">Identifikasi Item dengan Stok Berlebih</h3>
        <p class="subpage-hero-copy">Daftar item dengan days_remaining &gt; 14 hari, yang berpotensi mengikat modal terlalu lama.</p>
      </div>

      <details class="guide-acc"  open>
  <summary>💡 Cara membaca Overstock &amp; Estimasi Idle Value</summary>
<div class="guide-body">
          <p style="margin-top: 4px; margin-bottom: 16px; font-weight: 500; color: var(--color-text-secondary);">
            Subpage ini menampilkan barang yang menumpuk di atas 14 hari pemakaian. Stok berlebih mengikat modal kerja operasional (working capital) dan berisiko waste/rusak.
          </p>
          <div class="guide-grid" style="grid-template-columns: repeat(3, minmax(0, 1fr));">
            <div class="guide-card orange">
              <div class="guide-card-icon">⚠️</div>
              <div class="guide-card-content">
                <div class="guide-card-label">Sangat Berlebih</div>
                <h4 class="guide-card-title">Sangat Berlebih (&gt;= 30 Hari)</h4>
                <p class="guide-card-desc">Modal kerja tertahan sangat lama. Tahan PO baru untuk item ini atau pindahkan ke outlet lain.</p>
              </div>
            </div>
            <div class="guide-card blue">
              <div class="guide-card-icon">📦</div>
              <div class="guide-card-content">
                <div class="guide-card-label">Berlebih Tinggi</div>
                <h4 class="guide-card-title">Berlebih Tinggi (&gt;= 21 Hari)</h4>
                <p class="guide-card-desc">Penumpukan stok cukup tinggi. Evaluasi ulang safety stock minimum dan jadwal pemesanan supplier.</p>
              </div>
            </div>
            <div class="guide-card teal">
              <div class="guide-card-icon">⚖️</div>
              <div class="guide-card-content">
                <div class="guide-card-label">Idle Value</div>
                <h4 class="guide-card-title">Estimasi Idle Value</h4>
                <p class="guide-card-desc">Perkiraan rupiah modal yang mengendap/tidak produktif karena jumlah stok melebihi batas aman 14 hari.</p>
              </div>
            </div>
          </div>
        </div>
</details>

      <div class="section-card" style="margin-top: 16px;">
        <div class="section-head">
          <div class="section-eyebrow">📋 Daftar Detail Overstock</div>
          <h3 class="section-title">Semua Item Overstock di Cabang</h3>
          <p class="section-copy">Diurutkan berdasarkan estimasi nilai idle terbesar.</p>
        </div>
        <DataTable data={inv_overstock_items} search=true rows=10>
          <Column id="branch_name" title="Cabang" />
          <Column id="item_name" title="Bahan" />
          <Column id="category" title="Kategori" />
          <Column id="stock_on_hand" title="Stok" fmt="#,##0.0" />
          <Column id="unit" title="Satuan" />
          <Column id="days_remaining" title="Coverage Hari" fmt="0.0" />
          <Column id="stock_value" title="Nilai Stok" fmt="#,##0" />
          <Column id="estimated_idle_value" title="Estimasi Idle" fmt="#,##0" />
          <Column id="purchase_usage_ratio_30d" title="Rasio Beli/Pakai 30H" fmt="0.0" />
        </DataTable>
      </div>

      {#if inv_transfer_candidates && inv_transfer_candidates.length > 0 && inv_transfer_candidates[0]?.item_name !== null}
      <div class="section-card" style="margin-top: 16px;">
        <div class="section-head">
          <div class="section-eyebrow">🔄 REKOMENDASI PENYALURAN STOK</div>
          <h3 class="section-title">Salurkan Stok Berlebih ke Cabang Membutuhkan</h3>
          <p class="section-copy">Pindahkan barang yang menumpuk di outlet penyuplai ke outlet yang hampir kehabisan stok sebelum mengajukan PO baru.</p>
        </div>
        <DataTable data={inv_transfer_candidates} search=true rows=5>
          <Column id="branch_source" title="Cabang Penyuplai (Overstock)" />
          <Column id="item_name" title="Bahan" />
          <Column id="category" title="Kategori" />
          <Column id="branch_need" title="Cabang Membutuhkan (Low Stock)" />
          <Column id="need_days" title="Sisa Hari Penerima" fmt="0.0" />
          <Column id="source_days" title="Sisa Hari Penyuplai" fmt="0.0" />
          <Column id="source_stock" title="Stok Penyuplai" fmt="#,##0.0" />
          <Column id="source_stock_value" title="Nilai Stok Penyuplai" fmt="#,##0" />
        </DataTable>
      </div>
      {/if}

      <div class="section-card" style="margin-top: 16px;">
        <div class="section-head">
          <div class="section-eyebrow">📊 Profil Nilai Stok vs Overstock</div>
          <h3 class="section-title">Komposisi Nilai Stok vs Overstock per Kategori</h3>
          <p class="section-copy">Bandingkan berapa bagian dari nilai stok kategori yang mengendap (overstock) dibanding totalnya.</p>
        </div>
        <BarChart data={inv_stock_value_by_category} x="category" y={["stock_value", "overstock_value"]} type="grouped" title="Nilai Stok vs Overstock per Kategori" yFmt="#,##0" xAxisTitle="Kategori" yAxisTitle="Nilai (Rp)" colorPalette={['#64748b', '#f97316']} />
      </div>

    </div>
  {:else}
    <div class="inv-page">
      <div class="action-empty" style="margin-top: 10px;">
        <div class="title">✅ Tidak ada item overstock. Semua coverage di bawah 14 hari.</div>
      </div>
    </div>
  {/if}
{/if}
