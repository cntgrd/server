# Centigrade Server

[![Build Status](https://travis-ci.org/cntgrd/server.svg?branch=dev)](https://travis-ci.org/cntgrd/server)

Collects data from the Centigrade platform and relays it to the Centigrade app.

# Deployment

## Initial Setup
Before the Centigrade backend can be deployed, the host system must be set up to work with Docker. Apart from setting up a new server with users, etc., the requirements for deployment are the Docker CE Engine and Docker Compose.

The installation of the Docker components is a bit beyond the scope of this document, but the links below should be plenty to get them installed.

* Install [Docker CE Engine](https://docs.docker.com/engine/installation/)
* Install [Docker Compose](https://docs.docker.com/compose/install/)



## Development

1. Clone the repository

```bash
git clone https://github.com/cntgrd/server.git
cd server
``` 

2. Run the following command to spin up the Docker environment:

```bash
make deploy_dev
```

## Production

1. Clone the repository

```bash
git clone https://github.com/cntgrd/server.git
cd server
``` 

2. Run the following command to spin up the Docker environment:

```bash
make deploy_production
```
