WITH source_data AS (
    SELECT * FROM orders
),

cleaned AS (
    SELECT
        *,
        COALESCE(overdue_principal, 0) AS overdue_principal_clean,
        COALESCE(overdue_fees, 0) AS overdue_fees_clean
    FROM source_data
)

SELECT
    order_id,
    shopper_id,
    merchant_id,
    product_id,
    
    CASE 
        WHEN merchant_id = 5 THEN 'AXA'
        WHEN merchant_id = 6 THEN 'Generali'
        WHEN merchant_id = 7 THEN 'BBVA Seguros'
        ELSE 'Unknown'
    END AS merchant,
    
    CASE 
        WHEN product_id = 1 THEN 'Life'
        WHEN product_id = 2 THEN 'Car' 
        WHEN product_id = 3 THEN 'Health'
        WHEN product_id = 4 THEN 'Home'
        ELSE 'Unknown'
    END AS product,
    
    CAST(order_date AS DATE) AS order_date,
    current_order_value,
    days_unbalanced,
    is_in_default,
    
    overdue_principal_clean AS overdue_principal,
    overdue_fees_clean AS overdue_fees,
    overdue_principal_clean + overdue_fees_clean AS total_overdue_amount,
    
    STRFTIME(order_date, '%Y-%m') AS month_year_order,
    
    CASE WHEN days_unbalanced > 0 THEN TRUE ELSE FALSE END AS is_in_arrears

FROM cleaned