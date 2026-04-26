"""
Wekadata — Laporan Harian Restoran
====================================
Mengirim ringkasan harian ke pemilik restoran via Telegram bot.
Dijalankan otomatis oleh Dagster setiap pagi pukul 06:00 WIB.

Env vars yang dibutuhkan:
    TELEGRAM_BOT_TOKEN
    TELEGRAM_CHAT_ID
    DUCKDB_PATH
"""

import os
import duckdb
import requests
from datetime import date, timedelta
from pathlib import Path

from dotenv import load_dotenv
load_dotenv()

BOT_TOKEN = os.getenv("TELEGRAM_BOT_TOKEN")
CHAT_ID   = os.getenv("TELEGRAM_CHAT_ID")
ROOT_DIR  = Path(__file__).parent.parent
DB_PATH   = os.getenv("DUCKDB_PATH", str(ROOT_DIR / "data" / "warehouse.duckdb"))


def fetch_summary(target_date: date) -> dict:
    con = duckdb.connect(DB_PATH, read_only=True)

    revenue = con.execute(f"""
        SELECT
            branch_name,
            total_revenue,
            total_orders,
            ROUND(pct_change_vs_sdow_avg * 100, 1) AS pct_change
        FROM main_marts.mart_daily_revenue
        WHERE order_date = '{target_date}'
        ORDER BY total_revenue DESC
    """).fetchall()

    top_menu = con.execute(f"""
        SELECT menu_name, SUM(total_qty_sold) AS qty
        FROM main_marts.mart_menu_performance
        WHERE order_date = '{target_date}'
        GROUP BY menu_name
        ORDER BY qty DESC
        LIMIT 1
    """).fetchone()

    alerts = con.execute(f"""
        SELECT
            branch_name,
            ROUND(pct_change_vs_sdow_avg * 100, 1) AS pct_drop
        FROM main_marts.mart_daily_revenue
        WHERE order_date = '{target_date}'
        AND pct_change_vs_sdow_avg < -0.15
        ORDER BY pct_change_vs_sdow_avg ASC
    """).fetchall()

    con.close()
    return {"revenue": revenue, "top_menu": top_menu, "alerts": alerts}


def format_message(target_date: date, data: dict) -> str:
    hari_map = {
        "Monday": "Senin", "Tuesday": "Selasa", "Wednesday": "Rabu",
        "Thursday": "Kamis", "Friday": "Jumat", "Saturday": "Sabtu", "Sunday": "Minggu"
    }
    bulan_map = {
        1: "Januari", 2: "Februari", 3: "Maret", 4: "April",
        5: "Mei", 6: "Juni", 7: "Juli", 8: "Agustus",
        9: "September", 10: "Oktober", 11: "November", 12: "Desember"
    }
    nama_hari = hari_map.get(target_date.strftime("%A"), target_date.strftime("%A"))
    tanggal   = f"{target_date.day} {bulan_map[target_date.month]} {target_date.year}"

    lines = [
        "✅ *Wekadata — Laporan Harian*",
        f"📅 {nama_hari}, {tanggal}",
        "",
        "━━━━━━━━━━━━━━━━━━━━",
        "📊 *Revenue per Cabang*",
    ]

    total_revenue = 0
    total_orders  = 0

    for branch_name, revenue, orders, pct_change in data["revenue"]:
        arrow = "✅" if pct_change >= 0 else "🚨"
        sign  = "+" if pct_change >= 0 else ""
        lines.append(
            f"{arrow} *{branch_name}*\n"
            f"   Rp {revenue:,.0f} ({orders} pesanan) "
            f"[{sign}{pct_change}% vs hari serupa]"
        )
        total_revenue += revenue
        total_orders  += orders

    lines += [
        "",
        "━━━━━━━━━━━━━━━━━━━━",
        f"💵 *Total: Rp {total_revenue:,.0f}*",
        f"🧾 *Total Pesanan: {total_orders:,}*",
    ]

    if data["top_menu"]:
        menu_name, qty = data["top_menu"]
        lines += [
            "",
            "━━━━━━━━━━━━━━━━━━━━",
            "🏆 *Menu Terlaris Hari Ini*",
            f"   {menu_name} ({qty:,} porsi)",
        ]

    if data["alerts"]:
        lines += [
            "",
            "━━━━━━━━━━━━━━━━━━━━",
            "⚠️ *Peringatan — Revenue Turun Signifikan*",
        ]
        for branch_name, pct_drop in data["alerts"]:
            lines.append(
                f"   🚨 {branch_name}: {pct_drop}% vs rata-rata hari serupa"
            )
        lines.append("   _Segera cek kondisi cabang ini._")

    lines += [
        "",
        "━━━━━━━━━━━━━━━━━━━━",
        "_Laporan otomatis Wekadata — diperbarui setiap pukul 06:00 WIB_",
        "_Dashboard lengkap: app.wekadata.id_",
    ]

    return "\n".join(lines)


def send_telegram(message: str) -> bool:
    if not BOT_TOKEN or not CHAT_ID:
        print("[WARN] TELEGRAM_BOT_TOKEN atau TELEGRAM_CHAT_ID belum diset.")
        return False

    url  = f"https://api.telegram.org/bot{BOT_TOKEN}/sendMessage"
    resp = requests.post(url, json={
        "chat_id":    CHAT_ID,
        "text":       message,
        "parse_mode": "Markdown",
    })

    if resp.status_code == 200:
        print("✓ Wekadata alert terkirim")
        return True
    else:
        print(f"✗ Telegram error: {resp.status_code} — {resp.text}")
        return False


def run_alert(target_date: date = None):
    if target_date is None:
        target_date = date.today() - timedelta(days=1)

    print(f"▶ Mengirim laporan Wekadata untuk {target_date}...")
    data    = fetch_summary(target_date)
    message = format_message(target_date, data)
    print(message)
    send_telegram(message)


if __name__ == "__main__":
    run_alert()