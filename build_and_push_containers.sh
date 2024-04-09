#!/bin/bash

# Output executed commands and stop on errors.
set -e -x

# Ensure the correct builder is in use.
docker buildx use secure-edge-pro

# Function to build, tag, and push Docker images.
build_and_push_image() {
  local directory=$1
  local tag="192.168.140.1:5000/$directory:latest"
  local platform="linux/arm64/v8"

  cd "$directory"
  docker buildx build --platform "$platform" --tag "$tag" --push .
  cd ..
}

# Build and push the ftp-server image.
build_and_push_image "ftp-server" 

# Build and push the backup-service image.
build_and_push_image "backup-service"

# Build and push the backup-webui image.
build_and_push_image "backup-webui"
