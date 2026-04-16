--create database sales_dw
USE sales_dw;
GO

-- إنشاء Schema
CREATE SCHEMA sales;
GO
-- =========================================================
-- DIMENSION: DATE
-- PURPOSE: Stores calendar attributes for time-based analysis
-- GRAIN: One row per calendar date
-- =========================================================
CREATE TABLE dim_date (
    date_sk INT IDENTITY(1,1) PRIMARY KEY,   -- Surrogate Key (internal DW key)

    date_bk DATE,                            -- Business Key (actual date from source system)

    full_date DATE,                          -- Full date value (redundant but useful for BI tools)

    year INT,                                -- Calendar year (e.g., 2026)
    month INT,                               -- Month number (1–12)
    month_name VARCHAR(20),                  -- Month name (January, February...)
    day INT,                                 -- Day of month
    quarter INT,                             -- Quarter (1–4)
    day_name VARCHAR(20)                     -- Day name (Monday, Tuesday...)
);

-----------------------------------------------------------------------------------
-- =========================================================
-- DIMENSION: TIME
-- PURPOSE: Enables analysis at hourly / minute / second level
-- GRAIN: One row per unique time value
-- =========================================================
CREATE TABLE dim_time (
    time_sk INT IDENTITY(1,1) PRIMARY KEY,   -- Surrogate Key

    time_bk TIME,                            -- Business Key (actual time value)

    hour INT,                                -- Hour of day (0–23)
    minute INT,                              -- Minute (0–59)
    second INT                               -- Second (0–59)
);
-----------------------------------------------------------------------------
-- =========================================================
-- DIMENSION: PRODUCT (SCD TYPE 2)
-- PURPOSE: Tracks product history over time (price/cost changes)
-- SCD TYPE: Slowly Changing Dimension Type 2
-- =========================================================
CREATE TABLE dim_product (
    product_sk INT IDENTITY(1,1) PRIMARY KEY,  -- Surrogate Key (DW key)

    product_bk INT,                            -- Business Key (Product_ID from source system)

    product_category VARCHAR(100),             -- Product classification

    unit_cost DECIMAL(10,2),                   -- Cost per unit at that time
    unit_price DECIMAL(10,2),                  -- Selling price per unit

    start_date DATE,                           -- Record effective start date
    end_date DATE,                             -- Record effective end date (NULL = current record)
    is_current BIT                             -- Flag indicating active record (1 = current)
);
-----------------------------------------------------------------------
-- =========================================================
-- DIMENSION: CUSTOMER (SCD TYPE 2)
-- PURPOSE: Stores customer segmentation history
-- =========================================================
CREATE TABLE dim_customer (
    customer_sk INT IDENTITY(1,1) PRIMARY KEY, -- Surrogate Key

    customer_bk VARCHAR(50),                   -- Business Key (Customer Type from source)

    customer_type VARCHAR(50),                 -- Customer classification

    start_date DATE,                           -- Effective start date
    end_date DATE,                             -- Effective end date
    is_current BIT                             -- Current record indicator
);
-------------------------------------------------------------------------
-- =========================================================
-- DIMENSION: REGION (SCD TYPE 2)
-- PURPOSE: Tracks regional changes over time if applicable
-- =========================================================
CREATE TABLE dim_region (
    region_sk INT IDENTITY(1,1) PRIMARY KEY,   -- Surrogate Key

    region_bk VARCHAR(50),                     -- Business Key (Region name/code)

    region VARCHAR(50),                        -- Region description

    start_date DATE,                           -- Record start validity
    end_date DATE,                             -- Record end validity
    is_current BIT                             -- Active record flag
);
-----------------------------------------------------------------------
-- =========================================================
-- DIMENSION: SALES REPRESENTATIVE (SCD TYPE 2)
-- PURPOSE: Tracks sales rep history and regional assignment changes
-- =========================================================
CREATE TABLE dim_sales_rep (
    sales_rep_sk INT IDENTITY(1,1) PRIMARY KEY,  -- Surrogate Key

    sales_rep_bk VARCHAR(100),                  -- Business Key (Sales Rep name/ID)

    sales_rep VARCHAR(100),                    -- Sales representative name

    region_and_sales_rep VARCHAR(150),        -- Combined attribute from source system

    start_date DATE,                           -- Effective start date
    end_date DATE,                             -- Effective end date
    is_current BIT                             -- Active record flag
);
-----------------------------------------------------------------------
-- =========================================================
-- FACT TABLE: SALES
-- PURPOSE: Stores transactional metrics (measures)
-- GRAIN: One row per sales transaction
-- =========================================================
CREATE TABLE fact_sales (
    sales_sk INT IDENTITY(1,1) PRIMARY KEY,   -- Surrogate Key for fact table

    -- =====================================================
    -- FOREIGN KEYS TO DIMENSIONS
    -- =====================================================
    date_sk INT,                              -- FK → dim_date
    time_sk INT,                              -- FK → dim_time
    product_sk INT,                           -- FK → dim_product
    customer_sk INT,                          -- FK → dim_customer
    region_sk INT,                            -- FK → dim_region
    sales_rep_sk INT,                         -- FK → dim_sales_rep

    -- =====================================================
    -- MEASURES (NUMERIC FACTS)
    -- =====================================================
    quantity_sold INT,                        -- Number of units sold
    sales_amount DECIMAL(10,2),               -- Raw sales amount from source
    unit_cost DECIMAL(10,2),                  -- Cost per unit
    unit_price DECIMAL(10,2),                 -- Selling price per unit
    discount DECIMAL(5,2),                    -- Discount applied (percentage or value)

    total_revenue DECIMAL(12,2),              -- quantity * unit_price
    total_cost DECIMAL(12,2),                 -- quantity * unit_cost
    profit DECIMAL(12,2),                    -- revenue - cost
    profit_margin DECIMAL(10,4),             -- profit / revenue
    net_revenue DECIMAL(12,2),               -- revenue after discount

    -- =====================================================
    -- FOREIGN KEY CONSTRAINTS (INTEGRITY RULES)
    -- =====================================================
    FOREIGN KEY (date_sk) REFERENCES dim_date(date_sk),
    FOREIGN KEY (time_sk) REFERENCES dim_time(time_sk),
    FOREIGN KEY (product_sk) REFERENCES dim_product(product_sk),
    FOREIGN KEY (customer_sk) REFERENCES dim_customer(customer_sk),
    FOREIGN KEY (region_sk) REFERENCES dim_region(region_sk),
    FOREIGN KEY (sales_rep_sk) REFERENCES dim_sales_rep(sales_rep_sk)
);