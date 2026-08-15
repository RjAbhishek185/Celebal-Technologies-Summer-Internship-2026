# 🗄️ CityReads SQL

This folder contains the MySQL scripts used in the **CityReads Data Engineering Capstone Project**.

## 📁 Structure

```text
sql/
├── cityreads_capstone.sql
└── final_pipeline_audit.sql
```

### `cityreads_capstone.sql`

Handles:

* Database and table creation
* Source data loading
* Silver table creation
* Data validation and transformations

**Database:** `cityreads`

**Tables:**
`books`, `customers`, `orders`, `loans`, `reviews`

**Silver Tables:**
`books_silver`, `customers_silver`, `orders_silver`, `loans_silver`, `reviews_silver`

### `final_pipeline_audit.sql`

Contains the **Gold KPI calculations and final pipeline health audit**.

**Gold KPIs:**

* Monthly Revenue Growth
* Customer Retention Rate
* Book Sell-Through Rate
* Library Return Compliance
* Review Coverage Rate

The audit validates:

* Bronze/Silver record counts
* Rejected records
* KPI values against targets
* Overall pipeline health

### 🔄 Pipeline Flow

```text
Source → Bronze → Silver → Gold → Final Audit
```

### 🛠️ Technologies

**Python | Pandas | MySQL | SQL | MySQL Workbench | GitHub**

The project uses a local **Python + MySQL** implementation of the Medallion Architecture, with transparent KPI PASS/FAIL reporting.
