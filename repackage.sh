#!/bin/sh
#
# Builds Cantaloupe from the working copy, copies the resulting zip file
# into place, and rebuilds the image.

CWD=$(pwd)
CANTALOUPE_DIR=../../cantaloupe-project/cantaloupe
cd $CANTALOUPE_DIR
mvn clean package -DskipTests
cd "$CWD"
rm ./image_files/cantaloupe-*.zip
cp $CANTALOUPE_DIR/target/cantaloupe-*.zip ./image_files
./docker-build.sh
