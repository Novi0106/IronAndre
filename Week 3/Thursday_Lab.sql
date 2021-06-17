-- Use the RANK() and the table of your choice rank films by length (filter out the rows that have nulls or 0s in length column). In your output, only select the columns title, length, and the rank.

select title, length, rank() over (partition by title order by length desc) as length_ranking
from film f
where length <> 0;


-- Build on top of the previous query and rank films by length within the rating category (filter out the rows that have nulls or 0s in length column). In your output, only select the columns title, length, rating and the rank.

select title, rating, length, rank() over (partition by rating order by length desc) as length_ranking
from film f
where length <> 0;

-- How many films are there for each of the categories? Inspect the database structure and use appropriate join to write this query.

select c.name as category, count(distinct f.film_id) as amount_of_films
from film f
join film_category fc on fc.film_id = f.film_id
join category c on c.category_id = fc.category_id
group by c.name;

-- Which actor has appeared in the most films?

select concat(a.first_name," ",a.last_name) as actor, count(distinct f.film_id) as appereances
from actor a
join film_actor fa on fa.actor_id = a.actor_id
join film f on f.film_id = fa.film_id
group by actor
order by appereances desc
limit 1;

-- Most active customer (the customer that has rented the most number of films)

select concat(c.first_name," ",c.last_name) as customer, count(distinct i.film_id) as films_rented
from customer c
join rental r on r.customer_id = c.customer_id
join inventory i on i.inventory_id = r.inventory_id
group by customer
order by films_rented desc
limit 1;

-- Which is the most rented film? 

select f.title, count(distinct r.rental_id) as total_rentals
from customer c
join rental r on r.customer_id = c.customer_id
join inventory i on i.inventory_id = r.inventory_id
join film f on f.film_id = i.film_id
group by title
order by total_rentals desc
limit 1;