# Potion SaaS Data Platform

## 🚀 Overview
This repository contains a production-ready end-to-end data engineering platform for **Potion**, a US-based AI Productivity SaaS startup. The platform provides actionable insights into growth, sales performance, and customer behavior by integrating synthetic data from multiple sources into a centralized Snowflake Data Warehouse.

## 🏗 Architecture
The platform follows a modern data stack (MDS) architecture, now fully implemented with local ingestion and dbt transformation:

1.  **Sources:** Synthetic data for Stripe (Payments), HubSpot (CRM), Product (Event Logs), and Sales Tracking (CSV format in `/data`).
2.  **Ingestion (EL):** Custom **Python Ingestion Scripts** (`/ingestion`) that load local CSV data into Snowflake `RAW` schemas using the Snowflake Pandas Connector.
3.  **Storage:** **Snowflake** serves as the primary Data Cloud for raw and transformed data.
4.  **Transformation (T):** **dbt (data build tool)** manages the transformation layers (Staging -> Intermediate -> Marts).
5.  **Visualization (BI):** **Metabase** (ready for connection) to the `MART` layer for executive and operational dashboards.

## 🌊 Data Flow & dbt Structure
We employ a vertical-based folder structure maintained consistently across all dbt layers. This ensures a 1:1 mapping between staging models and their downstream intermediate and mart counterparts.

### Completed Verticals
The following verticals are now fully implemented across Staging, Intermediate, and Marts layers:

-   **Stripe (Payments):** Subscription management, MRR snapshots, and billing.
-   **HubSpot (CRM):** Customer profiles, deals, and engagement.
-   **Product:** User behavior, feature engagement, and event tracking.
-   **Sales:** Tracking leads, deals, and sales productivity.
-   **Analytics/Growth:** CAC, LTV, DAU/MAU, and Funnel metrics.

### Layer Definitions
-   **Staging Layer:** Initial cleaning and standardization of raw source data, organized by vertical.
-   **Intermediate Layer:** Application of complex business logic, joins across sources, and metric definitions.
-   **Marts Layer:** Final, "BI-ready" models optimized for performance and end-user clarity.

## 🛠 Engineering Features
-   **Automated Ingestion:** Python scripts with error handling and environment variable configuration.
-   **Schema Management:** Centralized macro for upper-case schema normalization in Snowflake.
-   **Data Quality:** Robust dbt tests (unique, not null) and custom business logic validations.
-   **Modular Design:** Decoupled ingestion logic from transformation logic.

## 📊 Key Business Metrics
The platform calculates and tracks critical SaaS KPIs in the Marts layer:
-   **LTV (Lifetime Value):** Predicted and historical value per customer.
-   **CAC (Customer Acquisition Cost):** Blended and channel-specific costs.
-   **Retention:** MoM and YoY cohort-based retention rates.
-   **Funnel:** Conversion rates from Lead -> SQL -> Opportunity -> Closed Won.

## 🚀 Getting Started

### Prerequisites
-   Python 3.9+
-   dbt Core 1.7+
-   Snowflake Account

### Setup & Ingestion
1.  Clone the repository and install dependencies:
    ```bash
    pip install -r ingestion/requirements.txt
    dbt deps
    ```
2.  Configure your `.env` file with Snowflake credentials (see `ingestion/load_stripe_to_snowflake.py` for required variables).
3.  Run the ingestion scripts to load raw data:
    ```bash
    python ingestion/load_stripe_to_snowflake.py
    python ingestion/load_hubspot_to_snowflake.py
    # ... and others in the /ingestion folder
    ```
4.  *(Optional)* Use the cleanup script to reset your Snowflake environment:
    ```bash
    python ingestion/snowflake_cleanup.py
    ```

### dbt Execution
1.  Set up your `profiles.yml` for Snowflake connection.
2.  Run the initial build:
    ```bash
    dbt build
    ```

---
*Note: This project uses synthetic data generated via Claude to simulate a real-world SaaS environment.*
