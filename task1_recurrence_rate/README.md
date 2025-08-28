# Shopper Recurrence Rate Model

## Overview
Calculates customer retention by merchant and month using SQL window functions.

## Setup
1. Place source data: `data/orders_merchant.csv`
2. Run: `python calculate_recurrence.py`
3. Outputs: `data/shopper_recurrence_rate.csv|.parquet`

## Model Design
- **Extract**: Parse mixed orders/merchants CSV data
- **Transform**: Apply LAG window function for 11-month lookback
- **Aggregate**: Calculate recurrence rates by merchant-month

## Key Metric
**Recurrence Rate** = % of shoppers with previous purchase within 11 months
- Calculated using LAG window function over (merchant, shopper) partitions
- Outputs by: merchant_name, month

## Key Logic
```sql
LAG(purchase_month) OVER (
   PARTITION BY merchant_name, shopper_id
   ORDER BY purchase_month
) >= purchase_month - INTERVAL '11 months'