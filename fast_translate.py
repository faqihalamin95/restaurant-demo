import os
from pathlib import Path

translations = {
    'Laporan Keuangan': 'Financial Report',
    'Rincian Biaya': 'Cost Breakdown',
    'Performa Cabang': 'Branch Performance',
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
    'Eksplorasi Ekosistem & Peta Kekuatan Cabang': 'Ecosystem Exploration & Branch Strength Map',
    'Bedah lebih dalam efektivitas SOP, deteksi anomali kinerja, dan ukur ketimpangan profitabilitas lintas cabang secara komprehensif.': 'Dive deeper into SOP effectiveness, detect performance anomalies, and comprehensively measure profitability gaps across branches.',
    'Navigasikan analisis performa cabang Anda dari ringkasan kesehatan finansial hingga audit granular per outlet.': 'Navigate your branch performance analysis from financial health overview to granular outlet audits.',
    'Audit Per Cabang': 'Audit Per Branch',
    'Baca cepat volume order, AOV, dan gap ketimpangan antar cabang di seluruh outlet.': 'Quickly read order volume, AOV, and inequality gaps across all outlets.',
    'Baca analisis pertumbuhan jangka panjang, profitabilitas, dan strategi portofolio cabang.': 'Read long-term growth analysis, profitability, and branch portfolio strategy.',
    'Semua cabang sehat dan berjalan optimal.': 'All branches are healthy and running optimally.',
    'Mayoritas cabang dalam kondisi sehat dan aman.': 'Majority of branches are in healthy and safe condition.',
    'Setengah cabang mulai tertekan, perlu pengawasan aktif.': 'Half of branches are starting to be pressured, needs active monitoring.',
    'Mayoritas cabang tertekan secara margin operasional.': 'Majority of branches are pressured operationally in margins.',
    'Seluruh cabang beroperasi dengan profit positif.': 'All branches are operating with positive profit.',
    'STATUS KESEHATAN & AUDIT MARGIN PER CABANG': 'HEALTH STATUS & MARGIN AUDIT PER BRANCH',
    'omzet bergantung pada': 'revenue depends on',
    'Cabang Tren Menurun': 'Declining Trend Branches',
    'Buka Evaluasi Strategis': 'Open Strategic Evaluation',
    'Eksplorasi Ekosistem & Peta Kekuatan Menu': 'Ecosystem Exploration & Menu Strength Map',
    'Eksplorasi Strategi Promosi & Rotasi': 'Promotion Strategy & Rotation Exploration',
    'Bedah lebih dalam efektivitas SOP, deteksi anomali kinerja, dan ukur ketimpangan profitabilitas lintas menu secara komprehensif.': 'Dive deeper into SOP effectiveness, detect performance anomalies, and measure profitability gaps across menus.',
}

directories = [
    'evidence/pages/en/05-menu-performance',
    'evidence/pages/en/06-member-behavior',
    'evidence/pages/en/07-employee-performance'
]

files = [
    'evidence/pages/en/index.md'
]

for d in directories:
    for path in Path(d).rglob('*.md'):
        files.append(str(path))

for f in files:
    try:
        content = Path(f).read_text()
        new_content = content
        for k, v in translations.items():
            new_content = new_content.replace(k, v)
        if new_content != content:
            Path(f).write_text(new_content)
            print(f"Translated {f}")
    except Exception as e:
        print(f"Error reading {f}: {e}")
