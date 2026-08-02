---
title: Inventori & Stok
sidebar: hide
---

<script>
  import InvGuide from '$lib/InvGuide.svelte';
  import InvTabs from '$lib/InvTabs.svelte';
  import SectionHeader from '$lib/SectionHeader.svelte';
  import SectionCard from '$lib/SectionCard.svelte';
  import PremiumTable from '$lib/PremiumTable.svelte';

  const ratio = 0.7;
  const inflation = 29.1;
  const ontime = 95.2;
</script>

<InvGuide />

<InvTabs activeTab="analysis" />

```sql supplier_kpi
/* 
  PIPELINE DATA KPI SUPPLIER
  Total Pengeluaran dan Inflasi menggunakan DATA ASLI dari mart_inventory_stok.
  Fulfillment dan Defect Rate menggunakan MOCK DATA.
  
  [AI ASSISTANT INSTRUCTION]: 
  Jika tabel fact_purchase_orders sudah tersedia, ganti MOCK_METRICS 
  dengan agregasi asli (misal: AVG(is_on_time) untuk fulfillment).
*/
WITH real_metrics AS (
    SELECT
        SUM(purchase_cost) AS total_spend,
        (AVG(avg_unit_cost) - AVG(base_unit_cost)) / NULLIF(AVG(base_unit_cost), 0) * 100 AS avg_inflation
    FROM restaurant.inventory_stok
    WHERE txn_date >= (SELECT MAX(txn_date) FROM restaurant.inventory_stok) - INTERVAL '29 days'
),
mock_metrics AS (
    SELECT 
        95.2 AS on_time_pct,
        2.8 AS defect_rate_pct
)
SELECT 
    COALESCE(r.total_spend, 0) AS total_spend,
    COALESCE(ROUND(r.avg_inflation, 1), 0) AS avg_inflation,
    m.on_time_pct,
    m.defect_rate_pct
FROM real_metrics r
CROSS JOIN mock_metrics m
```

```sql price_spikes
/* 
  PIPELINE DATA RADAR LONJAKAN HARGA
  Harga dasar dan harga baru menggunakan DATA ASLI dari mart_inventory_stok.
  Nama Supplier (supplier_name) saat ini MOCK DATA (dibuat menggunakan CASE).
  
  [AI ASSISTANT INSTRUCTION]: 
  1. Untuk menyambungkan ke data asli, hapus CASE 'supplier_name' dan ganti dengan:
     LEFT JOIN restaurant.dim_supplier s ON i.supplier_id = s.supplier_id
  2. Saat migrasi ke data nyata, PASTIKAN untuk menyesuaikan ulang kategori 
     dan nilai ambang batas ideal (Waspada/Kritis) di dalam CASE status_inflasi 
     agar sesuai dengan profil fluktuasi riil bisnis restoran ini.
*/
WITH raw_spikes AS (
    SELECT
        item_name,
        category,
        AVG(base_unit_cost) AS old_price,
        AVG(avg_unit_cost) AS new_price,
        (AVG(avg_unit_cost) - AVG(base_unit_cost)) / NULLIF(AVG(base_unit_cost), 0) * 100 AS spike_pct,
        -- Mocking supplier name based on category
        CASE 
            WHEN category = 'produce' THEN 'PT Tani Makmur'
            WHEN category = 'protein' THEN 'Sapi Bintang Merah'
            WHEN category = 'seafood' THEN 'Lautan Samudera'
            WHEN category = 'oil' THEN 'Agen Minyak Bumi'
            WHEN category = 'grain' THEN 'Grosir Kebutuhan'
            WHEN category = 'utility' THEN 'Pemasok Utilitas'
            WHEN category = 'drink' THEN 'Toko Minuman'
            ELSE 'Grosir Umum'
        END AS supplier_name
    FROM restaurant.inventory_stok
    WHERE txn_date = (SELECT MAX(txn_date) FROM restaurant.inventory_stok)
    GROUP BY 1, 2
)
SELECT 
    item_name,
    category,
    supplier_name,
    old_price,
    new_price,
    ROUND(spike_pct, 1) || '%' AS spike_pct_str,
    spike_pct,
    CASE 
        WHEN category IN ('protein', 'seafood') THEN
            CASE WHEN spike_pct > 8 THEN 'Kritis' WHEN spike_pct > 5 THEN 'Waspada' ELSE 'Aman' END
        WHEN category = 'produce' THEN
            CASE WHEN spike_pct > 25 THEN 'Kritis' WHEN spike_pct > 15 THEN 'Waspada' ELSE 'Aman' END
        ELSE
            CASE WHEN spike_pct > 12 THEN 'Kritis' WHEN spike_pct > 8 THEN 'Waspada' ELSE 'Aman' END
    END AS status_inflasi
FROM raw_spikes
WHERE CASE 
        WHEN category IN ('protein', 'seafood') THEN
            CASE WHEN spike_pct > 8 THEN 'Kritis' WHEN spike_pct > 5 THEN 'Waspada' ELSE 'Aman' END
        WHEN category = 'produce' THEN
            CASE WHEN spike_pct > 25 THEN 'Kritis' WHEN spike_pct > 15 THEN 'Waspada' ELSE 'Aman' END
        ELSE
            CASE WHEN spike_pct > 12 THEN 'Kritis' WHEN spike_pct > 8 THEN 'Waspada' ELSE 'Aman' END
      END != 'Aman'
ORDER BY spike_pct DESC
```

```sql historical_price_spikes
/* 
  DATA TREN HISTORIS LONJAKAN HARGA
  Mengambil data riwayat harga dari bahan baku yang saat ini menyentuh
  ambang batas Waspada/Kritis berdasarkan kategorinya.

  [AI ASSISTANT INSTRUCTION]:
  Logika kategori 'alert_items' di bawah (protein >5%, produce >15%, dll) 
  harus disinkronkan dengan nilai ideal riil saat data asli (production) masuk.
*/
WITH top_spikes AS (
    SELECT item_name, category, (AVG(avg_unit_cost) - AVG(base_unit_cost)) / NULLIF(AVG(base_unit_cost), 0) * 100 AS spike_pct
    FROM restaurant.inventory_stok
    WHERE txn_date = (SELECT MAX(txn_date) FROM restaurant.inventory_stok)
    GROUP BY 1, 2
),
alert_items AS (
    SELECT item_name
    FROM top_spikes
    WHERE 
        (category IN ('protein', 'seafood') AND spike_pct > 5) OR
        (category = 'produce' AND spike_pct > 15) OR
        (category NOT IN ('protein', 'seafood', 'produce') AND spike_pct > 8)
)
SELECT 
    i.txn_date,
    i.item_name,
    AVG(i.avg_unit_cost) AS unit_cost
FROM restaurant.inventory_stok i
JOIN alert_items t ON i.item_name = t.item_name
WHERE i.txn_date >= (SELECT MAX(txn_date) - INTERVAL '29 days' FROM restaurant.inventory_stok)
GROUP BY 1, 2
ORDER BY 1 ASC
```

```sql supplier_data
/* 
  PIPELINE DATA SUPPLIER SCORECARD
  Saat ini menggunakan data simulasi (mock) seutuhnya. 
  
  [AI ASSISTANT INSTRUCTION]:
  Jika data asli sudah siap:
  1. Hapus blok CTE 'mock_data' 
  2. Ubah "FROM mock_data" menjadi "FROM restaurant.dim_supplier" (atau mart terkait).
  3. Pastikan kolom-kolomnya sesuai dengan SELECT di bawah ini.
*/
WITH mock_data AS (
    SELECT 'PT Tani Makmur' AS supplier_name, 'produce' AS category, 99.0 AS on_time_pct, 95.5 AS in_full_pct, 2.1 AS defect_rate_pct, 12000000 AS spend_30d
    UNION ALL SELECT 'Sapi Bintang Merah', 'protein', 100.0, 98.2, 0.5, 35000000
    UNION ALL SELECT 'Grosir Kebutuhan', 'grain', 100.0, 100.0, 0.0, 22000000
    UNION ALL SELECT 'Agen Minyak Bumi', 'oil', 88.0, 100.0, 1.0, 28000000
    UNION ALL SELECT 'Pemasok Utilitas', 'utility', 85.0, 100.0, 0.0, 10000000
    UNION ALL SELECT 'Toko Minuman', 'drink', 95.0, 99.0, 0.2, 8000000
),
actual_table AS (
    SELECT *,
        CASE 
            WHEN on_time_pct < 90 OR in_full_pct < 95 OR defect_rate_pct > 3 THEN 'C'
            WHEN on_time_pct >= 95 AND in_full_pct >= 98 AND defect_rate_pct <= 1 THEN 'A'
            ELSE 'B'
        END AS grade
    FROM mock_data
)
SELECT
    supplier_name,
    category,
    ROUND(on_time_pct, 1) || '%' AS on_time_str,
    ROUND(in_full_pct, 1) || '%' AS in_full_str,
    ROUND(defect_rate_pct, 1) || '%' AS defect_pct,
    spend_30d,
    grade,
    CASE 
        WHEN grade = 'A' THEN 'Sangat Baik'
        WHEN grade = 'B' THEN 'Baik'
        ELSE 'Evaluasi'
    END AS status_evaluasi
FROM actual_table
ORDER BY grade ASC, spend_30d DESC
```

```sql supplier_watchlist
/*
  PIPELINE DAFTAR PENGAWASAN SUPPLIER (WATCHLIST 60 HARI)
  Tabel ini menyoroti supplier yang mendapatkan status Evaluasi (C) 
  minimal satu kali dalam 2 bulan terakhir.
  
  [AI ASSISTANT INSTRUCTION]:
  Ubah query ini untuk melakukan agregasi per bulan dari tabel fakta 
  pengiriman riil.
*/
WITH mock_watchlist AS (
    SELECT 'Pemasok Utilitas' AS supplier_name, 'Evaluasi (C)' AS prev_month_grade, 'Evaluasi (C)' AS curr_month_grade
    UNION ALL SELECT 'Agen Minyak Bumi', 'Baik (B)', 'Evaluasi (C)'
),
watchlist_logic AS (
    SELECT 
        supplier_name,
        prev_month_grade,
        curr_month_grade,
        CASE 
            WHEN prev_month_grade LIKE '%C%' AND curr_month_grade LIKE '%C%' THEN '🚨 Putus Kontrak / Alihkan 50% Kuota'
            WHEN prev_month_grade LIKE '%C%' OR curr_month_grade LIKE '%C%' THEN '⚠️ Pantau Ketat'
            ELSE '✅ Aman'
        END AS rekomendasi
    FROM mock_watchlist
)
SELECT * FROM watchlist_logic
```
{#if typeof supplier_kpi !== 'undefined' && supplier_kpi.length > 0}

<div class="decision-box amber" style="margin-top: 24px; margin-bottom: 32px;">
  <div class="decision-content">
    <div class="decision-title">
      <span style="display: flex; align-items: center; gap: 8px;">
        💡 Insight Strategis & Rekomendasi
      </span>
      <div class="ai-badge">✨ AI Generated</div>
    </div>

    <p class="decision-text" style="color: var(--color-text-primary); margin-bottom: 12px;">
      <strong>
      {#if inflation > 15 && ratio < 0.9}
        🔍 Observasi: Anomali Silang: Penurunan Volume PO di Tengah Lonjakan Harga
      {:else if inflation <= 15 && ratio < 0.9}
        🔍 Observasi: Pemotongan Anggaran & Risiko Kelangkaan Stok
      {:else if ratio > 1.2}
        🔍 Observasi: Penumpukan Inventori (Over-buying)
      {:else}
        🔍 Observasi: Stabilitas Pengadaan Terkendali
      {/if}
      </strong>
    </p>
    
    <p class="decision-text" style="color: var(--color-text-primary); margin-bottom: 16px;">
      {#if ratio < 0.9}
        Data agregat 30 hari terakhir merekam anomali <strong>defisit pengadaan</strong>, di mana volume konsumsi operasional jauh melampaui total pembelian bahan baku (Rasio <strong>{ratio}x</strong>). Secara matematis, selisih gap konsumsi harian ini menyerap langsung persediaan stok awal (<em>safety stock</em>) yang tersisa di gudang.
        <br><br>
        {#if inflation > 15 && ontime > 90}
          <strong>Insight:</strong> Menariknya, volume <em>Purchase Order</em> (PO) tetap ditekan meskipun tidak ada gangguan dari sisi logistik supplier (<strong>On-Time {ontime}%</strong>). Penahanan PO ini terjadi beririsan dengan momentum harga modal yang sedang melambung tajam (<strong>+{inflation}%</strong>).
        {:else if inflation > 15 && ontime <= 90}
          <strong>Insight:</strong> Tren <em>under-purchasing</em> ini terjadi di tengah tekanan ganda: lonjakan harga modal (<strong>+{inflation}%</strong>) dan kemunduran performa supplier (<strong>{ontime}% On-Time</strong>). Kekosongan stok saat ini tidak didukung oleh kepastian pengiriman logistik eksternal.
        {:else}
          <strong>Insight:</strong> Penahanan volume belanja ini cukup anomali. Pemangkasan PO terus terjadi padahal harga modal relatif stabil (<strong>+{inflation}%</strong>) dan performa logistik supplier tetap konsisten. Data tidak menunjukkan tekanan eksternal yang mengharuskan penahanan pesanan.
        {/if}
      {:else if ratio > 1.2}
        Data agregat 30 hari terakhir merekam tren <strong>surplus pengadaan</strong>, di mana laju pembelian bahan baku melonjak melampaui rata-rata pemakaian normal dapur (Rasio <strong>{ratio}x</strong>). Selisih laju positif ini terekam sebagai eskalasi inventori fisik (<em>stock build-up</em>) di seluruh fasilitas penyimpanan.
        <br><br>
        {#if inflation > 15 && ontime > 90}
          <strong>Insight:</strong> Volume pembelian membeludak justru di saat harga modal sedang meroket (<strong>+{inflation}%</strong>). Penumpukan stok mahal ini terjadi padahal aliran logistik eksternal sebenarnya sangat lancar (<strong>On-Time {ontime}%</strong>).
        {:else if inflation > 15 && ontime <= 90}
          <strong>Insight:</strong> Volume pembelian membeludak di saat harga modal sedang meroket tajam (<strong>+{inflation}%</strong>). Hal ini beririsan dengan memburuknya performa supplier (<strong>{ontime}% On-Time</strong>), merepresentasikan kemungkinan terjadinya <em>panic buying</em> sebagai bantalan terhadap ketidakpastian pasokan.
        {:else if inflation <= 15 && ontime > 90}
          <strong>Insight:</strong> Tren <em>over-buying</em> (penumpukan stok) ini terekam saat indikator eksternal sedang landai; harga modal relatif stagnan (<strong>+{inflation}%</strong>) tanpa ada hambatan sama sekali pada rantai pasok supplier (<strong>On-Time {ontime}%</strong>).
        {:else}
          <strong>Insight:</strong> Terjadi penumpukan volume stok meski harga modal relatif stabil (<strong>+{inflation}%</strong>). Kondisi ini bertepatan dengan menurunnya reliabilitas pengiriman supplier (<strong>{ontime}% On-Time</strong>), memunculkan dugaan upaya proteksi stok dapur dari krisis logistik.
        {/if}
      {:else}
        Data agregat 30 hari terakhir merekam pergerakan rantai pasok pada <strong>titik ekuilibrium (Rasio {ratio}x)</strong>. Angka ini merepresentasikan rasio proporsional antara arus barang masuk (PO) dan laju pemakaian dapur, menjaga likuiditas uang kas tetap sejajar dengan ketersediaan fisik.
        <br><br>
        {#if inflation > 15 && ontime > 90}
          <strong>Insight:</strong> Meskipun fluktuasi harga modal mengalami tekanan ekstrem (<strong>+{inflation}%</strong>), rasio perputaran belanja dipertahankan proporsional. Lancarnya performa supplier (<strong>On-Time {ontime}%</strong>) kemungkinan besar menunjang disiplin pengadaan ini.
        {:else if inflation > 15 && ontime <= 90}
          <strong>Insight:</strong> Kedisiplinan rasio belanja ini menjadi paradoks yang menarik karena terjadi tepat saat dihantam tekanan ganda: lonjakan harga modal (<strong>+{inflation}%</strong>) sekaligus kemunduran keandalan logistik supplier (<strong>{ontime}% On-Time</strong>).
        {:else if inflation <= 15 && ontime > 90}
          <strong>Insight:</strong> Seluruh indikator makro pengadaan beroperasi pada kondisi ideal. Tren harga modal sangat terkendali (<strong>+{inflation}%</strong>), rasio serapan seimbang, dan layanan logistik supplier berkinerja tinggi (<strong>On-Time {ontime}%</strong>).
        {:else}
          <strong>Insight:</strong> Rasio perputaran belanja dijaga seimbang dan harga modal cukup stabil (<strong>+{inflation}%</strong>), meskipun hal ini terjadi di tengah gejolak penurunan kepastian SLA pengiriman oleh pihak supplier (<strong>{ontime}% On-Time</strong>).
        {/if}
      {/if}
    </p>

    <div class="metrics-row" style="margin-top: 24px;">
      <div class="metric-pill">⚖️ Efisiensi Beli: {ratio}x</div>
      <div class="metric-pill">📈 Tren Harga: +{inflation}%</div>
      <div class="metric-pill">🚚 On-Time: {ontime}%</div>
      <div class="metric-pill">📉 Reject Rate: 1.8%</div>
    </div>
    
    <div class="decision-footer" style="margin-top: 24px;">
      <em>*Disclaimer: Analisis ini dikalkulasi secara otomatis oleh AI berdasarkan komparasi rasio perputaran pesanan (PO), tren histori harga modal, dan rapor SLA supplier selama 30 hari terakhir. Gunakan insight ini sebagai petunjuk arah (compass), namun tetap validasi keadaan di lapangan.</em>
    </div>
  </div>
</div>






<!-- RISIKO STRUKTURAL SECTION -->
  <div class="diagnostics-header" style="margin-top: 48px; margin-bottom: 24px;">
    <div class="diagnostics-eyebrow">⚠️ DINAMIKA RANTAI PASOK (SUPPLY CHAIN)</div>
    <h2 class="diagnostics-title">Membedah Risiko Penumpukan & Kekosongan Stok</h2>
    <p class="diagnostics-copy">Memahami mengapa rasio efisiensi beli (PO vs Pemakaian) harus dipertahankan di angka 1.0x untuk mencegah matinya uang kas di gudang atau lumpuhnya operasional dapur.</p>
  </div>

  <div class="risk-section">

    <div class="risk-row purple-theme">
      <div class="risk-row-header">
        <span class="risk-row-icon">📦</span>
        <h4 class="risk-row-title">Bahaya Penumpukan (Over-Purchasing / Rasio &gt; 1.2x)</h4>
      </div>
      <div class="risk-pills">
        <div class="risk-pill">
          <span class="risk-pill-anchor">💸</span>
          <div class="risk-pill-content">
            <strong>Uang Mati (Dead Cash)</strong>
            <span>Modal kas perusahaan terkunci dalam bentuk fisik barang yang belum tentu terjual habis di bulan berjalan.</span>
          </div>
        </div>
        <div class="risk-pill">
          <span class="risk-pill-anchor">🗑️</span>
          <div class="risk-pill-content">
            <strong>Risiko Penyusutan (Spoilage)</strong>
            <span>Bahan segar (produce/protein) punya masa kedaluwarsa. Menimbun memperbesar risiko barang busuk sebelum laku.</span>
          </div>
        </div>
        <div class="risk-pill">
          <span class="risk-pill-anchor">🏢</span>
          <div class="risk-pill-content">
            <strong>Beban Ruang Gudang</strong>
            <span>Kelebihan pasokan membebani kapasitas pendingin (chiller), memaksa penggunaan energi ekstra atau sewa gudang luar.</span>
          </div>
        </div>
      </div>
      <div class="risk-funfact">
        <span class="risk-funfact-icon">📎</span>
        <div class="risk-funfact-content">
          <span>Menumpuk inventori di atas kebutuhan standar dapat menggerus margin operasional bersih hingga <strong>15%-20%</strong> akibat <em>holding cost</em> (biaya simpan) dan <em>food waste</em>.</span>
          <cite>Prinsip Lean Inventory Management</cite>
        </div>
      </div>
    </div>

    <div class="risk-row blue-theme">
      <div class="risk-row-header">
        <span class="risk-row-icon">⏳</span>
        <h4 class="risk-row-title">Risiko Kekosongan (Under-Purchasing / Rasio &lt; 0.9x)</h4>
      </div>
      <div class="risk-pills">
        <div class="risk-pill">
          <span class="risk-pill-anchor">🛑</span>
          <div class="risk-pill-content">
            <strong>Hilangnya Potensi Jual</strong>
            <span>Menu "Sold Out" membuat pelanggan kecewa, pindah ke kompetitor, dan menghilangkan pendapatan secara permanen.</span>
          </div>
        </div>
        <div class="risk-pill">
          <span class="risk-pill-anchor">🚀</span>
          <div class="risk-pill-content">
            <strong>Panic Buying Darurat</strong>
            <span>Dapur terpaksa membeli bahan dadakan dari pasar lokal dengan harga retail (non-grosir) yang jauh lebih merugikan.</span>
          </div>
        </div>
        <div class="risk-pill">
          <span class="risk-pill-anchor">⚙️</span>
          <div class="risk-pill-content">
            <strong>Inkonsistensi Resep</strong>
            <span>Kehabisan satu bumbu kunci seringkali memaksa koki menggunakan bahan pengganti, merusak standar rasa restoran.</span>
          </div>
        </div>
      </div>
      <div class="risk-funfact">
        <span class="risk-funfact-icon">📎</span>
        <div class="risk-funfact-content">
          <span>Pelanggan restoran reguler yang mendapati menu favoritnya <em>sold-out</em> memiliki <strong>30% probabilitas</strong> untuk tidak pernah kembali lagi ke gerai Anda.</span>
          <cite>Studi Kepuasan Pelanggan F&B</cite>
        </div>
      </div>
    </div>
  </div>

<div style="margin-top: 48px;">
  <SectionHeader 
    eyebrow="📑 Ruang Data Pendukung"
    title="Pusat Data Ekstra & Perspektif Strategis"
    description="Gunakan lensa tambahan di bawah ini untuk membedah fluktuasi harga bahan baku serta melacak rapor kinerja logistik dari seluruh pihak pemasok (supplier)."
  />
</div>

<div class="data-wrapper">
  <Tabs id="analisis_inventori_tabs" fullWidth=true>

    <Tab label="📈 Analisis Harga & Inflasi">
      <div style="padding: 12px 0px;">
      
    {#if historical_price_spikes && historical_price_spikes.length > 0}
      <div class="section-head tight" style="margin-bottom: 12px;">
        <div>
          <div class="section-eyebrow">📈 Tren Kenaikan Harga (30 Hari Terakhir)</div>
          <h3 class="section-title">Seberapa agresif pergerakan harga bahan baku kritis?</h3>
          <p class="section-copy">Menampilkan histori pergerakan harga harian untuk item yang menyentuh batas Waspada/Kritis berdasarkan kategorinya.</p>
        </div>
      </div>
      <div style="margin-bottom: 8px;">
        <LineChart 
          data={historical_price_spikes} 
          x="txn_date" 
          y="unit_cost" 
          series="item_name" 
          yAxisTitle="Harga Modal (Rp)"
          xAxisTitle="Tanggal"
          yFmt="#,##0"
        />
      </div>
      <div class="chart-insight-bar" style="margin-bottom: 32px;">
        📌 <strong>Bukti Negosiasi (Tren Harga):</strong> Gunakan grafik histori ini sebagai pijakan negosiasi ulang kontrak harga. Anda bisa melihat dengan jelas kapan persisnya harga mulai lepas landas dari harga patokan dasar.
      </div>
    {/if}

    {#if price_spikes && price_spikes.length > 0}
      <div class="section-head tight" style="margin-bottom: 12px;">
        <div>
          <div class="section-eyebrow">💸 Tekanan Harga Supplier (Snapshot Hari Ini)</div>
          <h3 class="section-title">Kategori mana dengan lonjakan harga tertinggi?</h3>
          <p class="section-copy">Menampilkan daftar detail bahan baku yang menyentuh batas Waspada/Kritis berdasarkan kategorinya.</p>
        </div>
      </div>
      <PremiumTable 
        data={price_spikes}
        rowColor={(row) => row.status_inflasi === 'Kritis' ? 'rgba(239, 68, 68, 0.15)' : row.status_inflasi === 'Waspada' ? 'rgba(245, 158, 11, 0.15)' : null}
        columns={[
          { key: 'item_name', title: 'Nama Barang' },
          { key: 'category', title: 'Kategori' },
          { key: 'supplier_name', title: 'Supplier (Mock)' },
          { key: 'old_price', title: 'Harga Dasar', type: 'currency' },
          { key: 'new_price', title: 'Harga Terbaru', type: 'currency' },
          { key: 'spike_pct_str', title: 'Kenaikan' },
          { key: 'status_inflasi', title: 'Status' }
        ]}
      />
    {:else}
      <div class="action-empty">
        <div class="title">✅ Harga Terkendali</div>
        <div class="subtitle">Tidak ada indikasi lonjakan harga bahan baku yang merugikan.</div>
      </div>
    {/if}
      <div class="chart-insight-bar" style="margin-top: 16px;">
        📌 <strong>Bukti Negosiasi (Snapshot Hari Ini):</strong> Gunakan tabel ini sebagai pijakan negosiasi ulang kontrak harga. Persentase lonjakan dihitung dengan membandingkan rata-rata harga modal (unit cost) aktual di seluruh cabang hari ini terhadap harga patokan dasar.
      </div>

      <div style="margin-top: 24px;">
        <details class="guide-acc" style="margin-bottom:24px;">
          <summary>💡 Cara membaca ambang batas</summary>
          <div class="guide-body">
            <p style="margin-top: 4px; margin-bottom: 16px; font-weight: 500; color: var(--color-text-secondary);">
              Ambang batas inflasi kini dibedakan berdasarkan jenis bahan baku (Sensitivitas Margin) untuk menghindari peringatan palsu pada bahan bersiklus cuaca (sayuran) dan memprioritaskan peringatan pada bahan padat modal (daging).
            </p>
            <div class="guide-grid" style="grid-template-columns: repeat(2, minmax(0, 1fr));">
              <div class="guide-card purple">
                <div class="guide-card-icon">🥩</div>
                <div class="guide-card-content">
                  <div class="guide-card-label">Sensitivitas Tinggi</div>
                  <h4 class="guide-card-title">Protein & Seafood</h4>
                  <p class="guide-card-desc">Bahan pokok berbiaya tinggi. Karena memakan porsi COGS terbesar, sedikit fluktuasi harga berdampak masif pada margin.<br><strong style="font-size: 0.73rem; display: block; margin-top: 5px; color: var(--color-text-tertiary);">*Waspada >5% | Kritis >8%</strong></p>
                </div>
              </div>
              <div class="guide-card teal">
                <div class="guide-card-icon">🥬</div>
                <div class="guide-card-content">
                  <div class="guide-card-label">Fluktuasi Musiman</div>
                  <h4 class="guide-card-title">Sayur & Bumbu</h4>
                  <p class="guide-card-desc">Hasil bumi bergantung musim dan cuaca harian. Batas sengaja dilonggarkan agar tim tidak terjebak pada fluktuasi harian wajar.<br><strong style="font-size: 0.73rem; display: block; margin-top: 5px; color: var(--color-text-tertiary);">*Waspada >15% | Kritis >25%</strong></p>
                </div>
              </div>
              <div class="guide-card blue">
                <div class="guide-card-icon">🍚</div>
                <div class="guide-card-content">
                  <div class="guide-card-label">Stabilitas Tinggi</div>
                  <h4 class="guide-card-title">Barang Kering & Utilitas</h4>
                  <p class="guide-card-desc">Beras, minyak, dan gas adalah barang pabrikan. Jika harga merangkak naik, ini menandakan inflasi riil yang akan bertahan lama.<br><strong style="font-size: 0.73rem; display: block; margin-top: 5px; color: var(--color-text-tertiary);">*Waspada >8% | Kritis >12%</strong></p>
                </div>
              </div>
              <div class="guide-card red">
                <div class="guide-card-icon">🚨</div>
                <div class="guide-card-content">
                  <div class="guide-card-label">Level Tindakan</div>
                  <h4 class="guide-card-title">Eksekusi Pengadaan</h4>
                  <p class="guide-card-desc"><strong>Waspada (⚠️):</strong> Mulai pantau harian dan hubungi supplier lapis kedua. <br><strong>Kritis (🚨):</strong> Segera evaluasi resep atau putuskan negosiasi kontrak paksa.<br><strong style="font-size: 0.73rem; display: block; margin-top: 5px; color: var(--color-text-tertiary);">*Diukur vs. harga patokan dasar (baseline).</strong></p>
                </div>
              </div>
            </div>
          </div>
        </details>
      </div>
      </div>
    </Tab>

    <Tab label="🤝 Kinerja & Risiko Supplier">
      <div style="padding: 12px 0px;">
      
      <!-- Chart: Risiko Ketergantungan -->
      <div class="section-head tight" style="margin-bottom: 12px;">
        <div>
          <div class="section-eyebrow">⚠️ Risiko Ketergantungan</div>
          <h3 class="section-title">Peta Konsentrasi Pengeluaran (Spend Dependency)</h3>
          <p class="section-copy">Visualisasi proporsi uang belanja yang dialokasikan ke masing-masing supplier. Ketergantungan ekstrem (&gt;50% ke satu supplier) berisiko mematikan operasional jika supplier tersebut bermasalah.</p>
        </div>
      </div>
      <div style="margin-bottom: 8px;">
        <ECharts 
          config={{
            tooltip: { 
              trigger: 'item',
              formatter: function(params) {
                let val = params.data.spend_30d;
                return params.name + ':<br/><b>Rp ' + val.toLocaleString('id-ID') + '</b> (' + params.percent + '%)';
              }
            },
            dataset: { 
              source: supplier_data 
            },
            series: [
              {
                name: 'Total Belanja',
                type: 'pie',
                radius: ['40%', '70%'],
                itemStyle: {
                  borderRadius: 8,
                  borderColor: '#fff',
                  borderWidth: 2
                },
                label: {
                  show: true,
                  formatter: '{b}\n{d}%'
                },
                encode: { 
                  itemName: 'supplier_name', 
                  value: 'spend_30d' 
                }
              }
            ]
          }}
        />
      </div>
      <div class="chart-insight-bar" style="margin-bottom: 32px;">
        📌 <strong>Mitigasi Risiko:</strong> Jika satu pihak mendominasi kue pengeluaran, siapkan <i>supplier</i> lapis kedua agar pasokan tidak lumpuh total saat pihak utama mengalami gagal panen/kirim.
      </div>

      <!-- Table: Rapor Supplier -->
      <div class="section-head tight" style="margin-bottom: 12px;">
        <div>
          <div class="section-eyebrow">📋 Rapor Supplier (30 Hari Terakhir)</div>
          <h3 class="section-title">Evaluasi Kinerja Pengiriman Pemasok</h3>
          <p class="section-copy">Peringkat supplier berdasarkan ketepatan waktu (On-Time), kuantitas utuh (In-Full), dan kecacatan barang (Defect Rate).</p>
        </div>
      </div>
      <PremiumTable 
        data={supplier_data}
        rowColor={(row) => row.grade === 'A' ? 'rgba(5, 150, 105, 0.15)' : row.grade === 'C' ? 'rgba(239, 68, 68, 0.15)' : null}
        columns={[
          { key: 'supplier_name', title: 'Nama Supplier' },
          { key: 'category', title: 'Kategori' },
          { key: 'on_time_str', title: 'Tepat Waktu' },
          { key: 'in_full_str', title: 'Pesanan Utuh' },
          { key: 'defect_pct', title: 'Defect Rate' },
          { key: 'spend_30d', title: 'Total Belanja (30 Hari)', type: 'currency' },
          { key: 'status_evaluasi', title: 'Status' }
        ]}
      />
      <div class="chart-insight-bar" style="margin-top: 16px;">
        📌 <strong>Tindak Lanjut Evaluasi:</strong> Status "Evaluasi" menandakan supplier ini lebih sering merugikan dapur dibanding membantu. Segera berikan teguran keras atau mulai kurangi proporsi belanja (Spend) ke mereka.
      </div>

      <div style="margin-top: 24px;">
        <details class="guide-acc" style="margin-bottom:24px;">
          <summary>💡 Cara membaca rapor kinerja supplier</summary>
          <div class="guide-body">
            <p style="margin-top: 4px; margin-bottom: 16px; font-weight: 500; color: var(--color-text-secondary);">
              Status kinerja ditentukan dari kombinasi tiga metrik utama: Ketepatan Waktu pengiriman (On-Time), Keutuhan Pesanan (In-Full), dan tingkat barang yang ditolak/rusak (Defect Rate).
            </p>
            <div class="guide-grid" style="grid-template-columns: repeat(2, minmax(0, 1fr));">
              <div class="guide-card blue">
                <div class="guide-card-icon">🌟</div>
                <div class="guide-card-content">
                  <div class="guide-card-label">Kinerja Optimal</div>
                  <h4 class="guide-card-title">Sangat Baik (A)</h4>
                  <p class="guide-card-desc">Pengiriman nyaris sempurna. Cocok dijadikan prioritas utama untuk belanja skala besar.<br><strong style="font-size: 0.73rem; display: block; margin-top: 5px; color: var(--color-text-tertiary);">*Tepat Waktu &gt;95% | Pesanan Utuh &gt;95% | Defect &lt;1%</strong></p>
                </div>
              </div>
              <div class="guide-card teal">
                <div class="guide-card-icon">👍</div>
                <div class="guide-card-content">
                  <div class="guide-card-label">Kinerja Toleransi</div>
                  <h4 class="guide-card-title">Baik (B)</h4>
                  <p class="guide-card-desc">Berada di zona tengah. Ada insiden namun dapur masih aman. Lakukan pembinaan (briefing) secara berkala.<br><strong style="font-size: 0.73rem; display: block; margin-top: 5px; color: var(--color-text-tertiary);">*Belum memenuhi syarat A, namun bebas dari syarat kritis C.</strong></p>
                </div>
              </div>
              <div class="guide-card red">
                <div class="guide-card-icon">🚩</div>
                <div class="guide-card-content">
                  <div class="guide-card-label">Kinerja Kritis</div>
                  <h4 class="guide-card-title">Evaluasi (C)</h4>
                  <p class="guide-card-desc"><strong>Satu saja</strong> metrik meleset melewati batas ini, supplier akan langsung jatuh ke status Evaluasi.<br><strong style="font-size: 0.73rem; display: block; margin-top: 5px; color: var(--color-text-tertiary);">*Tepat Waktu &lt;90% ATAU Utuh &lt;95% ATAU Defect &gt;3%</strong></p>
                </div>
              </div>
              <div class="guide-card orange">
                <div class="guide-card-icon">🛑</div>
                <div class="guide-card-content">
                  <div class="guide-card-label">Tindakan Lanjut</div>
                  <h4 class="guide-card-title">Pemutusan Kontrak</h4>
                  <p class="guide-card-desc">Jika status Evaluasi bertahan selama 2 bulan berturut-turut, kurangi alokasi belanjanya dan pindahkan ke supplier lapis kedua.<br><strong style="font-size: 0.73rem; display: block; margin-top: 5px; color: var(--color-text-tertiary);">*Gunakan data ini untuk negosiasi termin bayar.</strong></p>
                </div>
              </div>
            </div>
          </div>
        </details>
      </div>

      <!-- Table: Watchlist 60 Hari -->
      <div class="section-head tight" style="margin-top: 32px; margin-bottom: 12px;">
        <div>
          <div class="section-eyebrow">🛑 Daftar Pengawasan Khusus (Watchlist 60 Hari)</div>
          <h3 class="section-title">Rekomendasi Pemutusan Kontrak</h3>
          <p class="section-copy">Menyoroti <i>supplier</i> yang menunjukkan kinerja buruk dalam 2 bulan terakhir.</p>
        </div>
      </div>
      
      <PremiumTable 
        data={supplier_watchlist}
        rowColor={(row) => row.curr_month_grade.includes('C') && row.prev_month_grade.includes('C') ? 'rgba(239, 68, 68, 0.15)' : 'rgba(245, 158, 11, 0.15)'}
        columns={[
          { key: 'supplier_name', title: 'Nama Supplier' },
          { key: 'prev_month_grade', title: 'Bulan Lalu (Mei)' },
          { key: 'curr_month_grade', title: 'Bulan Ini (Juni)' },
          { key: 'rekomendasi', title: 'Rekomendasi Sistem' }
        ]}
      />

      </div>
    </Tab>

  </Tabs>
</div>

<style>
  .action-empty {
    padding: 60px 20px;
    text-align: center;
    background: var(--color-background-secondary);
    border: 1px dashed var(--color-border-tertiary);
    border-radius: 12px;
  }
  .action-empty .title {
    font-size: 20px;
    font-weight: 700;
    color: var(--color-text-primary);
    margin-bottom: 8px;
  }
  .action-empty .subtitle {
    color: var(--color-text-secondary);
  }

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
</style>

{:else}
  <GlobalLoading />
{/if}
