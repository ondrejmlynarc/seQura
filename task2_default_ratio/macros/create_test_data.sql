{% macro create_test_data() %}
  {% set sql %}
    DROP TABLE IF EXISTS orders;
    DROP TABLE IF EXISTS shoppers;

    CREATE TABLE shoppers (
      shopper_id INT PRIMARY KEY,
      dob DATE
    );

    CREATE TABLE orders (
      order_id INT PRIMARY KEY,
      shopper_id INT,
      merchant_id INT,
      product_id INT,
      order_date DATE,
      current_order_value DECIMAL(10,2),
      days_unbalanced INT,
      is_in_default BOOLEAN,
      overdue_principal DECIMAL(10,2) DEFAULT 0,
      overdue_fees DECIMAL(10,2) DEFAULT 0
    );

    INSERT INTO shoppers (shopper_id, dob) VALUES
    (208, '1960-05-15'),  -- 64 years old (60+)
    (209, '1998-12-01'),  -- 26 years old (18-29)
    (210, '1970-09-20'),  -- 54 years old (45-59)
    (211, '2002-03-10'),  -- 22 years old (18-29)
    (212, '1988-11-25'),  -- 36 years old (30-44)
    (213, '1995-07-10'),  -- 29 years old (18-29)
    (214, '1985-04-22');  -- 39 years old (30-44)

    INSERT INTO orders (order_id, shopper_id, merchant_id, product_id, order_date, current_order_value, days_unbalanced, is_in_default, overdue_principal, overdue_fees) VALUES
    -- Test different delay periods for same segment (AXA, Life, Jan 2024)
    (1, 208, 5, 1, '2024-01-15', 1000, 10, false, 0.00, 0.00),        -- Below 17 days, won't appear
    (2, 209, 5, 1, '2024-01-15', 2000, 20, false, 0.00, 0.00),        -- 17+ days only
    (3, 210, 5, 1, '2024-01-15', 1500, 20, true, 100.00, 10.00),      -- 17+ days, in default
    (4, 211, 5, 1, '2024-01-15', 3000, 35, true, 200.00, 20.00),      -- 17+ and 30+ days
    (5, 212, 5, 1, '2024-01-15', 2500, 65, false, 0.00, 0.00),        -- 17, 30, 60+ days
    (6, 213, 5, 1, '2024-01-15', 1800, 95, true, 500.00, 50.00),      -- All periods
    
    -- Mixed default status in same segment (Generali, Car, Feb 2024)
    (7, 208, 6, 2, '2024-02-01', 5000, 45, true, 1000.00, 100.00),    -- Default
    (8, 209, 6, 2, '2024-02-01', 4000, 45, false, 0.00, 0.00),        -- Same days, not default
    (9, 210, 6, 2, '2024-02-01', 3500, 45, true, 800.00, 80.00),      -- Default
    
    -- Test edge cases
    (10, 211, 7, 3, '2024-03-01', 1000, 0, false, 0.00, 0.00),        -- No delay
    (11, 211, 7, 3, '2024-03-01', 1000, 17, true, 50.00, 5.00),       -- Exactly 17 days
    (12, 211, 7, 3, '2024-03-01', 1000, 30, true, 75.00, 7.50),       -- Exactly 30 days
    (13, 211, 7, 3, '2024-03-01', 1000, 60, true, 150.00, 15.00),     -- Exactly 60 days
    (14, 211, 7, 3, '2024-03-01', 1000, 90, true, 300.00, 30.00),     -- Exactly 90 days
    
    -- Large amounts for ratio testing
    (15, 214, 5, 4, '2024-02-15', 10000, 25, false, 0.00, 0.00),      -- Large loan, not default
    (16, 214, 5, 4, '2024-02-15', 10000, 25, true, 5000.00, 500.00),  -- Large loan, in default
    (17, 212, 5, 4, '2024-02-15', 500, 25, true, 50.00, 5.00),        -- Small loan, in default
    
    -- Different months 
    (18, 208, 6, 1, '2024-01-01', 2000, 35, true, 400.00, 40.00),
    (19, 208, 6, 1, '2024-02-01', 2000, 35, true, 450.00, 45.00),
    (20, 208, 6, 1, '2024-03-01', 2000, 35, false, 0.00, 0.00);
  {% endset %}

  {% do run_query(sql) %}
  {{ log("Test data created successfully!", info=True) }}
{% endmacro %}