DROP DATABASE if EXISTS homework;
CREATE DATABASE homework;
use homework;
DROP TABLE if EXISTS products;
create table products (
    id INT(8) not null auto_increment,
    code varchar(12) not null,
    category_id INT(8) not null,
    title varchar(128) not null,
    description varchar(1024) not null,
    price decimal(6,2) not null,
    quantity int(5) not null,
    primary key (id, code)
);

insert  into products (code, category_id, title, description, price, quantity) values 
(1001,1,'Learn Python: The Complete Python Programming Course','Learn A-Z everything about Python, from the basics, to advanced topics like Python GUI, Python Data Analysis, and more!',19.99,100),
(1002,1,'The Complete 2022 Web Development Bootcamp','Become a Full-Stack Web Developer with just ONE course. HTML, CSS, Javascript, Node, React, MongoDB, Web3 and DApps',19.99,100),
(1003,2,'The English Master Course','The Complete English Language Course: English grammar, English speaking, and writing. British and American English.',9.99,50),
(1004,2,'Spanish for Beginners','Learn Spanish with the complete, non-stop SPEAKING method, in a matter of weeks, not years.',9.99,50),
(1005,3,'15 Minutes x 15 Days Yoga','Improve your flexibility, reduce morning stiffness and alleviate recurring aches and pains in 15 minutes a day.',29.99,10),
(1006,4,'Breath is Life: Pranayama, meditation course - Yoga Alliance','Pranayama / Meditation / Bandhas course that will change your life. (With 16 hours of Yoga Alliance Continuing Points)',29.99,10);


DROP TABLE if EXISTS categories;
create table categories (
    id int(8) not null auto_increment,
    category_id INT(8) not null,
    title varchar(48) not null,
    description varchar(1024) not null,
    primary key (id)
);

insert into categories (category_id, title, description) values 
(1,'Software courses','Courses for people who want to become developers'),
(2,'Language courses','Different foreign language courses'),
(3,'Yoga courses','Big collection of the yoga video courses');

DROP TABLE if EXISTS customers;

CREATE TABLE customers (
    id INT(8) NOT NULL auto_increment,
    name VARCHAR(48),
    email VARCHAR(48),
    phone VARCHAR(16),
    address VARCHAR(250),
    PRIMARY KEY (id)
);

insert into customers (name, email, phone, address) values 
('Hope Macejkovic','lynch.ramon@gmail.com','(302) 871-9295','33844 Maymie Dam Apt. 098, Vonborough, West Virginia'),
('Vernice Wisoky','schaden.murl@langworth.com','906-717-2201','45608 Craig Junction Suite 776, New Triston'),
('Rick Greenholt','elroy96@bahringer.net','906-650-9426','8895 Jamarcus River Apt. 543'),
('Daija Ortiz','ardith54@yahoo.com','965.340.6943','74815 Effertz Springs Apt. 275'),
('Eriberto Wunsch','hfriesen@waters.org','1-617-229-5927','78129 Lesch Spur Apt. 990');

DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
  id int(11) NOT NULL auto_increment,
  customerId int(8) NOT NULL,
  productCode varchar(15) NOT NULL,
  quantity int(11) NOT NULL,
  PRIMARY KEY (id)
);

insert into orders (customerId, productCode, quantity) values 
(1, 1001, 1),
(1, 1002, 1),
(2, 1004, 1),
(2, 1005, 1),
(3, 1006, 1),
(4, 1003, 1),
(4, 1004, 1),
(4, 1007, 1),
(5, 1002, 1),
(5, 1006, 1);
