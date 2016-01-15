#!/bin/bash -e

get_script_dir () {
     SOURCE="${BASH_SOURCE[0]}"

     while [ -h "$SOURCE" ]; do
          DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
          SOURCE="$( readlink "$SOURCE" )"
          [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
     done
     cd -P "$( dirname "$SOURCE" )"
     pwd
}

if pgrep -lf sshuttle > /dev/null ; then
  echo "sshuttle detected. Please close this program as it messes with networking and prevents Docker links to work"
  exit 1
fi

if groups $USER | grep &>/dev/null '\bdocker\b'; then
    DOCKER="docker"
else
    DOCKER="sudo docker"
fi

$DOCKER rm --force dummydb 2> /dev/null | true
$DOCKER run --name dummydb \
    -v $(get_script_dir)/sql:/docker-entrypoint-initdb.d/ \
    -e POSTGRES_PASSWORD=test -d postgres:9.4.5

$DOCKER exec dummydb \
    /bin/bash -c 'while ! pg_isready -U postgres ; do sleep 1; done'
