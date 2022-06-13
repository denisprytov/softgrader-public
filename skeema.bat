@ECHO OFF

SET COMMAND=%1
SET PWD=%2
SET ALLOW_UNSAFE=%3

2>NUL CALL :CASE_%COMMAND% # jump to :CASE_diff, :CASE_push, etc.
IF ERRORLEVEL 1 CALL :DEFAULT_CASE # if command doesn't exist

EXIT /B

:CASE_diff
  docker exec softgrader_skeema skeema diff development %PWD% %ALLOW_UNSAFE% 2>&1
  GOTO END_CASE
:CASE_push
  docker exec softgrader_skeema skeema push development %PWD% %ALLOW_UNSAFE% 2>&1
  GOTO END_CASE
:CASE_pull
  docker exec softgrader_skeema skeema pull development %PWD% 2>&1
  GOTO END_CASE
:DEFAULT_CASE
  ECHO Unknown command "%COMMAND%"
  GOTO END_CASE
:END_CASE
  VER > NUL # reset ERRORLEVEL
  GOTO :EOF # return from CALL
