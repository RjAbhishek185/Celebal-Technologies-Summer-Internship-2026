# 📊 Data

This folder contains all datasets used throughout the CityReads Data Engineering Capstone Project.

The data is organized according to the Medallion Architecture:

- `cityreads_dataset/` — Original source CSV files
- `bronze/` — Incrementally ingested raw data
- `silver/` — Cleaned and validated data
- `gold/` — Business-ready Gold-layer data and outputs

The data flow is:

```text
Source Dataset
      ↓
Bronze Layer
      ↓
Silver Layer
      ↓
Gold Layer
