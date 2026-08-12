
# 📸 CityReads Project Screenshots

This folder contains execution screenshots and validation evidence for all major phases of the **CityReads Data Engineering Capstone Project**.

## 📁 Screenshot Structure

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
````

## 🔄 Project Execution Flow

```text
Phase 1
Project & Dataset Setup
        ↓
Phase 2
Database Setup
        ↓
Phase 3
Source Data Loading
        ↓
Phase 4
🥉 Bronze Layer
        ↓
Phase 5
🥈 Silver Layer
        ↓
Phase 6
🥇 Gold Layer
        ↓
Phase 7
🔍 Pipeline Health Audit
```

## 📸 Phase 1 — Project & Dataset Setup

Screenshots demonstrate:

* Project initialization
* Dataset availability
* Source data preparation
* Initial project structure

## 🗄️ Phase 2 — MySQL Database Setup

Screenshots demonstrate:

* MySQL Workbench configuration
* Database creation
* `cityreads` database
* Table creation

## 📥 Phase 3 — Source Data Loading

Screenshots demonstrate:

* Source CSV loading
* Table creation
* Data insertion
* Source row-count validation

### Source Record Counts

| Dataset   | Records |
| --------- | ------: |
| Books     |     190 |
| Customers |   2,800 |
| Orders    |  28,336 |
| Loans     |   9,614 |
| Reviews   |   5,621 |

## 🥉 Phase 4 — Bronze Layer

Screenshots demonstrate:

* Bronze directory creation
* Incremental ingestion
* Bronze CSV files
* Watermark creation
* Watermark state
* Duplicate-ingestion prevention

### Incremental Ingestion Result

```text
Books       : 0 new rows
Customers   : 0 new rows
Orders      : 0 new rows
Loans       : 0 new rows
Reviews     : 0 new rows

Total       : 0 new rows
```

## 🥈 Phase 5 — Silver Layer

Screenshots demonstrate:

* Silver transformation
* Data validation
* Data cleaning
* Silver record counts
* Rejected-record processing

### Silver Results

| Dataset   | Bronze | Silver |
| --------- | -----: | -----: |
| Books     |    190 |    190 |
| Customers |  2,800 |  2,766 |
| Orders    | 28,336 | 27,835 |
| Loans     |  9,614 |  9,538 |
| Reviews   |  5,621 |  5,522 |

```text
Total Rejected Records : 710
```

Rejected records are stored in:

```text
data/silver/rejected/silver_rejected_rows.csv
```

## 🥇 Phase 6 — Gold Layer

Screenshots demonstrate:

* Gold-layer KPI creation
* SQL views
* KPI calculations
* Business analytics
* KPI result validation

### Gold KPIs

| KPI                       |   Actual | Target | Status |
| ------------------------- | -------: | -----: | ------ |
| Monthly Revenue Growth    |   68.30% | 10.00% | ✅ PASS |
| Customer Retention Rate   |   76.45% | 40.00% | ✅ PASS |
| Book Sell-Through Rate    | 8133.32% | 50.00% | ✅ PASS |
| Library Return Compliance |   74.18% | 80.00% | ❌ FAIL |
| Review Coverage Rate      |   81.58% | 80.00% | ✅ PASS |

## 🔍 Phase 7 — Pipeline Health Audit

Screenshots demonstrate:

* KPI-level validation
* Actual vs target comparison
* PASS/FAIL status
* Overall pipeline health
* Final audit results

### Final KPI Health

```text
Total KPIs  : 5
Passed KPIs : 4
Failed KPIs : 1
Overall     : FAIL
```

The overall status is **FAIL** because the **Library Return Compliance** KPI achieved **74.18%**, below the target of **80%**.

## 🎯 Purpose

These screenshots provide visual execution evidence for the complete CityReads pipeline:

```text
Source Data
    ↓
Bronze
    ↓
Silver
    ↓
Gold
    ↓
Pipeline Health Audit
```

They document the implementation, execution, validation, and final results of the **CityReads Data Engineering Capstone Project**.

---

### 🎓 Celebal Technologies Summer Internship 2026

**CityReads — Data Engineering Capstone Project**

```
```

