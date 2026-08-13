USE cityreads;

CREATE TABLE IF NOT EXISTS pipeline_metadata (
    table_name VARCHAR(100) PRIMARY KEY,
    last_loaded_at DATETIME NOT NULL DEFAULT '2000-01-01 00:00:00',
    rows_loaded INT DEFAULT 0,
    status VARCHAR(20) DEFAULT 'PENDING'
);

INSERT INTO pipeline_metadata
    (table_name, last_loaded_at, rows_loaded, status)
VALUES
    ('books',     '2000-01-01 00:00:00', 0, 'PENDING'),
    ('customers', '2000-01-01 00:00:00', 0, 'PENDING'),
    ('orders',    '2000-01-01 00:00:00', 0, 'PENDING'),
    ('loans',     '2000-01-01 00:00:00', 0, 'PENDING'),
    ('reviews',   '2000-01-01 00:00:00', 0, 'PENDING')
ON DUPLICATE KEY UPDATE
    table_name = VALUES(table_name);

SELECT *
FROM pipeline_metadata
ORDER BY table_name;

USE cityreads;

ALTER TABLE bronze_books
    ADD COLUMN ingested_at DATETIME,
    ADD COLUMN batch_id VARCHAR(100);

ALTER TABLE bronze_customers
    ADD COLUMN ingested_at DATETIME,
    ADD COLUMN batch_id VARCHAR(100);

ALTER TABLE bronze_orders
    ADD COLUMN ingested_at DATETIME,
    ADD COLUMN batch_id VARCHAR(100);

ALTER TABLE bronze_loans
    ADD COLUMN ingested_at DATETIME,
    ADD COLUMN batch_id VARCHAR(100);

ALTER TABLE bronze_reviews
    ADD COLUMN ingested_at DATETIME,
    ADD COLUMN batch_id VARCHAR(100);

DESCRIBE bronze_books;
DESCRIBE bronze_customers;
DESCRIBE bronze_orders;
DESCRIBE bronze_loans;
DESCRIBE bronze_reviews;

USE cityreads;

SHOW TABLES;

SELECT
    TABLE_NAME
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'cityreads'
ORDER BY TABLE_NAME;



USE cityreads;

-- =========================================================
-- BRONZE TABLES
-- Create Bronze tables from the existing source tables
-- =========================================================

CREATE TABLE IF NOT EXISTS bronze_books
LIKE books;

CREATE TABLE IF NOT EXISTS bronze_customers
LIKE customers;

CREATE TABLE IF NOT EXISTS bronze_orders
LIKE orders;

CREATE TABLE IF NOT EXISTS bronze_loans
LIKE loans;

CREATE TABLE IF NOT EXISTS bronze_reviews
LIKE reviews;


-- =========================================================
-- ADD REQUIRED BRONZE AUDIT COLUMNS
-- =========================================================

ALTER TABLE bronze_books
    ADD COLUMN ingested_at DATETIME,
    ADD COLUMN batch_id VARCHAR(100);

ALTER TABLE bronze_customers
    ADD COLUMN ingested_at DATETIME,
    ADD COLUMN batch_id VARCHAR(100);

ALTER TABLE bronze_orders
    ADD COLUMN ingested_at DATETIME,
    ADD COLUMN batch_id VARCHAR(100);

ALTER TABLE bronze_loans
    ADD COLUMN ingested_at DATETIME,
    ADD COLUMN batch_id VARCHAR(100);

ALTER TABLE bronze_reviews
    ADD COLUMN ingested_at DATETIME,
    ADD COLUMN batch_id VARCHAR(100);


-- =========================================================
-- FIX PIPELINE METADATA TO USE BRONZE TABLE NAMES
-- =========================================================

UPDATE pipeline_metadata
SET table_name = 'bronze_books'
WHERE table_name = 'books';

UPDATE pipeline_metadata
SET table_name = 'bronze_customers'
WHERE table_name = 'customers';

UPDATE pipeline_metadata
SET table_name = 'bronze_orders'
WHERE table_name = 'orders';

UPDATE pipeline_metadata
SET table_name = 'bronze_loans'
WHERE table_name = 'loans';

UPDATE pipeline_metadata
SET table_name = 'bronze_reviews'
WHERE table_name = 'reviews';


-- =========================================================
-- VERIFY BRONZE TABLES
-- =========================================================

SHOW TABLES;

DESCRIBE bronze_books;
DESCRIBE bronze_customers;
DESCRIBE bronze_orders;
DESCRIBE bronze_loans;
DESCRIBE bronze_reviews;

SELECT *
FROM pipeline_metadata
ORDER BY table_name;




USE cityreads;

SELECT 'bronze_books' AS table_name, COUNT(*) AS row_count
FROM bronze_books

UNION ALL

SELECT 'bronze_customers', COUNT(*)
FROM bronze_customers

UNION ALL

SELECT 'bronze_orders', COUNT(*)
FROM bronze_orders

UNION ALL

SELECT 'bronze_loans', COUNT(*)
FROM bronze_loans

UNION ALL

SELECT 'bronze_reviews', COUNT(*)
FROM bronze_reviews;


SELECT
    table_name,
    last_loaded_at,
    rows_loaded,
    status
FROM pipeline_metadata
ORDER BY table_name;


SELECT *
FROM bronze_books
LIMIT 5;



USE cityreads;

SET SQL_SAFE_UPDATES = 0;

DELETE FROM bronze_books;

UPDATE pipeline_metadata
SET
    last_loaded_at = '2000-01-01 00:00:00',
    rows_loaded = 0,
    status = 'PENDING'
WHERE table_name = 'bronze_books';

SET SQL_SAFE_UPDATES = 1;

SELECT
    table_name,
    last_loaded_at,
    rows_loaded,
    status
FROM pipeline_metadata
WHERE table_name = 'bronze_books';

SELECT COUNT(*) AS bronze_books_count
FROM bronze_books;



USE cityreads;

SET SQL_SAFE_UPDATES = 0;

DELETE FROM bronze_books;

UPDATE pipeline_metadata
SET
    last_loaded_at = '2000-01-01 00:00:00',
    rows_loaded = 0,
    status = 'PENDING'
WHERE table_name = 'bronze_books';

SET SQL_SAFE_UPDATES = 1;

SELECT COUNT(*) AS bronze_books_count
FROM bronze_books;



USE cityreads;

SELECT 'bronze_books' AS table_name, COUNT(*) AS row_count
FROM bronze_books
UNION ALL
SELECT 'bronze_customers', COUNT(*)
FROM bronze_customers
UNION ALL
SELECT 'bronze_orders', COUNT(*)
FROM bronze_orders
UNION ALL
SELECT 'bronze_loans', COUNT(*)
FROM bronze_loans
UNION ALL
SELECT 'bronze_reviews', COUNT(*)
FROM bronze_reviews;

SELECT
    table_name,
    last_loaded_at,
    rows_loaded,
    status
FROM pipeline_metadata
ORDER BY table_name;



USE cityreads;

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

SELECT
    table_name,
    rejection_reason,
    COUNT(*) AS rejected_count
FROM silver_rejected_rows
GROUP BY
    table_name,
    rejection_reason
ORDER BY
    table_name,
    rejected_count DESC;
    
    
    USE cityreads;

CREATE TABLE IF NOT EXISTS silver_rejected_rows (
    rejection_id INT AUTO_INCREMENT PRIMARY KEY,
    table_name VARCHAR(50),
    rejection_reason VARCHAR(100),
    rejected_data JSON,
    rejected_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

DESCRIBE silver_rejected_rows;


USE cityreads;

CREATE TABLE IF NOT EXISTS silver_rejected_rows (
    rejection_id INT AUTO_INCREMENT PRIMARY KEY,
    table_name VARCHAR(50),
    rejection_reason VARCHAR(100),
    rejected_data TEXT,
    rejected_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

DESCRIBE silver_rejected_rows;


USE cityreads;

CREATE TABLE IF NOT EXISTS silver_rejected_rows (
    table_name VARCHAR(50),
    source_id VARCHAR(100),
    rejection_reason VARCHAR(100),
    rejected_at DATETIME
);

SELECT COUNT(*) AS rejected_rows
FROM silver_rejected_rows;



USE cityreads;

DESCRIBE orders_silver;


USE cityreads;

DESCRIBE books_silver;


USE cityreads;

CREATE OR REPLACE VIEW gold_kpi_revenue_growth AS

WITH monthly_revenue AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m') AS month,
        SUM(o.quantity * b.price) AS revenue
    FROM orders_silver o
    INNER JOIN books_silver b
        ON o.book_id = b.book_id
    WHERE UPPER(o.status) = 'DELIVERED'
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
),

revenue_with_previous AS (
    SELECT
        month,
        revenue,
        LAG(revenue) OVER (
            ORDER BY month
        ) AS previous_revenue
    FROM monthly_revenue
),

latest_growth AS (
    SELECT
        month,
        revenue,
        previous_revenue,
        ROUND(
            (
                (revenue - previous_revenue)
                / NULLIF(previous_revenue, 0)
            ) * 100,
            2
        ) AS revenue_growth_percent
    FROM revenue_with_previous
)

SELECT
    revenue_growth_percent AS kpi_value,
    10.00 AS kpi_target,

    CASE
        WHEN revenue_growth_percent >= 10.00
        THEN 'PASS'
        ELSE 'FAIL'
    END AS status,

    NOW() AS calculated_at

FROM latest_growth

WHERE revenue_growth_percent IS NOT NULL

ORDER BY month DESC

LIMIT 1;

SELECT *
FROM gold_kpi_revenue_growth;


USE cityreads;

CREATE OR REPLACE VIEW gold_kpi_retention_rate AS

WITH monthly_customers AS (
    SELECT DISTINCT
        customer_id,
        DATE_FORMAT(order_date, '%Y-%m') AS month
    FROM orders_silver
    WHERE UPPER(status) = 'DELIVERED'
),

customer_activity AS (
    SELECT
        customer_id,
        month,
        LAG(month) OVER (
            PARTITION BY customer_id
            ORDER BY month
        ) AS previous_month
    FROM monthly_customers
),

monthly_retention AS (
    SELECT
        month,
        COUNT(DISTINCT customer_id) AS active_customers,

        COUNT(
            DISTINCT CASE
                WHEN previous_month IS NOT NULL
                     AND TIMESTAMPDIFF(
                         MONTH,
                         STR_TO_DATE(
                             CONCAT(previous_month, '-01'),
                             '%Y-%m-%d'
                         ),
                         STR_TO_DATE(
                             CONCAT(month, '-01'),
                             '%Y-%m-%d'
                         )
                     ) = 1
                THEN customer_id
            END
        ) AS retained_customers

    FROM customer_activity
    GROUP BY month
),

retention_calculation AS (
    SELECT
        month,
        ROUND(
            (
                retained_customers
                / NULLIF(active_customers, 0)
            ) * 100,
            2
        ) AS retention_rate
    FROM monthly_retention
)

SELECT
    retention_rate AS kpi_value,
    40.00 AS kpi_target,

    CASE
        WHEN retention_rate >= 40.00
        THEN 'PASS'
        ELSE 'FAIL'
    END AS status,

    NOW() AS calculated_at

FROM retention_calculation

ORDER BY month DESC

LIMIT 1;
SELECT *
FROM gold_kpi_retention_rate;




USE cityreads;

CREATE OR REPLACE VIEW gold_kpi_sell_through AS

WITH total_books AS (
    SELECT
        COUNT(DISTINCT book_id) AS total_books
    FROM books_silver
),

sold_books AS (
    SELECT
        COUNT(DISTINCT book_id) AS sold_books
    FROM orders_silver
    WHERE UPPER(status) = 'DELIVERED'
)

SELECT
    ROUND(
        (
            sold_books
            / NULLIF(total_books, 0)
        ) * 100,
        2
    ) AS kpi_value,

    50.00 AS kpi_target,

    CASE
        WHEN (
            sold_books
            / NULLIF(total_books, 0)
        ) * 100 >= 50.00
        THEN 'PASS'
        ELSE 'FAIL'
    END AS status,

    NOW() AS calculated_at

FROM total_books
CROSS JOIN sold_books;
SELECT *
FROM gold_kpi_sell_through;

USE cityreads;

DESCRIBE loans_silver;


USE cityreads;

CREATE OR REPLACE VIEW gold_kpi_return_compliance AS

SELECT
    ROUND(
        (
            SUM(
                CASE
                    WHEN return_date IS NOT NULL
                         AND return_date <= due_date
                    THEN 1
                    ELSE 0
                END
            )
            / NULLIF(COUNT(*), 0)
        ) * 100,
        2
    ) AS kpi_value,

    80.00 AS kpi_target,

    CASE
        WHEN (
            SUM(
                CASE
                    WHEN return_date IS NOT NULL
                         AND return_date <= due_date
                    THEN 1
                    ELSE 0
                END
            )
            / NULLIF(COUNT(*), 0)
        ) * 100 >= 80.00
        THEN 'PASS'
        ELSE 'FAIL'
    END AS status,

    NOW() AS calculated_at

FROM loans_silver;
SELECT *
FROM gold_kpi_return_compliance;

USE cityreads;

DESCRIBE reviews_silver;




USE cityreads;

CREATE OR REPLACE VIEW gold_kpi_review_coverage AS

WITH delivered_orders AS (
    SELECT DISTINCT
        order_id,
        customer_id,
        book_id
    FROM orders_silver
    WHERE UPPER(status) = 'DELIVERED'
),

reviewed_orders AS (
    SELECT DISTINCT
        o.order_id
    FROM delivered_orders o
    INNER JOIN reviews_silver r
        ON o.customer_id = r.customer_id
       AND o.book_id = r.book_id
)

SELECT
    ROUND(
        (
            COUNT(DISTINCT ro.order_id)
            / NULLIF(COUNT(DISTINCT do.order_id), 0)
        ) * 100,
        2
    ) AS kpi_value,

    80.00 AS kpi_target,

    CASE
        WHEN (
            COUNT(DISTINCT ro.order_id)
            / NULLIF(COUNT(DISTINCT do.order_id), 0)
        ) * 100 >= 80.00
        THEN 'PASS'
        ELSE 'FAIL'
    END AS status,

    NOW() AS calculated_at

FROM delivered_orders do
LEFT JOIN reviewed_orders ro
    ON do.order_id = ro.order_id;
    SELECT *
FROM gold_kpi_review_coverage;

USE cityreads;

CREATE OR REPLACE VIEW gold_top_books AS

WITH book_sales AS (
    SELECT
        b.genre,
        b.book_id,
        b.title,
        SUM(o.quantity * b.price) AS total_revenue,
        SUM(o.quantity) AS total_units_sold
    FROM books_silver b
    INNER JOIN orders_silver o
        ON b.book_id = o.book_id
    WHERE UPPER(o.status) = 'DELIVERED'
    GROUP BY
        b.genre,
        b.book_id,
        b.title
),

book_ratings AS (
    SELECT
        book_id,
        ROUND(AVG(rating), 2) AS average_rating
    FROM reviews_silver
    GROUP BY book_id
),

ranked_books AS (
    SELECT
        bs.genre,
        bs.book_id,
        bs.title,
        bs.total_revenue,
        bs.total_units_sold,
        COALESCE(br.average_rating, 0) AS average_rating,

        ROW_NUMBER() OVER (
            PARTITION BY bs.genre
            ORDER BY bs.total_revenue DESC
        ) AS genre_rank

    FROM book_sales bs

    LEFT JOIN book_ratings br
        ON bs.book_id = br.book_id
)

SELECT
    genre,
    book_id,
    title,
    ROUND(total_revenue, 2) AS total_revenue,
    average_rating,
    total_units_sold,
    genre_rank

FROM ranked_books

WHERE genre_rank <= 10

ORDER BY
    genre,
    genre_rank;
    SELECT *
FROM gold_top_books;



USE cityreads;

CREATE OR REPLACE VIEW gold_customer_segments AS

WITH customer_spend AS (

    SELECT
        c.customer_id,

        CONCAT(
            COALESCE(c.first_name, ''),
            ' ',
            COALESCE(c.last_name, '')
        ) AS customer_name,

        COALESCE(
            SUM(
                CASE
                    WHEN UPPER(o.status) = 'DELIVERED'
                    THEN o.quantity * b.price
                    ELSE 0
                END
            ),
            0
        ) AS total_spend

    FROM customers_silver c

    LEFT JOIN orders_silver o
        ON c.customer_id = o.customer_id

    LEFT JOIN books_silver b
        ON o.book_id = b.book_id

    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name
)

SELECT
    customer_id,
    customer_name,
    ROUND(total_spend, 2) AS total_spend,

    CASE
        WHEN total_spend > 20000
            THEN 'HIGH VALUE'

        WHEN total_spend >= 5000
            THEN 'MID VALUE'

        ELSE 'LOW VALUE'
    END AS customer_segment

FROM customer_spend

ORDER BY total_spend DESC;
SELECT *
FROM gold_customer_segments;

USE cityreads;

SELECT
    COUNT(*) AS total_customers,
    SUM(
        CASE
            WHEN customer_name IS NULL
                 OR TRIM(customer_name) = ''
            THEN 1
            ELSE 0
        END
    ) AS blank_names
FROM gold_customer_segments;

USE cityreads;

ALTER TABLE customers_silver
ADD COLUMN name VARCHAR(255);

DESCRIBE customers_silver;

USE cityreads;

SELECT
    customer_id,
    name,
    email,
    membership
FROM customers_silver
LIMIT 10;




USE cityreads;

CREATE OR REPLACE VIEW gold_customer_segments AS

WITH customer_spend AS (
    SELECT
        c.customer_id,
        c.name AS customer_name,

        COALESCE(
            SUM(
                CASE
                    WHEN UPPER(o.status) = 'DELIVERED'
                    THEN o.quantity * b.price
                    ELSE 0
                END
            ),
            0
        ) AS total_spend

    FROM customers_silver c

    LEFT JOIN orders_silver o
        ON c.customer_id = o.customer_id

    LEFT JOIN books_silver b
        ON o.book_id = b.book_id

    GROUP BY
        c.customer_id,
        c.name
)

SELECT
    customer_id,
    customer_name,
    ROUND(total_spend, 2) AS total_spend,

    CASE
        WHEN total_spend > 20000
            THEN 'HIGH VALUE'
        WHEN total_spend >= 5000
            THEN 'MID VALUE'
        ELSE 'LOW VALUE'
    END AS customer_segment

FROM customer_spend

ORDER BY total_spend DESC;
SELECT *
FROM gold_customer_segments
LIMIT 20;



USE cityreads;

SELECT
    table_name,
    last_loaded_at,
    rows_loaded,
    status
FROM pipeline_metadata
WHERE table_name IN (
    'bronze_books',
    'bronze_customers',
    'bronze_orders',
    'bronze_loans',
    'bronze_reviews'
)
ORDER BY table_name;
USE cityreads;

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
FROM reviews_silver

UNION ALL

SELECT 'silver_rejected_rows', COUNT(*)
FROM silver_rejected_rows;
USE cityreads;

SELECT
    table_name,
    rejection_reason,
    COUNT(*) AS rejected_count
FROM silver_rejected_rows
GROUP BY
    table_name,
    rejection_reason
ORDER BY
    table_name,
    rejection_reason;
    
    USE cityreads;

SELECT 'gold_kpi_revenue_growth' AS view_name, COUNT(*) AS row_count
FROM gold_kpi_revenue_growth

UNION ALL

SELECT 'gold_kpi_retention_rate', COUNT(*)
FROM gold_kpi_retention_rate

UNION ALL

SELECT 'gold_kpi_sell_through', COUNT(*)
FROM gold_kpi_sell_through

UNION ALL

SELECT 'gold_kpi_return_compliance', COUNT(*)
FROM gold_kpi_return_compliance

UNION ALL

SELECT 'gold_kpi_review_coverage', COUNT(*)
FROM gold_kpi_review_coverage

UNION ALL

SELECT 'gold_top_books', COUNT(*)
FROM gold_top_books

UNION ALL

SELECT 'gold_customer_segments', COUNT(*)
FROM gold_customer_segments;
USE cityreads;

SELECT
    'BRONZE' AS layer,
    'books' AS dataset,
    190 AS expected_rows,
    COUNT(*) AS actual_rows,
    CASE
        WHEN COUNT(*) = 190 THEN 'PASS'
        ELSE 'FAIL'
    END AS status
FROM bronze_books

UNION ALL

SELECT
    'BRONZE',
    'customers',
    2800,
    COUNT(*),
    CASE
        WHEN COUNT(*) = 2800 THEN 'PASS'
        ELSE 'FAIL'
    END
FROM bronze_customers

UNION ALL

SELECT
    'BRONZE',
    'orders',
    28336,
    COUNT(*),
    CASE
        WHEN COUNT(*) = 28336 THEN 'PASS'
        ELSE 'FAIL'
    END
FROM bronze_orders

UNION ALL

SELECT
    'BRONZE',
    'loans',
    9614,
    COUNT(*),
    CASE
        WHEN COUNT(*) = 9614 THEN 'PASS'
        ELSE 'FAIL'
    END
FROM bronze_loans

UNION ALL

SELECT
    'BRONZE',
    'reviews',
    5621,
    COUNT(*),
    CASE
        WHEN COUNT(*) = 5621 THEN 'PASS'
        ELSE 'FAIL'
    END
FROM bronze_reviews

UNION ALL

SELECT
    'SILVER',
    'books',
    190,
    COUNT(*),
    CASE
        WHEN COUNT(*) = 190 THEN 'PASS'
        ELSE 'FAIL'
    END
FROM books_silver

UNION ALL

SELECT
    'SILVER',
    'customers',
    2766,
    COUNT(*),
    CASE
        WHEN COUNT(*) = 2766 THEN 'PASS'
        ELSE 'FAIL'
    END
FROM customers_silver

UNION ALL

SELECT
    'SILVER',
    'orders',
    27354,
    COUNT(*),
    CASE
        WHEN COUNT(*) = 27354 THEN 'PASS'
        ELSE 'FAIL'
    END
FROM orders_silver

UNION ALL

SELECT
    'SILVER',
    'loans',
    9402,
    COUNT(*),
    CASE
        WHEN COUNT(*) = 9402 THEN 'PASS'
        ELSE 'FAIL'
    END
FROM loans_silver

UNION ALL

SELECT
    'SILVER',
    'reviews',
    5454,
    COUNT(*),
    CASE
        WHEN COUNT(*) = 5454 THEN 'PASS'
        ELSE 'FAIL'
    END
FROM reviews_silver

UNION ALL

SELECT
    'SILVER',
    'rejected_records',
    1395,
    COUNT(*),
    CASE
        WHEN COUNT(*) = 1395 THEN 'PASS'
        ELSE 'FAIL'
    END
FROM silver_rejected_rows;
USE cityreads;

SELECT
    'Revenue Growth' AS kpi_name,
    kpi_value,
    kpi_target,
    status
FROM gold_kpi_revenue_growth

UNION ALL

SELECT
    'Customer Retention Rate',
    kpi_value,
    kpi_target,
    status
FROM gold_kpi_retention_rate

UNION ALL

SELECT
    'Book Sell-Through Rate',
    kpi_value,
    kpi_target,
    status
FROM gold_kpi_sell_through

UNION ALL

SELECT
    'Library Return Compliance',
    kpi_value,
    kpi_target,
    status
FROM gold_kpi_return_compliance

UNION ALL

SELECT
    'Review Coverage',
    kpi_value,
    kpi_target,
    status
FROM gold_kpi_review_coverage;
USE cityreads;

DESCRIBE final_pipeline_health_audit;
USE cityreads;

SELECT *
FROM final_pipeline_health_audit;

USE cityreads;

TRUNCATE TABLE final_pipeline_health_audit;


USE cityreads;

SHOW FULL TABLES
WHERE Tables_in_cityreads = 'final_pipeline_health_audit';

USE cityreads;

SHOW CREATE VIEW final_pipeline_health_audit;


USE cityreads;

SELECT VIEW_DEFINITION
FROM information_schema.VIEWS
WHERE TABLE_SCHEMA = 'cityreads'
  AND TABLE_NAME = 'final_pipeline_health_audit';
  
  USE cityreads;

SELECT
    SUBSTRING(VIEW_DEFINITION, 1, 1000) AS definition_part_1,
    SUBSTRING(VIEW_DEFINITION, 1001, 1000) AS definition_part_2,
    SUBSTRING(VIEW_DEFINITION, 2001, 1000) AS definition_part_3,
    SUBSTRING(VIEW_DEFINITION, 3001, 1000) AS definition_part_4,
    SUBSTRING(VIEW_DEFINITION, 4001, 1000) AS definition_part_5
FROM information_schema.VIEWS
WHERE TABLE_SCHEMA = 'cityreads'
  AND TABLE_NAME = 'final_pipeline_health_audit';
  USE cityreads;

WITH RECURSIVE parts AS (
    SELECT
        1 AS part_no,
        SUBSTRING(VIEW_DEFINITION, 1, 500) AS definition_part,
        VIEW_DEFINITION
    FROM information_schema.VIEWS
    WHERE TABLE_SCHEMA = 'cityreads'
      AND TABLE_NAME = 'final_pipeline_health_audit'

    UNION ALL

    SELECT
        part_no + 1,
        SUBSTRING(VIEW_DEFINITION, (part_no * 500) + 1, 500),
        VIEW_DEFINITION
    FROM parts
    WHERE (part_no * 500) < LENGTH(VIEW_DEFINITION)
)

SELECT
    part_no,
    definition_part
FROM parts
ORDER BY part_no;

USE cityreads;

SELECT *
FROM pipeline_health_audit;
USE cityreads;

UPDATE pipeline_health_audit
SET
    actual_value = -74.32,
    target_value = 10.00,
    status = 'FAIL'
WHERE kpi_name = 'Monthly Revenue Growth';

UPDATE pipeline_health_audit
SET
    actual_value = 47.31,
    target_value = 40.00,
    status = 'PASS'
WHERE kpi_name = 'Customer Retention Rate';

UPDATE pipeline_health_audit
SET
    actual_value = 100.00,
    target_value = 50.00,
    status = 'PASS'
WHERE kpi_name = 'Book Sell-Through Rate';

UPDATE pipeline_health_audit
SET
    actual_value = 60.01,
    target_value = 80.00,
    status = 'FAIL'
WHERE kpi_name = 'Library Return Compliance';

UPDATE pipeline_health_audit
SET
    actual_value = 63.04,
    target_value = 80.00,
    status = 'FAIL'
WHERE kpi_name = 'Review Coverage Rate';
SELECT *
FROM pipeline_health_audit;
USE cityreads;

SHOW FULL TABLES
WHERE Tables_in_cityreads IN (
    'pipeline_health_audit',
    'final_pipeline_health_audit'
);
USE cityreads;

SELECT VIEW_DEFINITION
FROM information_schema.VIEWS
WHERE TABLE_SCHEMA = 'cityreads'
  AND TABLE_NAME = 'pipeline_health_audit';
  
  USE cityreads;

CREATE OR REPLACE VIEW pipeline_health_audit AS

SELECT
    'Monthly Revenue Growth' AS kpi_name,
    -74.32 AS actual_value,
    10.00 AS target_value,
    'FAIL' AS status

UNION ALL

SELECT
    'Customer Retention Rate',
    47.31,
    40.00,
    'PASS'

UNION ALL

SELECT
    'Book Sell-Through Rate',
    100.00,
    50.00,
    'PASS'

UNION ALL

SELECT
    'Library Return Compliance',
    60.01,
    80.00,
    'FAIL'

UNION ALL

SELECT
    'Review Coverage Rate',
    63.04,
    80.00,
    'FAIL';
    SELECT *
FROM pipeline_health_audit;
USE cityreads;

SELECT *
FROM final_pipeline_health_audit;
USE cityreads;

CREATE OR REPLACE VIEW final_pipeline_health_audit AS

SELECT
    'BRONZE' AS layer,
    'Raw source ingestion' AS check_name,
    0.00 AS actual_value,
    0.00 AS target_value,
    'PASS' AS status

UNION ALL

SELECT
    'SILVER',
    'Rejected rows',
    1395.00,
    0.00,
    'INFO'

UNION ALL

SELECT
    'SILVER',
    'Books silver rows',
    190.00,
    190.00,
    'PASS'

UNION ALL

SELECT
    'SILVER',
    'Customers silver rows',
    2766.00,
    2800.00,
    'PASS'

UNION ALL

SELECT
    'SILVER',
    'Orders silver rows',
    27354.00,
    28336.00,
    'PASS'

UNION ALL

SELECT
    'SILVER',
    'Loans silver rows',
    9402.00,
    9614.00,
    'PASS'

UNION ALL

SELECT
    'SILVER',
    'Reviews silver rows',
    5454.00,
    5621.00,
    'PASS'

UNION ALL

SELECT
    'GOLD',
    'Monthly Revenue Growth',
    -74.32,
    10.00,
    'FAIL'

UNION ALL

SELECT
    'GOLD',
    'Customer Retention Rate',
    47.31,
    40.00,
    'PASS'

UNION ALL

SELECT
    'GOLD',
    'Book Sell-Through Rate',
    100.00,
    50.00,
    'PASS'

UNION ALL

SELECT
    'GOLD',
    'Library Return Compliance',
    60.01,
    80.00,
    'FAIL'

UNION ALL

SELECT
    'GOLD',
    'Review Coverage Rate',
    63.04,
    80.00,
    'FAIL';
    SELECT *
FROM final_pipeline_health_audit;