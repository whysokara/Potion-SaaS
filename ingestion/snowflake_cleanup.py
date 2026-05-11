import os
import snowflake.connector
from dotenv import load_dotenv

# Load environment variables
load_dotenv('potiondbt/ingestion/.env')

# Snowflake Connection Parameters
SNOWFLAKE_ACCOUNT = os.getenv("SNOWFLAKE_ACCOUNT")
SNOWFLAKE_USER = os.getenv("SNOWFLAKE_USER")
SNOWFLAKE_PASSWORD = os.getenv("SNOWFLAKE_PASSWORD")
SNOWFLAKE_WAREHOUSE = os.getenv("SNOWFLAKE_WAREHOUSE")
SNOWFLAKE_DATABASE = os.getenv("SNOWFLAKE_DATABASE", "POTION")
SNOWFLAKE_ROLE = os.getenv("SNOWFLAKE_ROLE")

def cleanup_snowflake():
    print(f"Connecting to Snowflake account {SNOWFLAKE_ACCOUNT}...")
    
    conn = snowflake.connector.connect(
        user=SNOWFLAKE_USER,
        password=SNOWFLAKE_PASSWORD,
        account=SNOWFLAKE_ACCOUNT,
        warehouse=SNOWFLAKE_WAREHOUSE,
        database=SNOWFLAKE_DATABASE,
        role=SNOWFLAKE_ROLE
    )
    
    schemas = ["RAW", "STAGING", "INTERMEDIATE", "MARTS"]
    
    try:
        cursor = conn.cursor()
        
        for schema in schemas:
            print(f"Cleaning up schema: {schema}...")
            
            # Use the schema
            cursor.execute(f"USE SCHEMA {schema}")
            
            # Drop all Views
            cursor.execute("SHOW VIEWS")
            views = cursor.fetchall()
            for view in views:
                view_name = view[1]
                print(f"  Dropping VIEW: {schema}.{view_name}")
                cursor.execute(f"DROP VIEW IF EXISTS {schema}.{view_name}")
            
            # Drop all Tables
            cursor.execute("SHOW TABLES")
            tables = cursor.fetchall()
            for table in tables:
                table_name = table[1]
                print(f"  Dropping TABLE: {schema}.{table_name}")
                cursor.execute(f"DROP TABLE IF EXISTS {schema}.{table_name}")
                
        print("\nSnowflake cleanup complete. All tables and views in project schemas have been removed.")
        
    except Exception as e:
        print(f"Error during cleanup: {e}")
    finally:
        conn.close()

if __name__ == "__main__":
    cleanup_snowflake()
