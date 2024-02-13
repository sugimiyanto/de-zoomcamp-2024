SELECT
  COUNT(*)
FROM `sugi-learn.nytaxi.green_taxi_trip_non_partitioned`
WHERE
  fare_amount = 0;