
# 🗄️ CityReads SQL

This folder contains the SQL scripts used to create, populate, transform, analyze, and audit the **CityReads Data Engineering Capstone Project**.

## 📁 SQL Structure


sql/
│
├── 📄 cityreads_capstone.sql
│
├── 📄final_pipeline_audit.sql
````

## 📄 Main SQL Script

### `cityreads_capstone.sql`

Contains the core MySQL implementation of the CityReads project, including:

* Database creation
* Table creation
* Source data loading
* Table validation
* Row-count validation
* Silver table creation
* Silver data loading
* Data verification
* SQL transformations

Database used:

```text
cityreads
```

Main tables:

```text
books
customers
orders
loans
reviews
```

Silver tables:

```text
books_silver
customers_silver
orders_silver
loans_silver
reviews_silver
```

---

# 🥇 Gold SQL

Location:

```text
sql/gold/gold_kpis.sql
```

This script contains the business KPI logic created from the Silver-layer data.

### Gold KPIs

```text
1. Monthly Revenue Growth
2. Customer Retention Rate
3. Book Sell-Through Rate
4. Library Return Compliance
5. Review Coverage Rate
```

### KPI Results

| KPI                       |   Actual | Target | Status |
| ------------------------- | -------: | -----: | ------ |
| Monthly Revenue Growth    |   68.30% | 10.00% | PASS   |
| Customer Retention Rate   |   76.45% | 40.00% | PASS   |
| Book Sell-Through Rate    | 8133.32% | 50.00% | PASS   |
| Library Return Compliance |   74.18% | 80.00% | FAIL   |
| Review Coverage Rate      |   81.58% | 80.00% | PASS   |

---

# 🔍 Audit SQL

Location:

```text
sql/audit/pipeline_health_audit.sql
```

This script validates the overall health of the CityReads pipeline.

It checks:

* Bronze ingestion
* Silver record counts
* Rejected records
* Gold KPI values
* KPI targets
* KPI PASS/FAIL status
* Overall pipeline health

### Final KPI Audit

```text
Total KPIs  : 5
Passed KPIs : 4
Failed KPIs : 1
Overall     : FAIL
```

The overall status is **FAIL** because the Library Return Compliance KPI is below its target.

---

# 🔄 SQL Pipeline Flow

```text
Source Tables
      ↓
Silver Tables
      ↓
Gold KPI Views
      ↓
KPI Validation
      ↓
Pipeline Health Audit
```

## 🛠️ SQL Concepts Used

The project demonstrates:

* `CREATE DATABASE`
* `CREATE TABLE`
* `LOAD DATA LOCAL INFILE`
* `SELECT`
* `WHERE`
* `GROUP BY`
* `HAVING`
* `ORDER BY`
* `JOIN`
* `LEFT JOIN`
* `UNION ALL`
* `COUNT`
* `SUM`
* `AVG`
* `CASE`
* Common Table Expressions (CTEs)
* Window Functions
* Date Functions
* `CREATE OR REPLACE VIEW`
* KPI calculations
* Data-quality checks
* Audit queries

---

## 🎯 Purpose

The `sql/` directory contains the complete SQL implementation of the CityReads project:

```text
Database Setup
      ↓
Data Loading
      ↓
Silver Transformation
      ↓
Gold KPI Generation
      ↓
Pipeline Health Audit
```

All SQL processing was performed using **MySQL / MySQL Workbench**.

```
```

