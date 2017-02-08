# Ilios Docker

## What is the purpose of this?
This repository is the home for the official Ilios Docker images as well as some sample configurations for running these images in concert.

If you are attempting to run Ilios from within a container infrastructure we hope the `docker-compose.yml` file will help you understand how these pieces can be fit together.

## Not ready for production
These sample files are not quite ready for production use, you will need to customize them for your own environment to ensure you are storing data from MySql and Ilios in a way that will not be lost when the docker containers are removed or replaced.

## How can I try Ilios with these containers?
- Clone or [download](https://github.com/ilios/docker/archive/master.zip) this repository
- [Install](https://docs.docker.com/compose/install/) docker and docker-compose
- run the command `docker-compose -f demo-docker-compose.yml up -d`
- After a few moments visit http://localhost:8000

## Containers for running Ilios

These containers are auto built on the docker hub
and can be found at https://hub.docker.com/u/ilios/
### Contains:

- php-fpm
- nginx
- mysql
- mysql-demo
- php-fpm-dev
