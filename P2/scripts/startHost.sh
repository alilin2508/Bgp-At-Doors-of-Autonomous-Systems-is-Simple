#!/bin/bash

declare -A script_mapping=(
  ["host_alilin-1"]="ip addr add 30.1.1.1/24 dev eth1"
  ["host_alilin-2"]="ip addr add 30.1.1.2/24 dev eth1"
)

for container in $(docker ps --filter "ancestor=busybox" --format "{{.Names}}");
do
  hostname=$(docker inspect --format '{{.Config.Hostname}}' $container)
  script=${script_mapping[$hostname]}
  if [[ -z $script ]]; then
    echo "No script found for container: $container (hostname: $hostname)"
    continue
  fi
  echo "Running script on container: $container (hostname: $hostname)"
  docker exec -it $container sh -c "$script"
done