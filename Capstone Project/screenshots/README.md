# 📸 CityReads Project Screenshots

This folder contains execution screenshots and validation evidence for all major phases of the **CityReads Data Engineering Capstone Project**.

---

# 📁 Screenshot Structure

```text
screenshots/
│
├── 📁 phase1/
│   └── Project & Dataset Setup
│
├── 📁 phase2/
│   └── MySQL Database Setup
│
├── 📁 phase3/
│   └── Source Data Loading & Validation
│
├── 📁 phase4_bronze/
│   ├── Incremental Ingestion
│   └── Watermark Validation
│
├── 📁 phase5_silver/
│   ├── Silver Transformation
│   └── Rejected Records
│
├── 📁 phase6_gold/
│   ├── Gold Layer
│   └── Business KPI Results
│
└── 📁 phase7_audit/
    ├── KPI Health Audit
    └── Final Pipeline Health
🔄 Project Execution Flow
# Phase 1
Project & Dataset Setup
        ↓
# Phase 2
MySQL Database Setup
        ↓
# Phase 3
Source Data Loading
        ↓
# Phase 4
🥉 Bronze Layer
        ↓
# Phase 5
🥈 Silver Layer
        ↓
# Phase 6
🥇 Gold Layer
        ↓
# Phase 7
🔍 Pipeline Health Audit
📸 Phase 1 — Project & Dataset Setup

Screenshots demonstrate:

Project initialization
Dataset availability
Source data preparation
Initial project structure
🗄️ Phase 2 — MySQL Database Setup

Screenshots demonstrate:

MySQL Workbench configuration
Database creation
cityreads database
Table creation
Database schema validation
📥 Phase 3 — Source Data Loading

Screenshots demonstrate:

Source CSV loading
Table creation
Data insertion
Source row-count validation
Bronze source metadata
📊 Source Record Counts
Dataset	Records
Books	190
Customers	2,800
Orders	28,336
Loans	9,614
Reviews	5,621
Total	46,561
🥉 Phase 4 — Bronze Layer

Screenshots demonstrate:

Bronze directory creation
Incremental ingestion
Bronze CSV files
Watermark creation
Watermark state
Duplicate-ingestion prevention
MySQL Bronze synchronization
📊 Bronze Results
Dataset	Bronze Rows
Books	190
Customers	2,800
Orders	28,336
Loans	9,614
Reviews	5,621
Total	46,561
🔄 Incremental Ingestion Validation

A subsequent execution confirmed that previously processed records were not ingested again.

Books       : 0 new rows
Customers   : 0 new rows
Orders      : 0 new rows
Loans       : 0 new rows
Reviews     : 0 new rows

Total       : 0 new rows
🥈 Phase 5 — Silver Layer

Screenshots demonstrate:

Silver transformation
Data cleaning
Data validation
Duplicate handling
Foreign-key validation
Invalid-value detection
Silver record counts
Rejected-record processing
Silver-to-MySQL synchronization
📊 Silver Results
Dataset	Bronze Rows	Silver Rows
Books	190	190
Customers	2,800	2,766
Orders	28,336	27,354
Loans	9,614	9,402
Reviews	5,621	5,454
Total	46,561	45,166
❌ Rejected Records
Total Rejected Records : 1,395

Rejected records are stored in:

data/silver/rejected/silver_rejected_rows.csv
📋 Rejection Summary
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
🥇 Phase 6 — Gold Layer

Screenshots demonstrate:

Gold-layer KPI creation
SQL views
KPI calculations
Business analytics
KPI result validation
Top-book analysis
Customer segmentation
📊 Gold Views

The Gold layer contains the following business views:

gold_kpi_revenue_growth
gold_kpi_retention_rate
gold_kpi_sell_through
gold_kpi_return_compliance
gold_kpi_review_coverage
gold_top_books
gold_customer_segments
📈 Gold KPI Results
KPI	Actual	Target	Status
Monthly Revenue Growth	-74.32%	10.00%	❌ FAIL
Customer Retention Rate	47.31%	40.00%	✅ PASS
Book Sell-Through Rate	100.00%	50.00%	✅ PASS
Library Return Compliance	60.01%	80.00%	❌ FAIL
Review Coverage Rate	63.04%	80.00%	❌ FAIL
🔍 Phase 7 — Pipeline Health Audit

Screenshots demonstrate:

KPI-level validation
Actual vs target comparison
PASS/FAIL status
Bronze validation
Silver validation
Rejected-record validation
Gold KPI validation
Overall pipeline health
Final audit results
📊 Final Pipeline Health
Metric	Result
Total KPIs	5
Passed KPIs	2
Failed KPIs	3
Overall Status	FAIL
🔎 Final Audit Results
Layer	Check Name	Actual Value	Target Value	Status
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
📋 Final KPI Status
KPI	Actual	Target	Status
📈 Monthly Revenue Growth	-74.32%	10.00%	❌ FAIL
👥 Customer Retention Rate	47.31%	40.00%	✅ PASS
📚 Book Sell-Through Rate	100.00%	50.00%	✅ PASS
📖 Library Return Compliance	60.01%	80.00%	❌ FAIL
⭐ Review Coverage Rate	63.04%	80.00%	❌ FAIL

The final audit shows that 2 out of 5 KPIs passed, while 3 KPIs require improvement.

The failed KPIs are intentionally retained to demonstrate real business exception detection and automated KPI monitoring.

🎯 Purpose

These screenshots provide visual execution evidence for the complete CityReads Data Engineering pipeline.

Source Data
    ↓
🥉 Bronze Layer
    ↓
🥈 Silver Layer
    ↓
🥇 Gold Layer
    ↓
🔍 Pipeline Health Audit

They document the implementation, execution, validation, and final results of the CityReads Data Engineering Capstone Project.

🎓 Celebal Technologies Summer Internship 2026
CityReads — Data Engineering Capstone Project

Built with Python • Pandas • MySQL • SQL • Medallion Architecture
