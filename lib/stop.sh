#!/usr/bin/env bash

set -euo pipefail

source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/helpers.sh"

if (($# != 1)); then
  printf 'Usage: stop.sh <service>\n' >&2
  exit 1
fi

service=$1

load_env
require_commands docker

hostname_var=${service^^}_CONTAINER

require_env_vars "$hostname_var"

container_name=${!hostname_var}

if container_exists "$container_name"; then
  printf 'Removing container: %s\n' "$container_name"
  docker rm -f "$container_name" >/dev/null
else
  printf 'Container not found: %s\n' "$container_name"
fi
