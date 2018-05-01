#!/bin/bash

## TODO: not functional anymore

WORK_DIR="$(pwd)"

if groups $USER | grep &>/dev/null '\bdocker\b'; then
  DOCKER="docker"
else
  DOCKER="sudo docker"
fi

sudo chmod -R a+rw $WORK_DIR

$DOCKER rm r-dev 2> /dev/null | true

if pgrep -lf sshuttle > /dev/null ; then
  echo "sshuttle detected. Please close this program as it messes with networking and prevents Docker links to work"
  exit 1
fi

echo "Starting the databases..."
./tests/up.sh
echo

echo "Cheat sheet - run the following commands:"
echo
echo "setwd('/src')"
echo "devtools::load_all()"
echo "  # Load the code in the current project"
echo
echo "setwd('/src')"
echo "formatR::tidy_dir(\"R\")"
echo "  # Format your source code"
echo
echo "setwd('/src')"
echo "lintr::lint_package()"
echo "  # Checks the style of the source code"
echo
echo "setwd('/src')"
echo "devtools::document()"
echo "  # Generates the documentation"
echo
echo "setwd('/src')"
echo "devtools::use_testthat()"
echo "  # Setup the package to use testthat"
echo
echo "-----------------------------------------"

$DOCKER run -v $WORK_DIR:/home/docker/data:rw \
    -v $WORK_DIR/:/src/ \
    -v $WORK_DIR/tests:/src/tests/ \
    -i -t --rm --name r-dev \
    --link db:db \
    --network tests_default \
    -e JOB_ID=001 \
    -e NODE=local \
    -e IN_DBI_DRIVER=PostgreSQL \
    -e IN_HOST=db \
    -e IN_PORT=5432 \
    -e IN_DATABASE=datadb \
    -e IN_USER=data \
    -e IN_PASSWORD=datapwd \
    -e OUT_DBI_DRIVER=PostgreSQL \
    -e OUT_HOST=db \
    -e OUT_PORT=5432 \
    -e OUT_DATABASE=wokendb \
    -e OUT_USER=woken \
    -e OUT_PASSWORD=wokenpwd \
    hbpmip/r-interactive R

sudo chown -R $USER:$USER $WORK_DIR

#./tests/stop.sh
