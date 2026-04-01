"""
Load Raw Data → DuckDB
======================
Reads CSV files from data/raw/ and loads them into DuckDB
under the 'raw' schema. Safe to re-run — uses CREATE OR REPLACE.

Usage:
    python load_raw.py               # loads data/raw/ (ID version)
    python load_raw.py --lang en     # loads data/raw_en/ (US version)

Called by Dagster ingestion asset after daily data generation.
"""

import argparse
from pathlib import Path

import duckdb

# ── Config ────────────────────────────────────────────────────────────────────
ROOT_DIR = Path(__file__).parent.parent

TABLES = [
    "branches",
    "menu_items",
    "employees",
    "members",
    "shifts",
    "employee_attendance",
    "orders",
    "order_items",
    "employee_compensation",
    "inventory_catalog",
    "inventory_transactions",
    "branch_daily_operational_costs",
]


def load(raw_dir: Path, db_path: Path):
    print(f"▶ Loading from {raw_dir} → {db_path}")
    db_path.parent.mkdir(parents=True, exist_ok=True)

    con = duckdb.connect(str(db_path))
    con.execute("CREATE SCHEMA IF NOT EXISTS raw")

    for table in TABLES:
        csv_path = raw_dir / f"{table}.csv"

        if not csv_path.exists():
            print(f"  ✗ {table}.csv not found — skipping")
            continue

        con.execute(f"""
            CREATE OR REPLACE TABLE raw.{table} AS
            SELECT * FROM read_csv_auto('{csv_path}', header=true)
        """)

        count = con.execute(f"SELECT COUNT(*) FROM raw.{table}").fetchone()[0]
        print(f"  ✓ raw.{table:<15} — {count:>10,} rows")

    con.close()
    print("\n✅ Load complete.")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Load raw CSVs into DuckDB")
    parser.add_argument(
        "--lang",
        choices=["id", "en"],
        default="id",
        help="id: data/raw/ (Indonesian) | en: data/raw_en/ (US)",
    )
    args = parser.parse_args()

    if args.lang == "id":
        raw_dir = ROOT_DIR / "data" / "raw"
        db_path = ROOT_DIR / "data" / "warehouse.duckdb"
    else:
        raw_dir = ROOT_DIR / "data" / "raw_en"
        db_path = ROOT_DIR / "data" / "warehouse_en.duckdb"

    load(raw_dir, db_path)