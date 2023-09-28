#!/usr/bin/env bash

source ${DIR}/scripts/colors.sh

function build_image() {
    # build the docker image
    docker build -t ${DOCKER_TAG} ${DIR} > /dev/null 2>&1
    [ $? == 0 ] || fail "failed to build image: ${BOLD_WHITE}${DOCKER_TAG}${NC} from ${CYAN}${DIR}${NC}"
    ok "successfully built docker image: ${BOLD_WHITE}${DOCKER_TAG}${NC}"
}

function require_image() {
    if [[ -z "$(docker images -q ${DOCKER_TAG})" ]]
    then
        info "image ${BOLD_WHITE}${DOCKER_TAG}${NC} does not exist, building..."
        build_image
    fi
}

function start_postfix() {
    docker run --rm -d --name "${CONTAINER_NAME}" \
        -e "SERVER_HOSTNAME=${SERVER_HOSTNAME}" \
        -p 1337:25 \
        -v ${PROJECT_ROOT}/app/logs:/app/logs \
        -t ${DOCKER_TAG} \
        > /dev/null 2>&1

    ok "POSTFIX container started."
}

function stop_postfix() {
    docker stop ${CONTAINER_NAME} > /dev/null 2>&1
    ok "POSTFIX container stopped."
}

function run_tests() {
    start_time=$(gdate +%s.%3N)

    # start up the docker image
    start_postfix

    # wait for the container to be healthy
    echo -n "${CYAN}[info]${NC} monitoring for readiness."
    while [ "`docker inspect -f {{.State.Health.Status}} ${CONTAINER_NAME}`" != "healthy" ]
    do
        echo -n "."
        sleep 1
    done
    echo $'\r'

    ok "POSTFIX container is healthy, running the tests."
    HOST="${TEST_HOST}" PORT=${TEST_PORT} node mailer

    # all done, so clean up
    stop_postfix

    end_time=$(gdate +%s.%3N)
    elapsed=$(echo "scale=3; $end_time - $start_time" | bc)

    ok "completed tasks in ${BOLD_WHITE}${elapsed} seconds${NC}"
}
