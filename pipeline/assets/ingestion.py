"""
Ingestion Assets
================
Asset 1: generate_daily_data  — runs generate_data.py --mode daily
Asset 2: load_raw_to_duckdb   — runs load_raw.py --lang id

On first run (backfill), trigger manually with --mode backfill.
Daily schedule handles incremental appends thereafter.
"""

import subprocess
from pathlib import Path

from dagster import asset, Output, MetadataValue

ROOT_DIR = Path(__file__).parent.parent.parent


@asset(group_name="ingestion", compute_kind="python")
def generate_daily_data():
    """
    Appends yesterday's synthetic data to data/raw/ CSVs.
    Idempotent — safe to re-run on same day.
    """
    result = subprocess.run(
        ["python", str(ROOT_DIR / "ingestion" / "generate_data_id.py"), "--mode", "daily"],
        capture_output=True,
        text=True,
        cwd=str(ROOT_DIR),
    )

    if result.returncode != 0:
        raise Exception(f"generate_data.py failed:\n{result.stderr}")

    return Output(
        value=result.stdout,
        metadata={"output": MetadataValue.text(result.stdout)},
    )


@asset(group_name="ingestion", compute_kind="duckdb", deps=[generate_daily_data])
def load_raw_to_duckdb():
    """
    Loads raw CSVs into DuckDB raw schema.
    Runs after generate_daily_data completes.
    """
    result = subprocess.run(
        ["python", str(ROOT_DIR / "ingestion" / "load_raw.py"), "--lang", "id"],
        capture_output=True,
        text=True,
        cwd=str(ROOT_DIR),
    )

    if result.returncode != 0:
        raise Exception(f"load_raw.py failed:\n{result.stderr}")

    return Output(
        value=result.stdout,
        metadata={"output": MetadataValue.text(result.stdout)},
    )

@asset(group_name="ingestion_en", compute_kind="python")
def generate_daily_data_en():
    result = subprocess.run(
        ["python", str(ROOT_DIR / "ingestion" / "generate_data_en.py"), "--mode", "daily"],
        capture_output=True, text=True, cwd=str(ROOT_DIR),
    )
    if result.returncode != 0:
        raise Exception(f"generate_data_en.py failed:\n{result.stderr}")
    return Output(value=result.stdout, metadata={"output": MetadataValue.text(result.stdout)})


@asset(group_name="ingestion_en", compute_kind="duckdb", deps=[generate_daily_data_en])
def load_raw_to_duckdb_en():
    result = subprocess.run(
        ["python", str(ROOT_DIR / "ingestion" / "load_raw.py"), "--lang", "en"],
        capture_output=True, text=True, cwd=str(ROOT_DIR),
    )
    if result.returncode != 0:
        raise Exception(f"load_raw.py failed:\n{result.stderr}")
    return Output(value=result.stdout, metadata={"output": MetadataValue.text(result.stdout)})