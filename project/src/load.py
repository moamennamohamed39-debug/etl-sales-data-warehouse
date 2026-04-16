
from sqlalchemy import create_engine
from src.config import DB_CONFIG


def get_engine():
    return create_engine(
        f"mssql+pyodbc://@{DB_CONFIG['server']}/{DB_CONFIG['database']}?"
        f"driver={DB_CONFIG['driver'].replace(' ', '+')}&trusted_connection=yes"
    )


def load(df, table):
    engine = get_engine()

    df.to_sql(
        table,
        engine,
        if_exists="replace",
        index=False,
        chunksize=1000
    )
