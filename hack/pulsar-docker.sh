#!/usr/bin/env bash

set -e

ROOT=$(git rev-parse --show-toplevel)
pushd "${ROOT}" > /dev/null

IMAGE=terraform-provider-pulsar-standalone
CONTAINER=terraform-provider-pulsar-dev

case $1 in
run)
  docker build -t ${IMAGE} -f hack/pulsarimage/Dockerfile hack/pulsarimage
  docker run -d -p 6650:6650 -p 8080:8080 --name ${CONTAINER} ${IMAGE}
  until curl http://localhost:8080/admin/v2/tenants >/dev/null 2>&1; do
    sleep 1
    echo "Wait for pulsar service to be ready...$(date +%H:%M:%S)"
  done
  echo "Pulsar service is ready"
  ;;
remove)
  docker rm -f ${CONTAINER}
  ;;
esac

popd > /dev/null
