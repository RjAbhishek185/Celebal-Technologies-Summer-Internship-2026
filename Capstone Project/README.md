# 📚 CityReads — Data Engineering Capstone Project

### Celebal Technologies Summer Internship 2026

> An end-to-end Data Engineering pipeline implementing Medallion Architecture, incremental ingestion, data-quality validation, business KPIs, and automated pipeline auditing.

---

## 📌 Table of Contents

- [Overview](#-overview)
- [Objectives](#-objectives)
- [Architecture](#-architecture)
- [Dataset](#-dataset)
- [Bronze Layer](#-bronze-layer)
- [Silver Layer](#-silver-layer)
- [Gold Layer](#-gold-layer)
- [Pipeline Health Audit](#-pipeline-health-audit)
- [Final Results](#-final-results)
- [Project Structure](#-project-structure)
- [Technologies Used](#-technologies-used)
- [Execution Evidence](#-execution-evidence)
- [How to Run](#-how-to-run)
- [Internship Details](#-internship-details)
- [Author](#-author)
- [Conclusion](#-conclusion)

---

# 📖 Overview

CityReads is an end-to-end Data Engineering Capstone Project developed as part of the Celebal Technologies Summer Internship 2026.

The project implements a three-layer Medallion Architecture:

Source CSV → Bronze → Silver → Gold → Pipeline Audit

The pipeline processes five datasets:

| Dataset | Description |
|---|---|
| 📚 Books | Book inventory and catalog information |
| 👥 Customers | Customer and membership information |
| 🛒 Orders | Book purchase transactions |
| 📖 Loans | Library borrowing and return information |
| ⭐ Reviews | Customer book reviews |

The project demonstrates:

- Incremental data ingestion
- Watermark-based processing
- Data cleaning and validation
- Rejected-record handling
- SQL analytics
- Business KPI generation
- KPI target validation
- Pipeline health auditing

---

# 🎯 Objectives

The main objectives of the project are:

1. Implement incremental data ingestion.
2. Build a raw Bronze data layer.
3. Maintain dataset-specific watermarks.
4. Build a cleaned and validated Silver layer.
5. Detect invalid records and store them separately.
6. Build business-ready Gold KPI views.
7. Compare KPIs against predefined targets.
8. Implement automated pipeline health auditing.
9. Maintain an organized and reproducible project structure.

---

# 🏗️ Architecture

The project follows the Medallion Architecture.

```text
                         CITYREADS SOURCE DATA
                                  │
                                  ▼
                        ┌──────────────────┐
                        │    SOURCE CSVs   │
                        │                  │
                        │ Books            │
                        │ Customers        │
                        │ Orders           │
                        │ Loans            │
                        │ Reviews          │
                        └────────┬─────────┘
                                 │
                                 ▼
                    ┌─────────────────────────┐
                    │      🥉 BRONZE          │
                    │                         │
                    │ Incremental Ingestion   │
                    │ Watermark Processing    │
                    │ Raw Data Preservation   │
                    └────────────┬────────────┘
                                 │
                                 ▼
                    ┌─────────────────────────┐
                    │      🥈 SILVER          │
                    │                         │
                    │ Data Cleaning           │
                    │ Validation              │
                    │ Standardization         │
                    │ Rejected Records        │
                    └────────────┬────────────┘
                                 │
                                 ▼
                    ┌─────────────────────────┐
                    │       🥇 GOLD           │
                    │                         │
                    │ Business KPIs           │
                    │ SQL Views               │
                    │ Analytics               │
                    └────────────┬────────────┘
                                 │
                                 ▼
                    ┌─────────────────────────┐
                    │    🔍 PIPELINE AUDIT    │
                    │                         │
                    │ KPI Validation          │
                    │ PASS / FAIL             │
                    │ Pipeline Health         │
                    └─────────────────────────┘
📊 Dataset

The project uses five source CSV datasets.

Dataset	Source Records
📚 Books	190
👥 Customers	2,800
🛒 Orders	28,336
📖 Loans	9,614
⭐ Reviews	5,621
Total	46,561
Source Files
data/
└── cityreads_dataset/
    ├── books.csv
    ├── customers.csv
    ├── orders.csv
    ├── loans.csv
    └── reviews.csv
🥉 Bronze Layer
Purpose

The Bronze layer performs incremental ingestion of the source CSV files.

The layer preserves source information while maintaining ingestion state using watermarks.

Bronze Responsibilities
Raw data ingestion
Incremental processing
Watermark tracking
Batch identification
Duplicate ingestion prevention
Ingestion metadata
Bronze Output
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
Bronze Ingestion Results
Dataset	Source Rows	Bronze Rows
Books	190	190
Customers	2,800	2,800
Orders	28,336	28,336
Loans	9,614	9,614
Reviews	5,621	5,621
Total	46,561	46,561
Incremental Processing Validation

A subsequent Bronze execution produced:

Books       → 0 new rows
Customers   → 0 new rows
Orders      → 0 new rows
Loans       → 0 new rows
Reviews     → 0 new rows

Total new rows → 0

This confirms that already processed records were not ingested again.

🥈 Silver Layer
Purpose

The Silver layer transforms raw Bronze data into cleaned, validated, and analysis-ready datasets.

Silver Processing

The pipeline performs:

Data validation
Data cleaning
Standardization
Date validation
Numeric validation
Business-rule validation
Duplicate detection
Rejected-record handling
Derived-column generation
Silver Results
Dataset	Bronze Rows	Silver Rows
Books	190	190
Customers	2,800	2,766
Orders	28,336	27,354
Loans	9,614	9,402
Reviews	5,621	5,454
Total	46,561	45,166
Rejected Records

Total rejected records: 1,395

Rejected records are stored in:

data/silver/rejected/silver_rejected_rows.csv
Rejection Summary
Table	Rejection Reason	Count
Customers	INVALID_MEMBERSHIP	12
Customers	NULL_EMAIL	22
Loans	INVALID_CUSTOMER_FK	136
Loans	INVALID_DUE_DATE	76
Orders	INVALID_BOOK_FK	161
Orders	INVALID_CUSTOMER_FK	320
Orders	INVALID_QUANTITY	145
Orders	INVALID_STATUS	356
Reviews	INVALID_CUSTOMER_FK	68
Reviews	INVALID_RATING	99
Total		1,395

Each rejected record contains audit information such as:

Source table
Source ID
Rejection reason
Rejection timestamp
🥇 Gold Layer
Purpose

The Gold layer contains business-ready SQL views created from the validated Silver data.

The project implements five business KPIs:

#	KPI
1	📈 Monthly Revenue Growth
2	👥 Customer Retention Rate
3	📚 Book Sell-Through Rate
4	📖 Library Return Compliance
5	⭐ Review Coverage Rate
Gold Views
gold_kpi_revenue_growth
gold_kpi_retention_rate
gold_kpi_sell_through
gold_kpi_return_compliance
gold_kpi_review_coverage
gold_top_books
gold_customer_segments
📈 KPI Results
KPI	Actual	Target	Status
Monthly Revenue Growth	-74.32%	10.00%	❌ FAIL
Customer Retention Rate	47.31%	40.00%	✅ PASS
Book Sell-Through Rate	100.00%	50.00%	✅ PASS
Library Return Compliance	60.01%	80.00%	❌ FAIL
Review Coverage Rate	63.04%	80.00%	❌ FAIL
🔍 Pipeline Health Audit

The project includes an automated SQL-based pipeline health audit.

The audit compares actual KPI values against predefined business targets and validates Bronze and Silver layer record counts.

Final Pipeline Validation
Layer	Check	Actual	Target	Status
BRONZE	Raw source ingestion	0.00	0.00	PASS
SILVER	Rejected rows	1,395.00	0.00	INFO
SILVER	Books silver rows	190.00	190.00	PASS
SILVER	Customers silver rows	2,766.00	2,800.00	PASS
SILVER	Orders silver rows	27,354.00	28,336.00	PASS
SILVER	Loans silver rows	9,402.00	9,614.00	PASS
SILVER	Reviews silver rows	5,454.00	5,621.00	PASS
GOLD	Monthly Revenue Growth	-74.32	10.00	FAIL
GOLD	Customer Retention Rate	47.31	40.00	PASS
GOLD	Book Sell-Through Rate	100.00	50.00	PASS
GOLD	Library Return Compliance	60.01	80.00	FAIL
GOLD	Review Coverage Rate	63.04	80.00	FAIL
Overall KPI Status
Metric	Result
Total KPIs	5
Passed KPIs	2
Failed KPIs	3
Overall Status	FAIL

The failed KPIs are intentionally retained to demonstrate real KPI monitoring and exception detection.

📋 Final Results
Bronze Layer
Dataset	Rows
Books	190
Customers	2,800
Orders	28,336
Loans	9,614
Reviews	5,621
Silver Layer
Dataset	Rows
Books	190
Customers	2,766
Orders	27,354
Loans	9,402
Reviews	5,454
Rejected Records	1,395
Gold Layer
KPI	Actual	Target	Status
Revenue Growth	-74.32%	10.00%	❌ FAIL
Customer Retention	47.31%	40.00%	✅ PASS
Book Sell-Through	100.00%	50.00%	✅ PASS
Return Compliance	60.01%	80.00%	❌ FAIL
Review Coverage	63.04%	80.00%	❌ FAIL
🗂️ Project Structure
Capstone Project/
│
├── data/
│   ├── cityreads_dataset/
│   │   ├── books.csv
│   │   ├── customers.csv
│   │   ├── orders.csv
│   │   ├── loans.csv
│   │   └── reviews.csv
│   │
│   ├── bronze/
│   │   ├── books/
│   │   ├── customers/
│   │   ├── orders/
│   │   ├── loans/
│   │   ├── reviews/
│   │   └── watermark.json
│   │
│   └── silver/
│       ├── books/
│       ├── customers/
│       ├── orders/
│       ├── loans/
│       ├── reviews/
│       └── rejected/
│
├── scripts/
│   ├── bronze_ingestion.py
│   ├── silver_transform.py
│   └── README.md
│
├── sql/
│   ├── cityreads_capstone.sql
│   ├── gold_kpis.sql
│   └── pipeline_health_audit.sql
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
├── Dataset_generator.py
├── requirements.txt
├── .gitignore
└── README.md
📸 Execution Evidence

Screenshots are organized according to the different project phases.

screenshots/
│
├── phase1/
├── phase2/
├── phase3/
├── phase4_bronze/
├── phase5_silver/
├── phase6_gold/
└── phase7_audit/

The screenshots provide evidence for:

Database setup
Source data loading
Bronze ingestion
Watermark processing
Silver transformation
Data-quality rejection
Gold KPI generation
Top-book analysis
Customer segmentation
Pipeline health validation
Final audit

🛠️ Technologies Used
Technology	Purpose
Python	Data ingestion and transformation
Pandas	Data processing
MySQL	Data storage and SQL analytics
MySQL Workbench	Database development and validation
CSV	Source and layer storage
Medallion Architecture	Data-layer organization
Watermark Processing	Incremental ingestion
SQL	Analytics and KPI generation
Window Functions	Advanced SQL analytics
CTEs	Query organization
SQL Views	Gold and audit layers
Git & GitHub	Version control

💡 Key Concepts Demonstrated
Data Engineering
ETL/ELT
Medallion Architecture
Incremental ingestion
Watermark-based processing
Data cleaning
Data validation
Data-quality checks
Deduplication
Rejected-record handling
SQL analytics
Window functions
Common Table Expressions
SQL Views
Business KPI development
Pipeline monitoring
PASS/FAIL validation
Audit reporting
Git and GitHub

📁 Important Files
Dataset Generator
Dataset_generator.py

Generates the CityReads source datasets.

Bronze Ingestion
scripts/bronze_ingestion.py

Implements incremental Bronze ingestion and watermark processing.

Silver Transformation
scripts/silver_transform.py

Performs Silver-layer cleaning, validation, and rejected-record handling.

Main SQL
sql/cityreads_capstone.sql

Contains the main CityReads SQL implementation.

Gold KPI SQL
sql/gold_kpis.sql

Contains the Gold-layer business KPI views.

Pipeline Audit SQL
sql/pipeline_health_audit.sql

Contains pipeline health and KPI validation logic.

▶️ How to Run
1. Install Dependencies
pip install -r requirements.txt
2. Generate or Prepare Source Data
python Dataset_generator.py
3. Run Bronze Ingestion
python scripts/bronze_ingestion.py

Enter the MySQL root password when prompted.

4. Run Silver Transformation
python scripts/silver_transform.py
5. Execute Gold SQL

Open the Gold SQL script in MySQL Workbench:

sql/gold_kpis.sql

Execute the script after selecting the cityreads database.

6. Run Pipeline Audit

Open the pipeline audit script:

sql/pipeline_health_audit.sql

Execute the script in MySQL Workbench.

🎓 Internship Details
Field	Information
Organization	Celebal Technologies
Role	Data Engineering Intern
Program	Celebal Technologies Summer Internship 2026
Project	CityReads Data Engineering Capstone Project

👨‍💻 Author
Abhishek Raj

Computer Science Engineering student interested in:

Data Engineering
Software Development
Cloud Technologies
Artificial Intelligence
GitHub

https://github.com/RjAbhishek185

LinkedIn

https://www.linkedin.com/in/abhishek-raj-1589a62a1/

# 🚀 Conclusion

CityReads demonstrates a complete Data Engineering pipeline built using the Medallion Architecture.

The pipeline follows:

Source Data
↓
Bronze Layer
↓
Silver Layer
↓
Gold Layer
↓
Pipeline Health Audit

## Key Achievements

- Incremental data ingestion
- Watermark-based processing
- Data cleaning and validation
- Rejected-record handling
- SQL analytics
- Business KPI generation
- Automated KPI validation
- Pipeline health auditing

## Final KPI Status

| KPI | Status |
|---|---|
| Monthly Revenue Growth | ❌ FAIL |
| Customer Retention Rate | ✅ PASS |
| Book Sell-Through Rate | ✅ PASS |
| Library Return Compliance | ❌ FAIL |
| Review Coverage Rate | ❌ FAIL |

**2 out of 5 KPIs passed, while 3 KPIs require improvement.**

The failed KPIs are intentionally retained to demonstrate real business exception detection and automated pipeline monitoring.

---

## ⭐ CityReads

**Data Engineering Capstone Project**

Celebal Technologies Summer Internship 2026

Built with Python, Pandas, MySQL, SQL, and Medallion Architecture.

### 👨‍💻 Abhishek Raj

GitHub: https://github.com/RjAbhishek185

LinkedIn: https://www.linkedin.com/in/abhishek-raj-1589a62a1/
