select
	CAST(lpep_pickup_datetime AS DATE),
	SUM(trip_distance)
FROM
	green_trip_data
GROUP BY 1
ORDER BY 2 desc