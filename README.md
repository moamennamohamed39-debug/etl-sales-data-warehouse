# etl-sales-data-warehouse
# Sales Data Warehouse ETL Project

## Overview
This project is an end-to-end Data Engineering pipeline that transforms raw sales data into a structured Star Schema Data Warehouse using Python and SQL Server.

It demonstrates ETL development, data modeling, and analytics-ready data preparation.

---

## Project Goals
- Build a complete ETL pipeline using Python
- Clean and transform raw sales data
- Design a Star Schema (Fact and Dimension model)
- Load data into SQL Server Data Warehouse
- Enable analytical queries for business insights

---

## Architecture

Raw CSV Data  
→ Python ETL (pandas)  
→ Data Cleaning and Feature Engineering  
→ Star Schema Design  
→ SQL Server Data Warehouse  

---

## Data Warehouse Design

### Fact Table
- fact_sales

### Dimension Tables
- dim_product  
- dim_customer  
- dim_region  
- dim_sales_rep  
- dim_date  
- dim_time  

---

## Tech Stack
- Python (pandas, sqlalchemy)
- SQL Server
- ETL Pipeline Design
- Star Schema Modeling

---

## ETL Pipeline Steps

### Extract
- Load raw CSV data using pandas

### Transform
- Clean column names
- Handle missing values
- Feature engineering:
  - total_revenue
  - total_cost
  - profit
  - profit_margin
  - net_revenue

### Load
- Load transformed data into SQL Server tables
- Build Fact and Dimension tables

---

## Example Business Queries

```sql
-- Total revenue by region
SELECT r.region, SUM(f.total_revenue)
FROM fact_sales f
JOIN dim_region r ON f.region_sk = r.region_sk
GROUP BY r.region;
