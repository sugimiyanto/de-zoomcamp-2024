select
	z."Borough",
	SUM(total_amount)
FROM
	green_trip_data gtd
LEFT JOIN
	zones z
	ON gtd."PULocationID" = z."LocationID"
WHERE
	CAST(lpep_pickup_datetime AS DATE) = '2019-09-18'
GROUP BY 1
ORDER BY 2 desc