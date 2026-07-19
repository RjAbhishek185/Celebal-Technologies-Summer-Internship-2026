# Azure ADF Data Pipeline

## Overview

This project demonstrates the implementation of an end-to-end Azure Data Pipeline using Azure Blob Storage and Azure Data Factory (ADF). The pipeline validates the source file using the Get Metadata activity and copies the CSV file from the source Blob container to a destination Blob container.

---

## Objectives

- Understand Azure Resource Groups
- Create and configure Azure Storage Account
- Upload CSV files to Blob Storage
- Create Azure Data Factory
- Configure Linked Services
- Create Source and Destination Datasets
- Validate source files using Get Metadata
- Build and execute Copy Data Pipeline
- Assign IAM Roles for secure access

---

## Azure Services Used

- Azure Resource Group
- Azure Storage Account
- Azure Blob Storage
- Azure Data Factory
- Azure IAM (Role Based Access Control)

---

## Project Architecture

Source CSV (Blob Storage)
↓
Get Metadata
↓
Copy Data Activity
↓
Destination Blob Storage

---

## Repository Structure

```
Azure-ADF-Data-Pipeline
│
├── README.md
├── adf
│   ├── linked-service.md
│   ├── datasets.md
│   └── pipeline.md
├── documentation
│   └── Azure_ADF_Data_Pipeline_Report.md
└── screenshots
```

---

## Project Workflow

1. Created Azure Resource Group
2. Created Azure Storage Account
3. Created Blob Containers
4. Uploaded Superstore.csv
5. Created Azure Data Factory
6. Configured Linked Service
7. Created Source and Destination Datasets
8. Added Get Metadata Activity
9. Added Copy Data Activity
10. Executed Pipeline Successfully
11. Verified Output File
12. Configured IAM Roles

---

## Outcome

- Successfully validated source metadata
- Successfully copied CSV file
- Pipeline executed without errors
- Output file generated in destination Blob Storage

---

## Author

**Abhishek Raj**

B.Tech Computer Science Engineering

DIT University

