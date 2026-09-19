/*=========================================================
Retail Sales Analytics
Basic SQL Queries

Author   : Manish Kumar Gupta
Database : retail_sales_analytics

Purpose:
Practice fundamental SQL queries before moving to
business-oriented analysis.

=========================================================*/

USE retail_sales_analytics;

/*---------------------------------------------------------
SECTION 1: View the Data
---------------------------------------------------------*/

SELECT *
FROM retail_sales
LIMIT 10;

-- Display Sales, Profit and Category

SELECT
    category,
    sales,
    profit
FROM retail_sales;

-- List all product categories

SELECT DISTINCT 
    category
FROM retail_sales;

/*---------------------------------------------------------
Business Question:
Which individual orders generated the highest sales?
---------------------------------------------------------*/

SELECT
    order_id,
    customer_name,
    sales
FROM retail_sales
ORDER BY sales DESC
LIMIT 10;

/*---------------------------------------------------------
Business Question:
Which individual orders generated the lowest profit?
---------------------------------------------------------*/

SELECT
    order_id,
    customer_name,
    profit
FROM retail_sales
ORDER BY profit ASC
LIMIT 10;

-- Filtering Data

SELECT *
FROM retail_sales
WHERE category = 'Technology';

—- Loss-making Orders

SELECT
    order_id,
    product_name,
    sales,
    profit
FROM retail_sales
WHERE profit < 0;

-- Orders with High Discounts

SELECT
    order_id,
    discount,
    sales,
    profit
FROM retail_sales
WHERE discount >= 0.5;

-- Aggregate Functions
-- Total Sales, Profit, Order, Avg Discount, Max Sales, Min Profit

SELECT
    ROUND(SUM(sales),2) AS total_sales
FROM retail_sales;

SELECT
    ROUND(SUM(profit),2) AS total_profit
FROM retail_sales;

SELECT
    COUNT(DISTINCT order_id) AS total_orders
FROM retail_sales;

SELECT
    ROUND(AVG(discount),2) AS average_discount
FROM retail_sales;

SELECT
    MAX(sales) AS highest_sale
FROM retail_sales;

SELECT
    MIN(profit) AS lowest_profit
FROM retail_sales;