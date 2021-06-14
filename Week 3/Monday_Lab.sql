-- 1. Review the tables in the database

show tables;

-- 2. Explore tables (example for 2 rather then repeating the query for 23 tables)

select
	*
from
	actor;
	
select
	*
from
	address;
	
-- Alternatively with the query below (only returns column headers)

select
	COLUMN_NAME
from
	INFORMATION_SCHEMA.COLUMNS
Where
	TABLE_NAME in ('actor', 'address');

-- 3. Select film titles column from film
select
	title
from
	film;
	
	
-- 4 Select a list of languages from languages table
select
	distinct name as language
from
	language;

-- 5.1 Find out how many stores does the company have?
select
	count(distinct store_id) as number_stores
from
	store;

-- 5.2 Find out how many employees the company has?
select
	count(distinct staff_id) as employee_number
from
	staff;

-- 5.3 Return a list of employee first names only
select
	first_name
from
	staff;
