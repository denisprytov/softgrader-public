@ECHO OFF

FOR /F "tokens=* USEBACKQ" %%F IN (`git rev-parse --short HEAD`) DO (
SET last_commit_hash=%%F
)
set container_name=softgrader_mysql_%last_commit_hash%

FOR /F "tokens=* USEBACKQ" %%F IN (`docker container inspect -f '{{.State.Status}}' %container_name%`) DO (
SET tmp_mysql_status=%%F
)
if [%tmp_mysql_status%]==['exited'] (
    SETLOCAL EnableDelayedExpansion
    choice /C:YN /N /M:"%container_name% will be deleted! Are you sure?(y/n)"
    IF ERRORLEVEL ==2 GOTO END
    IF ERRORLEVEL ==1 GOTO YES
    GOTO END

    :YES
    docker stop %container_name%
    docker rm -v %container_name%
    echo [+] %container_name% deleted
    EXIT

    :END
    EXIT
) else (
    echo [!] No container to remove or container is running
)
