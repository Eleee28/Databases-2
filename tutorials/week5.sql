-- Tutorial Week 5: Performance Optimisation

explain analyze
select * from rental;

-- Sequential Scan
explain analyze
select first_name, last_name from customer c
where customer_id in (
	select customer_id from rental r
	where r.rental_date > c.create_date
);

-- Database runs a join (Hash Join)
explain analyze
select first_name, last_name from customer c
where customer_id in (
	select customer_id from rental r
);

-- Join (Hash Aggregate), less time
explain analyse
select distinct first_name, last_name
from customer c join rental r
on c.customer_id = r.customer_id
where r.rental_date > c.create_date;

-- EXERCISE: Improve this query
-- No subplan (simple query, it is re-written): tipically having a subquery involves having a subplan (one plan per query).
explain analyze
select first_name, last_name
from customer
where customer_id in (
	select customer_id
	from payment
	where amount > 5
);

-- Optimised query
explain analyze
select distinct first_name, last_name
from customer c join payment p 
on c.customer_id = p.customer_id
where p.amount > 5;

-- The results of both queries are the same but in different order as the data in the database is not order.
-- Retrieved data is not in order unless especified.