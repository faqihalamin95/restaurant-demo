# Alasan Skor dan Rekomendasi UI Dashboard Restoran

Dokumen ini menjelaskan alasan di balik skor audit tiap halaman dan rekomendasi desain finalnya. Fokusnya bukan menilai "bagus atau jelek" secara visual saja, tetapi menilai apakah tiap halaman sudah menjawab keputusan bisnis yang tepat, dengan kedalaman yang pas untuk user restoran.

Kesimpulan utama: reasoning awal untuk beranda sudah benar. Beranda memang harus memberi gambaran cepat terhadap semua kondisi bisnis, lalu detailnya dijelaskan per page. Yang perlu diperbaiki bukan tujuannya, tetapi bentuk penyajiannya. Saat ini beranda sudah menjadi gambaran cepat, tetapi sebagian section mulai membawa pola "mini-report" dari page detail: ada KPI, penjelasan KPI, threshold, alert, chart, tabel, lalu link. Itu membuat beranda lebih lengkap, tetapi mengurangi fungsi utamanya sebagai command center.

## Kriteria Penilaian

Skor saya beri berdasarkan 6 aspek:

| Aspek | Pertanyaan Penilaian |
|---|---|
| Kejelasan keputusan | Apakah halaman langsung menjawab keputusan apa yang harus diambil? |
| Hirarki informasi | Apakah yang penting muncul dulu, bukan tenggelam di bawah chart/tabel? |
| Kedalaman analitik | Apakah datanya cukup membuktikan diagnosis tanpa menjadi berlebihan? |
| Konsistensi UI | Apakah pola visualnya konsisten dengan halaman terbaik di project? |
| Actionability | Apakah halaman berakhir pada tindakan, bukan sekadar observasi? |
| Kesiapan final | Apakah halaman sudah dekat dengan bentuk produk final? |

Framework final yang saya sarankan:

1. L1 Executive Cockpit: status, diagnosis, prioritas tindakan.
2. L2 Diagnostic Evidence: chart dan tabel inti yang membuktikan diagnosis.
3. L3 Analyst Detail: definisi, threshold, metodologi, dan tabel panjang di accordion atau tab detail.

## Ringkasan Skor

| Page | Skor | Alasan Singkat |
|---|---:|---|
| Index / Ringkasan | 6/10 | Tujuan benar, tetapi terlalu banyak section meniru mini page detail. |
| 00 Panduan | 7/10 | Sudah informatif, tetapi bisa lebih decision-oriented. |
| 01 Laporan Keuangan | 9/10 | Paling matang; sudah punya cockpit, period strip, KPI grid, signal cards, section cards. |
| 02 Performa Cabang | 8/10 | Sangat kuat secara analitik, tetapi terlalu padat dan perlu penyederhanaan navigasi. |
| 03 Inventori Stok | 8/10 | Sudah jelas sebagai workflow operasional, tinggal perapihan dan fokus. |
| 04 Peak Hours | 8/10 | Story demand planning sudah kuat, perlu action queue yang lebih eksplisit. |
| 05 Performa Menu | 5/10 | Kontennya berguna, tetapi masih report-style dan belum punya hierarchy cockpit. |
| 06 Member Behavior | 5/10 | Analisis ada, tetapi fokus tindakan retensi/churn belum naik ke atas. |
| 07 Employee Performance | 5/10 | Banyak metrik penting, tetapi belum disusun sebagai workforce risk cockpit. |

---

# 1. Index / Ringkasan Performa Bisnis

## Skor: 6/10

## Kenapa Bukan Lebih Rendah?

Karena tujuan dasarnya sudah tepat. Beranda memang harus menjawab:

- Kondisi bisnis sedang sehat, waspada, atau kritis?
- Area mana yang perlu perhatian dulu?
- Apakah masalahnya finance, cabang, menu, inventory, demand, member, atau pegawai?
- Ke mana user harus masuk untuk investigasi detail?

Di `pages/index.md`, sudah ada beberapa fondasi yang benar:

- Ada period switch: `Kemarin`, `7 Hari`, `30 Hari`.
- Ada ringkasan jumlah indikator sehat/perhatian/kritis.
- Ada domain section untuk keuangan, cabang, menu, member, pegawai, inventori, dan jam sibuk.
- Setiap domain punya link ke halaman detail.

Ini sudah sesuai reasoning kamu: "pemberi gambaran cepat terhadap semua kondisi bisnis, baru detailnya dijelaskan per page."

## Kenapa Skornya 6/10?

Karena eksekusinya belum sepenuhnya command center. Beberapa section di beranda terlalu mirip mini-report dari halaman detail.

Contoh pattern saat ini:

1. Section Keuangan menampilkan BigValue untuk gross, net, margin.
2. Lalu ada accordion "Kenapa KPI ini?"
3. Lalu alert margin sehat/waspada/kritis.
4. Lalu accordion "Cara membaca angka ini" berisi definisi, rumus, threshold.
5. Lalu accordion "Lihat detail & chart" berisi bar chart margin cabang dan line chart gross vs net.
6. Lalu link ke halaman lengkap.

Secara individual ini bagus. Masalahnya, pattern ini diulang untuk banyak domain. Akibatnya beranda menjadi panjang, repetitif, dan terasa seperti banyak laporan kecil dalam satu halaman.

## Maksud "Command Center, Bukan Mini-Report Semua Domain"

Command center bukan berarti lebih sedikit informasi. Command center berarti informasi disusun berdasarkan prioritas tindakan, bukan berdasarkan kelengkapan laporan.

### Mini-report

Mini-report menjawab:

- Apa KPI domain ini?
- Apa definisinya?
- Bagaimana threshold-nya?
- Chart pendukungnya apa?
- Tabel detailnya apa?

Ini cocok untuk page detail.

### Command center

Command center menjawab:

- Apa status bisnis sekarang?
- Area mana yang paling berisiko?
- Apa prioritas tindakan hari ini?
- Detail mana yang perlu dibuka?
- Area mana yang tidak perlu dibuka karena aman?

Ini cocok untuk beranda.

## Bedanya Dengan Kondisi Sekarang

| Hal | Sekarang | Rekomendasi |
|---|---|---|
| Struktur | Domain by domain, masing-masing punya mini analisis. | Priority first: status global, action queue, lalu domain tiles. |
| Detail KPI | Banyak definisi dan threshold di tiap domain. | Definisi umum masuk accordion appendix, bukan setiap domain. |
| Chart | Ada chart detail di accordion domain. | Beranda cukup sparkline/small visual jika perlu; chart penuh di page detail. |
| Tindakan | Ada alert, tapi belum menjadi daftar prioritas lintas domain. | Buat action queue yang mengurutkan masalah dari paling urgent. |
| Tujuan klik | Link detail ada, tapi setelah banyak konten. | Setiap domain tile punya CTA jelas sejak awal. |

## Konten Final yang Seharusnya Ada di Index

### 1. Global Business Health Hero

Isi:

- Tanggal data terakhir.
- Periode aktif: Kemarin / 7 Hari / 30 Hari.
- Status global: Sehat / Waspada / Kritis.
- Diagnosis utama 1 kalimat.
- Next action utama.

Contoh copy:

> Bisnis 7 hari terakhir masuk zona waspada. Margin masih aman, tetapi portofolio menu terlalu bergantung pada 1 menu dan inventory mulai menunjukkan pembelian di atas pemakaian.

UI:

- Hero besar dengan status color.
- Sisi kanan berisi 2-3 angka ringkas:
  - jumlah indikator kritis,
  - jumlah indikator perhatian,
  - area paling urgent.

### 2. Cross-Domain Health Strip

Isi tile:

- Keuangan: Net margin.
- Cabang: jumlah cabang turun / gap cabang.
- Menu: top menu concentration / active menu rate.
- Inventory: ratio beli/pakai / price variance.
- Peak Hours: peak demand share / critical window.
- Member: member order contribution / churn risk.
- Pegawai: attendance rate / late rate.

UI:

- Grid 7 tile ringkas.
- Setiap tile punya:
  - domain,
  - status badge,
  - 1 angka utama,
  - 1 micro diagnosis,
  - link kecil "lihat".

Tidak perlu chart besar di sini.

### 3. Action Queue Lintas Domain

Ini bagian paling penting untuk command center.

Isi:

| Priority | Domain | Masalah | Kenapa penting | Aksi | Link |
|---|---|---|---|---|---|
| Kritis | Inventory | Rasio beli/pakai 1.8x | Modal kerja tertahan dan risiko waste | Review pembelian item top overstock | Inventori |
| Waspada | Menu | 45% revenue dari satu menu | Risiko dependency | Cek menu engineering dan stok menu andalan | Menu |
| Waspada | Pegawai | Late rate naik | Risiko service lambat saat rush | Cek shift dan coaching queue | Pegawai |

UI:

- Action cards, bukan tabel biasa.
- Card berisi:
  - severity,
  - domain,
  - diagnosis,
  - impact,
  - recommended action,
  - button/link ke page detail.

### 4. Domain Snapshot Cards

Setelah action queue, baru tampilkan snapshot per domain.

Setiap domain maksimal:

- 3 KPI.
- 1 diagnosis.
- 1 reason singkat.
- 1 link detail.

Contoh untuk Keuangan:

- KPI: Gross revenue, net margin, cost pressure.
- Diagnosis: "Margin sehat, tekanan utama bahan masih dalam batas."
- Link: "Buka Laporan Keuangan."

Contoh untuk Menu:

- KPI: Menu terlaris, share menu terlaris, menu aktif.
- Diagnosis: "Menu aktif cukup sehat, tetapi kontribusi top menu mulai tinggi."
- Link: "Buka Performa Menu."

Yang tidak perlu di domain snapshot:

- Rumus KPI.
- Threshold table.
- Chart detail.
- Tabel detail.

### 5. Analyst Appendix

Isi:

- Definisi KPI.
- Threshold sehat/waspada/kritis.
- Caveat data.

UI:

- Accordion di paling bawah:
  - "Cara membaca status bisnis"
  - "Definisi KPI"
  - "Caveat data demo"

## Wireframe Index Final

```text
[Period Switch: Kemarin | 7 Hari | 30 Hari]

[Global Health Hero]
Status: Waspada
Diagnosis utama
Next action
Data terakhir

[Cross-Domain Health Strip]
Keuangan | Cabang | Menu | Inventory | Jam Sibuk | Member | Pegawai

[Action Queue]
1. Inventory - overstock risk - buka Inventori
2. Menu - dependency risk - buka Menu
3. Pegawai - late risk - buka Pegawai

[Domain Snapshot Grid]
Keuangan card
Cabang card
Menu card
Inventory card
Peak Hours card
Member card
Pegawai card

[Analyst Appendix accordions]
Definisi KPI
Threshold status
Caveat data
```

## Rekomendasi UI Detail untuk Index

### Class yang sebaiknya dibuat

- `.home-page`
- `.global-hero`
- `.global-hero-status`
- `.global-hero-side`
- `.health-strip`
- `.health-tile`
- `.health-tile.sehat`
- `.health-tile.waspada`
- `.health-tile.kritis`
- `.action-queue`
- `.action-card`
- `.domain-snapshot-grid`
- `.domain-card`
- `.domain-card-kpis`
- `.domain-card-link`
- `.appendix-accordion`

### Bentuk health tile

Isi tiap tile:

```text
Keuangan
[Sehat]
Net Margin 17.2%
Biaya bahan terkendali
```

Ukuran:

- Desktop: 7 tile bisa jadi grid 4 + 3 atau horizontal scroll.
- Tablet: 2-3 kolom.
- Mobile: 1 kolom atau horizontal swipe.

### Bentuk action card

Isi:

```text
[Kritis] Inventory
Pembelian 1.8x lebih tinggi dari pemakaian
Dampak: modal kerja tertahan dan risiko waste
Aksi: audit item overstock sebelum PO berikutnya
[Buka Inventori]
```

### Kenapa Ini Lebih Baik

Beranda tetap memberi gambaran cepat semua kondisi bisnis, tetapi user tidak dipaksa membaca semua domain secara linear. Mereka langsung tahu:

1. Apakah bisnis aman?
2. Apa yang harus dikerjakan dulu?
3. Domain mana yang perlu dibuka?
4. Domain mana yang bisa dilewati hari ini?

Itu inti command center.

---

# 2. Page 00 - Panduan

## Skor: 7/10

## Evidence Saat Ini

`pages/00-panduan.md` sudah punya:

- Penjelasan chart.
- Penjelasan tabel.
- Catatan mobile.
- Peta halaman dashboard.
- Glosarium istilah.

Ini cukup bagus sebagai onboarding.

## Kenapa Skornya 7/10?

Karena panduan masih lebih banyak menjelaskan cara membaca komponen UI, bukan cara mengambil keputusan dari dashboard.

User restoran biasanya tidak hanya butuh tahu "chart bisa ditap" atau "tabel bisa digeser". Mereka butuh tahu:

- Mulai dari halaman mana?
- Kalau status kritis, harus klik apa?
- Kapan pakai data kemarin vs 7 hari vs 30 hari?
- Apa beda alert harian dengan masalah struktural?

## Rekomendasi Konten Final

Panduan sebaiknya diubah menjadi:

1. Mulai dari Beranda.
2. Baca status: sehat, waspada, kritis.
3. Pilih horizon:
   - Kemarin untuk anomali operasional.
   - 7 Hari untuk keputusan mingguan.
   - 30 Hari untuk pola struktural.
   - 90 Hari untuk member/cohort/seasonality.
4. Ikuti action queue.
5. Masuk ke page detail hanya untuk domain yang bermasalah.
6. Gunakan glosarium jika istilah belum jelas.

## Rekomendasi UI

- Tambahkan "Decision Flow" di atas:

```text
Beranda -> Action Queue -> Page Detail -> Action
```

- Peta halaman jangan hanya "pertanyaan yang dijawab", tambahkan "dipakai saat":

| Halaman | Dipakai Saat |
|---|---|
| Laporan Keuangan | Margin turun, biaya naik, atau owner ingin cek profit. |
| Performa Cabang | Ada cabang melemah, gap besar, atau perlu benchmark cabang. |
| Inventori | Bahan mahal, pembelian berlebih, atau rasio beli/pakai aneh. |

---

# 3. Page 01 - Laporan Keuangan

## Skor: 9/10

## Evidence Saat Ini

`pages/01-laporan-keuangan.md` sudah punya:

- Local style block yang matang.
- `.finance-page`.
- `ButtonGroup name=period` dengan Bulan Ini, 30 Hari, 90 Hari.
- Period strip.
- Hero cockpit.
- KPI grid.
- Signal cards.
- Section cards.
- Cost breakdown dengan progress/threshold.
- Query health overview seperti `fin_operational_overview`.

## Kenapa Skornya Tinggi?

Karena page ini sudah menjawab keputusan dengan jelas:

- Apakah bisnis profitable?
- Margin sehat atau kritis?
- Biaya mana yang menekan margin?
- Apakah masalahnya sementara atau struktural?
- Apa yang harus dicek dulu?

Ini bukan sekadar laporan angka. Ada diagnosis.

## Kenapa Tidak 10/10?

Karena ada potensi page menjadi terlalu panjang dan gaya visualnya masih bisa distandardisasi untuk semua page.

Beberapa hal yang perlu dijaga:

- Jangan terlalu banyak variasi card baru.
- Jangan terlalu banyak emoji pada heading besar jika ingin terlihat lebih profesional.
- Pastikan semua section punya peran jelas: KPI, diagnosis, proof, action.

## Rekomendasi Final

Pertahankan struktur:

1. Period switch.
2. Period strip.
3. Hero margin health.
4. KPI grid.
5. Signal cards.
6. Cost breakdown.
7. Trend margin.
8. Operational overview.
9. Methodology accordion.

## Detail UI

Page 01 harus menjadi design reference.

Yang perlu distandardisasi untuk page lain:

- `.period-strip`
- `.period-pill`
- `.hero`
- `.kpi-grid`
- `.signal-grid`
- `.section-card`
- `.acc-strategic`

Rekomendasi copy:

- Pakai bahasa diagnosis, bukan hanya status.
- Contoh bagus:
  - "Tekanan terbesar datang dari biaya bahan."
  - "Margin 30 hari masih sehat, tetapi MTD mulai turun."

---

# 4. Page 02 - Performa Cabang

## Skor: 8/10

## Evidence Saat Ini

`pages/02-branch-performance.md` sudah punya:

- `ButtonGroup name=view`: Ringkasan, Pertumbuhan, Profitabilitas, Deep Dive, Strategi, Pusat Aksi.
- `ButtonGroup name=period`: Kemarin, 7 Hari, 30 Hari.
- Portfolio Health Cockpit.
- Signal cards.
- Ranking cabang.
- Scatter/matrix revenue vs margin.
- Branch selector untuk deep dive.
- Strategy/action sections.

## Kenapa Skornya Tinggi?

Karena page ini sudah punya konsep yang kuat: manajemen portofolio cabang. Ia tidak hanya menjawab "cabang mana paling besar", tapi juga:

- Cabang mana efisien?
- Cabang mana tumbuh?
- Cabang mana perlu turnaround?
- Cabang mana bisa jadi benchmark?
- Apakah portofolio terlalu bergantung pada satu cabang?

Ini analyst-grade dan cocok untuk owner/operator multi-branch.

## Kenapa Tidak 9 atau 10?

Karena page ini sudah sangat padat. Risiko utamanya bukan kurang data, tetapi user kelelahan sebelum sampai ke action.

Masalah yang mungkin terasa:

- Terlalu banyak tab.
- Terlalu banyak section sama-sama penting.
- Overview bisa terasa seperti deep dive.
- Definisi dan narasi panjang bisa memperlambat scan.

## Rekomendasi Konten Final

### View Ringkasan

Harus menjawab:

- Apakah portofolio cabang sehat?
- Cabang mana top performer?
- Cabang mana warning?
- Apakah gap antar cabang terlalu besar?

Konten:

- Period strip.
- Portfolio cockpit.
- 3 signal cards:
  - Margin portofolio.
  - Demand vs baseline.
  - Konsentrasi cabang.
- Ranking cabang.
- Matrix revenue vs margin.

### View Pertumbuhan

Harus menjawab:

- Cabang mana naik/turun?
- Apakah penurunan hanya harian atau tren?
- Apakah cabang bergerak bersama atau divergen?

Konten:

- WoW ranking.
- Daily revenue line per branch.
- Monthly stacked trend.

### View Profitabilitas

Harus menjawab:

- Cabang mana omzet besar tapi laba bocor?
- Komponen biaya apa yang menekan cabang?

Konten:

- Gross vs net.
- Cost breakdown.
- Margin audit 90 hari.

### View Deep Dive

Harus menjawab:

- Apa diagnosis untuk cabang tertentu?
- Apa tindakan spesifik untuk cabang itu?

Konten:

- Branch selector.
- Branch scorecard.
- Trend.
- Cost.
- Operational signals.

### View Strategi

Harus menjawab:

- Cabang mana strategic asset?
- Cabang mana scale-up?
- Cabang mana turnaround?

Konten:

- Classification table/cards.
- Strategic recommendation.

### View Pusat Aksi

Harus menjawab:

- Apa 5 tindakan cabang terpenting minggu ini?

Konten:

- Action cards by severity.
- Branch, issue, evidence, action, owner.

## Rekomendasi UI

- Pertahankan tab, tapi buat tab label lebih pendek jika terlalu penuh.
- Overview jangan menampilkan terlalu banyak chart.
- Gunakan matrix sebagai visual utama karena sangat kuat.
- Tabel panjang taruh di bawah atau accordion.
- Action queue harus bisa dibaca tanpa membuka semua tab.

---

# 5. Page 03 - Inventori Stok

## Skor: 8/10

## Evidence Saat Ini

`pages/03-inventori-stok.md` sudah punya:

- `ButtonGroup name=view`: Ringkasan, Overstock, Supplier, Performa, Pusat Aksi.
- `ButtonGroup name=period`.
- `inv_health_overview`.
- Period strip.
- Inventory Health Cockpit.
- Rasio beli/pakai.
- Harga supplier.
- Risk tables.

## Kenapa Skornya Tinggi?

Karena page ini sudah action-oriented. Inventory memang harus diperlakukan sebagai workflow:

- Apakah beli terlalu banyak?
- Apakah pemakaian lebih besar dari pembelian?
- Apakah harga supplier naik?
- Item mana yang harus diaudit?
- Apa yang harus dilakukan sebelum pembelian berikutnya?

Struktur tab-nya cocok dengan cara kerja operasional.

## Kenapa Tidak 9?

Karena masih perlu merapikan hubungan antara inventory dan finance.

Inventory page harus fokus ke:

- pembelian,
- pemakaian,
- stok terdrain,
- overstock,
- supplier price variance.

Sedangkan margin final tetap di page Finance. Jangan sampai user bingung apakah masalah bahan harus dibaca di finance atau inventory.

## Rekomendasi Konten Final

### Ringkasan

- Inventory health score.
- Rasio beli/pakai.
- Biaya bahan dari revenue.
- Price variance.
- Diagnosis utama.

### Overstock

- Item/kategori dengan pembelian di atas pemakaian.
- Cabang penyebab.
- Risiko waste.
- Action: tahan PO, cek stok fisik, ubah reorder point.

### Supplier

- Item dengan harga naik.
- Supplier/category price trend.
- Action: renegosiasi, cari alternatif supplier, cek kualitas.

### Performa

- Usage vs purchase by branch.
- Volatility.
- Kategori paling boros.

### Pusat Aksi

- Top 5 inventory actions:
  - stop/reduce purchase,
  - renegotiate supplier,
  - validate stock drain,
  - adjust prep forecast,
  - audit waste.

## Rekomendasi UI

- Gunakan gauge/score untuk health.
- Gunakan progress bar untuk rasio beli/pakai:
  - <0.8x: stok terdrain,
  - 0.8-1.2x: ideal,
  - 1.2-1.5x: waspada,
  - >1.5x: kritis.
- Gunakan action cards, bukan hanya tabel.
- Tabel item tetap searchable.

---

# 6. Page 04 - Peak Hours

## Skor: 8/10

## Evidence Saat Ini

`pages/04-peak-hours.md` sudah punya:

- `ButtonGroup name=view`: Jam Sibuk, Hari Ramai, Volatilitas, Musiman.
- Executive banner.
- KPI cards.
- Demand interpretation.
- Recommendation block.
- Prediksi besok.
- Monthly/quarterly trend.

## Kenapa Skornya Tinggi?

Karena page ini sudah punya narrative yang kuat:

- Kapan demand paling tinggi?
- Apakah ada satu peak atau dua peak?
- Window staffing kritis jam berapa?
- Hari apa paling ramai?
- Bagaimana prediksi besok?

Ini langsung relevan untuk operasional restoran.

## Kenapa Tidak 9?

Karena action queue belum cukup konsisten di seluruh view. Rekomendasi sudah ada, tetapi belum diformat sebagai daftar tindakan yang bisa dieksekusi.

## Rekomendasi Konten Final

### View Jam Sibuk

- Peak demand share.
- Demand surge.
- Critical staffing window.
- Bimodal detection.
- Prediksi besok.
- Staffing/prep action.

### View Hari Ramai

- Busiest day.
- Quietest day.
- Weekend share.
- Roster recommendation.

### View Volatilitas

- Cabang/hari dengan demand tidak stabil.
- Risiko overstaff/understaff.
- Action: flexible staffing, backup prep.

### View Musiman

- Monthly trend.
- Quarterly trend.
- Seasonal planning.
- Promo/capacity calendar.

## Rekomendasi UI

- Pertahankan executive banner.
- Tambahkan "ops action strip":
  - staf,
  - bahan,
  - promo,
  - jam operasional.
- Buat prediksi besok lebih prominent, karena ini actionable.
- Chart detail cukup 1-2 per view.

---

# 7. Page 05 - Performa Menu

## Skor: 5/10

## Evidence Saat Ini

`pages/05-menu-performance.md` punya konten analitik yang berguna:

- Ringkasan 30 hari.
- Menu terlaris.
- Menu penggerak revenue.
- Menu menurun dan naik.
- Top by volume.
- Top by revenue.
- Category summary.
- Price tier summary.
- Menu reference.
- Andalan per cabang.
- Menu engineering.
- WoW table.
- Declining trend.

Ini artinya datanya sudah ada. Masalahnya bukan kekurangan konten, tetapi hierarchy.

## Kenapa Skornya 5/10?

Karena halaman masih terasa seperti report:

- BigValue di atas.
- Alert inline.
- Heading per bagian.
- Chart.
- Tabel.
- Menu engineering muncul setelah beberapa section.

Padahal secara strategis, menu engineering justru salah satu insight paling penting. Owner ingin tahu:

- Menu mana tulang punggung bisnis?
- Menu mana laku tapi uangnya kecil?
- Menu mana mahal/revenue tinggi tapi jarang dibeli?
- Menu mana harus dipromosikan, dibundling, dinaikkan harga, atau dihapus?

Pertanyaan ini harus muncul di atas, bukan di tengah/bawah.

## Rekomendasi Konten Final

Jadikan page ini "Menu Portfolio Cockpit".

### 1. Period Switch

Kemarin / 7 Hari / 30 Hari.

Kenapa:

- Kemarin: cek operasional dan stok.
- 7 Hari: cek momentum menu.
- 30 Hari: cek portfolio structure.

### 2. Period Strip

Tampilkan:

- Status portfolio menu.
- Share top menu.
- Jumlah menu aktif.
- Jumlah menu declining.

### 3. Hero Cockpit

Hero harus menjawab:

- Portfolio menu sehat atau berisiko?
- Risiko utamanya apa?
- Tindakan utama apa?

Contoh diagnosis:

- "Portfolio menu sehat, revenue tidak terlalu bergantung pada satu item."
- "Portfolio menu waspada, 42% revenue datang dari satu menu."
- "Menu terlalu gemuk, kurang dari 50% item terjual konsisten."
- "Banyak menu menurun WoW, perlu cek promo, stok, atau relevansi menu."

### 4. KPI Grid

Maksimal 4:

- Total menu revenue.
- Total qty sold.
- Menu aktif.
- Top menu revenue share.

### 5. Signal Cards

3 cards:

- Menu andalan: jaga stok/kualitas.
- Under-monetized menu: laku tapi revenue kecil.
- Declining menu: perlu intervensi.

### 6. Menu Portfolio Map

Ini harus naik ke awal.

Kuadran:

- Primadona: volume tinggi, revenue tinggi.
- Misteri: volume rendah, revenue tinggi.
- Pekerja Keras: volume tinggi, revenue rendah.
- Lemah: volume rendah, revenue rendah.

UI:

- ScatterPlot.
- Classification cards di atas/bawah scatter.
- Tooltip menu name.
- Tabel detail di bawah.

### 7. Revenue Drivers

Isi:

- Top by revenue.
- Top by volume.
- Overlap analysis.

Pertanyaan:

- Apakah menu yang paling laku juga paling menghasilkan?
- Kalau tidak, kenapa?

### 8. Category and Price Tier Mix

Isi:

- Contribution by category.
- Contribution by price tier.
- Risiko kategori terlalu dominan.

### 9. Branch Playbook

Isi:

- Menu andalan per cabang.
- Menu declining per cabang.
- Cabang yang perlu push menu tertentu.

### 10. Trend and Declining Menus

Isi:

- WoW change.
- 90-day declining trend.
- Menu yang turun konsisten.

### 11. Action Queue

Isi action:

| Klasifikasi | Aksi |
|---|---|
| Primadona | Jaga stok, kualitas, dan speed service. |
| Misteri | Promosikan, rekomendasikan oleh staf, taruh lebih visible. |
| Pekerja Keras | Review harga, bundling, atau portion cost. |
| Lemah | Reformulasi, seasonal promo, atau hapus. |
| Declining | Cek stok, kualitas, promo, kompetitor, atau fatigue. |

## Rekomendasi UI Detail

Class:

- `.menu-page`
- `.menu-hero`
- `.menu-kpi-grid`
- `.menu-signal-grid`
- `.classification-grid`
- `.classification-card`
- `.portfolio-map`
- `.revenue-driver-grid`
- `.branch-playbook`
- `.menu-action-queue`

Layout final:

```text
[Period Switch]
[Period Strip]
[Hero: menu portfolio status]
[KPI Grid]
[Signal Cards]
[Portfolio Map + Classification Cards]
[Revenue Drivers]
[Category/Price Mix]
[Branch Playbook]
[Declining Trend]
[Action Queue]
[Methodology Accordion]
```

---

# 8. Page 06 - Member Behavior

## Skor: 5/10

## Evidence Saat Ini

`pages/06-member-behavior.md` sudah punya:

- 90-day summary.
- Member active.
- Total order member.
- Total spend.
- AOV.
- AOV vs previous period.
- Churn count.
- Tier spending.
- Trend belanja.
- Top member.
- Tier per kota.
- Cohort.
- Churn risk table.

## Kenapa Skornya 5/10?

Karena banyak analisis penting, tetapi belum disusun berdasarkan tindakan retensi.

Masalah utamanya:

- Churn risk terlalu bawah.
- Cohort cukup berat dan cocok untuk analyst, bukan pembuka halaman.
- Fokus belum dipilih: apakah halaman ini untuk loyalty health, tier economics, atau churn prevention?

Untuk restoran, member page paling actionable jika menjawab:

- Apakah program member benar-benar aktif?
- Tier mana yang paling valuable?
- Siapa yang hampir churn?
- Siapa yang harus dihubungi dulu?
- Apakah member makin sering datang atau makin jarang?

## Rekomendasi Konten Final

Jadikan "Loyalty & Retention Cockpit".

### 1. Hero

Status:

- Sehat: contribution member tinggi, frequency stabil, churn rendah.
- Waspada: contribution sedang, AOV/frequency turun, churn mulai naik.
- Kritis: high value members mulai churn.

### 2. KPI Grid

- Member aktif.
- Order dari member (%).
- AOV member.
- Repeat frequency.

### 3. Signal Cards

- Tier paling valuable.
- Frekuensi membaik/menurun.
- Churn risk.

### 4. Retention Queue

Harus naik ke atas.

Isi:

- Gold churn risk.
- Silver churn risk.
- High spender inactive.
- Member dengan spend turun.

UI:

- Action card per segment:
  - segment,
  - jumlah member,
  - value at risk,
  - action.

### 5. Tier Economics

Isi:

- Spend by tier.
- Frequency by tier.
- AOV by tier.
- Member count vs revenue contribution.

### 6. Top Member

Tabel searchable:

- Member.
- Tier.
- Total spend.
- Frequency.
- Recency.
- Suggested action.

### 7. Geography

Isi:

- City/tier contribution.
- Kota dengan member high value.

### 8. Cohort

Masuk tab atau accordion analyst.

Kenapa:

- Penting untuk analisis jangka panjang.
- Tidak harus dibaca setiap hari.

## Rekomendasi UI

Class:

- `.member-page`
- `.loyalty-hero`
- `.retention-queue`
- `.tier-economics-grid`
- `.churn-card`
- `.member-action-card`

Layout:

```text
[Period Switch: 30H | 90H | Cohort]
[Hero: loyalty health]
[KPI Grid]
[Signal Cards]
[Retention Queue]
[Tier Economics]
[Top Member]
[Geography]
[Cohort Accordion/Tab]
```

---

# 9. Page 07 - Employee Performance

## Skor: 5/10

## Evidence Saat Ini

`pages/07-employee-performance.md` sudah punya:

- 30-day summary.
- Total pegawai.
- Order handled.
- Revenue handled.
- AOV.
- Attendance alerts.
- Attendance distribution.
- Attendance trend.
- Shift performance.
- Overtime.
- Role performance.
- Top employees by revenue.
- Revenue per hour.
- Attendance problem table.

## Kenapa Skornya 5/10?

Karena data banyak, tetapi hierarchy tindakan belum kuat.

Untuk workforce, owner/manager biasanya perlu tahu:

- Apakah shift kekurangan orang?
- Apakah absensi/keterlambatan mulai mengganggu operasi?
- Apakah overtime terlalu tinggi?
- Apakah produktivitas rendah karena orangnya, role-nya, atau shift-nya?
- Siapa yang butuh coaching atau schedule adjustment?

Saat ini page masih lebih seperti HR/ops report. Perlu diubah menjadi workforce cockpit.

## Risiko Desain Saat Ini

Top employee by revenue bisa misleading jika tidak dinormalisasi:

- Pegawai di shift ramai otomatis menang.
- Pegawai role tertentu mungkin lebih sering handle transaksi.
- Pegawai full-time lebih tinggi dari part-time.

Karena itu `revenue per hour` lebih cocok menjadi metric utama daripada total revenue handled.

## Rekomendasi Konten Final

Jadikan "Workforce Cockpit".

### 1. Period Switch

Kemarin / 7 Hari / 30 Hari.

### 2. Hero

Status:

- Coverage aman.
- Attendance waspada.
- Overtime berat.
- Productivity gap.

### 3. KPI Grid

- Attendance rate.
- Late rate.
- Absent count.
- Revenue per labor hour atau order per labor hour.

### 4. Signal Cards

- Coverage risk.
- Attendance discipline.
- Productivity variance.

### 5. Shift Coverage

Isi:

- Absensi per shift.
- Shift tersibuk.
- Coverage pressure.
- Overtime by shift.

### 6. Productivity

Isi:

- Revenue/hour by role.
- Revenue/hour by shift.
- Top performers normalized.
- Low productivity outliers.

### 7. Coaching Queue

Harus naik.

Isi:

- Pegawai absent >= threshold.
- Late >= threshold.
- Overtime high.
- Productivity low.

Penting: wording harus hati-hati. Ini bukan menyalahkan pegawai. Banyak masalah produktivitas berasal dari jadwal, role, atau demand window.

### 8. Role and Branch Diagnostics

Isi:

- Role attendance.
- Branch workforce pressure.
- Overtime by branch.

## Rekomendasi UI

Class:

- `.workforce-page`
- `.workforce-hero`
- `.coverage-grid`
- `.shift-pressure-card`
- `.coaching-queue`
- `.employee-action-card`

Layout:

```text
[Period Switch]
[Hero: workforce status]
[KPI Grid]
[Signal Cards]
[Shift Coverage]
[Productivity Normalized]
[Coaching Queue]
[Role/Branch Diagnostics]
[Detail Tables]
```

---

# Prioritas Rework

## Prioritas 1: Page 05 Menu

Alasan:

- Gap paling jelas.
- Sudah ada dokumen spec rework.
- Data sudah cukup.
- Akan menjadi contoh untuk rework page 06 dan 07.

## Prioritas 2: Page 06 Member

Alasan:

- Banyak insight bagus, tetapi churn/retention action belum naik.
- Mudah direstruktur menjadi cockpit.

## Prioritas 3: Page 07 Employee

Alasan:

- Banyak metrik tetapi perlu framing agar tidak terasa sekadar HR report.
- Perlu normalisasi produktivitas.

## Prioritas 4: Index

Alasan:

- Index sebaiknya diringkas setelah page detail final.
- Kalau page detail belum final, index akan terus ikut berubah.

## Prioritas 5: Panduan

Alasan:

- Panduan harus mencerminkan arsitektur final.
- Lebih aman dirapikan setelah struktur page selesai.

---

# Definisi Final: Simple Tetapi Complete

Dashboard ini bisa tetap simple dan complete kalau setiap page punya batas yang jelas.

Simple bukan berarti sedikit data. Simple berarti user tahu apa yang harus dilihat dulu.

Complete bukan berarti semua hal tampil sekaligus. Complete berarti detail tetap tersedia saat dibutuhkan.

Aturan praktis:

1. Halaman pertama setiap domain harus menjawab keputusan dalam 10 detik.
2. Chart hanya dipakai jika membantu membuktikan diagnosis.
3. Tabel panjang tidak boleh menjadi pengalaman utama.
4. Definisi KPI tidak perlu diulang di setiap domain snapshot.
5. Setiap halaman harus punya action queue atau next action.
6. Beranda mengurutkan prioritas lintas domain; page detail membuktikan dan menjelaskan masalah domain tersebut.

