# Section D – JOIN Operations

---

## Q19. Display each order along with the customer's full name and city.

### Objective

Retrieve order details along with the corresponding customer's full name and city by joining the `orders` and `customers` tables.

### Original SQL Query

```sql
SELECT o.order_id,
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       c.city,
       o.order_date,
       o.status,
       o.total_amount
FROM orders o
INNER JOIN customers c
ON o.customer_id = c.customer_id;
```

### Explanation

- `FROM orders o` selects the `orders` table and assigns it the alias `o`.
- `INNER JOIN customers c` joins the `customers` table using the alias `c`.
- `ON o.customer_id = c.customer_id` matches each order with its corresponding customer.
- `CONCAT(c.first_name, ' ', c.last_name)` combines the customer's first and last names into a single column.
- The query returns order details together with customer information in a single result set.

### Business Insight

Joining customer and order data provides a complete view of purchasing activity, enabling businesses to analyze customer behavior, generate regional sales reports, and support personalized marketing initiatives.

## Q20. Using a LEFT JOIN, list ALL customers and their orders (if any). Customers with no orders should still appear with NULL values for order columns.

### Objective

Display all customers along with their order details, ensuring that customers without any orders are also included in the result.

### Original SQL Query

```sql
SELECT c.customer_id,
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       o.order_id,
       o.order_date,
       o.status,
       o.total_amount
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id;
```

### Explanation

- `FROM customers c` selects the `customers` table as the left table.
- `LEFT JOIN orders o` joins matching orders while ensuring all customers are included.
- `ON c.customer_id = o.customer_id` matches customers with their corresponding orders.
- `CONCAT(c.first_name, ' ', c.last_name)` combines the customer's first and last names into a single column.
- If a customer has no matching order, the order-related columns display `NULL`.

### Business Insight

A LEFT JOIN enables businesses to analyze all customers, including those who have not yet placed any orders. This is valuable for customer retention analysis, identifying inactive customers, and planning targeted marketing campaigns.

## Q21. Write a query using JOINs across three tables (`orders` → `order_items` → `products`) to show: `order_id`, `product_name`, `quantity`, `unit_price`, and `discount_pct` for each order item.

### Objective

Retrieve detailed information for every purchased product by joining the `orders`, `order_items`, and `products` tables.

### Original SQL Query

```sql
SELECT o.order_id,
       p.product_name,
       oi.quantity,
       oi.unit_price,
       oi.discount_pct
FROM orders o
INNER JOIN order_items oi
ON o.order_id = oi.order_id
INNER JOIN products p
ON oi.product_id = p.product_id;
```

### Explanation

- `FROM orders o` starts with the `orders` table.
- `INNER JOIN order_items oi` connects each order with its purchased items.
- `ON o.order_id = oi.order_id` matches orders to their corresponding order items.
- `INNER JOIN products p` joins product information.
- `ON oi.product_id = p.product_id` matches each order item to its product.
- The query returns detailed information for every purchased product.

### Business Insight

Combining order, order item, and product information enables detailed sales analysis at the product level. Businesses can identify popular products, monitor discounts, analyze purchasing patterns, and make informed inventory and pricing decisions.

## Q22. Explain the difference between LEFT JOIN and RIGHT JOIN with an example from this schema. When would you use a FULL OUTER JOIN?

### Objective

Understand the differences between LEFT JOIN, RIGHT JOIN, and FULL OUTER JOIN.

### Example SQL Queries

```sql
-- LEFT JOIN
SELECT c.customer_id,
       c.first_name,
       o.order_id
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id;

-- RIGHT JOIN
SELECT c.customer_id,
       c.first_name,
       o.order_id
FROM customers c
RIGHT JOIN orders o
ON c.customer_id = o.customer_id;
```

### Explanation

- **LEFT JOIN** returns all rows from the left table and matching rows from the right table.
- **RIGHT JOIN** returns all rows from the right table and matching rows from the left table.
- **FULL OUTER JOIN** returns all rows from both tables, matching them where possible and filling unmatched columns with `NULL`. MySQL does not support `FULL OUTER JOIN` directly.

### Business Insight

Different JOIN types help businesses analyze complete datasets, identify missing relationships, and detect customers or records that do not have corresponding matches.

## Q23. Identify all Foreign Key relationships in the schema. Explain what would happen if you tried to insert an order with `customer_id = 999` (which doesn't exist in `customers`).

### Objective

Understand how Foreign Keys maintain referential integrity between related tables.

### Example SQL Query

```sql
INSERT INTO orders
VALUES
(
1011,
999,
'2024-09-01',
'Pending',
1598.00
);
```

### Explanation

The schema contains the following Foreign Key relationships:

- `orders.customer_id` → `customers.customer_id`
- `order_items.order_id` → `orders.order_id`
- `order_items.product_id` → `products.product_id`

The above `INSERT` statement fails because `customer_id = 999` does not exist in the `customers` table. MySQL rejects the insertion with a Foreign Key constraint error, ensuring referential integrity.

### Business Insight

Foreign Keys prevent invalid references between tables, ensuring that every order belongs to a valid customer and every order item belongs to a valid order and product. This maintains accurate and reliable business data.

---