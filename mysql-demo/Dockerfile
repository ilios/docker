FROM ilios/mysql:v3

# customized to install ilios demo database
MAINTAINER Ilios Project Team <support@iliosproject.org>

ENV MYSQL_RANDOM_ROOT_PASSWORD yes
ENV MYSQL_USER ilios
ENV MYSQL_PASSWORD ilios
ENV MYSQL_DATABASE ilios

ENV DEMO_DATABASE_LOCATION https://s3-us-west-2.amazonaws.com/ilios-demo-db.iliosproject.org/latest_db/ilios3_demosite_db.sql.gz
RUN apt-get update && apt-get install -y wget

COPY fetch-demo-database.sh /fetch-demo-database.sh
RUN /bin/bash /fetch-demo-database.sh
