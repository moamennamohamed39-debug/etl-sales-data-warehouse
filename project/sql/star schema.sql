-- =========================
-- DATABASE
-- =========================
CREATE DATABASE sales_dw;
GO

USE sales_dw;
GO

-- =========================
-- SCHEMA
-- =========================
CREATE SCHEMA sales;
GO

-- =========================
-- DIM DATE
-- =========================
CREATE TABLE sales.dim_date (
    date_sk INT IDENTITY(1,1) PRIMARY KEY,
    date_bk DATE NOT NULL,
    full_date DATE NOT NULL,

    year INT NOT NULL,
    month INT NOT NULL,
    month_name VARCHAR(20),
    day INT NOT NULL,
    quarter INT NOT NULL,
    day_name VARCHAR(20)
);

-- =========================
-- DIM TIME
-- =========================
CREATE TABLE sales.dim_time (
    time_sk INT IDENTITY(1,1) PRIMARY KEY,
    time_bk TIME NOT NULL,

    hour INT NOT NULL,
    minute INT NOT NULL,
    second INT NOT NULL
);

-- =========================
-- DIM PRODUCT (SCD2)
-- =========================
CREATE TABLE sales.dim_product (
    product_sk INT IDENTITY(1,1) PRIMARY KEY,
    product_bk INT NOT NULL,

    product_category VARCHAR(100),

    unit_cost DECIMAL(10,2),
    unit_price DECIMAL(10,2),

    start_date DATE NOT NULL,
    end_date DATE NULL,
    is_current BIT DEFAULT 1
);

-- =========================
-- DIM CUSTOMER (SCD2)
-- =========================
CREATE TABLE sales.dim_customer (
    customer_sk INT IDENTITY(1,1) PRIMARY KEY,
    customer_bk VARCHAR(50) NOT NULL,

    customer_type VARCHAR(50),

    start_date DATE NOT NULL,
    end_date DATE NULL,
    is_current BIT DEFAULT 1
);

-- =========================
-- DIM REGION (SCD2)
-- =========================
CREATE TABLE sales.dim_region (
    region_sk INT IDENTITY(1,1) PRIMARY KEY,
    region_bk VARCHAR(50) NOT NULL,

    region VARCHAR(50),

    start_date DATE NOT NULL,
    end_date DATE NULL,
    is_current BIT DEFAULT 1
);

-- =========================
-- DIM SALES REP (SCD2)
-- =========================
CREATE TABLE sales.dim_sales_rep (
    sales_rep_sk INT IDENTITY(1,1) PRIMARY KEY,
    sales_rep_bk VARCHAR(100) NOT NULL,

    sales_rep VARCHAR(100),
    region_and_sales_rep VARCHAR(150),

    start_date DATE NOT NULL,
    end_date DATE NULL,
    is_current BIT DEFAULT 1
);

-- =========================
-- FACT SALES
-- =========================
CREATE TABLE sales.fact_sales (
    sales_sk INT IDENTITY(1,1) PRIMARY KEY,

    -- FOREIGN KEYS
    date_sk INT NOT NULL,
    time_sk INT NOT NULL,
    product_sk INT NOT NULL,
    customer_sk INT NOT NULL,
    region_sk INT NOT NULL,
    sales_rep_sk INT NOT NULL,

    -- MEASURES
    quantity_sold INT NOT NULL,
    sales_amount DECIMAL(10,2),
    unit_cost DECIMAL(10,2),
    unit_price DECIMAL(10,2),
    discount DECIMAL(5,2),

    total_revenue DECIMAL(12,2),
    total_cost DECIMAL(12,2),
    profit DECIMAL(12,2),
    profit_margin DECIMAL(10,4),
    net_revenue DECIMAL(12,2),

    -- ETL AUDIT
    load_date DATETIME DEFAULT GETDATE(),
    batch_id INT,

    -- CONSTRAINTS
    CONSTRAINT chk_quantity CHECK (quantity_sold > 0),
    CONSTRAINT chk_discount CHECK (discount >= 0 AND discount <= 100),
    CONSTRAINT chk_sales_amount CHECK (sales_amount >= 0),

    -- FOREIGN KEYS
    CONSTRAINT fk_date FOREIGN KEY (date_sk) REFERENCES sales.dim_date(date_sk),
    CONSTRAINT fk_time FOREIGN KEY (time_sk) REFERENCES sales.dim_time(time_sk),
    CONSTRAINT fk_product FOREIGN KEY (product_sk) REFERENCES sales.dim_product(product_sk),
    CONSTRAINT fk_customer FOREIGN KEY (customer_sk) REFERENCES sales.dim_customer(customer_sk),
    CONSTRAINT fk_region FOREIGN KEY (region_sk) REFERENCES sales.dim_region(region_sk),
    CONSTRAINT fk_salesrep FOREIGN KEY (sales_rep_sk) REFERENCES sales.dim_sales_rep(sales_rep_sk)
);
GO

-- =========================
-- PERFORMANCE INDEXES
-- =========================
CREATE INDEX idx_fact_date ON sales.fact_sales(date_sk);
CREATE INDEX idx_fact_time ON sales.fact_sales(time_sk);
CREATE INDEX idx_fact_product ON sales.fact_sales(product_sk);
CREATE INDEX idx_fact_customer ON sales.fact_sales(customer_sk);
CREATE INDEX idx_fact_region ON sales.fact_sales(region_sk);
CREATE INDEX idx_fact_salesrep ON sales.fact_sales(sales_rep_sk);
GO

