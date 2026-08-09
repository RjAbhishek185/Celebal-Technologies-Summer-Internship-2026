# E-Commerce Order Analytics System

### Celebal Technologies Summer Internship 2026

---

## 📖 Overview

This project implements an end-to-end **E-Commerce Order Analytics System** using **Python and SQL**.

The project starts with realistic but intentionally messy e-commerce data and follows a complete data engineering workflow:

```text
Data Generation
      ↓
Data Verification
      ↓
Data Cleaning
      ↓
SQLite Database
      ↓
SQL Analysis
      ↓
CLI Reporting
      ↓
Edge Case Testing
```

---

## 🎯 Objective

The objective of this project is to design and develop an e-commerce analytics system that can:

- Generate realistic datasets
- Introduce intentional data-quality issues
- Validate raw datasets
- Clean and transform data
- Maintain referential integrity
- Load data into SQLite
- Perform business analytics using SQL
- Use CTEs and window functions
- Perform customer segmentation
- Perform cohort and retention analysis
- Generate reports using Python
- Handle important edge cases

---

## 📂 Project Structure

```text
Week-08/
│
├── data/
│   ├── raw/
│   └── cleaned/
│
├── scripts/
│   ├── generate_data.py
│   ├── verify_data.py
│   ├── clean_data.py
│   ├── load_database.py
│   ├── run_sql.py
│   ├── report_cli.py
│   └── test_edge_cases.py
│
├── sql/
│   ├── schema.sql
│   ├── aggregations.sql
│   ├── window_functions.sql
│   └── cohort_analysis.sql
│
├── output/
│   └── data_quality_report.txt
│
├── screenshots/
│   ├── data_loading/
│   ├── data_cleaning/
│   ├── sql_analysis/
│   ├── phase5_cli/
│   └── phase6_edge_cases/
|
├── report/
│   ├── README.md
│   └── Celebal_Week_08_ECommerce_Order_Analytics_Report.docx
│
├── ecommerce.db
└── README.md
```

---

## 📊 Dataset

Four datasets are used:

### Customers

Contains:

- `customer_id`
- `customer_name`
- `email`
- `registration_date`
- `customer_type`

### Products

Contains:

- `product_id`
- `product_name`
- `category`
- `subcategory`
- `cost_price`

### Orders

Contains:

- `order_id`
- `customer_id`
- `order_date`
- `status`
- `region_code`

### Order Items

Contains:

- `item_id`
- `order_id`
- `product_id`
- `quantity`
- `unit_price`
- `discount_percent`

---

## 📈 Dataset Statistics

### Raw Data

```text
Customers    : 500
Products     : 500
Orders       : 1000
Order Items  : 2000
```

### Cleaned Data

```text
Customers    : 500
Products     : 500
Orders       : 950
Order Items  : 1905
```

---

## 🔹 Project Phases

### Phase 1 — Data Generation

Python was used to generate realistic e-commerce datasets with intentional inconsistencies such as:

- Missing customer IDs
- Invalid emails
- Negative quantities
- Product name formatting issues
- Incorrect date formats

The generated data was verified before cleaning.

---

### Phase 2 — Data Cleaning

The datasets were cleaned using Python.

Operations included:

- Duplicate detection
- Email validation
- Product name normalization
- Date conversion
- Missing customer ID handling
- Referential integrity checks
- Discount validation

---

### Phase 3 — SQLite Database

The cleaned datasets were loaded into:

```text
ecommerce.db
```

Tables:

```text
customers
products
orders
order_items
```

Foreign-key validation was performed successfully.

---

### Phase 4 — SQL Analysis

The project contains **16 SQL analytical questions** covering:

- Revenue analysis
- Customer analysis
- Monthly order analysis
- Return analysis
- Running totals
- Ranking
- LAG analysis
- Customer segmentation
- Lifetime value
- Year-over-year comparison
- First/last category analysis
- Cumulative revenue
- Cohort retention
- Self-join analysis

SQL concepts include:

- JOINs
- Aggregations
- CTEs
- Subqueries
- Window Functions
- RANK
- DENSE_RANK
- LAG
- NTILE
- SUM OVER
- Cohort Analysis

---

### Phase 5 — CLI Reporting

A Python CLI tool was created to generate:

- Daily reports
- Weekly reports
- Monthly reports

The reports include:

- Total orders
- Revenue
- Unique customers
- Top 3 products
- Previous-period comparison
- Percentage changes

---

### Phase 6 — Edge Case Testing

The following cases were tested:

| Test | Result |
|------|:------:|
| Invalid Order ID | ✅ Passed |
| Discount > 100% | ✅ Passed |
| Zero Quantity | ✅ Passed |
| Future Order Date | ✅ Passed |

---

## 🛠️ Technologies

- Python
- SQL
- SQLite
- Pandas
- Faker
- Git
- GitHub
- Visual Studio Code

---

## ▶️ Execution

Run the project from the `Week-08` directory.

### Generate Data

```bash
python scripts/generate_data.py
```

### Verify Data

```bash
python scripts/verify_data.py
```

### Clean Data

```bash
python scripts/clean_data.py
```

### Create Database

```bash
python scripts/load_database.py
```

### Run SQL Analysis

```bash
python scripts/run_sql.py
```

### Run CLI Reports

```bash
python scripts/report_cli.py
```

### Run Edge Case Tests

```bash
python scripts/test_edge_cases.py
```

---

## 📸 Screenshots

Execution screenshots are available in:

```text
screenshots/
```

They demonstrate:

- Data generation
- Data verification
- Data cleaning
- Database creation
- SQL analysis
- CLI reporting
- Edge-case testing

---

## 🎯 Key Outcomes

This project demonstrates practical experience with:

- Data generation
- Data quality management
- Data cleaning
- Data validation
- Relational databases
- SQL analytics
- Advanced SQL
- Window functions
- CTEs
- Cohort analysis
- Customer segmentation
- Python automation
- CLI reporting
- Edge-case handling

---

## 👨‍💻 Author

**Abhishek Raj**

Computer Science Engineering Student

Interested in:

- Data Engineering
- Software Development
- Cloud Technologies
- Artificial Intelligence

---

### ⭐ Thank You

Thank you for visiting this project!
