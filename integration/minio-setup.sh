#!/bin/sh

set -xeu

# This script creates a bucket named sunlight-integration with anonymous download access

mc alias set minio http://minio:9000 minioadmin minioadmin
mc mb --ignore-existing minio/sunlight-integration
mc anonymous set download minio/sunlight-integration
