CREATE OR REPLACE EXTERNAL TABLE `sugi-learn.nytaxi.green_taxi_trip_2022`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://sugi-learning-dwh/green_tripdata_2022-*.parquet']
);

SELECT COUNT(*) FROM `sugi-learn.nytaxi.green_taxi_trip_2022`;