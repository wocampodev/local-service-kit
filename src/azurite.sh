#!/usr/bin/env bash

set -euo pipefail

source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../lib" && pwd)/helpers.sh"

load_env
require_commands docker
require_env_vars \
  AZURITE_CONTAINER \
  AZURITE_IMAGE \
  AZURITE_VOLUME \
  AZURITE_BLOB_PORT \
  AZURITE_QUEUE_PORT \
  AZURITE_TABLE_PORT

remove_container_if_exists "$AZURITE_CONTAINER"
ensure_volume "$AZURITE_VOLUME"

docker run \
  --name "$AZURITE_CONTAINER" \
  -v "$AZURITE_VOLUME:/data" \
  -p "$AZURITE_BLOB_PORT:10000" \
  -p "$AZURITE_QUEUE_PORT:10001" \
  -p "$AZURITE_TABLE_PORT:10002" \
  -d --rm "$AZURITE_IMAGE" >/dev/null

printf 'Azurite started: %s (blob:%s queue:%s table:%s)\n' \
  "$AZURITE_CONTAINER" "$AZURITE_BLOB_PORT" "$AZURITE_QUEUE_PORT" "$AZURITE_TABLE_PORT"
