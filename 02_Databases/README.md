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

### Connect to DB

mysql -u root -p [databasename]

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