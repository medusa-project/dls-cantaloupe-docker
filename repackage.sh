CWD=$(pwd)
cd ../cantaloupe
mvn clean package -DskipTests
cd $CWD
rm ./image_files/cantaloupe-*.zip
cp ../cantaloupe/target/cantaloupe-*-SNAPSHOT.zip ./image_files
./docker-build.sh
