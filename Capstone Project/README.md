# 📚 CityReads — Data Engineering Capstone Project

### Celebal Technologies Summer Internship 2026

---

## 📖 Overview

**CityReads** is an end-to-end Data Engineering Capstone Project developed as part of the **Celebal Technologies Summer Internship 2026**.

The project implements a production-style data pipeline using the **Medallion Architecture**, consisting of **Bronze, Silver, and Gold layers**.

The pipeline processes five datasets:

- 📚 Books
- 👥 Customers
- 🛒 Orders
- 📖 Loans
- ⭐ Reviews

The project demonstrates **incremental data ingestion, watermark-based processing, data-quality validation, rejected-record handling, SQL-based business analytics, KPI generation, and automated pipeline health auditing**.

---

# 🎯 Project Objectives

The main objectives of the CityReads project are:

- Implement incremental data ingestion.
- Build a Bronze layer for raw source data.
- Maintain watermark information to prevent duplicate ingestion.
- Build a Silver layer for data cleaning and validation.
- Detect and handle invalid and duplicate records.
- Store rejected records separately for auditing.
- Build a Gold layer containing business KPIs.
- Implement automated KPI PASS/FAIL validation.
- Create a final pipeline health audit.
- Follow an organized and maintainable Data Engineering project structure.

---

# 🏗️ Architecture

The project follows the **Medallion Architecture**:

text
                  CITYREADS SOURCE DATA
                         │
                         ▼
                ┌─────────────────┐
                │   SOURCE CSVs   │
                └────────┬────────┘
                         │
                         ▼
                ┌─────────────────┐
                │  BRONZE LAYER   │
                │                 │
                │ Incremental     │
                │ Ingestion       │
                │ Watermark       │
                └────────┬────────┘
                         │
                         ▼
                ┌─────────────────┐
                │  SILVER LAYER   │
                │                 │
                │ Cleaning        │
                │ Validation      │
                │ Deduplication   │
                │ Rejections      │
                └────────┬────────┘
                         │
                         ▼
                ┌─────────────────┐
                │   GOLD LAYER    │
                │                 │
                │ Business KPIs   │
                │ SQL Views       │
                └────────┬────────┘
                         │
                         ▼
                ┌─────────────────┐
                │ PIPELINE AUDIT  │
                │                 │
                │ PASS / FAIL     │
                └─────────────────┘
📊 Source Datasets

The project uses five source datasets.

Dataset	Source Records
📚 Books	190
👥 Customers	2,800
🛒 Orders	28,336
📖 Loans	9,614
⭐ Reviews	5,621
Total	46,561

Source files are stored in:

data/cityreads_dataset/

Files:

books.csv
customers.csv
orders.csv
loans.csv
reviews.csv
🥉 Bronze Layer

The Bronze layer stores the incrementally ingested source data.

Bronze Objectives
Preserve source information.
Perform incremental ingestion.
Maintain processing state.
Prevent duplicate ingestion.
Store ingestion metadata.
Bronze Structure
data/
└── bronze/
    ├── books/
    │   └── books_bronze.csv
    ├── customers/
    │   └── customers_bronze.csv
    ├── orders/
    │   └── orders_bronze.csv
    ├── loans/
    │   └── loans_bronze.csv
    ├── reviews/
    │   └── reviews_bronze.csv
    └── watermark.json
Incremental Processing

A separate watermark is maintained for each dataset.

The final Bronze ingestion loaded:

Books       : 190
Customers   : 2800
Orders      : 28336
Loans       : 9614
Reviews     : 5621

A subsequent execution produced:

Books       → 0 new rows
Customers   → 0 new rows
Orders      → 0 new rows
Loans       → 0 new rows
Reviews     → 0 new rows

Total new rows → 0

This confirms that previously processed records were not ingested again.

🥈 Silver Layer

The Silver layer converts Bronze data into cleaned and validated datasets.

Silver Processing

The following operations were implemented:

Data validation
Duplicate detection
Data cleaning
Standardization
Date validation
Numeric validation
Business-rule validation
Rejected-record logging
Derived columns
Silver Results
Dataset	Bronze Records	Silver Records
Books	190	190
Customers	2,800	2,766
Orders	28,336	27,354
Loans	9,614	9,402
Reviews	5,621	5,454
Total	46,561	45,166
Rejected Records

Total rejected records:

1,395

Rejected records are stored in:

data/silver/rejected/silver_rejected_rows.csv

The rejected-record dataset maintains information such as:

Table name
Source ID
Rejection reason
Rejection timestamp

This provides traceability for data-quality failures.

🥇 Gold Layer

The Gold layer contains business-ready SQL views created using the cleaned Silver data.

The following five business KPIs were implemented:

📈 Monthly Revenue Growth
👥 Customer Retention Rate
📚 Book Sell-Through Rate
📖 Library Return Compliance
⭐ Review Coverage Rate

Gold SQL logic:

sql/gold/gold_kpis.sql
📈 Gold KPI Results
1. Monthly Revenue Growth

Average monthly revenue growth:

-74.32%

Target:

10.00%

Status:

FAIL ❌

2. Customer Retention Rate

Average customer retention rate:

47.31%

Target:

40.00%

Status:

PASS ✅

3. Book Sell-Through Rate

Average book sell-through rate:

100.00%

Target:

50.00%

Status:

PASS ✅

4. Library Return Compliance

Return compliance rate:

60.01%

Target:

80.00%

Status:

FAIL ❌

5. Review Coverage Rate

Review coverage rate:

63.04%

Target:

80.00%

Status:

FAIL ❌

🔍 Pipeline Health Audit

An automated SQL-based pipeline health audit was implemented to compare actual KPI values against predefined business targets.

Audit SQL:

sql/audit/pipeline_health_audit.sql
KPI Audit Results
KPI	Actual	Target	Status
Monthly Revenue Growth	-74.32%	10.00%	❌ FAIL
Customer Retention Rate	47.31%	40.00%	✅ PASS
Book Sell-Through Rate	100.00%	50.00%	✅ PASS
Library Return Compliance	60.01%	80.00%	❌ FAIL
Review Coverage Rate	63.04%	80.00%	❌ FAIL
📋 Overall Pipeline Health

The overall KPI audit produced:

Metric	Result
Total KPIs	5
Passed KPIs	2
Failed KPIs	3
Overall Status	FAIL

The overall status is FAIL because three KPIs are below their defined targets:

Monthly Revenue Growth: -74.32% vs 10.00%
Library Return Compliance: 60.01% vs 80.00%
Review Coverage Rate: 63.04% vs 80.00%

The failed KPIs are intentionally retained to demonstrate real KPI monitoring and exception detection rather than artificially changing the results.

🔎 Final Pipeline Audit

The final pipeline audit combines validation results from the Bronze, Silver, and Gold layers.

The audit checks:

Bronze ingestion
Silver record counts
Rejected records
Gold KPI values
KPI targets
PASS/FAIL status

The final audit contains 12 validation checks.

Final audit SQL:

sql/audit/pipeline_health_audit.sql
📊 Final Pipeline Validation
Bronze Layer
Books       : 190
Customers   : 2800
Orders      : 28336
Loans       : 9614
Reviews     : 5621
Silver Layer
Books       : 190
Customers   : 2766
Orders      : 27354
Loans       : 9402
Reviews     : 5454
Rejected    : 1395
Gold Layer
Revenue Growth           : -74.32%  → FAIL
Customer Retention       : 47.31%   → PASS
Book Sell-Through        : 100.00%  → PASS
Return Compliance        : 60.01%   → FAIL
Review Coverage          : 63.04%   → FAIL
🗂️ Project Structure
Capstone Project/
│
├── data/
│   ├── cityreads_dataset/
│   │   ├── books.csv
│   │   ├── customers.csv
│   │   ├── loans.csv
│   │   ├── orders.csv
│   │   └── reviews.csv
│   │
│   ├── bronze/
│   │   ├── books/
│   │   ├── customers/
│   │   ├── loans/
│   │   ├── orders/
│   │   ├── reviews/
│   │   └── watermark.json
│   │
│   ├── silver/
│   │   ├── books/
│   │   ├── customers/
│   │   ├── loans/
│   │   ├── orders/
│   │   ├── reviews/
│   │   └── rejected/
│   │
│   └── gold/
│
├── scripts/
│   ├── bronze_ingestion.py
│   ├── silver_transform.py
│   └── README.md
│
├── sql/
│   ├── cityreads_capstone.sql
│   │
│   ├── gold/
│   │   └── gold_kpis.sql
│   │
│   └── audit/
│       └── pipeline_health_audit.sql
│
├── screenshots/
│   ├── phase1/
│   ├── phase2/
│   ├── phase3/
│   ├── phase4_bronze/
│   ├── phase5_silver/
│   ├── phase6_gold/
│   └── phase7_audit/
│
├── output/
│
├── Dataset_generator.py
│
└── README.md
📸 Screenshots & Execution Evidence

Execution evidence is organized by project phase:

screenshots/
├── phase1/
├── phase2/
├── phase3/
├── phase4_bronze/
├── phase5_silver/
├── phase6_gold/
└── phase7_audit/

The screenshots demonstrate:

Database setup
Source data loading
Bronze ingestion
Watermark processing
Silver transformation
Rejected-record handling
Gold KPI results
Customer segmentation
Top books analysis
Pipeline health audit
Final PASS/FAIL validation
🛠️ Technologies Used
🐍 Python
🐼 Pandas
🗄️ SQL
🐬 MySQL
🛠️ MySQL Workbench
📄 CSV
🏗️ Medallion Architecture
🔄 Incremental Data Processing
💧 Watermark Processing
🔍 Data Quality Validation
📊 SQL Analytics
🪟 Window Functions
🔗 Common Table Expressions
👁️ SQL Views
🔀 Joins
📈 Aggregations
🌐 Git & GitHub
💡 Key Concepts Demonstrated

This project demonstrates practical understanding of:

Data Engineering pipelines
ETL/ELT concepts
Medallion Architecture
Incremental ingestion
Watermark-based processing
Data quality checks
Data cleaning
Deduplication
Rejected-record handling
SQL analytics
Window functions
Common Table Expressions
Business KPI development
SQL views
Pipeline monitoring
PASS/FAIL validation
Audit reporting
Version control
📁 Important Project Files
Dataset Generation
Dataset_generator.py

Used to generate the CityReads source datasets.

Bronze Ingestion
scripts/bronze_ingestion.py

Implements incremental Bronze ingestion and watermark processing.

Silver Transformation
scripts/silver_transform.py

Performs Silver-layer cleaning, validation and rejected-record handling.

Main SQL Script
sql/cityreads_capstone.sql

Contains the main CityReads SQL implementation.

Gold KPI SQL
sql/gold/gold_kpis.sql

Contains the five Gold-layer business KPI views.

Pipeline Audit SQL
sql/audit/pipeline_health_audit.sql

Contains KPI and pipeline health validation logic.

📄 Project Report

The final project report is available in:

output/
🎓 Internship Details
Field	Information
Organization	Celebal Technologies
Role	Data Engineering Intern
Program	Celebal Technologies Summer Internship 2026
Project	CityReads Data Engineering Capstone Project
👨‍💻 Author
Abhishek Raj

Computer Science Engineering student passionate about:

Data Engineering
Software Development
Cloud Technologies
Artificial Intelligence
GitHub

https://github.com/RjAbhishek185

LinkedIn

https://www.linkedin.com/in/abhishek-raj-1589a62a1/

🚀 Conclusion

The CityReads Data Engineering Capstone Project demonstrates an end-to-end Data Engineering workflow using the Medallion Architecture.

The project successfully implements:

Incremental Bronze Ingestion → Silver Data Quality Processing → Gold Business KPIs → Automated Pipeline Health Audit

The Bronze layer provides incremental ingestion and watermark tracking.

The Silver layer performs data cleaning, validation, standardization and rejected-record handling.

The Gold layer provides five business KPIs for executive-level analysis.

The final pipeline audit automatically compares KPI results against predefined business targets.

The final audit shows that 2 out of 5 KPIs passed, while Monthly Revenue Growth, Library Return Compliance, and Review Coverage Rate require further improvement.

This project demonstrates practical knowledge of modern Data Engineering concepts including data ingestion, transformation, quality validation, SQL analytics, KPI development, monitoring and pipeline auditing.

<div align="center">
⭐ Thank You for Visiting the CityReads Data Engineering Capstone Project!

Celebal Technologies Summer Internship 2026

</div>
