-- Task 1
explain analyze
select c.customer_id, c.first_name, c.last_name, 
(
	select sum(p.amount) as total_amount
	from payment p
	where p.customer_id = c.customer_id
) as total_amount
from customer c
where (
	select sum(p.amount) as total_amount
	from payment p
	where p.customer_id = c.customer_id
) > 100;

-- Task 2
explain analyze
select c.customer_id, c.first_name, c.last_name, sum(p.amount) as total_amount
from customer c
join payment p on c.customer_id = p.customer_id
group by (c.customer_id, c.first_name, c.last_name)
having sum(p.amount) > 100;

-- Task 3
create index idx_customer_id on payment(customer_id);
drop index if exists idx_customer_id;

set enable_seqscan = off;
set enable_seqscan = on;