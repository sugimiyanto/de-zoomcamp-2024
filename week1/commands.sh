docker run -it \
    -e POSTGRES_USER="root" \
    -e POSTGRES_PASSWORD="root" \
    -e POSTGRES_DB="ny_taxi" \
    -v $(pwd)/ny_taxi_postgres_data:/var/lib/postgresql/data \
    -p 2345:5432 \
postgres:13
# -e is setting env variables  
# -v: remember that Docker doesn't keep state, it will go to the initial condition and data
    # so, if we want to keep the data we generate or update in docker container, we need to store it to local file system, by using 'Volume'
# -p: need to specify/map the port to access the postgres db from outside the container
    # host:port:container_port. we tunnel port 2345 from our local system to port 5432 of container port which is port of postgre
    # why 2345? because i hv existing postgres server installed on my laptop, so port 5432 already used.

# when we run it, look at the monted volume we made, docker is creating folders to store the data

pip install pgcli
pgcli -h localhost -p 2345 -u root -d ny_taxi

##@@@@ PGADMIN #######
# goal: connecting between two containers: postgres db as container and pgadmin as postgres GUI
# keyword: use docker network to connect them

docker run -it \
    -e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
    -e PGADMIN_DEFAULT_PASSWORD="root" \
    -p 8080:80 \
dpage/pgadmin4
# but when we run it, and open pgadmin GUI we cant connect because the postgres container is running in different container not in pgadmin container.
# we need to connect the container using docker network
docker network create pg-network

# then run the containers using that network
docker run -it \
    -e POSTGRES_USER="root" \
    -e POSTGRES_PASSWORD="root" \
    -e POSTGRES_DB="ny_taxi" \
    -v $(pwd)/ny_taxi_postgres_data:/var/lib/postgresql/data \
    -p 2345:5432 \
    --network=pg-network \
    --name pg-database \
postgres:13
# the --name is used for pgadmin to discover the postgres db means that container

docker run -it \
    -e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
    -e PGADMIN_DEFAULT_PASSWORD="root" \
    -p 8080:80 \
    --network=pg-network \
dpage/pgadmin4
# open the pgadmin: localhost:8080. right click on servers -> register -> server
# the hostname to connect is the --name on the previous docker run postgres


###### 2024-01-19 #####
# converting codes on jupyter notebook to python script, will be put it on pipieline.py
jupyter nbconvert --to=script Ingest_CSV_data_to_postgres_container.ipynb
# clean the unnecessary things on the *.py file

URL="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz"
# --password -> this is not a good way to access using password.
    # a better way is we can store it as env variable or any password storage
python ingest_CSV_data_to_postgres_container.py \
    --user=root \
    --password=root \
    --host=localhost \
    --port=2345 \
    --db=ny_taxi \
    --table_name=yellow_taxi_trips \
    --url=${URL}
# it got error: ingest_CSV_data_to_postgres_container.py:47: DtypeWarning: Columns (6) have mixed types. Specify dtype option on import or set low_memory=False.
#   File "pandas/_libs/parsers.pyx", line 839, in pandas._libs.parsers.TextReader.read_low_memory
# StopIteration
# but we not focus on fixing this, the idea is just to insert the data
# check in pgAdmin select count(*) from ...

# TODID: modify the Dockerfile

docker build -t taxi_ingest:001 .

docker run -it \
    --network=pg-network \
    taxi_ingest:001 \
        --user=root \
        --password=root \
        --host=pg-database \
        --port=5432 \
        --db=ny_taxi \
        --table_name=yellow_taxi_trips \
        --url=${URL}
# in production env,
    # the host might be a cloud db.
    # instead of typing docker run -it, it might be kubernetes job


### =========
# 2024-01-22
# docker compose
# ===
# wrap all the above manual of writing command, passing parameters, binding to network of running multiple containers.
# to be simpler, using docker-compose. so to run a container, instead of typing we can only do docker-compose
# read: https://docs.docker.com/compose/
docker-compose up
docker-compose down # proper way to shutdown docker-compose run
docker-compose -d # to run in background as daemon 'd'


### ======
# 2024-01-23
# SQL refresher
# ===
# menu:
#=> JOIN
    # (inner) join using FROM table_a a, table_b b WHERE a.col = b.col
    # also aim the same inner join using FROM table_a a JOIN table_b b ON a.col = b.col
    # they are equivalent, there is no performance difference
#=> Basic data quality checks. run in pgAdmin UI
    SELECT
        tpep_pickup_datetime,
        tpep_dropoff_datetime,
        total_amount,
        "PULocationID",
        "DOLocationID"
    FROM
        yellow_taxi_data t
    -- LIMIT 100;
    -- check if thre are maybe some things that are empty
    -- WHERE
    -- 	"PULocationID" IS NULL; -- return empty, so there are no empty pickuplocation id 
    -- 	"DOLocationID" IS NULL; -- return empty, so there are no empty dropofflocation id


    -- check if Location IDs (DO and PU) not present in the zones table
        -- maybe there are some ideas that we dont have information about
    WHERE
        "PULocationID" NOT IN (SELECT "LocationID" FROM zones)
        OR "DOLocationID" NOT IN (SELECT "LocationID" FROM zones)
        -- return empty, so, there are no such cases
    -- so, apparently our data set is good in the sense that all the records have pick up and drop off locations
        -- and all location IDs in the yellow taxi data are present in the zones table

#=> LEFT, RIGHT, OUTER JOIN
#=> GROUP BY
    # ORDER BY. check what is the busiest day.
    SELECT
        CAST(tpep_dropoff_datetime AS DATE) AS "day",
        COUNT(1) AS "count"
    FROM
        yellow_taxi_data
    GROUP BY CAST(tpep_dropoff_datetime AS DATE)
    ORDER BY "count" DESC;

    # check what is the max number of money that driver made
    # and see the largest trip in terms of number of passengers in the trip
    SELECT
        CAST(tpep_dropoff_datetime AS DATE) AS "day",
        COUNT(1) AS "count",
        MAX(total_amount),
        MAX(passenger_count)
    FROM
        yellow_taxi_data
    GROUP BY CAST(tpep_dropoff_datetime AS DATE)
    ORDER BY "count" DESC;
    # -- we see that poeple travel in large groups 6-8
    # -- we also see that there was driver that made >$1000 in one trip. that is quite impressive

    SELECT
        CAST(tpep_dropoff_datetime AS DATE) AS "day",
		"DOLocationID",
        COUNT(1) AS "count",
        MAX(total_amount),
        MAX(passenger_count)
    FROM
        yellow_taxi_data
    GROUP BY 1, 2
    ORDER BY
		"day" ASC,
		"DOLocationID" ASC;
    # we can see that on each day and each location, how much was the max money the driver made and what was the max num of passengers
    # of course, we can add more and more sutff.
    # and those are the majority of queries that analytics use looks like
        # group by, aggregation, some sort of joins

