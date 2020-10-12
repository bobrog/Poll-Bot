#!/bin/bash

set -ex

#conf
: ${image_name:=pollbot}
: ${env_file:=`pwd`/.env/dev.json}

# build
docker build -t ${image_name} .

# run with cwd mounted in image
docker run \
    --rm \
    -v `pwd`:/usr/src/app \
    -v ${env_file}:/usr/src/app/config.json \
    ${image_name} ${@}
