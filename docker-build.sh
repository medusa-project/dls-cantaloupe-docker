#!/bin/sh

source ./env.sh

docker build -t $APP_NAME -t $APP_NAME:$CANTALOUPE_VERSION .
