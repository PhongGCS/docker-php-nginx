#!/bin/bash
source project.cfg

if [ $# -eq 0 ]
  then
    echo "Do not run this script manually."
	exit 0
fi


# make sure the network is created
docker network create localdev

# look into the network specs and find the last used IP
LAST_IP=$(docker inspect $DOCKER_NETWORK | grep IPv4Address | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' | sort -Vr | head -n 1)

if [ -z "$LAST_IP" ]
then
	LAST_IP=$(docker inspect $DOCKER_NETWORK | grep Gateway | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}')
fi

LAST_DIGIT=${LAST_IP##*.}
NET=${LAST_IP%.*}

# define the IP that the Docker container will be listening on (bind)
DOCKER_IP=$NET.$((LAST_DIGIT+1))
COMPOSE_PROJECT_NAME=$DOCKER_CONTAINER_NAME
NGINX_PORT_1=80:80
NGINX_PORT_2=443:443

sudo ifconfig lo0 add $DOCKER_IP netmask 0xffffffff
echo "Allocated IP: "$DOCKER_IP

echo "DOCKER_IP="$DOCKER_IP > .env
echo "DOCKER_NETWORK="$DOCKER_NETWORK >> .env
echo "DOCKER_CONTAINER_NAME="$DOCKER_CONTAINER_NAME >> .env
echo "COMPOSE_PROJECT_NAME="$COMPOSE_PROJECT_NAME >> .env
echo "NGINX_PORT_1="$NGINX_PORT_1 >> .env
echo "NGINX_PORT_2="$NGINX_PORT_2 >> .env