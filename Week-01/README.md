# Week 01 - Basic Data Exploration and Cleaning using Pandas

## Overview

The first week's assignment focused on understanding the fundamentals of data analysis using the Pandas library in Python. The objective was to explore a real-world dataset, identify inconsistencies, clean the data, and prepare it for further analysis.

Data cleaning is one of the most important stages in the data engineering lifecycle. A well-cleaned dataset improves data quality and leads to more reliable analytics and machine learning models.

---

## Objectives

- Understand the basics of Pandas DataFrames.
- Load datasets from CSV files.
- Perform exploratory data analysis (EDA).
- Handle missing values.
- Remove duplicate records.
- Rename and modify columns.
- Filter and sort data.
- Perform aggregation using GroupBy.
- Export the cleaned dataset.

---

## Technologies Used

- Python 3
- Pandas
- Jupyter Notebook

---

## Dataset

The assignment uses a shopping dataset stored in CSV format.

The dataset contains information related to:

- Customer details
- Products
- Purchase records
- Prices
- Categories
- Sales information

---

## Tasks Performed

### 1. Import Required Libraries

Imported the necessary Python libraries for data analysis.

```python
import pandas as pd
```

---

### 2. Load Dataset

Loaded the CSV dataset into a Pandas DataFrame.

```python
df = pd.read_csv("shopping_dataset.csv")
```

---

### 3. Data Exploration

Performed several exploratory operations including:

- Viewing first and last records
- Checking dataset dimensions
- Displaying column names
- Examining data types
- Generating summary statistics
- Identifying missing values

Functions used:

- head()
- tail()
- shape
- columns
- info()
- describe()
- isnull()

---

### 4. Data Cleaning

Performed cleaning operations such as:

- Removing duplicate rows
- Handling missing values
- Correcting inconsistent entries
- Renaming columns

Functions used:

- drop_duplicates()
- fillna()
- rename()

---

### 5. Data Transformation

Applied transformations including:

- Filtering rows
- Sorting records
- Creating calculated columns
- Changing data types

Functions used:

- loc[]
- sort_values()
- astype()

---

### 6. Data Aggregation

Used aggregation techniques to summarize the dataset.

Operations included:

- Count
- Mean
- Sum
- Maximum
- Minimum
- GroupBy

---

### 7. Export Cleaned Dataset

Saved the cleaned dataset into a new CSV file.

```python
df.to_csv("cleaned_shopping_dataset.csv", index=False)
```

---

## Learning Outcomes

Through this assignment, I learned how to:

- Work with Pandas DataFrames
- Explore structured datasets
- Handle missing and duplicate values
- Perform filtering and sorting
- Apply aggregation techniques
- Prepare datasets for further analysis

---

## Repository Structure

```
Week-01-Pandas
│
├── README.md
├── Assignment.ipynb
└── cleaned_shopping_dataset.csv
```

---

## Conclusion

This assignment provided hands-on experience with the complete data cleaning workflow using Pandas. The cleaned dataset produced in this assignment serves as a strong foundation for subsequent data analysis and engineering tasks.
