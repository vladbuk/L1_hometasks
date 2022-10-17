#!/bin/bash

# run mysql in docker container with permanent storage and exposed port
docker run --name mysql -d -v mysql_data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=password -p 3306:3306 mysql:latest

# enter to mysql container
docker exec -it mysql bash

# create db
mysqladmin -u root -p create taskdb

# show databases
mysql -u root -p -e 'show databases;'

# MySQL commands