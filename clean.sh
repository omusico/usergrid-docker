#!/bin/bash
#

# Make sure that exited containers are deleted.
CONTAINERS=$(docker ps -a -q -f status=exited)
if [ -n "$CONTAINERS" ];
then
  docker rm -v $CONTAINERS
fi

# Remove unwanted ‘dangling’ images
IMAGES=$(docker images -f "dangling=true" -q)
if [ -n "$IMAGES" ];
then
  docker rmi $IMAGES
fi

# cleanup stored container data from host
sudo rm -rf data/cassandra-data/*
sudo rm -rf data/elasticsearch-data/*

# If your docker directory still takes up space, that probably means that you have unwanted volumes filling up in your disk. 
# The -v flag we passed to rm command usually takes care of this. But sometimes, if your way of shutting down containers 
# do not auto remove the containers, the vfs directory will grow pretty fast. We can reclaim this space by deleting the 
# unwanted volumes. To do this, there’s a docker image that you can use!
# see: http://blog.yohanliyanage.com/2015/05/docker-clean-up-after-yourself/
#docker run -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/docker:/var/lib/docker --rm martin/docker-cleanup-volumes