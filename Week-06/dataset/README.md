# Week 6 Spark Dataset

## Overview

This dataset was created specifically for the **Celebal Technologies Data Engineering Internship – Week 6 Assignment**. It simulates a realistic retail sales environment and is designed to demonstrate various Apache Spark concepts, including DataFrame operations, transformations, filtering, schema handling, and file format processing.

## Dataset Information

- **Dataset Name:** `week6_spark_dataset.csv`
- **Total Records:** 10,050
- **Total Columns:** 18
- **File Format:** CSV
- **Generated Using:** Python (Pandas, NumPy, Faker)

## Features

- Realistic retail sales data
- Multiple product categories
- Customer and transaction information
- Randomly generated order dates
- Various payment methods
- Multiple regions and states
- Different order priorities
- Different order statuses
- Duplicate records for data cleaning practice
- Missing values for null handling and preprocessing

## Columns

| Column Name | Description |
|--------------|-------------|
| user_id | Unique customer identifier |
| product_id | Unique product identifier |
| transaction_id | Unique transaction identifier |
| category | Product category |
| product_name | Name of the product |
| old_name | Product name used for column renaming practice |
| price | Product price stored as String |
| base_price | Original product price |
| quantity | Number of units purchased |
| amount | Total transaction amount |
| status | Order status (Completed, Pending, Cancelled, Returned) |
| region | Sales region |
| priority | Order priority (High, Medium, Low) |
| order_date | Date of purchase |
| payment_method | Mode of payment |
| customer_name | Customer name |
| city | Customer city |
| state | Customer state |

## Product Categories

- Electronics
- Furniture
- Clothing
- Books
- Sports
- Groceries
- Beauty
- Home Decor
- Toys
- Automotive

## Order Status

- Completed
- Pending
- Cancelled
- Returned

## Priority Levels

- High
- Medium
- Low

## Regions

- North
- South
- East
- West
- Central

## Payment Methods

- Cash
- Credit Card
- Debit Card
- UPI
- Net Banking
- Wallet

## Purpose

This dataset supports the following Apache Spark concepts:

- Reading CSV files
- Schema inference
- DataFrame transformations
- Filtering and selection
- Column renaming
- Data type casting
- Adding new columns
- Handling null values
- Working with Parquet files
- Spark Actions and Transformations
- Predicate Pushdown concepts
- Performance optimization
- Spark Architecture demonstrations

## Notes

- The dataset is synthetically generated for educational purposes.
- It does not contain any real customer information.
- Missing values and duplicate records are intentionally included to practice data cleaning and preprocessing techniques in Apache Spark.
