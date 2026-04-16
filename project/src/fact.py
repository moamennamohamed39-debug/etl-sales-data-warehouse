def build_fact(df, dim_product, dim_customer, dim_region, dim_rep):

    fact = df.copy()

    # =========================
    # JOIN dimensions (ONLY KEYS)
    # =========================
    fact = fact.merge(dim_product, on="product_category")
    fact = fact.merge(dim_customer, on="customer_type")
    fact = fact.merge(dim_region, on="region")
    fact = fact.merge(dim_rep, on=["sales_rep", "region_and_sales_rep"])

    # =========================
    # RE-CALCULATE METRICS (IMPORTANT FIX)
    # =========================
    fact["total_revenue"] = fact["quantity_sold"] * fact["unit_price"]
    fact["total_cost"] = fact["quantity_sold"] * fact["unit_cost"]
    fact["profit"] = fact["total_revenue"] - fact["total_cost"]

    fact["profit_margin"] = fact["profit"] / \
        fact["total_revenue"].replace(0, 1)
    fact["net_revenue"] = fact["total_revenue"] * (1 - fact["discount"])

    # =========================
    # FINAL FACT TABLE
    # =========================
    fact_sales = fact[[
        "product_sk",
        "customer_sk",
        "region_sk",
        "sales_rep_sk",
        "sale_date",
        "quantity_sold",
        "sales_amount",
        "unit_cost",
        "unit_price",
        "discount",
        "total_revenue",
        "total_cost",
        "profit",
        "profit_margin",
        "net_revenue"
    ]]

    return fact_sales
