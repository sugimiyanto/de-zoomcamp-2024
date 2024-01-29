#!/usr/bin/env python
# coding: utf-8


import pandas as pd
from sqlalchemy import create_engine

from time import time
import argparse
import os

def main(params):
    user = params.user
    password = params.password
    host = params.host
    port = params.port
    db = params.db
    table_name = params.table_name
    url = params.url

    gz_file = "output.csv.gz"
    csv_name = "output.csv"
    # download the csv
    os.system(f"wget {url} -O {gz_file} && gunzip {gz_file}")

    engine = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{db}')
    engine.connect()

    df_iter = pd.read_csv(csv_name, iterator=True, chunksize=100_000)

    df = next(df_iter) # use next() to iterate the batches

    # ISSUE: we see that the columns tpep_pickup_datetime and tpep_dropoff_datetime have dtype TEXT
    # because pandas doesnt know those columns are actually timestamp. so we need to tell pandas they are timestamp
    df.tpep_pickup_datetime = pd.to_datetime(df.tpep_pickup_datetime)
    df.tpep_dropoff_datetime = pd.to_datetime(df.tpep_dropoff_datetime)

    # because we do it in chunks, we first create the table then insert the data in chunks. so we use head(n=0)
    # to only get the header to create table
    df.head(n=0).to_sql(con=engine, name=table_name, if_exists='replace') # if table exists, drop and recreate
    df.to_sql(con=engine, name=table_name, if_exists='append')

    # this might be not cleanest code
    while True:
        t_start = time()
        
        df = next(df_iter)
        df.tpep_pickup_datetime = pd.to_datetime(df.tpep_pickup_datetime)
        df.tpep_dropoff_datetime = pd.to_datetime(df.tpep_dropoff_datetime)

        df.to_sql(con=engine, name=table_name, if_exists='append')

        t_end = time()
        print(f'inserted another chunk..., took {t_end - t_start:.2f}s')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Ingest CSV data to postgres')

    parser.add_argument('--user', help='user name for postgres')
    parser.add_argument('--password', help='password for postgres')
    parser.add_argument('--host', help='host name for postgres')
    parser.add_argument('--port', help='pot for postgres')
    parser.add_argument('--db', help='dn name for postgres')
    parser.add_argument('--table_name', help='name of the table where we will wite the results to')
    parser.add_argument('--url', help='url of the csv file')

    args = parser.parse_args()

    main(args)
