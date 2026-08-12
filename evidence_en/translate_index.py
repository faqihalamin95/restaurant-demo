from pathlib import Path

translations = {
    'Turnaround': 'Turnaround',
    'Margin Active 30H': 'Active 30D Margin',
    'Margin 90H': '90D Margin',
    'Historis': 'Historical',
    'trends Orders': 'Order Trends',
    'sama-sama lemah': 'are both weak',
    'Perlu pembenahan struktural.': 'Structural improvements needed.',
    'Stabil Rendah': 'Stable Low',
    'sama-sama sedang': 'are both moderate',
    'Bukan krisis, tapi belum optimal.': 'Not a crisis, but not yet optimal.',
    'Sehat': 'Healthy',
    'sama-sama kuat': 'are both strong',
    'Jadikan benchmark operasional.': 'Use as operational benchmark.',
    'Daya Beli Jaringan': 'Network Purchasing Power',
    'selama 3 bln beruntun.': 'for 3 consecutive months.',
    'Eksplorasi Ekosistem & Peta Kekuatan Location': 'Ecosystem Exploration & Location Power Map',
    'Bedah lebih dalam efektivitas SOP, deteksi anomali kinerja, dan ukur ketimpangan profitabilitas lintas location secara komprehensif.': 'Deep dive into SOP effectiveness, detect performance anomalies, and comprehensively measure profitability inequality across locations.',
    'Buka Evaluation Strategis ➔': 'Open Strategic Evaluation ➔',
    'Buka Evaluation Strategis': 'Open Strategic Evaluation',
    'Total volume struk (30 Days)': 'Total receipt volume (30 Days)',
    '30 Days Terakhir': 'Last 30 Days',
    '90 Days Terakhir': 'Last 90 Days',
    'Selisih / Perubahan': 'Difference / Change',
    'Target normal maks': 'Normal max target',
    'Rasio mulai naik. Tinjau ulang pemakaian bahan baku harian.': 'Ratio starting to rise. Review daily raw material usage.',
    'Rasio sangat rendah. Risiko operasional dan pelayanan turun.': 'Ratio is very low. Operational and service risks decrease.',
    'Pengeluaran rendah. Pastikan utilitas fasilitas tetap memadai.': 'Low expenditure. Ensure facility utilities remain adequate.',
    'Target normal 30% didasarkan pada kaidah keuangan': 'The normal 30% target is based on financial rules',
    'Proporsi Rincian Pengeluaran Location': 'Location Expenditure Breakdown Proportion',
    'Sewa Bangunan': 'Building Rent',
    'Listrik': 'Electricity',
    'Air': 'Water',
    'Lainnya': 'Others'
}

f = Path('/home/faqih/projects/restaurant-demo/evidence_en/pages/02-branch-performance/index.md')
c = f.read_text()
for k, v in translations.items():
    c = c.replace(k, v)
f.write_text(c)
print("Updated index.md")
