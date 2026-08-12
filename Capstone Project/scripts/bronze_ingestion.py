import pandas as pd
import os
import json
from datetime import datetime


# ============================================================
# CITYREADS - BRONZE LAYER INCREMENTAL INGESTION
# ============================================================

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

SOURCE_DIR = os.path.join(BASE_DIR, "data", "cityreads_dataset")
BRONZE_DIR = os.path.join(BASE_DIR, "data", "bronze")
STATE_FILE = os.path.join(BRONZE_DIR, "watermark.json")


TABLES = {
    "books": {
        "file": "books.csv",
        "key": "book_id"
    },
    "customers": {
        "file": "customers.csv",
        "key": "customer_id"
    },
    "orders": {
        "file": "orders.csv",
        "key": "order_id"
    },
    "loans": {
        "file": "loans.csv",
        "key": "loan_id"
    },
    "reviews": {
        "file": "reviews.csv",
        "key": "review_id"
    }
}


# ------------------------------------------------------------
# CREATE BRONZE DIRECTORIES
# ------------------------------------------------------------

for table in TABLES:
    os.makedirs(
        os.path.join(BRONZE_DIR, table),
        exist_ok=True
    )


# ------------------------------------------------------------
# LOAD WATERMARK STATE
# ------------------------------------------------------------

if os.path.exists(STATE_FILE):

    with open(STATE_FILE, "r") as file:
        watermark = json.load(file)

else:

    watermark = {}


# ------------------------------------------------------------
# INGEST EACH SOURCE TABLE
# ------------------------------------------------------------

print("=" * 70)
print("CITYREADS - BRONZE LAYER INGESTION")
print("=" * 70)

total_inserted = 0


for table, config in TABLES.items():

    source_file = os.path.join(
        SOURCE_DIR,
        config["file"]
    )

    key_column = config["key"]

    print()
    print("-" * 70)
    print(f"TABLE: {table.upper()}")
    print("-" * 70)

    # Read source CSV
    df = pd.read_csv(source_file)

    source_count = len(df)

    print(f"Source rows          : {source_count}")

    # Current watermark
    previous_watermark = watermark.get(table, 0)

    print(f"Previous watermark   : {previous_watermark}")

    # Incremental records
    new_data = df[
        df[key_column] > previous_watermark
    ].copy()

    new_count = len(new_data)

    print(f"New rows             : {new_count}")

    # --------------------------------------------------------
    # Add Bronze metadata
    # --------------------------------------------------------

    if new_count > 0:

        new_data["_ingestion_timestamp"] = datetime.now().isoformat()
        new_data["_source_file"] = config["file"]

        output_file = os.path.join(
            BRONZE_DIR,
            table,
            f"{table}_bronze.csv"
        )

        # Append if file already exists
        if os.path.exists(output_file):

            new_data.to_csv(
                output_file,
                mode="a",
                header=False,
                index=False
            )

        else:

            new_data.to_csv(
                output_file,
                index=False
            )

        # Update watermark
        new_watermark = int(
            new_data[key_column].max()
        )

        watermark[table] = new_watermark

        print(f"New watermark       : {new_watermark}")

        total_inserted += new_count

    else:

        print("No new records found.")

    print(f"Bronze file         : {table}_bronze.csv")


# ------------------------------------------------------------
# SAVE WATERMARK
# ------------------------------------------------------------

with open(STATE_FILE, "w") as file:

    json.dump(
        watermark,
        file,
        indent=4
    )


# ------------------------------------------------------------
# FINAL SUMMARY
# ------------------------------------------------------------

print()
print("=" * 70)
print("BRONZE INGESTION COMPLETED")
print("=" * 70)

print(f"Total new rows      : {total_inserted}")

print()
print("Watermark state:")

for table, value in watermark.items():

    print(f"{table:<15}: {value}")

print()
print(f"Watermark file      : {STATE_FILE}")

print("=" * 70)