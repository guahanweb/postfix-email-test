#!/usr/bin/env bash

source ${DIR}/scripts/colors.sh

function run_tests() {
    start_time=$(gdate +%s.%3N)

    # start up the docker image
    docker run -d --name "${CONTAINER_NAME}" \
        -e "SERVER_HOSTNAME=${SERVER_HOSTNAME}" \
        -p 1337:25 \
        -t ${DOCKER_TAG} \
        > /dev/null 2>&1

    ok "POSTFIX container is running."

    # wait for the container to be healthy
    echo -n "${CYAN}[info]${NC} monitoring for readiness."
    while [ "`docker inspect -f {{.State.Health.Status}} ${CONTAINER_NAME}`" != "healthy" ]
    do
        echo -n "."
        sleep 1
    done
    echo $'\r'

    ok "POSTFIX container is healthy, running the tests."
    HOST="host.docker.internal" PORT=5000 node mailer

    # all done, so clean up
    docker stop ${CONTAINER_NAME} > /dev/null 2>&1
    docker rm ${CONTAINER_NAME} > /dev/null 2>&1

    end_time=$(gdate +%s.%3N)
    elapsed=$(echo "scale=3; $end_time - $start_time" | bc)

    ok "completed tasks in ${BOLD_WHITE}${elapsed} seconds${NC}"
}
