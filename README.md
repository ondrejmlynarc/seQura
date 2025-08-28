# SeQura Analytics Engineer Coding Challenge

This repository contains solutions to the SeQura Analytics Engineer coding challenge, structured as per the tasks 1,2.

## Repository Structure
```SEQURA/
├── task1_recurrence_rate/
│   ├── data/
│   ├── calculate_recurrence.sql
│   ├── README.md
│   ├── requirements.txt
│   └── sequra.duckdb
└── task2_default_ratio/
    ├── models/
    │   ├── staging/
    │   │   ├── stg_orders.sql
    │   │   └── stg_shoppers.sql
    │   ├── intermediate/
    │   │   └── int_defaults.sql
    │   └── marts/
    │       ├── loan_default_ratio.sql
    │       └── loan_defaults_monitoring.sql
    ├── macros/
    │   └── create_test_data.sql
    ├── dbt_project.yml
    ├── profiles.yml
    ├── packages.yml
    ├── schema.yml
    └── README.md
```

## Task 1 - SQL Data Extraction
**Shopper Recurrence Rate Calculation**

Calculate customer loyalty metrics by measuring repeat purchase behavior. Delivers monthly recurrence rates by merchant using SQL queries.

[Go to Task 1 Solution](./task1_recurrence_rate/)

## Task 2 - DBT Data Modeling
**Loan Default Ratio Model**

Build DBT models to monitor loan default patterns for risk management. Creates production-ready data pipeline with comprehensive testing and documentation.

[Go to Task 2 Solution](./task2_default_ratio/)

## Quick Start

### Task 1 (SQL)
```bash
cd task1_recurrence_rate/
# Review calculate_recurrence.sql for SQL solution
# Check README.md for detailed explanations
```


## Task 2 (DBT)
```bash
cd task2_default_ratio/
dbt deps
dbt run-operation create_test_data
dbt run
dbt test
```

Each task folder contains detailed documentation explaining approach, assumptions, and business logic.