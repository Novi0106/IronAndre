-- In the actor table, which are the actors whose last names are not repeated? 

select last_name as does_not_repeat
from actor
group by last_name
having count(last_name) = 1;

-- Which last names appear more than once? 

select last_name as repeats, count(last_name) as appereances
from actor
group by last_name
having count(last_name) > 1;

-- Using the rental table, find out how many rentals were processed by each employee.

select r.staff_id, s.first_name as employee_name, count(r.rental_id) as rentals_processed 
from rental r 
join staff s on s.staff_id = r.staff_id
group by staff_id;

-- Using the film table, find out how many films were released each year

select release_year, count(distinct film_id) as released_films
from film
group by release_year;

-- Using the film table, find out for each rating how many films were there.

select rating, count(distinct film_id)
from film
group by rating;

-- What is the average length of films for each rating? Round off the average lengths to two decimal places.

select rating, round(avg(length),2) min_duration
from film
group by rating;

-- Which kind of movies (based on rating) have an average duration of two hours or more?

select rating, round(avg(length),2) min_duration
from film
group by rating
having min_duration > 120.00;