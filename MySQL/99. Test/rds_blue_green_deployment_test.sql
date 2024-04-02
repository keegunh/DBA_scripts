-- Testing replication between Blue DB instances and Green DB instances in a Blue/Green Deployment of AWS RDS.
-- Modifications 


-- BLUE
use employees;
show indexes from employees;
create index employees_ix01 on employees(first_name, last_name);
-- drop index employees_ix01 on employees(first_name, last_name);


-- GREEN 
-- Must set read_only=0 using parameter group
-- Check index created from BLUE - should be created
use employees;
show indexes from employees;

-- Add column
desc employees;
alter table employees add address varchar(200) not null;
-- alter table employees drop address;

-- Create new table
create table address_history (
	emp_no int not null,
	address varchar(200) not null,
	from_date date not null,
	to_date date not null,
	primary key (emp_no, from_date)
);
desc address_history;
-- drop table address_history;



-- BLUE
use employees;
-- Check table and column added from BLUE - shouldn't be created.
desc employees;
desc address_history;