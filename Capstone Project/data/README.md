# 📊 CityReads Data

This folder contains all datasets and data-layer outputs used in the **CityReads Data Engineering Capstone Project**.

The data follows the **Medallion Architecture**:

Source Data
    ↓
Bronze Layer
    ↓
Silver Layer
    ↓
Gold Layer
    ↓
Business Insights

---

## 📁 Data Structure

```text
data/
│
├── cityreads_dataset/
│   ├── books.csv
│   ├── customers.csv
│   ├── orders.csv
│   ├── loans.csv
│   └── reviews.csv
│
├── bronze/
│   ├── books/
│   ├── customers/
│   ├── loans/
│   ├── orders/
│   ├── reviews/
│   └── watermark.json
│
├── silver/
│   ├── books/
│   ├── customers/
│   ├── loans/
│   ├── orders/
│   ├── reviews/
│   └── rejected/
│
└── gold/
📚 Source Dataset

The cityreads_dataset/ directory contains the original source CSV files used by the pipeline.

Dataset	Records
Books	190
Customers	2,800
Orders	28,336
Loans	9,614
Reviews	5,621
Total	46,561
Source Files
books.csv — Book information
customers.csv — Customer information
orders.csv — Order transaction data
loans.csv — Library loan information
reviews.csv — Book reviews and ratings
🥉 Bronze Layer

The bronze/ directory contains incrementally ingested source data.

The Bronze layer handles:

Incremental ingestion
Source-data preservation
Watermark-based processing
Duplicate-ingestion prevention
Ingestion tracking
Bronze Structure
bronze/
├── books/
├── customers/
├── loans/
├── orders/
├── reviews/
└── watermark.json
Watermark State
Books       : 190
Customers   : 2,800
Orders      : 28,336
Loans       : 9,614
Reviews     : 5,621

A subsequent Bronze ingestion execution detected:

Total new rows : 0

This confirms that previously processed records were not ingested again.

🥈 Silver Layer

The silver/ directory contains cleaned and validated data produced from the Bronze layer.

The Silver layer performs:

Data validation
Duplicate detection
Data cleaning
Standardization
Date validation
Numeric validation
Business-rule validation
Rejected-record handling
Silver Results
Dataset	Bronze Records	Silver Records
Books	190	190
Customers	2,800	2,766
Orders	28,336	27,354
Loans	9,614	9,402
Reviews	5,621	5,454
Total	46,561	45,166
Rejected Records

A total of 1,395 records were rejected during Silver-layer validation.

Rejected records are stored in:

silver/rejected/silver_rejected_rows.csv

The rejected records are retained for auditing and traceability rather than being silently discarded.

🥇 Gold Layer

The gold/ directory represents the business-ready stage of the pipeline.

Gold-layer outputs are generated from validated Silver data and are used for business KPI analysis.

The project implements five KPIs:

Monthly Revenue Growth
Customer Retention Rate
Book Sell-Through Rate
Library Return Compliance
Review Coverage Rate
KPI Summary
KPI	Actual	Target	Status
Monthly Revenue Growth	-74.32%	10.00%	❌ FAIL
Customer Retention Rate	47.31%	40.00%	✅ PASS
Book Sell-Through Rate	100.00%	50.00%	✅ PASS
Library Return Compliance	60.01%	80.00%	❌ FAIL
Review Coverage Rate	63.04%	80.00%	❌ FAIL
🔄 Complete Data Flow
cityreads_dataset/
       │
       ▼
   BRONZE
       │
       │ Incremental Ingestion
       │ + Watermark
       ▼
   SILVER
       │
       │ Cleaning
       │ Validation
       │ Deduplication
       │ Rejection Handling
       ▼
    GOLD
       │
       │ Business KPIs
       ▼
Pipeline Health Audit
📌 Purpose

The data/ directory provides a clear separation between:

Original source data
Raw ingested data
Cleaned and validated data
Business-ready data

This organization makes the CityReads pipeline easier to understand, maintain, test, and reproduce.

🔗 Related Project Components
Python Processing
../scripts/bronze_ingestion.py
../scripts/silver_transform.py
Gold SQL
../sql/gold/gold_kpis.sql
Pipeline Audit
../sql/audit/pipeline_health_audit.sql
🏗️ Architecture

The data/ directory represents the core data-processing portion of the CityReads project:

Source → Bronze → Silver → Gold → Business Insights

This structure follows the principles of the Medallion Architecture.
