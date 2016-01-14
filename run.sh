#!/bin/bash
#

DOMAIN=dzbw.de
ADMIN_USERNAME=admin
ADMIN_PASSWORD=admin
ADMIN_MAIL=admin@dzbw.de

ORG_NAME=dzbw
APP_NAME=hostinator

ORG_ADMIN_USERNAME=freund
ORG_ADMIN_PASSWORD=freund
ORG_ADMIN_REALNAME=Freund
ORG_ADMIN_EMAIL=s.freund@dzbw.de

# start dockerui
docker run -d --name dockerui -p 9000:9000 --privileged -v /var/run/docker.sock:/var/run/docker.sock dockerui/dockerui

# start cassandra and elasticsearch
docker run -d --name cassandra -p 9042:9042 -p 9160:9160 --volume $(pwd)/data/cassandra-data:/var/lib/cassandra usergrid-cassandra
docker run -d --name elasticsearch -p 9200:9200 -p 9300:9300 --volume $(pwd)/data/elasticsearch-data:/data usergrid-elasticsearch

# start usergrid server
docker run -d --name usergrid \
  -p 8080:8080 -p 8443:8443 \
  --env DOMAIN=${DOMAIN} --env ADMIN_USER=${ADMIN_USER} --env ADMIN_PASS=${ADMIN_PASS} --env ADMIN_MAIL=${ADMIN_MAIL} \
  --env ORG_NAME=${ORG_NAME} --env APP_NAME=${APP_NAME} \
  --env ORG_ADMIN_USERNAME=${ORG_ADMIN_USERNAME} --env ORG_ADMIN_PASSWORD=${ORG_ADMIN_PASSWORD} \
  --env ORG_ADMIN_REALNAME=${ORG_ADMIN_REALNAME} --env ORG_ADMIN_EMAIL=${ORG_ADMIN_EMAIL} \
  --link elasticsearch:elasticsearch --link cassandra:cassandra usergrid

# get usergrid server ip
USERGRID_IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' usergrid)
USERGRID_HOST="${USERGRID_IP}:8080"
USERGRID_HOST=10.129.3.239:8080

echo "Starting usergrid portal with usergrid host: ${USERGRID_HOST}"

# start usergrid portal and set USERGRID_HOST
docker run -d --name portal --env USERGRID_HOST=${USERGRID_HOST} --link usergrid:usergrid -p 80:80 usergrid-portal