#!/bin/sh

set -xeuo pipefail

# This script conditionally creates a DynamoDB table for the sunlight integration tests to use

export AWS_REGION=localhost
export AWS_ACCESS_KEY_ID=bogus
export AWS_SECRET_ACCESS_KEY=aws_cli_requires_credentials

aws dynamodb describe-table --table-name sunlight-integration --endpoint-url http://dynamo:8000 || \
  aws dynamodb create-table --endpoint-url http://dynamo:8000 \
    --table-name sunlight-integration \
    --attribute-definitions AttributeName=logID,AttributeType=B \
    --key-schema AttributeName=logID,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1
