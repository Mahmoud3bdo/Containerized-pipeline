- python
- Docker
- Docker Compose
- PostgreSQL
- pgAdmin


### Docker

- What is Docker?
    - Docker is a service that enables software packaging using containers.
- Why is it important?
    - it allows isolation of systems
        - imagine we need a specific Python version in a single project and the Python version installed in our OS is different. To avoid conflicts, we can define the desired version in the container that packages the project.
    - reproducibility
        - we can use the local container on a cloud provider and the expected behavior will be the same as observed in the local machine
    - local experiments
        - allows making local tests before deploying

### Commands :

- dataset: https://s3.amazonaws.com/nyc-tlc/trip+data/yellow_tripdata_2021-01.parquet

 - build an image:
 ```
 docker build -t IMAGE_NAME .
 ``` 
 - run an image :
 ```
 docker run -it IMAGE_NAME
 ```
- run a postgres image 
```
docker run -it  \
    -e POSTGRES_USER='root' \
    -e POSTGRES_PASSWORD='root' \
    -e POSTGRES_DB='ny_taxi' \
    -v /f/sql_docker/ny_taxi_postgres_data:/var/lib/postgresql/data" \
    -p 5432:5432 \
    postgres:13 
```

- pgAdmin image: 
```
docker run -it \
        -e PGADMIN_DEFAULT_EMAIL=admin@admin.com \
        -e PGADMIN_DEFAULT_PASSWORD="root" \
        -p 8080:80 \
        dpage/pgadmin4
```



    - 8080: the port in the local machine
    - 80: the port used by pgAdmin
    - 8080:80 is the setup to connect the local machine with pgAdmin

- create a docker network: 
```
docker network create mh_network
```
 
- update PostgreSQL image: 
```
docker run -it  \
    -e POSTGRES_USER='root' \
    -e POSTGRES_PASSWORD='root' \
    -e POSTGRES_DB='ny_taxi' \
    -v /f/sql_docker/ny_taxi_postgres_data:/var/lib/postgresql/data" \
    -p 5432:5432 \
    --network=mh_network \
    --name pg-database \
    postgres:13
```

- update pgAdmin image with network settings: 
```
docker run -it \
        -e PGADMIN_DEFAULT_EMAIL=admin@admin.com \
        -e PGADMIN_DEFAULT_PASSWORD="root" \
        -p 8080:80 \
        --network=mh_network \
        --name pg-database \
        dpage/pgadmin4
```
Now when we connect to the server, we use the name of the Postgres container as the hostname/address which in our case was pg-database.


![pgadmin_connect](https://i.imgur.com/8xKK5S1.png)

Now we have a fully featured graphical SQL manager that we can use to run admin tasks on the database and run queries using the Query Tool.


![pgadmin](https://i.imgur.com/6FSwGXR.png)

- build an image for the data ingestion process: 
```
docker build -t taxi_ingest:v001 .
```

- run the docker image for data ingestion using the same network used by pgAdmin and PostgreSQL:
```
docker run -it \
    --network=mh_network \
    taxi_ingest:v001 \
        --user=root \
        --password=root \
        --host=pg-database-teste\
        --port=5432 \
        --db=ny_taxi \
        --table_name=yellow_taxi_data \
        --url="https://s3.amazonaws.com/nyc-tlc/trip+data/yellow_tripdata_2021-01.parquet"
```

- Docker Compose:
```
docker-compose up
```
