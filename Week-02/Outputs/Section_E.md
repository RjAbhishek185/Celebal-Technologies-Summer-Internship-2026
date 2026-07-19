# Section E – Advanced Concepts (CASE, ACID & Transactions)

---

## Q24. Write a query using CASE to classify products into price tiers.

### Objective

Categorize products into different pricing groups based on their selling price.

### SQL Query

```sql
SELECT product_name,
       unit_price,
       CASE
           WHEN unit_price < 1000 THEN 'Budget'
           WHEN unit_price BETWEEN 1000 AND 3000 THEN 'Mid-Range'
           ELSE 'Premium'
       END AS price_tier
FROM products;
```

### Explanation

* The `CASE` statement checks the value of `unit_price` for every product.
* Products costing less than ₹1000 are labeled **Budget**.
* Products priced between ₹1000 and ₹3000 are classified as **Mid-Range**.
* Any product above ₹3000 is categorized as **Premium**.
* The result is displayed in a new column named `price_tier`.

### Business Insight

Grouping products into price ranges helps businesses organize their catalog, create pricing strategies, and design promotional campaigns for different customer segments.

---

## Q25. Using the `orders` table, display the total number of Delivered and Non-Delivered orders using CASE.

### Objective

Calculate the number of delivered and non-delivered orders within a single query.

### SQL Query

```sql
SELECT
    SUM(
        CASE
            WHEN status = 'Delivered' THEN 1
            ELSE 0
        END
    ) AS delivered_orders,

    SUM(
        CASE
            WHEN status <> 'Delivered' THEN 1
            ELSE 0
        END
    ) AS non_delivered_orders
FROM orders;
```

### Explanation

* `CASE` checks the status of every order.
* If an order is delivered, it contributes **1** to the delivered count.
* All remaining order statuses contribute **1** to the non-delivered count.
* `SUM()` adds these values to produce the final totals.

### Business Insight

This approach generates multiple statistics in a single query, making it efficient for dashboards that monitor delivery performance and pending orders.

---

## Q26. Explain the purpose of `START TRANSACTION`, `COMMIT`, and `ROLLBACK`. Provide a simple example.

### Objective

Understand how transactions keep related database operations accurate and consistent.

### Example SQL

```sql
START TRANSACTION;

UPDATE orders
SET status = 'Delivered'
WHERE order_id = 1007;

UPDATE orders
SET total_amount = 1399.00
WHERE order_id = 1007;

COMMIT;

-- If an error occurs before COMMIT
-- ROLLBACK;
```

### Explanation

* `START TRANSACTION` marks the beginning of a transaction.
* Any changes made after this point remain temporary until confirmed.
* `COMMIT` permanently saves all successful changes to the database.
* `ROLLBACK` cancels all uncommitted changes if an error occurs.

### Business Insight

Transactions are essential whenever multiple operations depend on one another. They help avoid incomplete updates and ensure the database remains accurate.

---

## Q27. Explain the four ACID properties of database transactions. Give a practical example related to an e-commerce order.

### Objective

Learn the core principles that make database transactions reliable and secure.

### Explanation

The ACID properties are:

* **Atomicity:** Every transaction is treated as a single operation. If one step fails, the entire transaction is cancelled.
* **Consistency:** The database always remains in a valid state before and after a transaction.
* **Isolation:** Simultaneous transactions do not interfere with each other.
* **Durability:** Once a transaction is committed, the changes remain permanently stored even if the system unexpectedly shuts down.

### Practical Example

Suppose a customer places an online order. The system needs to:

1. Create a new order.
2. Reduce the product stock.
3. Process the payment.

If the payment fails, the order should not be created and the stock should not decrease. The transaction is rolled back so that all data remains accurate. If every step completes successfully, the transaction is committed and the changes become permanent.

### Business Insight

The ACID properties help maintain trustworthy business data by preventing incomplete transactions, protecting data integrity, and ensuring smooth operation of systems such as e-commerce websites, banking applications, and inventory management platforms.
