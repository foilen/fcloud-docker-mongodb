#!/bin/bash

set -e

RUN_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $RUN_PATH

# Build
echo Compile
./create-local-release.sh

# Start
echo Start
INSTANCE=mongo_test

PASS_FILE=$(mktemp)
echo -n ABC > $PASS_FILE

echo START MongoDB
docker run \
  --name $INSTANCE \
  -p 27017:27017 \
  -v $PASS_FILE:/newPass \
  -d fcloud-docker-mongodb:master-SNAPSHOT \
  /mongodb-start.sh

# Wait for it to be ready
echo Wait for it to be ready
until docker exec -i $INSTANCE mongo 'mongodb://root:ABC@localhost:27017/' << _EOF
_EOF
do
sleep 2
done

# Go in
echo ; echo ; echo
echo Get in
echo ; echo ; echo
docker exec -it $INSTANCE mongo 'mongodb://root:ABC@localhost:27017/'

