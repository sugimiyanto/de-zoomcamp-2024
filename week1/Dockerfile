FROM python:3.9

# create /app dir, and cd into it
WORKDIR /app
# copy file pipeline.py on current dir, output as pipeline.py in current dir in image container
COPY pipeline.py pipeline.py
COPY requirements.txt requirements.txt
# COPY pipeline.py pipeline.py
COPY ingest_CSV_data_to_postgres_container.py ingest_CSV_data_to_postgres_container.py

RUN pip install -r requirements.txt

RUN apt-get install wget

# we override the entry point, this is what will be executed (open a bash prompt) when we run the container instead of opening a python prompt (which is the default entry point of image python:3.9)
# ENTRYPOINT [ "bash" ]

# we override again, so when we run `docker run` will execute this
# ENTRYPOINT [ "python", "pipeline.py"]
ENTRYPOINT [ "python", "ingest_CSV_data_to_postgres_container.py" ]

#= then we run it using: (the args we pass when we run the container becomes args when container executes ENTRYPOINT which is `python pipeline.py`)
# ❯ docker run -it test:pandas 2023-01-01
# ['pipeline.py', '2023-01-01']
# job finished successfully for day = 2023-01-01

#= then we can pass more arguments when run container.
# ❯ docker run -it test:pandas 2023-01-01 123 hello
# ['pipeline.py', '2023-01-01', '123', 'hello']
# job finished successfully for day = 2023-01-01
# ==>> that is how we parameterize our data pipeline script