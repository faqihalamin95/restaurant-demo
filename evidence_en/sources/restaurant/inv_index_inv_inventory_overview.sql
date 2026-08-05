WITH max_d AS (
    SELECT MAX(txn_date)::DATE AS d FROM main_marts.mart_inventory_stok
),
latest AS (
    SELECT *
    FROM main_marts.mart_inventory_stok CROSS JOIN max_d
    WHERE txn_date = d
),
movement_7 AS (
    SELECT
        SUM(usage_cost) AS usage_cost_7d,
        SUM(purchase_cost) AS purchase_cost_7d
    FROM main_marts.mart_inventory_stok CROSS JOIN max_d
    WHERE txn_date >= d - INTERVAL '6 days'
),
movement_30 AS (
    SELECT
        SUM(usage_cost) AS usage_cost_30d,
        SUM(purchase_cost) AS purchase_cost_30d,
        ROUND(SUM(purchase_cost)/NULLIF(SUM(usage_cost),0),2) AS purchase_usage_ratio_30d
    FROM main_marts.mart_inventory_stok CROSS JOIN max_d
    WHERE txn_date >= d - INTERVAL '29 days'
),
price_30 AS (
    SELECT
        ROUND(AVG(CASE WHEN base_unit_cost > 0 THEN (avg_unit_cost-base_unit_cost)/base_unit_cost*100 END),1) AS avg_price_variance_pct,
        COUNT(DISTINCT CASE WHEN base_unit_cost > 0 AND (avg_unit_cost-base_unit_cost)/base_unit_cost*100 > 10 THEN item_name END) AS price_alert_items
    FROM main_marts.mart_inventory_stok CROSS JOIN max_d
    WHERE txn_date >= d - INTERVAL '29 days'
),
summary AS (
    SELECT
        COUNT(*) AS stock_points,
        COUNT(DISTINCT item_name) AS total_items,
        COUNT(DISTINCT branch_name) AS total_branches,
        ROUND(SUM(stock_value),0) AS stock_value,
        SUM(CASE WHEN stock_status = 'low' OR days_remaining < 3 THEN 1 ELSE 0 END) AS low_points,
        COUNT(DISTINCT CASE WHEN stock_status = 'low' OR days_remaining < 3 THEN item_name END) AS low_items,
        SUM(CASE WHEN stock_status = 'overstock' OR days_remaining > 14 THEN 1 ELSE 0 END) AS overstock_points,
        COUNT(DISTINCT CASE WHEN stock_status = 'overstock' OR days_remaining > 14 THEN item_name END) AS overstock_items,
        ROUND(SUM(CASE WHEN stock_status = 'overstock' OR days_remaining > 14 THEN stock_value ELSE 0 END),0) AS overstock_value,
        ROUND(MIN(days_remaining),1) AS min_days_remaining
    FROM latest
)
SELECT
    s.*,
    m7.usage_cost_7d,
    m7.purchase_cost_7d,
    m30.usage_cost_30d,
    m30.purchase_cost_30d,
    m30.purchase_usage_ratio_30d,
    p.avg_price_variance_pct,
    p.price_alert_items,
    ROUND(s.overstock_value / NULLIF(s.stock_value,0) * 100,1) AS overstock_value_pct,
    CASE
        WHEN s.low_points > 0 THEN 'Kritis'
        WHEN s.overstock_value / NULLIF(s.stock_value,0) > 0.25 OR p.price_alert_items > 0 OR m30.purchase_usage_ratio_30d > 1.3 THEN 'Waspada'
        ELSE 'Sehat'
    END AS health_status,
    CASE
        WHEN s.low_points > 0 THEN 'Ada item yang mendekati habis. Prioritas pertama adalah mencegah menu tidak bisa dijual.'
        WHEN s.overstock_value / NULLIF(s.stock_value,0) > 0.25 THEN 'Modal mulai tertahan di stok berlebih. Cek tab Overstock untuk item dan cabang spesifik.'
        WHEN p.price_alert_items > 0 THEN 'Harga supplier mulai menekan biaya bahan. Cek tab Supplier untuk prioritas negosiasi.'
        WHEN m30.purchase_usage_ratio_30d > 1.3 THEN 'Pembelian lebih cepat dari pemakaian. Jadwal pengadaan perlu direview.'
        ELSE 'Stok aktual, ritme pemakaian, dan tekanan harga masih terkendali.'
    END AS diagnosis
FROM summary s, movement_7 m7, movement_30 m30, price_30 p
