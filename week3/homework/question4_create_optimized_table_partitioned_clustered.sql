CREATE OR REPLACE TABLE `sugi-learn.nytaxi.green_taxi_trip_partitioned_clustered`
PARTITION BY DATE(lpep_pickup_datetime)
CLUSTER BY PUlocationID AS
SELECT * FROM `sugi-learn.nytaxi.green_taxi_trip_non_partitioned`;