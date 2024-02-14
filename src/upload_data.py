import pandas as pd
from sqlalchemy import create_engine
import os
print(f'current working dir:{os.getcwd()}')

# Load dataset
df = pd.read_csv('../data/python_output/sales_cleaned.csv')

# Connect to Azure SQL Edge
engine = create_engine(
    'mssql+pyodbc://sa:tamar-janssens2024@localhost:57000/master?driver=ODBC+Driver+18+for+SQL+Server&TrustServerCertificate=Yes',
    fast_executemany=True,
    connect_args={'login_timeout': 30})
df.to_sql('raw_data', con=engine, if_exists='replace', index=False)
print('done...')
