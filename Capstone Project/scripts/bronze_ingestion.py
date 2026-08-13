# ============================================================
# CITYREADS - BRONZE LAYER INCREMENTAL INGESTION
# Celebal Technologies Summer Internship 2026
# ============================================================

import os
import pandas as pd
import mysql.connector
from datetime import datetime
from getpass import getpass


# ============================================================
# PROJECT PATHS
# ============================================================

BASE_DIR = os.path.abspath(
    os.path.join(os.path.dirname(__file__), "..")
)

SOURCE_DIR = os.path.join(
    BASE_DIR,
    "data",
    "cityreads_dataset"
)

BRONZE_DIR = os.path.join(
    BASE_DIR,
    "data",
    "bronze"
)


# ============================================================
# MYSQL CONNECTION
# ============================================================

print("\n" + "=" * 65)
print("CITYREADS - BRONZE LAYER INGESTION")
print("=" * 65)

MYSQL_PASSWORD = getpass("Enter MySQL root password: ")

connection = mysql.connector.connect(
    host="localhost",
    port=3306,
    user="root",
    password=MYSQL_PASSWORD,
    database="cityreads"
)

print("\nMySQL connection successful.")


# ============================================================
# TABLE CONFIGURATION
# ============================================================

TABLE_CONFIG = {

    "books": {
        "source_file": "books.csv",
        "bronze_file": "books_bronze.csv",
        "bronze_table": "bronze_books",
        "timestamp_column": "published_on",
        "primary_key": "book_id"
    },

    "customers": {
        "source_file": "customers.csv",
        "bronze_file": "customers_bronze.csv",
        "bronze_table": "bronze_customers",
        "timestamp_column": "joined_on",
        "primary_key": "customer_id"
    },

    "orders": {
        "source_file": "orders.csv",
        "bronze_file": "orders_bronze.csv",
        "bronze_table": "bronze_orders",
        "timestamp_column": "order_date",
        "primary_key": "order_id"
    },

    "loans": {
        "source_file": "loans.csv",
        "bronze_file": "loans_bronze.csv",
        "bronze_table": "bronze_loans",
        "timestamp_column": "loan_date",
        "primary_key": "loan_id"
    },

    "reviews": {
        "source_file": "reviews.csv",
        "bronze_file": "reviews_bronze.csv",
        "bronze_table": "bronze_reviews",
        "timestamp_column": "created_at",
        "primary_key": "review_id"
    }
}


# ============================================================
# CREATE BRONZE DIRECTORIES
# ============================================================

for table_name in TABLE_CONFIG:

    os.makedirs(
        os.path.join(BRONZE_DIR, table_name),
        exist_ok=True
    )


# ============================================================
# BATCH ID
# ============================================================

batch_id = datetime.now().strftime(
    "BATCH_%Y%m%d_%H%M%S"
)

print(f"Batch ID: {batch_id}")


# ============================================================
# GET WATERMARK
# ============================================================

def get_watermark(cursor, bronze_table):

    cursor.execute(
        """
        SELECT last_loaded_at
        FROM pipeline_metadata
        WHERE table_name = %s
        """,
        (bronze_table,)
    )

    result = cursor.fetchone()

    if result is None or result[0] is None:

        return datetime(2000, 1, 1)

    return result[0]


# ============================================================
# GET MYSQL TABLE COLUMNS
# ============================================================

def get_table_columns(cursor, table_name):

    cursor.execute(
        f"DESCRIBE `{table_name}`"
    )

    rows = cursor.fetchall()

    return [row[0] for row in rows]


# ============================================================
# PROCESS TABLES
# ============================================================

total_new_rows = 0


for table_name, config in TABLE_CONFIG.items():

    print("\n" + "-" * 65)
    print(f"TABLE: {table_name.upper()}")
    print("-" * 65)

    source_file = os.path.join(
        SOURCE_DIR,
        config["source_file"]
    )

    bronze_file = os.path.join(
        BRONZE_DIR,
        table_name,
        config["bronze_file"]
    )

    bronze_table = config["bronze_table"]

    timestamp_column = config["timestamp_column"]

    primary_key = config["primary_key"]


    # ========================================================
    # CHECK SOURCE FILE
    # ========================================================

    if not os.path.exists(source_file):

        print(
            f"Source file not found: {source_file}"
        )

        continue


    # ========================================================
    # READ SOURCE
    # ========================================================

    df = pd.read_csv(source_file)

    print(
        f"Source rows          : {len(df)}"
    )


    # ========================================================
    # CONVERT TIMESTAMP
    # ========================================================

    df[timestamp_column] = pd.to_datetime(
        df[timestamp_column],
        errors="coerce"
    )


    cursor = connection.cursor()


    try:

        # ====================================================
        # GET WATERMARK
        # ====================================================

        last_loaded_at = get_watermark(
            cursor,
            bronze_table
        )

        print(
            f"Previous watermark   : {last_loaded_at}"
        )


        # ====================================================
        # TIMESTAMP FILTER
        # ====================================================

        if last_loaded_at == datetime(2000, 1, 1):

            new_df = df.copy()

        else:

         new_df = df[
        (
            df[timestamp_column].notna()
            &
            (df[timestamp_column] > last_loaded_at)
        )
        |
        df[timestamp_column].isna()
    ].copy()


        # ====================================================
        # CHECK EXISTING BRONZE IDS
        # ====================================================

        cursor.execute(
            f"""
            SELECT `{primary_key}`
            FROM `{bronze_table}`
            """
        )

        existing_rows = cursor.fetchall()

        existing_ids = {
            row[0]
            for row in existing_rows
            if row[0] is not None
        }


        # ====================================================
        # REMOVE DUPLICATE IDS
        # ====================================================

        if existing_ids:

            new_df = new_df[
                ~new_df[primary_key].isin(existing_ids)
            ].copy()


        # ====================================================
        # NEW ROW COUNT
        # ====================================================

        new_rows = len(new_df)

        print(
            f"New rows             : {new_rows}"
        )


        # ====================================================
        # NO NEW RECORDS
        # ====================================================

        if new_rows == 0:

            print(
                "No new records found."
            )

            cursor.close()

            continue


        # ====================================================
        # ADD BRONZE METADATA
        # ====================================================

        ingestion_time = datetime.now()

        new_df["ingested_at"] = ingestion_time

        new_df["batch_id"] = batch_id


        # ====================================================
        # GET BRONZE TABLE COLUMNS
        # ====================================================

        bronze_columns = get_table_columns(
            cursor,
            bronze_table
        )


        # ====================================================
        # VALIDATE REQUIRED COLUMNS
        # ====================================================

        if "ingested_at" not in bronze_columns:

            raise Exception(
                f"{bronze_table} is missing ingested_at"
            )

        if "batch_id" not in bronze_columns:

            raise Exception(
                f"{bronze_table} is missing batch_id"
            )


        # ====================================================
        # COMMON COLUMNS
        # ====================================================

        insert_columns = [
            column
            for column in bronze_columns
            if column in new_df.columns
        ]


        # ====================================================
        # INSERT QUERY
        # ====================================================

        column_sql = ", ".join(
            f"`{column}`"
            for column in insert_columns
        )

        placeholders = ", ".join(
            "%s"
            for _ in insert_columns
        )

        insert_sql = f"""
            INSERT INTO `{bronze_table}`
            ({column_sql})
            VALUES ({placeholders})
        """


        # ====================================================
        # PREPARE ROWS
        # ====================================================

        rows_to_insert = []

        for _, row in new_df.iterrows():

            values = []

            for column in insert_columns:

                value = row[column]

                if pd.isna(value):

                    value = None

                elif column in [
                    timestamp_column,
                    "ingested_at"
                ]:

                    value = pd.Timestamp(
                        value
                    ).to_pydatetime()

                values.append(value)

            rows_to_insert.append(
                tuple(values)
            )


        # ====================================================
        # INSERT INTO BRONZE
        # ====================================================

        cursor.executemany(
            insert_sql,
            rows_to_insert
        )


        # ====================================================
        # NEW WATERMARK
        # ====================================================

        new_watermark = pd.Timestamp(
            new_df[timestamp_column].max()
        ).to_pydatetime()


        # ====================================================
        # UPDATE METADATA
        # ====================================================

        cursor.execute(
            """
            UPDATE pipeline_metadata
            SET
                last_loaded_at = %s,
                rows_loaded = %s,
                status = 'SUCCESS'
            WHERE table_name = %s
            """,
            (
                new_watermark,
                new_rows,
                bronze_table
            )
        )


        # ====================================================
        # COMMIT
        # ====================================================

        connection.commit()


        # ====================================================
        # WRITE BRONZE CSV
        # ====================================================

        if len(existing_ids) == 0:

            new_df.to_csv(
                bronze_file,
                mode="w",
                header=True,
                index=False
            )

        else:

            new_df.to_csv(
                bronze_file,
                mode="a",
                header=False,
                index=False
            )


        # ====================================================
        # SUCCESS
        # ====================================================

        print(
            f"Bronze rows loaded  : {new_rows}"
        )

        print(
            f"New watermark       : {new_watermark}"
        )

        print(
            f"Bronze table        : {bronze_table}"
        )

        total_new_rows += new_rows


    except Exception as error:

        connection.rollback()

        print(
            f"ERROR: {error}"
        )

        print(
            "Transaction rolled back."
        )

        try:

            cursor.execute(
                """
                UPDATE pipeline_metadata
                SET status = 'FAILED'
                WHERE table_name = %s
                """,
                (bronze_table,)
            )

            connection.commit()

        except Exception:

            connection.rollback()


    finally:

        cursor.close()


# ============================================================
# FINAL SUMMARY
# ============================================================

print("\n" + "=" * 65)
print("BRONZE INGESTION SUMMARY")
print("=" * 65)

print(
    f"Total new rows      : {total_new_rows}"
)


# ============================================================
# PIPELINE METADATA
# ============================================================

cursor = connection.cursor()

cursor.execute(
    """
    SELECT
        table_name,
        last_loaded_at,
        rows_loaded,
        status
    FROM pipeline_metadata
    ORDER BY table_name
    """
)

metadata_rows = cursor.fetchall()

print("\nPipeline metadata:")

for row in metadata_rows:

    print(
        f"{row[0]:20} : "
        f"{row[1]} | "
        f"rows={row[2]} | "
        f"status={row[3]}"
    )

cursor.close()


# ============================================================
# CLOSE CONNECTION
# ============================================================

connection.close()

print("\nMySQL connection closed.")

print("\nBronze ingestion completed.")

print("=" * 65)