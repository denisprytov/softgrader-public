#!/bin/bash

last_commit_hash=`git rev-parse --short HEAD`
container_name="softgrader_mysql_${last_commit_hash}"

if [ "$( docker container inspect -f '{{.State.Status}}' $container_name )" == "exited" ]; then
    read -p "${container_name} will be deleted! Are you sure?(y/n) "
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        docker stop $container_name
        docker rm -v $container_name
        echo "$container_name deleted"
    fi
else
    echo "No container to remove or container is running"
fi
