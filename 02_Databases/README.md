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

Truncate table customers:
```
mysql> truncate table customers;
Query OK, 0 rows affected (0.03 sec)

mysql> select * from customers;
Empty set (0.00 sec)
```

Now we just restore the database from a previously created dump in a way that depends on the kind of dump.

```
mysql -u root -p --protocol=tcp homework < /tmp/homework.dump.sql
zcat /tmp/homework.dump.sql.gzip | mysql -u root -p --protocol=tcp homework
gunzip < /tmp/homework.dump_20230116-184640_sql.gzip | mysql -u root -p --protocol=tcp homework
```

Everything is working very well:
```
mysql> select * from customers;
+----+-----------------+----------------------------+----------------+------------------------------------------------------+
| id | name            | email                      | phone          | address                                              |
+----+-----------------+----------------------------+----------------+------------------------------------------------------+
|  1 | Hope Macejkovic | lynch.ramon@gmail.com      | (302) 871-9295 | 33844 Maymie Dam Apt. 098, Vonborough, West Virginia |
|  2 | Vernice Wisoky  | schaden.murl@langworth.com | 906-717-2201   | 45608 Craig Junction Suite 776, New Triston          |
|  3 | Rick Greenholt  | elroy96@bahringer.net      | 906-650-9426   | 8895 Jamarcus River Apt. 543                         |
|  4 | Daija Ortiz     | ardith54@yahoo.com         | 965.340.6943   | 74815 Effertz Springs Apt. 275                       |
|  5 | Eriberto Wunsch | hfriesen@waters.org        | 1-617-229-5927 | 78129 Lesch Spur Apt. 990                            |
+----+-----------------+----------------------------+----------------+------------------------------------------------------+
5 rows in set (0.00 sec)
```

### Working with AWS RDS

Try to connect to crated AWS RDS instance and create database:

```
mysql -u admin -p -h homework.co4qzsstu6hv.eu-central-1.rds.amazonaws.com

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
4 rows in set (0.04 sec)

mysql> create database homework;
Query OK, 1 row affected (0.04 sec)

mysql> grant all privileges on homework.* to 'admin'@'%';
Query OK, 0 rows affected (0.04 sec)

```

I transferred local database to RDS (through sql dump):
```
mysql -u admin -p -h homework.co4qzsstu6hv.eu-central-1.rds.amazonaws.com homework < /tmp/homework.dump.sql

mysql> use homework;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed


mysql> select name, email from customers;
+-----------------+----------------------------+
| name            | email                      |
+-----------------+----------------------------+
| Hope Macejkovic | lynch.ramon@gmail.com      |
| Vernice Wisoky  | schaden.murl@langworth.com |
| Rick Greenholt  | elroy96@bahringer.net      |
| Daija Ortiz     | ardith54@yahoo.com         |
| Eriberto Wunsch | hfriesen@waters.org        |
+-----------------+----------------------------+
5 rows in set (0.07 sec)
```

And now we have to create dump of the RDS database:
```
mysqldump -u admin -p -h homework.co4qzsstu6hv.eu-central-1.rds.amazonaws.com homework > /tmp/rds-homework.dump.sql

ll /tmp/rds-homework.dump.sql 
-rw-rw-r-- 1 ut ut 6.4K Jan 16 20:26 /tmp/rds-homework.dump.sql

```

Everytyng is working fine.

## Part 3. MongoDB

Run mongodb in docker container and connect to it

```
docker run --name mymongo -d mongo:latest
docker exec -it mymongo bash
mongosh

test> db
test
test> show databases
admin    40.00 KiB
config  108.00 KiB
local    40.00 KiB
test> use mydb
switched to db mydb
mydb> 
```

Start to work with mongodb:

```
mydb> db.testCollection.insertOne({"name": "dove", "age" : 26, "email": "test@gmail.com"})
{
  acknowledged: true,
  insertedId: ObjectId("63c65f1d111d23de0b60288e")
}
mydb> db.testCollection.find()
[
  {
    _id: ObjectId("63c65f1d111d23de0b60288e"),
    name: 'dove',
    age: 26,
    email: 'test@gmail.com'
  }
]
mydb> db.testCollection.deleteOne({});
{ acknowledged: true, deletedCount: 1 }
mydb> db.testCollection.find()

mydb> 
```

Let's add more data:

```
mydb> db.customers.insertOne({ 'name': 'Hope Macejkovic',
'email': 'lynch.ramon@gmail.com',
'phone': '(302) 871-9295',
'address': '33844 Maymie Dam Apt. 098, Vonborough, West Virginia'
})

{
  acknowledged: true,
  insertedId: ObjectId("63c660b8111d23de0b60288f")
}


mydb> db.customers.find()
[
  {
    _id: ObjectId("63c660b8111d23de0b60288f"),
    name: 'Hope Macejkovic',
    email: 'lynch.ramon@gmail.com',
    phone: '(302) 871-9295',
    address: '33844 Maymie Dam Apt. 098, Vonborough, West Virginia'
  }
]

db.customers.insertMany(
[{
"name": "Vernice Wisoky",
"email": "schaden.murl@langworth.com",
"phone": "906-717-2201",
"address": "45608 Craig Junction Suite 776, New Triston"
},
{
"name": "Rick Greenholt",
"email": "elroy96@bahringer.net",
"phone": "906-650-9426",
"address": "8895 Jamarcus River Apt. 543"
},
{
"name": "Daija Ortiz",
"email": "ardith54@yahoo.com",
"phone": "965.340.6943",
"address": "74815 Effertz Springs Apt. 275"
}])

{
  acknowledged: true,
  insertedIds: {
    '0': ObjectId("63c66274111d23de0b602890"),
    '1': ObjectId("63c66274111d23de0b602891"),
    '2': ObjectId("63c66274111d23de0b602892")
  }
}
```

Work with collection

```
mydb> db.customers.find({"name": "Rick Greenholt"})
[
  {
    _id: ObjectId("63c66274111d23de0b602891"),
    name: 'Rick Greenholt',
    email: 'elroy96@bahringer.net',
    phone: '906-650-9426',
    address: '8895 Jamarcus River Apt. 543'
  }
]

mydb> db.customers.find({"email": /gmail/})
[
  {
    _id: ObjectId("63c660b8111d23de0b60288f"),
    name: 'Hope Macejkovic',
    email: 'lynch.ramon@gmail.com',
    phone: '(302) 871-9295',
    address: '33844 Maymie Dam Apt. 098, Vonborough, West Virginia'
  }
]


mydb> db.customers.updateOne({name: "Hope Macejkovic"}, {$set: {email: "Hope.Macejkovic@gmail.com"}})
{
  acknowledged: true,
  insertedId: null,
  matchedCount: 1,
  modifiedCount: 1,
  upsertedCount: 0
}

mydb> db.customers.find({"email": /gmail/})
[
  {
    _id: ObjectId("63c660b8111d23de0b60288f"),
    name: 'Hope Macejkovic',
    email: 'Hope.Macejkovic@gmail.com',
    phone: '(302) 871-9295',
    address: '33844 Maymie Dam Apt. 098, Vonborough, West Virginia'
  }
]
```

Just check what we have done:

```
mydb> show databases
admin    40.00 KiB
config  108.00 KiB
local    40.00 KiB
mydb     96.00 KiB
mydb> show collections
customers
testCollection

```
