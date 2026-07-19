# Section B — Filtering & Optimization (WHERE, Indexes)
---

## Q7. Retrieve all orders with status = 'Delivered'

### Objective
Retrieve all successfully delivered orders to analyze completed sales.

### SQL Query

SELECT *
FROM orders
WHERE status = 'Delivered';

### Explanation

- SELECT * retrieves all columns.
- FROM orders specifies the source table.
- WHERE status = 'Delivered' filters only completed orders.

### Business Insight

Delivered orders represent completed transactions and can be used for revenue analysis, customer purchase history, and sales reporting.

## Q8. Find all products in the Electronics category with a unit_price greater than ₹2000.

### Objective

Retrieve premium electronic products for pricing and inventory analysis.

### SQL Query

SELECT *
FROM products
WHERE category = 'Electronics'
AND unit_price > 2000;

### Explanation

- SELECT * retrieves all product details.
- WHERE filters the rows.
- category = 'Electronics' restricts results to electronic products.
- AND ensures both conditions are satisfied.
- unit_price > 2000 filters premium-priced items.

### Business Insight

This query highlights higher-priced electronics that can be targeted for premium marketing campaigns and revenue-focused analysis.

## Q9. List all customers who joined in the year 2024 and belong to the state 'Maharashtra'.

### Objective

Retrieve customers from Maharashtra who joined during 2024.

### SQL Query

SELECT *
FROM customers
WHERE join_date BETWEEN '2024-01-01' AND '2024-12-31'
AND state = 'Maharashtra';

### Explanation

- SELECT * retrieves all customer details.
- WHERE applies filtering conditions.
- BETWEEN filters customers who joined during 2024.
- AND ensures only customers from Maharashtra are returned.

### Business Insight

This query helps identify recently acquired customers from a specific region, enabling targeted marketing and regional customer analysis.

## Q10. Find all orders placed between '2024-08-10' and '2024-08-25' (inclusive) that are NOT cancelled.

### Objective

Retrieve orders placed during a specified time period while excluding cancelled orders.

### SQL Query

SELECT *
FROM orders
WHERE order_date BETWEEN '2024-08-10' AND '2024-08-25'
AND status != 'Cancelled';

### Explanation

- SELECT * retrieves all order details.
- WHERE filters the records.
- BETWEEN limits the results to the specified date range.
- status != 'Cancelled' excludes cancelled orders.

### Business Insight

Filtering out cancelled orders allows analysts to focus on active and completed transactions, leading to more accurate operational and sales reporting.

## Q11. Explain what the index `idx_orders_date` does. How would it improve the performance of a query that filters orders by `order_date`? Write a sample query that would benefit from this index.

### Objective

Understand the purpose of the `idx_orders_date` index and how it improves query performance when filtering records based on the `order_date` column.

### Sample SQL Query

```sql
SELECT *
FROM orders
WHERE order_date BETWEEN '2024-08-10' AND '2024-08-25';
```

### Explanation

* The `idx_orders_date` index is created on the `order_date` column of the `orders` table.
* An index acts like the index of a book, allowing MySQL to locate matching records quickly instead of scanning every row in the table.
* When a query filters records using the `order_date` column, MySQL can use this index to retrieve only the relevant rows, significantly improving query performance.
* This optimization becomes especially beneficial when the database contains a large number of records.

### Business Insight

Date-based filtering is one of the most common operations in e-commerce analytics, such as generating daily, weekly, or monthly sales reports. Indexing the `order_date` column improves query execution time, enabling faster report generation and better application performance as the database grows.

## Q12. If you run `SELECT * FROM customers WHERE YEAR(join_date) = 2024;` would the index on `join_date` be used? Explain why or why not, and rewrite the query to be index-friendly (SARGable).

### Objective

Understand why applying functions to indexed columns can reduce query performance and learn how to write index-friendly (SARGable) queries.

### Original SQL Query

```sql
SELECT *
FROM customers
WHERE YEAR(join_date) = 2024;
```

### Optimized SQL Query

```sql
SELECT *
FROM customers
WHERE join_date BETWEEN '2024-01-01'
AND '2024-12-31';
```

### Explanation

- The original query applies the `YEAR()` function to the `join_date` column.
- Since the indexed column is wrapped inside a function, MySQL generally cannot use the index efficiently.
- The optimized query compares the indexed column directly, allowing MySQL to use the index for faster data retrieval.
- Such queries are known as **SARGable (Search ARGument Able)** because they enable efficient index usage.

### Business Insight

Writing SARGable queries improves database performance without changing the query results. As customer records increase, efficient filtering ensures faster reports, dashboards, and application responsiveness.

---