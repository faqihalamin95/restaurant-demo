"""
Patch: Tambahkan stock_on_hand ke generate_inventory_for_dates
=============================================================
Jalankan dari root project:
    python patch_inventory_generator.py

Akan memodifikasi: ingestion/generate_data_id.py
Backup otomatis di:  ingestion/generate_data_id.py.bak
"""

import re
from pathlib import Path
import shutil

TARGET = Path("ingestion/generate_data_id.py")

if not TARGET.exists():
    raise FileNotFoundError(f"File tidak ditemukan: {TARGET}")

# Backup
shutil.copy(TARGET, TARGET.with_suffix(".py.bak"))
print(f"✓ Backup → {TARGET.with_suffix('.py.bak')}")

src = TARGET.read_text()

# ── 1. Ganti fungsi generate_inventory_for_dates ─────────────────────────────
OLD_FUNC = '''def generate_inventory_for_dates(date_range: list) -> pd.DataFrame:
    rows = []
    trx_counter = int(date_range[0].strftime("%Y%m%d")) * 10000
    for target_date in date_range:
        np.random.seed(BASE_SEED + 7 + int(target_date.strftime("%Y%m%d")))
        random.seed(BASE_SEED + 7 + int(target_date.strftime("%Y%m%d")))

        inflation = get_inflation_factor(target_date)   # ← inflasi gradual

        for branch in BRANCHES:
            for item in INVENTORY_CATALOG:
                if item["inventory_id"] == "INV08":
                    usage_qty = max(np.random.normal(loc=0.4, scale=0.1), 0.2)
                else:
                    usage_qty = max(np.random.normal(loc=7.5, scale=2.0), 1.2)
                if item["category"] in ("protein", "grain"):
                    usage_qty *= 1.35

                # Harga beli = base × inflasi × variasi harian supplier
                unit_cost = int(item["base_unit_cost"] * inflation * np.random.uniform(0.95, 1.08))

                rows.append({
                    "inventory_txn_id": f"ITX{trx_counter:011d}",
                    "txn_date":         str(target_date),
                    "branch_id":        branch["branch_id"],
                    "inventory_id":     item["inventory_id"],
                    "txn_type":         "usage",
                    "qty":              round(usage_qty, 2),
                    "unit_cost":        unit_cost,
                    "total_cost":       int(round(usage_qty * unit_cost, 0)),
                })
                trx_counter += 1

                if target_date.weekday() in (0, 3):
                    purchase_qty = usage_qty * np.random.uniform(2.1, 2.8)
                    rows.append({
                        "inventory_txn_id": f"ITX{trx_counter:011d}",
                        "txn_date":         str(target_date),
                        "branch_id":        branch["branch_id"],
                        "inventory_id":     item["inventory_id"],
                        "txn_type":         "purchase",
                        "qty":              round(purchase_qty, 2),
                        "unit_cost":        unit_cost,
                        "total_cost":       int(round(purchase_qty * unit_cost, 0)),
                    })
                    trx_counter += 1

    return pd.DataFrame(rows)'''

NEW_FUNC = '''def generate_inventory_for_dates(date_range: list, initial_stock: dict = None) -> pd.DataFrame:
    """
    Generate transaksi inventori harian dengan saldo stok fisik (stock_on_hand).

    stock_on_hand = saldo fisik di gudang setelah semua transaksi hari itu selesai.
    Digunakan untuk menjawab tiga pertanyaan owner:
      1. Harga supplier wajar?   → unit_cost vs base_unit_cost
      2. Ada stok menumpuk?      → stock_on_hand jauh di atas rata-rata pakai harian
      3. Stok mana yang menipis? → stock_on_hand mendekati atau di bawah safety_stock_days
    """
    rows = []
    trx_counter = int(date_range[0].strftime("%Y%m%d")) * 10000

    # ── Inisialisasi saldo stok ─────────────────────────────────────────────
    # Saldo awal = 7–14 hari pemakaian rata-rata per item per cabang
    # Key: (branch_id, inventory_id) → float qty
    rng_init = random.Random(BASE_SEED + 999)
    stock_balance: dict = {}

    if initial_stock is not None:
        # Lanjutkan dari saldo akhir periode sebelumnya (mode daily)
        stock_balance = dict(initial_stock)
    else:
        # Backfill: generate opening stock realistis
        for branch in BRANCHES:
            for item in INVENTORY_CATALOG:
                key = (branch["branch_id"], item["inventory_id"])
                # Opening = 7–14 hari pemakaian harian estimasi
                base_daily = 0.4 if item["inventory_id"] == "INV08" else 7.5
                if item["category"] in ("protein", "grain"):
                    base_daily *= 1.35
                days_on_hand = rng_init.uniform(7, 14)
                stock_balance[key] = round(base_daily * days_on_hand, 2)

    # ── Safety stock threshold (hari) ───────────────────────────────────────
    # Dipakai untuk menentukan apakah stok "menipis" (low stock alert)
    SAFETY_DAYS = 3  # stok < 3 hari pemakaian = perlu beli

    for target_date in date_range:
        np.random.seed(BASE_SEED + 7 + int(target_date.strftime("%Y%m%d")))
        random.seed(BASE_SEED + 7 + int(target_date.strftime("%Y%m%d")))

        inflation = get_inflation_factor(target_date)

        for branch in BRANCHES:
            for item in INVENTORY_CATALOG:
                key = (branch["branch_id"], item["inventory_id"])

                # ── Hitung usage ────────────────────────────────────────────
                if item["inventory_id"] == "INV08":
                    usage_qty = max(np.random.normal(loc=0.4, scale=0.1), 0.2)
                else:
                    usage_qty = max(np.random.normal(loc=7.5, scale=2.0), 1.2)
                if item["category"] in ("protein", "grain"):
                    usage_qty *= 1.35
                usage_qty = round(usage_qty, 2)

                unit_cost = int(item["base_unit_cost"] * inflation * np.random.uniform(0.95, 1.08))

                # ── Hitung purchase ─────────────────────────────────────────
                purchase_qty = 0.0
                if target_date.weekday() in (0, 3):
                    purchase_qty = round(usage_qty * np.random.uniform(2.1, 2.8), 2)

                # ── Update saldo stok fisik ─────────────────────────────────
                prev_stock = stock_balance.get(key, 0.0)
                closing_stock = max(0.0, prev_stock + purchase_qty - usage_qty)
                stock_balance[key] = closing_stock

                # ── Estimasi avg daily usage (pakai nilai konstan generator) ─
                avg_daily_usage = usage_qty  # proxy: hari ini representatif

                # ── Flag status stok ────────────────────────────────────────
                days_remaining = (closing_stock / avg_daily_usage) if avg_daily_usage > 0 else 99
                if days_remaining < SAFETY_DAYS:
                    stock_status = "low"        # perlu beli segera
                elif closing_stock > avg_daily_usage * 14:
                    stock_status = "overstock"  # menumpuk > 2 minggu pemakaian
                else:
                    stock_status = "ok"

                # ── Tulis baris usage ───────────────────────────────────────
                rows.append({
                    "inventory_txn_id": f"ITX{trx_counter:011d}",
                    "txn_date":         str(target_date),
                    "branch_id":        branch["branch_id"],
                    "inventory_id":     item["inventory_id"],
                    "txn_type":         "usage",
                    "qty":              usage_qty,
                    "unit_cost":        unit_cost,
                    "total_cost":       int(round(usage_qty * unit_cost, 0)),
                    "stock_on_hand":    closing_stock,      # ← BARU
                    "stock_status":     stock_status,       # ← BARU
                    "days_remaining":   round(days_remaining, 1),  # ← BARU
                })
                trx_counter += 1

                # ── Tulis baris purchase (jika ada) ─────────────────────────
                if purchase_qty > 0:
                    rows.append({
                        "inventory_txn_id": f"ITX{trx_counter:011d}",
                        "txn_date":         str(target_date),
                        "branch_id":        branch["branch_id"],
                        "inventory_id":     item["inventory_id"],
                        "txn_type":         "purchase",
                        "qty":              purchase_qty,
                        "unit_cost":        unit_cost,
                        "total_cost":       int(round(purchase_qty * unit_cost, 0)),
                        # purchase baris: stock_on_hand sama (sudah dihitung closing)
                        "stock_on_hand":    closing_stock,
                        "stock_status":     stock_status,
                        "days_remaining":   round(days_remaining, 1),
                    })
                    trx_counter += 1

    return pd.DataFrame(rows)'''

if OLD_FUNC not in src:
    print("⚠️  Tanda tangan fungsi tidak ditemukan persis — cek diff manual")
    print("   Mungkin sudah pernah dipatch sebelumnya, atau ada whitespace diff.")
else:
    src = src.replace(OLD_FUNC, NEW_FUNC)
    print("✓ Fungsi generate_inventory_for_dates diperbarui")

# ── 2. Patch run_daily() — teruskan saldo akhir ke panggilan berikutnya ──────
OLD_DAILY_CALL = '''    orders_df, items_df = generate_for_dates([YESTERDAY])
    attendance_df       = build_attendance_for_dates([YESTERDAY])
    inventory_df        = generate_inventory_for_dates([YESTERDAY])
    branch_cost_df      = generate_operational_costs_for_dates([YESTERDAY])'''

NEW_DAILY_CALL = '''    orders_df, items_df = generate_for_dates([YESTERDAY])
    attendance_df       = build_attendance_for_dates([YESTERDAY])

    # Baca saldo stok akhir dari CSV yang sudah ada agar kontinuitas terjaga
    _initial_stock = {}
    if inventory_path.exists():
        import pandas as _pd
        _prev = _pd.read_csv(inventory_path, usecols=[
            "branch_id", "inventory_id", "stock_on_hand"
        ]) if "stock_on_hand" in _pd.read_csv(inventory_path, nrows=0).columns else None
        if _prev is not None:
            _last = _prev.sort_values("stock_on_hand").drop_duplicates(
                subset=["branch_id", "inventory_id"], keep="last"
            )
            for _, row in _last.iterrows():
                _initial_stock[(row["branch_id"], row["inventory_id"])] = row["stock_on_hand"]

    inventory_df        = generate_inventory_for_dates([YESTERDAY], initial_stock=_initial_stock or None)
    branch_cost_df      = generate_operational_costs_for_dates([YESTERDAY])'''

if OLD_DAILY_CALL in src:
    src = src.replace(OLD_DAILY_CALL, NEW_DAILY_CALL)
    print("✓ run_daily() diperbarui — meneruskan saldo stok antar hari")
else:
    print("⚠️  Blok run_daily() tidak cocok persis — skip patch ini, cek manual")

# ── 3. Tulis hasil ────────────────────────────────────────────────────────────
TARGET.write_text(src)
print(f"\n✅ Patch selesai: {TARGET}")
print("\nLangkah berikutnya:")
print("  1. python ingestion/generate_data_id.py --mode backfill")
print("     (regenerate semua data dengan kolom baru)")
print("  2. python ingestion/load_raw.py --lang id")
print("  3. dbt build  (di folder dbt_restaurant/)")
print("\nKolom baru di tabel inventory_transactions:")
print("  stock_on_hand  — saldo fisik gudang setelah transaksi hari ini")
print("  stock_status   — 'ok' | 'low' | 'overstock'")
print("  days_remaining — estimasi berapa hari stok ini habis (qty/avg_daily_use)")
