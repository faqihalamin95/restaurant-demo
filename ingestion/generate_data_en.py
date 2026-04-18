"""
Burger Restaurant Demo (US) - Synthetic Data Generator
=======================================================
Generates realistic restaurant transaction data relative to today's date.
Full parity with the Indonesian (ID) version:
  branches, menu_items, employees, members, shifts,
  employee_attendance, orders, order_items, employee_compensation,
  inventory_catalog, inventory_transactions,
  branch_daily_operational_costs

Modes:
  --mode backfill   Generate (today - 365 days) up to yesterday. Run once.
  --mode daily      Generate yesterday only, append to existing CSVs.

Usage:
    python generate_data_en.py --mode backfill
    python generate_data_en.py --mode daily

Output: data/raw_en/
"""

import argparse
import random
from datetime import date, datetime, timedelta
from pathlib import Path

import numpy as np
import pandas as pd

# ── Reproducibility ───────────────────────────────────────────────────────────
BASE_SEED = 99

# ── Config ────────────────────────────────────────────────────────────────────
ROOT_DIR   = Path(__file__).parent.parent
OUTPUT_DIR = ROOT_DIR / "data" / "raw_en"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

TODAY          = date.today()
YESTERDAY      = TODAY - timedelta(days=1)
BACKFILL_START = TODAY - timedelta(days=365)


# ── 1. BRANCHES ───────────────────────────────────────────────────────────────

def get_branch_multiplier(branch_id: str, target_date: date) -> float:
    months_elapsed = (
        (target_date.year  - BACKFILL_START.year)  * 12
        + (target_date.month - BACKFILL_START.month)
    )

    if branch_id == "BR01":
        return 1.0

    elif branch_id == "BR02":
        growth = [0.70, 0.74, 0.78, 0.81, 0.84, 0.87,
                  0.90, 0.92, 0.95, 0.97, 1.00, 1.04]
        return growth[min(months_elapsed, len(growth) - 1)]

    elif branch_id == "BR03":
        if months_elapsed < 4:
            return 0.0
        ramp = [0.42, 0.53, 0.62, 0.68, 0.72, 0.75, 0.79, 0.84]
        return ramp[min(months_elapsed - 4, len(ramp) - 1)]

    elif branch_id == "BR04":
        drop     = {6: 0.58, 7: 0.52, 8: 0.56}
        recovery = [0.74, 0.81, 0.87]
        if months_elapsed in drop:
            return drop[months_elapsed]
        elif months_elapsed >= 9:
            return recovery[min(months_elapsed - 9, len(recovery) - 1)]
        return 0.84

    return 1.0


BRANCHES = [
    {"branch_id": "BR01", "name": "Downtown",  "location": "Chicago, IL — Loop",
     "opened_date": str(BACKFILL_START)},
    {"branch_id": "BR02", "name": "Midtown",   "location": "Chicago, IL — River North",
     "opened_date": str(BACKFILL_START)},
    {"branch_id": "BR03", "name": "Westside",  "location": "Oak Park, IL",
     "opened_date": str(BACKFILL_START + timedelta(days=120))},
    {"branch_id": "BR04", "name": "Northside", "location": "Chicago, IL — Lincoln Park",
     "opened_date": str(BACKFILL_START)},
]

MENU_ITEMS = [
    {"menu_id": "M01", "name": "Classic Smash Burger",    "category": "main",    "price": 10.99, "is_active": True, "note": "bestseller"},
    {"menu_id": "M02", "name": "Pulled Beef Burger",      "category": "main",    "price": 13.99, "is_active": True, "note": "stable"},
    {"menu_id": "M03", "name": "Veggie Patty Burger",     "category": "main",    "price": 11.49, "is_active": True, "note": "declining"},
    {"menu_id": "M04", "name": "Chicken Crispy Sandwich", "category": "main",    "price": 10.49, "is_active": True, "note": "stable"},
    {"menu_id": "M05", "name": "Spicy Crispy Chicken",    "category": "main",    "price": 11.49, "is_active": True, "note": "declining"},
    {"menu_id": "M06", "name": "Family Bundle (x4)",      "category": "main",    "price": 38.99, "is_active": True, "note": "weekend_spike"},
    {"menu_id": "M07", "name": "Fountain Soda",           "category": "drink",   "price": 2.99,  "is_active": True, "note": "stable"},
    {"menu_id": "M08", "name": "Fresh Lemonade",          "category": "drink",   "price": 3.99,  "is_active": True, "note": "stable"},
    {"menu_id": "M09", "name": "Vanilla Milkshake",       "category": "drink",   "price": 5.99,  "is_active": True, "note": "stable"},
    {"menu_id": "M10", "name": "Bottled Water",           "category": "drink",   "price": 1.99,  "is_active": True, "note": "stable"},
    {"menu_id": "M11", "name": "Crispy Fries",            "category": "side",    "price": 3.99,  "is_active": True, "note": "stable"},
    {"menu_id": "M12", "name": "Onion Rings",             "category": "side",    "price": 4.49,  "is_active": True, "note": "stable"},
    {"menu_id": "M13", "name": "Coleslaw",                "category": "side",    "price": 2.99,  "is_active": True, "note": "stable"},
    {"menu_id": "M14", "name": "Apple Pie Slice",         "category": "dessert", "price": 4.99,  "is_active": True, "note": "hidden_gem"},
    {"menu_id": "M15", "name": "Soft Serve Cone",         "category": "dessert", "price": 2.99,  "is_active": True, "note": "stable"},
    {"menu_id": "M16", "name": "Brownie",                 "category": "dessert", "price": 3.99,  "is_active": True, "note": "stable"},
]

SHIFTS = [
    {"shift_id": "S1", "shift_name": "Morning",   "start_hour": 8,  "end_hour": 15},
    {"shift_id": "S2", "shift_name": "Afternoon", "start_hour": 12, "end_hour": 20},
    {"shift_id": "S3", "shift_name": "Evening",   "start_hour": 16, "end_hour": 23},
]

INVENTORY_CATALOG = [
    {"inventory_id": "INV01", "item_name": "Beef Patty",       "category": "protein",  "unit": "lb",    "base_unit_cost": 6.50},
    {"inventory_id": "INV02", "item_name": "Burger Buns",      "category": "bakery",   "unit": "dozen", "base_unit_cost": 4.20},
    {"inventory_id": "INV03", "item_name": "Frying Oil",       "category": "oil",      "unit": "gal",   "base_unit_cost": 8.99},
    {"inventory_id": "INV04", "item_name": "Fresh Tomatoes",   "category": "produce",  "unit": "lb",    "base_unit_cost": 2.50},
    {"inventory_id": "INV05", "item_name": "Iceberg Lettuce",  "category": "produce",  "unit": "head",  "base_unit_cost": 1.80},
    {"inventory_id": "INV06", "item_name": "Soda Syrup",       "category": "beverage", "unit": "box",   "base_unit_cost": 18.00},
    {"inventory_id": "INV07", "item_name": "Lemons",           "category": "produce",  "unit": "lb",    "base_unit_cost": 1.50},
    {"inventory_id": "INV08", "item_name": "Propane Tank",     "category": "utility",  "unit": "tank",  "base_unit_cost": 22.00},
]

EMPLOYEE_NAMES = [
    "James Carter", "Emily Johnson", "Michael Brown", "Sarah Davis",
    "Robert Wilson", "Jessica Martinez", "David Anderson", "Ashley Taylor",
    "Christopher Thomas", "Amanda Jackson", "Daniel White", "Stephanie Harris",
    "Matthew Lewis", "Nicole Robinson", "Joshua Walker", "Megan Hall",
    "Andrew Young", "Lauren Allen", "Ryan King", "Brittany Wright",
    "Kevin Scott", "Samantha Green", "Brandon Adams", "Kayla Baker",
    "Tyler Nelson", "Rachel Hill", "Nathan Mitchell", "Heather Carter",
    "Justin Perez", "Amber Roberts", "Eric Turner", "Melissa Phillips",
]

MEMBER_CITIES = ["Chicago", "Oak Park", "Evanston", "Naperville", "Aurora", "Schaumburg"]

menu_notes  = {m["menu_id"]: m["note"]  for m in MENU_ITEMS}
menu_prices = {m["menu_id"]: m["price"] for m in MENU_ITEMS}
menu_ids    = [m["menu_id"] for m in MENU_ITEMS]

# ── Generate static dimensions ────────────────────────────────────────────────
random.seed(BASE_SEED)

MEMBERS = []
for i in range(1, 701):
    signup_date = BACKFILL_START + timedelta(days=random.randint(0, 350))
    tier = random.choices(["Bronze", "Silver", "Gold"], weights=[0.58, 0.30, 0.12])[0]
    MEMBERS.append({
        "member_id":   f"MBR{i:04d}",
        "member_name": f"Member Customer {i:04d}",
        "gender":      random.choice(["M", "F"]),
        "birth_year":  random.randint(1970, 2005),
        "city":        random.choice(MEMBER_CITIES),
        "join_date":   str(signup_date),
        "tier":        tier,
        "is_active":   random.choices([True, False], weights=[0.93, 0.07])[0],
    })

EMPLOYEES = []
EMPLOYEE_COMPENSATION = []
employee_branch_map = {}

for branch in BRANCHES:
    for _ in range(8):
        emp_idx    = len(EMPLOYEES) + 1
        opened_dt  = datetime.strptime(branch["opened_date"], "%Y-%m-%d").date()
        start_date = opened_dt + timedelta(days=random.randint(0, 60))
        shift_id   = random.choices(["S1", "S2", "S3"], weights=[0.35, 0.40, 0.25])[0]
        employee_id = f"EMP{emp_idx:04d}"
        role = random.choices(["cashier", "server", "supervisor"], weights=[0.45, 0.40, 0.15])[0]

        EMPLOYEES.append({
            "employee_id":       employee_id,
            "employee_name":     EMPLOYEE_NAMES[(emp_idx - 1) % len(EMPLOYEE_NAMES)],
            "branch_id":         branch["branch_id"],
            "role":              role,
            "assigned_shift_id": shift_id,
            "start_date":        str(start_date),
            "is_active":         random.choices([True, False], weights=[0.96, 0.04])[0],
        })
        EMPLOYEE_COMPENSATION.append({
            "employee_id":          employee_id,
            "branch_id":            branch["branch_id"],
            "base_salary_monthly":  random.choice([3200, 3500, 3800, 4200, 4800]),
            "meal_allowance_daily": random.choice([12, 15, 18]),
            "overtime_rate_hourly": random.choice([18, 20, 22]),
            "effective_from":       str(start_date),
        })
        employee_branch_map.setdefault(branch["branch_id"], []).append(employee_id)


# ── 2. HELPERS ────────────────────────────────────────────────────────────────

def get_hour_weight(hour: int) -> float:
    weights = {
        8: 0.3, 9: 0.5, 10: 0.8, 11: 2.2,
        12: 3.0, 13: 2.5, 14: 0.8, 15: 0.6,
        16: 0.7, 17: 1.8, 18: 2.2, 19: 1.8,
        20: 1.2, 21: 0.6, 22: 0.3
    }
    return weights.get(hour, 0.2)


def get_menu_weight(menu_id: str, months_elapsed: int, is_weekend: bool) -> float:
    note = menu_notes.get(menu_id, "stable")
    if note == "bestseller":
        return 3.0
    elif note == "declining":
        if months_elapsed >= 8:
            return max(0.3, 1.4 - (months_elapsed - 7) * 0.22)
        return 1.4
    elif note == "weekend_spike":
        return 3.2 if is_weekend else 0.5
    elif note == "hidden_gem":
        return 0.3
    return 1.0


def get_base_orders(branch_id: str, target_date: date) -> int:
    multiplier = get_branch_multiplier(branch_id, target_date)
    if multiplier == 0.0:
        return 0
    base = {"BR01": 110, "BR02": 80, "BR03": 60, "BR04": 85}[branch_id]
    if target_date.weekday() >= 5:
        base = int(base * 1.25)
    return max(int(base * multiplier * np.random.uniform(0.88, 1.12)), 0)


def get_payment_method() -> str:
    return random.choices(
        ["card", "contactless", "cash", None],
        weights=[0.52, 0.30, 0.15, 0.03]
    )[0]


def get_order_type(hour: int) -> str:
    if hour in [12, 13, 18, 19]:
        return random.choices(["dine_in", "delivery", "takeaway"], weights=[0.38, 0.42, 0.20])[0]
    elif hour in [14, 15, 16]:
        return random.choices(["dine_in", "delivery", "takeaway"], weights=[0.25, 0.25, 0.50])[0]
    return random.choices(["dine_in", "delivery", "takeaway"], weights=[0.48, 0.28, 0.24])[0]


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


# ── 3. ATTENDANCE ─────────────────────────────────────────────────────────────

def build_attendance_for_dates(date_range: list) -> pd.DataFrame:
    rows = []
    emp_off_days = {e["employee_id"]: get_off_days(e["employee_id"]) for e in EMPLOYEES}

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

            status = random.choices(
                ["present", "late", "leave", "absent"],
                weights=[0.82, 0.10, 0.04, 0.04] if not is_weekend
                        else [0.78, 0.12, 0.03, 0.07],
            )[0]

            overtime_hours = 0
            if status in ("present", "late"):
                overtime_hours = random.choices([0, 1, 2], weights=[0.78, 0.17, 0.05])[0]

            rows.append({
                "attendance_id":   f"ATD{target_date.strftime('%Y%m%d')}{emp['employee_id'][3:]}",
                "attendance_date": str(target_date),
                "employee_id":     emp["employee_id"],
                "branch_id":       emp["branch_id"],
                "shift_id":        emp["assigned_shift_id"],
                "status":          status,
                "overtime_hours":  overtime_hours,
            })

    return pd.DataFrame(rows)


# ── 4. CORE ORDER GENERATOR ───────────────────────────────────────────────────

def generate_for_dates(date_range: list) -> tuple:
    hours        = list(range(8, 23))
    hour_weights = [get_hour_weight(h) for h in hours]

    orders_rows = []
    items_rows  = []

    emp_off_days  = {e["employee_id"]: get_off_days(e["employee_id"]) for e in EMPLOYEES}
    order_counter = int(date_range[0].strftime("%Y%m%d")) * 100000
    oi_counter    = order_counter * 10

    for target_date in date_range:
        np.random.seed(BASE_SEED + int(target_date.strftime("%Y%m%d")))
        random.seed(BASE_SEED + int(target_date.strftime("%Y%m%d")))

        day_of_week = target_date.weekday()

        # Pool of available handlers for today
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

                n_items      = random.choices([1, 2, 3, 4], weights=[0.25, 0.42, 0.23, 0.10])[0]
                item_weights = [get_menu_weight(m, months_elapsed, is_weekend) for m in menu_ids]
                selected     = random.choices(menu_ids, weights=item_weights, k=n_items)

                for menu_id in selected:
                    qty = random.choices([1, 2, 3], weights=[0.72, 0.23, 0.05])[0]
                    items_rows.append({
                        "order_item_id": f"OI{oi_counter:011d}",
                        "order_id":      order_id,
                        "menu_id":       menu_id,
                        "qty":           qty,
                        "subtotal":      round(menu_prices[menu_id] * qty, 2),
                    })
                    oi_counter += 1

                order_counter += 1

    return pd.DataFrame(orders_rows), pd.DataFrame(items_rows)


# ── 5. INVENTORY ──────────────────────────────────────────────────────────────

def generate_inventory_for_dates(date_range: list) -> pd.DataFrame:
    rows = []
    trx_counter = int(date_range[0].strftime("%Y%m%d")) * 10000

    for target_date in date_range:
        np.random.seed(BASE_SEED + 7 + int(target_date.strftime("%Y%m%d")))
        random.seed(BASE_SEED + 7 + int(target_date.strftime("%Y%m%d")))

        for branch in BRANCHES:
            for item in INVENTORY_CATALOG:
                if item["inventory_id"] == "INV08":
                    usage_qty = max(np.random.normal(loc=0.4, scale=0.1), 0.2)
                else:
                    usage_qty = max(np.random.normal(loc=7.5, scale=2.0), 1.2)
                if item["category"] in ("protein", "bakery"):
                    usage_qty *= 1.35
                unit_cost = round(item["base_unit_cost"] * np.random.uniform(0.95, 1.08), 2)

                rows.append({
                    "inventory_txn_id": f"ITX{trx_counter:011d}",
                    "txn_date":         str(target_date),
                    "branch_id":        branch["branch_id"],
                    "inventory_id":     item["inventory_id"],
                    "txn_type":         "usage",
                    "qty":              round(usage_qty, 2),
                    "unit_cost":        unit_cost,
                    "total_cost":       round(usage_qty * unit_cost, 2),
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
                        "total_cost":       round(purchase_qty * unit_cost, 2),
                    })
                    trx_counter += 1

    return pd.DataFrame(rows)


# ── 6. OPERATIONAL COSTS ─────────────────────────────────────────────────────

def generate_operational_costs_for_dates(date_range: list) -> pd.DataFrame:
    rows = []
    for target_date in date_range:
        np.random.seed(BASE_SEED + 13 + int(target_date.strftime("%Y%m%d")))
        random.seed(BASE_SEED + 13 + int(target_date.strftime("%Y%m%d")))
        days_in_month = (target_date.replace(day=28) + timedelta(days=4)).replace(day=1) - timedelta(days=1)

        for branch in BRANCHES:
            rent_monthly = {
                "BR01": 8500,
                "BR02": 6200,
                "BR03": 4800,
                "BR04": 7000,
            }[branch["branch_id"]]

            open_date = datetime.strptime(branch["opened_date"], "%Y-%m-%d").date()
            if target_date < open_date:
                continue

            rows.append({
                "cost_date":           str(target_date),
                "branch_id":           branch["branch_id"],
                "building_rent_daily": round(rent_monthly / days_in_month.day, 2),
                "water_cost":          round(np.random.uniform(30, 65), 2),
                "electricity_cost":    round(np.random.uniform(80, 180), 2),
                "other_utilities_cost": round(np.random.uniform(15, 35), 2),
            })

    return pd.DataFrame(rows)


# ── 7. DIMENSION TABLES ───────────────────────────────────────────────────────

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


# ── 8. MODES ──────────────────────────────────────────────────────────────────

def run_backfill():
    print(f"▶ Backfill: {BACKFILL_START} → {YESTERDAY}")
    write_dimensions()

    date_range = [BACKFILL_START + timedelta(days=i)
                  for i in range((YESTERDAY - BACKFILL_START).days + 1)]

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

    orders_path     = OUTPUT_DIR / "orders.csv"
    items_path      = OUTPUT_DIR / "order_items.csv"
    attendance_path = OUTPUT_DIR / "employee_attendance.csv"
    inventory_path  = OUTPUT_DIR / "inventory_transactions.csv"
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

    orders_df.to_csv(orders_path,     mode="a", header=False, index=False)
    items_df.to_csv(items_path,       mode="a", header=False, index=False)
    attendance_df.to_csv(attendance_path, mode="a", header=False, index=False)
    inventory_df.to_csv(inventory_path,   mode="a", header=not inventory_path.exists(), index=False)
    branch_cost_df.to_csv(branch_cost_path, mode="a", header=not branch_cost_path.exists(), index=False)

    print(f"✓ Appended {len(orders_df):,} orders")
    print(f"✓ Appended {len(items_df):,} order items")
    print(f"✓ Appended {len(attendance_df):,} attendance rows")
    print(f"✓ Appended {len(inventory_df):,} inventory rows")
    print(f"✓ Appended {len(branch_cost_df):,} operational cost rows")
    print("\n✅ Daily append complete.")


# ── 9. SANITY CHECK ───────────────────────────────────────────────────────────

def _sanity_check(orders_df: pd.DataFrame, items_df: pd.DataFrame):
    print("\n── Sanity Check ──────────────────────────────────────────────────")
    merged = items_df.merge(orders_df[["order_id", "branch_id"]], on="order_id")
    rev    = (merged.groupby("branch_id")["subtotal"].sum()
              .reset_index().rename(columns={"subtotal": "revenue"}))
    rev["revenue"] = rev["revenue"].apply(lambda x: f"${x:,.2f}")
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


# ── 10. ENTRYPOINT ────────────────────────────────────────────────────────────

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Burger Restaurant (US) data generator")
    parser.add_argument("--mode", choices=["backfill", "daily"], required=True)
    args = parser.parse_args()

    if args.mode == "backfill":
        run_backfill()
    else:
        run_daily()
