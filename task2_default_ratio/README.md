# Loan Default Ratio Model

## Overview
DBT project for calculating loan default ratios across multiple dimensions and delay periods.

## Setup
1. Install dbt: `pip install dbt-duckdb`
2. Install dependencies: `dbt deps`
3. Create test data: `dbt run-operation create_test_data`
4. Run models: `dbt run`
5. Test models: `dbt test`

## Model Architecture
- **Staging**: Clean raw data, map IDs to names
- **Intermediate**: Apply business logic for delay periods
- **Marts**: Calculate final default ratios

## Key Metrics
- Default Ratio = Sum of overdue amounts (debt) / Sum of all loan amounts
- Calculated by: age_bucket, month, product, merchant, delay_period (17/30/60/90 days)