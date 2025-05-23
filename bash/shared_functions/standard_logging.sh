#!/bin/bash

# source the colors function
source ./colors.sh

function log {
  local -r level="$1"
  local -r message="$2"
  local -r timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  >&2 echo -e "${timestamp} [${level}] [$SCRIPT_NAME] ${message}"
}

function log_info {
  local -r message="$(rgb b)$1$(rgb e)"
  log "INFO" "$message"
}

function log_warn {
  local -r message="$(rgb y)$1$(rgb e)"
  log "WARN" "$message"
}

function log_error {
  local -r message="$(rgbb b)$1$(rgb e)"
  log "ERROR" "$message"
}

# Usage:
```sh
log_info "test message"
log_warn "test message"
log_error "test message"
```

# Built-in color
# function log {
#   local -r level="$1"
#   local -r message="$2"
#   local -r timestamp=$(date +"%Y-%m-%d %H:%M:%S")
#   >&2 printf "[${timestamp}] [${level}] ${message}\n"
# }

# function log_info {
#   local -r message="$1"
#   log "\e[36mINFO\e[0m" "\e[36m$message\e[0m"
# }

# function log_warn {
#   local -r message="$1"
#   log "\e[33mWARN\e[0m" "\e[33m$message\e[0m"
# }

# function log_error {
#   local -r message="$1"
#   log "\e[31mERROR\e[0m" "\e[31m$message\e[0m"
# }