import os

replacements = {
    "Baris teratas yang disorot menampilkan data kuartal yang": "The highlighted top row displays quarterly data that is",
    "belum selesai": "unfinished",
    "Baris teratas yang disorot menampilkan data tahun berjalan yang": "The highlighted top row displays current year data that is",
    "Segera lakukan audit utilitas dan tekan pengeluaran promosi yang tidak memberikan ROI positif.": "Immediately conduct a utility audit and reduce promotional expenses that do not provide positive ROI.",
    "Visualisasi proporsi uang belanja yang dialokasikan ke masing-masing supplier. Ketergantungan ekstrem (>50% ke satu supplier) berisiko mematikan operasional jika supplier tersebut bermasalah.": "Visualization of the proportion of spending allocated to each supplier. Extreme dependence (>50% to one supplier) risks halting operations if that supplier encounters problems.",
    "Menyoroti": "Highlights",
    "yang menunjukkan kinerja buruk dalam 2 bulan terakhir.": "that shows poor performance in the last 2 months.",
    "karena bersifat": "because it is",
    "harus dibayar meski restoran tidak ada pembeli": "must be paid even if the restaurant has no customers",
    "Bernegosiasi ulang biaya sewa saat bisnis tertekan adalah praktik korporat yang wajar.": "Renegotiating rent when business is pressured is a normal corporate practice.",
    "Untuk menjaga akurasi perbandingan, seluruh perhitungan kuartal dan grafik musiman di halaman ini hanya memproses bulan operasional yang sudah selesai penuh. Data bulan berjalan sengaja": "To maintain comparison accuracy, all quarterly calculations and seasonal charts on this page only process fully completed operational months. Current month data is intentionally",
    "dikecualikan": "excluded",
    "agar tidak memicu bias tren yang dapat merusak akurasi rekomendasi strategi.": "so as not to trigger trend bias that can ruin strategy recommendation accuracy.",
    "Melacak": "Tracking",
    "siklus tren jangka panjang (tahunan)": "long-term (yearly) trend cycles",
    "untuk melihat apakah ada bulan atau kuartal tertentu yang secara konsisten selalu lebih ramai, sehingga Anda bisa merencanakan kapasitas staf dan stock jauh-jauh hari.": "to see if there are specific months or quarters that are consistently busier, so you can plan staff and stock capacity well in advance.",
    "Selama musim tinggi": "During peak season",
    "yang mencakup": "which includes",
    "Libur Sekolah, Akhir Tahun, dan Periode Ramadan/Lebaran": "School Holidays, Year End, and Ramadan/Eid Periods",
    "restoran Anda mengalami perubahan traffic sebesar": "your restaurant experiences a traffic change of",
    "Bukti data mentah pergeseran tren kuartalan yang mendasari rekomendasi kapasitas dan marketing di atas.": "Raw data evidence of quarterly trend shifts underlying the capacity and marketing recommendations above.",
    "Kuartal mana yang paling dominan secara historis?": "Which quarter is historically most dominant?",
    "Gunakan data kuartalan untuk validasi pola:": "Use quarterly data to validate patterns:",
    "pastikan lonjakan atau penurunan di suatu kuartal terjadi secara konsisten dari tahun ke tahun. Pola yang berulang (bukan anomali satu tahun) adalah fondasi paling aman untuk merencanakan rekrutmen staf dan anggaran": "ensure spikes or drops in a quarter occur consistently year after year. A repeating pattern (not a one-year anomaly) is the safest foundation for planning staff recruitment and budgets",
    "tercatat baru beroperasi selama": "is recorded as having only operated for",
    "bulan. Analisis pergeseran musiman memerlukan minimal 12 bulan (1 siklus tahunan) data historis penuh agar tren jangka panjang yang dibaca akurat dan tidak menyesatkan.": "months. Seasonal shift analysis requires a minimum of 12 months (1 yearly cycle) of full historical data for long-term trends to be read accurately and not misleadingly."
}

pages_dir = "pages/en"
for root, dirs, files in os.walk(pages_dir):
    for file in files:
        if file.endswith(".md"):
            filepath = os.path.join(root, file)
            with open(filepath, "r") as f:
                content = f.read()
            original_content = content
            for indo, eng in replacements.items():
                content = content.replace(indo, eng)
            if content != original_content:
                with open(filepath, "w") as f:
                    f.write(content)
                print(f"Patched {filepath}")
