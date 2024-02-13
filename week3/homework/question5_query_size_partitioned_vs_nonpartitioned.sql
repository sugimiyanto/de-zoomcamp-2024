SELECT
  DISTINCT PULocationID
FROM
  `sugi-learn.nytaxi.green_taxi_trip_non_partitioned`
WHERE
  lpep_pickup_datetime BETWEEN '2022-06-01' AND '2022-06-30';

SELECT
  DISTINCT PULocationID
FROM
  `sugi-learn.nytaxi.green_taxi_trip_partitioned_clustered`
WHERE
  lpep_pickup_datetime BETWEEN '2022-06-01' AND '2022-06-30';
