import logging
from src.ext_trans import extract, transform
from src.dimensions import build_dimensions
from src.fact import build_fact
from src.load import load

logging.basicConfig(filename="etl.log", level=logging.INFO)


def run():

    logging.info("ETL START")

    # Extract + Transform
    df = extract()
    df = transform(df)

    # Build Dimensions
    dim_product, dim_customer, dim_region, dim_rep = build_dimensions(df)

    # Build Fact
    fact_sales = build_fact(df, dim_product, dim_customer, dim_region, dim_rep)

    # LOAD DIMENSIONS
    load(dim_product, "dim_product")
    load(dim_customer, "dim_customer")
    load(dim_region, "dim_region")
    load(dim_rep, "dim_sales_rep")

    # LOAD FACT
    load(fact_sales, "fact_sales")

    logging.info("ETL DONE")
    print("SUCCESS ")


if __name__ == "__main__":
    run()
