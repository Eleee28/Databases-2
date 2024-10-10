drop table if exists customer_rentals_unnormalized;

create table customer_rentals_unnormalized(
	customer_id int,
	customer_name varchar(50),
	address varchar(100),
	film_1 varchar(50),
	film_2 varchar(50),
	film_3 varchar(50),
	rental_date date
);

-- Insert some sample data

insert into customer_rentals_unnormalized(customer_id,
	customer_name, address, film_1, film_2, film_3, 
	rental_date)
values
(1, 'John Doe', '123 Elm St', 'The Matrix', 'Inception', 
'NULL', '2024-01-10'),
(2, 'Jane Smith', '456 Oak St', 'Interstellar', 'NULL',
'NULL', '2024-01-12'),

(3, 'Bob Johnson', '789 Pine St', 'The Matrix',
'The Dark Knight', 'NULL', '2024-01-15'),

(4, 'John Doe', '123 Elm St', 'Shrek', 'NULL', 'NULL',
'2024-01-15');

-- Update query (demonstrate update anomaly)
update customer_rentals_unnormalized
set address='124 Elm St'
where customer_name='John Doe' and rental_date='2024-01-15';

-- Insert query (demonstrate insert anomaly)
insert into customer_rentals_unnormalized (customer_id, customer_name,
address, rental_date)
values (5, 'Jason Smith', '125 Elm St', '2024-01-16');

delete from customer_rentals_unnormalized
where customer_id=3;

-- Show data
select * from customer_rentals_unnormalized;