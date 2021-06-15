-- Lab 2.5
-- Select all the actors with the first name ‘Scarlett’.
select
	*
from
	actor
where
	first_name = "Scarlett";

-- How many films (movies) are available for rent and how many films have been rented?

-- Rentable movies (not copies)

select
	count(distinct film_id) as rentable_movies
from
	inventory;
	
-- Total rentals

select
	count(distinct rental_id) as total_rentals
from
	rental;
	
-- What are the shortest and longest movie duration?
select
	min(length) as min_duration,
	max(length) as max_duration
from
	film;
	
-- What's the average movie duration expressed in format (hours, minutes)?
SELECT
	floor(avg((length/60))) as duration_hours,
	floor(avg(length % 60)) as duration_minutes
from
	film;

-- How many distinct (different) actors' last names are there?
select
	count(distinct last_name)
from
	actor;	


-- Since how many days has the company been operating (check DATEDIFF() function)?
-- Taking as the assumption that they still operate today. Taking the first customer registration as the start of operations.
select
	DATEDIFF(CURDATE(), min(create_date)) AS days_operating
from
	customer;
	
-- Show rental info with additional columns month and weekday. Get 20 results.
select
	*,
	date_format(rental_date, '%M') as month,
	date_format(rental_date, '%W') as weekday
from
	rental
limit 20;

-- Add an additional column day_type with values 'weekend' and 'workday' depending on the rental day of the week.
with w as(
select
	rental_id,
	date_format(rental_date, '%M') as month,
	date_format(rental_date, '%W') as weekday
from
	rental)
	
select
	rental_id,
	weekday,
	Case
		when weekday = 'Saturday' or weekday = 'Sunday' then 'Weekend'
		else 'Weekday'
		end as 'day_type'
from
	w;
	
-- How many rentals were in the last month of activity?
select
	count(distinct rental_id) as rentals,
	date_format(rental_date, '%M') as month,
	date_format(rental_date, '%Y') as year
from
	rental
group by
	year, month
order by
	year desc;
	
-- Lab 2.6

-- Get release years

select
	release_year
from
	film;
	
-- Get films with ARMAGEDDON in title
	
select
	*
from
	film
where
	title like "%ARMAGEDDON%";
	
-- Get all films which title ends with APOLLO.

select
	*
from
	film
where
	title like "%APOLLO";
	
-- Get 10 the longest films.

select
	*
from
	film
order by
	length desc
limit 10;

-- How many films include Behind the Scenes content?
select
	count(film_id) as behind_the_scenes
from
	film
where
	special_features like '%Behind the Scenes%';
	
-- Drop column picture from staff.
alter table staff
drop column picture;

-- A new person is hired to help Jon. Her name is TAMMY SANDERS, and she is a customer. Update the database accordingly.
select * from customer where first_name = 'Tammy'; #check entry for tammy

select * from staff; #check table structure fro staff

insert into staff (staff_id, first_name, last_name, address_id, email, store_id, active, username, password, last_update) #add values to staff table
values (3, 'TAMMY', 'SANDERS',79,'TAMMY.SANDERS@sakilastaff.org', 2, 1, 'TAMMY', 'password',CURDATE());

select * from staff; #check for result

-- Add rental for movie "Academy Dinosaur" by Charlotte Hunter from Mike Hillyer at Store 1.
select * from rental order by rental_id desc; # find out last rental id

select customer_id from customer
where first_name = 'CHARLOTTE' and last_name = 'HUNTER'; # check out correct customer id

select * from film where title like '%Academy Dinosaur%'; #check out available inventory ids for store 1
select * from inventory
where film_id = 1 and store_id = 1;

select * from rental where inventory_id in (1, 2, 3, 4); #check if any copy is still on rentable

select * from staff where store_id = 1; #check relevant staff_id

insert into rental (rental_id, rental_date, inventory_id, customer_id, return_date, staff_id, last_update) #add values to rental table
values (16050, now(), 1, 130, null, 1, now()); #add values to rental table

select * from rental where rental_id = 16050; #check results

-- Delete non-active users, but first, create a backup table
select distinct active from customer; #check for distinct active values

select * from customer where active = 0; #look for non-active users

create table if not exists back_up( # create new table
	customer_id smallint,
	email varchar(50),
	date datetime);
	
insert into back_up (customer_id, email, date) #populate back-up table
select customer_id, email, create_date
from customer
where active = 0;

select * from back_up; #check new table

delete from customer where active = 0; #this returns a foreign key constraint with dependency. I would need to delete payment records to make this work, which seems like a rather bad idea. ;)

