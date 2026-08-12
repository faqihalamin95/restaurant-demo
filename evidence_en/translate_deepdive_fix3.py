from pathlib import Path

f = Path('/home/faqih/projects/restaurant-demo/evidence_en/pages/02-branch-performance/deepdive.md')
c = f.read_text()

c = c.replace('Fokus pada <em>Loyalty Program</em>. Berikan <em>voucher</em> kejutan bagi pelanggan rutin.', 'Focus on <em>Loyalty Program</em>. Give <em>surprise vouchers</em> to routine customers.')
c = c.replace('Bergantung sepenuhnya pada kualitas database pelanggan (CRM).', 'Depends entirely on the quality of the customer database (CRM).')

c = c.replace('<strong>Opsi C: Renegosiasi Kontrak</strong>', '<strong>Option C: Contract Renegotiation</strong>')
c = c.replace('<strong>Lobi Uang Sewa.</strong> Mengingat tren location lesu, negosiasikan ulang harga sewa, atau putus kontrak vendor keamanan.', '<strong>Lobby Rent Money.</strong> Given the sluggish location trend, renegotiate rental prices, or terminate security vendor contracts.')
c = c.replace('Memangkas beban <em>overhead</em> terbesar secara fundamental.', 'Cut the largest <em>overhead</em> burden fundamentally.')
c = c.replace('Risiko hubungan bisnis retak atau penalti pemutusan kontrak.', 'Risk of fractured business relationships or contract termination penalties.')
c = c.replace('Overhead melebihi 30% adalah <em>silent killer</em> karena bersifat <em>fixed-cost</em> (harus dibayar meski restoran tidak ada pembeli). Bernegosiasi ulang biaya sewa saat bisnis tertekan adalah praktik korporat yang wajar.', 'Overhead exceeding 30% is a <em>silent killer</em> because it is a <em>fixed-cost</em> (must be paid even if the restaurant has no buyers). Renegotiating rental costs when business is under pressure is a reasonable corporate practice.')

c = c.replace('<Tab label="📉 Penurunan Volume">', '<Tab label="📉 Volume Decline">')

f.write_text(c)
