# 📚 CityReads — Data Engineering Capstone Project

### Celebal Technologies Summer Internship 2026

> An end-to-end Data Engineering pipeline implementing **Medallion Architecture**, incremental ingestion, data-quality validation, business KPIs, and automated pipeline auditing.

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
- [Key Concepts](#-key-concepts)
- [Execution Evidence](#-execution-evidence)
- [Important Files](#-important-files)
- [Internship Details](#-internship-details)
- [Author](#-author)
- [Conclusion](#-conclusion)

---

# 📖 Overview

**CityReads** is an end-to-end Data Engineering Capstone Project developed as part of the **Celebal Technologies Summer Internship 2026**.

The project processes library and bookstore data through a three-layer **Medallion Architecture**:

**Source CSV → Bronze → Silver → Gold → Pipeline Audit**

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
- SQL-based analytics
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

The project follows the **Medallion Architecture**.

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
Source Location
data/cityreads_dataset/
books.csv
customers.csv
orders.csv
loans.csv
reviews.csv
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

A second Bronze execution produced:

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
Dataset	Bronze Rows	Silver Rows	Rejected
Books	190	190	0
Customers	2,800	2,766	34
Orders	28,336	27,354	982
Loans	9,614	9,402	212
Reviews	5,621	5,454	167
Total	46,561	45,166	1,395
Rejected Records
Total rejected records: 1,395

Rejected records are stored in:

data/silver/rejected/silver_rejected_rows.csv

Each rejected record contains audit information such as:

Source table
Source ID
Rejection reason
Rejection timestamp

This provides traceability for data-quality failures.

🥇 Gold Layer
Purpose

The Gold layer contains business-ready SQL views created from the validated Silver data.

Five business KPIs were implemented:

#	KPI
1	📈 Monthly Revenue Growth
2	👥 Customer Retention Rate
3	📚 Book Sell-Through Rate
4	📖 Library Return Compliance
5	⭐ Review Coverage Rate

Gold SQL implementation:

sql/gold/gold_kpis.sql
📈 KPI Results
KPI Summary
KPI	Actual	Target	Status
Monthly Revenue Growth	-74.32%	10.00%	❌ FAIL
Customer Retention Rate	47.31%	40.00%	✅ PASS
Book Sell-Through Rate	100.00%	50.00%	✅ PASS
Library Return Compliance	60.01%	80.00%	❌ FAIL
Review Coverage Rate	63.04%	80.00%	❌ FAIL
📈 1. Monthly Revenue Growth

Actual: -74.32%

Target: 10.00%

Status: ❌ FAIL

The current dataset indicates a negative average monthly revenue growth rate, which is below the defined business target.

👥 2. Customer Retention Rate

Actual: 47.31%

Target: 40.00%

Status: ✅ PASS

Customer retention exceeds the defined target.

📚 3. Book Sell-Through Rate

Actual: 100.00%

Target: 50.00%

Status: ✅ PASS

The sell-through KPI meets the defined business target.

📖 4. Library Return Compliance

Actual: 60.01%

Target: 80.00%

Status: ❌ FAIL

Return compliance is below the defined target and represents an area requiring improvement.

⭐ 5. Review Coverage Rate

Actual: 63.04%

Target: 80.00%

Status: ❌ FAIL

Review coverage is below the defined target.

🔍 Pipeline Health Audit

The project includes an automated SQL-based pipeline health audit.

The audit compares actual KPI values against predefined business targets.

Audit SQL
sql/audit/pipeline_health_audit.sql
Audit Results
KPI	Actual	Target	Result
Monthly Revenue Growth	-74.32%	10.00%	❌ FAIL
Customer Retention Rate	47.31%	40.00%	✅ PASS
Book Sell-Through Rate	100.00%	50.00%	✅ PASS
Library Return Compliance	60.01%	80.00%	❌ FAIL
Review Coverage Rate	63.04%	80.00%	❌ FAIL
📋 Overall Pipeline Health
Metric	Result
Total KPIs	5
Passed KPIs	2
Failed KPIs	3
Overall Status	FAIL
Interpretation

The overall pipeline health is marked FAIL because three KPIs are below their defined business targets:

Monthly Revenue Growth
Library Return Compliance
Review Coverage Rate

The failed KPIs are intentionally retained to demonstrate real KPI monitoring and exception detection rather than artificially changing the results.

🔎 Final Pipeline Audit

The final audit validates the complete pipeline from Bronze through Gold.

Validation Areas
✅ Bronze ingestion
✅ Silver record counts
✅ Rejected records
✅ Gold KPI values
✅ KPI targets
✅ PASS/FAIL status
Final Silver Validation
Dataset	Validated Rows
Books	190
Customers	2,766
Orders	27,354
Loans	9,402
Reviews	5,454
Rejected Records	1,395
Final Gold Validation
KPI	Status
Revenue Growth	❌
Customer Retention	✅
Book Sell-Through	✅
Return Compliance	❌
Review Coverage	❌
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
│   ├── gold/
│   │   └── gold_kpis.sql
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
├── requirements.txt
│
├── .gitignore
│
└── README.md
📸 Execution Evidence

Execution screenshots are organized by project phase:

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
🐍 Python	Data ingestion and transformation
🐼 Pandas	Data processing
🐬 MySQL	Data storage and SQL analytics
🛠️ MySQL Workbench	Database development and validation
📄 CSV	Source and layer storage
🏗️ Medallion Architecture	Data-layer organization
🔄 Watermark Processing	Incremental ingestion
📊 SQL	Analytics and KPI generation
🪟 Window Functions	Advanced SQL analytics
🔗 CTEs	Query organization
👁️ SQL Views	Gold and audit layers
🌐 Git & GitHub	Version control
💡 Key Concepts Demonstrated

This project demonstrates practical knowledge of:

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
📁 Important Project Files
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
sql/gold/gold_kpis.sql

Contains the Gold-layer business KPI views.

Pipeline Audit SQL
sql/audit/pipeline_health_audit.sql

Contains pipeline health and KPI validation logic.

▶️ How to Run
1. Clone the Repository
git clone https://github.com/RjAbhishek185/Celebal-Technologies-Summer-Internship-2026.git
cd Capstone\ Project
2. Install Dependencies
pip install -r requirements.txt
3. Generate / Prepare Source Data
python Dataset_generator.py
4. Run Bronze Ingestion
python scripts/bronze_ingestion.py

Enter the MySQL root password when prompted.

5. Run Silver Transformation
python scripts/silver_transform.py
6. Execute Gold SQL

Open:

sql/gold/gold_kpis.sql

Execute the SQL in MySQL Workbench.

7. Run Pipeline Audit

Open:

sql/audit/pipeline_health_audit.sql

Execute the audit queries in MySQL Workbench.

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

🚀 Conclusion

The CityReads Data Engineering Capstone Project demonstrates an end-to-end Data Engineering workflow using the Medallion Architecture.

The complete pipeline follows:

Source CSV
    ↓
🥉 Bronze Ingestion
    ↓
🥈 Silver Data Quality Processing
    ↓
🥇 Gold Business KPIs
    ↓
🔍 Pipeline Health Audit

The project successfully demonstrates:

Incremental data ingestion
Watermark-based processing
Data cleaning and validation
Rejected-record handling
SQL analytics
Business KPI generation
Automated KPI validation
Pipeline health auditing

The final audit shows:

2 out of 5 KPIs passed and 3 KPIs require improvement.

This demonstrates that the pipeline is capable of identifying real business exceptions rather than simply producing successful-looking results.

<div align="center">
⭐ CityReads Data Engineering Capstone Project
Celebal Technologies Summer Internship 2026

Built with Python • Pandas • MySQL • SQL • Medallion Architecture

</div> ```
