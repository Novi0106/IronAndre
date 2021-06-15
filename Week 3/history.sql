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