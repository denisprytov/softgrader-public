@ECHO OFF

docker run --rm -v %~dp0:/softgrader ^
-v %~dp0/.github/linters/phpstan.neon:/softgrader/.github/linters/phpstan.neon ^
ghcr.io/phpstan/phpstan analyse -c /softgrader/.github/linters/phpstan.neon /softgrader/%1