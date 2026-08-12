from pathlib import Path
import re

f = Path('/home/faqih/projects/restaurant-demo/evidence_en/pages/02-branch-performance/deepdive.md')
c = f.read_text()

replacements = {
    "Bulan Ini (MTD)": "This Month (MTD)",
    "Pangkas Shift.": "Cut Shift.",
    "Kurangi shift karyawan <em>part-time</em> di jam <em>off-peak</em> dan bekukan rekrutmen baru.": "Reduce <em>part-time</em> employee shifts during <em>off-peak</em> hours and freeze new recruitment.",
    "Pelayanan bisa melambat saat terjadi lonjakan pesanan mendadak.": "Service may slow down during sudden order surges.",
    "Menjaga moral tim dan kualitas layanan tetap prima.": "Maintains team morale and top service quality.",
    "Memerlukan biaya <em>marketing</em> tambahan yang membebani kas.": "Requires additional <em>marketing</em> costs that burden cash.",
    "Perombakan SOP.": "SOP Revamp.",
    "Kurangi ketergantungan pada pramusaji dengan sistem <em>Self-Service</em> atau <em>QR Ordering</em>.": "Reduce dependency on waiters with a <em>Self-Service</em> or <em>QR Ordering</em> system.",
    "Butuh capex awal (investasi sistem) dan merubah <em>customer habit</em>.": "Needs initial capex (system investment) and changes <em>customer habit</em>.",
    "Beban gaji ideal maksimal 30% dari omzet bruto. Memecat karyawan inti berisiko merusak layanan, sehingga pemotongan jam <em>part-time</em> atau efisiensi jam operasional lebih disarankan sebagai langkah pertama.": "Ideal salary burden is maximum 30% of gross revenue. Firing core employees risks damaging service, so cutting <em>part-time</em> hours or operational hour efficiency is recommended as a first step.",
    "Audit Energi.": "Energy Audit.",
    "Buat SOP jam nyala-mati AC/Lampu yang ketat. Evaluation tagihan listrik mingguan.": "Create strict AC/Lighting on-off SOPs. Evaluate weekly electricity bills.",
    "Space Monetization.": "Space Monetization.",
    "Sewakan area kosong ke <em>tenant</em> pelengkap atau manfaatkan dapur sebagai <em>Cloud Kitchen</em>.": "Rent empty areas to complementary <em>tenants</em> or utilize the kitchen as a <em>Cloud Kitchen</em>.",
    "Memakan waktu untuk mencari <em>tenant</em> dan negosiasi.": "Takes time to find <em>tenants</em> and negotiate.",
    "Accept Reality.": "Accept Reality.",
    "Asumsikan ini adalah siklus <em>low-season</em> alami. Turunkan stock harian untuk menghindari <em>food waste</em>.": "Assume this is a natural <em>low-season</em> cycle. Lower daily stock to avoid <em>food waste</em>.",
    "Standarisasi SOP.": "SOP Standardization.",
    "Jadikan SOP dan Manajer location ini sebagai <em>benchmark</em> untuk direplikasi ke location lain.": "Make this location's SOP and Manager a <em>benchmark</em> to replicate to other locations.",
    "Mengangkat performa location lain yang sedang *under-performing*.": "Boosts performance of other *under-performing* locations.",
    "Dapat memecah fokus Manajer Bintang dari location utamanya.": "May divide the Star Manager's focus from their main location.",
    "Bonus Pegawai.": "Employee Bonus.",
    "Pertimbangkan memberikan insentif performa bagi staf di location ini untuk menjaga retensi.": "Consider giving performance incentives for staff in this location to maintain retention.",
    "Menambah beban pengeluaran kas ekstra di akhir bulan.": "Adds extra cash expense burden at the end of the month.",
    "Tambah Kapasitas.": "Add Capacity.",
    "Alihkan fokus ke ekspansi penjualan (tambah kapasitas kursi, jam operasional, pesan antar).": "Shift focus to sales expansion (add seating capacity, operational hours, delivery).",
    "Mendobrak <em>ceiling revenue</em> dan meningkatkan utilitas aset harian.": "Break the <em>revenue ceiling</em> and increase daily asset utility.",
    "Memerlukan injeksi modal (Capex) untuk renovasi/marketing.": "Requires capital injection (Capex) for renovation/marketing.",
    "Rasio di bawah target. Verifikasi konsistensi standar porsi.": "Ratio below target. Verify portion standard consistency.",
    "Rasio efisien. Pertahankan standar resep saat ini.": "Efficient ratio. Maintain current recipe standard.",
    "Proporsi di atas standar. Analysis potensi inefisiensi pengadaan.": "Proportion above standard. Analyze procurement inefficiency potential.",
    "Rasio di bawah target. Pantau potensi kelelahan staf.": "Ratio below target. Monitor potential staff fatigue.",
    "Pengeluaran staf efisien. Pertahankan produktivitas.": "Staff spending efficient. Maintain productivity.",
    "Proporsi meningkat. Tinjau jam lembur dan jadwal staf.": "Proportion increasing. Review overtime hours and staff schedules.",
    "Indikasi inefisiensi. Evaluation struktur tim dan shift.": "Inefficiency indication. Evaluate team structure and shifts.",
    "Rasio meningkat. Periksa tagihan listrik atau utilitas.": "Ratio increasing. Check electricity or utility bills.",
    "Beban operasional tinggi. Segera audit sewa dan utilitas bulanan.": "High operational burden. Audit monthly rent and utilities immediately.",
    "Waktu layanan (serving time) melambat tajam, order error rate spikes, dan staf lama terancam <em>resign</em> karena kelelahan (burnout).": "Service time slows down sharply, order error rate spikes, and veteran staff are threatened to <em>resign</em> due to exhaustion (burnout).",
    "Risiko Ketergantungan: Jika porsi menu Top 5 mendominasi terlalu besar, pastikan ketersediaan bahan baku untuk menu tersebut tidak pernah putus, karena jika kosong, restoran kehilangan mayoritas omzetnya.": "Dependency Risk: If the Top 5 menus dominate too much, ensure raw material availability never breaks, because if empty, the restaurant loses most of its revenue.",
    "Anomali Pergerakan: Perhatikan arah dan panjang batang pada grafik untuk melihat tren persentase. Lalu, cek tabel di sebelahnya untuk memvalidasi apakah persentase tersebut berdampak signifikan secara porsi riil.": "Movement Anomaly: Pay attention to the direction and length of bars on the graph to see percentage trends. Then, check the adjacent table to validate if the percentage has a significant real portion impact.",
    "Analysis Kuartalan: Membantu mengidentifikasi faktor musiman (seasonality) dan stabilitas laba bersih per kuartal secara konsisten.": "Quarterly Analysis: Helps identify seasonal factors (seasonality) and net profit stability per quarter consistently.",
    "Analysis YoY: Memberikan pandangan makro mengenai apakah location ini secara fundamental bertumbuh, stabil, atau mengalami perlambatan dari tahun ke tahun.": "YoY Analysis: Provides a macro view on whether this location is fundamentally growing, stable, or slowing down year over year.",
    "⚠️ Deep Dive Belum Tersedia": "⚠️ Deep Dive Not Available",
    "Location ini belum punya data cukup untuk diagnosis detail": "This location does not have enough data for a detailed diagnosis",
    "Pilih location lain atau cek apakah data revenue, net revenue, dan biaya untuk location ini sudah masuk lengkap pada horizon 30 sampai 90 hari.": "Select another location or check if revenue, net revenue, and cost data for this location are fully entered within the 30 to 90 day horizon.",
    'title="Tahun"': 'title="Year"',
    'title="Omzet (Gross)"': 'title="Gross Revenue"',
    "Statistik Sejarah Location": "Location Historical Statistics",
    "Tanggal Transaksi Pertama": "First Transaction Date",
    "Rata-rata Margin Bersih Historis": "Historical Average Net Margin"
}

for k, v in replacements.items():
    c = c.replace(k, v)

f.write_text(c)
