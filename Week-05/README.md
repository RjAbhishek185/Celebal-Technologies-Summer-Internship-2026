# Week 05 - Apache Spark Fundamentals: Data Cleaning, Transformation, and Aggregation

## Overview

This assignment introduces the fundamentals of Apache Spark and demonstrates how Spark DataFrames can be used to perform large-scale data processing efficiently. The focus is on understanding Spark's architecture, in-memory computing capabilities, DataFrame operations, and building a complete data processing pipeline involving data cleaning, transformation, and aggregation.

Apache Spark is one of the most widely used distributed data processing frameworks, designed to handle large datasets with high speed and fault tolerance. Compared to traditional MapReduce, Spark provides significant performance improvements through in-memory computation and optimized execution planning.

---

## Objectives

- Understand the limitations of traditional MapReduce.
- Learn the advantages of Apache Spark.
- Work with Spark DataFrames.
- Perform data cleaning operations.
- Handle duplicate and missing values.
- Filter and transform datasets.
- Apply aggregation functions.
- Perform GroupBy operations.
- Understand narrow and wide transformations.
- Learn about shuffle operations.
- Modify DataFrame schemas.
- Build a complete Spark data processing pipeline.

---

## Technologies Used

- Apache Spark
- PySpark
- Python 3
- Jupyter Notebook / VS Code

---

## Topics Covered

### Spark Fundamentals

- Introduction to Apache Spark
- Spark Architecture
- Driver Program
- Executors
- Cluster Manager
- Resilient Distributed Datasets (RDDs)
- Spark DataFrames

---

### In-Memory Computing

Explored how Spark stores intermediate computation results in memory instead of repeatedly reading and writing data to disk.

Benefits include:

- Faster execution
- Reduced disk I/O
- Efficient iterative processing
- Better performance for Machine Learning workloads

---

### Data Cleaning

Performed various data cleaning operations including:

- Removing duplicate rows
- Handling null values
- Dropping unnecessary records
- Filling missing values
- Cleaning inconsistent data

Functions used:

- dropDuplicates()
- na.drop()
- na.fill()

---

### Data Transformation

Applied several transformation operations including:

- Filtering records
- Selecting required columns
- Renaming columns
- Casting data types
- Creating new columns

Functions used:

- filter()
- select()
- withColumn()
- withColumnRenamed()
- cast()

---

### Aggregation

Performed aggregation using Spark SQL functions.

Operations included:

- Count
- Sum
- Average
- Minimum
- Maximum

Functions used:

- count()
- sum()
- avg()
- min()
- max()

---

### GroupBy Operations

Grouped datasets based on different attributes and calculated aggregate statistics.

Examples include:

- Revenue by Store
- Sales by Region
- Average Sales by Category
- Record Count by City

---

### Data Filtering

Applied conditional filtering using Spark DataFrame APIs.

Examples:

- Age between 18 and 30
- Premium subscriptions
- Region-specific records
- Valid email filtering

---

### Schema Modification

Modified DataFrame schemas by:

- Renaming columns
- Changing data types
- Converting strings into timestamps

Example:

- raw_timestamp → event_time

---

### Shuffle Operations

Studied Spark shuffle behavior during wide transformations.

Operations causing shuffle:

- groupBy()
- join()
- distinct()
- repartition()

Also understood why shuffle operations are computationally expensive.

---

## Complete Data Processing Pipeline

The final pipeline combined multiple Spark operations into a single workflow.

Pipeline steps included:

1. Remove duplicate records
2. Handle missing values
3. Filter unnecessary records
4. Transform columns
5. Group data
6. Calculate total revenue
7. Display processed output

---

## Learning Outcomes

Through this assignment, I learned how to:

- Understand Apache Spark architecture.
- Compare Spark with traditional MapReduce.
- Use Spark DataFrames effectively.
- Clean large datasets efficiently.
- Handle missing and inconsistent data.
- Perform filtering and transformation operations.
- Apply aggregation and grouping techniques.
- Understand shuffle operations and their impact on performance.
- Build scalable ETL pipelines using Spark.

---

## Repository Structure

```
Week-05-Apache-Spark
│
├── README.md
├── spark_assignment.py
├── Week5_Assignment.pdf
└── outputs/
```

---

## Key Concepts Learned

- Apache Spark Architecture
- Spark DataFrames
- In-Memory Computing
- Data Cleaning
- Data Transformation
- Aggregations
- GroupBy Operations
- Schema Evolution
- Shuffle Operations
- Wide vs Narrow Transformations
- ETL Pipeline Development

---

## Conclusion

This assignment provided practical experience with Apache Spark for distributed data processing. By implementing data cleaning, transformation, and aggregation using Spark DataFrames, I gained an understanding of scalable data engineering workflows and how Spark enables efficient processing of large datasets through in-memory computation and optimized execution. These concepts form the foundation for building high-performance ETL pipelines and large-scale data analytics applications.
