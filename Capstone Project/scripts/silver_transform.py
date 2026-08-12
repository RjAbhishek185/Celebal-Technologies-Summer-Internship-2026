import pandas as pd
import os
from datetime import datetime


# ============================================================
# CITYREADS - SILVER LAYER
# DATA CLEANING + VALIDATION + DEDUPLICATION
# ============================================================

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

BRONZE_DIR = os.path.join(BASE_DIR, "data", "bronze")
SILVER_DIR = os.path.join(BASE_DIR, "data", "silver")

REJECTED_DIR = os.path.join(
    SILVER_DIR,
    "rejected"
)


# ------------------------------------------------------------
# CREATE DIRECTORIES
# ------------------------------------------------------------

for folder in [
    "books",
    "customers",
    "orders",
    "loans",
    "reviews",
    "rejected"
]:

    os.makedirs(
        os.path.join(SILVER_DIR, folder),
        exist_ok=True
    )


# ------------------------------------------------------------
# REJECTION STORAGE
# ------------------------------------------------------------

rejected_rows = []


def reject_rows(
    df,
    table_name,
    reason,
    id_column
):

    if len(df) == 0:
        return

    for _, row in df.iterrows():

        rejected_rows.append({
            "table_name": table_name,
            "source_id": row.get(id_column),
            "rejection_reason": reason,
            "rejected_at": datetime.now().isoformat()
        })


# ============================================================
# 1. BOOKS
# ============================================================

print("=" * 70)
print("SILVER TRANSFORMATION")
print("=" * 70)

print("\nBOOKS")
print("-" * 70)

books_file = os.path.join(
    BRONZE_DIR,
    "books",
    "books_bronze.csv"
)

books = pd.read_csv(books_file)

print("Bronze rows:", len(books))


# Deduplicate
before = len(books)

books = books.sort_values(
    "_ingestion_timestamp"
)

books = books.drop_duplicates(
    subset=["book_id"],
    keep="last"
)

print(
    "Duplicates removed:",
    before - len(books)
)


# Standardization

books["title"] = (
    books["title"]
    .astype(str)
    .str.strip()
)

books["author"] = (
    books["author"]
    .astype(str)
    .str.strip()
)

books["genre"] = (
    books["genre"]
    .astype(str)
    .str.strip()
    .str.title()
)

books["price"] = pd.to_numeric(
    books["price"],
    errors="coerce"
)

books["stock"] = pd.to_numeric(
    books["stock"],
    errors="coerce"
)


books.to_csv(
    os.path.join(
        SILVER_DIR,
        "books",
        "books_silver.csv"
    ),
    index=False
)

print("Silver books:", len(books))


# ============================================================
# 2. CUSTOMERS
# ============================================================

print("\nCUSTOMERS")
print("-" * 70)

customers_file = os.path.join(
    BRONZE_DIR,
    "customers",
    "customers_bronze.csv"
)

customers = pd.read_csv(
    customers_file
)

print("Bronze rows:", len(customers))


# Missing email

invalid_email = customers[
    customers["email"].isna()
]

reject_rows(
    invalid_email,
    "customers",
    "NULL_EMAIL",
    "customer_id"
)

customers = customers[
    customers["email"].notna()
].copy()


# Membership validation

valid_memberships = [
    "BASIC",
    "PREMIUM",
    "LIBRARY"
]

customers["membership"] = (
    customers["membership"]
    .astype(str)
    .str.upper()
    .str.strip()
)

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


# Email standardization

customers["email"] = (
    customers["email"]
    .astype(str)
    .str.lower()
    .str.strip()
)


# Deduplicate

before = len(customers)

customers = customers.sort_values(
    "_ingestion_timestamp"
)

customers = customers.drop_duplicates(
    subset=["customer_id"],
    keep="last"
)

print(
    "Duplicates removed:",
    before - len(customers)
)


customers.to_csv(
    os.path.join(
        SILVER_DIR,
        "customers",
        "customers_silver.csv"
    ),
    index=False
)

print("Silver customers:", len(customers))


# ============================================================
# 3. ORDERS
# ============================================================

print("\nORDERS")
print("-" * 70)

orders_file = os.path.join(
    BRONZE_DIR,
    "orders",
    "orders_bronze.csv"
)

orders = pd.read_csv(
    orders_file
)

print("Bronze rows:", len(orders))


# Quantity validation

orders["quantity"] = pd.to_numeric(
    orders["quantity"],
    errors="coerce"
)

invalid_quantity = orders[
    orders["quantity"].isna()
    | (orders["quantity"] <= 0)
]

reject_rows(
    invalid_quantity,
    "orders",
    "INVALID_QUANTITY",
    "order_id"
)

orders = orders[
    orders["quantity"].notna()
    & (orders["quantity"] > 0)
].copy()


# Status validation

valid_status = [
    "PENDING",
    "SHIPPED",
    "DELIVERED",
    "CANCELLED"
]

orders["status"] = (
    orders["status"]
    .astype(str)
    .str.upper()
    .str.strip()
)

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


# Date conversion

orders["order_date"] = pd.to_datetime(
    orders["order_date"],
    errors="coerce"
)

invalid_dates = orders[
    orders["order_date"].isna()
]

reject_rows(
    invalid_dates,
    "orders",
    "INVALID_ORDER_DATE",
    "order_id"
)

orders = orders[
    orders["order_date"].notna()
].copy()


# Deduplicate

before = len(orders)

orders = orders.sort_values(
    "_ingestion_timestamp"
)

orders = orders.drop_duplicates(
    subset=["order_id"],
    keep="last"
)

print(
    "Duplicates removed:",
    before - len(orders)
)


# Derived column

# For now, quantity is retained.
# Revenue will be calculated later in Gold
# using the book price.

orders.to_csv(
    os.path.join(
        SILVER_DIR,
        "orders",
        "orders_silver.csv"
    ),
    index=False
)

print("Silver orders:", len(orders))


# ============================================================
# 4. LOANS
# ============================================================

print("\nLOANS")
print("-" * 70)

loans_file = os.path.join(
    BRONZE_DIR,
    "loans",
    "loans_bronze.csv"
)

loans = pd.read_csv(
    loans_file
)

print("Bronze rows:", len(loans))


# Date conversion

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


# Due date validation

invalid_due_date = loans[
    loans["due_date"].isna()
    | loans["loan_date"].isna()
    | (loans["due_date"] <= loans["loan_date"])
]

reject_rows(
    invalid_due_date,
    "loans",
    "INVALID_DUE_DATE",
    "loan_id"
)

loans = loans[
    loans["loan_date"].notna()
    & loans["due_date"].notna()
    & (loans["due_date"] > loans["loan_date"])
].copy()


# Deduplicate

before = len(loans)

loans = loans.sort_values(
    "_ingestion_timestamp"
)

loans = loans.drop_duplicates(
    subset=["loan_id"],
    keep="last"
)

print(
    "Duplicates removed:",
    before - len(loans)
)


# Days overdue

today = pd.Timestamp.today().normalize()

effective_return = loans["return_date"].fillna(today)

loans["days_overdue"] = (
    effective_return - loans["due_date"]
).dt.days.clip(lower=0)


# Overdue category

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


loans.to_csv(
    os.path.join(
        SILVER_DIR,
        "loans",
        "loans_silver.csv"
    ),
    index=False
)

print("Silver loans:", len(loans))


# ============================================================
# 5. REVIEWS
# ============================================================

print("\nREVIEWS")
print("-" * 70)

reviews_file = os.path.join(
    BRONZE_DIR,
    "reviews",
    "reviews_bronze.csv"
)

reviews = pd.read_csv(
    reviews_file
)

print("Bronze rows:", len(reviews))


# Rating validation

reviews["rating"] = pd.to_numeric(
    reviews["rating"],
    errors="coerce"
)

invalid_rating = reviews[
    reviews["rating"].isna()
    | ~reviews["rating"].between(1, 5)
]

reject_rows(
    invalid_rating,
    "reviews",
    "INVALID_RATING",
    "review_id"
)

reviews = reviews[
    reviews["rating"].notna()
    & reviews["rating"].between(1, 5)
].copy()


# Date conversion

reviews["created_at"] = pd.to_datetime(
    reviews["created_at"],
    errors="coerce"
)


# Deduplicate

before = len(reviews)

reviews = reviews.sort_values(
    "_ingestion_timestamp"
)

reviews = reviews.drop_duplicates(
    subset=["review_id"],
    keep="last"
)

print(
    "Duplicates removed:",
    before - len(reviews)
)


reviews.to_csv(
    os.path.join(
        SILVER_DIR,
        "reviews",
        "reviews_silver.csv"
    ),
    index=False
)

print("Silver reviews:", len(reviews))


# ============================================================
# SAVE REJECTED ROWS
# ============================================================

rejected_df = pd.DataFrame(
    rejected_rows
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