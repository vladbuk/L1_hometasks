# Working with mysql.

## Install mysql server on Centos Linux

sudo yum install mysql-server

### Start and check status

sudo systemctl start mysqld.service

sudo systemctl status mysqld

### Enable mysql service

sudo systemctl enable mysqld

### Disable (if needed) mysql service

sudo systemctl disable mysqld

### Secure mysql service

sudo mysql_secure_installation