DROP DATABASE if EXISTS homework;
CREATE DATABASE homework;
use homework;
DROP TABLE if EXISTS products;
create table products (
    id INT(8) not null auto_increment,
    code varchar(12) not null,
    title varchar(48) not null,
    description varchar(1024) not null,
    price decimal(6,2) not null,
    quantity int(5) not null,
    primary key (id, code)
);

DROP TABLE if EXISTS categories;
create table categoires (
    id int(8) not null auto_increment,
    title varchar(48) not null,
    description varchar(1024) not null,
    primary key (id)
);

DROP TABLE if EXISTS customers;

CREATE TABLE customers (
    id INT(8) NOT NULL auto_increment,
    name VARCHAR(48),
    email VARCHAR(48),
    phone VARCHAR(12),
    address VARCHAR(50),
    PRIMARY KEY (id)
);

DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
  id int(11) NOT NULL,
  productCode varchar(15) NOT NULL,
  quantity int(11) NOT NULL,
  price decimal(10,2) NOT NULL,
  PRIMARY KEY (id)
);