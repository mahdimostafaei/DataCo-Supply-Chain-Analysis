-- 1. Create the base table
DROP TABLE IF EXISTS dim_date;

CREATE TABLE dim_date (
    date_key DATE PRIMARY KEY,
    year INTEGER,
    month INTEGER,
    month_name VARCHAR(20),
    quarter INTEGER,
    day_of_week VARCHAR(20),
    is_weekend BOOLEAN,
    year_month INTEGER,
    year_month_label VARCHAR(20)
);

-- 2. Populate the table (FIXED)
INSERT INTO dim_date (
    date_key, year, month, month_name, quarter, 
    day_of_week, is_weekend, year_month, year_month_label
)
SELECT
    d AS date_key,
    EXTRACT(YEAR FROM d) AS year,
    EXTRACT(MONTH FROM d) AS month,
    TRIM(TO_CHAR(d, 'Month')) AS month_name,
    EXTRACT(QUARTER FROM d) AS quarter,
    TRIM(TO_CHAR(d, 'Day')) AS day_of_week,
    CASE 
        WHEN EXTRACT(ISODOW FROM d) IN (6,7) THEN TRUE 
        ELSE FALSE 
    END AS is_weekend,
    (EXTRACT(YEAR FROM d) * 100 + EXTRACT(MONTH FROM d))::INTEGER AS year_month,
    TO_CHAR(d, 'Mon YYYY') AS year_month_label
FROM generate_series(
    '2015-01-01'::DATE,
    '2018-12-31'::DATE,
    INTERVAL '1 day'
) d;

-- 3. Add index
CREATE INDEX idx_dim_date_year_month ON dim_date(year, month);
