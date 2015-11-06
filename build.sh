#!/bin/bash

WORK_DIR="$(pwd)"
shift

sudo chmod -R a+rw $WORK_DIR

docker rm r-build 2> /dev/null | true

# Bind mount your data
# assuming that current folder contains the data
docker run -v $WORK_DIR:/home/docker/data:rw \
    --rm --name r-build \
    registry.federation.mip.hbp/mip_tools/r-interactive build-package 2>&1 | sed -e "s|/home/docker/data|$WORK_DIR|g"

sudo chown -R $USER:$USER $WORK_DIR
