#!/usr/bin/env bash

docker build --build-arg REPO_DIR=$REPO_DIR \
    --build-arg COMMAND=$COMMAND \
    -t autotransform \
    autotransform

if [[ $COMMAND == "schedule" || $COMMAND == "manage" ]]; then
    docker run -e AUTO_TRANSFORM_CONFIG=environment \
        -e AUTO_TRANSFORM_GITHUB_TOKEN="$GITHUB_TOKEN" \
        -v "$(pwd)":/$REPO_DIR \
        autotransform
    RESULT=$?
fi

if [[ $COMMAND == "run" ]]; then
    docker run -e AUTO_TRANSFORM_CONFIG=environment \
        -e AUTO_TRANSFORM_GITHUB_TOKEN="$GITHUB_TOKEN" \
        -e FILTER="$FILTER" \
        -e MAX_SUBMISSIONS="$MAX_SUBMISSIONS"
        -v "$(pwd)"/"$REPO_DIR":/$REPO_DIR \
        autotransform
    RESULT=$?
fi

if [[ $COMMAND == "update" ]]; then
    docker run -e AUTO_TRANSFORM_CONFIG=environment \
        -e AUTO_TRANSFORM_GITHUB_TOKEN="$GITHUB_TOKEN" \
        -e AUTO_TRANSFORM_CHANGE="$AUTO_TRANSFORM_CHANGE" \
        -v "$(pwd)"/"$REPO_DIR":/$REPO_DIR \
        autotransform
    RESULT=$?
fi

docker system prune -a -f >/dev/null 2>&1 &

if [[ -z $RESULT ]]; then
    echo "Unknown command $1"
    exit 1
fi
if [[ $RESULT -ne 0 ]]; then
    exit 1
fi
exit 0