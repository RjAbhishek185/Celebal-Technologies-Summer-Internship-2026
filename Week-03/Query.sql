USE superstore_db;
SELECT COUNT(*) FROM superstore_raw;
DESCRIBE superstore_raw;

-- CREATE CUSTOMERS TABLE

CREATE TABLE customers (
    customer_id VARCHAR(30),
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    country VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code INT,
    region VARCHAR(50)
);

-- INSERT INTO CUSTOMERS

INSERT INTO customers
SELECT DISTINCT
    `Customer ID`,
    `Customer Name`,
    Segment,
    Country,
    City,
    State,
    `Postal Code`,
    Region
FROM superstore_raw;

-- CREATE PRODUCTS TABLE

CREATE TABLE products (
    product_id VARCHAR(30),
    product_name VARCHAR(255),
    category VARCHAR(50),
    sub_category VARCHAR(50)
);

-- INSERT INTO PRODUCTS

INSERT INTO products
SELECT DISTINCT
    `Product ID`,
    `Product Name`,
    Category,
    `Sub-Category`
FROM superstore_raw;

-- CREATE ORDERS TABLE

CREATE TABLE orders (
    row_id INT,
    order_id VARCHAR(30),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(50),
    customer_id VARCHAR(30),
    product_id VARCHAR(30),
    sales DECIMAL(10,2),
    quantity INT,
    discount DECIMAL(5,2),
    profit DECIMAL(10,2)
);

-- INSERT INTO ORDERS

INSERT INTO orders
SELECT DISTINCT
    `Row ID`,
    `Order ID`,
    STR_TO_DATE(`Order Date`, '%m/%d/%Y'),
    STR_TO_DATE(`Ship Date`, '%m/%d/%Y'),
    `Ship Mode`,
    `Customer ID`,
    `Product ID`,
    CAST(Sales AS DECIMAL(10,2)),
    CAST(Quantity AS UNSIGNED),
    CAST(Discount AS DECIMAL(5,2)),
    CAST(Profit AS DECIMAL(10,2))
FROM superstore_raw;

-- QUERY 1

SELECT *
FROM orders
WHERE sales >
(
    SELECT AVG(sales)
    FROM orders
);

-- QUERY 2

SELECT o.*
FROM orders o
JOIN (
    SELECT customer_id, MAX(sales) AS max_sales
    FROM orders
    GROUP BY customer_id
) t
ON o.customer_id = t.customer_id
AND o.sales = t.max_sales;

-- QUERY 3

WITH customer_sales AS
(
    SELECT
        customer_id,
        SUM(sales) AS total_sales
    FROM orders
    GROUP BY customer_id
)

SELECT *
FROM customer_sales
ORDER BY total_sales DESC;

-- QUERY 4

WITH customer_sales AS
(
    SELECT
        customer_id,
        SUM(sales) AS total_sales
    FROM orders
    GROUP BY customer_id
)

SELECT *
FROM customer_sales
WHERE total_sales >
(
    SELECT AVG(total_sales)
    FROM customer_sales
);

-- QUERY 5
WITH customer_sales AS
(
    SELECT
        customer_id,
        SUM(sales) AS total_sales
    FROM orders
    GROUP BY customer_id
)

SELECT
    customer_id,
    total_sales,
    RANK() OVER (ORDER BY total_sales DESC) AS sales_rank
FROM customer_sales;

-- QUERY 6

SELECT
    customer_id,
    order_id,
    sales,
    ROW_NUMBER() OVER
    (
        PARTITION BY customer_id
        ORDER BY sales DESC
    ) AS row_num
FROM orders;

-- QUERY 7

WITH customer_sales AS
(
    SELECT
        customer_id,
        SUM(sales) AS total_sales
    FROM orders
    GROUP BY customer_id
)

SELECT *
FROM
(
    SELECT
        customer_id,
        total_sales,
        RANK() OVER (ORDER BY total_sales DESC) AS sales_rank
    FROM customer_sales
) ranked
WHERE sales_rank <= 3;

-- FINAL COMBINED QUERY

WITH customer_sales AS
(
    SELECT
        customer_id,
        SUM(sales) AS total_sales
    FROM orders
    GROUP BY customer_id
)

SELECT
    c.customer_name,
    cs.total_sales,
    RANK() OVER (ORDER BY cs.total_sales DESC) AS sales_rank
FROM customer_sales cs
JOIN customers c
ON cs.customer_id = c.customer_id
ORDER BY sales_rank;

-- MINI PROJECT QUERY 1

WITH customer_sales AS
(
    SELECT
        customer_id,
        SUM(sales) AS total_sales
    FROM orders
    GROUP BY customer_id
)

SELECT
    c.customer_name,
    cs.total_sales
FROM customer_sales cs
JOIN customers c
ON cs.customer_id = c.customer_id
ORDER BY cs.total_sales DESC
LIMIT 5;

-- MINI PROJECT QUERY 2

WITH customer_sales AS
(
    SELECT
        customer_id,
        SUM(sales) AS total_sales
    FROM orders
    GROUP BY customer_id
)

SELECT
    c.customer_name,
    cs.total_sales
FROM customer_sales cs
JOIN customers c
ON cs.customer_id = c.customer_id
ORDER BY cs.total_sales ASC
LIMIT 5;

-- MINI PROJECT QUERY 3

SELECT
    c.customer_name,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.customer_name
HAVING COUNT(DISTINCT o.order_id) = 1;

-- MINI PROJECT QUERY 4

WITH customer_sales AS
(
    SELECT
        customer_id,
        SUM(sales) AS total_sales
    FROM orders
    GROUP BY customer_id
)

SELECT
    c.customer_name,
    cs.total_sales
FROM customer_sales cs
JOIN customers c
ON cs.customer_id = c.customer_id
WHERE cs.total_sales >
(
    SELECT AVG(total_sales)
    FROM customer_sales
)
ORDER BY cs.total_sales DESC;

-- MINI PROJECT QUERY 5

SELECT
    c.customer_name,
    MAX(o.sales) AS highest_order_value
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY highest_order_value DESC;


/* ============================================================
                    BUSINESS INSIGHTS
============================================================ */

-- The analysis shows that a relatively small number of customers generate a
-- large share of the overall sales. Building long-term relationships with these
-- customers through loyalty programs and personalized services can improve
-- customer retention and business revenue.

-- Customers who have placed only one order may require targeted marketing
-- efforts to encourage repeat purchases. Understanding their buying behavior
-- can help improve customer engagement.

-- Ranking customers by total sales helps the business identify its most
-- valuable customers, making it easier to prioritize customer support,
-- promotional campaigns, and premium offerings.

-- Customers with sales above the average represent high-performing segments
-- that can be targeted with cross-selling and upselling strategies to maximize
-- future revenue.

-- Analyzing the highest order value for each customer provides valuable
-- insights into spending habits and purchasing capacity, supporting better
-- sales and marketing decisions.

-- Overall, the combination of Subqueries, Common Table Expressions (CTEs),
-- and Window Functions demonstrates how SQL can be used to transform raw
-- transactional data into meaningful business insights for decision-making.

/* ====================== END OF ASSIGNMENT ====================== */
