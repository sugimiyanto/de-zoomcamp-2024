select
	CAST(lpep_pickup_datetime AS DATE),
	COUNT(*)
FROM
	green_trip_data
WHERE
	CAST(lpep_pickup_datetime AS DATE) = '2019-09-18'
	AND CAST(lpep_dropoff_datetime AS DATE) = '2019-09-18'
GROUP BY 1