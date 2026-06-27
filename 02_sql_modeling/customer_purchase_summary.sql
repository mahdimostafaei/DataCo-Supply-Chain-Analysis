CREATE TABLE customer_purchase_summary AS
SELECT
    customer_id,
    COUNT(DISTINCT order_id) AS purchase_count
FROM fact_sales
GROUP BY customer_id;
SELECT *
FROM customer_purchase_summary
ORDER BY purchase_count DESC;

ALTER TABLE customer_purchase_summary
ADD COLUMN purchase_bucket VARCHAR(20);
UPDATE customer_purchase_summary
SET purchase_bucket =
CASE
    WHEN purchase_count = 1 THEN '1 Purchase'
    WHEN purchase_count = 2 THEN '2 Purchases'
    WHEN purchase_count = 3 THEN '3 Purchases'
    WHEN purchase_count BETWEEN 4 AND 5 THEN '4-5 Purchases'
    WHEN purchase_count BETWEEN 6 AND 10 THEN '6-10 Purchases'
    ELSE '10+ Purchases'
END;

ALTER TABLE customer_purchase_summary
ADD COLUMN sort_order INT;

UPDATE customer_purchase_summary
SET sort_order =
CASE
    WHEN purchase_bucket = '1 Purchase' THEN 1
    WHEN purchase_bucket = '2 Purchases' THEN 2
    WHEN purchase_bucket = '3 Purchases' THEN 3
    WHEN purchase_bucket = '4-5 Purchases' THEN 4
    WHEN purchase_bucket = '6-10 Purchases' THEN 5
    WHEN purchase_bucket = '10+ Purchases' THEN 6
END;