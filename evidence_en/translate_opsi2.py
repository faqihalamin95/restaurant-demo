from pathlib import Path

f = Path('/home/faqih/projects/restaurant-demo/evidence_en/pages/02-branch-performance/deepdive.md')
c = f.read_text()

c = c.replace('Opsi B: Agresif Ekspansi', 'Option B: Aggressive Expansion')
c = c.replace('Opsi C: Restrukturisasi Sistem', 'Option C: System Restructuring')
c = c.replace('Penghematan rupiahnya relatif kecil dibanding opsi lain.', 'The rupiah savings are relatively small compared to other options.')
c = c.replace('Opsi B: Utilisasi Aset', 'Option B: Asset Utilization')
c = c.replace('Opsi B: Apresiasi Tim', 'Option B: Team Appreciation')
c = c.replace('Opsi C: Ekspansi Organik', 'Option C: Organic Expansion')

# Let's fix the texts corresponding to these options as well
c = c.replace('Tarik Chef Eksekutif.', 'Bring in Executive Chef.')
c = c.replace('Tempatkan SDM terbaik atau supervisor paling tangguh untuk membereskan lokasi yang paling parah performanya.', 'Deploy the best HR or toughest supervisor to fix the worst performing location.')
c = c.replace('Peluang turnaround dramatis dalam waktu singkat.', 'Opportunity for dramatic turnaround in a short time.')
c = c.replace('SDM unggulan mungkin merasa "turun kasta" atau kelelahan di lokasi bermasalah.', 'Top HR might feel "downgraded" or exhausted in problem locations.')

c = c.replace('Ganti Format Layanan.', 'Change Service Format.')
c = c.replace('Jika biaya SDM permanen tinggi, transisi perlahan menuju Self-Service (pesan dan ambil sendiri di kasir).', 'If fixed Labor Costs are high, transition slowly towards Self-Service (order and pick up at cashier).')
c = c.replace('Menghilangkan kebutuhan waitress secara drastis.', 'Drastically eliminates the need for waitresses.')
c = c.replace('Mengubah identitas brand dan berisiko ditolak pelanggan lama.', 'Changes brand identity and risks being rejected by old customers.')

c = c.replace('Buka Cloud Kitchen.', 'Open Cloud Kitchen.')
c = c.replace('Gunakan kapasitas dapur yang menganggur di luar jam sibuk untuk menjual brand virtual online baru.', 'Use idle kitchen capacity outside peak hours to sell new virtual online brands.')
c = c.replace('Meningkatkan revenue tanpa menambah biaya sewa (overhead).', 'Increases revenue without adding rent (overhead) costs.')
c = c.replace('Membutuhkan riset menu baru dan budget marketing tambahan.', 'Requires new menu research and additional marketing budget.')

c = c.replace('Berikan Bonus / Insentif.', 'Give Bonus / Incentive.')
c = c.replace('Alokasikan sebagian surplus margin untuk bonus karyawan agar mereka merasa dihargai.', 'Allocate a portion of margin surplus for employee bonuses so they feel appreciated.')
c = c.replace('Menurunkan angka turnover dan menjaga kualitas layanan.', 'Reduces turnover rate and maintains service quality.')
c = c.replace('Menjadi biaya tetap baru jika tidak dibingkai sebagai "bonus bersyarat".', 'Becomes a new fixed cost if not framed as a "conditional bonus".')

c = c.replace('Perpanjang Jam Operasional.', 'Extend Operational Hours.')
c = c.replace('Mengingat margin sangat sehat, pertimbangkan buka lebih pagi (sarapan) atau lebih malam (midnight).', 'Given the very healthy margin, consider opening earlier (breakfast) or later (midnight).')
c = c.replace('Maksimalisasi utilisasi alat dan sewa gedung.', 'Maximizes utilization of equipment and building rent.')
c = c.replace('Harus berhati-hati agar beban SDM (lembur) tidak menggerus margin sehat ini.', 'Must be careful so that HR load (overtime) does not erode this healthy margin.')

f.write_text(c)
