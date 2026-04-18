"""
Ingestion Assets
================
Asset 1 (ID): generate_daily_data    — runs generate_data_id.py --mode daily
Asset 2 (ID): load_raw_to_duckdb     — runs load_raw.py --lang id
Asset 3 (EN): generate_daily_data_en — runs generate_data_en.py --mode daily
Asset 4 (EN): load_raw_to_duckdb_en  — runs load_raw.py --lang en

On first run (backfill), trigger manually with --mode backfill.
Daily schedule handles incremental appends thereafter.
"""

import subprocess
from pathlib import Path

from dagster import asset, Output, MetadataValue

ROOT_DIR = Path(__file__).parent.parent.parent


# ── Indonesian (ID) pipeline ──────────────────────────────────────────────────

@asset(group_name="ingestion", compute_kind="python")
def generate_daily_data():
    """Appends yesterday's synthetic data to data/raw/ CSVs. Idempotent."""
    result = subprocess.run(
        ["python", str(ROOT_DIR / "ingestion" / "generate_data_id.py"), "--mode", "daily"],
        capture_output=True, text=True, cwd=str(ROOT_DIR),
    )
    if result.returncode != 0:
        raise Exception(f"generate_data_id.py failed:\n{result.stderr}")
    return Output(value=result.stdout, metadata={"output": MetadataValue.text(result.stdout)})


@asset(group_name="ingestion", compute_kind="duckdb", deps=[generate_daily_data])
def load_raw_to_duckdb():
    """Loads raw CSVs into DuckDB raw schema (Indonesian version)."""
    result = subprocess.run(
        ["python", str(ROOT_DIR / "ingestion" / "load_raw.py"), "--lang", "id"],
        capture_output=True, text=True, cwd=str(ROOT_DIR),
    )
    if result.returncode != 0:
        raise Exception(f"load_raw.py (id) failed:\n{result.stderr}")
    return Output(value=result.stdout, metadata={"output": MetadataValue.text(result.stdout)})


# ── English (EN) pipeline ─────────────────────────────────────────────────────

@asset(group_name="ingestion_en", compute_kind="python")
def generate_daily_data_en():
    """Appends yesterday's synthetic data to data/raw_en/ CSVs. Idempotent."""
    result = subprocess.run(
        ["python", str(ROOT_DIR / "ingestion" / "generate_data_en.py"), "--mode", "daily"],
        capture_output=True, text=True, cwd=str(ROOT_DIR),
    )
    if result.returncode != 0:
        raise Exception(f"generate_data_en.py failed:\n{result.stderr}")
    return Output(value=result.stdout, metadata={"output": MetadataValue.text(result.stdout)})


@asset(group_name="ingestion_en", compute_kind="duckdb", deps=[generate_daily_data_en])
def load_raw_to_duckdb_en():
    """Loads raw CSVs into DuckDB raw schema (English version)."""
    result = subprocess.run(
        ["python", str(ROOT_DIR / "ingestion" / "load_raw.py"), "--lang", "en"],
        capture_output=True, text=True, cwd=str(ROOT_DIR),
    )
    if result.returncode != 0:
        raise Exception(f"load_raw.py (en) failed:\n{result.stderr}")
    return Output(value=result.stdout, metadata={"output": MetadataValue.text(result.stdout)})
