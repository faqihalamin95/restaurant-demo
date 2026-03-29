"""
Restaurant Demo (ID) - Synthetic Data Generator
================================================
Generates realistic restaurant transaction data relative to today's date.

Modes:
  --mode backfill   Generate (today - 365 days) up to yesterday. Run once.
  --mode daily      Generate yesterday only, append to existing CSVs.

Usage:
    python generate_data.py --mode backfill
    python generate_data.py --mode daily

Output: data/raw/
    branches.csv, menu_items.csv, employees.csv, members.csv,
    employee_attendance.csv, orders.csv, order_items.csv
"""

import argparse
import os
import random
from datetime import date, datetime, timedelta
from pathlib import Path

import numpy as np
import pandas as pd

# ── Reproducibility ───────────────────────────────────────────────────────────
# Daily mode uses date-based seed so each day's data is deterministic
# but unique — rerunning the same day always gives the same rows.
BASE_SEED = 42

# ── Config ────────────────────────────────────────────────────────────────────
ROOT_DIR   = Path(__file__).parent.parent
OUTPUT_DIR = ROOT_DIR / "data" / "raw"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

TODAY          = date.today()
YESTERDAY      = TODAY - timedelta(days=1)
BACKFILL_START = TODAY - timedelta(days=365)


# ── 1. BRANCHES ───────────────────────────────────────────────────────────────
# Narrative anchored to months elapsed from BACKFILL_START — not fixed
# calendar months — so the story stays consistent as time rolls forward.

def get_branch_multiplier(branch_id: str, target_date: date) -> float:
    months_elapsed = (
        (target_date.year  - BACKFILL_START.year)  * 12
        + (target_date.month - BACKFILL_START.month)
    )

    if branch_id == "BR01":
        # Cabang Pusat — stable flagship
        return 1.0

    elif branch_id == "BR02":
        # Cabang Selatan — consistent growth
        growth = [0.70, 0.75, 0.80, 0.82, 0.85, 0.88,
                  0.90, 0.93, 0.95, 0.97, 1.00, 1.05]
        return growth[min(months_elapsed, len(growth) - 1)]

    elif branch_id == "BR03":
        # Cabang Utara — opens month 4, slow ramp-up
        if months_elapsed < 4:
            return 0.0
        ramp = [0.45, 0.55, 0.65, 0.70, 0.73, 0.76, 0.80, 0.85]
        return ramp[min(months_elapsed - 4, len(ramp) - 1)]

    elif branch_id == "BR04":
        # Cabang Timur — drop months 6-8 (competitor), recovery after
        drop     = {6: 0.60, 7: 0.55, 8: 0.58}
        recovery = [0.75, 0.82, 0.88]
        if months_elapsed in drop:
            return drop[months_elapsed]
        elif months_elapsed >= 9:
            return recovery[min(months_elapsed - 9, len(recovery) - 1)]
        return 0.85

    return 1.0


BRANCHES = [
    {"branch_id": "BR01", "name": "Cabang Pusat",  "location": "Jakarta Selatan",
     "opened_date": str(BACKFILL_START)},
    {"branch_id": "BR02", "name": "Cabang Selatan", "location": "Depok",
     "opened_date": str(BACKFILL_START)},
    {"branch_id": "BR03", "name": "Cabang Utara",   "location": "Bekasi",
     "opened_date": str(BACKFILL_START + timedelta(days=120))},
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
    {"shift_id": "S1", "shift_name": "Pagi", "start_hour": 8, "end_hour": 15},
    {"shift_id": "S2", "shift_name": "Siang", "start_hour": 12, "end_hour": 20},
    {"shift_id": "S3", "shift_name": "Malam", "start_hour": 16, "end_hour": 23},
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

MEMBERS = []
for i in range(1, 701):
    signup_date = BACKFILL_START + timedelta(days=random.randint(0, 350))
    tier = random.choices(
        ["Bronze", "Silver", "Gold"],
        weights=[0.58, 0.30, 0.12],
    )[0]
    MEMBERS.append(
        {
            "member_id": f"MBR{i:04d}",
            "member_name": f"Pelanggan Member {i:04d}",
            "gender": random.choice(["M", "F"]),
            "birth_year": random.randint(1975, 2005),
            "city": random.choice(["Jakarta", "Depok", "Bekasi", "Tangerang", "Bogor"]),
            "join_date": str(signup_date),
            "tier": tier,
            "is_active": random.choices([True, False], weights=[0.93, 0.07])[0],
        }
    )

EMPLOYEES = []
employee_branch_map = {}
for branch in BRANCHES:
    for _ in range(8):
        emp_idx = len(EMPLOYEES) + 1
        opened_date = datetime.strptime(branch["opened_date"], "%Y-%m-%d").date()
        start_date = opened_date + timedelta(days=random.randint(0, 60))
        shift_id = random.choices(["S1", "S2", "S3"], weights=[0.35, 0.40, 0.25])[0]
        employee_id = f"EMP{emp_idx:04d}"
        EMPLOYEES.append(
            {
                "employee_id": employee_id,
                "employee_name": EMPLOYEE_NAMES[(emp_idx - 1) % len(EMPLOYEE_NAMES)],
                "branch_id": branch["branch_id"],
                "role": random.choices(
                    ["kasir", "pramusaji", "supervisor"],
                    weights=[0.45, 0.40, 0.15],
                )[0],
                "assigned_shift_id": shift_id,
                "start_date": str(start_date),
                "is_active": random.choices([True, False], weights=[0.96, 0.04])[0],
            }
        )
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
    multiplier = get_branch_multiplier(branch_id, target_date)
    if multiplier == 0.0:
        return 0
    base = {"BR01": 90, "BR02": 65, "BR03": 50, "BR04": 70}[branch_id]
    if target_date.weekday() >= 5:
        base = int(base * 1.3)
    return max(int(base * multiplier * np.random.uniform(0.88, 1.12)), 0)


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
    """
    Deterministic off-days per employee (0=Mon ... 6=Sun).
    Each employee gets 1-2 fixed days off per week.
    """
    seed_val = int(employee_id[3:])  # numeric part of EMP0001
    rng = random.Random(seed_val)
    n_off = rng.choices([1, 2], weights=[0.4, 0.6])[0]
    return set(rng.sample(range(7), n_off))


def build_attendance_for_dates(date_range: list) -> pd.DataFrame:
    rows = []
    # Pre-compute off days per employee once
    emp_off_days = {emp["employee_id"]: get_off_days(emp["employee_id"]) for emp in EMPLOYEES}

    for target_date in date_range:
        is_weekend = target_date.weekday() >= 5
        day_of_week = target_date.weekday()  # 0=Mon, 6=Sun

        for emp in EMPLOYEES:
            start_date = datetime.strptime(emp["start_date"], "%Y-%m-%d").date()
            if target_date < start_date:
                continue
            if not emp["is_active"] and target_date > YESTERDAY - timedelta(days=60):
                continue

            # ← FIX: skip scheduled off days entirely
            if day_of_week in emp_off_days[emp["employee_id"]]:
                continue

            attendance_status = random.choices(
                ["present", "late", "leave", "absent"],
                weights=[0.82, 0.10, 0.04, 0.04] if not is_weekend else [0.78, 0.12, 0.03, 0.07],
            )[0]
            shift_id = emp["assigned_shift_id"]
            overtime_hours = 0
            if attendance_status in ("present", "late"):
                overtime_hours = random.choices([0, 1, 2], weights=[0.78, 0.17, 0.05])[0]

            rows.append({
                "attendance_id":  f"ATD{target_date.strftime('%Y%m%d')}{emp['employee_id'][3:]}",
                "attendance_date": str(target_date),
                "employee_id":    emp["employee_id"],
                "branch_id":      emp["branch_id"],
                "shift_id":       shift_id,
                "status":         attendance_status,
                "overtime_hours": overtime_hours,
            })

    return pd.DataFrame(rows)


# ── 3. CORE GENERATOR ────────────────────────────────────────────────────────

def generate_for_dates(date_range: list) -> tuple:
    hours        = list(range(8, 23))
    hour_weights = [get_hour_weight(h) for h in hours]

    orders_rows = []
    items_rows  = []

    # ID counter prefix from first date — avoids collisions on append
    order_counter = int(date_range[0].strftime("%Y%m%d")) * 100000
    oi_counter    = order_counter * 10

    for target_date in date_range:
        # Per-day seed — deterministic but unique per day
        np.random.seed(BASE_SEED + int(target_date.strftime("%Y%m%d")))
        random.seed(BASE_SEED + int(target_date.strftime("%Y%m%d")))

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
                    "order_id":       order_id,
                    "branch_id":      branch_id,
                    "order_time":     ts.strftime("%Y-%m-%d %H:%M:%S"),
                    "payment_method": get_payment_method(),
                    "order_type":     get_order_type(hour),
                    "shift_id":       infer_shift_id(hour),
                    "handler_employee_id": random.choice(employee_branch_map[branch_id]),
                    "member_id":      random.choices(
                        [None] + [m["member_id"] for m in MEMBERS],
                        weights=[0.62] + [0.38 / len(MEMBERS)] * len(MEMBERS)
                    )[0],
                })

                n_items      = random.choices([1, 2, 3, 4], weights=[0.30, 0.40, 0.20, 0.10])[0]
                item_weights = [get_menu_weight(m, months_elapsed, is_weekend) for m in menu_ids]
                selected     = random.choices(menu_ids, weights=item_weights, k=n_items)

                for menu_id in selected:
                    qty      = random.choices([1, 2, 3], weights=[0.70, 0.25, 0.05])[0]
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


# ── 4. DIMENSION TABLES ───────────────────────────────────────────────────────

def write_dimensions():
    pd.DataFrame(BRANCHES).to_csv(OUTPUT_DIR / "branches.csv", index=False)
    pd.DataFrame([{k: v for k, v in m.items() if k != "note"} for m in MENU_ITEMS]).to_csv(
        OUTPUT_DIR / "menu_items.csv", index=False
    )
    pd.DataFrame(EMPLOYEES).to_csv(OUTPUT_DIR / "employees.csv", index=False)
    pd.DataFrame(MEMBERS).to_csv(OUTPUT_DIR / "members.csv", index=False)
    pd.DataFrame(SHIFTS).to_csv(OUTPUT_DIR / "shifts.csv", index=False)
    print(f"✓ branches.csv   — {len(BRANCHES)} rows")
    print(f"✓ menu_items.csv — {len(MENU_ITEMS)} rows")
    print(f"✓ employees.csv  — {len(EMPLOYEES)} rows")
    print(f"✓ members.csv    — {len(MEMBERS)} rows")
    print(f"✓ shifts.csv     — {len(SHIFTS)} rows")


# ── 5. MODES ──────────────────────────────────────────────────────────────────

def run_backfill():
    print(f"▶ Backfill: {BACKFILL_START} → {YESTERDAY}")
    write_dimensions()

    date_range  = [BACKFILL_START + timedelta(days=i)
                   for i in range((YESTERDAY - BACKFILL_START).days + 1)]
    orders_df, items_df = generate_for_dates(date_range)

    attendance_df = build_attendance_for_dates(date_range)

    orders_df.to_csv(OUTPUT_DIR / "orders.csv",                index=False)
    items_df.to_csv(OUTPUT_DIR / "order_items.csv",            index=False)
    attendance_df.to_csv(OUTPUT_DIR / "employee_attendance.csv", index=False)

    print(f"✓ orders.csv      — {len(orders_df):,} rows")
    print(f"✓ order_items.csv — {len(items_df):,} rows")
    print(f"✓ employee_attendance.csv — {len(attendance_df):,} rows")
    _sanity_check(orders_df, items_df)
    print("\n✅ Backfill complete.")


def run_daily():
    print(f"▶ Daily append: {YESTERDAY}")

    orders_path = OUTPUT_DIR / "orders.csv"
    items_path  = OUTPUT_DIR / "order_items.csv"
    attendance_path = OUTPUT_DIR / "employee_attendance.csv"

    if not orders_path.exists():
        print("✗ No existing data. Run --mode backfill first.")
        return

    # Idempotency check — skip if already appended today
    existing = pd.read_csv(orders_path, usecols=["order_time"])
    if existing["order_time"].str.startswith(str(YESTERDAY)).any():
        print(f"⚠ Data for {YESTERDAY} already exists. Skipping.")
        return

    orders_df, items_df = generate_for_dates([YESTERDAY])
    attendance_df = build_attendance_for_dates([YESTERDAY])
    orders_df.to_csv(orders_path, mode="a", header=False, index=False)
    items_df.to_csv(items_path,   mode="a", header=False, index=False)
    attendance_df.to_csv(attendance_path, mode="a", header=False, index=False)

    print(f"✓ Appended {len(orders_df):,} orders")
    print(f"✓ Appended {len(items_df):,} order items")
    print(f"✓ Appended {len(attendance_df):,} attendance rows")
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