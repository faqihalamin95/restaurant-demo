import glob
from pathlib import Path

translations = {
    'Direktori Data': 'Data Directory',
    'Analisis': 'Analysis',
    'Evaluasi Strategis': 'Strategic Evaluation',
    'Kesehatan': 'Health',
    'Kinerja': 'Performance'
}

for f in glob.glob('/home/faqih/projects/restaurant-demo/evidence_en/pages/**/*.md', recursive=True):
    try:
        content = Path(f).read_text()
        new_content = content
        for k, v in translations.items():
            new_content = new_content.replace(k, v)
        if new_content != content:
            Path(f).write_text(new_content)
    except:
        pass
