#!/usr/bin/env bash

repo_root() {
  local script_dir

  script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
  cd -- "$script_dir/.." && pwd
}

load_env() {
  local env_file="${1:-$(repo_root)/.local.env}"

  if [[ ! -f "$env_file" ]]; then
    printf 'Error: %s not found.\n' "$env_file" >&2
    printf 'Copy .local.env.example to .local.env and fill the required values.\n' >&2
    exit 1
  fi

  set -a
  # shellcheck source=/dev/null
  source "$env_file"
  set +a
}

require_commands() {
  local missing=()

  for command_name in "$@"; do
    if ! command -v "$command_name" >/dev/null 2>&1; then
      missing+=("$command_name")
    fi
  done

  if ((${#missing[@]} > 0)); then
    printf 'Error: missing required command(s): %s\n' "${missing[*]}" >&2
    exit 1
  fi
}

require_env_vars() {
  local missing=()
  local var_name

  for var_name in "$@"; do
    if [[ -z ${!var_name:-} ]]; then
      missing+=("$var_name")
    fi
  done

  if ((${#missing[@]} > 0)); then
    printf 'Error: missing required environment variable(s): %s\n' "${missing[*]}" >&2
    exit 1
  fi
}

container_exists() {
  local container_name=$1

  docker container inspect "$container_name" >/dev/null 2>&1
}

remove_container_if_exists() {
  local container_name=$1

  if container_exists "$container_name"; then
    printf 'Removing existing container: %s\n' "$container_name"
    docker rm -f "$container_name" >/dev/null
  fi
}

ensure_volume() {
  local volume_name=$1

  if ! docker volume inspect "$volume_name" >/dev/null 2>&1; then
    printf 'Creating volume: %s\n' "$volume_name"
    docker volume create "$volume_name" >/dev/null
  fi
}
