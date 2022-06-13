@ECHO OFF

FOR /F "tokens=* USEBACKQ" %%F IN (`git rev-parse --short HEAD`) DO (
SET last_commit_hash=%%F
)
set container_name=softgrader_mysql_%last_commit_hash%

FOR /F "tokens=* USEBACKQ" %%F IN (`docker container inspect -f '{{.State.Status}}' %container_name%`) DO (
SET tmp_mysql_status=%%F
)
if [%tmp_mysql_status%]==['running'] (
    docker stop %container_name%
    echo %container_name% stopped
    docker-compose up -d db
)
