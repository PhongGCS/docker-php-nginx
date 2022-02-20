#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "ERROR: This script must be run as root" 
   exit 1
fi


source project.cfg


# prepare IP addresses
source files/scripts/ip-allocate.sh 1


docker-compose -p $DOCKER_CONTAINER_NAME up -d

# update the hosts file with all the web containers we know
sudo ./files/scripts/hosts-update.sh

# composer install
# docker-compose exec web bash -c "cd /app && composer install"

# create SSL certificates
#docker-compose exec web bash -c "mkdir -p /ssl && cd /ssl && cp /source/files/config/ssl.conf /ssl && sed -i "s/%%HOST%%/$LOCAL_DEV_HOSTNAME/g" /ssl/ssl.conf && cp /source/files/config/v3.ext /ssl && sed -i "s/%%HOST%%/$LOCAL_DEV_HOSTNAME/g" /ssl/v3.ext && cp /source/files/config/v3.ext /ssl && sed -i "s/%%HOST%%/$LOCAL_DEV_HOSTNAME/g" /ssl/v3.ext"
#docker-compose exec web bash -c "cd /ssl && openssl genrsa -out device.key 2048 && openssl req -new -key device.key -out device.csr -subj '/C=VN/ST=VN/L=HCMC/O=Conceptual Studio/OU=Conceptual/CN=$LOCAL_DEV_HOSTNAME' -nodes -config ssl.conf && openssl x509 -req -in device.csr -CA /source/files/docker/rootCA.pem -CAkey /source/files/docker/rootCA.key -CAcreateserial -out device.crt -days 5000 -sha256 -extfile v3.ext"
#docker-compose exec web bash -c "/etc/init.d/nginx restart"
#


