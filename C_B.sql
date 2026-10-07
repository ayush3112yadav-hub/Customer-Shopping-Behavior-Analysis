/* =====================================================================
   Customer Shopping Behavior - SQL Analysis (SQL Server / T-SQL)
   Database : Customer_Behavior
   Table    : dbo.customer_clean   (3,900 rows, created from Python)
   Columns  : customerid, age, gender, item_purchased, category,
              purchase_amount (or purchase_amount_usd), location, size,
              color, season, review_rating, subscription_status,
              shipping_type, discount_applied, previous_purchases,
              payment_method, frequency_of_purchases, age_group,
              purchase_frequency_days
   NOTE: if your column is still named purchase_amount_usd, replace
         purchase_amount with purchase_amount_usd below.
   ===================================================================== */
 
USE Customer_Behavior;
GO



/* ---------------------------------------------------------------------
   Q1. Revenue by gender
   Business question: Which gender segment brings in more revenue?
   --------------------------------------------------------------------- */

SELECT
    gender,
    COUNT(*)                                   AS total_orders,
    SUM(purchase_amount)                       AS total_revenue,
    ROUND(AVG(CAST(purchase_amount AS FLOAT)), 2) AS avg_order_value
FROM dbo.customer_behavior
GROUP BY gender
ORDER BY total_revenue DESC;



/* ---------------------------------------------------------------------
   Q2. Top 5 products by average review rating
   Business question: Which products do customers rate highest?
   --------------------------------------------------------------------- */

SELECT TOP 5
    item_purchased,
    ROUND(AVG(review_rating), 2) AS avg_rating,
    COUNT(*)                     AS num_purchases
FROM dbo.customer_behavior
GROUP BY item_purchased
ORDER BY avg_rating DESC;



/* ---------------------------------------------------------------------
   Q3. Average purchase amount: Standard vs Express shipping
   Business question: Do customers who pay for faster shipping spend more?
   --------------------------------------------------------------------- */

SELECT
    shipping_type,
    COUNT(*)                                      AS total_orders,
    ROUND(AVG(CAST(purchase_amount AS FLOAT)), 2) AS avg_purchase_amount
FROM dbo.customer_behavior
WHERE shipping_type IN ('Standard', 'Express')
GROUP BY shipping_type;



/* ---------------------------------------------------------------------
   Q4. Do subscribers spend more than non-subscribers?
   Business question: Is the subscription program tied to higher value?
   --------------------------------------------------------------------- */

SELECT
    subscription_status,
    COUNT(*)                                      AS total_customers,
    ROUND(AVG(CAST(purchase_amount AS FLOAT)), 2) AS avg_spend,
    SUM(purchase_amount)                          AS total_revenue,
    ROUND(100.0 * SUM(purchase_amount)
          / SUM(SUM(purchase_amount)) OVER (), 2) AS revenue_share_pct
FROM dbo.customer_behavior
GROUP BY subscription_status
ORDER BY total_revenue DESC;



/* ---------------------------------------------------------------------
   Q5. Top 5 products with the highest share of discounted purchases
   Business question: Which products depend most on discounts?
   --------------------------------------------------------------------- */

SELECT TOP 5
    item_purchased,
    COUNT(*) AS total_purchases,
    SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) AS discounted_purchases,
    ROUND(100.0 * SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END)
          / COUNT(*), 2) AS discount_rate_pct
FROM dbo.customer_behavior
GROUP BY item_purchased
ORDER BY discount_rate_pct DESC;



/* ---------------------------------------------------------------------
   Q6. Customer segments by previous purchases
   Business question: How many customers are new, returning, or loyal?
   Thresholds (previous_purchases ranges 1-50): New <= 10,
   Returning 11-30, Loyal > 30. Adjust to taste.
   --------------------------------------------------------------------- */

WITH segmented AS (
    SELECT
        customer_id,
        purchase_amount,
        CASE
            WHEN previous_purchases <= 10 THEN 'New'
            WHEN previous_purchases <= 30 THEN 'Returning'
            ELSE 'Loyal'
        END AS customer_segment
    FROM dbo.customer_behavior
)
SELECT
    customer_segment,
    COUNT(*)                                      AS num_customers,
    ROUND(AVG(CAST(purchase_amount AS FLOAT)), 2) AS avg_spend,
    SUM(purchase_amount)                          AS total_revenue
FROM segmented
GROUP BY customer_segment
ORDER BY total_revenue DESC;



/* ---------------------------------------------------------------------
   Q7. Revenue contribution by age group
   Business question: Which age groups drive the most revenue?
   --------------------------------------------------------------------- */

SELECT
    age_group,
    COUNT(*)             AS total_orders,
    SUM(purchase_amount) AS total_revenue,
    ROUND(100.0 * SUM(purchase_amount)
          / SUM(SUM(purchase_amount)) OVER (), 2) AS revenue_share_pct
FROM dbo.customer_behavior
GROUP BY age_group
ORDER BY total_revenue DESC;



/* ---------------------------------------------------------------------
   Q8. Top 3 products per category (window function)
   Business question: What are the best-selling products in each category?
   Ranked by number of purchases.
   --------------------------------------------------------------------- */

WITH product_counts AS (
    SELECT
        category,
        item_purchased,
        COUNT(*) AS total_purchases
    FROM dbo.customer_behavior
    GROUP BY category, item_purchased
),
ranked AS (
    SELECT
        category,
        item_purchased,
        total_purchases,
        ROW_NUMBER() OVER (
            PARTITION BY category
            ORDER BY total_purchases DESC
        ) AS rank_in_category
    FROM product_counts
)
SELECT category, item_purchased, total_purchases, rank_in_category
FROM ranked
WHERE rank_in_category <= 3
ORDER BY category, rank_in_category;