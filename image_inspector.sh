#!/usr/bin/env bash

# Get list of running container IDs
container_ids=$(docker ps -q)

if [ -z "$container_ids" ]; then
  echo "No running containers found."
  exit 0
fi

echo "Inspecting running containers..."
echo

for id in $container_ids; do
  # Get container name and image
  name=$(docker inspect --format '{{.Name}}' "$id" | sed 's/^\/\(.*\)/\1/')
  image=$(docker inspect --format '{{.Config.Image}}' "$id")

  # Try to get the debian version
  version=$(docker exec "$id" cat /etc/debian_version 2>/dev/null)

  echo "Container: $name"
  echo "  Image: $image"
  if [ -n "$version" ]; then
    echo "  Debian version: $version"
  else
    echo "  /etc/debian_version not found"
  fi
  echo
done
