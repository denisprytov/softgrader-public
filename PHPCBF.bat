@ECHO OFF

docker run --rm -v %~dp0:/data/softgrader ^
-v %~dp0/.github/linters/phpcs.xml:/data/phpcs.xml cytopia/phpcbf softgrader/%1