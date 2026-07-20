# Week 5 - Apache Spark (PySpark)

## Celebal Technologies Data Engineering Internship

### Overview

This repository contains the Week 5 assignment completed as part of the **Celebal Technologies Data Engineering Internship**. The assignment focuses on learning and implementing core Apache Spark (PySpark) concepts used for distributed data processing and large-scale data analytics.

A custom **Retail Sales** dataset was created to demonstrate various PySpark operations, including data cleaning, filtering, aggregation, duplicate removal, null value handling, timestamp conversion, and processing pipelines.

---

## Assignment Objectives

- Understand the limitations of traditional MapReduce.
- Learn Spark's in-memory computing architecture.
- Perform data cleaning using PySpark.
- Remove duplicate records.
- Handle missing values.
- Apply filtering and aggregation operations.
- Perform groupBy transformations.
- Convert data types using Spark.
- Understand Spark Shuffle operations.
- Build an end-to-end data processing pipeline.

---

## Project Structure

```
Week-05/
│
├── data/
│   └── retail_sales.csv
│
├── notebooks/
│   └── Week5_PySpark_Assignment.ipynb
│
├── Week5_Report.docx
│
└── README.md
```

---

## Dataset Description

A custom Retail Sales dataset was generated specifically for this assignment.

### Dataset Features

- 500+ retail transaction records
- Duplicate records for data cleaning
- Missing values for null handling
- Multiple stores and regions
- Different product categories
- Customer demographic information
- Transaction timestamps

### Dataset Columns

- user_id
- transaction_date
- transaction_id
- store_id
- region
- city
- state
- product_category
- product_name
- sale_amount
- price
- quantity
- status
- age
- subscription
- email
- username
- raw_timestamp

---

## Technologies Used

- Python 3
- Apache Spark (PySpark)
- Pandas
- Jupyter Notebook
- Java
- Visual Studio Code

---

## Assignment Topics Covered

### Theoretical Concepts

- Limitations of MapReduce
- In-Memory Computing
- Spark Shuffle
- DataFrame Immutability
- Handling Null Values
- Schema Inference

### Practical Implementation

- Creating Spark Session
- Loading CSV Files
- Data Inspection
- Removing Duplicate Records
- Filtering Data
- Handling Missing Values
- GroupBy Operations
- Aggregate Functions
- Timestamp Conversion
- Spark SQL
- Processing Pipelines

---

## Key PySpark Operations

- `dropDuplicates()`
- `filter()`
- `groupBy()`
- `agg()`
- `avg()`
- `count()`
- `sum()`
- `min()`
- `max()`
- `na.fill()`
- `withColumn()`
- `cast()`
- `createOrReplaceTempView()`

---

## Assignment Workflow

1. Create a custom retail sales dataset.
2. Load the dataset using PySpark.
3. Inspect the dataset structure and schema.
4. Perform data cleaning operations.
5. Handle duplicate and missing values.
6. Apply filtering and aggregation.
7. Convert timestamp columns.
8. Build a complete processing pipeline.
9. Analyze the final output.

---

## Learning Outcomes

After completing this assignment, the following concepts were understood and implemented:

- Apache Spark architecture
- Distributed data processing
- In-memory computation
- DataFrame transformations
- DataFrame actions
- Data cleaning techniques
- Data aggregation
- Spark SQL basics
- End-to-end PySpark workflows

---

## Conclusion

This assignment demonstrates the practical use of Apache Spark (PySpark) for distributed data processing using a custom Retail Sales dataset. It covers essential data engineering operations such as data cleaning, transformation, aggregation, timestamp handling, and processing pipelines. The project provides hands-on experience with Spark's distributed computing model and highlights its advantages over traditional MapReduce for modern big data applications.

---

## Author

**Abhishek Raj**

Data Engineering Intern

Celebal Technologies Internship

2026
