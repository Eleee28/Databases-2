-- Procedural Lab

-- Task 1: Calculate total number of rentals for specific customer

create or replace function get_rental_count_by_customer(p_customer_id int)
returns int as $$
declare
	rental_count int;
begin
	select count(*) into rental_count
	from rental r
	where r.customer_id = p_customer_id;

	return rental_count;
end;
$$ language plpgsql;

select get_rental_count_by_customer(13);

-- Remove function
drop function get_rental_count_by_customer(int);

-- Task 2: Stored procedure that updates the customer email based on their id

create or replace procedure update_customer_email(p_customer_id int, p_email varchar(50))
language plpgsql as $$
begin
	-- Check the customer exists
	if exists (
			select 1 from customer c
			where c.customer_id = p_customer_id
	) then
		update customer c
		set email = p_email
		where c.customer_id = p_customer_id;
	else
		-- Raise an error
		raise exception 'Customer ID % does not exist', p_customer_id;
	end if;
end;
$$;

select * from customer where customer_id = 1;

call update_customer_email(1, 'mary.smith@newemail.com');

select * from customer where customer_id = 1;
select * from customer;%                                                        🪿  DB  
