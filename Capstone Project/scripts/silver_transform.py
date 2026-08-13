# ============================================================
# CITYREADS - SILVER LAYER TRANSFORMATION
# Celebal Technologies Summer Internship 2026
# ============================================================
#
# Bronze
#    ↓
# Deduplication
#    ↓
# Data Quality Validation
#    ↓
# Rejected Records
#    ↓
# Standardization
#    ↓
# Enrichment
#    ↓
# Silver
#
# Required Silver concepts:
# - Deduplication using ingested_at
# - Null validation
# - Foreign-key validation
# - Range/value validation
# - Standardization
# - order_value
# - days_overdue
# - overdue_category
# - silver_rejected_rows
# ============================================================

import pandas as pd
import os
from datetime import datetime


# ============================================================
# PROJECT PATHS
# ============================================================

BASE_DIR = os.path.dirname(
    os.path.dirname(
        os.path.abspath(__file__)
    )
)

BRONZE_DIR = os.path.join(
    BASE_DIR,
    "data",
    "bronze"
)

SILVER_DIR = os.path.join(
    BASE_DIR,
    "data",
    "silver"
)

REJECTED_DIR = os.path.join(
    SILVER_DIR,
    "rejected"
)


# ============================================================
# CREATE DIRECTORIES
# ============================================================

for folder in [
    "books",
    "customers",
    "orders",
    "loans",
    "reviews",
    "rejected"
]:

    os.makedirs(
        os.path.join(
            SILVER_DIR,
            folder
        ),
        exist_ok=True
    )


# ============================================================
# REJECTION STORAGE
# ============================================================

rejected_rows = []


def reject_rows(
    df,
    table_name,
    reason,
    id_column
):

    if df.empty:
        return

    for _, row in df.iterrows():

        rejected_rows.append({

            "table_name": table_name,

            "source_id": row.get(
                id_column
            ),

            "rejection_reason": reason,

            "rejected_at": datetime.now().strftime(
                "%Y-%m-%d %H:%M:%S"
            )
        })


# ============================================================
# HELPER FUNCTION
# ============================================================

def load_bronze(
    table_name,
    file_name
):

    file_path = os.path.join(
        BRONZE_DIR,
        table_name,
        file_name
    )

    if not os.path.exists(file_path):

        raise FileNotFoundError(
            f"Bronze file not found: {file_path}"
        )

    return pd.read_csv(
        file_path
    )


# ============================================================
# START
# ============================================================

print()
print("=" * 70)
print("CITYREADS - SILVER LAYER TRANSFORMATION")
print("=" * 70)


# ============================================================
# 1. BOOKS
# ============================================================

print()
print("BOOKS")
print("-" * 70)

books = load_bronze(
    "books",
    "books_bronze.csv"
)

print(
    "Bronze rows:",
    len(books)
)


# ------------------------------------------------------------
# Convert data types
# ------------------------------------------------------------

books["book_id"] = pd.to_numeric(
    books["book_id"],
    errors="coerce"
)

books["price"] = pd.to_numeric(
    books["price"],
    errors="coerce"
)

books["stock"] = pd.to_numeric(
    books["stock"],
    errors="coerce"
)

books["published_on"] = pd.to_datetime(
    books["published_on"],
    errors="coerce"
)


# ------------------------------------------------------------
# Standardize text
# ------------------------------------------------------------

for column in [
    "title",
    "author"
]:

    books[column] = (
        books[column]
        .fillna("")
        .astype(str)
        .str.strip()
    )


books["genre"] = (
    books["genre"]
    .fillna("")
    .astype(str)
    .str.strip()
    .str.title()
)


# ------------------------------------------------------------
# Validation
# ------------------------------------------------------------

invalid_book_id = books[
    books["book_id"].isna()
]

reject_rows(
    invalid_book_id,
    "books",
    "NULL_BOOK_ID",
    "book_id"
)

books = books[
    books["book_id"].notna()
].copy()


invalid_price = books[
    books["price"].isna()
    |
    (books["price"] <= 0)
]

reject_rows(
    invalid_price,
    "books",
    "INVALID_PRICE",
    "book_id"
)

books = books[
    books["price"].notna()
    &
    (books["price"] > 0)
].copy()


invalid_stock = books[
    books["stock"].isna()
    |
    (books["stock"] < 0)
]

reject_rows(
    invalid_stock,
    "books",
    "INVALID_STOCK",
    "book_id"
)

books = books[
    books["stock"].notna()
    &
    (books["stock"] >= 0)
].copy()


# ------------------------------------------------------------
# Deduplication
# ------------------------------------------------------------

books["ingested_at"] = pd.to_datetime(
    books["ingested_at"],
    errors="coerce"
)

books = books.sort_values(
    "ingested_at"
)

before = len(books)

books = books.drop_duplicates(
    subset=["book_id"],
    keep="last"
)

print(
    "Duplicates removed:",
    before - len(books)
)


# ------------------------------------------------------------
# Save Silver
# ------------------------------------------------------------

books.to_csv(
    os.path.join(
        SILVER_DIR,
        "books",
        "books_silver.csv"
    ),
    index=False
)

print(
    "Silver books:",
    len(books)
)


# ============================================================
# 2. CUSTOMERS
# ============================================================

print()
print("CUSTOMERS")
print("-" * 70)

customers = load_bronze(
    "customers",
    "customers_bronze.csv"
)

print(
    "Bronze rows:",
    len(customers)
)


# ------------------------------------------------------------
# Standardization
# ------------------------------------------------------------

customers["name"] = (
    customers["name"]
    .fillna("")
    .astype(str)
    .str.strip()
)

customers["city"] = (
    customers["city"]
    .fillna("")
    .astype(str)
    .str.strip()
)

customers["email"] = (
    customers["email"]
    .fillna("")
    .astype(str)
    .str.strip()
    .str.lower()
)

customers["membership"] = (
    customers["membership"]
    .fillna("")
    .astype(str)
    .str.strip()
    .str.upper()
)


# ------------------------------------------------------------
# Email validation
# ------------------------------------------------------------

invalid_email = customers[
    customers["email"].eq("")
]

reject_rows(
    invalid_email,
    "customers",
    "NULL_EMAIL",
    "customer_id"
)

customers = customers[
    customers["email"] != ""
].copy()


# ------------------------------------------------------------
# Membership validation
# ------------------------------------------------------------

valid_memberships = [
    "BASIC",
    "PREMIUM",
    "LIBRARY"
]

invalid_membership = customers[
    ~customers["membership"].isin(
        valid_memberships
    )
]

reject_rows(
    invalid_membership,
    "customers",
    "INVALID_MEMBERSHIP",
    "customer_id"
)

customers = customers[
    customers["membership"].isin(
        valid_memberships
    )
].copy()


# ------------------------------------------------------------
# Customer ID validation
# ------------------------------------------------------------

customers["customer_id"] = pd.to_numeric(
    customers["customer_id"],
    errors="coerce"
)

invalid_customer_id = customers[
    customers["customer_id"].isna()
]

reject_rows(
    invalid_customer_id,
    "customers",
    "NULL_CUSTOMER_ID",
    "customer_id"
)

customers = customers[
    customers["customer_id"].notna()
].copy()


# ------------------------------------------------------------
# Deduplication
# ------------------------------------------------------------

customers["ingested_at"] = pd.to_datetime(
    customers["ingested_at"],
    errors="coerce"
)

customers = customers.sort_values(
    "ingested_at"
)

before = len(customers)

customers = customers.drop_duplicates(
    subset=["customer_id"],
    keep="last"
)

print(
    "Duplicates removed:",
    before - len(customers)
)


# ------------------------------------------------------------
# Save Silver
# ------------------------------------------------------------

customers.to_csv(
    os.path.join(
        SILVER_DIR,
        "customers",
        "customers_silver.csv"
    ),
    index=False
)

print(
    "Silver customers:",
    len(customers)
)


# ============================================================
# 3. ORDERS
# ============================================================

print()
print("ORDERS")
print("-" * 70)

orders = load_bronze(
    "orders",
    "orders_bronze.csv"
)

print(
    "Bronze rows:",
    len(orders)
)


# ------------------------------------------------------------
# Convert data types
# ------------------------------------------------------------

orders["order_id"] = pd.to_numeric(
    orders["order_id"],
    errors="coerce"
)

orders["customer_id"] = pd.to_numeric(
    orders["customer_id"],
    errors="coerce"
)

orders["book_id"] = pd.to_numeric(
    orders["book_id"],
    errors="coerce"
)

orders["quantity"] = pd.to_numeric(
    orders["quantity"],
    errors="coerce"
)

orders["order_date"] = pd.to_datetime(
    orders["order_date"],
    errors="coerce"
)


# ------------------------------------------------------------
# Standardize status
# ------------------------------------------------------------

orders["status"] = (
    orders["status"]
    .fillna("")
    .astype(str)
    .str.strip()
    .str.upper()
)


# ------------------------------------------------------------
# Quantity validation
# ------------------------------------------------------------

invalid_quantity = orders[
    orders["quantity"].isna()
    |
    (orders["quantity"] <= 0)
]

reject_rows(
    invalid_quantity,
    "orders",
    "INVALID_QUANTITY",
    "order_id"
)

orders = orders[
    orders["quantity"].notna()
    &
    (orders["quantity"] > 0)
].copy()


# ------------------------------------------------------------
# Status validation
# ------------------------------------------------------------

valid_status = [
    "PENDING",
    "SHIPPED",
    "DELIVERED",
    "CANCELLED"
]

invalid_status = orders[
    ~orders["status"].isin(
        valid_status
    )
]

reject_rows(
    invalid_status,
    "orders",
    "INVALID_STATUS",
    "order_id"
)

orders = orders[
    orders["status"].isin(
        valid_status
    )
].copy()


# ------------------------------------------------------------
# Order date validation
# ------------------------------------------------------------

invalid_order_date = orders[
    orders["order_date"].isna()
]

reject_rows(
    invalid_order_date,
    "orders",
    "INVALID_ORDER_DATE",
    "order_id"
)

orders = orders[
    orders["order_date"].notna()
].copy()


# ------------------------------------------------------------
# Customer FK validation
# ------------------------------------------------------------

customer_ids = set(
    customers["customer_id"]
)

invalid_customer_fk = orders[
    ~orders["customer_id"].isin(
        customer_ids
    )
]

reject_rows(
    invalid_customer_fk,
    "orders",
    "INVALID_CUSTOMER_FK",
    "order_id"
)

orders = orders[
    orders["customer_id"].isin(
        customer_ids
    )
].copy()


# ------------------------------------------------------------
# Book FK validation
# ------------------------------------------------------------

book_ids = set(
    books["book_id"]
)

invalid_book_fk = orders[
    ~orders["book_id"].isin(
        book_ids
    )
]

reject_rows(
    invalid_book_fk,
    "orders",
    "INVALID_BOOK_FK",
    "order_id"
)

orders = orders[
    orders["book_id"].isin(
        book_ids
    )
].copy()


# ------------------------------------------------------------
# Deduplication
# ------------------------------------------------------------

orders["ingested_at"] = pd.to_datetime(
    orders["ingested_at"],
    errors="coerce"
)

orders = orders.sort_values(
    "ingested_at"
)

before = len(orders)

orders = orders.drop_duplicates(
    subset=["order_id"],
    keep="last"
)

print(
    "Duplicates removed:",
    before - len(orders)
)


# ------------------------------------------------------------
# Derive order_value
# ------------------------------------------------------------

book_prices = books[
    [
        "book_id",
        "price"
    ]
].drop_duplicates(
    subset=["book_id"]
)

orders = orders.merge(
    book_prices,
    on="book_id",
    how="left"
)

orders["order_value"] = (
    orders["quantity"]
    *
    orders["price"]
)


# ------------------------------------------------------------
# Save Silver
# ------------------------------------------------------------

orders.to_csv(
    os.path.join(
        SILVER_DIR,
        "orders",
        "orders_silver.csv"
    ),
    index=False
)

print(
    "Silver orders:",
    len(orders)
)


# ============================================================
# 4. LOANS
# ============================================================

print()
print("LOANS")
print("-" * 70)

loans = load_bronze(
    "loans",
    "loans_bronze.csv"
)

print(
    "Bronze rows:",
    len(loans)
)


# ------------------------------------------------------------
# Convert IDs
# ------------------------------------------------------------

loans["loan_id"] = pd.to_numeric(
    loans["loan_id"],
    errors="coerce"
)

loans["customer_id"] = pd.to_numeric(
    loans["customer_id"],
    errors="coerce"
)

loans["book_id"] = pd.to_numeric(
    loans["book_id"],
    errors="coerce"
)


# ------------------------------------------------------------
# Convert dates
# ------------------------------------------------------------

loans["loan_date"] = pd.to_datetime(
    loans["loan_date"],
    errors="coerce"
)

loans["due_date"] = pd.to_datetime(
    loans["due_date"],
    errors="coerce"
)

loans["return_date"] = pd.to_datetime(
    loans["return_date"],
    errors="coerce"
)


# ------------------------------------------------------------
# Due date validation
# ------------------------------------------------------------

invalid_due_date = loans[
    loans["loan_date"].isna()
    |
    loans["due_date"].isna()
    |
    (loans["due_date"] <= loans["loan_date"])
]

reject_rows(
    invalid_due_date,
    "loans",
    "INVALID_DUE_DATE",
    "loan_id"
)

loans = loans[
    loans["loan_date"].notna()
    &
    loans["due_date"].notna()
    &
    (loans["due_date"] > loans["loan_date"])
].copy()


# ------------------------------------------------------------
# Customer FK validation
# ------------------------------------------------------------

invalid_loan_customer_fk = loans[
    ~loans["customer_id"].isin(
        customer_ids
    )
]

reject_rows(
    invalid_loan_customer_fk,
    "loans",
    "INVALID_CUSTOMER_FK",
    "loan_id"
)

loans = loans[
    loans["customer_id"].isin(
        customer_ids
    )
].copy()


# ------------------------------------------------------------
# Book FK validation
# ------------------------------------------------------------

invalid_loan_book_fk = loans[
    ~loans["book_id"].isin(
        book_ids
    )
]

reject_rows(
    invalid_loan_book_fk,
    "loans",
    "INVALID_BOOK_FK",
    "loan_id"
)

loans = loans[
    loans["book_id"].isin(
        book_ids
    )
].copy()


# ------------------------------------------------------------
# Return date validation
# ------------------------------------------------------------

invalid_return_date = loans[
    loans["return_date"].notna()
    &
    (
        loans["return_date"]
        <
        loans["loan_date"]
    )
]

reject_rows(
    invalid_return_date,
    "loans",
    "INVALID_RETURN_DATE",
    "loan_id"
)

loans = loans[
    loans["return_date"].isna()
    |
    (
        loans["return_date"]
        >=
        loans["loan_date"]
    )
].copy()


# ------------------------------------------------------------
# Deduplication
# ------------------------------------------------------------

loans["ingested_at"] = pd.to_datetime(
    loans["ingested_at"],
    errors="coerce"
)

loans = loans.sort_values(
    "ingested_at"
)

before = len(loans)

loans = loans.drop_duplicates(
    subset=["loan_id"],
    keep="last"
)

print(
    "Duplicates removed:",
    before - len(loans)
)


# ------------------------------------------------------------
# Days overdue
# ------------------------------------------------------------

today = pd.Timestamp.today().normalize()

effective_return = loans[
    "return_date"
].fillna(today)

loans["days_overdue"] = (
    effective_return
    -
    loans["due_date"]
).dt.days.clip(
    lower=0
)


# ------------------------------------------------------------
# Overdue category
# ------------------------------------------------------------

def overdue_category(days):

    if days == 0:
        return "ON TIME"

    elif days <= 7:
        return "MILD"

    elif days <= 30:
        return "SEVERE"

    else:
        return "CRITICAL"


loans["overdue_category"] = (
    loans["days_overdue"]
    .apply(overdue_category)
)


# ------------------------------------------------------------
# Save Silver
# ------------------------------------------------------------

loans.to_csv(
    os.path.join(
        SILVER_DIR,
        "loans",
        "loans_silver.csv"
    ),
    index=False
)

print(
    "Silver loans:",
    len(loans)
)


# ============================================================
# 5. REVIEWS
# ============================================================

print()
print("REVIEWS")
print("-" * 70)

reviews = load_bronze(
    "reviews",
    "reviews_bronze.csv"
)

print(
    "Bronze rows:",
    len(reviews)
)


# ------------------------------------------------------------
# Convert IDs
# ------------------------------------------------------------

reviews["review_id"] = pd.to_numeric(
    reviews["review_id"],
    errors="coerce"
)

reviews["customer_id"] = pd.to_numeric(
    reviews["customer_id"],
    errors="coerce"
)

reviews["book_id"] = pd.to_numeric(
    reviews["book_id"],
    errors="coerce"
)

reviews["rating"] = pd.to_numeric(
    reviews["rating"],
    errors="coerce"
)


# ------------------------------------------------------------
# Rating validation
# ------------------------------------------------------------

invalid_rating = reviews[
    reviews["rating"].isna()
    |
    ~reviews["rating"].between(
        1,
        5
    )
]

reject_rows(
    invalid_rating,
    "reviews",
    "INVALID_RATING",
    "review_id"
)

reviews = reviews[
    reviews["rating"].notna()
    &
    reviews["rating"].between(
        1,
        5
    )
].copy()


# ------------------------------------------------------------
# Created date
# ------------------------------------------------------------

reviews["created_at"] = pd.to_datetime(
    reviews["created_at"],
    errors="coerce"
)


# ------------------------------------------------------------
# Customer FK
# ------------------------------------------------------------

invalid_review_customer_fk = reviews[
    ~reviews["customer_id"].isin(
        customer_ids
    )
]

reject_rows(
    invalid_review_customer_fk,
    "reviews",
    "INVALID_CUSTOMER_FK",
    "review_id"
)

reviews = reviews[
    reviews["customer_id"].isin(
        customer_ids
    )
].copy()


# ------------------------------------------------------------
# Book FK
# ------------------------------------------------------------

invalid_review_book_fk = reviews[
    ~reviews["book_id"].isin(
        book_ids
    )
]

reject_rows(
    invalid_review_book_fk,
    "reviews",
    "INVALID_BOOK_FK",
    "review_id"
)

reviews = reviews[
    reviews["book_id"].isin(
        book_ids
    )
].copy()


# ------------------------------------------------------------
# Deduplication
# ------------------------------------------------------------

reviews["ingested_at"] = pd.to_datetime(
    reviews["ingested_at"],
    errors="coerce"
)

reviews = reviews.sort_values(
    "ingested_at"
)

before = len(reviews)

reviews = reviews.drop_duplicates(
    subset=["review_id"],
    keep="last"
)

print(
    "Duplicates removed:",
    before - len(reviews)
)


# ------------------------------------------------------------
# Standardize review text
# ------------------------------------------------------------

if "review_text" in reviews.columns:

    reviews["review_text"] = (
        reviews["review_text"]
        .fillna("")
        .astype(str)
        .str.strip()
    )


# ------------------------------------------------------------
# Save Silver
# ------------------------------------------------------------

reviews.to_csv(
    os.path.join(
        SILVER_DIR,
        "reviews",
        "reviews_silver.csv"
    ),
    index=False
)

print(
    "Silver reviews:",
    len(reviews)
)


# ============================================================
# SAVE REJECTED ROWS
# ============================================================

rejected_df = pd.DataFrame(
    rejected_rows,
    columns=[
        "table_name",
        "source_id",
        "rejection_reason",
        "rejected_at"
    ]
)

rejected_file = os.path.join(
    REJECTED_DIR,
    "silver_rejected_rows.csv"
)

rejected_df.to_csv(
    rejected_file,
    index=False
)


# ============================================================
# FINAL SUMMARY
# ============================================================

print()
print("=" * 70)
print("SILVER TRANSFORMATION COMPLETED")
print("=" * 70)

print(
    f"Total rejected rows : {len(rejected_df)}"
)

print(
    f"Rejected file       : {rejected_file}"
)

print()
print("Silver output:")
print(
    "Books       :",
    len(books)
)

print(
    "Customers   :",
    len(customers)
)

print(
    "Orders      :",
    len(orders)
)

print(
    "Loans       :",
    len(loans)
)

print(
    "Reviews     :",
    len(reviews)
)

print("=" * 70)

# ============================================================
# SYNC SILVER CSV OUTPUTS TO MYSQL SILVER TABLES
# ============================================================

import mysql.connector
from getpass import getpass

print()
print("=" * 70)
print("SYNCING SILVER LAYER TO MYSQL")
print("=" * 70)

MYSQL_PASSWORD = getpass("Enter MySQL root password: ")

mysql_connection = mysql.connector.connect(
    host="localhost",
    port=3306,
    user="root",
    password=MYSQL_PASSWORD,
    database="cityreads"
)

print("MySQL connection successful.")


# ============================================================
# SILVER TABLE CONFIGURATION
# ============================================================

SILVER_TABLES = {

    "books": {
        "mysql_table": "books_silver",
        "csv_file": os.path.join(
            SILVER_DIR,
            "books",
            "books_silver.csv"
        ),
        "id_column": "book_id"
    },

    "customers": {
        "mysql_table": "customers_silver",
        "csv_file": os.path.join(
            SILVER_DIR,
            "customers",
            "customers_silver.csv"
        ),
        "id_column": "customer_id"
    },

    "orders": {
        "mysql_table": "orders_silver",
        "csv_file": os.path.join(
            SILVER_DIR,
            "orders",
            "orders_silver.csv"
        ),
        "id_column": "order_id"
    },

    "loans": {
        "mysql_table": "loans_silver",
        "csv_file": os.path.join(
            SILVER_DIR,
            "loans",
            "loans_silver.csv"
        ),
        "id_column": "loan_id"
    },

    "reviews": {
        "mysql_table": "reviews_silver",
        "csv_file": os.path.join(
            SILVER_DIR,
            "reviews",
            "reviews_silver.csv"
        ),
        "id_column": "review_id"
    }
}


# ============================================================
# FUNCTION: GET MYSQL COLUMNS
# ============================================================

def get_mysql_columns(cursor, table_name):

    cursor.execute(
        f"DESCRIBE `{table_name}`"
    )

    rows = cursor.fetchall()

    return [
        row[0]
        for row in rows
    ]


# ============================================================
# FUNCTION: CONVERT VALUES
# ============================================================

def clean_value(value):

    if pd.isna(value):
        return None

    if isinstance(value, pd.Timestamp):
        return value.to_pydatetime()

    return value


# ============================================================
# SYNC EACH SILVER TABLE
# ============================================================

for name, config in SILVER_TABLES.items():

    table_name = config["mysql_table"]
    csv_file = config["csv_file"]

    print()
    print("-" * 70)
    print(f"TABLE: {table_name}")
    print("-" * 70)


    # ========================================================
    # CHECK CSV
    # ========================================================

    if not os.path.exists(csv_file):

        print(
            f"CSV not found: {csv_file}"
        )

        continue


    # ========================================================
    # READ SILVER CSV
    # ========================================================

    silver_df = pd.read_csv(
        csv_file
    )

    print(
        f"CSV rows: {len(silver_df)}"
    )


    cursor = mysql_connection.cursor()


    try:

        # ====================================================
        # GET MYSQL COLUMNS
        # ====================================================

        mysql_columns = get_mysql_columns(
            cursor,
            table_name
        )


        # ====================================================
        # COMMON COLUMNS
        # ====================================================

        insert_columns = [
            column
            for column in mysql_columns
            if column in silver_df.columns
        ]


        if not insert_columns:

            raise Exception(
                f"No matching columns found for {table_name}"
            )


        # ====================================================
        # CHECK FOR REQUIRED MYSQL COLUMNS
        # ====================================================

        missing_mysql_columns = [
            column
            for column in mysql_columns
            if column not in silver_df.columns
            and column not in [
                "id",
                "created_at"
            ]
        ]

        if missing_mysql_columns:

            print(
                "Warning - MySQL columns not present in CSV:"
            )

            print(
                missing_mysql_columns
            )


        # ====================================================
        # DELETE EXISTING SILVER DATA
        # ====================================================

        cursor.execute(
            f"DELETE FROM `{table_name}`"
        )

        mysql_connection.commit()


        # ====================================================
        # CREATE INSERT QUERY
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
            INSERT INTO `{table_name}`
            ({column_sql})
            VALUES ({placeholders})
        """


        # ====================================================
        # PREPARE DATA
        # ====================================================

        rows_to_insert = []

        for _, row in silver_df.iterrows():

            values = []

            for column in insert_columns:

                values.append(
                    clean_value(
                        row[column]
                    )
                )

            rows_to_insert.append(
                tuple(values)
            )


        # ====================================================
        # INSERT DATA
        # ====================================================

        if rows_to_insert:

            cursor.executemany(
                insert_sql,
                rows_to_insert
            )

            mysql_connection.commit()


        # ====================================================
        # VERIFY MYSQL COUNT
        # ====================================================

        cursor.execute(
            f"""
            SELECT COUNT(*)
            FROM `{table_name}`
            """
        )

        mysql_count = cursor.fetchone()[0]


        print(
            f"CSV rows loaded   : {len(silver_df)}"
        )

        print(
            f"MySQL rows        : {mysql_count}"
        )


        if mysql_count == len(silver_df):

            print(
                "STATUS            : SUCCESS"
            )

        else:

            print(
                "STATUS            : COUNT MISMATCH"
            )


    except Exception as error:

        mysql_connection.rollback()

        print(
            f"ERROR: {error}"
        )


    finally:

        cursor.close()


# ============================================================
# SYNC REJECTED RECORDS
# ============================================================

print()
print("-" * 70)
print("TABLE: silver_rejected_rows")
print("-" * 70)

rejected_csv = os.path.join(
    REJECTED_DIR,
    "silver_rejected_rows.csv"
)

if os.path.exists(rejected_csv):

    rejected_df = pd.read_csv(
        rejected_csv
    )

    cursor = mysql_connection.cursor()

    try:

        rejected_table = "silver_rejected_rows"

        mysql_columns = get_mysql_columns(
            cursor,
            rejected_table
        )

        insert_columns = [
            column
            for column in mysql_columns
            if column in rejected_df.columns
        ]

        cursor.execute(
            f"DELETE FROM `{rejected_table}`"
        )

        mysql_connection.commit()

        column_sql = ", ".join(
            f"`{column}`"
            for column in insert_columns
        )

        placeholders = ", ".join(
            "%s"
            for _ in insert_columns
        )

        insert_sql = f"""
            INSERT INTO `{rejected_table}`
            ({column_sql})
            VALUES ({placeholders})
        """

        rows_to_insert = []

        for _, row in rejected_df.iterrows():

            values = []

            for column in insert_columns:

                values.append(
                    clean_value(
                        row[column]
                    )
                )

            rows_to_insert.append(
                tuple(values)
            )

        if rows_to_insert:

            cursor.executemany(
                insert_sql,
                rows_to_insert
            )

            mysql_connection.commit()

        cursor.execute(
            f"""
            SELECT COUNT(*)
            FROM `{rejected_table}`
            """
        )

        rejected_mysql_count = cursor.fetchone()[0]

        print(
            f"CSV rejected rows : {len(rejected_df)}"
        )

        print(
            f"MySQL rows        : {rejected_mysql_count}"
        )

        if rejected_mysql_count == len(rejected_df):

            print(
                "STATUS            : SUCCESS"
            )

        else:

            print(
                "STATUS            : COUNT MISMATCH"
            )

    except Exception as error:

        mysql_connection.rollback()

        print(
            f"ERROR: {error}"
        )

    finally:

        cursor.close()


# ============================================================
# FINAL MYSQL SILVER VALIDATION
# ============================================================

print()
print("=" * 70)
print("FINAL MYSQL SILVER VALIDATION")
print("=" * 70)

cursor = mysql_connection.cursor()

for table_name in [
    "books_silver",
    "customers_silver",
    "orders_silver",
    "loans_silver",
    "reviews_silver",
    "silver_rejected_rows"
]:

    cursor.execute(
        f"""
        SELECT COUNT(*)
        FROM `{table_name}`
        """
    )

    count = cursor.fetchone()[0]

    print(
        f"{table_name:25} : {count}"
    )

cursor.close()

mysql_connection.close()

print()
print("MySQL connection closed.")

print("=" * 70)
print("SILVER MYSQL SYNC COMPLETED")
print("=" * 70)