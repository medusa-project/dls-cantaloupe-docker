##
# Copies Docker environment variables from env.list into shell environment
# variables.
#

while read p; do
  if [[ $p != "#"* && $p != "" ]]; then
    KEY=$(cut -d'=' -f1 <<< $p)
    VALUE=$(cut -d'=' -f2 <<< $p)
    export "${KEY}"="${VALUE}"
  fi
done < env.list

ZIP_FILE=$(ls image_files/cantaloupe-*)
CANTALOUPE_VERSION=$(echo $ZIP_FILE | sed -En 's/image_files\/cantaloupe-(.+).zip$/\1/p')