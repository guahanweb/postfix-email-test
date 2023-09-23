#!/usr/bin/env bash

export CONTAINER_NAME=${CONTAINER_NAME:-"postfix-local"}
export SERVER_HOSTNAME=${SERVER_HOSTNAME:-"mail.example.com"}
export DOCKER_TAG=${DOCKER_TAG:-"postfix_test:local"}
