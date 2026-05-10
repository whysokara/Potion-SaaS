# Potion SaaS Data Platform

## 🚀 Overview
This repository contains the end-to-end data engineering platform for **Potion**, a US-based AI Productivity SaaS startup. The platform is designed to provide actionable insights into growth, sales performance, and customer behavior by integrating data from multiple disparate sources into a centralized Snowflake Data Warehouse.

## 🏗 Architecture
The platform follows a modern data stack (MDS) architecture:
1.  **Sources:** Stripe (Payments), HubSpot (CRM), Product (Event Logs), and Manual Sales Tracking.
2.  **Ingestion (EL):** **Fivetran** extracts data from SaaS sources and loads them into Snowflake `RAW` schemas.
3.  **Storage:** **Snowflake** serves as the primary Data Cloud for raw and transformed data.
4.  **Transformation (T):** **dbt (data build tool)** manages the transformation layers (Staging -> Intermediate -> Marts).
5.  **Orchestration:** **Dagster** handles the end-to-end pipeline orchestration, ensuring data freshness and dependency management.
6.  **Visualization (BI):** **Metabase** connects to the `MART` layer for executive and operational dashboards.

## 🌊 Data Flow & dbt Structure
We employ a vertical-based folder structure that is maintained consistently across all dbt layers. This ensures a 1:1 mapping between staging models and their downstream intermediate and mart counterparts, making the lineage intuitive and easy to navigate.

### The Vertical Alignment
The following verticals are used as the primary organizational unit in `models/staging`, `models/intermediate`, and `models/marts`:

-   **Sales:** Tracking leads, deals, and sales productivity.
-   **Payments:** Subscription management, revenue, and billing.
-   **Product:** User behavior, feature engagement, and event tracking.
-   **Retention:** Cohort analysis, DAU/MAU, and churn metrics.
-   **Growth:** CAC, LTV, and ROI analysis.

### Layer Definitions
-   **Staging Layer:** Initial cleaning and standardization of raw source data, organized by vertical.
-   **Intermediate Layer:** Application of complex business logic, joins across sources, and metric definitions.
-   **Marts Layer:** Final, "BI-ready" models optimized for performance and end-user clarity.

## 🛠 Engineering Features
To ensure enterprise-grade reliability, we have implemented:
-   **Incremental Loading:** Optimized performance for high-volume event data.
-   **SCD Type 2 (Snapshots):** Tracking historical changes in HubSpot deals and customer status.
-   **Data Quality:** Robust dbt tests (schema, unique, not null) and custom business logic validations.
-   **Documentation:** Auto-generated dbt documentation and Metabase metadata syncing.

## 📊 Key Business Metrics
The platform calculates and tracks critical SaaS KPIs:
-   **LTV (Lifetime Value):** Predicted and historical value per customer.
-   **CAC (Customer Acquisition Cost):** Blended and channel-specific costs.
-   **Retention:** MoM and YoY cohort-based retention rates.
-   **Funnel:** Conversion rates from Lead -> SQL -> Opportunity -> Closed Won.

## 🚀 Getting Started

### Prerequisites
-   dbt Core 1.7+
-   Snowflake Account
-   Dagster instance

### Installation
1.  Clone the repository:
    ```bash
    git clone https://github.com/your-org/potiondbt.git
    cd potiondbt
    ```
2.  Install dbt dependencies:
    ```bash
    dbt deps
    ```
3.  Set up your `profiles.yml` for Snowflake connection.
4.  Run the initial build:
    ```bash
    dbt build
    ```

---
*Note: This project uses synthetic data generated via Claude to simulate a real-world SaaS environment.*
