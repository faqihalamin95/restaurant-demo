# Blueprint Desain Final Dashboard Restoran

Tujuan dokumen ini: mengunci gambaran akhir dashboard sebelum coding dilanjutkan. Prinsip utamanya bukan memilih antara simple atau complete analyst, tapi membagi kedalaman analisis menjadi tiga lapis:

1. **L1 Executive Cockpit**: jawaban 10 detik. Apa statusnya, apa penyebab utama, apa tindakan berikutnya.
2. **L2 Diagnostic View**: chart dan tabel inti untuk membuktikan diagnosis.
3. **L3 Analyst Detail**: definisi, metodologi, tabel panjang, dan caveat di accordion atau tab khusus.

Dengan struktur ini, halaman tetap simple untuk owner/manager, tapi tetap lengkap untuk analyst.

## Temuan Umum dari Project Saat Ini

| Area | Evidence Saat Ini | Penilaian | Arahan Final |
|---|---|---:|---|
| Beranda | `pages/index.md` sudah 3701 baris dan menarik finance, branch, menu, member, pegawai, inventory, peak hours dalam satu page. | 6/10 | Jadikan command center, bukan mini versi lengkap semua page. Kurangi chart detail, tampilkan status lintas area dan action queue. |
| Laporan Keuangan | `pages/01-laporan-keuangan.md` punya custom style, period strip, hero, KPI grid, signal cards, section cards. | 9/10 | Jadikan standar UI untuk page lain. Hanya rapikan copy dan kurangi emoji jika ingin lebih enterprise. |
| Performa Cabang | `pages/02-branch-performance.md` punya cockpit, tab view, period switch, matriks, deep dive, strategy, action. | 8/10 | Kuat tapi terlalu padat. Pertahankan sebagai halaman analyst paling lengkap, rapikan navigasi dan kurangi repetisi. |
| Inventori | `pages/03-inventori-stok.md` sudah mengarah ke cockpit dengan tab overview/overstock/supplier/performance/action. | 8/10 | Pertahankan model workflow. Perjelas hubungan stok, harga supplier, dan biaya bahan. |
| Peak Hours | `pages/04-peak-hours.md` sudah punya tab jam/hari/volatilitas/musiman dan executive banner. | 8/10 | Kuat sebagai demand planning page. Tambahkan action queue lintas operasional di akhir setiap view. |
| Menu Performance | `pages/05-menu-performance.md` masih report-style: BigValue, heading, chart, tabel. Sudah ada spec rework khusus. | 5/10 | Rework jadi Menu Portfolio Cockpit. Ini prioritas berikutnya. |
| Member Behavior | `pages/06-member-behavior.md` masih report-style 90 hari dengan tier, cohort, churn. | 5/10 | Rework jadi Loyalty & Retention Cockpit. Fokus ke aktivasi, value, retensi, churn queue. |
| Employee Performance | `pages/07-employee-performance.md` masih report-style 30 hari dengan absensi, shift, overtime, role, revenue/hour. | 5/10 | Rework jadi Workforce Cockpit. Fokus ke coverage risk, attendance risk, productivity, coaching queue. |
| Panduan | `pages/00-panduan.md` menjelaskan chart, tabel, mobile, peta halaman, glosarium. | 7/10 | Jadikan onboarding ringkas. Tambahkan "cara mengambil keputusan" berdasarkan status sehat/waspada/kritis. |

## Sistem UI Final

Gunakan pola halaman `01-laporan-keuangan.md` sebagai desain dasar:

- Hide `.over-container`.
- Wrapper page per domain: `.finance-page`, `.branch-page`, `.inv-page`, `.menu-page`, `.member-page`, `.workforce-page`.
- `ButtonGroup` untuk horizon waktu atau view.
- `period-strip` untuk membandingkan Kemarin / 7 Hari / 30 Hari, atau MTD / 30 Hari / 90 Hari.
- Hero cockpit dengan status, headline diagnosis, dan next action.
- KPI grid maksimal 4 kartu per view.
- Signal cards maksimal 3 kartu: sehat, risiko, fokus tindakan.
- Section card untuk chart/tabel inti.
- Detail panjang masuk ke accordion.
- Action queue selalu ada di bagian bawah atau tab khusus.

Standar visual:

- Gunakan status yang konsisten: `sehat`, `waspada`, `kritis`, `neutral`.
- Gunakan warna semantic dari theme: positive, warning, negative, info.
- Hindari inline style baru. Page lama boleh bertahap dimigrasi ke class lokal.
- Jangan membuat semua halaman sama padatnya. Cabang dan Inventory boleh paling dalam; Beranda dan Menu harus lebih cepat discan.

## Page 00 - Panduan

**Peran final**: onboarding dan kamus keputusan, bukan dokumentasi panjang.

Evidence:

- Sudah ada peta halaman dan glosarium di `pages/00-panduan.md`.
- Sudah menjelaskan chart, tabel, dan mobile.

Desain final:

1. Header singkat: "Mulai dari Beranda, lalu masuk ke halaman detail saat ada alarm."
2. Tiga cara membaca dashboard:
   - Status: Sehat / Waspada / Kritis.
   - Horizon: Kemarin untuk anomali, 7 hari untuk operasional, 30/90 hari untuk struktur.
   - Action queue: urutan kerja harian.
3. Peta halaman dashboard.
4. Glosarium bisnis.
5. Caveat data: data demo, tanggal max dari dataset, bukan real-time.

UI:

- Gunakan card grid ringan untuk "cara membaca".
- Peta halaman boleh tabel, tapi tambahkan kolom "dipakai saat".
- Hindari terlalu banyak contoh chart, karena user utama butuh orientasi cepat.

## Page Index - Ringkasan Performa Bisnis

**Peran final**: command center lintas fungsi. Bukan tempat analisis lengkap.

Evidence:

- `pages/index.md` berisi query lintas area sampai ribuan baris.
- Sudah ada `ButtonGroup name=period`.
- Banyak section memakai `BigValue`, `details`, dan link ke halaman lengkap.

Masalah desain:

- Terlalu banyak domain dalam satu scroll.
- Setiap domain mencoba menjelaskan metodologi sendiri.
- Beranda jadi terasa seperti kumpulan mini-report, bukan dashboard eksekutif.

Desain final:

1. Executive health hero:
   - Status bisnis keseluruhan.
   - Tanggal data terakhir.
   - 1 diagnosis utama: margin, demand, menu, stok, member, atau workforce.
2. Period switch: Kemarin / 7 Hari / 30 Hari.
3. Cross-domain score strip:
   - Keuangan.
   - Cabang.
   - Menu.
   - Inventori.
   - Jam sibuk.
   - Member.
   - Pegawai.
4. Action queue lintas area:
   - Urut berdasarkan severity.
   - Setiap item punya domain, alasan, dampak, link ke page detail.
5. Domain tiles:
   - Maksimal 3 KPI per domain.
   - 1 micro insight.
   - 1 link "lihat detail".
6. Analyst appendix:
   - Definisi KPI dan threshold masuk accordion.

UI:

- Ganti kumpulan BigValue panjang menjadi `domain-health-grid`.
- Gunakan `action-card` untuk daftar prioritas.
- Setiap domain tile harus berakhir dengan next click yang jelas.

Yang sebaiknya tidak ada:

- Tabel panjang.
- Chart detail per domain.
- Penjelasan threshold berulang di setiap periode.

## Page 01 - Laporan Keuangan

**Peran final**: kesehatan finansial, margin, dan struktur biaya.

Evidence:

- Sudah menggunakan style block komprehensif, `.finance-page`, `.period-strip`, `.hero`, `.kpi-grid`, `.signal-grid`, `.section-card`.
- Sudah punya `ButtonGroup name=period` dengan Bulan Ini / 30 Hari / 90 Hari.
- Sudah punya query health overview seperti `fin_operational_overview`.

Penilaian:

- Ini page paling matang dan sebaiknya menjadi template.
- Narasi sudah decision-oriented.
- Risiko hanya terlalu panjang dan terlalu banyak variasi UI kecil.

Desain final:

1. Period strip: MTD / 30 Hari / 90 Hari.
2. Hero: margin status, pressure point biaya, tindakan utama.
3. KPI grid:
   - Gross revenue.
   - Net revenue.
   - Net margin.
   - Total biaya.
4. Signal cards:
   - Apa yang sehat.
   - Biaya yang menekan.
   - Risiko jika dibiarkan.
5. Breakdown biaya:
   - Bahan.
   - SDM.
   - Operasional.
6. Trend margin.
7. Operational overview.
8. Methodology accordion.

UI:

- Pertahankan gaya sekarang.
- Jadikan semua page lain mengikuti class pattern page ini.
- Jika ingin lebih profesional, kurangi emoji di label besar tapi pertahankan status color.

## Page 02 - Performa Cabang

**Peran final**: manajemen portofolio cabang, bukan ringkasan total bisnis.

Evidence:

- Sudah punya guide, `ButtonGroup name=view`, `ButtonGroup name=period`, `period-strip`, cockpit score, signal cards, matriks revenue vs margin, deep dive, strategi, action.
- File sangat besar, 2124 baris.

Penilaian:

- Analitiknya kuat.
- UI sudah mendekati final.
- Tantangan utamanya adalah beban kognitif, bukan kekurangan fitur.

Desain final:

Views:

1. Ringkasan:
   - Portfolio Health Cockpit.
   - Period strip.
   - Signal cards: margin, demand vs baseline, concentration.
   - Ranking cabang.
   - Matrix revenue vs margin.
2. Pertumbuhan:
   - Momentum WoW.
   - Daily divergence.
   - Monthly trajectory.
3. Profitabilitas:
   - Gross vs net.
   - Cost breakdown.
   - Margin audit 90 hari.
4. Deep Dive:
   - Branch selector.
   - Branch scorecard.
   - trend, cost, order mix.
5. Strategi:
   - Role classification: strategic asset, scale-up, margin optimization, turnaround.
   - Expansion/turnaround recommendations.
6. Pusat Aksi:
   - Prioritized action queue per cabang.

UI:

- Pertahankan tab view.
- Setiap view harus punya satu hero/section intro saja.
- Pindahkan definisi panjang ke accordion global.
- Jangan tampilkan semua chart di overview.

## Page 03 - Inventori Stok

**Peran final**: kontrol pengadaan, waste, dan tekanan harga bahan.

Evidence:

- Sudah punya `inv_health_overview`, `ButtonGroup name=view`, `ButtonGroup name=period`, period strip, cockpit, overstock/supplier/performance/action.
- Sudah ada panduan cara membaca rasio beli/pakai.

Penilaian:

- Struktur workflow sudah benar.
- Cocok menjadi halaman operasional yang action-heavy.
- Perlu memastikan istilah inventory tidak bercampur terlalu jauh dengan financial margin, karena margin final sudah di page 01.

Desain final:

Views:

1. Ringkasan:
   - Inventory Health Cockpit.
   - Rasio beli/pakai.
   - Biaya bahan dari revenue.
   - Variasi harga supplier.
2. Overstock:
   - Item/category dengan pembelian jauh di atas pemakaian.
   - Risiko modal kerja dan waste.
3. Supplier:
   - Item dengan harga naik dari baseline.
   - Tren harga mingguan.
4. Performa:
   - Usage vs purchase by branch/category.
   - Volatilitas pemakaian.
5. Pusat Aksi:
   - Stop/reduce purchase.
   - Renegotiate supplier.
   - Validate stock drain.

UI:

- Gunakan cockpit score sebagai anchor.
- Tampilkan progress/threshold untuk rasio dan price variance.
- Detail item masuk tabel searchable.

## Page 04 - Peak Hours

**Peran final**: demand planning untuk staf, bahan, dan jam operasional.

Evidence:

- Sudah punya `ButtonGroup name=view`: jam, hari, volatilitas, musiman.
- Sudah memakai executive banner dan recommendation block.
- Query mencakup hourly trend, prediksi besok, day-of-week, volatility, monthly/quarterly trend.

Penilaian:

- Sudah kuat dari sisi story dan tindakan.
- Tidak perlu period switch terlalu banyak, karena analisis utamanya memang 30 hari dan seasonal.

Desain final:

Views:

1. Jam Sibuk:
   - Peak demand share.
   - Demand surge.
   - Critical staffing window.
   - Prediksi besok.
2. Hari Ramai:
   - Busiest/quietest day.
   - Weekend share.
   - Roster recommendation.
3. Volatilitas:
   - Cabang/hari yang demand-nya tidak stabil.
   - Risiko staffing dan prep bahan.
4. Musiman:
   - Monthly dan quarterly pattern.
   - Planning kalender promo/kapasitas.

UI:

- Pertahankan executive banner.
- Tambahkan compact action queue pada akhir setiap view.
- Gunakan chart hanya untuk membuktikan pola, bukan memenuhi halaman.

## Page 05 - Performa Menu

**Peran final**: Menu Portfolio Cockpit.

Evidence:

- Current page masih report-style dengan `BigValue`, alert inline, `BarChart`, `ScatterPlot`, `DataTable`.
- Sudah ada dokumen `PAGE_05_MENU_PERFORMANCE_REWORK_DESIGN.md` yang menargetkan rework ke cockpit style page 01.
- Current content sudah punya top volume, top revenue, category/price tier, branch hero menu, menu engineering, WoW, declining trend.

Masalah desain:

- Jawaban strategis muncul terlambat.
- Menu engineering terlalu bawah.
- Belum ada health query pusat.
- Belum ada period switch.
- Belum ada action queue.

Desain final:

1. Period switch: Kemarin / 7 Hari / 30 Hari.
2. Period strip:
   - Status portfolio menu.
   - Top menu contribution.
   - Declining item count.
3. Hero:
   - "Portfolio menu sehat/waspada/kritis".
   - Penyebab utama: konsentrasi revenue, banyak menu turun, gap volume vs revenue, atau menu aktif terlalu banyak.
4. KPI grid:
   - Total revenue menu.
   - Total qty sold.
   - Menu aktif.
   - Top menu revenue share.
5. Signal cards:
   - Menu andalan.
   - Menu under-monetized.
   - Menu turun.
6. Menu Portfolio Map:
   - Scatter volume vs revenue.
   - Kuadran: Primadona, Misteri, Pekerja Keras, Lemah.
7. Revenue Drivers:
   - Top by revenue.
   - Top by volume.
   - Overlap analysis.
8. Category and Price Tier Mix:
   - Kategori.
   - Segmen harga.
   - Risiko terlalu berat pada satu kategori.
9. Branch Playbook:
   - Menu andalan per cabang.
   - Menu yang turun per cabang.
10. Trend and Declining Menus:
   - WoW.
   - 90-day decline.
11. Action Queue:
   - Jaga stok menu andalan.
   - Promo menu mystery.
   - Bundling/price review untuk pekerja keras.
   - Reformulasi/hapus menu lemah.

UI:

- Ikuti class page 01 dengan prefix `.menu-`.
- Menu engineering harus naik ke bagian awal.
- Gunakan classification cards untuk definisi kuadran.
- Tabel panjang hanya di section akhir atau accordion.

## Page 06 - Member Behavior

**Peran final**: Loyalty & Retention Cockpit.

Evidence:

- Current page memakai 90 hari sebagai horizon utama.
- Sudah punya tier spending, trend, top member, tier per kota, cohort, churn risk.
- Masih report-style dengan BigValue dan alert inline.

Masalah desain:

- Fokus belum jelas: acquisition, loyalty, value, atau churn.
- Cohort penting tapi berat untuk audience non-analyst.
- Churn risk muncul terlalu bawah padahal paling action-oriented.

Desain final:

1. Period switch: 30 Hari / 90 Hari / Cohort.
2. Hero:
   - "Program member aktif/sehat/berisiko".
   - Diagnosis: kontribusi order, AOV, frekuensi, atau churn.
3. KPI grid:
   - Member aktif.
   - Order dari member.
   - AOV member.
   - Repeat frequency.
4. Signal cards:
   - Value tier terbaik.
   - Tier melemah.
   - Churn risk.
5. Tier Economics:
   - Belanja per tier.
   - AOV/frequency per tier.
   - Contribution vs member count.
6. Retention Queue:
   - Gold churn risk.
   - Silver/Bronze win-back.
   - Member high value yang mulai turun.
7. Geography:
   - Tier per kota.
   - Kota dengan value tinggi/rendah.
8. Cohort:
   - Masuk tab khusus atau accordion.
   - Jangan menjadi core page bagi manager harian.
9. Top Member:
   - Searchable table.
   - Action label: VIP maintain, win-back, upsell.

UI:

- Buat `.member-page`.
- Gunakan loyalty health score, bukan hanya ringkasan 90 hari.
- Churn queue harus terlihat sebelum cohort.

## Page 07 - Employee Performance

**Peran final**: Workforce Cockpit untuk coverage, disiplin, produktivitas, dan coaching.

Evidence:

- Current page punya absensi, trend, shift, overtime, role, top employee, revenue per hour, attendance problem.
- Masih report-style dan sangat tabel/chart driven.

Masalah desain:

- Terlalu banyak metrik HR bercampur tanpa prioritas tindakan.
- Top revenue employee bisa misleading jika tidak dinormalisasi dengan jam kerja/role/shift.
- Attendance problem muncul bawah, padahal action utama.

Desain final:

1. Period switch: Kemarin / 7 Hari / 30 Hari.
2. Hero:
   - Status workforce: coverage aman, absensi waspada, overtime berat, atau productivity gap.
3. KPI grid:
   - Attendance rate.
   - Late rate.
   - Absent count.
   - Revenue per labor hour atau order per labor hour.
4. Signal cards:
   - Coverage risk.
   - Attendance discipline.
   - Productivity variance.
5. Shift Coverage:
   - Absensi per shift.
   - Shift tersibuk vs staf hadir.
   - Overtime per shift.
6. Productivity:
   - Revenue/hour by role and shift.
   - Top performers normalized.
   - Jangan jadikan total revenue handled sebagai ranking utama tanpa konteks.
7. Coaching Queue:
   - Pegawai absent >= threshold.
   - Late >= threshold.
   - Overtime high.
   - Productivity unusually low/high.
8. Role and Branch Diagnostics:
   - Role-level attendance.
   - Branch-level workforce pressure.
9. Detail tables:
   - Searchable and paginated.

UI:

- Buat `.workforce-page`.
- Gunakan action cards untuk coaching, schedule adjustment, dan overtime audit.
- Pisahkan "people performance" dari "schedule risk" agar tidak terasa menghakimi pegawai tanpa konteks.

## Urutan Pengerjaan yang Disarankan

1. Rework `05-menu-performance.md` karena sudah ada spec dan gap-nya paling jelas.
2. Rework `06-member-behavior.md` menjadi retention cockpit.
3. Rework `07-employee-performance.md` menjadi workforce cockpit.
4. Ringkas `index.md` menjadi command center setelah semua detail page punya final shape.
5. Rapikan `00-panduan.md` terakhir agar sesuai desain final.

## Definisi "Selesai" untuk Setiap Page

Sebuah page dianggap final jika memenuhi semua ini:

- Ada satu pertanyaan utama yang dijawab dalam 10 detik.
- Ada status health yang jelas.
- Ada 3-4 KPI utama, bukan 8-12 KPI datar.
- Ada diagnosis sebab, bukan hanya angka.
- Ada action queue atau next action eksplisit.
- Ada chart/tabel yang membuktikan diagnosis.
- Ada accordion untuk definisi dan caveat.
- Empty state aman sebelum akses `[0]`.
- Mobile tidak bergantung pada tabel lebar sebagai pengalaman utama.

