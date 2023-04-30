#!/bin/bash

declare -A script_mapping1=(
  ["routeur_alilin-1"]="/scripts_p2/unicast/routeur_1_uc.sh"
  ["routeur_alilin-2"]="/scripts_p2/unicast/routeur_2_uc.sh"
)

declare -A script_mapping2=(
  ["routeur_alilin-1"]="/scripts_p2/multicast/routeur_1_mc.sh"
  ["routeur_alilin-2"]="/scripts_p2/multicast/routeur_2_mc.sh"
)

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <static|multicast>"
  exit 1
fi

if [[ $1 == "static" ]]; then
  script_mapping=("${script_mapping1[@]}")
elif [[ $1 == "multicast" ]]; then
  script_mapping=("${script_mapping2[@]}")
else
  echo "Invalid mapping argument: $1"
  exit 1
fi

for container in $(docker ps --filter "ancestor=routing" --format "{{.Names}}");
do
  hostname=$(docker inspect --format '{{.Config.Hostname}}' $container)
  script=${script_mapping[$hostname]}
  if [[ -z $script ]]; then
    echo "No script found for container: $container (hostname: $hostname)"
    continue
  fi
  echo "Running script on container: $container (hostname: $hostname)"
  docker exec -it $container bash -c "chmod +x /$script && /$script"
done