import os
import snowflake.connector
from dotenv import load_dotenv
from pathlib import Path

# Load environment variables
# Check multiple possible locations for .env
env_paths = [
    Path(".env"),
    Path("ingestion/.env"),
    Path("potiondbt/ingestion/.env")
]

env_found = False
for path in env_paths:
    if path.exists():
        load_dotenv(path)
        env_found = True
        break

# Snowflake Connection Parameters
SNOWFLAKE_ACCOUNT = os.getenv("SNOWFLAKE_ACCOUNT")
SNOWFLAKE_USER = os.getenv("SNOWFLAKE_USER")
SNOWFLAKE_PASSWORD = os.getenv("SNOWFLAKE_PASSWORD")
SNOWFLAKE_WAREHOUSE = os.getenv("SNOWFLAKE_WAREHOUSE")
SNOWFLAKE_DATABASE = os.getenv("SNOWFLAKE_DATABASE", "POTION")
SNOWFLAKE_ROLE = os.getenv("SNOWFLAKE_ROLE")

def reset_snowflake_dbt():
    """
    Drops all tables and views in STAGING, INTERMEDIATE, and MARTS schemas.
    Explicitly PRESERVES the RAW schema where source data lives.
    """
    if not env_found:
        print("Error: Could not find .env file. Please ensure it exists in the root or ingestion folder.")
        return

    print(f"Connecting to Snowflake account {SNOWFLAKE_ACCOUNT}...")
    
    try:
        conn = snowflake.connector.connect(
            user=SNOWFLAKE_USER,
            password=SNOWFLAKE_PASSWORD,
            account=SNOWFLAKE_ACCOUNT,
            warehouse=SNOWFLAKE_WAREHOUSE,
            database=SNOWFLAKE_DATABASE,
            role=SNOWFLAKE_ROLE
        )
        
        # We ONLY clean up dbt-managed schemas. RAW is preserved.
        schemas = ["STAGING", "INTERMEDIATE", "MARTS"]
        
        cursor = conn.cursor()
        
        for schema in schemas:
            print(f"\nProcessing schema: {schema}...")
            
            # Check if schema exists first to avoid errors
            try:
                cursor.execute(f"USE SCHEMA {schema}")
            except snowflake.connector.errors.ProgrammingError:
                print(f"  Schema {schema} does not exist. Skipping.")
                continue
            
            # Drop all Views
            cursor.execute(f"SHOW VIEWS IN SCHEMA {schema}")
            views = cursor.fetchall()
            if views:
                for view in views:
                    view_name = view[1]
                    print(f"  Dropping VIEW: {schema}.{view_name}")
                    cursor.execute(f"DROP VIEW IF EXISTS {schema}.{view_name}")
            else:
                print("  No views found.")
            
            # Drop all Tables
            cursor.execute(f"SHOW TABLES IN SCHEMA {schema}")
            tables = cursor.fetchall()
            if tables:
                for table in tables:
                    table_name = table[1]
                    print(f"  Dropping TABLE: {schema}.{table_name}")
                    cursor.execute(f"DROP TABLE IF EXISTS {schema}.{table_name}")
            else:
                print("  No tables found.")
                
        print("\nSnowflake reset complete. dbt schemas have been cleared. RAW data is preserved.")
        
    except Exception as e:
        print(f"Error during reset: {e}")
    finally:
        if 'conn' in locals():
            conn.close()

if __name__ == "__main__":
    reset_snowflake_dbt()
