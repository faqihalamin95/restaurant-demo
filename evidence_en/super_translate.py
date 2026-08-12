import os
from pathlib import Path
import glob

translations = {
    # Specifically requested by user
    'DIAGNOSTIK UTAMA': 'MAIN DIAGNOSTICS',
    'Sintesis Efisiensi Operasional Makro': 'Macro Operational Efficiency Synthesis',
    'Evaluation menyeluruh terhadap batas aman pengeluaran utilitas, biaya tetap, dan kesehatan anggaran operasional restoran bulan ini.': 'Comprehensive evaluation of safe limits for utility expenses, fixed costs, and the health of this month\'s restaurant operational budget.',
    'Ideal: Pengeluaran Operasional Efisien': 'Ideal: Efficient Operational Spending',
    'Pengeluaran utilitas dan biaya tetap sangat sehat': 'Utility and fixed costs are very healthy',
    'mematuhi batas aman operasional.': 'complying with safe operational limits.',
    'Prestasi efisiensi operasional terbaik dicapai oleh': 'The best operational efficiency achievement was reached by',
    'Saran: Pertahankan kedisiplinan pemakaian utilitas saat ini tanpa mengorbankan kenyamanan pengunjung.': 'Recommendation: Maintain current utility usage discipline without sacrificing visitor comfort.',
    '(Catatan: Terus pantau kepuasan pelanggan di lapangan).': '(Note: Continuously monitor customer satisfaction in the field).',
    'Sistem Peringatan Dini (Zona Operasional)': 'Early Warning System (Operational Zone)',
    'Pantau Bawah': 'Monitor Lower',
    'Proporsi di bawah target. Tinjau alokasi biaya pemeliharaan dasar.': 'Proportion below target. Review basic maintenance cost allocation.',
    'Zona Ideal': 'Ideal Zone',
    'Pengeluaran efisien. Pertahankan pola operasional saat ini.': 'Efficient spending. Maintain current operational pattern.',
    'Pantau Atas': 'Monitor Upper',
    'Proporsi meningkat. Tinjau tren tagihan utilitas bulanan.': 'Proportion increasing. Review monthly utility bill trends.',
    'Pemborosan': 'Waste',
    'Indikasi inefisiensi. Lakukan audit pengeluaran non-esensial.': 'Indication of inefficiency. Conduct audit of non-essential expenses.',
    'PERBANDINGAN CABANG': 'LOCATION COMPARISON',
    'Rapor Efisiensi Operasional': 'Operational Efficiency Report',
    'Hari': 'Days',
    'Target Rasio Overhead Costs: Idealnya 30% dari Total Revenue per location.': 'Overhead Costs Ratio Target: Ideally 30% of Total Revenue per location.',
    'Konteks Data & Cara Membaca': 'Data Context & How to Read',
    'Nilai Varian (Rp)': 'Variance Value (Rp)',
    'STRUKTUR KOMPOSISI BIAYA': 'COST COMPOSITION STRUCTURE',
    'Proporsi Overhead Costs (Sewa vs Listrik vs Air vs Lainnya)': 'Overhead Costs Proportion (Rent vs Electricity vs Water vs Others)',
    'Bedah sumber pembengkakan utilitas atau biaya overhead lainnya untuk mengetahui pos pengeluaran mana yang butuh efisiensi segera.': 'Analyze sources of utility swelling or other overhead costs to determine which expense items need immediate efficiency.',
    'Investigasi Cost Breakdown Location': 'Location Cost Breakdown Investigation',
    'Bedah lebih detail rincian biaya per location dan temukan rekomendasi aksinya.': 'Analyze location cost breakdown details and find actionable recommendations.',
    'Buka Deep Dive Location': 'Open Location Deep Dive',

    # General replacements
    'Laporan Keuangan': 'Financial Report',
    '01-laporan-keuangan': '01-financial-report',
    '01-rincian-biaya': 'cost-breakdown',
    'Rincian Biaya': 'Cost Breakdown',
    'Performa Cabang': 'Location Performance',
    '02-branch-performance': '02-branch-performance',
    'Inventori': 'Inventory',
    'Karyawan': 'Employee',
    'Ringkasan': 'Overview',
    'Biaya Bahan Baku': 'Ingredient Costs',
    'Biaya SDM': 'Labor Costs',
    'Biaya Operasional': 'Overhead Costs',
    'Pilih sub-modul': 'Select a sub-module',
    'Semua Cabang': 'All Locations',
    'Cabang Pusat': 'Downtown',
    'Cabang Selatan': 'Southside',
    'Cabang Timur': 'Eastside',
    'Cabang Utara': 'Northside',
    'Pendapatan': 'Revenue',
    'Tren': 'Trends',
    'Evaluasi': 'Evaluation',
    'Cabang': 'Location',
    'cabang': 'location',
    'Stok': 'Stock',
    'stok': 'stock',
    'Kritis': 'Critical',
    'Sehat': 'Healthy',
    'Waspada': 'Warning',
    'Eksplorasi Ekosistem & Peta Kekuatan Cabang': 'Ecosystem Exploration & Location Strength Map',
    'Bedah lebih dalam efektivitas SOP, deteksi anomali kinerja, dan ukur ketimpangan profitabilitas lintas cabang secara komprehensif.': 'Dive deeper into SOP effectiveness, detect performance anomalies, and comprehensively measure profitability gaps across locations.',
    'Navigasikan analisis performa cabang Anda dari ringkasan kesehatan finansial hingga audit granular per outlet.': 'Navigate your location performance analysis from financial health overview to granular outlet audits.',
    'Audit Per Cabang': 'Audit Per Location',
    'Baca cepat volume order, AOV, dan gap ketimpangan antar cabang di seluruh outlet.': 'Quickly read order volume, AOV, and inequality gaps across all outlets.',
    'Baca analisis pertumbuhan jangka panjang, profitabilitas, dan strategi portofolio cabang.': 'Read long-term growth analysis, profitability, and location portfolio strategy.',
    'Semua cabang sehat dan berjalan optimal.': 'All locations are healthy and running optimally.',
    'Mayoritas cabang dalam kondisi sehat dan aman.': 'Majority of locations are in healthy and safe condition.',
    'Setengah cabang mulai tertekan, perlu pengawasan aktif.': 'Half of locations are starting to be pressured, needs active monitoring.',
    'Mayoritas cabang tertekan secara margin operasional.': 'Majority of locations are pressured operationally in margins.',
    'Seluruh cabang beroperasi dengan profit positif.': 'All locations are operating with positive profit.',
    'STATUS KESEHATAN & AUDIT MARGIN PER CABANG': 'HEALTH STATUS & MARGIN AUDIT PER LOCATION',
    'omzet bergantung pada': 'revenue depends on',
    'Cabang Tren Menurun': 'Declining Trend Locations',
    'Buka Evaluasi Strategis': 'Open Strategic Evaluation',
    'Eksplorasi Ekosistem & Peta Kekuatan Menu': 'Ecosystem Exploration & Menu Strength Map',
    'Eksplorasi Strategi Promosi & Rotasi': 'Promotion Strategy & Rotation Exploration',
    'Bedah lebih dalam efektivitas SOP, deteksi anomali kinerja, dan ukur ketimpangan profitabilitas lintas menu secara komprehensif.': 'Dive deeper into SOP effectiveness, detect performance anomalies, and measure profitability gaps across menus.',
    
    # 02-branch-performance specific
    'kesehatan margin, pertumbuhan, profitabilitas, strategi, dan prioritas aksi.': 'margin health, growth, profitability, strategy, and action priorities.',
    'Cara memilih subpage': 'How to choose a subpage',
    'Navigasikan analisis performa location Anda dari ringkasan kesehatan finansial hingga audit granular per outlet.': 'Navigate your location performance analysis from financial health overview to granular outlet audits.',
    'Status Utama & Gap': 'Main Status & Gap',
    'Audit Per Location': 'Audit Per Location',
    'Audit location satu per satu: status margin harian, cogs, tren belanja, dan data pendukung.': 'Audit locations one by one: daily margin status, COGS, spending trends, and supporting data.',
    'Strategi Portofolio': 'Portfolio Strategy',
    'Total bisnis tetap paling pas dibaca di halaman': 'Total business is best viewed on the page',
    'Tulang Punggung Laba': 'Profit Backbone',
    'Titik Kebocoran': 'Leakage Point',
    'Laba': 'Profit',
    'Rugi': 'Loss',
    'Fokus: Analisis perbandingan margin 30H vs baseline 90H. Klik kartu untuk membuka analisis komprehensif.': 'Focus: Comparative analysis of 30D margin vs 90D baseline. Click card to open comprehensive analysis.',
    'Kenapa margin 30H dibandingkan dengan 90H?': 'Why compare 30D margin with 90D?',
    'Margin 30 Hari': '30 Day Margin',
    'Margin 30H menunjukkan kondisi aktif yang perlu diputuskan sekarang.': '30D margin shows active condition requiring immediate decision.',
    'Baseline Pembanding': 'Comparison Baseline',
    'Baseline 90 Hari': '90 Day Baseline',
    'Margin 90H menunjukkan baseline recent: apakah masalahnya baru atau sudah menetap beberapa bulan.': '90D margin shows recent baseline: whether the issue is new or has persisted for months.',
    'Masalah Baru': 'New Issue',
    'Jika 30H lemah tapi 90H sehat, masalahnya early warning dan masih bisa dikoreksi cepat.': 'If 30D is weak but 90D is healthy, it is an early warning and can be quickly corrected.',
    'Masalah Kronis': 'Chronic Issue',
    'Pola Struktural': 'Structural Pattern',
    'Jika 30H dan 90H sama-sama lemah, masalahnya sudah lebih struktural.': 'If both 30D and 90D are weak, the issue is more structural.',
    'Konteks Historis': 'Historical Context',
    'Margin Fundamental': 'Fundamental Margin',
    'Margin historis tetap dipakai sebagai konteks fundamental, bukan sebagai alarm utama.': 'Historical margin remains as fundamental context, not as main alarm.',
    'KESEHATAN MAKRO (STRATEGIS)': 'MACRO HEALTH (STRATEGIC)',
    'Fokus: Evaluation Kebijakan Bisnis Jangka Panjang': 'Focus: Evaluation of Long-Term Business Policies',
    'Pemusatan Risiko': 'Risk Concentration',
    'Dominasi': 'Dominance',
    'Location Teratas': 'Top Locations',
    'Momentum Trafik Jaringan': 'Network Traffic Momentum',
    
    # 04-peak-hours deepdive
    'demmand & traffic': 'demand & traffic',
    'Trafik': 'Traffic',
    'Permintaan': 'Demand',
    'Pola Konsumsi': 'Consumption Patterns',
    
    # 07-employee-performance direktori-data
    'direktori data': 'data directory',
    'Kinerja Karyawan': 'Employee Performance',
    'Absensi': 'Attendance',
    'Produktivitas': 'Productivity',
    'Jam Kerja': 'Working Hours',
    
    # URL renaming
    '/01-rincian-biaya': '/cost-breakdown',
    '/02-branch-performance/direktori-data': '/02-branch-performance/data-directory',
    'direktori-data': 'data-directory'
}

files = glob.glob('/home/faqih/projects/restaurant-demo/evidence_en/pages/**/*.md', recursive=True)

for f in files:
    try:
        content = Path(f).read_text()
        new_content = content
        
        # Sort keys by length descending to replace longer phrases first
        for k in sorted(translations.keys(), key=len, reverse=True):
            new_content = new_content.replace(k, translations[k])
            
        if new_content != content:
            Path(f).write_text(new_content)
            print(f"Translated {f}")
    except Exception as e:
        print(f"Error processing {f}: {e}")

# Rename the files
renames = [
    ('/home/faqih/projects/restaurant-demo/evidence_en/pages/01-financial-report/01-rincian-biaya.md', 
     '/home/faqih/projects/restaurant-demo/evidence_en/pages/01-financial-report/cost-breakdown.md'),
    ('/home/faqih/projects/restaurant-demo/evidence_en/pages/02-branch-performance/direktori-data.md', 
     '/home/faqih/projects/restaurant-demo/evidence_en/pages/02-branch-performance/data-directory.md'),
    ('/home/faqih/projects/restaurant-demo/evidence_en/pages/07-employee-performance/direktori-data.md', 
     '/home/faqih/projects/restaurant-demo/evidence_en/pages/07-employee-performance/data-directory.md'),
    ('/home/faqih/projects/restaurant-demo/evidence_en/pages/03-inventory/direktori-data.md', 
     '/home/faqih/projects/restaurant-demo/evidence_en/pages/03-inventory/data-directory.md')
]

for old, new in renames:
    if os.path.exists(old):
        os.rename(old, new)
        print(f"Renamed {old} to {new}")
