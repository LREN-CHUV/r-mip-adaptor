#!/bin/bash

WORK_DIR="$(pwd)"
shift

sudo chmod -R a+rw $WORK_DIR

docker rm r-dev 2> /dev/null | true

echo "Cheat sheet - run the following commands:"
echo
echo "formatR::tidy_dir(\"R\")"
echo "  Format your source code"
echo
echo "lintr::lint_package()"
echo "  Checks the style of the source code"
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
docker run -v $WORK_DIR:/home/docker/data:rw \
    -i -t --rm --name r-dev \
    registry.federation.mip.hbp/mip_tools/r-interactive R

sudo chown -R $USER:$USER $WORK_DIR
