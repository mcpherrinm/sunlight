#!/bin/bash
set -eu

stop() {
  ret=$?

  # Print the logs from each of the service containers.
  # This list needs to be kept in sync with ./integration/docker-compose.yml
  for ctr in minio dynamo aws-setup sunlight; do
    name="integration-$ctr-1"
    echo "::group::$name logs"
    docker logs -t "$name" || echo "no logs"
    echo "::endgroup::"
  done

  echo "::group::docker compose down"
  docker compose down
  echo "::endgroup::"

  exit $ret
}

trap stop EXIT

# Build containers:
echo "::group::docker compose build"
docker compose build
echo "::endgroup::"

# Start services in background
echo "::group::docker compose up"
docker compose up -d --wait
echo "::endgroup::"

# Run integration tests
echo "::group::Integration Test"
go test -tags=integration
echo "::endgroup::"
