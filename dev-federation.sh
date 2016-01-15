docker run -v (pwd):/home/docker/data:rw \
    -v (pwd)/tests/local:/home/docker/data/tests \
    --rm --name r-test \
    --link dummydb:indb \
    --link analyticsdb:outdb \
    -e JOB_ID=001 \
    -e NODE=local \
    -e PARAM_query="select * from brain_feature" \
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
    -e OUT_FORMAT=INTERMEDIATE_RESULTS \
    registry.federation.mip.hbp/mip_tools/r-interactive check-package

docker run -i -t -v (pwd):/home/docker/data:rw \
    -v (pwd)/tests/local:/home/docker/data/tests \
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
    registry.federation.mip.hbp/mip_tools/r-interactive R
