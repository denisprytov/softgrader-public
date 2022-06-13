#!/bin/bash

# how to use: ./upload_mysql_data.sh <folder> <user> <password> <database name>

if [ $# == 4 ]; then
    for sql_file in $1/*.sql; do
        echo "Run $sql_file"
        mysql -u$2 -p$3 $4 < $sql_file
    done
else
    echo "Wrong number of arguments!"
fi
