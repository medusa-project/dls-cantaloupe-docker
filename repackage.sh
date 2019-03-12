CWD=$(pwd)
cd ../cantaloupe
mvn clean package -DskipTests
cd $CWD
cp ../cantaloupe/target/cantaloupe-4.1-SNAPSHOT.zip ./image_files
./docker-build.sh
