-- Using the tables address and staff and the JOIN command, display the first names, last names, and address of each staff member.

select s.first_name, s.last_name, a.address
from staff s
join address a on a.address_id = s.address_id;


-- Using the tables staff and payment and the JOIN command, display the total payment amount by staff member in August of 2005.

select concat(s.first_name," ",s.last_name) as full_name, sum(p.amount) as total_payments
from staff s
join payment p on p.staff_id = s.staff_id
where payment_date between '2005-08-01' and '2005-08-30'
group by full_name;


-- Using the tables film and film_actor and the JOIN command, list each film and the number of actors who are listed for that film.

select f.title as film_title, count(fa.actor_id) as actors
from film f
join film_actor fa on fa.film_id = f.film_id
group by film_title;


-- Using the tables payment and customer and the JOIN command, list the total paid by each customer. Order the customers by last name and alphabetically.

select c.last_name, c.first_name, sum(p.amount) as total_amount_paid
from customer c
join payment p on p.customer_id = c.customer_id
group by c.last_name, c.first_name
order by c.last_name;

