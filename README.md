# Centigrade Server
Collects data from the Centigrade platform and relays it to the Centigrade app.

# Deployment

## Initial Setup
Before the Centigrade backend can be deployed, the host system must be set up to work with Docker. Apart from setting up a new server with users, etc., the requirements for deployment are the Docker CE Engine, Docker Compose, the Swift environment, and the Vapor web framework.

Swift and Vapor are easy enough to install, just run the following commands:
```bash
sudo apt update
sudo apt install -y curl
curl -sL https://apt.vapor.sh | bash
sudo apt update
sudo apt install -y swift vapor
```

The installation of the Docker components is a bit beyond the scope of this document, but the links below should be plenty to get them installed.

* Install [Docker CE Engine](https://docs.docker.com/engine/installation/)
* Install [Docker Compose](https://docs.docker.com/compose/install/)

### Create Docker secrets on host machine

Docker secrets are used as a [more secure alternative](https://diogomonica.com/2017/03/27/why-you-shouldnt-use-env-variables-for-secret-data/) to environment variables. For this application, the only necessary secrets are the credentials for the database.

To create these secrets, on the host machine, use the command `echo "<secret_info>" | docker secret creat <secret_name> -` to create each secret, making sure to include the trailing '-'. This system requires the following secrets:
* `db_name` - contains the name of the database
* `db_pass` - contains the password of the database
* `db_user` - contains the username of the database

For example, to create the `db_user` secret containing the username `username`, one would run:
```bash
echo "username" | docker secret create db_user -
```

### Initialize Docker Swarm

Initialize Docker Swarm by entering in the command
```bash
docker swarm init
```

**NB** Depending on the host system, there may be more than one IP address to which the Swarm instance can bind. In this case, the command will fail and print which IP addresses it can bind to. Among the options, choose the public IP address and attempt the command again, appending with `--advertise-addr <IP_address>` (e.g. `docker swarm init --advertise-addr 192.168.0.1`).

## Deploy

1. Navigate to the project directory
2. Run `docker stack deploy -c <docker-compose.yml> <stack_name>`, making sure to name the stack with a relevant, memorable name.
