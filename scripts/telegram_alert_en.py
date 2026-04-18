"""
Telegram Alert — Restaurant Report (EN)
=======================================
Sends daily summary to owner via Telegram bot.
Triggered as last asset in Dagster pipeline.

Required env vars:
    TELEGRAM_BOT_TOKEN
    TELEGRAM_CHAT_ID
    DUCKDB_PATH_EN   (optional — defaults to data/warehouse_en.duckdb)
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
DB_PATH   = os.getenv("DUCKDB_PATH_EN", str(ROOT_DIR / "data" / "warehouse_en.duckdb"))


def fetch_summary(target_date: date) -> dict:
    con = duckdb.connect(DB_PATH, read_only=True)

    # Revenue per location with SDOW comparison
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

    # Top menu item of the day
    top_menu = con.execute(f"""
        SELECT menu_name, SUM(total_qty_sold) AS qty
        FROM main_marts.mart_menu_performance
        WHERE order_date = '{target_date}'
        GROUP BY menu_name
        ORDER BY qty DESC
        LIMIT 1
    """).fetchone()

    # Locations with >15% drop vs same-day-of-week average
    alerts = con.execute(f"""
        SELECT
            branch_name,
            ROUND(pct_change_vs_sdow_avg * 100, 1) AS pct_drop
        FROM main_marts.mart_daily_revenue
        WHERE order_date = '{target_date}'
          AND pct_change_vs_sdow_avg < -0.15
        ORDER BY pct_change_vs_sdow_avg ASC
    """).fetchall()

    # Net margin snapshot
    net = con.execute(f"""
        SELECT
            SUM(net_revenue) AS net_revenue,
            ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS net_margin_pct
        FROM main_marts.mart_daily_net_revenue
        WHERE metric_date = '{target_date}'
    """).fetchone()

    con.close()
    return {"revenue": revenue, "top_menu": top_menu, "alerts": alerts, "net": net}


def format_message(target_date: date, data: dict) -> str:
    lines = [
        f"🍔 *Restaurant Analytics — Daily Report*",
        f"📅 {target_date.strftime('%A, %B %d, %Y')}",
        "",
        "━━━━━━━━━━━━━━━━━━━━",
        "📊 *Revenue by Location*",
    ]

    total_revenue = 0
    total_orders  = 0

    for branch_name, revenue, orders, pct_change in data["revenue"]:
        arrow = "🟢" if pct_change >= 0 else "🔴"
        sign  = "+" if pct_change >= 0 else ""
        lines.append(
            f"{arrow} *{branch_name}*\n"
            f"   ${revenue:,.2f} ({orders:,} orders) "
            f"[{sign}{pct_change}% vs same-day avg]"
        )
        total_revenue += revenue
        total_orders  += orders

    lines += [
        "",
        "━━━━━━━━━━━━━━━━━━━━",
        f"💰 *Total Revenue: ${total_revenue:,.2f}*",
        f"🧾 *Total Orders: {total_orders:,}*",
    ]

    if data["net"] and data["net"][0] is not None:
        net_rev, net_margin = data["net"]
        lines += [
            f"📈 *Net Revenue: ${net_rev:,.2f}* ({net_margin}% margin)",
        ]

    if data["top_menu"]:
        menu_name, qty = data["top_menu"]
        lines += [
            "",
            "━━━━━━━━━━━━━━━━━━━━",
            "🏆 *Best Seller*",
            f"   {menu_name} ({qty:,} units)",
        ]

    if data["alerts"]:
        lines += [
            "",
            "━━━━━━━━━━━━━━━━━━━━",
            "⚠️ *Alert — Revenue Drop*",
        ]
        for branch_name, pct_drop in data["alerts"]:
            lines.append(
                f"   🔴 {branch_name}: {pct_drop}% vs same-day average"
            )
        lines.append("   _Please check this location immediately._")

    lines += [
        "",
        "━━━━━━━━━━━━━━━━━━━━",
        "_Automated daily report — 6:00 AM_",
    ]

    return "\n".join(lines)


def send_telegram(message: str) -> bool:
    if not BOT_TOKEN or not CHAT_ID:
        print("[WARN] TELEGRAM_BOT_TOKEN or TELEGRAM_CHAT_ID is not set.")
        return False

    url  = f"https://api.telegram.org/bot{BOT_TOKEN}/sendMessage"
    resp = requests.post(url, json={
        "chat_id":    CHAT_ID,
        "text":       message,
        "parse_mode": "Markdown",
    })

    if resp.status_code == 200:
        print("✓ Telegram alert sent successfully")
        return True
    else:
        print(f"✗ Telegram error: {resp.status_code} — {resp.text}")
        return False


def run_alert(target_date: date = None):
    if target_date is None:
        target_date = date.today() - timedelta(days=1)

    print(f"▶ Sending EN alert for {target_date}...")
    data    = fetch_summary(target_date)
    message = format_message(target_date, data)
    print(message)
    send_telegram(message)


if __name__ == "__main__":
    run_alert()
