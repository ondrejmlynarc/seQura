WITH base AS (
    SELECT
        o.order_id,
        o.shopper_id,
        s.shopper_age,
        s.age_bucket,
        o.month_year_order,
        o.product,
        o.merchant,
        o.current_order_value,
        o.total_overdue_amount,
        o.days_unbalanced,
        o.is_in_default,
        CASE WHEN o.is_in_default THEN 'default' ELSE 'non_default' END AS default_type,
        
        -- Create one row per applicable delayed period
        UNNEST([
            o.delayed_17,
            o.delayed_30,
            o.delayed_60,
            o.delayed_90
        ]) AS delayed_period
        
    FROM {{ ref('int_defaults') }} o
    LEFT JOIN {{ ref('stg_shoppers') }} s
        ON o.shopper_id = s.shopper_id
)

SELECT *
FROM base
WHERE delayed_period IS NOT NULL