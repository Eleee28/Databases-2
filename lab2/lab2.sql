-- TASK 1: Exploring the Database Structure

-- 1a: List the tables in the database
select table_name
from information_schema.tables
where table_schema = 'public' and table_type = 'BASE TABLE';

-- 1b: Retrieve the structure of the film table on the terminal: \d film

-- Retrieve columns, data types, and nullability
select column_name, data_type, is_nullable
from information_schema.columns
where table_name = 'film';

-- TASK 2: Writing Basic Queries

-- 1: Retrieve the top 10 films based on rental duration
select film_id, title, rental_duration
from film
order by rental_duration desc
limit 10;

-- 2: Find the total number of rentals per customer
select first_name, last_name, count(rental_id) as num_rentals
from customer
join rental on customer.customer_id = rental.customer_id
group by first_name, last_name
order by num_rentals desc;

-- 3: Find customers who have never made a payment 
select c.customer_id, c.first_name, c.last_name
from customer c
left join payment p on c.customer_id = p.customer_id
where p.payment_id is null;

-- TASK 3: Using Conditional Logic

-- 1: Classify films based on rental rate
select title, rental_rate, 
case 
	when rental_rate < 2 then 'Low'
	when rental_rate between 2 and 4 then 'Medium'
	else 'High'
end as price_category
from film;

-- 2: Find active customers based on payment history
select c.customer_id, c.first_name, c.last_name
from customer c
join payment p on c.customer_id = p.customer_id
where now() - p.payment_date <= interval '30 days';

-- TASK 4: Aggregation and Grouping

-- 1: Find most popular film category
select c.name, count(r.rental_id) as num_rentals
from category c
join film_category fc on c.category_id = fc.category_id
join inventory i on fc.film_id = i.film_id
join rental r on i.inventory_id = r.inventory_id
group by c.name
order by num_rentals desc;

-- 2: Find the average rental duration for each customer

select c.customer_id, c.first_name, c.last_name, 
	round(avg(date_part('day', r.return_date - r.rental_date)))
	as avg_rental_duration
from customer c
join rental r on c.customer_id = r.customer_id
where r.return_date is not null
group by c.customer_id, c.first_name, c.last_name
order by avg_rental_duration desc;

-- Update rental rate of action films
UPDATE film
SET rental_rate = rental_rate * 1.10
WHERE film_id IN (
	SELECT film_id
	FROM film_category
	JOIN category ON film_category.category_id = category.category_id
	WHERE category.name = 'Action'
	AND rental_rate < 3
);