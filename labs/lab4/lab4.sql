-- Lab 4. Performance Optimisation

-- EXERCISE 1: Query Rewritting for better Performance

-- Query
explain analyze
select first_name, last_name
from customer
where customer_id in (
	select customer_id
	from rental
	where return_date is not null
);

-- Review execution plan: HASH JOIN
-- No subplan as the query is being rewritten

-- Rewrite the Query Using a Join
explain analyze
select c.first_name, c.last_name
from customer c
join rental r on c.customer_id = r.customer_id
where r.return_date is not null;

-- Review execution plan: HASH JOIN
-- Less time as query is not being rewritten


-- EXERCISE 2: Positive Impact of Indexing

-- Run query
explain analyze
select * from rental where customer_id = 123;

-- Interpret execution plan: SEQUENTIAL SCAN

-- Add an Index on the customer_id column
create index idx_rental_customer_id on rental(customer_id);

-- Re-run the query
-- Interpret execution plan: BITMAP HEAP SCAN
-- It uses a BITMAP INDEX SCAN, indicating the index is being used.

-- Drop existing index
drop index if exists idx_rental_customer_id;

-- EXERCISE 3: More Query Re-writes

-- Run original correlated subquery
explain analyze
select first_name, last_name
from customer c
where (
	select count(*)
	from rental r
	where r.customer_id = c.customer_id
) > 3;

-- Execution plan: there is a Subplan, which indicates the subquery is being
-- executed multiple times.

-- Analyse execution plan: SEQUENTIAL SCAN on both tables

-- Rewrite using a Join
-- Use a join aggregation
explain analyze
select c.first_name, c.last_name
from customer c
join (
	select customer_id, count(*) as rental_count
	from rental
	group by customer_id
	having count(*) > 3
) r on c.customer_id = r.customer_id;

-- Compare Execution Plans
-- HASH JOIN (efficient method for joining large tables)
-- No SubPlan, execution time has improved

-- EXERCISE 4: Optimising a Query with Multiple Conditions

explain analyze
select first_name, last_name
from customer c
where customer_id in (
	select p.customer_id
	from payment p
	where p.amount > 5
)
and customer_id in (
	select r.customer_id
	from rental r
	group by r.customer_id
	having count(*) > 2
);

-- Solution 1
explain analyze
select distinct c.first_name, c.last_name
from customer c
join (
    select customer_id
    from payment
    where amount > 5
) p on c.customer_id = p.customer_id
join (
    select customer_id
    from rental
    group by customer_id
    having count(*) > 2
) r on c.customer_id = r.customer_id;

-- Solution 2
explain analyze
select distinct c.first_name, c.last_name
from customer c
join payment p on c.customer_id = p.customer_id and p.amount > 5
join rental r on c.customer_id = r.customer_id
group by c.customer_id, c.first_name, c.last_name
having count(r.rental_id) > 2;
