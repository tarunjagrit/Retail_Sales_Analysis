CREATE DATABASE retail_sales_analytics;

USE retail_sales_analytics;

CREATE TABLE retail_sales (
    row_id INT PRIMARY KEY,
    order_id VARCHAR(20),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(30),
    customer_id VARCHAR(20),
    customer_name VARCHAR(100),
    segment VARCHAR(30),
    country_region VARCHAR(50),
    city VARCHAR(100),
    state_province VARCHAR(100),
    postal_code INT,
    region VARCHAR(30),
    product_id VARCHAR(30),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(255),
    sales DECIMAL(10,2),
    quantity INT,
    discount DECIMAL(5,2),
    profit DECIMAL(10,2),
    order_month VARCHAR(20),
    order_year INT,
    order_day VARCHAR(20),
    shipping_days INT,
    profit_margin DECIMAL(10,4),
    is_loss VARCHAR(5),
    order_month_num INT
);

SELECT VERSION();

SHOW TABLES;

DESCRIBE retail_sales;

SHOW GLOBAL VARIABLES LIKE 'local_infile';

LOAD DATA LOCAL INFILE 'I:/Use Case/Retails-Sales-Analytics/data/cleaned/sample_-_superstore.csv'
INTO TABLE retail_sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
row_id,
order_id,
order_date,
ship_date,
ship_mode,
customer_id,
customer_name,
segment,
country_region,
city,
state_province,
postal_code,
region,
product_id,
category,
sub_category,
product_name,
sales,
quantity,
discount,
profit,
order_month,
order_year,
order_day,
shipping_days,
profit_margin,
is_loss,
order_month_num
);

SELECT COUNT(*) FROM retail_sales;

SELECT * FROM retail_sales LIMIT 5;

SELECT COUNT(*) AS total_rows

SELECT * FROM retail_sales LIMIT 10;

SELECT
    MIN(sales),
    MAX(sales),
    AVG(sales)
FROM retail_sales;

SELECT
    COUNT(*),
    COUNT(DISTINCT customer_id),
    COUNT(DISTINCT product_id)
FROM retail_sales;

/*---------------------------------------------------------
DATA MIGRATION: Convert Text Dates to MySQL DATE Format

Reason:
The cleaned CSV stores dates as M/D/YYYY, while MySQL DATE
expects YYYY-MM-DD. Importing directly into DATE columns
results in invalid values (0000-00-00). The following steps
safely convert the imported text into proper DATE values.

Concepts:
- ALTER TABLE
- STR_TO_DATE()
- UPDATE
- Data Migration (ETL)
---------------------------------------------------------*/

DROP TABLE retail_sales;

CREATE TABLE retail_sales (
    row_id INT PRIMARY KEY,
    order_id VARCHAR(20),
	order_date VARCHAR(20),
	ship_date VARCHAR(20),
    ship_mode VARCHAR(30),
    customer_id VARCHAR(20),
    customer_name VARCHAR(100),
    segment VARCHAR(30),
    country_region VARCHAR(50),
    city VARCHAR(100),
    state_province VARCHAR(100),
    postal_code INT,
    region VARCHAR(30),
    product_id VARCHAR(30),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(255),
    sales DECIMAL(10,2),
    quantity INT,
    discount DECIMAL(5,2),
    profit DECIMAL(10,2),
    order_month VARCHAR(20),
    order_year INT,
    order_day VARCHAR(20),
    shipping_days INT,
    profit_margin DECIMAL(10,4),
    is_loss VARCHAR(5),
    order_month_num INT
);

use retail_sales_analytics;

LOAD DATA LOCAL INFILE 'I:/Use Case/Retails-Sales-Analytics/data/cleaned/sample_-_superstore.csv'
INTO TABLE retail_sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
row_id,
order_id,
order_date,
ship_date,
ship_mode,
customer_id,
customer_name,
segment,
country_region,
city,
state_province,
postal_code,
region,
product_id,
category,
sub_category,
product_name,
sales,
quantity,
discount,
profit,
order_month,
order_year,
order_day,
shipping_days,
profit_margin,
is_loss,
order_month_num
);

SELECT
    order_date,
    ship_date
FROM retail_sales
LIMIT 10;

ALTER TABLE retail_sales
ADD COLUMN order_date_new DATE,
ADD COLUMN ship_date_new DATE;

SET SQL_SAFE_UPDATES = 0;

UPDATE retail_sales
SET
    order_date_new = STR_TO_DATE(order_date, '%m/%d/%Y'),
    ship_date_new = STR_TO_DATE(ship_date, '%m/%d/%Y');
    
SET SQL_SAFE_UPDATES = 1;

SELECT
    order_date,
    order_date_new,
    ship_date,
    ship_date_new
FROM retail_sales
LIMIT 10;
    
ALTER TABLE retail_sales
DROP COLUMN order_date,
DROP COLUMN ship_date;

ALTER TABLE retail_sales
RENAME COLUMN order_date_new TO order_date,
RENAME COLUMN ship_date_new TO ship_date;

DESCRIBE retail_sales;

SELECT
    order_date,
    ship_date
FROM retail_sales
LIMIT 10;