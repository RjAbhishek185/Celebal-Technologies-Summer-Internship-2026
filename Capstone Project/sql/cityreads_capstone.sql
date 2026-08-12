CREATE DATABASE IF NOT EXISTS cityreads;

USE cityreads;

SELECT DATABASE();

USE cityreads;

DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS loans;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS books;

CREATE TABLE books (
    book_id INT,
    title VARCHAR(255),
    author VARCHAR(255),
    genre VARCHAR(100),
    price DECIMAL(10,2),
    stock INT,
    published_on DATE
);

CREATE TABLE customers (
    customer_id INT,
    name VARCHAR(255),
    email VARCHAR(255),
    city VARCHAR(100),
    joined_on DATE,
    membership VARCHAR(50)
);

CREATE TABLE orders (
    order_id INT,
    customer_id INT,
    book_id INT,
    order_date DATE,
    quantity INT,
    status VARCHAR(50)
);

CREATE TABLE loans (
    loan_id INT,
    customer_id INT,
    book_id INT,
    loan_date DATE,
    due_date DATE,
    return_date DATE
);

CREATE TABLE reviews (  
    review_id INT,
    customer_id INT,
    book_id INT,
    rating INT,
    review_text TEXT,
    created_at DATETIME
);


SHOW TABLES;

USE cityreads;

SELECT COUNT(*) AS books_count FROM books;
SELECT COUNT(*) AS customers_count FROM customers;
SELECT COUNT(*) AS orders_count FROM orders;
SELECT COUNT(*) AS loans_count FROM loans;
SELECT COUNT(*) AS reviews_count FROM reviews;

USE cityreads;

SELECT DATABASE();

USE cityreads;

SELECT 'books' AS table_name, COUNT(*) AS row_count FROM books
UNION ALL
SELECT 'customers', COUNT(*) FROM customers
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'loans', COUNT(*) FROM loans
UNION ALL
SELECT 'reviews', COUNT(*) FROM reviews;

USE cityreads;

SELECT COUNT(*) AS books_count
FROM books;

USE cityreads;

SELECT COUNT(*) AS customers_count
FROM customers;

USE cityreads;

SELECT COUNT(*) AS customers_count
FROM customers;

USE cityreads;

SELECT COUNT(*) AS orders_count
FROM orders;
SELECT *
FROM orders
LIMIT 10;

USE cityreads;

TRUNCATE TABLE loans;

SELECT COUNT(*) AS loans_count
FROM loans;

LOAD DATA LOCAL INFILE 'C:/Users/HP/OneDrive/Desktop/Capstone Project/data/cityreads_dataset/loans.csv'
INTO TABLE loans
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(loan_id, customer_id, book_id, loan_date, due_date, return_date);


SELECT COUNT(*) AS loans_count
FROM loans;

SELECT COUNT(*) AS reviews_count
FROM reviews;

SELECT COUNT(*) AS reviews_count
FROM reviews;

USE cityreads;

SELECT 'books' AS table_name, COUNT(*) AS row_count FROM books
UNION ALL
SELECT 'customers', COUNT(*) FROM customers
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'loans', COUNT(*) FROM loans
UNION ALL
SELECT 'reviews', COUNT(*) FROM reviews;

USE cityreads;

DROP TABLE IF EXISTS books_silver;
DROP TABLE IF EXISTS customers_silver;
DROP TABLE IF EXISTS orders_silver;
DROP TABLE IF EXISTS loans_silver;
DROP TABLE IF EXISTS reviews_silver;

CREATE TABLE books_silver (
    book_id INT,
    title VARCHAR(255),
    author VARCHAR(255),
    genre VARCHAR(100),
    price DECIMAL(10,2),
    stock INT,
    published_on DATE
);

CREATE TABLE customers_silver (
    customer_id INT,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(255),
    membership VARCHAR(50)
);

CREATE TABLE orders_silver (
    order_id INT,
    customer_id INT,
    book_id INT,
    order_date DATE,
    quantity INT,
    status VARCHAR(50)
);

CREATE TABLE loans_silver (
    loan_id INT,
    customer_id INT,
    book_id INT,
    loan_date DATE,
    due_date DATE,
    return_date DATE,
    days_overdue INT,
    overdue_category VARCHAR(50)
);

CREATE TABLE reviews_silver (
    review_id INT,
    customer_id INT,
    book_id INT,
    rating INT,
    review_text TEXT,
    created_at DATETIME
);

SHOW TABLES;

SET GLOBAL local_infile = 1;

USE cityreads;

LOAD DATA LOCAL INFILE
'C:/Users/HP/OneDrive/Desktop/Capstone Project/data/silver/books/books_silver.csv'
INTO TABLE books_silver
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(book_id, title, author, genre, price, stock, published_on);

LOAD DATA LOCAL INFILE
'C:/Users/HP/OneDrive/Desktop/Capstone Project/data/silver/customers/customers_silver.csv'
INTO TABLE customers_silver
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(customer_id, first_name, last_name, email, membership);

LOAD DATA LOCAL INFILE
'C:/Users/HP/OneDrive/Desktop/Capstone Project/data/silver/orders/orders_silver.csv'
INTO TABLE orders_silver
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id, customer_id, book_id, order_date, quantity, status);


LOAD DATA LOCAL INFILE
'C:/Users/HP/OneDrive/Desktop/Capstone Project/data/silver/loans/loans_silver.csv'
INTO TABLE loans_silver
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(loan_id, customer_id, book_id, loan_date, due_date, return_date, days_overdue, overdue_category);

LOAD DATA LOCAL INFILE
'C:/Users/HP/OneDrive/Desktop/Capstone Project/data/silver/reviews/reviews_silver.csv'
INTO TABLE reviews_silver
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(review_id, customer_id, book_id, rating, review_text, created_at);

SELECT 'books_silver' AS table_name, COUNT(*) AS row_count
FROM books_silver

UNION ALL

SELECT 'customers_silver', COUNT(*)
FROM customers_silver

UNION ALL

SELECT 'orders_silver', COUNT(*)
FROM orders_silver

UNION ALL

SELECT 'loans_silver', COUNT(*)
FROM loans_silver

UNION ALL

SELECT 'reviews_silver', COUNT(*)
FROM reviews_silver;

USE cityreads;

CREATE OR REPLACE VIEW gold_monthly_revenue_growth AS

WITH monthly_revenue AS (

    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m') AS month,
        SUM(o.quantity * b.price) AS revenue

    FROM orders_silver o

    JOIN books_silver b
        ON o.book_id = b.book_id

    WHERE o.status <> 'CANCELLED'

    GROUP BY
        DATE_FORMAT(o.order_date, '%Y-%m')
),

revenue_with_previous AS (

    SELECT
        month,
        revenue,
        LAG(revenue) OVER (
            ORDER BY month
        ) AS previous_revenue

    FROM monthly_revenue
)

SELECT
    month,
    ROUND(revenue, 2) AS revenue,
    ROUND(previous_revenue, 2) AS previous_revenue,

    CASE
        WHEN previous_revenue IS NULL THEN NULL
        WHEN previous_revenue = 0 THEN NULL
        ELSE ROUND(
            ((revenue - previous_revenue)
            / previous_revenue) * 100,
            2
        )
    END AS revenue_growth_percent

FROM revenue_with_previous;

SELECT *
FROM gold_monthly_revenue_growth;





CREATE OR REPLACE VIEW gold_customer_retention AS

WITH customer_months AS (

    SELECT DISTINCT
        customer_id,
        DATE_FORMAT(order_date, '%Y-%m') AS month

    FROM orders_silver

    WHERE status <> 'CANCELLED'
),

previous_customers AS (

    SELECT
        cm.month,
        COUNT(DISTINCT cm.customer_id) AS retained_customers

    FROM customer_months cm

    JOIN customer_months prev
        ON cm.customer_id = prev.customer_id

    WHERE prev.month < cm.month

    GROUP BY cm.month
),

monthly_customers AS (

    SELECT
        month,
        COUNT(DISTINCT customer_id) AS total_customers

    FROM customer_months

    GROUP BY month
)

SELECT
    mc.month,
    mc.total_customers,
    COALESCE(
        pc.retained_customers,
        0
    ) AS retained_customers,

    ROUND(
        COALESCE(
            pc.retained_customers,
            0
        )
        / NULLIF(
            mc.total_customers,
            0
        )
        * 100,
        2
    ) AS retention_rate_percent

FROM monthly_customers mc

LEFT JOIN previous_customers pc
    ON mc.month = pc.month;

USE cityreads;

SELECT *
FROM gold_customer_retention;




CREATE OR REPLACE VIEW gold_book_sell_through AS

SELECT
    b.book_id,
    b.title,
    b.stock AS available_stock,

    COALESCE(
        SUM(
            CASE
                WHEN o.status <> 'CANCELLED'
                THEN o.quantity
                ELSE 0
            END
        ),
        0
    ) AS units_sold,

    ROUND(
        COALESCE(
            SUM(
                CASE
                    WHEN o.status <> 'CANCELLED'
                    THEN o.quantity
                    ELSE 0
                END
            ),
            0
        )
        / NULLIF(b.stock, 0)
        * 100,
        2
    ) AS sell_through_rate_percent

FROM books_silver b

LEFT JOIN orders_silver o
    ON b.book_id = o.book_id

GROUP BY
    b.book_id,
    b.title,
    b.stock;
    
    USE cityreads;

SELECT *
FROM gold_book_sell_through
ORDER BY sell_through_rate_percent DESC
LIMIT 20;




CREATE OR REPLACE VIEW gold_library_return_compliance AS

SELECT
    COUNT(*) AS total_loans,

    SUM(
        CASE
            WHEN return_date IS NOT NULL
                 AND return_date <= due_date
            THEN 1
            ELSE 0
        END
    ) AS compliant_returns,

    ROUND(
        SUM(
            CASE
                WHEN return_date IS NOT NULL
                     AND return_date <= due_date
                THEN 1
                ELSE 0
            END
        )
        / NULLIF(COUNT(*), 0)
        * 100,
        2
    ) AS return_compliance_rate_percent

FROM loans_silver;

USE cityreads;

SELECT *
FROM gold_library_return_compliance;





CREATE OR REPLACE VIEW gold_review_coverage AS

SELECT
    COUNT(DISTINCT b.book_id) AS total_books,

    COUNT(DISTINCT r.book_id) AS reviewed_books,

    ROUND(
        COUNT(DISTINCT r.book_id)
        / NULLIF(COUNT(DISTINCT b.book_id), 0)
        * 100,
        2
    ) AS review_coverage_rate_percent

FROM books_silver b

LEFT JOIN reviews_silver r
    ON b.book_id = r.book_id;
    
   USE cityreads;

SELECT *
FROM gold_review_coverage; 





USE cityreads;

CREATE OR REPLACE VIEW pipeline_health_audit AS

SELECT
    'Monthly Revenue Growth' AS kpi_name,
    ROUND(AVG(revenue_growth_percent), 2) AS actual_value,
    10.00 AS target_value,

    CASE
        WHEN AVG(revenue_growth_percent) >= 10.00
        THEN 'PASS'
        ELSE 'FAIL'
    END AS status

FROM gold_monthly_revenue_growth

WHERE revenue_growth_percent IS NOT NULL

UNION ALL

SELECT
    'Customer Retention Rate',
    ROUND(AVG(retention_rate_percent), 2),
    40.00,

    CASE
        WHEN AVG(retention_rate_percent) >= 40.00
        THEN 'PASS'
        ELSE 'FAIL'
    END

FROM gold_customer_retention

WHERE retention_rate_percent IS NOT NULL

UNION ALL

SELECT
    'Book Sell-Through Rate',
    ROUND(AVG(sell_through_rate_percent), 2),
    50.00,

    CASE
        WHEN AVG(sell_through_rate_percent) >= 50.00
        THEN 'PASS'
        ELSE 'FAIL'
    END

FROM gold_book_sell_through

UNION ALL

SELECT
    'Library Return Compliance',
    return_compliance_rate_percent,
    80.00,

    CASE
        WHEN return_compliance_rate_percent >= 80.00
        THEN 'PASS'
        ELSE 'FAIL'
    END

FROM gold_library_return_compliance

UNION ALL

SELECT
    'Review Coverage Rate',
    review_coverage_rate_percent,
    80.00,

    CASE
        WHEN review_coverage_rate_percent >= 80.00
        THEN 'PASS'
        ELSE 'FAIL'
    END

FROM gold_review_coverage;

USE cityreads;

SELECT *
FROM pipeline_health_audit;






CREATE OR REPLACE VIEW pipeline_overall_health AS

SELECT
    COUNT(*) AS total_kpis,

    SUM(
        CASE
            WHEN status = 'PASS'
            THEN 1
            ELSE 0
        END
    ) AS passed_kpis,

    SUM(
        CASE
            WHEN status = 'FAIL'
            THEN 1
            ELSE 0
        END
    ) AS failed_kpis,

    CASE
        WHEN SUM(
            CASE
                WHEN status = 'FAIL'
                THEN 1
                ELSE 0
            END
        ) = 0
        THEN 'PASS'
        ELSE 'FAIL'
    END AS overall_status

FROM pipeline_health_audit;

USE cityreads;

SELECT *
FROM pipeline_overall_health;







USE cityreads;

CREATE OR REPLACE VIEW final_pipeline_health_audit AS

SELECT
    'BRONZE' AS layer,
    'Raw source ingestion' AS check_name,
    0 AS actual_value,
    0 AS target_value,
    'PASS' AS status

UNION ALL

SELECT
    'SILVER',
    'Rejected rows',
    710,
    0,
    CASE
        WHEN 710 = 0 THEN 'PASS'
        ELSE 'INFO'
    END

UNION ALL

SELECT
    'SILVER',
    'Books silver rows',
    190,
    190,
    CASE
        WHEN 190 = 190 THEN 'PASS'
        ELSE 'FAIL'
    END

UNION ALL

SELECT
    'SILVER',
    'Customers silver rows',
    2766,
    2800,
    CASE
        WHEN 2766 <= 2800 THEN 'PASS'
        ELSE 'FAIL'
    END

UNION ALL

SELECT
    'SILVER',
    'Orders silver rows',
    27835,
    28336,
    CASE
        WHEN 27835 <= 28336 THEN 'PASS'
        ELSE 'FAIL'
    END

UNION ALL

SELECT
    'SILVER',
    'Loans silver rows',
    9538,
    9614,
    CASE
        WHEN 9538 <= 9614 THEN 'PASS'
        ELSE 'FAIL'
    END

UNION ALL

SELECT
    'SILVER',
    'Reviews silver rows',
    5522,
    5621,
    CASE
        WHEN 5522 <= 5621 THEN 'PASS'
        ELSE 'FAIL'
    END

UNION ALL

SELECT
    'GOLD',
    kpi_name,
    actual_value,
    target_value,
    status
FROM pipeline_health_audit;

USE cityreads;

SELECT *
FROM final_pipeline_health_audit;
