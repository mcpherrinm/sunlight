#!/bin/bash
set -eu

stop() {
  ret=$?

  # Print the logs from each of the service containers.
  # This list needs to be kept in sync with ./integration/docker-compose.yml to get all logs
  for ctr in minio minio-setup dynamo aws-setup sunlight; do
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

# Template current date into config
echo "::group::template configuration file"
sed "s/TEST_LOG_INCEPTION_DATE/$(TZ=utc date '+%Y-%m-%d')/" <  etc/sunlight/integration-test-config.yaml.tmpl > etc/sunlight/integration-test-config.yaml
echo "::endgroup::"

# Start services in background
echo "::group::docker compose up"
docker compose up -d --wait
echo "::endgroup::"

# Run integration tests
echo "::group::Integration Test"
go test -tags=integration
echo "::endgroup::"
