"""
Restaurant Demo (ID) - Synthetic Data Generator
================================================
Generates realistic restaurant transaction data relative to today's date.

Modes:
  --mode backfill   Generate from 2024-01-01 up to yesterday. Run once.
  --mode daily      Generate yesterday only, append to existing CSVs.

Usage:
    python generate_data.py --mode backfill
    python generate_data.py --mode daily

Output: data/raw/
    branches.csv, menu_items.csv, employees.csv, members.csv,
    employee_attendance.csv, orders.csv, order_items.csv,
    employee_compensation.csv, inventory_catalog.csv,
    inventory_transactions.csv, branch_daily_operational_costs.csv
"""

import argparse
import os
import random
from datetime import date, datetime, timedelta
from pathlib import Path

import numpy as np
import pandas as pd

# ── Reproducibility ───────────────────────────────────────────────────────────
BASE_SEED = 42

# ── Config ────────────────────────────────────────────────────────────────────
ROOT_DIR   = Path(__file__).parent.parent
OUTPUT_DIR = ROOT_DIR / "data" / "raw"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

TODAY          = date.today()
YESTERDAY      = TODAY - timedelta(days=1)
BACKFILL_START = date(2024, 1, 1)   # ← hardcoded, 2 tahun ke belakang


# ── SEASONALITY INDONESIA ─────────────────────────────────────────────────────
# (start, end, revenue_multiplier)
# Ramadan: traffic siang turun, malam naik → net -12%
# Lebaran H-1 s/d H+3: orang pulang kampung → drop -55%
# Recovery pasca lebaran: rebound +10%
# Liburan sekolah: naik +12%
# Tahun baru: naik +10%

SEASONALITY_CALENDAR = [
    # Ramadan 2024 (11 Mar – 9 Apr)
    (date(2024,  3, 11), date(2024,  4,  9), 0.88),
    # Lebaran 2024
    (date(2024,  4, 10), date(2024,  4, 14), 0.45),
    # Recovery pasca lebaran 2024
    (date(2024,  4, 15), date(2024,  4, 21), 1.10),
    # Liburan sekolah Jun-Jul 2024
    (date(2024,  6, 22), date(2024,  7, 14), 1.12),
    # Libur Natal & akhir tahun 2024
    (date(2024, 12, 21), date(2024, 12, 31), 1.15),
    # Tahun Baru 2025
    (date(2025,  1,  1), date(2025,  1,  5), 1.10),
    # Ramadan 2025 (1–30 Mar)
    (date(2025,  3,  1), date(2025,  3, 30), 0.88),
    # Lebaran 2025
    (date(2025,  3, 31), date(2025,  4,  4), 0.45),
    # Recovery pasca lebaran 2025
    (date(2025,  4,  5), date(2025,  4, 11), 1.10),
    # Liburan sekolah Jun-Jul 2025
    (date(2025,  6, 21), date(2025,  7, 13), 1.12),
    # Libur Natal & akhir tahun 2025
    (date(2025, 12, 20), date(2025, 12, 31), 1.15),
    # Tahun Baru 2026
    (date(2026,  1,  1), date(2026,  1,  4), 1.10),
    # Ramadan 2026 (18 Feb – 19 Mar)
    (date(2026,  2, 18), date(2026,  3, 19), 0.88),
    # Lebaran 2026
    (date(2026,  3, 20), date(2026,  3, 24), 0.45),
    # Recovery pasca lebaran 2026
    (date(2026,  3, 25), date(2026,  3, 31), 1.10),
]

def get_seasonality_multiplier(target_date: date) -> float:
    for start, end, multiplier in SEASONALITY_CALENDAR:
        if start <= target_date <= end:
            return multiplier
    return 1.0


# ── INFLASI BAHAN BAKU ────────────────────────────────────────────────────────
def get_inflation_factor(target_date: date) -> float:
    """Inflasi gradual ~10%/tahun dihitung dari BACKFILL_START."""
    months_elapsed = (
        (target_date.year  - BACKFILL_START.year)  * 12
        + (target_date.month - BACKFILL_START.month)
    )
    monthly_rate = 0.10 / 12
    return (1 + monthly_rate) ** months_elapsed


# ── 1. BRANCHES ───────────────────────────────────────────────────────────────

def get_branch_multiplier(branch_id: str, target_date: date) -> float:
    months_elapsed = (
        (target_date.year  - BACKFILL_START.year)  * 12
        + (target_date.month - BACKFILL_START.month)
    )

    if branch_id == "BR01":
        # Cabang Pusat — stable flagship, sedikit growth tahun ke-2
        growth = [
            1.00, 1.00, 1.00, 1.00, 1.00, 1.00,  # Jan–Jun 2024
            1.00, 1.00, 1.00, 1.01, 1.01, 1.02,  # Jul–Des 2024
            1.02, 1.03, 1.03, 1.03, 1.04, 1.04,  # Jan–Jun 2025
            1.04, 1.05, 1.05, 1.05, 1.06, 1.06,  # Jul–Des 2025
        ]
        return growth[min(months_elapsed, len(growth) - 1)]

    elif branch_id == "BR02":
        # Cabang Selatan — consistent growth 2 tahun
        growth = [
            0.70, 0.74, 0.78, 0.81, 0.84, 0.87,  # Jan–Jun 2024
            0.90, 0.93, 0.95, 0.97, 1.00, 1.03,  # Jul–Des 2024
            1.05, 1.07, 1.08, 1.09, 1.10, 1.11,  # Jan–Jun 2025
            1.12, 1.13, 1.14, 1.15, 1.16, 1.17,  # Jul–Des 2025
        ]
        return growth[min(months_elapsed, len(growth) - 1)]

    elif branch_id == "BR03":
        # Cabang Utara — buka Apr 2024 (month 3), ramp-up panjang
        if months_elapsed < 3:
            return 0.0
        ramp = [
            0.40, 0.50, 0.58, 0.64, 0.68, 0.72,  # Apr–Sep 2024
            0.75, 0.78, 0.80, 0.82, 0.84, 0.86,  # Okt–Mar 2025
            0.88, 0.90, 0.91, 0.92, 0.93, 0.94,  # Apr–Sep 2025
            0.95, 0.96, 0.97, 0.97,               # Okt–Jan 2026
        ]
        return ramp[min(months_elapsed - 3, len(ramp) - 1)]

    elif branch_id == "BR04":
        # Cabang Timur — drop bulan 6-8 (kompetitor buka), recovery, lalu stabil
        scenario = {
            0:  0.85, 1:  0.85, 2:  0.85, 3:  0.85, 4:  0.85, 5:  0.85,
            6:  0.60, 7:  0.55, 8:  0.58,                              # drop
            9:  0.70, 10: 0.78, 11: 0.83,                              # recovery
            12: 0.86, 13: 0.87, 14: 0.88, 15: 0.88, 16: 0.89, 17: 0.89,
            18: 0.90, 19: 0.90, 20: 0.91, 21: 0.91, 22: 0.92, 23: 0.92,
        }
        return scenario.get(months_elapsed, 0.92)

    return 1.0


BRANCHES = [
    {"branch_id": "BR01", "name": "Cabang Pusat",   "location": "Jakarta Selatan",
     "opened_date": str(BACKFILL_START)},
    {"branch_id": "BR02", "name": "Cabang Selatan", "location": "Depok",
     "opened_date": str(BACKFILL_START)},
    {"branch_id": "BR03", "name": "Cabang Utara",   "location": "Bekasi",
     "opened_date": str(date(2024, 4, 1))},   # ← buka Apr 2024, hardcoded
    {"branch_id": "BR04", "name": "Cabang Timur",   "location": "Tangerang",
     "opened_date": str(BACKFILL_START)},
]

MENU_ITEMS = [
    {"menu_id": "M01", "name": "Ayam Bakar Madu",    "category": "main",    "price": 35000,  "is_active": True, "note": "bestseller"},
    {"menu_id": "M02", "name": "Ayam Goreng Kremes", "category": "main",    "price": 30000,  "is_active": True, "note": "stable"},
    {"menu_id": "M03", "name": "Ayam Geprek Pedas",  "category": "main",    "price": 28000,  "is_active": True, "note": "declining"},
    {"menu_id": "M04", "name": "Nasi Ayam Lalapan",  "category": "main",    "price": 32000,  "is_active": True, "note": "stable"},
    {"menu_id": "M05", "name": "Paket Keluarga (4)", "category": "main",    "price": 110000, "is_active": True, "note": "weekend_spike"},
    {"menu_id": "M06", "name": "Ayam Penyet Sambal", "category": "main",    "price": 29000,  "is_active": True, "note": "declining"},
    {"menu_id": "M07", "name": "Es Teh Manis",       "category": "drink",   "price": 8000,   "is_active": True, "note": "stable"},
    {"menu_id": "M08", "name": "Es Jeruk Peras",     "category": "drink",   "price": 12000,  "is_active": True, "note": "stable"},
    {"menu_id": "M09", "name": "Jus Alpukat",        "category": "drink",   "price": 18000,  "is_active": True, "note": "stable"},
    {"menu_id": "M10", "name": "Air Mineral",        "category": "drink",   "price": 5000,   "is_active": True, "note": "stable"},
    {"menu_id": "M11", "name": "Tempe Mendoan",      "category": "snack",   "price": 12000,  "is_active": True, "note": "stable"},
    {"menu_id": "M12", "name": "Tahu Goreng",        "category": "snack",   "price": 10000,  "is_active": True, "note": "stable"},
    {"menu_id": "M13", "name": "Kerupuk Udang",      "category": "snack",   "price": 7000,   "is_active": True, "note": "stable"},
    {"menu_id": "M14", "name": "Puding Coklat",      "category": "dessert", "price": 15000,  "is_active": True, "note": "hidden_gem"},
    {"menu_id": "M15", "name": "Es Krim Vanilla",    "category": "dessert", "price": 12000,  "is_active": True, "note": "stable"},
    {"menu_id": "M16", "name": "Pisang Goreng Keju", "category": "dessert", "price": 14000,  "is_active": True, "note": "stable"},
]

SHIFTS = [
    {"shift_id": "S1", "shift_name": "Pagi",  "start_hour": 8,  "end_hour": 15},
    {"shift_id": "S2", "shift_name": "Siang", "start_hour": 12, "end_hour": 20},
    {"shift_id": "S3", "shift_name": "Malam", "start_hour": 16, "end_hour": 23},
]

INVENTORY_CATALOG = [
    {"inventory_id": "INV01", "item_name": "Daging Ayam Fillet", "category": "protein", "unit": "kg",     "base_unit_cost": 58000},
    {"inventory_id": "INV02", "item_name": "Beras Premium",      "category": "grain",   "unit": "kg",     "base_unit_cost": 15000},
    {"inventory_id": "INV03", "item_name": "Minyak Goreng",      "category": "oil",     "unit": "liter",  "base_unit_cost": 19000},
    {"inventory_id": "INV04", "item_name": "Cabai Rawit",        "category": "produce", "unit": "kg",     "base_unit_cost": 42000},
    {"inventory_id": "INV05", "item_name": "Bawang Putih",       "category": "produce", "unit": "kg",     "base_unit_cost": 32000},
    {"inventory_id": "INV06", "item_name": "Teh Celup",          "category": "drink",   "unit": "box",    "base_unit_cost": 26000},
    {"inventory_id": "INV07", "item_name": "Jeruk Peras",        "category": "produce", "unit": "kg",     "base_unit_cost": 30000},
    {"inventory_id": "INV08", "item_name": "LPG 12kg",           "category": "utility", "unit": "tabung", "base_unit_cost": 205000},
]

EMPLOYEE_NAMES = [
    "Andi Pratama", "Budi Santoso", "Citra Lestari", "Dewi Anggraini",
    "Eka Saputra", "Fajar Nugroho", "Gita Maharani", "Hendra Kurniawan",
    "Intan Permata", "Joko Susilo", "Kiki Amelia", "Lukman Hakim",
    "Maya Sari", "Nadia Ramadhani", "Oki Prasetyo", "Putri Nabila",
    "Rizky Maulana", "Sari Wulandari", "Tono Wijaya", "Vina Kartika",
    "Wahyu Firmansyah", "Yuni Astuti", "Zaki Abdullah", "Bella Ananda",
    "Chandra Prabowo", "Dimas Akbar", "Erika Putri", "Fina Azzahra",
    "Galih Setiawan", "Hanif Fauzan", "Indra Setia", "Jihan Rahma",
]

menu_notes  = {m["menu_id"]: m["note"]  for m in MENU_ITEMS}
menu_prices = {m["menu_id"]: m["price"] for m in MENU_ITEMS}
menu_ids    = [m["menu_id"] for m in MENU_ITEMS]

# Members — signup tersebar selama 2 tahun
MEMBERS = []
for i in range(1, 701):
    signup_date = BACKFILL_START + timedelta(days=random.randint(0, 700))
    if signup_date > YESTERDAY:
        signup_date = YESTERDAY
    tier = random.choices(
        ["Bronze", "Silver", "Gold"],
        weights=[0.58, 0.30, 0.12],
    )[0]
    MEMBERS.append({
        "member_id":   f"MBR{i:04d}",
        "member_name": f"Pelanggan Member {i:04d}",
        "gender":      random.choice(["M", "F"]),
        "birth_year":  random.randint(1975, 2005),
        "city":        random.choice(["Jakarta", "Depok", "Bekasi", "Tangerang", "Bogor"]),
        "join_date":   str(signup_date),
        "tier":        tier,
        "is_active":   random.choices([True, False], weights=[0.93, 0.07])[0],
    })

EMPLOYEES = []
EMPLOYEE_COMPENSATION = []
employee_branch_map = {}
for branch in BRANCHES:
    for _ in range(8):
        emp_idx     = len(EMPLOYEES) + 1
        opened_date = datetime.strptime(branch["opened_date"], "%Y-%m-%d").date()
        start_date  = opened_date + timedelta(days=random.randint(0, 60))
        shift_id    = random.choices(["S1", "S2", "S3"], weights=[0.35, 0.40, 0.25])[0]
        employee_id = f"EMP{emp_idx:04d}"
        EMPLOYEES.append({
            "employee_id":       employee_id,
            "employee_name":     EMPLOYEE_NAMES[(emp_idx - 1) % len(EMPLOYEE_NAMES)],
            "branch_id":         branch["branch_id"],
            "role":              random.choices(
                                     ["kasir", "pramusaji", "supervisor"],
                                     weights=[0.45, 0.40, 0.15],
                                 )[0],
            "assigned_shift_id": shift_id,
            "start_date":        str(start_date),
            "is_active":         random.choices([True, False], weights=[0.96, 0.04])[0],
        })
        EMPLOYEE_COMPENSATION.append({
            "employee_id":          employee_id,
            "branch_id":            branch["branch_id"],
            "base_salary_monthly":  random.choice([3500000, 3800000, 4000000, 4300000, 4700000]),
            "meal_allowance_daily": random.choice([25000, 30000, 35000]),
            "overtime_rate_hourly": random.choice([22000, 25000, 28000]),
            "effective_from":       str(start_date),
        })
        employee_branch_map.setdefault(branch["branch_id"], []).append(employee_id)


# ── 2. HELPERS ────────────────────────────────────────────────────────────────

def get_hour_weight(hour: int) -> float:
    weights = {
        8: 0.5, 9: 0.6, 10: 0.7, 11: 1.2,
        12: 2.5, 13: 2.3, 14: 1.0, 15: 0.8,
        16: 0.7, 17: 1.1, 18: 2.2, 19: 2.5,
        20: 2.0, 21: 1.2, 22: 0.5
    }
    return weights.get(hour, 0.3)


def get_menu_weight(menu_id: str, months_elapsed: int, is_weekend: bool) -> float:
    note = menu_notes.get(menu_id, "stable")
    if note == "bestseller":
        return 3.0
    elif note == "declining":
        if months_elapsed >= 8:
            return max(0.3, 1.5 - (months_elapsed - 7) * 0.25)
        return 1.5
    elif note == "weekend_spike":
        return 3.5 if is_weekend else 0.8
    elif note == "hidden_gem":
        return 0.3
    return 1.0


def get_base_orders(branch_id: str, target_date: date) -> int:
    branch_multiplier  = get_branch_multiplier(branch_id, target_date)
    if branch_multiplier == 0.0:
        return 0
    seasonality = get_seasonality_multiplier(target_date)
    base = {"BR01": 90, "BR02": 65, "BR03": 50, "BR04": 70}[branch_id]
    if target_date.weekday() >= 5:
        base = int(base * 1.3)
    return max(int(base * branch_multiplier * seasonality * np.random.uniform(0.88, 1.12)), 0)


def get_payment_method() -> str:
    return random.choices(
        ["qris", "cash", "card", None],
        weights=[0.50, 0.35, 0.12, 0.03]
    )[0]


def get_order_type(hour: int) -> str:
    if hour in [12, 13, 18, 19, 20]:
        return random.choices(["dine_in", "delivery", "takeaway"], weights=[0.45, 0.35, 0.20])[0]
    elif hour in [14, 15, 16]:
        return random.choices(["dine_in", "delivery", "takeaway"], weights=[0.30, 0.20, 0.50])[0]
    return random.choices(["dine_in", "delivery", "takeaway"], weights=[0.50, 0.25, 0.25])[0]


def infer_shift_id(hour: int) -> str:
    if 8 <= hour <= 11:
        return "S1"
    if 12 <= hour <= 15:
        return random.choices(["S1", "S2"], weights=[0.40, 0.60])[0]
    if 16 <= hour <= 20:
        return random.choices(["S2", "S3"], weights=[0.55, 0.45])[0]
    return "S3"


def get_off_days(employee_id: str) -> set:
    seed_val = int(employee_id[3:])
    rng = random.Random(seed_val)
    n_off = rng.choices([1, 2], weights=[0.4, 0.6])[0]
    return set(rng.sample(range(7), n_off))


def build_attendance_for_dates(date_range: list) -> pd.DataFrame:
    rows = []
    emp_off_days = {emp["employee_id"]: get_off_days(emp["employee_id"]) for emp in EMPLOYEES}

    for target_date in date_range:
        is_weekend  = target_date.weekday() >= 5
        day_of_week = target_date.weekday()

        for emp in EMPLOYEES:
            start_date = datetime.strptime(emp["start_date"], "%Y-%m-%d").date()
            if target_date < start_date:
                continue
            if not emp["is_active"] and target_date > YESTERDAY - timedelta(days=60):
                continue
            if day_of_week in emp_off_days[emp["employee_id"]]:
                continue

            attendance_status = random.choices(
                ["present", "late", "leave", "absent"],
                weights=[0.82, 0.10, 0.04, 0.04] if not is_weekend else [0.78, 0.12, 0.03, 0.07],
            )[0]
            overtime_hours = 0
            if attendance_status in ("present", "late"):
                overtime_hours = random.choices([0, 1, 2], weights=[0.78, 0.17, 0.05])[0]

            rows.append({
                "attendance_id":   f"ATD{target_date.strftime('%Y%m%d')}{emp['employee_id'][3:]}",
                "attendance_date": str(target_date),
                "employee_id":     emp["employee_id"],
                "branch_id":       emp["branch_id"],
                "shift_id":        emp["assigned_shift_id"],
                "status":          attendance_status,
                "overtime_hours":  overtime_hours,
            })

    return pd.DataFrame(rows)


# ── 3. CORE GENERATOR ────────────────────────────────────────────────────────

def generate_for_dates(date_range: list) -> tuple:
    hours        = list(range(8, 23))
    hour_weights = [get_hour_weight(h) for h in hours]

    orders_rows = []
    items_rows  = []

    emp_off_days  = {emp["employee_id"]: get_off_days(emp["employee_id"]) for emp in EMPLOYEES}
    order_counter = int(date_range[0].strftime("%Y%m%d")) * 100000
    oi_counter    = order_counter * 10

    for target_date in date_range:
        np.random.seed(BASE_SEED + int(target_date.strftime("%Y%m%d")))
        random.seed(BASE_SEED + int(target_date.strftime("%Y%m%d")))

        day_of_week = target_date.weekday()

        available_handlers = {}
        for emp in EMPLOYEES:
            start_date = datetime.strptime(emp["start_date"], "%Y-%m-%d").date()
            if target_date < start_date:
                continue
            if not emp["is_active"] and target_date > YESTERDAY - timedelta(days=60):
                continue
            if day_of_week in emp_off_days[emp["employee_id"]]:
                continue
            available_handlers.setdefault(emp["branch_id"], []).append(emp["employee_id"])

        months_elapsed = (
            (target_date.year  - BACKFILL_START.year)  * 12
            + (target_date.month - BACKFILL_START.month)
        )
        is_weekend = target_date.weekday() >= 5

        for branch in BRANCHES:
            branch_id = branch["branch_id"]
            n_orders  = get_base_orders(branch_id, target_date)
            if n_orders == 0:
                continue

            chosen_hours = random.choices(hours, weights=hour_weights, k=n_orders)

            for hour in chosen_hours:
                ts       = datetime(
                    target_date.year, target_date.month, target_date.day,
                    hour, random.randint(0, 59), random.randint(0, 59)
                )
                order_id = f"ORD{order_counter:010d}"

                orders_rows.append({
                    "order_id":            order_id,
                    "branch_id":           branch_id,
                    "order_time":          ts.strftime("%Y-%m-%d %H:%M:%S"),
                    "payment_method":      get_payment_method(),
                    "order_type":          get_order_type(hour),
                    "shift_id":            infer_shift_id(hour),
                    "handler_employee_id": random.choice(
                        available_handlers.get(branch_id) or employee_branch_map[branch_id]
                    ),
                    "member_id": random.choices(
                        [None] + [m["member_id"] for m in MEMBERS],
                        weights=[0.62] + [0.38 / len(MEMBERS)] * len(MEMBERS)
                    )[0],
                })

                n_items      = random.choices([1, 2, 3, 4], weights=[0.30, 0.40, 0.20, 0.10])[0]
                item_weights = [get_menu_weight(m, months_elapsed, is_weekend) for m in menu_ids]
                selected     = random.choices(menu_ids, weights=item_weights, k=n_items)

                for menu_id in selected:
                    qty = random.choices([1, 2, 3], weights=[0.70, 0.25, 0.05])[0]
                    items_rows.append({
                        "order_item_id": f"OI{oi_counter:011d}",
                        "order_id":      order_id,
                        "menu_id":       menu_id,
                        "qty":           qty,
                        "subtotal":      menu_prices[menu_id] * qty,
                    })
                    oi_counter += 1

                order_counter += 1

    return pd.DataFrame(orders_rows), pd.DataFrame(items_rows)


def generate_inventory_for_dates(date_range: list) -> pd.DataFrame:
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

    return pd.DataFrame(rows)


def generate_operational_costs_for_dates(date_range: list) -> pd.DataFrame:
    rows = []
    for target_date in date_range:
        np.random.seed(BASE_SEED + 13 + int(target_date.strftime("%Y%m%d")))
        random.seed(BASE_SEED + 13 + int(target_date.strftime("%Y%m%d")))
        days_in_month = (
            target_date.replace(day=28) + timedelta(days=4)
        ).replace(day=1) - timedelta(days=1)

        # Sewa naik ~5% per tahun mulai 2025
        rent_inflation = 1.05 if target_date.year >= 2025 else 1.0

        for branch in BRANCHES:
            rent_monthly = {
                "BR01": 30_000_000,
                "BR02": 22_000_000,
                "BR03": 18_000_000,
                "BR04": 25_000_000,
            }[branch["branch_id"]]

            open_date = datetime.strptime(branch["opened_date"], "%Y-%m-%d").date()
            if target_date < open_date:
                continue

            rows.append({
                "cost_date":            str(target_date),
                "branch_id":            branch["branch_id"],
                "building_rent_daily":  int(rent_monthly * rent_inflation / days_in_month.day),
                "water_cost":           int(np.random.uniform(150_000, 250_000)),
                "electricity_cost":     int(np.random.uniform(300_000, 600_000)),
                "other_utilities_cost": int(np.random.uniform(50_000, 100_000)),
            })

    return pd.DataFrame(rows)


# ── 4. DIMENSION TABLES ───────────────────────────────────────────────────────

def write_dimensions():
    pd.DataFrame(BRANCHES).to_csv(OUTPUT_DIR / "branches.csv", index=False)
    pd.DataFrame([{k: v for k, v in m.items() if k != "note"} for m in MENU_ITEMS]).to_csv(
        OUTPUT_DIR / "menu_items.csv", index=False
    )
    pd.DataFrame(EMPLOYEES).to_csv(OUTPUT_DIR / "employees.csv", index=False)
    pd.DataFrame(MEMBERS).to_csv(OUTPUT_DIR / "members.csv", index=False)
    pd.DataFrame(SHIFTS).to_csv(OUTPUT_DIR / "shifts.csv", index=False)
    pd.DataFrame(EMPLOYEE_COMPENSATION).to_csv(OUTPUT_DIR / "employee_compensation.csv", index=False)
    pd.DataFrame(INVENTORY_CATALOG).to_csv(OUTPUT_DIR / "inventory_catalog.csv", index=False)
    print(f"✓ branches.csv              — {len(BRANCHES)} rows")
    print(f"✓ menu_items.csv            — {len(MENU_ITEMS)} rows")
    print(f"✓ employees.csv             — {len(EMPLOYEES)} rows")
    print(f"✓ members.csv               — {len(MEMBERS)} rows")
    print(f"✓ shifts.csv                — {len(SHIFTS)} rows")
    print(f"✓ employee_compensation.csv — {len(EMPLOYEE_COMPENSATION)} rows")
    print(f"✓ inventory_catalog.csv     — {len(INVENTORY_CATALOG)} rows")


# ── 5. MODES ──────────────────────────────────────────────────────────────────

def run_backfill():
    print(f"▶ Backfill: {BACKFILL_START} → {YESTERDAY}")
    write_dimensions()

    date_range = [
        BACKFILL_START + timedelta(days=i)
        for i in range((YESTERDAY - BACKFILL_START).days + 1)
    ]
    orders_df, items_df = generate_for_dates(date_range)
    attendance_df       = build_attendance_for_dates(date_range)
    inventory_df        = generate_inventory_for_dates(date_range)
    branch_cost_df      = generate_operational_costs_for_dates(date_range)

    orders_df.to_csv(OUTPUT_DIR / "orders.csv",                          index=False)
    items_df.to_csv(OUTPUT_DIR / "order_items.csv",                      index=False)
    attendance_df.to_csv(OUTPUT_DIR / "employee_attendance.csv",         index=False)
    inventory_df.to_csv(OUTPUT_DIR / "inventory_transactions.csv",       index=False)
    branch_cost_df.to_csv(OUTPUT_DIR / "branch_daily_operational_costs.csv", index=False)

    print(f"✓ orders.csv                         — {len(orders_df):,} rows")
    print(f"✓ order_items.csv                    — {len(items_df):,} rows")
    print(f"✓ employee_attendance.csv            — {len(attendance_df):,} rows")
    print(f"✓ inventory_transactions.csv         — {len(inventory_df):,} rows")
    print(f"✓ branch_daily_operational_costs.csv — {len(branch_cost_df):,} rows")
    _sanity_check(orders_df, items_df)
    print("\n✅ Backfill complete.")


def run_daily():
    print(f"▶ Daily append: {YESTERDAY}")

    orders_path      = OUTPUT_DIR / "orders.csv"
    items_path       = OUTPUT_DIR / "order_items.csv"
    attendance_path  = OUTPUT_DIR / "employee_attendance.csv"
    inventory_path   = OUTPUT_DIR / "inventory_transactions.csv"
    branch_cost_path = OUTPUT_DIR / "branch_daily_operational_costs.csv"

    if not orders_path.exists():
        print("✗ No existing data. Run --mode backfill first.")
        return

    existing = pd.read_csv(orders_path, usecols=["order_time"])
    if existing["order_time"].str.startswith(str(YESTERDAY)).any():
        print(f"⚠ Data for {YESTERDAY} already exists. Skipping.")
        return

    orders_df, items_df = generate_for_dates([YESTERDAY])
    attendance_df       = build_attendance_for_dates([YESTERDAY])
    inventory_df        = generate_inventory_for_dates([YESTERDAY])
    branch_cost_df      = generate_operational_costs_for_dates([YESTERDAY])

    orders_df.to_csv(orders_path,      mode="a", header=False, index=False)
    items_df.to_csv(items_path,        mode="a", header=False, index=False)
    attendance_df.to_csv(attendance_path, mode="a", header=False, index=False)
    inventory_df.to_csv(inventory_path,   mode="a", header=not inventory_path.exists(), index=False)
    branch_cost_df.to_csv(branch_cost_path, mode="a", header=not branch_cost_path.exists(), index=False)

    print(f"✓ Appended {len(orders_df):,} orders")
    print(f"✓ Appended {len(items_df):,} order items")
    print(f"✓ Appended {len(attendance_df):,} attendance rows")
    print(f"✓ Appended {len(inventory_df):,} inventory rows")
    print(f"✓ Appended {len(branch_cost_df):,} operational cost rows")
    print("\n✅ Daily append complete.")


# ── 6. SANITY CHECK ───────────────────────────────────────────────────────────

def _sanity_check(orders_df: pd.DataFrame, items_df: pd.DataFrame):
    print("\n── Sanity Check ──────────────────────────────────────────────────")
    merged = items_df.merge(orders_df[["order_id", "branch_id"]], on="order_id")
    rev    = (merged.groupby("branch_id")["subtotal"].sum()
              .reset_index().rename(columns={"subtotal": "revenue"}))
    rev["revenue"] = rev["revenue"].apply(lambda x: f"Rp {x:,.0f}")
    print("\nRevenue per branch:")
    print(rev.to_string(index=False))

    null_pct = orders_df["payment_method"].isna().mean() * 100
    print(f"\nNull payment_method: {null_pct:.1f}%")

    counts = (items_df.groupby("menu_id")["qty"].sum()
              .reset_index().sort_values("qty", ascending=False))
    print("\nTop 3 menu:")
    print(counts.head(3).to_string(index=False))
    print("Bottom 3 menu (M14 = hidden gem):")
    print(counts.tail(3).to_string(index=False))


# ── 7. ENTRYPOINT ─────────────────────────────────────────────────────────────

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Restaurant (ID) data generator")
    parser.add_argument("--mode", choices=["backfill", "daily"], required=True)
    args = parser.parse_args()

    if args.mode == "backfill":
        run_backfill()
    else:
        run_daily()