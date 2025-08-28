"""
Shopper Recurrence Rate
Calculate recurrence rate metric by merchant and month
"""

import duckdb

# Connect to DuckDB database
con = duckdb.connect("seQura.duckdb")

query = """
CREATE TABLE IF NOT EXISTS shopper_recurrence_rate AS

WITH raw_data AS (
    SELECT order_id, shopper_id, merchant_id, order_date
    FROM 'data/orders_merchant.csv'
),

-- Extract orders (records with dates)
orders AS (
    SELECT
        order_id,
        shopper_id,
        CAST(merchant_id AS INT) AS merchant_id,
        order_date
    FROM raw_data
    WHERE order_date IS NOT NULL
),

-- Extract merchant mapping (records without dates)
merchants AS (
    SELECT
        CAST(order_id AS INT) AS merchant_id,
        shopper_id AS merchant_name
    FROM raw_data
    WHERE order_date IS NULL
      AND merchant_id IS NULL
      AND TRY_CAST(order_id AS INT) IS NOT NULL
),

-- Join orders with merchant names
enriched_orders AS (
    SELECT
        o.*,
        m.merchant_name
    FROM orders o
    LEFT JOIN merchants m ON o.merchant_id = m.merchant_id
),

-- Aggregate to monthly shopper level
monthly_shoppers AS (
    SELECT
        merchant_name,
        shopper_id,
        DATE_TRUNC('month', order_date) AS purchase_month
    FROM enriched_orders
    WHERE merchant_name IS NOT NULL
    GROUP BY merchant_name, shopper_id, purchase_month
),

-- Calculate recurrence flag (11 months lookback = 12 months total)
with_flags AS (
    SELECT
        ms.*,
        CASE 
            WHEN LAG(purchase_month) OVER (
                PARTITION BY merchant_name, shopper_id
                ORDER BY purchase_month
            ) >= purchase_month - INTERVAL '11 months'
            THEN 1 
            ELSE 0 
        END AS is_recurrent
    FROM monthly_shoppers ms
)

-- Final aggregation
SELECT
    CAST(merchant_name AS VARCHAR) AS merchant_name,
    CAST(purchase_month AS DATE) AS month,
    CAST(AVG(is_recurrent::DECIMAL(10,4)) AS DECIMAL(10,4)) AS recurrence_rate
FROM with_flags
GROUP BY merchant_name, month
ORDER BY merchant_name, month;
"""

# Run & save the query results 
con.sql(query)

con.sql("COPY shopper_recurrence_rate TO 'data/shopper_recurrence_rate.csv' (HEADER, DELIMITER ',');")
print("Saved to data/shopper_recurrence_rate.csv")
con.close()