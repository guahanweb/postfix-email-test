#!/usr/bin/env bash

export CONTAINER_NAME=${CONTAINER_NAME:-"postfix-local"}
export SERVER_HOSTNAME=${SERVER_HOSTNAME:-"mail.example.com"}
export DOCKER_TAG=${DOCKER_TAG:-"postfix_test:local"}
export LOG_PATH=${LOG_PATH:-"/app/logs"}

# application settings
export TEST_HOST="host.docker.internal"
export TEST_PORT=5080
