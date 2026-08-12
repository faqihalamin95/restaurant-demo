from pathlib import Path
import re

f = Path('/home/faqih/projects/restaurant-demo/evidence_en/pages/02-branch-performance/deepdive.md')
c = f.read_text()

# Labor Advisor
c = c.replace('Opsi A: Defensif Pemotongan', 'Option A: Defensive Cut')
c = c.replace('Potong Jam Shift.', 'Cut Shift Hours.')
c = c.replace('Kurangi jam kerja part-time di luar jam sibuk.', 'Reduce part-time hours outside peak hours.')
c = c.replace('Mengembalikan rasio biaya SDM dengan sangat cepat.', 'Restores Labor Cost ratio very quickly.')
c = c.replace('Risiko antrean panjang jika traffic mendadak ramai.', 'Risk of long queues if traffic suddenly gets busy.')
c = c.replace('Opsi B: Penundaan Rekrutmen', 'Option B: Recruitment Delay')
c = c.replace('Tahan Hiring Baru.', 'Hold New Hiring.')
c = c.replace('Bekukan sementara rekrutmen karyawan baru atau pengganti (replacement) hingga revenue stabil.', 'Temporarily freeze recruitment of new or replacement employees until revenue stabilizes.')
c = c.replace('Mencegah biaya SDM tetap membesar secara permanen.', 'Prevents fixed Labor Costs from expanding permanently.')
c = c.replace('Staf lama yang ada akan kelelahan (burnout) jika dibiarkan terlalu lama.', 'Existing veteran staff will suffer burnout if left too long.')

# Overhead Advisor
c = c.replace('Opsi A: Efisiensi Utilitas', 'Option A: Utility Efficiency')
c = c.replace('Audit Listrik & Air.', 'Electricity & Water Audit.')
c = c.replace('Matikan sebagian AC dan lampu di area yang tidak terpakai, perketat SOP cuci piring.', 'Turn off some AC and lights in unused areas, tighten dishwashing SOP.')
c = c.replace('Efisiensi murni tanpa mengorbankan kualitas produk.', 'Pure efficiency without sacrificing product quality.')
c = c.replace('Penghematan seringkali tidak signifikan untuk menyelamatkan margin secara keseluruhan.', 'Savings are often insignificant to save the overall margin.')

# Cashcow Advisor
c = c.replace('Opsi A: Replikasi Sukses', 'Option A: Success Replication')
c = c.replace('Jadikan Benchmark.', 'Make it a Benchmark.')
c = c.replace('Dokumentasikan SOP operasional location ini dan terapkan di location yang sedang krisis (Turnaround).', 'Document the operational SOP of this location and apply it to locations in crisis (Turnaround).')
c = c.replace('Mentransfer knowledge sukses tanpa biaya tambahan.', 'Transfer success knowledge without additional costs.')
c = c.replace('Tidak semua faktor sukses bisa direplikasi (misal: lokasi demografis).', 'Not all success factors can be replicated (e.g., demographic location).')

f.write_text(c)
