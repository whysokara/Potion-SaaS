import os
import pandas as pd
from snowflake.connector.pandas_tools import write_pandas
import snowflake.connector
from dotenv import load_dotenv
from pathlib import Path

# Load environment variables
load_dotenv()

# Snowflake Connection Parameters
SNOWFLAKE_ACCOUNT = os.getenv("SNOWFLAKE_ACCOUNT")
SNOWFLAKE_USER = os.getenv("SNOWFLAKE_USER")
SNOWFLAKE_PASSWORD = os.getenv("SNOWFLAKE_PASSWORD")
SNOWFLAKE_WAREHOUSE = os.getenv("SNOWFLAKE_WAREHOUSE")
SNOWFLAKE_DATABASE = os.getenv("SNOWFLAKE_DATABASE", "POTION")
SNOWFLAKE_SCHEMA = os.getenv("SNOWFLAKE_SCHEMA", "RAW")
SNOWFLAKE_ROLE = os.getenv("SNOWFLAKE_ROLE")

def load_csv_to_snowflake(file_path, table_name):
    print(f"Loading {file_path} to Snowflake table {table_name}...")
    df = pd.read_csv(file_path)
    df.columns = [col.upper() for col in df.columns]
    conn = snowflake.connector.connect(
        user=SNOWFLAKE_USER,
        password=SNOWFLAKE_PASSWORD,
        account=SNOWFLAKE_ACCOUNT,
        warehouse=SNOWFLAKE_WAREHOUSE,
        database=SNOWFLAKE_DATABASE,
        schema=SNOWFLAKE_SCHEMA,
        role=SNOWFLAKE_ROLE
    )
    try:
        success, nchunks, nrows, _ = write_pandas(
            conn=conn,
            df=df,
            table_name=table_name,
            database=SNOWFLAKE_DATABASE,
            schema=SNOWFLAKE_SCHEMA,
            auto_create_table=True,
            overwrite=True
        )
        if success:
            print(f"Successfully loaded {nrows} rows into {table_name}.")
        else:
            print(f"Failed to load {table_name}.")
    finally:
        conn.close()

def main():
    data_dir = Path("potiondbt/data/analytics")
    if not data_dir.exists():
        data_dir = Path("../data/analytics")
        
    for csv_file in data_dir.glob("*.csv"):
        table_name = f"ANALYTICS_{csv_file.stem.upper()}"
        load_csv_to_snowflake(csv_file, table_name)

if __name__ == "__main__":
    main()
