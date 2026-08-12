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