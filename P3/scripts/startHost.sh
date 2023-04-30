#!/bin/bash

declare -A script_mapping=(
  ["host_alilin-1"]="ip addr add 20.1.1.1/24 dev eth1"
  ["host_alilin-2"]="ip addr add 20.1.1.2/24 dev eth0"
  ["host_alilin-3"]="ip addr add 20.1.1.3/24 dev eth0"
  ["host_alilin-4"]="ip addr add 21.1.1.1/24 dev eth0"
  ["host_alilin-5"]="ip addr add 21.1.1.2/24 dev eth0"
  ["host_alilin-6"]="ip addr add 21.1.1.3/24 dev eth0"
  ["host_alilin-7"]="ip addr add 21.1.1.4/24 dev eth0"
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
