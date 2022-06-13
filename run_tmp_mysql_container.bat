@ECHO OFF

FOR /F "tokens=* USEBACKQ" %%F IN (`docker container inspect -f '{{.State.Status}}' softgrader_skeema`) DO (
SET skeema_status=%%F
)
if not [%skeema_status%]==['running'] (
    echo softgrader_skeema is not up
    docker-compose up -d skeema
)
echo softgrader_skeema is running

FOR /F "tokens=* USEBACKQ" %%F IN (`docker container inspect -f '{{.State.Status}}' softgrader_nginx`) DO (
SET nginx_status=%%F
)
if not [%nginx_status%]==['running'] (
    echo softgrader_nginx is not up
    docker-compose up -d nginx
)
echo softgrader_nginx is running

FOR /F "tokens=* USEBACKQ" %%F IN (`docker container inspect -f '{{.State.Status}}' softgrader_fpm`) DO (
SET fpm_status=%%F
)
if not [%fpm_status%]==['running'] (
    echo softgrader_fpm is not up
    docker-compose up -d php
)
echo softgrader_fpm is running

FOR /F "tokens=* USEBACKQ" %%F IN (`docker container inspect -f '{{.State.Status}}' softgrader_memcached`) DO (
SET memcached_status=%%F
)
if not [%memcached_status%]==['running'] (
    echo softgrader_memcached is not up
    docker-compose up -d memcached
)
echo softgrader_memcached is running

FOR /F "tokens=* USEBACKQ" %%F IN (`docker container inspect -f '{{.State.Status}}' softgrader_mysql`) DO (
SET mysql_status=%%F
)
if [%mysql_status%]==['running'] (
    echo softgrader_mysql is up
    docker-compose stop db
)
echo softgrader_mysql is stopped

FOR /F "tokens=* USEBACKQ" %%F IN (`git rev-parse --short HEAD`) DO (
SET last_commit_hash=%%F
)
set container_name=softgrader_mysql_%last_commit_hash%

FOR /F "tokens=* USEBACKQ" %%F IN (`docker container inspect -f '{{.State.Status}}' %container_name%`) DO (
SET container_status=%%F
)
if not [%container_status%]==['running'] (
    if not [%container_status%]==['exited'] (
        docker run -v %cd%/etc/mysql/my-local.cnf:/etc/mysql/conf.d/my-local.cnf ^
        -v %cd%/.:/var/www/softgrader -w /var/www/softgrader ^
        -p 3306:3306 --name %container_name% -e MYSQL_ROOT_PASSWORD=secret -d mysql:latest -hdb
        docker network connect --alias db softgrader_sg_net %container_name%
        echo %container_name% created and started
    ) else (
        docker start %container_name%
        echo %container_name% started
    )
)
