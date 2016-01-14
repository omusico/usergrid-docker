#!/bin/bash
#

#pushd java && docker build -t usergrid-java . && popd

pushd cassandra && docker build -t usergrid-cassandra . && popd
pushd elasticsearch && docker build -t usergrid-elasticsearch . && popd
pushd usergrid && docker build -t usergrid . && popd
pushd portal && docker build -t usergrid-portal . && popd

# batch clean up of dangling images if available
IMAGES=$(docker images -f "dangling=true" -q)
if [ -n "$IMAGES" ];
then
  docker rmi $IMAGES
fi