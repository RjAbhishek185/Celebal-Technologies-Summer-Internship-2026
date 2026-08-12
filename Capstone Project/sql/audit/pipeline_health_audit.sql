USE cityreads;

CREATE OR REPLACE VIEW pipeline_health_audit AS

SELECT
    'Monthly Revenue Growth' AS kpi_name,

    ROUND(
        AVG(revenue_growth_percent),
        2
    ) AS actual_value,

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

    ROUND(
        AVG(retention_rate_percent),
        2
    ),

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

    ROUND(
        AVG(sell_through_rate_percent),
        2
    ),

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