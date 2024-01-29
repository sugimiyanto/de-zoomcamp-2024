with pickup as (
select
	gtp."DOLocationID",
	tip_amount
FROM
	green_trip_data gtp
LEFT JOIN
	zones z
	ON gtp."PULocationID" = z."LocationID"
WHERE
	CAST(lpep_pickup_datetime AS DATE) >= '2019-09-01'
	AND CAST(lpep_pickup_datetime AS DATE) <= '2019-09-30'
	AND z."Zone" = 'Astoria'
)
select
	z."Zone",
	tip_amount
from pickup p
left join
	zones z
	ON p."DOLocationID" = z."LocationID"
order by 2 desc