drop table if exists customer_dimension cascade;
drop table if exists product_dimension cascade;
drop table if exists staff_dimension cascade;
drop table if exists outlet_dimension cascade;
drop table if exists time_dimension cascade;
drop table if exists payment_dimension cascade;
drop table if exists sales_fact cascade;


create table customer_dimension
(
    customer_ID integer UNIQUE NOT NULL,
    Age interval,
    Gender varchar(60),
    location varchar(60),
    primary key(customer_ID)
);


create table product_dimension
(
    product_id integer UNIQUE NOT NULL,
    product_name varchar(60),
    brand varchar(60),
    Supplier_Name varchar(60),
    Loyalty_status decimal,
    primary key(product_id) 
);

create table staff_dimension
(
    staff_id  integer UNIQUE NOT NULL,
    staff_name varchar(60),
    primary key(staff_id)
);


create table outlet_dimension
(
    outlet_id  integer UNIQUE NOT NULL,
    vendor_name varchar(60),
    outlet_name varchar(60),
    outlet_city varchar(60),
    outlet_country varchar(60),
    outlet_location varchar(60),
    primary key(outlet_id)
);


create table time_dimension
(
    sales_date date,
    sales_hour integer,
    sales_day integer
);

create table payment_dimension
(
    sales_id varchar(60) UNIQUE NOT NULL,
    payment_type varchar(60),
    primary key(sales_id)
);


/* Fact table */
create table sales_fact 
(
    sales_id  integer,
    outlet_id integer,
    staff_id integer,
    customer_id integer,
    product_id integer,
	sales_date date,
    no_of_units_sold integer,
    profit decimal (7,2),
    unit_cost decimal (7,2),
	unit_sale_price decimal (7,2),
	total_revenue_sales decimal (7,2),
   	discount decimal (7,2)
);

/* 
drop table if exists customer_dimension cascade;
drop table if exists product_dimension cascade;
drop table if exists staff_dimension cascade;
drop table if exists outlet_dimension cascade;
drop table if exists time_dimension cascade;
drop table if exists payment_dimension cascade;
drop table if exists sales_fact cascade;
*/