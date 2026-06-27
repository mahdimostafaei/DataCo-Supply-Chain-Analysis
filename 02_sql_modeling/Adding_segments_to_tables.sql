---PRODUCT SEGMENTATION

-- determining percentiles
SELECT
    percentile_cont(0.25) WITHIN GROUP (ORDER BY product_price) AS q1,
    percentile_cont(0.75) WITHIN GROUP (ORDER BY product_price) AS q3
FROM dim_products;

-- adding the column
ALTER TABLE dim_products
ADD COLUMN price_segment VARCHAR(20);

--updating the table
UPDATE dim_products
SET price_segment =
CASE
    WHEN product_price <= q.q1 THEN 'Low'
    WHEN product_price <= q.q3 THEN 'Medium'
    ELSE 'High'
END
FROM (
    SELECT
        percentile_cont(0.25) WITHIN GROUP (ORDER BY product_price) AS q1,
        percentile_cont(0.75) WITHIN GROUP (ORDER BY product_price) AS q3
    FROM dim_products
) q;

--check
SELECT price_segment, COUNT(*)
FROM dim_products
GROUP BY price_segment;

--- CUSTOMER SEGMENTATION

--adding columns
ALTER TABLE dim_customers
ADD COLUMN sales_segment VARCHAR(20),
ADD COLUMN revenue_segment VARCHAR(20);

--total sales + revenue per customer + segmentation
WITH customer_metrics AS (
    -- Step 1: Aggregate totals per customer from the mega table
    SELECT 
        customer_id,
        SUM(order_item_quantity) AS total_sales_val,
        SUM(order_item_total) AS total_revenue_val
    FROM supply_chain_orders
    GROUP BY customer_id
),
quartiles AS (
    -- Step 2: Calculate Quartiles from those aggregated values
    SELECT 
        percentile_cont(0.25) WITHIN GROUP (ORDER BY total_sales_val) AS sales_q1,
        percentile_cont(0.75) WITHIN GROUP (ORDER BY total_sales_val) AS sales_q3,
        percentile_cont(0.25) WITHIN GROUP (ORDER BY total_revenue_val) AS rev_q1,
        percentile_cont(0.75) WITHIN GROUP (ORDER BY total_revenue_val) AS rev_q3
    FROM customer_metrics
)
-- Step 3: Update dim_customers with the labels
UPDATE dim_customers c
SET 
    sales_segment = CASE 
        WHEN m.total_sales_val <= q.sales_q1 THEN 'Low'
        WHEN m.total_sales_val <= q.sales_q3 THEN 'Medium'
        ELSE 'High'
    END,
    revenue_segment = CASE 
        WHEN m.total_revenue_val <= q.rev_q1 THEN 'Low'
        WHEN m.total_revenue_val <= q.rev_q3 THEN 'Medium'
        ELSE 'High'
    END
FROM customer_metrics m, quartiles q
WHERE c.customer_id = m.customer_id;

--check
SELECT *
FROM dim_customers
LIMIT 10;

--- REVENUE SEGMENTATION

-- Add column
ALTER TABLE fact_sales
ADD COLUMN revenue_segment VARCHAR(20);

-- Update using quartiles
WITH revenue_quartiles AS (
    SELECT
        percentile_cont(0.25) WITHIN GROUP (ORDER BY net_revenue) AS q1,
        percentile_cont(0.75) WITHIN GROUP (ORDER BY net_revenue) AS q3
    FROM fact_sales
)

UPDATE fact_sales f
SET revenue_segment =
CASE
    WHEN f.net_revenue <= q.q1 THEN 'Low'
    WHEN f.net_revenue <= q.q3 THEN 'Medium'
    ELSE 'High'
END
FROM revenue_quartiles q;

-- Check results
SELECT
    revenue_segment,
    COUNT(*)
FROM fact_sales
GROUP BY revenue_segment
ORDER BY revenue_segment;