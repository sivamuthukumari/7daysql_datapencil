
-- TO CREATE THE DATABASE 
create database datapencil_store;


-- USE THE CREATED DATABASE
use datapencil_store ;


---- TABLE CUSTOMERS
create table customers(
    customer_id int primary key not null,
	full_name varchar(100) not null,
	email varchar(50),
	city varchar(20) not null,
	signup_date date not null,
	segment varchar(50)
)


--- TABLE ORDERS
create table orders (
	order_id int primary key not null,
	customer_id int not null ,
	order_date date not null,
	status varchar(30),
	channel varchar(20)
	foreign key(customer_id)
	references customers(customer_id)
	)

---- TABLE PRODUCTS 

create table products(
	product_id int primary key not null,
	product_name varchar(100) not null,
	category varchar(50) not null,
	price decimal(7,2),
	cost decimal(7,2)
)

---TABLE ORDER_ITEM

create table order_item(
		order_item_id int primary key not null,
		order_id int not null,
		product_id int not null,
		quantity int,
		unit_price decimal(7,2)
		foreign key(order_id)
		references orders(order_id),
		foreign key(product_id)
		references products(product_id)
)



---- TABLE PAYMENT

create table payment(
	payment_id int primary key not null,
	order_id int not null,
	payment_method varchar(30) not null,
	payment_status varchar(20) not null,
	amount decimal(10,2)
	foreign key(order_id)
	references orders(order_id),

)


---- CREATE DELIVERIES

create table deliveries(
	delivery_id int primary key not null,
	order_id int not null,
	dispatch_date date not null ,
	delivery_date date,
	delivery_status varchar(20) not null,
	foreign key(order_id)
	references orders(order_id),
)

-- TO CHECK THE LOADED DATA

SELECT * FROM customers;

SELECT * FROM orders;

SELECT * FROM products;

SELECT * FROM order_items;

SELECT * FROM deliveries;

SELECT * FROM payments;


