from pathlib import Path
import re

f = Path('/home/faqih/projects/restaurant-demo/evidence_en/pages/02-branch-performance/deepdive.md')
c = f.read_text()

# Strip any html tags just for matching if needed, or simply replace the unformatted text
replacements = {
    'Fokus pada Loyalty Program. Berikan voucher kejutan bagi pelanggan rutin.': 'Focus on Loyalty Program. Give surprise vouchers to routine customers.',
    'Bergantung sepenuhnya pada kualitas database pelanggan (CRM).': 'Depends entirely on the quality of the customer database (CRM).',
    'Opsi C: Renegosiasi Kontrak': 'Option C: Contract Renegotiation',
    'Lobi Uang Sewa.': 'Lobby Rent Money.',
    'Mengingat tren location lesu, negosiasikan ulang harga sewa, atau putus kontrak vendor keamanan.': 'Given the sluggish location trend, renegotiate rental prices, or terminate security vendor contracts.',
    'Memangkas beban overhead terbesar secara fundamental.': 'Cut the largest overhead burden fundamentally.',
    'Risiko hubungan bisnis retak atau penalti pemutusan kontrak.': 'Risk of fractured business relationships or contract termination penalties.',
    'Overhead melebihi 30% adalah silent killer karena bersifat fixed-cost (harus dibayar meski restoran tidak ada pembeli). Bernegosiasi ulang biaya sewa saat bisnis tertekan adalah praktik korporat yang wajar.': 'Overhead exceeding 30% is a silent killer because it is a fixed-cost (must be paid even if the restaurant has no buyers). Renegotiating rental costs when business is under pressure is a reasonable corporate practice.'
}

for k, v in replacements.items():
    # To handle cases with or without <em> tags, we'll do a regex replace
    pattern = k.replace(' ', r'(?:\s+|<[^>]+>)*')
    c = re.sub(pattern, v, c, flags=re.IGNORECASE)

f.write_text(c)
