#!/bin/bash

WORK_DIR="$(pwd)"
shift

if groups $USER | grep &>/dev/null '\bdocker\b'; then
  DOCKER="docker"
else
  DOCKER="sudo docker"
fi

sudo chmod -R a+rw $WORK_DIR

$DOCKER rm r-dev 2> /dev/null | true

./tests/analytics-db/start-db.sh
./tests/dummy-db/start-db.sh

echo "Cheat sheet - run the following commands:"
echo
echo "formatR::tidy_dir(\"R\")"
echo "  Format your source code"
echo
echo "lintr::lint_package()"
echo "  Checks the style of the source code"
echo
echo "devtools::load_all()"
echo "  Load the code in the current project"
echo
echo "devtools::document()"
echo "  Generates the documentation"
echo
echo "devtools::use_testthat()"
echo "  Setup the package to use testthat"
echo
echo "-----------------------------------------"

# Bind mount your data
# assuming that current folder contains the data
$DOCKER run -v $WORK_DIR:/home/docker/data:rw \
    -i -t --rm --name r-dev \
    --link dummydb:indb \
    --link analyticsdb:outdb \
    -e JOB_ID=001 \
    -e NODE=local \
    -e IN_JDBC_DRIVER=org.postgresql.Driver \
    -e IN_JDBC_JAR_PATH=/usr/lib/R/libraries/postgresql-9.4-1201.jdbc41.jar \
    -e IN_JDBC_URL=jdbc:postgresql://indb:5432/postgres \
    -e IN_JDBC_USER=postgres \
    -e IN_JDBC_PASSWORD=test \
    -e OUT_JDBC_DRIVER=org.postgresql.Driver \
    -e OUT_JDBC_JAR_PATH=/usr/lib/R/libraries/postgresql-9.4-1201.jdbc41.jar \
    -e OUT_JDBC_URL=jdbc:postgresql://outdb:5432/postgres \
    -e OUT_JDBC_USER=postgres \
    -e OUT_JDBC_PASSWORD=test \
    registry.federation.mip.hbp/mip_tools/r-interactive R

sudo chown -R $USER:$USER $WORK_DIR

./tests/analytics-db/stop-db.sh
./tests/dummy-db/stop-db.sh
