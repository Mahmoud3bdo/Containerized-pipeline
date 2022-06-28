# how to create a new docker image

# specify the python version of the image
FROM python:latest

# install all the dependencies of our application
RUN apt-get install wget

RUN pip install pandas sqlalchemy  psycopg2 pyarrow

RUN pip install --pre --upgrade sqlalchemy

#create a app folder where pipeline.py will be stored
WORKDIR /app

COPY ingest_data.py  ingest_data.py

ENTRYPOINT [ "python" ,"ingest_data.py" ]