-- =====================================================
-- Business Question 1
-- =====================================================
-- Question:
-- Which states generate the highest sales and profit?

-- Objective:
-- Identify top-performing states based on revenue and profitability.

-- Query:

SELECT
    state,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM retail_sales
GROUP BY state
ORDER BY total_sales DESC;

-- =====================================================
-- Business Question 2
-- =====================================================
-- Question:
-- Which states are generating losses overall?
--
-- Objective:
-- Identify states where the business is unprofitable so management can
-- investigate pricing, discounts, logistics, or operational issues.
-- =====================================================

SELECT
    state,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM retail_sales
GROUP BY state
HAVING SUM(profit) < 0
ORDER BY total_profit;

-- =====================================================
-- Business Question 3
-- =====================================================
-- Question:
-- Which states have the highest profit margins?
--
-- Objective:
-- Identify states that are converting sales into profit most efficiently.
-- =====================================================

SELECT
    state,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS profit_margin_percentage
FROM retail_sales
GROUP BY state
HAVING SUM(sales) > 0
ORDER BY profit_margin_percentage DESC;

-- =====================================================
-- Business Question 4
-- =====================================================
-- Question:
-- Which customers generate the highest profit?
--
-- Objective:
-- Identify the company's most valuable customers based on profitability.
-- =====================================================

SELECT
    customer_name,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM retail_sales
GROUP BY customer_name
ORDER BY total_profit DESC
LIMIT 10;

-- =====================================================
-- Business Question 5
-- =====================================================
-- Question:
-- Which products are causing the highest losses?
--
-- Objective:
-- Identify products that consistently reduce overall profitability.
-- =====================================================

SELECT
    product_name,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM retail_sales
GROUP BY product_name
HAVING SUM(profit) < 0
ORDER BY total_profit
LIMIT 10;

-- =====================================================
-- Business Question 6
-- =====================================================
-- Question:
-- Which product categories receive the highest average discount?
--
-- Objective:
-- Identify categories where heavy discounting may be affecting profitability.
-- =====================================================

SELECT
    category,
    ROUND(AVG(discount) * 100, 2) AS average_discount_percentage
FROM retail_sales
GROUP BY category
ORDER BY average_discount_percentage DESC;

-- =====================================================
-- Business Question 7
-- =====================================================
-- Question:
-- Which customer segments contribute the most to sales and profit?
--
-- Objective:
-- Compare the performance of each customer segment to support
-- targeted marketing and resource allocation.
-- =====================================================

SELECT
    segment,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    COUNT(DISTINCT customer_id) AS total_customers
FROM retail_sales
GROUP BY segment
ORDER BY total_sales DESC;

-- =====================================================
-- Business Question 8
-- =====================================================
-- Question:
-- Which shipping modes generate the highest profit?
--
-- Objective:
-- Evaluate the profitability of different shipping methods.
-- =====================================================

SELECT
    ship_mode,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(AVG(shipping_days), 2) AS avg_shipping_days
FROM retail_sales
GROUP BY ship_mode
ORDER BY total_profit DESC;

-- =====================================================
-- Business Question 9
-- =====================================================
-- Question:
-- Which sub-categories have a negative profit margin?
--
-- Objective:
-- Identify product sub-categories where overall profitability
-- is below zero despite generating sales.
-- =====================================================

SELECT
    sub_category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS profit_margin_percentage
FROM retail_sales
GROUP BY sub_category
HAVING SUM(profit) < 0
ORDER BY profit_margin_percentage;

-- =====================================================
-- Business Question 10
-- =====================================================
-- Question:
-- Which years recorded the highest sales and profit?
--
-- Objective:
-- Evaluate business growth over time and identify the best-performing years.
-- =====================================================

SELECT
    order_year,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM retail_sales
GROUP BY order_year
ORDER BY order_year;

-- =====================================================
-- Business Question 11
-- =====================================================
-- Question:
-- Classify each order based on its profitability.
--
-- Objective:
-- Categorize orders into Profit, Break-even, and Loss to understand
-- the distribution of order performance.
-- =====================================================

SELECT
    CASE
        WHEN profit > 0 THEN 'Profit'
        WHEN profit = 0 THEN 'Break-even'
        ELSE 'Loss'
    END AS profit_status,
    COUNT(*) AS total_orders,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM retail_sales
GROUP BY profit_status
ORDER BY total_orders DESC;

-- =====================================================
-- Business Question 12
-- =====================================================
-- Question:
-- How does profitability vary across different discount levels?
--
-- Objective:
-- Determine whether higher discounts negatively impact profitability.
-- =====================================================

SELECT
    CASE
        WHEN discount = 0 THEN 'No Discount'
        WHEN discount <= 0.20 THEN 'Low Discount'
        WHEN discount <= 0.40 THEN 'Medium Discount'
        ELSE 'High Discount'
    END AS discount_category,
    COUNT(*) AS total_orders,
    ROUND(AVG(profit), 2) AS average_profit,
    ROUND(SUM(profit), 2) AS total_profit
FROM retail_sales
GROUP BY discount_category
ORDER BY average_profit DESC;

-- =====================================================
-- Business Question 13
-- =====================================================
-- Question:
-- Which customers have placed more than 10 orders?
--
-- Objective:
-- Identify loyal customers who purchase frequently.
-- =====================================================

SELECT
    customer_name,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM retail_sales
GROUP BY customer_name
HAVING COUNT(DISTINCT order_id) > 10
ORDER BY total_orders DESC;

-- =====================================================
-- Business Question 14
-- =====================================================
-- Question:
-- Which categories receive the highest average discounts?
--
-- Objective:
-- Compare discounting strategies across product categories.
-- =====================================================

SELECT
    category,
    ROUND(AVG(discount) * 100, 2) AS average_discount_percentage,
    ROUND(SUM(profit), 2) AS total_profit
FROM retail_sales
GROUP BY category
ORDER BY average_discount_percentage DESC;

-- =====================================================
-- Business Question 15
-- =====================================================
-- Question:
-- Which customers generated more sales than the average customer?
--
-- Objective:
-- Identify above-average customers for targeted retention and marketing.
-- =====================================================

SELECT
    customer_name,
    ROUND(SUM(sales), 2) AS total_sales
FROM retail_sales
GROUP BY customer_name
HAVING SUM(sales) >
(
    SELECT AVG(total_sales)
    FROM
    (
        SELECT
            SUM(sales) AS total_sales
        FROM retail_sales
        GROUP BY customer_name
    ) AS customer_sales
)
ORDER BY total_sales DESC;

-- =====================================================
-- Business Question 16
-- =====================================================
-- Question:
-- Which products generate above-average profit?
--
-- Objective:
-- Identify high-performing products for inventory and marketing focus.
-- =====================================================

SELECT
    product_name,
    ROUND(SUM(profit), 2) AS total_profit
FROM retail_sales
GROUP BY product_name
HAVING SUM(profit) >
(
    SELECT AVG(total_profit)
    FROM
    (
        SELECT
            SUM(profit) AS total_profit
        FROM retail_sales
        GROUP BY product_name
    ) AS product_profit
)
ORDER BY total_profit DESC;

-- =====================================================
-- Business Question 17
-- =====================================================
-- Question:
-- Which orders have sales greater than the overall average order sales?
--
-- Objective:
-- Identify high-value orders for sales pattern analysis.
-- =====================================================

SELECT
    order_id,
    customer_name,
    ROUND(sales, 2) AS sales,
    ROUND(profit, 2) AS profit
FROM retail_sales
WHERE sales >
(
    SELECT AVG(sales)
    FROM retail_sales
)
ORDER BY sales DESC;

-- =====================================================
-- Business Question 18
-- =====================================================
-- Question:
-- Rank customer segments by total profit.
--
-- Objective:
-- Compare the profitability of customer segments using a CTE.
-- =====================================================

WITH segment_profit AS
(
    SELECT
        segment,
        SUM(profit) AS total_profit
    FROM retail_sales
    GROUP BY segment
)

SELECT
    segment,
    ROUND(total_profit, 2) AS total_profit
FROM segment_profit
ORDER BY total_profit DESC;

-- =====================================================
-- Business Question 19
-- =====================================================
-- Question:
-- Which regions contribute more than 25% of total sales?
--
-- Objective:
-- Identify regions that are major revenue contributors.
-- =====================================================

WITH region_sales AS
(
    SELECT
        region,
        SUM(sales) AS total_sales
    FROM retail_sales
    GROUP BY region
)

SELECT
    region,
    ROUND(total_sales, 2) AS total_sales,
    ROUND(
        total_sales /
        (SELECT SUM(sales) FROM retail_sales) * 100,
        2
    ) AS sales_percentage
FROM region_sales
WHERE total_sales >
(
    SELECT SUM(sales) * 0.25
    FROM retail_sales
)
ORDER BY sales_percentage DESC;

-- =====================================================
-- Business Question 20
-- =====================================================
-- Question:
-- Rank states based on total sales.
--
-- Objective:
-- Identify the highest revenue-generating states.
-- =====================================================

SELECT
    state_province,
    ROUND(SUM(sales), 2) AS total_sales,
    RANK() OVER (ORDER BY SUM(sales) DESC) AS sales_rank
FROM retail_sales
GROUP BY state_province;

-- =====================================================
-- Business Question 21
-- =====================================================
-- Question:
-- Rank customers based on total profit.
--
-- Objective:
-- Identify the most profitable customers.
-- =====================================================

SELECT
    customer_name,
    ROUND(SUM(profit), 2) AS total_profit,
    DENSE_RANK() OVER (ORDER BY SUM(profit) DESC) AS profit_rank
FROM retail_sales
GROUP BY customer_name;

-- =====================================================
-- Business Question 22
-- =====================================================
-- Question:
-- Find the top 3 products in each category based on sales.
--
-- Objective:
-- Identify the best-selling products within every category.
-- =====================================================

WITH product_sales AS
(
    SELECT
        category,
        product_name,
        SUM(sales) AS total_sales,
        ROW_NUMBER() OVER
        (
            PARTITION BY category
            ORDER BY SUM(sales) DESC
        ) AS row_num
    FROM retail_sales
    GROUP BY category, product_name
)

SELECT
    category,
    product_name,
    ROUND(total_sales, 2) AS total_sales
FROM product_sales
WHERE row_num <= 3
ORDER BY category, total_sales DESC;

-- =====================================================
-- Business Question 23
-- =====================================================
-- Question:
-- Calculate the cumulative sales over the years.
--
-- Objective:
-- Analyze overall business growth using running totals.
-- =====================================================

SELECT
    order_year,
    ROUND(SUM(sales), 2) AS yearly_sales,
    ROUND(
        SUM(SUM(sales)) OVER
        (
            ORDER BY order_year
        ),
        2
    ) AS cumulative_sales
FROM retail_sales
GROUP BY order_year
ORDER BY order_year;

-- =====================================================
-- Business Question 24
-- =====================================================
-- Question:
-- Compare each year's sales with the previous year.
--
-- Objective:
-- Measure year-over-year sales growth.
-- =====================================================

WITH yearly_sales AS
(
    SELECT
        order_year,
        SUM(sales) AS total_sales
    FROM retail_sales
    GROUP BY order_year
)

SELECT
    order_year,
    ROUND(total_sales, 2) AS total_sales,
    ROUND(
        LAG(total_sales) OVER (ORDER BY order_year),
        2
    ) AS previous_year_sales,
    ROUND(
        total_sales -
        LAG(total_sales) OVER (ORDER BY order_year),
        2
    ) AS sales_difference
FROM yearly_sales;

-- =====================================================
-- Business Question 25
-- =====================================================
-- Question:
-- Which customers contribute to the top 80% of total sales?
--
-- Objective:
-- Identify the customers responsible for the majority of revenue.
-- =====================================================

WITH customer_sales AS
(
    SELECT
        customer_name,
        SUM(sales) AS total_sales
    FROM retail_sales
    GROUP BY customer_name
),
ranked_sales AS
(
    SELECT
        customer_name,
        total_sales,
        SUM(total_sales) OVER (ORDER BY total_sales DESC) AS cumulative_sales,
        SUM(total_sales) OVER () AS overall_sales
    FROM customer_sales
)

SELECT
    customer_name,
    ROUND(total_sales, 2) AS total_sales,
    ROUND(cumulative_sales, 2) AS cumulative_sales,
    ROUND((cumulative_sales / overall_sales) * 100, 2) AS cumulative_percentage
FROM ranked_sales
WHERE cumulative_sales <= overall_sales * 0.80
ORDER BY total_sales DESC;

-- =====================================================
-- Business Question 26
-- =====================================================
-- Question:
-- Which products have never generated a loss?
--
-- Objective:
-- Identify consistently profitable products.
-- =====================================================

SELECT
    product_name,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM retail_sales
GROUP BY product_name
HAVING MIN(profit) >= 0
ORDER BY total_profit DESC;

-- =====================================================
-- Business Question 27
-- =====================================================
-- Question:
-- Which customers have the highest average order value?
--
-- Objective:
-- Identify customers who spend the most per order.
-- =====================================================

SELECT
    customer_name,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(sales) / COUNT(DISTINCT order_id), 2) AS average_order_value
FROM retail_sales
GROUP BY customer_name
HAVING COUNT(DISTINCT order_id) > 1
ORDER BY average_order_value DESC
LIMIT 10;

-- =====================================================
-- Business Question 28
-- =====================================================
-- Question:
-- Which categories contribute the most to total profit?
--
-- Objective:
-- Determine each category's contribution to overall profitability.
-- =====================================================

SELECT
    category,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        SUM(profit) /
        (SELECT SUM(profit) FROM retail_sales) * 100,
        2
    ) AS profit_contribution_percentage
FROM retail_sales
GROUP BY category
ORDER BY total_profit DESC;

-- =====================================================
-- Business Question 29
-- =====================================================
-- Question:
-- Which month records the highest average sales per order?
--
-- Objective:
-- Identify seasonal patterns in customer spending.
-- =====================================================

SELECT
    order_month,
    ROUND(AVG(sales), 2) AS average_sales_per_order
FROM retail_sales
GROUP BY order_month, order_month_num
ORDER BY average_sales_per_order DESC;

-- =====================================================
-- Business Question 30
-- =====================================================
-- Question:
-- Which orders generated the highest profit?
--
-- Objective:
-- Identify exceptionally profitable orders for further analysis.
-- =====================================================

SELECT
    order_id,
    customer_name,
    product_name,
    ROUND(sales, 2) AS sales,
    ROUND(profit, 2) AS profit
FROM retail_sales
ORDER BY profit DESC
LIMIT 10;

