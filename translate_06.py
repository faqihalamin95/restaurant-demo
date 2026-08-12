import re

file_path = '/home/faqih/projects/restaurant-demo/evidence/pages/en/06-member-behavior/03-strategic-evaluation.md'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

replacements = {
    'Kesimpulan Eksekutif (Puncak Piramida)': 'Executive Summary (Pyramid Peak)',
    'Tempat untuk Analisis Pendukung dengan Tabs': 'Placeholder for Supporting Analysis with Tabs',
    'PANDUAN EKSEKUSI & BATASAN ETIKA (DUA KOLOM)': 'EXECUTION GUIDE & ETHICAL BOUNDARIES (TWO COLUMNS)',
    'Kolom Kiri: Panduan Taktis': 'Left Column: Tactical Guide',
    'Kolom Kanan: Guardrail Etika': 'Right Column: Ethical Guardrail',
}

for indo, eng in replacements.items():
    content = content.replace(indo, eng)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

