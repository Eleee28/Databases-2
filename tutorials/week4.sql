-- Tutorial week 4 (7 oct 2024)
-- Procedural Programming

-- Function

-- EXERCISE 1: Calculate the duration of a rental

select * from rental limit 10;

create or replace function calculate_rental_duration(rental_id int)
returns int as $$
declare
	rental_duration int;
begin
	-- logic is here
	select extract(day from (return_date - rental_date)) into rental_duration
	from rental r
	where r.rental_id = calculate_rental_duration.rental_id;

	return rental_duration;
end;
$$ language plpgsql;

-- usage
select calculate_rental_duration(2);

-- Remove function
drop function calculate_rental_duration(int);

-- EXERCISE 1.2: Verify if a customer exists

create or replace function customer_exists(p_customer_id int)
returns boolean as $$
declare
	exist boolean;
begin
	select count(*) into exist
	from customer c
	where c.customer_id = p_customer_id;

	return exist;
end;
$$ language plpgsql;

-- verify that a customer exists
select customer_exists(13);

-- Remove function
drop function customer_exists(int);

-- Procedure

-- EXERCISE 2: Update Inventory Stock

create or replace procedure adjust_inventory(p_inventory_id int)
language plpgsql as $$
begin
	-- Check if the inventory exixts
	if exists (
		select 1 from inventory i
		where i.inventory_id = p_inventory_id
		) then
		-- Update the last field
		update inventory i
		set last_update = now() -- Simulate the update
		where i.inventory_id = p_inventory_id;
	else
		-- Raise an error
		raise exception 'Inventory ID % does not exist', p_inventory_id;
	end if;
end;
$$;

select * from inventory where inventory_id = 1;

call adjust_inventory(1);

-- Remove procedure
drop procedure adjust_inventory(int);

-- Inspect the Change
select * from inventory where inventory_id = 1;

-- EXERCISE 2.2: Check Rental Status

create or replace procedure check_rental_status(p_rental_id int)
language plpgsql as $$
declare
	return_date date;
begin
	-- Get the return date for the rental
	select r.rental_date into return_date
	from rental r
	where r.rental_id = p_rental_id;

	if return_date is null then
		raise notice 'The movie is still rented out';
	else
		raise notice 'The movie was returned on %', return_date;
	end if;
end;
$$;

call check_rental_status(1);