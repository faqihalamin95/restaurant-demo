import os
import shutil
import glob

# 1. Copy folders
folders = ['05-menu-performance', '06-member-behavior', '07-employee-performance']
for f in folders:
    src = f"pages/id/{f}"
    dst = f"pages/en/{f}"
    if os.path.exists(dst):
        shutil.rmtree(dst)
    shutil.copytree(src, dst)

# 2. Rename files
renames = [
    ("pages/en/05-menu-performance/evaluasi.md", "pages/en/05-menu-performance/evaluation.md"),
    ("pages/en/05-menu-performance/rapor.md", "pages/en/05-menu-performance/report.md"),
    ("pages/en/05-menu-performance/direktori.md", "pages/en/05-menu-performance/directory.md"),
    ("pages/en/06-member-behavior/02-aksi-taktis.md", "pages/en/06-member-behavior/02-tactical-action.md"),
    ("pages/en/06-member-behavior/03-evaluasi-strategis.md", "pages/en/06-member-behavior/03-strategic-evaluation.md"),
    ("pages/en/06-member-behavior/04-direktori-member.md", "pages/en/06-member-behavior/04-member-directory.md"),
    ("pages/en/07-employee-performance/02-aksi-taktis.md", "pages/en/07-employee-performance/02-tactical-action.md"),
    ("pages/en/07-employee-performance/03-evaluasi-strategis.md", "pages/en/07-employee-performance/03-strategic-evaluation.md"),
    ("pages/en/07-employee-performance/05-direktori-data.md", "pages/en/07-employee-performance/04-data-directory.md")
]

for old, new in renames:
    if os.path.exists(old):
        os.rename(old, new)

# 3. Update components
comp_replacements = {
    "components/MenuTabs.svelte": [
        ('linkEvaluation: "/en/05-menu-performance/evaluasi"', 'linkEvaluation: "/en/05-menu-performance/evaluation"'),
        ('linkReport: "/en/05-menu-performance/rapor"', 'linkReport: "/en/05-menu-performance/report"'),
        ('linkDirectory: "/en/05-menu-performance/direktori"', 'linkDirectory: "/en/05-menu-performance/directory"')
    ],
    "components/MemberTabs.svelte": [
        ('linkTactical: "/en/06-member-behavior/02-aksi-taktis"', 'linkTactical: "/en/06-member-behavior/02-tactical-action"'),
        ('linkStrategic: "/en/06-member-behavior/03-evaluasi-strategis"', 'linkStrategic: "/en/06-member-behavior/03-strategic-evaluation"'),
        ('linkDirectory: "/en/06-member-behavior/04-direktori-member"', 'linkDirectory: "/en/06-member-behavior/04-member-directory"')
    ],
    "components/EmployeeTabs.svelte": [
        ('linkTactical: "/en/07-employee-performance/02-aksi-taktis"', 'linkTactical: "/en/07-employee-performance/02-tactical-action"'),
        ('linkStrategic: "/en/07-employee-performance/03-evaluasi-strategis"', 'linkStrategic: "/en/07-employee-performance/03-strategic-evaluation"'),
        ('linkDirectory: "/en/07-employee-performance/05-direktori-data"', 'linkDirectory: "/en/07-employee-performance/04-data-directory"')
    ]
}

for comp, reps in comp_replacements.items():
    with open(comp, 'r') as f:
        c = f.read()
    for old, new in reps:
        c = c.replace(old, new)
    with open(comp, 'w') as f:
        f.write(c)

# 4. Update Markdown files in en/
for folder in folders:
    for path in glob.glob(f"pages/en/{folder}/*.md"):
        with open(path, 'r') as f:
            c = f.read()
        
        # Add lang="en" to tabs
        c = c.replace("<MenuTabs", "<MenuTabs lang=\"en\"")
        c = c.replace("<MemberTabs", "<MemberTabs lang=\"en\"")
        c = c.replace("<EmployeeTabs", "<EmployeeTabs lang=\"en\"")
        
        # Update hardcoded hrefs
        c = c.replace('href="/05-menu-performance', 'href="/en/05-menu-performance')
        c = c.replace('href="/06-member-behavior', 'href="/en/06-member-behavior')
        c = c.replace('href="/07-employee-performance', 'href="/en/07-employee-performance')
        
        # Also fix any old links to other modules
        c = c.replace('href="/01-laporan-keuangan', 'href="/en/01-financial-report')
        c = c.replace('href="/02-branch-performance', 'href="/en/02-branch-performance')
        c = c.replace('href="/03-inventori-stok', 'href="/en/03-inventory')
        c = c.replace('href="/04-peak-hours', 'href="/en/04-peak-hours')

        with open(path, 'w') as f:
            f.write(c)

print("Phase 5 Python script completed.")
