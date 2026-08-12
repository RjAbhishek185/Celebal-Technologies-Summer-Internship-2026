
# 🐍 CityReads Python Scripts

This folder contains the Python scripts used to implement the **CityReads Data Engineering Capstone Project**.

## 📁 Scripts Structure

```text
scripts/
│
├── 📄 bronze_ingestion.py
│
├── 📄 silver_transform.py
│
└── 📄 README.md
````

---

# 🥉 Bronze Ingestion

### `bronze_ingestion.py`

This script implements the **Bronze-layer incremental ingestion process**.

### Responsibilities

* Read source CSV datasets.
* Check the existing watermark.
* Identify newly available records.
* Ingest new records into the Bronze layer.
* Maintain separate Bronze files for each dataset.
* Update the watermark after successful ingestion.
* Prevent previously processed records from being ingested again.

### Processing Flow

```text
Source CSV
    ↓
Read Previous Watermark
    ↓
Identify New Records
    ↓
Write Bronze Data
    ↓
Update Watermark
```

### Datasets Processed

```text
books
customers
orders
loans
reviews
```

### Incremental Ingestion Result

After running the ingestion process again:

```text
Books       : 0 new rows
Customers   : 0 new rows
Orders      : 0 new rows
Loans       : 0 new rows
Reviews     : 0 new rows

Total       : 0 new rows
```

This confirms that the watermark-based incremental ingestion is working correctly.

---

# 🥈 Silver Transformation

### `silver_transform.py`

This script implements the **Silver-layer data transformation and validation process**.

### Responsibilities

* Read Bronze-layer data.
* Validate source records.
* Remove duplicate records.
* Apply data-quality rules.
* Validate dates and numeric values.
* Apply business rules.
* Generate cleaned Silver datasets.
* Separate invalid records.
* Store rejected records for auditing.

### Processing Flow

```text
Bronze Data
    ↓
Data Validation
    ↓
Duplicate Handling
    ↓
Business Rule Validation
    ↓
Valid Records ──────────→ Silver Layer
    │
    └────────────────────→ Rejected Records
```

### Silver Results

| Dataset   | Bronze Records | Silver Records |
| --------- | -------------: | -------------: |
| Books     |            190 |            190 |
| Customers |          2,800 |          2,766 |
| Orders    |         28,336 |         27,835 |
| Loans     |          9,614 |          9,538 |
| Reviews   |          5,621 |          5,522 |
| **Total** |     **46,561** |     **45,851** |

### Rejected Records

```text
Total Rejected Records : 710
```

Rejected records are stored in:

```text
data/silver/rejected/silver_rejected_rows.csv
```

The rejection data provides traceability through information such as the source table, record ID, rejection reason, and timestamp.

---

# 🔄 Complete Python Pipeline

```text
              Source CSV Files
                     │
                     ▼
          ┌─────────────────────┐
          │ bronze_ingestion.py │
          └──────────┬──────────┘
                     │
                     ▼
               🥉 BRONZE
                     │
                     ▼
          ┌─────────────────────┐
          │  silver_transform   │
          │        .py          │
          └──────────┬──────────┘
                     │
              ┌──────┴──────┐
              ▼             ▼
         🥈 SILVER      ❌ REJECTED
              │             RECORDS
              │
              ▼
          Gold SQL Layer
```

---

# 🛠️ Technologies Used

* Python
* Pandas
* CSV
* File-based processing
* Incremental processing
* Watermark processing
* Data validation
* Data cleaning
* Deduplication
* Rejected-record handling

---

# 🎯 Purpose

The `scripts/` directory contains the Python processing components responsible for moving CityReads data from the **source layer → Bronze layer → Silver layer**.

The Gold layer and pipeline audit are implemented separately using SQL.

```text
Source
  ↓
Python Processing
  ↓
Bronze
  ↓
Python Transformation
  ↓
Silver
  ↓
SQL
  ↓
Gold KPIs
  ↓
Pipeline Audit
```

These scripts form the core programmatic processing layer of the CityReads Data Engineering pipeline.

```
```

