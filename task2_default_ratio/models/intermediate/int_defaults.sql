SELECT
    order_id,
    shopper_id,
    merchant,
    product_id,
    product,
    order_date,
    month_year_order,
    current_order_value,
    days_unbalanced,
    is_in_default,
    is_in_arrears,
    overdue_principal,
    overdue_fees,
    total_overdue_amount,
    
    -- Delayed period flags
    CASE WHEN days_unbalanced >= 17 THEN 17 ELSE NULL END AS delayed_17,
    CASE WHEN days_unbalanced >= 30 THEN 30 ELSE NULL END AS delayed_30,
    CASE WHEN days_unbalanced >= 60 THEN 60 ELSE NULL END AS delayed_60,
    CASE WHEN days_unbalanced >= 90 THEN 90 ELSE NULL END AS delayed_90

FROM {{ ref('stg_orders') }}