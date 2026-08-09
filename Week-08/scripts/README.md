```markdown
# Scripts

This folder contains the Python scripts used to build and execute the E-Commerce Order Analytics System.

## Scripts

| Script | Purpose |
|---|---|
| `generate_data.py` | Generates realistic raw datasets |
| `verify_data.py` | Verifies data quality and identifies issues |
| `clean_data.py` | Cleans and validates datasets |
| `load_database.py` | Loads cleaned data into SQLite |
| `run_sql.py` | Executes SQL analytical queries |
| `report_cli.py` | Generates daily, weekly and monthly reports |
| `test_edge_cases.py` | Tests important edge cases |

## Execution Order

Run the scripts in the following order:

```text
generate_data.py
        ↓
verify_data.py
        ↓
clean_data.py
        ↓
load_database.py
        ↓
run_sql.py
        ↓
report_cli.py
        ↓
test_edge_cases.py
