#!/bin/bash

if [ "$( docker container inspect -f '{{.State.Status}}' softgrader_skeema )" != "running" ]; then
    echo "softgrader_skeema is not up"
    docker-compose up -d skeema
fi
echo "softgrader_skeema is running"

if [ "$( docker container inspect -f '{{.State.Status}}' softgrader_nginx )" != "running" ]; then
    echo "softgrader_nginx is not up"
    docker-compose up -d nginx
fi
echo "softgrader_nginx is running"

if [ "$( docker container inspect -f '{{.State.Status}}' softgrader_fpm )" != "running" ]; then
    echo "softgrader_fpm is not up"
    docker-compose up -d php
fi
echo "softgrader_fpm is running"

if [ "$( docker container inspect -f '{{.State.Status}}' softgrader_memcached )" != "running" ]; then
    echo "softgrader_memcached is not up"
    docker-compose up -d memcached
fi
echo "softgrader_memcached is running"

if [ "$( docker container inspect -f '{{.State.Status}}' softgrader_mysql )" == "running" ]; then
    echo "softgrader_mysql is up"
    docker-compose stop db
fi
echo "softgrader_mysql is stopped"

last_commit_hash=`git rev-parse --short HEAD`
container_name="softgrader_mysql_${last_commit_hash}"
container_status=`docker container inspect -f '{{.State.Status}}' $container_name`


if [ "$container_status" != "running" ] && [ "$container_status" != "exited" ]; then
    docker run -v `pwd`/etc/mysql/my-local.cnf:/etc/mysql/conf.d/my-local.cnf \
    -v `pwd`/.:/var/www/softgrader -w /var/www/softgrader \
    -p 3306:3306 --name $container_name -e MYSQL_ROOT_PASSWORD=secret -d mysql:latest -hdb
    docker network connect --alias db softgrader_sg_net $container_name
    echo "$container_name created and started"
else
    docker start $container_name
    echo "$container_name started"
fi
