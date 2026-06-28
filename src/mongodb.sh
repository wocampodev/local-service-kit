#!/usr/bin/env bash

set -euo pipefail

source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../lib" && pwd)/helpers.sh"

load_env
require_commands docker
require_env_vars \
  MONGODB_CONTAINER \
  MONGODB_IMAGE \
  MONGODB_VOLUME \
  MONGODB_PORT \
  MONGODB_USERNAME \
  MONGODB_PASSWORD \
  MONGODB_DATABASE

remove_container_if_exists "$MONGODB_CONTAINER"
ensure_volume "$MONGODB_VOLUME-db"
ensure_volume "$MONGODB_VOLUME-configdb"

docker run \
  --name "$MONGODB_CONTAINER" \
  -v "$MONGODB_VOLUME-db:/data/db" \
  -v "$MONGODB_VOLUME-configdb:/data/configdb" \
  -v "$(repo_root)/src/init/mongodb:/docker-entrypoint-initdb.d" \
  -e "MONGO_INITDB_ROOT_USERNAME=${MONGODB_USERNAME}" \
  -e "MONGO_INITDB_ROOT_PASSWORD=${MONGODB_PASSWORD}" \
  -e "MONGO_INITDB_DATABASE=${MONGODB_DATABASE}" \
  -p "$MONGODB_PORT:27017" \
  -d --rm "$MONGODB_IMAGE" >/dev/null

printf 'MongoDB started: %s (localhost:%s)\n' "$MONGODB_CONTAINER" "$MONGODB_PORT"
