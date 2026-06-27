-- 1. Dim Customers
CREATE TABLE dim_customers (
    customer_id INTEGER PRIMARY KEY,
    customer_fname TEXT,
    customer_lname TEXT,
    customer_city TEXT,
    customer_state TEXT,
    customer_country TEXT,
    customer_zipcode TEXT,
    customer_segment TEXT
);

-- 2. Dim Products
CREATE TABLE dim_products (
    product_id INTEGER PRIMARY KEY,
    product_category_id INTEGER,
    product_category_name TEXT,
    product_name TEXT,
    product_description NUMERIC,
    product_price NUMERIC,
    product_status INTEGER
);

-- 3. Dim Location
CREATE TABLE dim_location (
    location_id SERIAL PRIMARY KEY,
    market TEXT,
    region TEXT,
    country TEXT,
    state TEXT,
    city TEXT,
    latitude NUMERIC,
    longitude NUMERIC
);

-- 4. Fact Sales
CREATE TABLE fact_sales (
    order_item_id INTEGER PRIMARY KEY,
    order_id INTEGER,
    date_key DATE REFERENCES dim_date(date_key),
    customer_id INTEGER REFERENCES dim_customers(customer_id),
    location_id INTEGER REFERENCES dim_location(location_id),
    product_id INTEGER REFERENCES dim_products(product_id),
    quantity INTEGER,
    revenue NUMERIC,
    net_revenue NUMERIC,
    discount NUMERIC,
    profit_ratio NUMERIC,
    discount_ratio NUMERIC,
    late_delivery_risk INTEGER,
    days_for_shipping_real INTEGER,
    days_for_shipping_scheduled INTEGER
);