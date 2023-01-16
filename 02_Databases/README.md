# Working with mysql.

## Part1. Install mysql server and work with database
-----------------------------------------------------

sudo yum install mysql-server
or sudo apt install mysql-server

### Start and check status

sudo systemctl start mysqld.service

sudo systemctl status mysqld

### Enable mysql service

sudo systemctl enable mysqld

### Disable (if needed) mysql service

sudo systemctl disable mysqld

### Secure mysql service

sudo mysql_secure_installation

### Connect to DB

mysql -u root -p [databasename]

### Initialize database

```
mysql> create database homework;
Query OK, 1 row affected (0.01 sec)

mysql> grant all privileges on homework.* to 'root'@'localhost';
Query OK, 0 rows affected, 1 warning (0.01 sec)
```

I have created a database from a sql file.

```
mysql -u root -p homework --protocol=tcp < /home/vladbuk/projects/L1_hometasks/02_Databases/db.sql
```

## Some SQL queries

```
mysql> show tables;
+--------------------+
| Tables_in_homework |
+--------------------+
| categories         |
| customers          |
| orders             |
| products           |
+--------------------+
4 rows in set (0.01 sec)
```

```
mysql> select name, email from customers where email like '%com';
+-----------------+----------------------------+
| name            | email                      |
+-----------------+----------------------------+
| Hope Macejkovic | lynch.ramon@gmail.com      |
| Vernice Wisoky  | schaden.murl@langworth.com |
| Daija Ortiz     | ardith54@yahoo.com         |
+-----------------+----------------------------+
3 rows in set (0.00 sec)

```

```
mysql> select title from products order by title asc;
+--------------------------------------------------------------+
| title                                                        |
+--------------------------------------------------------------+
| 15 Minutes x 15 Days Yoga                                    |
| Breath is Life: Pranayama, meditation course - Yoga Alliance |
| Learn Python: The Complete Python Programming Course         |
| Spanish for Beginners                                        |
| The Complete 2022 Web Development Bootcamp                   |
| The English Master Course                                    |
+--------------------------------------------------------------+
6 rows in set (0.00 sec)
```

```
mysql> select productCode, count(customerId) from orders group by productCode order by productCode asc;
+-------------+-------------------+
| productCode | count(customerId) |
+-------------+-------------------+
| 1001        |                 1 |
| 1002        |                 2 |
| 1003        |                 1 |
| 1004        |                 2 |
| 1005        |                 1 |
| 1006        |                 2 |
| 1007        |                 1 |
+-------------+-------------------+
7 rows in set (0.00 sec)

```

```
mysql> select count(productCode), name from orders, customers where customers.id = orders.customerId group by name order by count(productCode) asc;
+--------------------+-----------------+
| count(productCode) | name            |
+--------------------+-----------------+
|                  1 | Rick Greenholt  |
|                  2 | Hope Macejkovic |
|                  2 | Vernice Wisoky  |
|                  2 | Eriberto Wunsch |
|                  3 | Daija Ortiz     |
+--------------------+-----------------+
5 rows in set (0.00 sec)
```

```
INSERT INTO orders VALUES (11, 2, 1001, 2);

mysql> select * from orders where customerId=2;
+----+------------+-------------+----------+
| id | customerId | productCode | quantity |
+----+------------+-------------+----------+
|  3 |          2 | 1004        |        1 |
|  4 |          2 | 1005        |        1 |
| 11 |          2 | 1001        |        2 |
+----+------------+-------------+----------+
3 rows in set (0.00 sec)

```

```
UPDATE customers SET phone = '3-123-229-5927' WHERE name = 'Eriberto Wunsch'; 

mysql> select name, phone from customers where name = 'Eriberto Wunsch';
+-----------------+----------------+
| name            | phone          |
+-----------------+----------------+
| Eriberto Wunsch | 3-123-229-5927 |
+-----------------+----------------+
1 row in set (0.00 sec)

```

```
DELETE FROM orders WHERE id = 11;

mysql> select * from orders where customerId=2;
+----+------------+-------------+----------+
| id | customerId | productCode | quantity |
+----+------------+-------------+----------+
|  3 |          2 | 1004        |        1 |
|  4 |          2 | 1005        |        1 |
+----+------------+-------------+----------+
2 rows in set (0.00 sec)

```

```
GRANT select, update ON homework.* TO 'test'@'localhost';
```

## Part 2. Backup and restore database
--------------------------------------

### Backup
```
mysqldump -u root -p homework > /tmp/homework.dump.sql
```
Or if we started mysql server in docker container:
```
mysqldump -u root -p --protocol=tcp homework > /tmp/homework.dump.sql
```

Make gzipped dump:
```
mysqldump -u root -p --protocol=tcp homework | gzip > /tmp/homework.dump.sql.gzip
```

Make gzipped dump named with current date and time:
```
mysqldump -u root -p --protocol=tcp homework | gzip > `date +/tmp/homework.dump_%Y%m%d-%H%M%S_sql.gzip`
```

Results:
```
vladbuk@ubuntu-desktop:~/projects/L1_hometasks$ ll /tmp/home*
-rw-rw-r-- 1 ut ut 2.1K Jan 16 18:46 /tmp/homework.dump_20230116-184640_sql.gzip
-rw-rw-r-- 1 ut ut   20 Jan 16 18:42 /tmp/homework.dump.sql
-rw-rw-r-- 1 ut ut 2.1K Jan 16 18:42 /tmp/homework.dump.sql.gzip

```

### Restore from backup
Drop database:
```
mysql> drop database homework;
Query OK, 4 rows affected (0.07 sec)

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
4 rows in set (0.01 sec)
```

After that we have to create the database again and assign privileges as we did it at the beginning.

And now we just restore the database from a previously created dump in a way that depends on the kind of dump.

