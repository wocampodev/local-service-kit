#!/usr/bin/env bash

set -euo pipefail

source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../lib" && pwd)/helpers.sh"

load_env
require_commands docker
require_env_vars \
  COSMOSDB_CONTAINER \
  COSMOSDB_IMAGE \
  COSMOSDB_VOLUME \
  COSMOSDB_GATEWAY_PORT \
  COSMOSDB_HEALTH_PORT \
  COSMOSDB_DATA_EXPLORER_PORT

remove_container_if_exists "$COSMOSDB_CONTAINER"
ensure_volume "$COSMOSDB_VOLUME"

docker run \
  --name "$COSMOSDB_CONTAINER" \
  -v "$COSMOSDB_VOLUME:/data" \
  -p "$COSMOSDB_GATEWAY_PORT:8081" \
  -p "$COSMOSDB_HEALTH_PORT:8080" \
  -p "$COSMOSDB_DATA_EXPLORER_PORT:1234" \
  -d --rm "$COSMOSDB_IMAGE" >/dev/null

printf 'Cosmos DB emulator started: %s (gateway:%s health:%s explorer:%s)\n' \
  "$COSMOSDB_CONTAINER" "$COSMOSDB_GATEWAY_PORT" "$COSMOSDB_HEALTH_PORT" "$COSMOSDB_DATA_EXPLORER_PORT"
