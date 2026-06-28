#!/usr/bin/env bash

set -euo pipefail

source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../lib" && pwd)/helpers.sh"

load_env
require_commands docker
require_env_vars \
  POSTGRESQL_CONTAINER \
  POSTGRESQL_IMAGE \
  POSTGRESQL_VOLUME \
  POSTGRESQL_PORT \
  POSTGRESQL_USER \
  POSTGRESQL_PASSWORD \
  POSTGRESQL_DATABASE

remove_container_if_exists "$POSTGRESQL_CONTAINER"

docker run \
  --name "$POSTGRESQL_CONTAINER" \
  -v "$(repo_root)/src/init/postgresql:/docker-entrypoint-initdb.d" \
  -v "$POSTGRESQL_VOLUME:/var/lib/postgresql" \
  -e "POSTGRES_USER=${POSTGRESQL_USER}" \
  -e "POSTGRES_PASSWORD=${POSTGRESQL_PASSWORD}" \
  -e "POSTGRES_DB=${POSTGRESQL_DATABASE}" \
  -p "$POSTGRESQL_PORT:5432" \
  -d --rm "$POSTGRESQL_IMAGE" >/dev/null

printf 'PostgreSQL started: %s (localhost:%s)\n' "$POSTGRESQL_CONTAINER" "$POSTGRESQL_PORT"
