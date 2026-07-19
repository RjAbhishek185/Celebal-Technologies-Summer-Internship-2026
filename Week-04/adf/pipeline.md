# Azure Data Factory Pipeline

## Pipeline Name

PL_Copy_Superstore

---

## Activities Used

### Get Metadata

Purpose:
- Validate the existence of the source CSV file before processing.

Output:
- Returns file metadata including existence status.

---

### Copy Data

Purpose:
- Copy the CSV file from the source Blob container to the destination Blob container.

Source:
- DS_Source

Destination:
- DS_Destination

---

## Execution Result

- Metadata validation completed successfully.
- CSV file copied successfully.
- Pipeline execution status: Succeeded.

---

## Pipeline Flow

Source CSV
↓

Get Metadata
↓

Copy Data
↓

Destination Blob Storage
