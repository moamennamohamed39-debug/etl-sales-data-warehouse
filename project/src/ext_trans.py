import pandas as pd
import numpy as np


def extract():
    return pd.read_csv(r"C:\Users\Admin\Downloads\project\data\sales_data.csv")


def transform(df):
    df = df.copy()

    df.columns = df.columns.str.lower().str.strip().str.replace(" ", "_")

    df["sale_date"] = pd.to_datetime(df["sale_date"])

    df["quantity_sold"] = pd.to_numeric(df["quantity_sold"])
    df["unit_price"] = pd.to_numeric(df["unit_price"])
    df["unit_cost"] = pd.to_numeric(df["unit_cost"])

    df["total_revenue"] = df["quantity_sold"] * df["unit_price"]
    df["total_cost"] = df["quantity_sold"] * df["unit_cost"]
    df["profit"] = df["total_revenue"] - df["total_cost"]

    return df
