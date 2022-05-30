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


insert into customer_dimension(CUSTOMER_ID, Age, Gender,location)
select cus.customer_id ,
age(current_date, cus.date_of_birth),
cus.gender,
cus.postcode 
from public.customer cus;


create table product_dimension
(
    product_id integer UNIQUE NOT NULL,
    product_name varchar(60),
    brand varchar(60),
    Supplier_Name varchar(60),
    Loyalty_status decimal,
    primary key(product_id) 
);

insert into product_dimension(product_id , product_name , Brand,supplier_name,loyalty_status)
select prod.product_id ,
prod.name,
prod.brand,
prod.supplier,
case when prod.loyalty_value >0 then 1 else 0 end
from public.product prod;


create table staff_dimension
(
    staff_id  integer UNIQUE NOT NULL,
    staff_name varchar(60),
    primary key(staff_id)
);


insert into staff_dimension(staff_id , staff_name)
select stf.user_id,
stf.username
from public.staff stf;


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


insert into outlet_dimension(outlet_id , outlet_name, vendor_name 
,outlet_city,outlet_country,outlet_location)
select outl.outlet_id ,
outl.Name,
outl.vendor_name,
outl.city,
outl.country,
outl.postcode 
from public.outlet outl;



create table time_dimension
(
    sales_date date,
    sales_hour integer,
    sales_day integer
);

insert into time_dimension(sales_date , sales_hour, sales_day)
select sh.sale_date,
date_part('hour', sh.sale_date),
date_part('day', sh.sale_date) 
from public.sale_head sh;


create table payment_dimension
(
    sales_id varchar(60) UNIQUE NOT NULL,
    payment_type varchar(60),
    primary key(sales_id)
);

insert into payment_dimension(sales_ID,Payment_type)
select slhd.sale_id,
slhd.payment_type 
from public.sale_head slhd;


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

insert into sales_fact(sales_id, outlet_id,staff_id,customer_id,product_id,
sales_date,no_of_units_sold, profit,unit_cost, unit_sale_price, total_revenue_sales,
discount 
)
select coalesce(shead.sale_id,Null), 
coalesce(o.outlet_id, Null), 
sh.user_id,
c.customer_id,
prd.product_id,
shead.sale_date,
sline.quantity,
(sline.price-prd.unit_cost)*sline.quantity as profit,
prd.unit_cost,
sline.price,
sline.price*sline.quantity*(1-sline.discount) as total_revenue_sales,
sline.discount
from public.product prd
left join sale_line as sline 
on 
prd.product_id  = sline.product_id 
left join public.sale_head shead 
on 
shead.sale_id = sline.sale_id 
left join public.customer c 
on 
c.customer_id = shead.customer_id 
left join public.staff sh 
on 
sh.user_id = shead.user_id 
left join public.outlet o
on 
o.outlet_id = shead.outlet_id ;

/* Question 4.1.1 */
/* How many units of products has the vendor sold over time across their various outlets*/

select sum(sf.no_of_units_sold) as no_of_units_sold , od.vendor_name, sf.sales_date, od.outlet_id 
from sales_fact sf 
inner join outlet_dimension od 
on od.outlet_id = sf.outlet_id 
group by od.vendor_name, sf.sales_date, od.outlet_id 
limit 100;


/*Question 4.1.3*/
/*How does the total revenue of sales vary across customers’ gender, age, and location?*/
select sum(sf.total_revenue_sales) as total_revenue_sales, cd.gender, cd.age, cd."location" 
from sales_fact sf
left join customer_dimension cd 
on cd.customer_id = sf.customer_id 
group by cd.gender , cd.age , cd."location" 
order by total_revenue_sales desc;






