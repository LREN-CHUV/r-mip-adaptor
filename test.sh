#!/bin/bash -e

# TODO: consider https://github.com/sstephenson/bats to better report errors and test progress
# since tests are encapsulated into separate commands
# TODO: investigate why docker does not return an error code when a test fails.

WORK_DIR="$(pwd)"

if groups $USER | grep &>/dev/null '\bdocker\b'; then
  DOCKER="docker"
else
  DOCKER="sudo docker"
fi

sudo chmod -R a+rw $WORK_DIR

$DOCKER rm r-test 2> /dev/null | true

echo "Starting the results database..."
./tests/analytics-db/start-db.sh
echo
echo "Starting the test database..."
./tests/dummy-db/start-db.sh
echo

echo "> Test local node storing results as a dataset"
echo
$DOCKER run -v $WORK_DIR:/home/docker/data:rw \
    -v $WORK_DIR/tests/test_local_dataset:/home/docker/data/tests \
    --rm --name r-test \
    --link dummydb:indb \
    --link analyticsdb:outdb \
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
    registry.federation.mip.hbp/mip_tools/r-interactive check-package 2>&1 | sed -e "s|/home/docker/data|$WORK_DIR|g"

echo
echo "> Test federation node reading a dataset and storing this dataset as final result"
echo

$DOCKER run -v $WORK_DIR:/home/docker/data:rw \
    -v $WORK_DIR/tests/test_federation_dataset:/home/docker/data/tests \
    --rm --name r-test \
    --link analyticsdb:indb \
    --link analyticsdb:outdb \
    -e JOB_ID=001 \
    -e NODE=federation \
    -e PARAM_query="select * from job_result" \
    -e IN_JDBC_DRIVER=org.postgresql.Driver \
    -e IN_JDBC_JAR_PATH=/usr/lib/R/libraries/postgresql-9.4-1201.jdbc41.jar \
    -e IN_JDBC_URL=jdbc:postgresql://indb:5432/postgres \
    -e IN_JDBC_USER=postgres \
    -e IN_JDBC_PASSWORD=test \
    -e IN_FORMAT=INTERMEDIATE_RESULTS \
    -e OUT_JDBC_DRIVER=org.postgresql.Driver \
    -e OUT_JDBC_JAR_PATH=/usr/lib/R/libraries/postgresql-9.4-1201.jdbc41.jar \
    -e OUT_JDBC_URL=jdbc:postgresql://outdb:5432/postgres \
    -e OUT_JDBC_USER=postgres \
    -e OUT_JDBC_PASSWORD=test \
    hbpmip/r-interactive check-package 2>&1 | sed -e "s|/home/docker/data|$WORK_DIR|g"

sudo chown -R $USER:$USER $WORK_DIR

./tests/analytics-db/stop-db.sh
./tests/dummy-db/stop-db.sh

echo
echo "[ok] Success!"
