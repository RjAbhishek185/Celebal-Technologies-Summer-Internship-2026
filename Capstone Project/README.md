# 📚 CityReads — Data Engineering Capstone Project

### Celebal Technologies Summer Internship 2026

> An end-to-end Data Engineering pipeline implementing **Medallion Architecture, incremental ingestion, data-quality validation, business KPIs, and pipeline health auditing**.

## 📌 Overview

CityReads is a Data Engineering Capstone Project developed as part of the Celebal Technologies Summer Internship 2026.

The project follows:

```text
Source CSV → Bronze → Silver → Gold → Pipeline Audit
```

The pipeline processes five datasets:

* 📚 Books
* 👥 Customers
* 🛒 Orders
* 📖 Loans
* ⭐ Reviews

## 🎯 Key Objectives

* Incremental data ingestion
* Watermark-based processing
* Bronze and Silver layer implementation
* Data cleaning and validation
* Rejected-record handling
* Gold-layer business KPIs
* KPI target validation
* Pipeline health auditing

## 📊 Dataset

| Dataset   |    Records |
| --------- | ---------: |
| Books     |        190 |
| Customers |      2,800 |
| Orders    |     28,336 |
| Loans     |      9,614 |
| Reviews   |      5,621 |
| **Total** | **46,561** |

## 🥉 Bronze Layer

The Bronze layer performs incremental ingestion using **watermark-based processing**.

### Features

* Raw data ingestion
* Incremental processing
* Watermark tracking
* Batch identification
* Duplicate-ingestion prevention
* Ingestion metadata

A second execution produced **0 new rows** across all five datasets, confirming that previously processed records were not ingested again.

## 🥈 Silver Layer

The Silver layer cleans and validates Bronze data.

### Processing

* Data validation
* Data cleaning
* Standardization
* Date and numeric validation
* Business-rule validation
* Duplicate detection
* Rejected-record handling

### Results

| Dataset   |     Bronze |     Silver |
| --------- | ---------: | ---------: |
| Books     |        190 |        190 |
| Customers |      2,800 |      2,766 |
| Orders    |     28,336 |     27,354 |
| Loans     |      9,614 |      9,402 |
| Reviews   |      5,621 |      5,454 |
| **Total** | **46,561** | **45,166** |

**Rejected Records: 1,395**

Rejected records are stored separately with source information, rejection reason, and timestamp.

## 🥇 Gold Layer

The Gold layer contains business-ready analytics and KPI calculations.

### KPIs

1. 📈 Monthly Revenue Growth
2. 👥 Customer Retention Rate
3. 📚 Book Sell-Through Rate
4. 📖 Library Return Compliance
5. ⭐ Review Coverage Rate

### KPI Results

| KPI                |  Actual | Target | Status |
| ------------------ | ------: | -----: | ------ |
| Revenue Growth     | -74.32% | 10.00% | ❌ FAIL |
| Customer Retention |  47.31% | 40.00% | ✅ PASS |
| Book Sell-Through  | 100.00% | 50.00% | ✅ PASS |
| Return Compliance  |  60.01% | 80.00% | ❌ FAIL |
| Review Coverage    |  63.04% | 80.00% | ❌ FAIL |

The failed KPIs are intentionally retained to demonstrate **real business exception detection**.

## 🔍 Pipeline Health Audit

The final audit validates:

* Bronze ingestion
* Silver record counts
* Rejected records
* Gold KPI values
* KPI targets
* PASS/FAIL status
* Overall pipeline health

```text
Total KPIs   : 5
Passed KPIs  : 2
Failed KPIs  : 3
Overall      : FAIL
```

The `FAIL` status represents KPIs that are below their business targets and does not necessarily indicate a technical pipeline failure.

## 🗂️ Project Structure

```text
Capstone Project/
│
├── data/
│   ├── cityreads_dataset/
│   ├── bronze/
│   └── silver/
│
├── scripts/
│   ├── bronze_ingestion.py
│   ├── silver_transform.py
│   └── README.md
│
├── sql/
│   ├── cityreads_capstone.sql
│   └── final_pipeline_audit.sql
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
├── Dataset_generator.py
└── README.md
```

## 🛠️ Technologies

**Python • Pandas • MySQL • MySQL Workbench • SQL • CSV • Git & GitHub**

### Key Concepts

**ETL/ELT • Medallion Architecture • Incremental Ingestion • Watermarks • Data Validation • Deduplication • Data Quality • SQL Analytics • CTEs • Window Functions • SQL Views • KPI Monitoring • Pipeline Auditing**

## ▶️ How to Run

### 1. Install dependencies

```bash
pip install -r requirements.txt
```

### 2. Generate source data

```bash
python Dataset_generator.py
```

### 3. Run Bronze ingestion

```bash
python scripts/bronze_ingestion.py
```

### 4. Run Silver transformation

```bash
python scripts/silver_transform.py
```

### 5. Execute SQL

Run the following scripts in **MySQL Workbench**:

```text
sql/cityreads_capstone.sql
sql/final_pipeline_audit.sql
```

`final_pipeline_audit.sql` contains the **Gold KPI calculations and final pipeline health audit**.

## 📸 Execution Evidence

Screenshots are organized by project phase and provide evidence of:

* Database setup
* Data loading
* Bronze ingestion
* Watermark processing
* Silver transformation
* Data-quality rejection
* Gold KPI generation
* Analytics
* Pipeline health audit

## 🎓 Internship Details

| Field        | Information                                 |
| ------------ | ------------------------------------------- |
| Organization | Celebal Technologies                        |
| Role         | Data Engineering Intern                     |
| Program      | Celebal Technologies Summer Internship 2026 |
| Project      | CityReads Data Engineering Capstone Project |

## 👨‍💻 Author

**Abhishek Raj**

Computer Science Engineering Student

**GitHub:** https://github.com/RjAbhishek185

**LinkedIn:** https://www.linkedin.com/in/abhishek-raj-1589a62a1/

## 🚀 Conclusion

CityReads demonstrates a complete local Data Engineering workflow:

```text
Source Data
    ↓
Bronze — Incremental Ingestion
    ↓
Silver — Cleaning & Validation
    ↓
Gold — Business Analytics
    ↓
Audit — KPI & Pipeline Validation
```

The project demonstrates practical Data Engineering concepts including **incremental processing, data quality, SQL analytics, KPI monitoring, and transparent pipeline auditing**.

**Final Result: 2/5 KPIs passed and 3/5 require improvement.**
