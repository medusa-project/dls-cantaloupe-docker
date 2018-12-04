##
# Copies Docker environment variables from env.list into shell environment
# variables.
#
while read p; do
  if [[ $p != "#"* && $p != "" ]]; then
    IFS='=' read -ra parts <<< "$p"
    export "${parts[0]}"="${parts[1]}"
  fi
done < env.list
