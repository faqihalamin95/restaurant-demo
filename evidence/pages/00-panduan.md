---
title: Panduan Dashboard
---

<div style="display:flex;justify-content:space-between;align-items:center;background:rgba(128,128,128,0.05);border:1px solid rgba(128,128,128,0.2);padding:12px 20px;border-radius:10px;margin-bottom:24px;">
  <span style="font-size:0.9em;">Sudah familiar dengan dashboard ini?</span>
  <a href="/" style="font-size:0.85em;text-decoration:none;border:1px solid rgba(128,128,128,0.3);padding:6px 14px;border-radius:6px;background:rgba(128,128,128,0.05);">
    Lewati panduan →
  </a>
</div>

_Baca 2 menit dulu — kamu akan jauh lebih mudah baca datanya setelah ini._

---

## Selamat Datang di Dashboard Wekadata

Dashboard ini menampilkan seluruh data bisnis restoranmu dalam satu tempat — revenue, menu, jam sibuk, pegawai, hingga profitabilitas per cabang. Semua diperbarui otomatis setiap pagi.

```sql live_snapshot
SELECT
    SUM(total_revenue)        AS revenue_kemarin,
    SUM(total_orders)         AS order_kemarin,
    COUNT(DISTINCT branch_id) AS cabang_aktif
FROM restaurant.daily_revenue
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.daily_revenue)
```

```sql tgl_update
SELECT
    DAY(MAX(order_date)) || ' ' ||
    CASE MONTH(MAX(order_date))
        WHEN 1 THEN 'Januari' WHEN 2 THEN 'Februari' WHEN 3 THEN 'Maret'
        WHEN 4 THEN 'April' WHEN 5 THEN 'Mei' WHEN 6 THEN 'Juni'
        WHEN 7 THEN 'Juli' WHEN 8 THEN 'Agustus' WHEN 9 THEN 'September'
        WHEN 10 THEN 'Oktober' WHEN 11 THEN 'November' WHEN 12 THEN 'Desember'
    END || ' ' || YEAR(MAX(order_date)) AS tgl
FROM restaurant.daily_revenue
```

<BigValue data={live_snapshot} value="revenue_kemarin" title="Revenue Kemarin (Rp)" fmt="#,##0" />
<BigValue data={live_snapshot} value="order_kemarin"   title="Total Order Kemarin"  fmt="#,##0" />
<BigValue data={live_snapshot} value="cabang_aktif"    title="Cabang Aktif" />

_Data per {tgl_update[0].tgl}. Diperbarui otomatis setiap hari._

---

## Cara Membaca Dashboard Ini

### 📊 1 — Grafik & Chart

<div style="background:rgba(22,163,74,0.08);border-left:4px solid #16a34a;padding:12px 16px;border-radius:0 8px 8px 0;margin:12px 0 20px 0;font-size:0.9em;">

🖱️ <strong>Hover</strong> ke titik atau bar untuk melihat angka detailnya.<br/>
🏷️ <strong>Klik nama</strong> di legend untuk menyembunyikan atau memunculkan data tertentu — berguna kalau mau fokus ke satu cabang saja.<br/>
🔍 <strong>Klik dua kali</strong> nama di legend untuk fokus ke satu data, sembunyikan yang lain sekaligus.

</div>

```sql chart_contoh
SELECT
    order_date,
    branch_name,
    total_revenue
FROM restaurant.daily_revenue
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.daily_revenue) - INTERVAL '13 days'
ORDER BY order_date, branch_name
```

<LineChart
    data={chart_contoh}
    x="order_date"
    y="total_revenue"
    series="branch_name"
    title="Coba: hover ke titik ini, lalu klik nama cabang di legend"
    yFmt="#,##0"
    xAxisTitle="Tanggal"
    yAxisTitle="Revenue (Rp)"
/>

---

### 📋 2 — Tabel Data

<div style="background:rgba(37,99,235,0.08);border-left:4px solid #2563eb;padding:12px 16px;border-radius:0 8px 8px 0;margin:12px 0 20px 0;font-size:0.9em;">

↔️ <strong>Tabel lebar</strong>: geser ke kiri-kanan untuk melihat kolom yang tersembunyi di sisi kanan.<br/>
📄 <strong>Tabel panjang</strong>: gunakan tombol <strong>← →</strong> di pojok kanan bawah tabel untuk pindah halaman.<br/>
🔼 <strong>Klik judul kolom</strong> untuk mengurutkan data dari terbesar ke terkecil atau sebaliknya.

</div>

```sql tabel_contoh
SELECT
    branch_name                                                           AS cabang,
    SUM(total_revenue)                                                    AS total_revenue,
    SUM(total_orders)                                                     AS total_order,
    ROUND(SUM(total_revenue) / NULLIF(SUM(total_orders), 0), 0)          AS avg_order_value,
    SUM(delivery_orders)                                                  AS delivery,
    SUM(dine_in_orders)                                                   AS dine_in,
    SUM(takeaway_orders)                                                  AS takeaway,
    COUNT(DISTINCT order_date)                                            AS hari_aktif
FROM restaurant.daily_revenue
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.daily_revenue) - INTERVAL '30 days'
GROUP BY branch_name
ORDER BY total_revenue DESC
```

<DataTable data={tabel_contoh}>
    <Column id="cabang"          title="Cabang"/>
    <Column id="total_revenue"   title="Revenue (Rp)"               fmt="#,##0"/>
    <Column id="total_order"     title="Total Order"                 fmt="#,##0"/>
    <Column id="avg_order_value" title="Rata-rata Nilai Order (Rp)"  fmt="#,##0"/>
    <Column id="delivery"        title="Delivery"                    fmt="#,##0"/>
    <Column id="dine_in"         title="Dine-in"                     fmt="#,##0"/>
    <Column id="takeaway"        title="Takeaway"                    fmt="#,##0"/>
    <Column id="hari_aktif"      title="Hari Aktif"                  fmt="#,##0"/>
</DataTable>

_👆 Coba klik judul kolom untuk mengurutkan. Di layar kecil, geser tabel ke kanan untuk lihat kolom Delivery, Dine-in, dan Takeaway._

---

### 📱 3 — Di Handphone / Tablet

<div style="background:rgba(245,158,11,0.08);border-left:4px solid #f59e0b;padding:12px 16px;border-radius:0 8px 8px 0;margin:12px 0 20px 0;font-size:0.9em;">

📲 Semua halaman bisa diakses dari HP.<br/>
👆 Grafik bisa di-tap untuk lihat detail angka.<br/>
↔️ Geser tabel dengan jari ke kiri-kanan untuk lihat semua kolom.<br/>
📄 Tombol ← → untuk tabel panjang ada di bawah tabel — scroll ke bawah kalau belum kelihatan.

</div>

---

## Peta Halaman Dashboard

Gunakan **sidebar kiri** (atau ikon menu ☰ di HP) untuk berpindah halaman.

| Halaman | Pertanyaan yang Dijawab |
|---|---|
| 🏠 **Ringkasan** | Gimana kondisi bisnis hari ini secara keseluruhan? |
| 💵 **Laporan Keuangan** | Berapa net revenue dan margin keuntungan per cabang? |
| 🏪 **Performa Cabang** | Cabang mana yang tumbuh, stagnan, atau perlu perhatian? |
| ⏰ **Jam Sibuk** | Kapan pelanggan paling banyak datang? Prediksi besok? |
| 🍽️ **Performa Menu** | Menu apa yang laris, menurun, atau punya potensi tersembunyi? |
| 👥 **Perilaku Member** | Siapa member paling loyal dan siapa yang hampir churn? |
| 👨‍💼 **Performa Pegawai** | Performa dan kehadiran pegawai per shift dan cabang |

---

## Glosarium Istilah

| Istilah | Artinya |
|---|---|
| **Gross Revenue** | Total pendapatan sebelum dikurangi biaya apapun |
| **Net Revenue** | Pendapatan bersih setelah dikurangi biaya bahan, SDM & operasional |
| **Net Margin** | Persentase keuntungan bersih dari total revenue |
| **Rata-rata 7 Hari** | Rata-rata dari 7 hari sebelumnya — baseline perbandingan harian |
| **WoW** | Week-over-Week — perbandingan minggu ini vs minggu lalu |
| **Primadona** | Menu volume tinggi & revenue tinggi — jaga stok dan kualitasnya |
| **Misteri** | Menu revenue tinggi tapi kurang laku — kandidat promo atau rekomendasi staf |
| **Pekerja Keras** | Menu laris tapi revenue kecil — kandidat naik harga atau bundling |
| **Lemah** | Volume & revenue rendah — pertimbangkan hapus atau reformulasi |
| **Churn Risk** | Member yang belum transaksi 21+ hari — perlu program win-back |
| **Puncak Siang** | Jam 11–13, periode order tertinggi siang hari |
| **Puncak Malam** | Jam 17–20, periode order tertinggi malam hari |

---

<div style="text-align:center;margin:40px 0 20px 0;">
  <a href="/" style="display:inline-block;background:#1D9E75;color:white;padding:14px 36px;border-radius:10px;text-decoration:none;font-weight:700;font-size:1.05em;">
    Mulai Eksplorasi Dashboard →
  </a>
  <div style="margin-top:12px;">
    <a href="/" style="font-size:0.85em;color:#94a3b8;text-decoration:none;">
      Lewati panduan, langsung ke dashboard
    </a>
  </div>
</div>

_Dashboard Wekadata diperbarui otomatis setiap pagi._