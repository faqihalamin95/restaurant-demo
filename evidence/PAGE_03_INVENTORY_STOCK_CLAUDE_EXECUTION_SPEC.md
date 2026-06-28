# Page 03 - Inventori & Stok Claude Execution Spec

Dokumen ini adalah instruksi teknis untuk Claude. Tujuannya: rework page `Inventori & Stok` menjadi dashboard inventory control berbasis stok aktual, bukan lagi analisis proxy dari pembelian vs pemakaian saja.

Target file utama:

- `evidence/pages/03-inventori-stok.md`

Target data layer pendukung:

- `dbt_restaurant/models/staging/stg_inventory_transactions.sql`
- `dbt_restaurant/models/marts/mart_inventory_stok.sql`
- `dbt_restaurant/models/staging/schema.yml`
- `dbt_restaurant/models/staging/sources.yml`

## 1. Konteks Produk

Dashboard ini adalah bagian dari sistem laporan restoran. User akhir kemungkinan owner/operator restoran yang ingin menjawab pertanyaan operasional dengan cepat:

- Stok apa yang hampir habis?
- Barang apa yang terlalu banyak tertahan di gudang?
- Cabang mana yang inventory-nya tidak sehat?
- Bahan mana yang harga supplier-nya mulai menekan margin?
- Aksi apa yang harus dilakukan minggu ini?

Filosofi page ini:

> Jadikan page Inventori & Stok sebagai Inventory Control Center.

Bukan mini-report semua angka inventory. Setiap subpage harus punya fokus jelas, beban baca ringan, dan langsung mengarah ke keputusan.

## 2. Perubahan Konsep Wajib

Versi lama page ini membaca inventory terutama dari:

- `purchase_cost`
- `usage_cost`
- `purchase_cost / usage_cost`
- `estimated_stock_delta`
- price variance supplier

Itu berguna saat belum ada stok aktual, tapi sekarang data generator sudah menyediakan:

- `stock_on_hand`
- `stock_status`
- `days_remaining`

Karena itu page harus bergeser dari:

> "Analisis arus pembelian vs pemakaian"

menjadi:

> "Snapshot stok aktual + movement analysis + action board"

`purchase_cost / usage_cost` tetap boleh dipakai, tapi hanya sebagai konteks pola pengadaan, bukan definisi utama overstock.

## 3. Data Contract Wajib

Pastikan mart `main_marts.mart_inventory_stok` mengekspos kolom berikut:

- `txn_date`
- `branch_id`
- `branch_name`
- `inventory_id`
- `item_name`
- `category`
- `unit`
- `base_unit_cost`
- `cost_tier`
- `usage_qty`
- `purchase_qty`
- `usage_cost`
- `purchase_cost`
- `total_cost`
- `avg_unit_cost`
- `stock_on_hand`
- `stock_status`
- `days_remaining`
- `stock_value`
- `estimated_stock_delta`

### 3.1 Staging Model

Di `stg_inventory_transactions.sql`, tambahkan field:

```sql
cast(stock_on_hand as decimal(18,2))      as stock_on_hand,
stock_status,
cast(days_remaining as decimal(18,2))     as days_remaining
```

### 3.2 Mart Model

Di `mart_inventory_stok.sql`, agregasi harian tetap grain:

> `txn_date`, `branch_id`, `inventory_id`

Tambahkan:

```sql
max(t.stock_on_hand) as stock_on_hand,
max(t.days_remaining) as days_remaining,
case
    when min(t.days_remaining) < 3 then 'low'
    when max(t.days_remaining) > 14 then 'overstock'
    else 'ok'
end as stock_status
```

Lalu di joined output:

```sql
d.stock_on_hand,
d.stock_status,
d.days_remaining,
round(
    d.stock_on_hand * coalesce(nullif(d.avg_unit_cost, 0), c.base_unit_cost),
    0
) as stock_value
```

Catatan:

- `stock_on_hand` adalah saldo fisik snapshot dari generator.
- `days_remaining` adalah estimasi coverage berdasarkan rata-rata pemakaian.
- `estimated_stock_delta` boleh tetap ada, tapi copy UI jangan menyebut ini sebagai stok utama.

### 3.3 Schema Tests

Tambahkan test untuk:

- `stock_on_hand` not null
- `days_remaining` not null
- `stock_status` accepted values: `ok`, `low`, `overstock`

## 4. Struktur Subpage Wajib

Gunakan tab:

1. `Ringkasan`
2. `Reorder`
3. `Overstock`
4. `Supplier`
5. `Cabang`
6. `Pusat Aksi`

Jangan pakai tab lama `Performa` sebagai nama utama. Ganti menjadi `Cabang`, karena subpage itu tujuannya membaca kesehatan inventory per cabang.

## 5. Prinsip UI Wajib

Ikuti standar yang sudah mulai dipakai di page `Laporan Keuangan` dan `Performa Cabang`:

- Section pendek, jelas, dan tidak terasa seperti laporan panjang.
- Ringkasan tidak boleh menjadi mini-report semua metrik.
- Gunakan card seperlunya, jangan menumpuk terlalu banyak kartu besar.
- Accordion metodologi diletakkan dekat section yang dijelaskan, bukan semua ditumpuk di paling bawah.
- Font heading section jangan terlalu besar.
- Warna harus restrained, mirip page laporan keuangan:
  - hijau untuk sehat
  - kuning/oranye untuk waspada
  - merah untuk kritis
  - biru/teal untuk info/operasional
- Jangan pakai emoji berlebihan di button/tab. Label tab cukup teks bersih.
- Jangan pakai copy lama yang bilang "bukan stok fisik".
- Jangan pakai skor kesehatan besar seperti dashboard gamified. Lebih baik direct indicators: low stock, overstock value, price alert.

Penting untuk Svelte/Evidence:

- Di dalam HTML, escape tanda `<=` menjadi `&lt;=`.
- Jangan menulis `< 3` mentah di text HTML jika berpotensi dibaca sebagai tag. Gunakan `di bawah 3` atau `&lt; 3`.

## 6. Query Evidence yang Dibutuhkan

Semua query di page Evidence membaca dari:

```sql
restaurant.inventory_stok
```

### 6.1 `inv_dates`

Tujuan: label tanggal.

Output minimal:

- `tgl_akhir`
- `tgl_7d_awal`
- `tgl_30d_awal`
- `tgl_90d_awal`

### 6.2 `inv_inventory_overview`

Tujuan: data utama subpage Ringkasan.

Gunakan latest snapshot:

```sql
WITH max_d AS (
    SELECT MAX(txn_date)::DATE AS d
    FROM restaurant.inventory_stok
),
latest AS (
    SELECT *
    FROM restaurant.inventory_stok CROSS JOIN max_d
    WHERE txn_date = d
)
```

Output:

- `stock_value`
- `low_points`
- `low_items`
- `overstock_points`
- `overstock_items`
- `overstock_value`
- `overstock_value_pct`
- `min_days_remaining`
- `total_items`
- `total_branches`
- `usage_cost_7d`
- `purchase_cost_7d`
- `usage_cost_30d`
- `purchase_cost_30d`
- `purchase_usage_ratio_30d`
- `avg_price_variance_pct`
- `price_alert_items`
- `health_status`
- `diagnosis`

Logic status:

- `Kritis` jika ada low stock.
- `Waspada` jika overstock value > 25% dari total stock value, ada price alert, atau ratio beli/pakai 30H > 1.3.
- `Sehat` jika tidak ada masalah utama.

### 6.3 `inv_reorder_items`

Tujuan: daftar item yang harus dibeli/ditangani.

Filter:

- `stock_status = 'low'`
- atau `days_remaining <= 5`

Output:

- `branch_name`
- `item_name`
- `category`
- `unit`
- `stock_on_hand`
- `days_remaining`
- `stock_value`
- `avg_daily_usage`
- `usage_cost_30d`
- `reorder_status`

Status:

- `Kritis Hari Ini` jika `days_remaining < 1.5`
- `Reorder Sekarang` jika `days_remaining < 3`
- `Pantau Minggu Ini` sisanya

### 6.4 `inv_overstock_items`

Tujuan: daftar item yang overstock berdasarkan stok fisik.

Filter:

- `stock_status = 'overstock'`
- atau `days_remaining > 14`

Output:

- `branch_name`
- `item_name`
- `category`
- `unit`
- `stock_on_hand`
- `days_remaining`
- `stock_value`
- `estimated_idle_value`
- `purchase_usage_ratio_30d`
- `overstock_status`

Formula `estimated_idle_value`:

```sql
round(
    stock_value * greatest(days_remaining - 14, 0) / nullif(days_remaining, 0),
    0
) as estimated_idle_value
```

Status:

- `Sangat Berlebih` jika coverage >= 30 hari
- `Berlebih Tinggi` jika coverage >= 21 hari
- `Berlebih` jika coverage > 14 hari

### 6.5 `inv_transfer_candidates`

Tujuan: saran transfer antar cabang.

Join:

- low stock item
- dengan overstock item yang sama di cabang lain

Output:

- `item_name`
- `category`
- `branch_need`
- `need_days`
- `branch_source`
- `source_days`
- `source_stock`
- `source_stock_value`

### 6.6 `inv_branch_inventory`

Tujuan: kesehatan inventory per cabang.

Output:

- `branch_name`
- `stock_value`
- `low_points`
- `overstock_points`
- `overstock_value`
- `min_days_remaining`
- `usage_cost_7d`
- `purchase_cost_7d`
- `usage_cost_30d`
- `purchase_cost_30d`
- `purchase_usage_ratio_30d`
- `branch_status`

Logic:

- `Kritis` jika ada low stock.
- `Waspada` jika overstock value > 25% nilai stok cabang atau ratio 30H > 1.3.
- `Sehat` jika tidak ada sinyal besar.

### 6.7 `inv_supplier_alerts`

Tujuan: prioritas negosiasi supplier.

Filter:

- price variance > 10%

Output:

- `item_name`
- `category`
- `base_unit_cost`
- `avg_unit_cost`
- `price_variance_pct`
- `usage_cost_30d`
- `estimated_price_impact`
- `severity`

Severity:

- `Kritis` jika price variance >= 20%
- `Waspada` jika price variance > 10%

### 6.8 `inv_price_trend_weekly`

Tujuan: chart harga mingguan 90H.

Output:

- `minggu`
- `item_name`
- `category`
- `harga_rata_beli`
- `harga_dasar`

### 6.9 `inv_volatility_summary`

Tujuan: ranking volatilitas harga.

Output:

- `item_name`
- `category`
- `harga_min`
- `harga_maks`
- `harga_rata`
- `harga_dasar`
- `volatilitas_pct`
- `selisih_vs_dasar_pct`
- `kategori_volatilitas`

### 6.10 `inv_stock_value_by_category`

Tujuan: chart komposisi stok per kategori.

Output:

- `category`
- `stock_value`
- `overstock_value`
- `low_points`
- `avg_days_remaining`

### 6.11 `inv_action_board`

Tujuan: pusat aksi yang langsung bisa dieksekusi.

Prioritas urutan:

1. Reorder low stock
2. Transfer antar cabang
3. Tahan pembelian overstock
4. Renegosiasi supplier

Output:

- `priority_group`
- `severity_class`
- `action_type`
- `action_title`
- `action_detail`
- `action_window`
- `impact_value`

## 7. Detail UI per Subpage

### 7.1 Ringkasan

Tujuan:

> Client bisa menilai inventory sehat atau tidak dalam kurang dari 30 detik.

Konten atas:

- Hero compact:
  - label: `Snapshot Stok Aktual`
  - title: pertanyaan diagnosis inventory
  - copy: jelaskan bahwa stok aktual adalah basis utama, movement 7H/30H untuk konteks
  - status panel kanan: `Sehat`, `Waspada`, atau `Kritis`

KPI cards:

1. `Modal Stok Aktual`
   - value: total `stock_value`
   - meta: nilai barang tersimpan

2. `Risiko Habis`
   - value: jumlah low stock points
   - meta: jumlah item dan minimum days remaining

3. `Modal Tertahan`
   - value: `overstock_value`
   - meta: persentase dari total stok dan jumlah item

4. `Tekanan Harga`
   - value: jumlah item price alert
   - meta: average price variance 30H

Accordion dekat KPI:

Title:

> Kenapa stok aktual dan periode movement dipisah?

Isi:

> Stok aktual membaca posisi hari ini. Movement 7H/30H membaca penyebabnya: pemakaian, pembelian, dan harga supplier.

Lens cards:

- Availability
- Working Capital
- Supplier
- Purchase Discipline

Tambahkan chart:

- `BarChart` nilai stok aktual per kategori

Jangan tampilkan tabel besar di Ringkasan.

### 7.2 Reorder

Tujuan:

> Subpage operasional untuk tahu barang apa yang harus dibeli lebih dulu.

Konten:

- Section header: `Reorder Board`
- Copy: prioritas dari coverage paling pendek
- Accordion metodologi reorder
- 3 priority cards:
  - `Kritis Hari Ini`
  - `Reorder Sekarang`
  - `Pantau Minggu Ini`
- DataTable detail `inv_reorder_items`

Kolom tabel:

- Cabang
- Bahan
- Kategori
- Stok
- Satuan
- Sisa Hari
- Avg Pakai/Hari
- Status

Jika tidak ada data:

- tampilkan empty state positif: tidak ada low stock di snapshot terbaru

Jika ada `inv_transfer_candidates`:

- tampilkan section tambahan `Transfer Antar Cabang`

### 7.3 Overstock

Tujuan:

> Tahu barang mana yang mengikat modal terlalu lama.

Konten:

- Section header: `Overstock Aktual`
- Copy: overstock dihitung dari coverage aktual
- Accordion metodologi overstock
- DataTable `inv_overstock_items`
- Chart grouped `stock_value` vs `overstock_value` per kategori

Kolom tabel:

- Cabang
- Bahan
- Kategori
- Stok
- Satuan
- Coverage Hari
- Nilai Stok
- Estimasi Idle
- Rasio Beli/Pakai 30H
- Status

Catatan penting:

- Jangan mendefinisikan overstock dari `purchase_cost > usage_cost`.
- Ratio beli/pakai hanya supporting evidence.

### 7.4 Supplier

Tujuan:

> Baca tekanan harga bahan baku.

Style:

Gunakan pattern seperti section `Perspektif Strategis` di laporan keuangan:

- Intro section
- Dua lens:
  - `Price Variance - 30H`
  - `Volatility - 90H`

Konten:

- DataTable `inv_supplier_alerts`
- LineChart `inv_price_trend_weekly`
- DataTable `inv_volatility_summary`

Jangan terlalu banyak kartu diagnosis. Supplier sudah cukup jelas dengan table + trend.

### 7.5 Cabang

Tujuan:

> Tahu cabang mana yang inventory-nya sehat, rawan habis, atau menyimpan stok berlebih.

Konten:

- Section header: `Inventory per Cabang`
- Accordion metodologi status cabang
- DataTable `inv_branch_inventory`
- Grouped BarChart pemakaian vs pembelian 30H

Kolom tabel:

- Cabang
- Status
- Nilai Stok
- Low Stock
- Overstock
- Nilai Overstock
- Coverage Min
- Rasio 30H

Jangan buat subpage ini menjadi deepdive item panjang. Deep item sudah ada di Reorder dan Overstock.

### 7.6 Pusat Aksi

Tujuan:

> Mengubah insight menjadi tindakan.

Konten:

- Section header: `Pusat Aksi`
- Copy: urutan aksi dari risiko operasional dulu
- Accordion metodologi prioritas aksi
- Action card list dari `inv_action_board`

Action card harus memuat:

- action type
- action window
- action title
- action detail
- impact value

Contoh copy:

- `Reorder Daging Sapi di Cabang Timur`
- `Transfer Beras Premium: Cabang Pusat ke Cabang Selatan`
- `Tahan pembelian Keju Mozzarella di Cabang Utara`
- `Renegosiasi harga Minyak Goreng`

Jangan buat Pusat Aksi hanya berupa ringkasan metrik. Harus berupa to-do list yang bisa dijalankan.

## 8. Copy yang Harus Dihapus

Hapus semua copy/logic lama yang menyatakan:

- `Bukan Stok Fisik`
- `Dashboard ini menghitung dari data pembelian dan pemakaian - bukan saldo gudang aktual`
- `Untuk mengetahui unit tersisa perlu integrasi POS atau aplikasi stok`

Sekarang sudah ada `stock_on_hand`, jadi copy itu salah.

Ganti menjadi:

> Dashboard ini memakai stock_on_hand sebagai saldo fisik snapshot terbaru dari data warehouse. days_remaining adalah estimasi berbasis rata-rata pemakaian historis, sehingga tetap perlu validasi lapangan untuk item rusak, salah input, atau stok yang belum tercatat.

## 9. Acceptance Criteria

Implementasi dianggap selesai jika:

1. Page `03-inventori-stok.md` build tanpa error Svelte.
2. `npm run sources` berhasil dan `inventory_stok` punya kolom:
   - `stock_on_hand`
   - `stock_status`
   - `days_remaining`
   - `stock_value`
3. `npm run build` berhasil.
4. Tab `Ringkasan`, `Reorder`, `Overstock`, `Supplier`, `Cabang`, dan `Pusat Aksi` muncul.
5. Ringkasan tidak lagi memakai skor besar sebagai pusat UI.
6. Reorder memakai low stock dan `days_remaining`.
7. Overstock memakai `days_remaining > 14` dan `stock_value`.
8. Supplier tetap membaca price variance dan volatility.
9. Cabang membaca status dari low stock, overstock value, dan ratio pembelian 30H.
10. Pusat Aksi menghasilkan rekomendasi konkret, bukan hanya deskripsi metrik.
11. Tidak ada copy lama yang menyebut dashboard tidak memakai stok fisik.
12. Tidak ada error query terkait missing column `stock_status`, `stock_on_hand`, `days_remaining`, atau `stock_value`.

## 10. Validation Commands

Jalankan:

```bash
cd /home/faqih/projects/restaurant-demo/evidence
npm run sources
npm run build
```

Jika `dbt` tersedia, jalankan juga:

```bash
cd /home/faqih/projects/restaurant-demo/dbt_restaurant
dbt run --select stg_inventory_transactions mart_inventory_stok
dbt test --select stg_inventory_transactions
```

Jika `dbt` tidak tersedia, minimal pastikan warehouse DuckDB sudah punya kolom baru:

```bash
duckdb /home/faqih/projects/restaurant-demo/data/warehouse.duckdb -c "describe main_marts.mart_inventory_stok"
```

Sanity check snapshot:

```bash
duckdb /home/faqih/projects/restaurant-demo/data/warehouse.duckdb -c "with d as (select max(txn_date) as max_date from main_marts.mart_inventory_stok) select count(*) as latest_rows, sum(case when stock_status='low' then 1 else 0 end) as latest_low, sum(case when stock_status='overstock' then 1 else 0 end) as latest_overstock, min(days_remaining) as min_days, sum(stock_value) as stock_value from main_marts.mart_inventory_stok, d where txn_date=max_date"
```

## 11. Guardrails

- Jangan ubah page lain.
- Jangan refactor CSS global.
- Jangan ubah generator data kecuali diminta.
- Jangan hapus `estimated_stock_delta`; cukup turunkan perannya.
- Jangan membuat dashboard terlalu berat dengan semua data ditampilkan di Ringkasan.
- Jangan menaruh semua metodologi di satu blok besar paling bawah.
- Jangan memakai skor kompleks yang tidak mudah dijelaskan.
- Jangan menyamakan overstock dengan purchase/usage ratio.

## 12. Final Output yang Diharapkan dari Claude

Claude harus mengembalikan:

1. Ringkasan file yang diubah.
2. Penjelasan singkat perubahan konsep.
3. Hasil validasi command.
4. Catatan jika ada warning build yang bukan berasal dari page inventory.
5. Hal yang masih perlu direfine oleh reviewer.

