#!/bin/bash

function log {
  local -r level="$1"
  local -r message="$2"
  local -r timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  >&2 echo -e "${timestamp} [${level}] [$SCRIPT_NAME] ${message}"
}

function log_info {
  local -r message="$1"
  log "\e[36mINFO\e[0m" "$message"
}

function log_warn {
  local -r message="$1"
  log "\e[33mWARN\e[0m" "$message"
}

function log_error {
  local -r message="$1"
  lo

# Usage:
```sh
log_info "test message"
log_warn "test message"
log_error "test message"
```