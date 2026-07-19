
-- ==========================================================
-- Celebal Summer Internship 2026
-- Week 2 Task: E-Commerce Sales Database
-- File: queries.sql
-- Description:
-- Contains SQL queries to retrieve and manipulate data from the ShopEase database.
-- Author: Abhishek Raj
-- ==========================================================

USE superstore;

-- ==========================================================
-- Section A
-- ==========================================================

-- Q1
-- Display all columns and rows from the customers table.

SELECT *
FROM customers;

-- Q2
-- Retrieve only the first_name, last_name, and city of all customers.

SELECT first_name,
       last_name,
       city
FROM customers;

-- Q3
-- List all unique categories available in the products table.


SELECT DISTINCT category
FROM products;

-- Q4
-- Identify the Primary Key of each table. 
--(Theoretical Question - No SQL Query Required)

/*
Primary Keys:

customers    -> customer_id
products     -> product_id
orders       -> order_id
order_items  -> item_id
*/

-- Q5. UNIQUE constraint on the email column. 
-- (expected to fail because the email already exists.)

INSERT INTO customers
VALUES
(
    109,
    'Rahul',
    'Verma',
    'aarav.s@email.com',
    'Lucknow',
    'Uttar Pradesh',
    '2024-09-01',
    FALSE
);

-- Q6. CHECK constraint on unit_price. 
--(expected to fail because unit_price is negative.)

INSERT INTO products
VALUES
(
    209,
    'Test Product',
    'Electronics',
    'TestBrand',
    -50,
    100
);

-- ==========================================
-- SECTION B
-- ==========================================

-- Q7
-- Retrieve all delivered orders

SELECT *
FROM orders
WHERE status = 'Delivered';

-- Q8
-- Find Electronics products priced above ₹2000

SELECT *
FROM products
WHERE category = 'Electronics'
AND unit_price > 2000;

-- Q9
-- Customers from Maharashtra who joined in 2024

SELECT *
FROM customers
WHERE join_date BETWEEN '2024-01-01' AND '2024-12-31'
AND state = 'Maharashtra';

-- Q10
-- Orders between Aug 10 and Aug 25 excluding cancelled orders

SELECT *
FROM orders
WHERE order_date BETWEEN '2024-08-10' AND '2024-08-25'
AND status != 'Cancelled';

-- Q11
-- Query benefiting from idx_orders_date

SELECT *
FROM orders
WHERE order_date BETWEEN '2024-08-10' AND '2024-08-25';

-- Q12
-- SARGable Query
-- Non-SARGable Query
SELECT *
FROM customers
WHERE YEAR(join_date) = 2024;

-- Optimized SARGable Query
SELECT *
FROM customers
WHERE join_date BETWEEN '2024-01-01'
AND '2024-12-31';

-- ==========================================================
-- SECTION C – AGGREGATION
-- ==========================================================

-- Q13. Count the total number of orders in the orders table.

SELECT COUNT(*) AS total_orders
FROM orders;

-- Q14. Find the total revenue (SUM of total_amount)
-- from all Delivered orders.

SELECT SUM(total_amount) AS total_revenue
FROM orders
WHERE status = 'Delivered';

-- Q15. Calculate the average unit_price of products
-- in each category.

SELECT category,
       AVG(unit_price) AS average_price
FROM products
GROUP BY category;

-- Q16. Display the number of orders and total revenue
-- for each order status. Sort by revenue in descending order.

SELECT status,
       COUNT(*) AS total_orders,
       SUM(total_amount) AS total_revenue
FROM orders
GROUP BY status
ORDER BY total_revenue DESC;

-- Q17. Find the most expensive (MAX) and cheapest (MIN)
-- product in each category.

SELECT category,
       MAX(unit_price) AS most_expensive,
       MIN(unit_price) AS cheapest
FROM products
GROUP BY category;

-- Q18. Display categories where the average product price
-- is greater than ₹2000 using the HAVING clause.

SELECT category,
       AVG(unit_price) AS average_price
FROM products
GROUP BY category
HAVING AVG(unit_price) > 2000;

-- ==========================================================
-- SECTION D – JOINS & RELATIONSHIPS
-- ==========================================================

-- Q19
-- Display each order along with the customer's first name and last name.

SELECT
    o.order_id,
    o.order_date,
    c.first_name,
    c.last_name,
    o.total_amount
FROM orders o
INNER JOIN customers c
ON o.customer_id = c.customer_id;

-- Q20
-- List all customers and their orders (if any).

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    o.order_id,
    o.order_date,
    o.total_amount
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id;

-- Q21
-- Display order details by joining orders, order_items and products.

SELECT
    o.order_id,
    p.product_name,
    oi.quantity,
    oi.unit_price,
    oi.discount_pct
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN products p
ON oi.product_id = p.product_id;

-- Q22
-- Difference between LEFT JOIN and RIGHT JOIN.
-- (Theoretical Question - No SQL Query Required)

/*
LEFT JOIN:
Returns all rows from the left table and matching rows from the right table.
If there is no match, NULL values are returned.

RIGHT JOIN:
Returns all rows from the right table and matching rows from the left table.
If there is no match, NULL values are returned.

FULL OUTER JOIN:
Returns all matching and non-matching rows from both tables.
(MySQL does not support FULL OUTER JOIN directly.)
*/

-- Q23
-- Foreign Key Relationships.
-- (Theoretical Question - No SQL Query Required)

/*
Foreign Keys:

orders.customer_id      -> customers.customer_id
order_items.order_id    -> orders.order_id
order_items.product_id  -> products.product_id

If customer_id = 999 does not exist in customers,
the INSERT into orders will fail with a
Foreign Key Constraint Error.
*/

-- ==========================================================
-- SECTION E – ADVANCED CONCEPTS
-- ==========================================================

-- Q24
-- Classify products into price tiers using CASE.

SELECT
    product_name,
    unit_price,
    CASE
        WHEN unit_price < 1000 THEN 'Budget'
        WHEN unit_price BETWEEN 1000 AND 3000 THEN 'Mid-Range'
        ELSE 'Premium'
    END AS price_tier
FROM products;

-- Q25
-- Count Delivered and Not Delivered orders.

SELECT
    COUNT(CASE WHEN status = 'Delivered' THEN 1 END) AS delivered_orders,
    COUNT(CASE WHEN status <> 'Delivered' THEN 1 END) AS not_delivered_orders
FROM orders;

-- Q26
-- ACID Properties.
-- (Theoretical Question - No SQL Query Required)

/*
A - Atomicity:
Either all operations are completed or none are.

C - Consistency:
The database remains valid before and after a transaction.

I - Isolation:
Transactions execute independently without interfering.

D - Durability:
Committed changes are permanently saved.

Example:
In a bank transfer, money is deducted from one account
and added to another. If any step fails, the transaction
is rolled back to keep the data consistent.
*/

-- Q27
-- SQL Transaction

START TRANSACTION;

INSERT INTO orders (
    order_id,
    customer_id,
    order_date,
    status,
    total_amount
)
VALUES (
    1011,
    102,
    CURDATE(),
    'Pending',
    1598.00
);

INSERT INTO order_items (
    item_id,
    order_id,
    product_id,
    quantity,
    unit_price,
    discount_pct
)
VALUES
(5016, 1011, 201, 1, 999.00, 0),
(5017, 1011, 202, 1, 599.00, 0);

UPDATE products
SET stock_qty = stock_qty - 1
WHERE product_id = 201;

UPDATE products
SET stock_qty = stock_qty - 1
WHERE product_id = 202;

COMMIT;

-- If any step fails
ROLLBACK;