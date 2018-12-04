#!/bin/sh

source ./env.sh

docker build -t $APP_NAME .
