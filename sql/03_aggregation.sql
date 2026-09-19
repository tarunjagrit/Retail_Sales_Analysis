/*=========================================================
Retail Sales Analytics
Aggregation Queries

Author   : Manish Kumar Gupta
Database : retail_sales_analytics

Purpose:
Learn SQL aggregation using GROUP BY and HAVING to answer
business questions.

=========================================================*/

USE retail_sales_analytics;

/*---------------------------------------------------------
SECTION 1: Sales by Region

Business Question:
Which regions generate the highest total sales?

SQL Concepts:
GROUP BY, SUM(), ORDER BY

---------------------------------------------------------*/

SELECT
    region,
    ROUND(SUM(sales), 2) AS total_sales
FROM retail_sales
GROUP BY region
ORDER BY total_sales DESC;

/*---------------------------------------------------------
SECTION 2: Profit by Region

Business Question:
Which regions generate the highest total profit?

SQL Concepts:
GROUP BY, SUM(), ORDER BY

---------------------------------------------------------*/

SELECT
    region,
    ROUND(SUM(profit), 2) AS total_profit
FROM retail_sales
GROUP BY region
ORDER BY total_profit DESC;

/*---------------------------------------------------------
SECTION 3: Orders by Region

Business Question:
Which region receives the highest number of orders?

SQL Concepts:
GROUP BY, COUNT(DISTINCT), ORDER BY

---------------------------------------------------------*/

SELECT
    region,
    COUNT(DISTINCT order_id) AS total_orders
FROM retail_sales
GROUP BY region
ORDER BY total_orders DESC;

/*---------------------------------------------------------
SECTION 4: Average Profit by Region

Business Question:
Which region earns the highest average profit per order?

SQL Concepts:
GROUP BY, AVG(), ORDER BY

---------------------------------------------------------*/

SELECT
    region,
    ROUND(AVG(profit), 2) AS average_profit
FROM retail_sales
GROUP BY region
ORDER BY average_profit DESC;

/*---------------------------------------------------------
SECTION 5: Sales by Category

Business Question:
Which product categories contribute the highest sales?

SQL Concepts:
GROUP BY, SUM(), ORDER BY

---------------------------------------------------------*/

SELECT
    category,
    ROUND(SUM(sales), 2) AS total_sales
FROM retail_sales
GROUP BY category
ORDER BY total_sales DESC;

/*---------------------------------------------------------
SECTION 6: Profit by Category

Business Question:
Which product categories generate the highest profit?

SQL Concepts:
GROUP BY, SUM(), ORDER BY

---------------------------------------------------------*/

SELECT
    category,
    ROUND(SUM(profit), 2) AS total_profit
FROM retail_sales
GROUP BY category
ORDER BY total_profit DESC;

/*---------------------------------------------------------
SECTION 7: Sales by Sub-Category

Business Question:
Which product sub-categories generate the highest sales?

SQL Concepts:
GROUP BY, SUM(), ORDER BY

---------------------------------------------------------*/

SELECT
    sub_category,
    ROUND(SUM(sales), 2) AS total_sales
FROM retail_sales
GROUP BY sub_category
ORDER BY total_sales DESC;

/*---------------------------------------------------------
SECTION 8: Profit by Sub-Category

Business Question:
Which product sub-categories generate the highest profit?

SQL Concepts:
GROUP BY, SUM(), ORDER BY

---------------------------------------------------------*/

SELECT
    sub_category,
    ROUND(SUM(profit), 2) AS total_profit
FROM retail_sales
GROUP BY sub_category
ORDER BY total_profit DESC;

/*---------------------------------------------------------
SECTION 9: Categories with High Sales

Business Question:
Which product categories have generated total sales
greater than 500,000?

SQL Concepts:
GROUP BY, HAVING, SUM(), ORDER BY

---------------------------------------------------------*/

SELECT
    category,
    ROUND(SUM(sales), 2) AS total_sales
FROM retail_sales
GROUP BY category
HAVING total_sales > 500000
ORDER BY total_sales DESC;

