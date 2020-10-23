#!/bin/bash

set -ex

#conf
: ${git_branch:=`git rev-parse --abbrev-ref HEAD`}
: ${image_name:=pollbot}
: ${env_file:=`pwd`/.env/prod.json}
git_hash=`git rev-parse HEAD`

# build
container_version=${image_name}:${git_branch}-${git_hash:0:5}
docker build -t ${container_version} .

running_container=`docker ps --filter="name=${image_name}_${git_branch}" -q`
if [ -n "${running_container}" ]; then
    docker stop ${running_container}
    docker rm ${running_container}
fi

# run in headless/always on mode
docker run \
    -d \
    --restart always \
    -v ${env_file}:/usr/src/app/config.json \
    --name ${image_name}_${git_branch} \
    ${container_version}
