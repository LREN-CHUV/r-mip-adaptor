#!/bin/bash -e

if groups $USER | grep &>/dev/null '\bdocker\b'; then
    DOCKER=docker
else
    DOCKER=sudo docker
fi

$DOCKER stop dummydb > /dev/null
$DOCKER rm dummydb > /dev/null
