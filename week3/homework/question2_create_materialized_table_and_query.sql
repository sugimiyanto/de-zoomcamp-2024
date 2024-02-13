CREATE OR REPLACE TABLE `sugi-learn.nytaxi.green_taxi_trip_non_partitioned` AS
SELECT * FROM sugi-learn.nytaxi.green_taxi_trip_2022;

SELECT
  COUNT(DISTINCT PULocationID)
FROM `sugi-learn.nytaxi.green_taxi_trip_2022`;

SELECT
  COUNT(DISTINCT PULocationID)
FROM `sugi-learn.nytaxi.green_taxi_trip_non_partitioned`;

