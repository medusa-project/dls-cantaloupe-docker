#!/bin/sh

source ./env.sh

docker run \
    -p 8182:8182 \
    --env-file env.list \
    $APP_NAME
