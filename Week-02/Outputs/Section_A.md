# Section A – SQL Basics (SELECT, Constraints, Primary Keys)

---

## Q1. Display all columns and rows from the customers table.

### Objective

View the complete information stored in the `customers` table, including every row and every column.

### SQL Query

```sql
SELECT *
FROM customers;
```

### Explanation

* `SELECT *` fetches all available columns from the table.
* `FROM customers` tells MySQL which table to retrieve the data from.
* Because there is no `WHERE` clause, every customer record is displayed.

### Business Insight

This query is useful for getting an overall view of the customer database before performing any filtering or detailed analysis.

---

## Q2. Retrieve only the first_name, last_name, and city of all customers.

### Objective

Display only the customer's name and city instead of retrieving all available information.

### SQL Query

```sql
SELECT first_name,
       last_name,
       city
FROM customers;
```

### Explanation

* The `SELECT` statement lists only the required columns.
* Returning fewer columns makes the output simpler and reduces unnecessary data retrieval.
* The data is fetched from the `customers` table.

### Business Insight

Choosing only relevant fields improves report readability and can enhance query performance when working with large datasets.

---

## Q3. List all unique categories available in the products table.

### Objective

Find every distinct product category available in the inventory.

### SQL Query

```sql
SELECT DISTINCT category
FROM products;
```

### Explanation

* `DISTINCT` removes duplicate category values.
* Each category appears only once in the result.
* The information is obtained from the `products` table.

### Business Insight

A list of unique categories helps businesses understand their product range and supports category-based reporting.

---

## Q4. Identify the Primary Key of each table. Explain why a Primary Key must be UNIQUE and NOT NULL.

### Objective

Recognize the unique identifier used in each table and understand its role in maintaining database integrity.

### Primary Keys

| Table       | Primary Key |
| ----------- | ----------- |
| customers   | customer_id |
| products    | product_id  |
| orders      | order_id    |
| order_items | item_id     |

### Explanation

Every Primary Key must satisfy two conditions:

* **UNIQUE:** No two records can share the same key value.
* **NOT NULL:** Every record must contain a valid identifier.

These properties allow every row to be uniquely identified and support relationships between tables using Foreign Keys.

### Business Insight

Primary Keys ensure reliable record identification and prevent duplicate entries, making the database more accurate and consistent.

---

## Q5. What constraints are applied to the email column in the customers table? What would happen if you tried to insert a duplicate email?

### Objective

Understand how constraints on the email field help maintain data quality.

### SQL Query

```sql
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
```

### Explanation

The `email` column is protected by the following constraints:

* **UNIQUE** – prevents duplicate email addresses.
* **NOT NULL** – requires every customer to have an email.

Since the email already exists, MySQL rejects the insert operation and returns a duplicate entry error.

### Business Insight

Using a unique email address for every customer helps avoid duplicate accounts and ensures accurate customer communication.

---

## Q6. Try inserting a product with unit_price = -50. What happens and which constraint prevents it?

### Objective

Observe how database constraints stop invalid values from being stored.

### SQL Query

```sql
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
```

### Explanation

The insert operation fails because the table includes the following validation rule:

```sql
CHECK (unit_price > 0)
```

Since `-50` is less than zero, it violates the CHECK constraint and MySQL does not allow the record to be inserted.

### Business Insight

CHECK constraints help enforce business rules by ensuring that only valid product prices are stored, improving data accuracy and reliability.
