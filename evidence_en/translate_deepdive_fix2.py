import re
from pathlib import Path

f = Path('/home/faqih/projects/restaurant-demo/evidence_en/pages/02-branch-performance/deepdive.md')
c = f.read_text()

# Executive Summary
c = c.replace('namun volume bisnis sedang mengalami kontraksi', 'however business volume is experiencing contraction')
c = c.replace('Verifikasi pada grafik Kuartalan di bawah apakah penurunan ini murni efek siklus musiman (low-season).', 'Verify on the Quarterly chart below whether this decline is purely a seasonal effect (low-season).')
c = c.replace('Tetap waspadai tren pergerakan biaya bahan.', 'Remain vigilant of Ingredient Cost movement trends.')
c = c.replace('Tetap waspadai tren pergerakan', 'Remain vigilant of movement trends for')

c = c.replace('Tindakan korektif &amp; panduan strategis', 'Corrective action &amp; strategic guidance')
c = c.replace('Lonjakan trafik gagal dikonversi to laba, indikasi taktik promo/diskon terlalu dalam.', 'Traffic surge failed to convert to profit, indicating promo/discount tactics were too deep.')

c = c.replace('Rekomendasi Menghadapi Penurunan tren Volume', 'Recommendations for Facing Volume Trend Decline')
c = c.replace('Rekomendasi Menghadapi Penurunan trends Volume', 'Recommendations for Facing Volume Trend Decline')
c = c.replace('Opsi A: Agresif Promo', 'Option A: Aggressive Promo')
c = c.replace('Bakar Margin.', 'Burn Margin.')
c = c.replace('Buat diskon terbatas pada menu bervolume tertinggi', 'Create limited discounts on the highest volume menu')
c = c.replace('Mendongkrak volume transaksi dan <em>traffic</em> secara instan.', 'Boost transaction volume and <em>traffic</em> instantly.')
c = c.replace('Menggerus ruang margin kotor secara sengaja di bulan berjalan.', 'Intentionally erode gross margin space in the current month.')

c = c.replace('Opsi B: Moderat Retensi', 'Option B: Moderate Retention')
c = c.replace('Jaga Pelanggan Lama.', 'Keep Old Customers.')
c = c.replace('Fokus pada Loyalty Program.', 'Focus on Loyalty Program.')
c = c.replace('Berikan voucher kejutan bagi pelanggan rutin.', 'Give surprise vouchers to routine customers.')
c = c.replace('Mempertahankan loyalitas tanpa membakar biaya akuisisi (CAC).', 'Maintain loyalty without burning acquisition costs (CAC).')
c = c.replace('Bergantung sepenuhnya pada kualitas <em>database</em> pelanggan (CRM).', 'Depends entirely on the quality of the customer <em>database</em> (CRM).')

c = c.replace('Opsi C: Defensif Pasif', 'Option C: Passive Defensive')
c = c.replace('Terima Kenyataan.', 'Accept Reality.')
c = c.replace('Asumsikan ini adalah siklus low-season alami.', 'Assume this is a natural low-season cycle.')
c = c.replace('Turunkan stock harian untuk menghindari food waste.', 'Lower daily stock to avoid food waste.')
c = c.replace('Melindungi margin bersih secara absolut dari risiko limbah.', 'Absolutely protect net margin from waste risk.')
c = c.replace('Pangsa pasar berpotensi diam-diam direbut kompetitor.', 'Market share potentially quietly taken by competitors.')

c = c.replace('Membakar uang pemasaran (promo diskon) saat siklus <em>low-season</em> alami seringkali membuahkan ROI negatif.', 'Burning marketing money (promo discounts) during a natural <em>low-season</em> cycle often yields negative ROI.')
c = c.replace('Melindungi margin melalui efisiensi persediaan adalah langkah paling rasional.', 'Protecting margins through inventory efficiency is the most rational step.')
c = c.replace('Strategi Pertahanan Siklus Musiman F&B', 'F&B Seasonal Cycle Defense Strategy')

# Under budget
c = c.replace('Pengeluaran jauh di bawah batas target (&lt;25% untuk bahan, &lt;15% untuk SDM)', 'Expenditure well below target limits (&lt;25% for material, &lt;15% for HR)')
c = c.replace('tidak selalu berarti "hemat".', 'does not always mean "saving".')
c = c.replace('Warningi jebakan risiko tersembunyi berikut:', 'Beware of the following hidden risk traps:')
c = c.replace('Margin Semu', 'False Margin')
c = c.replace('Warningi indikasi pencurian porsi oleh dapur (under-portioning) atau supplier menurunkan kualitas standar bahan diam-diam (downgrade).', 'Beware of indications of portion theft by the kitchen (under-portioning) or suppliers secretly lowering standard material quality (downgrade).')
c = c.replace('Crisis Understaffed', 'Understaffed Crisis')
c = c.replace('Fasilitas Menurun', 'Declining Facilities')

# Fix Kontra -> Con
c = c.replace('<strong>Kontra:</strong>', '<strong>Con:</strong>')
c = c.replace('<strong>Pro:</strong>', '<strong>Pro:</strong>')

# Remove HTML tags logic for exact match
c = re.sub(r'Berisiko menurunkan <em>traffic</em> pelanggan jika sensitivitas harga tinggi\.', 'Risks lowering customer <em>traffic</em> if price sensitivity is high.', c)
c = re.sub(r'Wajibkan kasir melakukan <em>bundling</em> makanan berat dengan minuman bermargin tinggi\.', 'Require cashiers to bundle heavy meals with high-margin drinks.', c)
c = re.sub(r'Memerlukan <em>training</em> kasir dan insentif penjualan\.', 'Requires cashier <em>training</em> and sales incentives.', c)
c = re.sub(r'Waktu layanan \(<em>serving time</em>\) melambat tajam', 'Service time (<em>serving time</em>) slows down sharply', c)
c = re.sub(r'tingkat kesalahan pesanan melonjak', 'order error rate spikes', c)
c = re.sub(r'dan staf lama terancam <em>resign</em> karena kelelahan \(<em>burnout</em>\)\.', 'and veteran staff threatened to <em>resign</em> due to exhaustion (<em>burnout</em>).', c)
c = re.sub(r'Menghemat biaya kebersihan, pemeliharaan AC, atau perbaikan alat makan dapat merusak pengalaman bersantap secara permanen di mata konsumen\.', 'Saving on cleaning costs, AC maintenance, or cutlery repair can permanently damage the dining experience in the eyes of consumers.', c)

# Data room
c = c.replace('Pusat Data Ekstra &amp; Perspektif Strategis', 'Extra Data Center &amp; Strategic Perspectives')
c = c.replace('Gunakan lensa tambahan di bawah ini untuk membedah komposisi mesin pendapatan serta melacak pola tren kesehatan bisnis dalam jangka panjang (Kuartalan &amp; YoY).', 'Use the additional lenses below to dissect the revenue engine composition and track long-term business health trend patterns (Quarterly &amp; YoY).')
c = c.replace('Gunakan lensa tambahan di bawah ini untuk membedah komposisi mesin pendapatan serta melacak pola tren kesehatan bisnis dalam jangka panjang (Kuartalan & YoY).', 'Use the additional lenses below to dissect the revenue engine composition and track long-term business health trend patterns (Quarterly & YoY).')


f.write_text(c)
print("Updated deepdive.md")
