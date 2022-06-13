#!/bin/bash

last_commit_hash=`git rev-parse --short HEAD`
container_name="softgrader_mysql_${last_commit_hash}"

if [ "$( docker container inspect -f '{{.State.Status}}' $container_name )" == "running" ]; then
    docker stop $container_name
    echo "$container_name stopped"
    docker-compose up -d db
fi
