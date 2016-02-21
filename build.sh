#!/bin/bash

WORK_DIR="$(pwd)"
shift

if groups $USER | grep &>/dev/null '\bdocker\b'; then
  DOCKER="docker"
else
  DOCKER="sudo docker"
fi

sudo chmod -R a+rw $WORK_DIR

$DOCKER rm r-build 2> /dev/null | true

# Bind mount your data
# assuming that current folder contains the data
$DOCKER run -v $WORK_DIR:/home/docker/data:rw \
    --rm --name r-build \
    hbpmip/r-interactive build-package 2>&1 | sed -e "s|/home/docker/data|$WORK_DIR|g"

sudo chown -R $USER:$USER $WORK_DIR
