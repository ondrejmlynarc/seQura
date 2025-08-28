SELECT
    age_bucket,
    month_year_order,
    product,
    merchant,
    delayed_period,
    
    -- Default ratio: debt in arrears / total loans amount
    CAST(SUM(CASE WHEN default_type = 'default' THEN total_overdue_amount ELSE 0 END) AS DOUBLE) / 
    NULLIF(SUM(current_order_value), 0) AS default_ratio
    -- Assumption: "loans in arrears" = orders where is_in_default = TRUE   
    -- Alternative considered: using days_unbalanced > 0 for any overdue amount
    
FROM {{ ref('loan_defaults_monitoring') }}

-- Granular segmentation by all dimensions; adjust by removing columns as needed
GROUP BY
    age_bucket,
    month_year_order,
    product,
    merchant,
    delayed_period