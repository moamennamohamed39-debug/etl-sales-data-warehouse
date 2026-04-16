def build_dimensions(df):

    # ------------------------
    # DIM PRODUCT
    # ------------------------
    dim_product = df[["product_category"]].drop_duplicates()
    dim_product["product_bk"] = range(1, len(dim_product) + 1)
    dim_product["product_sk"] = dim_product["product_bk"]

    # ------------------------
    # DIM CUSTOMER
    # ------------------------
    dim_customer = df[["customer_type"]].drop_duplicates()
    dim_customer["customer_bk"] = range(1, len(dim_customer) + 1)
    dim_customer["customer_sk"] = dim_customer["customer_bk"]

    # ------------------------
    # DIM REGION
    # ------------------------
    dim_region = df[["region"]].drop_duplicates()
    dim_region["region_bk"] = range(1, len(dim_region) + 1)
    dim_region["region_sk"] = dim_region["region_bk"]

    # ------------------------
    # DIM SALES REP
    # ------------------------
    dim_rep = df[["sales_rep", "region_and_sales_rep"]].drop_duplicates()
    dim_rep["sales_rep_bk"] = range(1, len(dim_rep) + 1)
    dim_rep["sales_rep_sk"] = dim_rep["sales_rep_bk"]

    return dim_product, dim_customer, dim_region, dim_rep
