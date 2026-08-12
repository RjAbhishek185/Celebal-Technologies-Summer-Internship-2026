
# Celebal Technologies Summer Internship 2026

### Data Engineering Internship Portfolio

---

## 📖 About

Welcome to my **Celebal Technologies Summer Internship 2026** repository.

This repository documents my learning journey throughout the **8-week Data Engineering Internship**, where I completed weekly assignments and hands-on projects covering **SQL, Azure Data Factory, Apache Spark (PySpark), Delta Lake, Python**, and modern **Data Engineering** concepts.

Each week focuses on building practical skills through real-world datasets, ETL workflows, distributed data processing, Delta Lake operations, database analytics, and cloud-based data integration.

The repository also includes my **CityReads Data Engineering Capstone Project**, which brings together the concepts learned throughout the internship into an end-to-end Data Engineering pipeline.

---

# 📂 Repository Structure

```text
Celebal-Technologies-Summer-Internship-2026
│
├── Week-01/
├── Week-02/
├── Week-03/
├── Week-04/
├── Week-05/
├── Week-06/
├── Week-07/
├── Week-08/
│
├── Capstone Project/
│   ├── data/
│   ├── scripts/
│   ├── sql/
│   ├── screenshots/
│   ├── output/
│   ├── Dataset_generator.py
│   └── README.md
│
└── README.md
````

---

# 📅 Weekly Progress

| Week        | Topic                                |   Status  |
| ----------- | ------------------------------------ | :-------: |
| ✅ Week 01   | SQL Fundamentals                     | Completed |
| ✅ Week 02   | Database Design & SQL Queries        | Completed |
| ✅ Week 03   | Advanced SQL & Stored Procedures     | Completed |
| ✅ Week 04   | Azure Data Factory                   | Completed |
| ✅ Week 05   | Apache Spark (PySpark) Fundamentals  | Completed |
| ✅ Week 06   | Spark Architecture & Data Processing | Completed |
| ✅ Week 07   | Delta Lake MERGE Implementation      | Completed |
| ✅ Week 08   | E-Commerce Order Analytics System    | Completed |
| 🎓 Capstone | CityReads Data Engineering Pipeline  | Completed |

---

# 📚 Weekly Assignments

| Week        | Repository                                 |
| ----------- | ------------------------------------------ |
| 📁 Week 01  | [Week-01](./Week-01)                       |
| 📁 Week 02  | [Week-02](./Week-02)                       |
| 📁 Week 03  | [Week-03](./Week-03)                       |
| 📁 Week 04  | [Week-04](./Week-04)                       |
| 📁 Week 05  | [Week-05](./Week-05)                       |
| 📁 Week 06  | [Week-06](./Week-06)                       |
| 📁 Week 07  | [Week-07](./Week-07)                       |
| 📁 Week 08  | [Week-08](./Week-08)                       |
| 🎓 Capstone | [CityReads Capstone](./Capstone%20Project) |

---

# 🎓 CityReads — Data Engineering Capstone Project

The **CityReads Data Engineering Capstone Project** is the final project of my internship.

It demonstrates an end-to-end Data Engineering pipeline for processing and analyzing data related to:

* 📚 Books
* 👥 Customers
* 🛒 Orders
* 📖 Loans
* ⭐ Reviews

The project follows the **Medallion Architecture**:

```text
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
                │ Incremental     │
                │ Ingestion       │
                │ + Watermark     │
                └────────┬────────┘
                         │
                         ▼
                ┌─────────────────┐
                │  SILVER LAYER   │
                │ Cleaning        │
                │ Validation      │
                │ Deduplication   │
                │ Rejections      │
                └────────┬────────┘
                         │
                         ▼
                ┌─────────────────┐
                │   GOLD LAYER    │
                │ Business KPIs   │
                │ SQL Views       │
                └────────┬────────┘
                         │
                         ▼
                ┌─────────────────┐
                │ PIPELINE AUDIT  │
                │ PASS / FAIL     │
                └─────────────────┘
```

## 📊 Capstone Dataset

The project processes five datasets:

| Dataset      | Source Records |
| ------------ | -------------: |
| 📚 Books     |            190 |
| 👥 Customers |          2,800 |
| 🛒 Orders    |         28,336 |
| 📖 Loans     |          9,614 |
| ⭐ Reviews    |          5,621 |
| **Total**    |     **46,561** |

---

## 🥉 Bronze Layer

The Bronze layer implements **incremental data ingestion** using Python and watermark-based processing.

### Key Features

* Incremental ingestion
* Watermark tracking
* Duplicate-ingestion prevention
* Source-data preservation
* Ingestion state management

Final watermark state:

```text
Books       : 190
Customers   : 2,800
Orders      : 28,336
Loans       : 9,614
Reviews     : 5,621
```

A subsequent ingestion run detected:

```text
Total new rows : 0
```

This confirmed that previously processed records were not ingested again.

---

## 🥈 Silver Layer

The Silver layer performs data cleaning, validation, standardization, and rejected-record handling.

### Silver Results

| Dataset   |     Bronze |     Silver |
| --------- | ---------: | ---------: |
| Books     |        190 |        190 |
| Customers |      2,800 |      2,766 |
| Orders    |     28,336 |     27,835 |
| Loans     |      9,614 |      9,538 |
| Reviews   |      5,621 |      5,522 |
| **Total** | **46,561** | **45,851** |

### Rejected Records

```text
Total Rejected Records : 710
```

Invalid records are stored separately with rejection information for auditing and traceability.

---

## 🥇 Gold Layer

The Gold layer contains business-ready SQL views and five executive-level KPIs:

1. 📈 Monthly Revenue Growth
2. 👥 Customer Retention Rate
3. 📚 Book Sell-Through Rate
4. 📖 Library Return Compliance
5. ⭐ Review Coverage Rate

### KPI Results

| KPI                       |   Actual | Target | Status |
| ------------------------- | -------: | -----: | ------ |
| Monthly Revenue Growth    |   68.30% | 10.00% | ✅ PASS |
| Customer Retention Rate   |   76.45% | 40.00% | ✅ PASS |
| Book Sell-Through Rate    | 8133.32% | 50.00% | ✅ PASS |
| Library Return Compliance |   74.18% | 80.00% | ❌ FAIL |
| Review Coverage Rate      |   81.58% | 80.00% | ✅ PASS |

---

## 🔍 Pipeline Health Audit

An automated SQL audit compares KPI results against predefined targets.

```text
Total KPIs  : 5
Passed KPIs : 4
Failed KPIs : 1
Overall     : FAIL
```

The overall result is **FAIL** because Library Return Compliance achieved **74.18%**, below the target of **80.00%**.

The failure is intentionally retained to demonstrate real KPI monitoring and exception detection.

---

## 🛠️ Capstone Technologies

* 🐍 Python
* 🐼 Pandas
* 🗄️ SQL
* 🐬 MySQL
* 🛠️ MySQL Workbench
* 📄 CSV
* 🏗️ Medallion Architecture
* 🔄 Incremental Processing
* 💧 Watermark Processing
* 🔍 Data Quality Validation
* 📊 SQL Analytics
* 🪟 Window Functions
* 🔗 Common Table Expressions
* 👁️ SQL Views
* 🔀 Joins
* 📈 Aggregations
* 🌐 Git & GitHub

---

## 📂 Capstone Structure

```text
Capstone Project/
│
├── data/
│   ├── cityreads_dataset/
│   ├── bronze/
│   ├── silver/
│   └── gold/
│
├── scripts/
│   ├── bronze_ingestion.py
│   └── silver_transform.py
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
└── README.md
```

👉 **[View the Complete CityReads Capstone Project](./Capstone%20Project)**

---

# 🛠️ Technologies Used Across the Internship

* 🐍 Python
* 🗄️ SQL
* 🟢 SQLite
* 🐬 MySQL
* ⚡ Apache Spark (PySpark)
* 🟦 Delta Lake
* ☁️ Azure Data Factory
* 📊 Pandas
* 🔢 NumPy
* 🧪 Faker
* 📓 Jupyter Notebook / Google Colab
* 💻 Visual Studio Code
* 🌐 Git & GitHub

---

# 📂 Repository Contents

Each week's folder contains relevant assignment materials such as:

* 📓 Jupyter Notebooks
* 📊 Dataset(s)
* 📄 Assignment Reports
* 📘 README Documentation
* 💻 Source Code
* 📝 SQL Queries
* 📷 Execution Screenshots
* 🔍 Data Validation Results

The **Capstone Project** additionally contains:

* 🏗️ Medallion Architecture implementation
* 🔄 Incremental ingestion
* 💧 Watermark management
* 🧹 Data-quality processing
* ❌ Rejected-record handling
* 📊 Gold-layer KPIs
* 🔍 Pipeline health audit
* 📄 Final project report

---

# 🎯 Skills Gained

During this internship, I gained practical experience in:

* SQL Query Writing
* Database Design
* Data Cleaning
* Data Transformation
* ETL Pipeline Development
* Azure Data Factory
* Apache Spark (PySpark)
* Spark DataFrames
* Spark Architecture
* Delta Lake
* MERGE (UPSERT) Operations
* Incremental Data Processing
* Distributed Data Processing
* Window Functions
* CTEs
* Cohort Analysis
* Customer Segmentation
* SQLite Database Integration
* Command-Line Reporting
* Edge Case Handling
* Schema Management
* Data Engineering Best Practices
* Version Control using Git & GitHub
* Medallion Architecture
* Watermark-Based Processing
* Data Quality Validation
* Business KPI Development
* Pipeline Health Monitoring

---

# 📈 Repository Statistics

| Metric                    | Value                                 |
| ------------------------- | ------------------------------------- |
| Internship Duration       | 8 Weeks                               |
| Completed Weeks           | 8                                     |
| Weekly Assignments        | 8                                     |
| Capstone Project          | CityReads                             |
| Capstone Source Records   | 46,561                                |
| Capstone Silver Records   | 45,851                                |
| Capstone Rejected Records | 710                                   |
| Gold KPIs                 | 5                                     |
| Technologies Used         | Python, SQL, Spark, Delta Lake, Azure |
| Assignment Reports        | Included                              |
| Datasets                  | Included                              |
| Documentation             | Available                             |

---

# 🎓 Internship Details

| Field              | Information                             |
| ------------------ | --------------------------------------- |
| Organization       | **Celebal Technologies**                |
| Role               | **Data Engineering Intern**             |
| Duration           | **June 15, 2026 – August 15, 2026**     |
| Internship Project | **CityReads Data Engineering Capstone** |

---

# 👨‍💻 About Me

**Abhishek Raj**

Computer Science Engineering student passionate about **Data Engineering, Software Development, Cloud Technologies, and Artificial Intelligence**.

This repository showcases my internship assignments, hands-on projects, technical learning, and practical implementation of modern Data Engineering tools and technologies.

---

# 📬 Connect With Me

* **GitHub:** [RjAbhishek185](https://github.com/RjAbhishek185)
* **LinkedIn:** [Abhishek Raj](https://www.linkedin.com/in/abhishek-raj-1589a62a1/)

---

<div align="center">

### ⭐ Thank you for visiting this repository!

If you found this repository helpful, consider giving it a ⭐ on GitHub.

**Celebal Technologies Summer Internship 2026**

</div>

