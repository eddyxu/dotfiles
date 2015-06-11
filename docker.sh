#!/bin/bash

ISO_URL="https://github.com/boot2docker/boot2docker/releases/download/v1.6.2/boot2docker.iso"

function docker-create() {
  if [ $# -eq 0 ]; then
    echo "Usage: docker-create <name>"
    exit 1
  fi
  name=$1
  docker-machine create -d vmwarefusion $name \
    --vmwarefusion-boot2docker-url "$ISO_URL" \
    --vmwarefusion-memory-size "2048"
}

function docker-env() {
  eval $(docker-machine env $1)
}
