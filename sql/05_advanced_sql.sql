/*
============================================================
FILE: 05_advanced_sql.sql
PROJECT: Retail Sales Analytics
AUTHOR: Manish Kumar Gupta
DESCRIPTION:
Advanced SQL techniques used in production environments and
commonly asked in Data Analyst interviews.
============================================================
*/


/*============================================================
Scenario 1: Identifying the Highest Revenue Customer in Every Region
==============================================================*/

/*
Scenario:
The company is launching a Regional Customer Excellence Program.
Management wants to recognize the highest revenue-generating
customer from each region and assign dedicated account managers
to strengthen these strategic relationships.
*/

/*
Business Question:
Who is the highest revenue-generating customer in each region
based on total sales?
*/

WITH customer_sales AS (

    SELECT
        region,
        customer_name,
        SUM(sales) AS total_sales,

        ROW_NUMBER() OVER (
            PARTITION BY region
            ORDER BY SUM(sales) DESC
        ) AS customer_rank

    FROM retail_sales

    GROUP BY
        region,
        customer_name
)

SELECT
    region,
    customer_name,
    total_sales

FROM customer_sales

WHERE customer_rank = 1

ORDER BY region;


/*
Data Summary:
The query aggregates total sales for every customer within each
region and ranks them in descending order of revenue. It then
returns only the highest revenue-generating customer from each
region, providing management with a concise list of regional
key accounts.
*/

/*============================================================
Scenario 2: Identifying the Top 3 Customers in Every Region
==============================================================*/

/*
Scenario:
The Sales Department is organizing a Regional Customer Appreciation
Program to reward the highest revenue-generating customers. Instead
of selecting only the top customer, management wants to recognize
the top three customers from each region based on their total sales.
*/

/*
Business Question:
Who are the top three revenue-generating customers in each region?
*/

WITH customer_sales AS (

    SELECT
        region,
        customer_name,
        SUM(sales) AS total_sales,

        ROW_NUMBER() OVER (
            PARTITION BY region
            ORDER BY SUM(sales) DESC
        ) AS customer_rank

    FROM retail_sales

    GROUP BY
        region,
        customer_name
)

SELECT
    region,
    customer_name,
    total_sales,
    customer_rank

FROM customer_sales

WHERE customer_rank <= 3

ORDER BY
    region,
    customer_rank;


/*
Data Summary:
The query calculates total sales for every customer within each
region and assigns a unique ranking based on descending sales.
It then returns the top three customers from every region,
providing a shortlist of high-value customers for regional
recognition initiatives.
*/

/*============================================================
Scenario 3: Fairly Ranking Customers with Equal Sales
==============================================================*/

/*
Scenario:
After reviewing the customer leaderboard, the Sales Director
noticed that customers with identical sales figures were assigned
different rankings. To ensure fairness in the Regional Customer
Appreciation Program, management decided that customers with the
same revenue should receive the same rank.
*/

/*
Business Question:
How can customers be ranked within each region so that customers
with identical total sales receive the same rank?
*/

WITH customer_sales AS (

    SELECT
        region,
        customer_name,
        SUM(sales) AS total_sales,

        RANK() OVER (
            PARTITION BY region
            ORDER BY SUM(sales) DESC
        ) AS customer_rank

    FROM retail_sales

    GROUP BY
        region,
        customer_name
)

SELECT
    region,
    customer_name,
    total_sales,
    customer_rank

FROM customer_sales

ORDER BY
    region,
    customer_rank,
    total_sales DESC;


/*
Data Summary:
The query calculates total sales for every customer within each
region and assigns rankings using the RANK() window function.
Customers with identical sales receive the same rank, while the
next rank reflects the number of preceding positions, resulting
in gaps whenever ties occur.
*/

/*============================================================
Scenario 4: Creating Consecutive Customer Rankings
==============================================================*/

/*
Scenario:
The CRM team uses customer rankings to segment clients into
priority service tiers. While reviewing the leaderboard, they
found that gaps in the rankings caused confusion during customer
classification. They requested a ranking system where customers
with identical sales share the same rank, but the subsequent
rank should remain consecutive.
*/

/*
Business Question:
How can customers be ranked within each region so that customers
with identical sales receive the same rank without creating gaps
in the ranking sequence?
*/

WITH customer_sales AS (

    SELECT
        region,
        customer_name,
        SUM(sales) AS total_sales,

        DENSE_RANK() OVER (
            PARTITION BY region
            ORDER BY SUM(sales) DESC
        ) AS customer_rank

    FROM retail_sales

    GROUP BY
        region,
        customer_name
)

SELECT
    region,
    customer_name,
    total_sales,
    customer_rank

FROM customer_sales

ORDER BY
    region,
    customer_rank,
    total_sales DESC;


/*
Data Summary:
The query calculates total sales for every customer within each
region and assigns rankings using the DENSE_RANK() window
function. Customers with identical sales receive the same rank,
while the next rank continues sequentially without skipping any
numbers, making the output suitable for customer segmentation
and reporting.
*/

/*============================================================
Scenario 5: Detecting Declining Customer Purchases
==============================================================*/

/*
Scenario:
The Customer Success team wants to identify customers whose latest
purchase was lower than their previous purchase. A decline in
order value may indicate reduced customer engagement, allowing
the business to proactively launch retention campaigns.
*/

/*
Business Question:
Which customer orders generated lower sales than the customer's
previous order?
*/

WITH customer_orders AS (

    SELECT
        customer_name,
        order_id,
        order_date,
        sales,

        LAG(sales) OVER(
            PARTITION BY customer_name
            ORDER BY order_date
        ) AS previous_order_sales

    FROM retail_sales
)

SELECT
    customer_name,
    order_id,
    order_date,
    previous_order_sales,
    sales AS current_order_sales,
    ROUND(previous_order_sales - sales,2) AS decline_amount

FROM customer_orders

WHERE previous_order_sales IS NOT NULL
AND sales < previous_order_sales

ORDER BY
    decline_amount DESC;


/*
Data Summary:
The query compares every customer's order with their immediately
preceding purchase. Only orders where the current purchase value
is lower than the previous purchase are returned, along with the
amount of decline.
*/

/*============================================================
Scenario 6: Monitoring Month-over-Month Sales Growth
==============================================================*/

/*
Scenario:
The Finance department prepares monthly performance reports for
executive review. Instead of reviewing monthly sales in isolation,
management wants to compare each month's performance with the
previous month to monitor business growth.
*/

/*
Business Question:
How did total monthly sales change compared to the previous month?
*/

WITH monthly_sales AS (

    SELECT

        DATE_FORMAT(order_date,'%Y-%m') AS sales_month,

        SUM(sales) AS total_sales

    FROM retail_sales

    GROUP BY
        DATE_FORMAT(order_date,'%Y-%m')

)

SELECT

    sales_month,

    total_sales,

    LAG(total_sales) OVER(
        ORDER BY sales_month
    ) AS previous_month_sales,

    ROUND(
        total_sales -
        LAG(total_sales) OVER(
            ORDER BY sales_month
        ),
        2
    ) AS sales_change,

    ROUND(

        (
            (total_sales -
            LAG(total_sales) OVER(
                ORDER BY sales_month
            ))

            /

            LAG(total_sales) OVER(
                ORDER BY sales_month
            )

        )*100,
        2

    ) AS growth_percentage

FROM monthly_sales;


/*
Data Summary:
The query summarizes monthly sales and compares each month's
performance against the previous month. It reports both the
absolute sales difference and the percentage growth, enabling
trend monitoring over time.
*/

/*============================================================
Scenario 7: Building a Running Sales Dashboard
==============================================================*/

/*
Scenario:
The executive leadership team wants a dashboard that displays
the cumulative revenue generated throughout the business period.
Rather than viewing monthly sales independently, they want to
track how total revenue accumulates over time.
*/

/*
Business Question:
What is the cumulative sales value after each month?
*/

WITH monthly_sales AS (

    SELECT

        DATE_FORMAT(order_date,'%Y-%m') AS sales_month,

        SUM(sales) AS total_sales

    FROM retail_sales

    GROUP BY
        DATE_FORMAT(order_date,'%Y-%m')

)

SELECT

    sales_month,

    total_sales,

    SUM(total_sales) OVER(

        ORDER BY sales_month

    ) AS cumulative_sales

FROM monthly_sales;


/*
Data Summary:
The query aggregates monthly sales and calculates a running
cumulative total in chronological order. The output shows how
overall business revenue grows over time and forms the basis for
executive revenue dashboards.
*/

/*============================================================
Scenario 8: Identifying Premium Customers
==============================================================*/

/*
Scenario:
The Marketing team plans to launch an exclusive loyalty program
for high-value customers. Instead of selecting customers manually,
they want to segment customers into four spending tiers and invite
only the highest spending group.
*/

/*
Business Question:
Which customers belong to the top 25% based on their total sales?
*/

WITH customer_sales AS (

    SELECT
        customer_name,
        SUM(sales) AS total_sales

    FROM retail_sales

    GROUP BY
        customer_name
),

customer_segments AS (

    SELECT
        customer_name,
        total_sales,

        NTILE(4) OVER(
            ORDER BY total_sales DESC
        ) AS customer_tier

    FROM customer_sales
)

SELECT
    customer_name,
    total_sales,
    customer_tier

FROM customer_segments

WHERE customer_tier = 1

ORDER BY
    total_sales DESC;


/*
Data Summary:
The query calculates total sales for every customer and divides
them into four equally sized spending groups. Customers assigned
to Tier 1 represent the highest spending 25% of the customer
base and are suitable candidates for premium loyalty programs.
*/

/*============================================================
Scenario 9: Forecasting Product Performance
==============================================================*/

/*
Scenario:
The Inventory Planning team wants to monitor monthly sales trends
for every product category. To anticipate future inventory
requirements, they need to compare each month's sales with the
following month's sales.
*/

/*
Business Question:
How does each month's category sales compare with the following
month?
*/

WITH monthly_category_sales AS (

    SELECT

        category,

        DATE_FORMAT(order_date,'%Y-%m') AS sales_month,

        SUM(sales) AS total_sales

    FROM retail_sales

    GROUP BY
        category,
        DATE_FORMAT(order_date,'%Y-%m')

)

SELECT

    category,

    sales_month,

    total_sales,

    LEAD(total_sales) OVER(

        PARTITION BY category
        ORDER BY sales_month

    ) AS next_month_sales

FROM monthly_category_sales

ORDER BY
    category,
    sales_month;


/*
Data Summary:
The query summarizes monthly sales for every product category
and retrieves the following month's sales using LEAD(). This
allows analysts to compare current performance with upcoming
periods without using self joins.
*/

/*============================================================
Scenario 10: Measuring Product Contribution to Category Revenue
==============================================================*/

/*
Scenario:
The Product Management team wants to understand how much each
product contributes to its category's revenue. Rather than
viewing sales alone, they require each product's percentage
contribution within its category.
*/

/*
Business Question:
What percentage of total category sales is contributed by each
product?
*/

WITH product_sales AS (

    SELECT

        category,

        product_name,

        SUM(sales) AS total_sales

    FROM retail_sales

    GROUP BY
        category,
        product_name

)

SELECT

    category,

    product_name,

    total_sales,

    ROUND(

        (
            total_sales /

            SUM(total_sales) OVER(
                PARTITION BY category
            )

        ) * 100,

        2

    ) AS contribution_percentage

FROM product_sales

ORDER BY
    category,
    contribution_percentage DESC;


/*
Data Summary:
The query calculates total sales for every product and expresses
each product's sales as a percentage of its category's total
revenue. The output highlights the products that contribute the
largest share of revenue within each category.
*/

/*============================================================
Scenario 11: Identifying Consistently Growing Regions
==============================================================*/

/*
Scenario:
The Regional Sales Directors want to identify regions that have
demonstrated consistent month-over-month sales growth. Rather
than focusing on isolated high-performing months, management is
interested in regions that maintain a positive growth trend over
time.
*/

/*
Business Question:
Which regions recorded positive sales growth compared to their
previous month?
*/

WITH regional_monthly_sales AS (

    SELECT

        region,

        DATE_FORMAT(order_date,'%Y-%m') AS sales_month,

        SUM(sales) AS total_sales

    FROM retail_sales

    GROUP BY

        region,

        DATE_FORMAT(order_date,'%Y-%m')

),

sales_growth AS (

    SELECT

        region,

        sales_month,

        total_sales,

        LAG(total_sales) OVER(

            PARTITION BY region
            ORDER BY sales_month

        ) AS previous_month_sales

    FROM regional_monthly_sales

)

SELECT

    region,

    sales_month,

    previous_month_sales,

    total_sales,

    ROUND(

        total_sales - previous_month_sales,

        2

    ) AS growth_amount,

    CASE

        WHEN total_sales > previous_month_sales
        THEN 'Growth'

        WHEN total_sales < previous_month_sales
        THEN 'Decline'

        ELSE 'No Change'

    END AS growth_status

FROM sales_growth

WHERE previous_month_sales IS NOT NULL

ORDER BY

    region,

    sales_month;


/*
Data Summary:
The query compares monthly regional sales with the previous
month's performance and classifies each month as Growth,
Decline or No Change. This enables management to monitor
regional sales momentum over time.
*/

/*============================================================
Scenario 12: Executive Sales Performance Dashboard
==============================================================*/

/*
Scenario:
The executive leadership team requires a consolidated report
highlighting customer performance across all regions. The report
should display each customer's total sales, regional ranking,
and contribution towards regional revenue, enabling leadership
to quickly identify key revenue-generating customers.
*/

/*
Business Question:
How can customer sales, rankings and revenue contribution be
combined into a single executive-ready report?
*/

WITH customer_sales AS (

    SELECT

        region,

        customer_name,

        SUM(sales) AS total_sales

    FROM retail_sales

    GROUP BY

        region,

        customer_name

)

SELECT

    region,

    customer_name,

    total_sales,

    DENSE_RANK() OVER(

        PARTITION BY region
        ORDER BY total_sales DESC

    ) AS regional_rank,

    ROUND(

        (

            total_sales /

            SUM(total_sales) OVER(

                PARTITION BY region

            )

        ) * 100,

        2

    ) AS regional_sales_percentage,

    SUM(total_sales) OVER(

        PARTITION BY region
        ORDER BY total_sales DESC

    ) AS cumulative_regional_sales

FROM customer_sales

ORDER BY

    region,

    regional_rank;


/*
Data Summary:
The query combines customer revenue, regional rankings,
percentage contribution and cumulative regional sales into a
single report. The output provides executives with a concise
overview of customer performance and revenue distribution across
each region.
*/

