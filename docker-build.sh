#!/bin/sh

source ./env.sh

ZIP_FILE=$(ls image_files/cantaloupe-*)
VERSION=$(echo $ZIP_FILE | sed -En 's/image_files\/cantaloupe-(.+).zip$/\1/p')

docker build -t $APP_NAME -t $APP_NAME:$CANTALOUPE_VERSION .
