-- Insert a New Rental and Roll It Back

-- Check how much rentals
select count(*) from rental;

-- Begin the transaction
begin;

-- Insert new rental into the rental table
insert into rental (rental_date, inventory_id, customer_id, return_date, staff_id)
values ('2024-09-250', 101, 3, null, 1);

-- Verify insertion
select * from rental where inventory_id = 101;

-- Check amount of rentals
select count(*) from rental;

-- Rollback the transactions, undoing the insertion
rollback;

-- Verify the rental is no longer present
select count(*) from rental;

-- Insert and Roll Back a Payment for a Rental

-- Begin the transaction
begin;

-- Insert a new payment for a customer
insert into payment (customer_id, staff_id, rental_id, amount, payment_date)
values (3, 1, 1524, 9.99, '2024-09-25');

-- Verify the insertion
select count(*) from payment;

-- Rollback the transaction, undoing the payment insertion
rollback;

-- Verify that the payment is no longer present
select count(*) from payment;

-- Run Two Concurrent Transactions in Default Isolation Level

select * from rental where rental_id = 1000; -- Check the current state of a specific row in the rental table for rental_id = 1000

-- Transaction 1: Start Transaction and Read Data
begin;

select * from rental where rental_id = 1000; -- First read

-- Transaction 2: Update Data and Commit
begin;

update rental set return_date = '2024-10-01 12:00:00' where rental_id = 1000; -- Update return_date

commit; -- Commit transaction

-- Transaction 1: Read Data Again

select * from rental where rental_id = 1000; -- Second read within the same transaction

-- Commit or Rollback on Transaction 1
commit;


-- Simulate a Non-Repeatable Read on the customer table

select * from customer where customer_id = 10; -- Check initial data in the customer table

-- Transaction 1: Read the customer data
begin;

select * from customer where customer_id = 10; -- First read of the customer record

-- Transaction 2: Update the customer data
begin;

update customer set last_name = 'JOHNSON' where customer_id = 10; -- Update customer's last name

commit; -- Commit the change

-- Transaction 1: Read

select * from customer where customer_id = 10; -- Second read of the customer record

--Commit or Rollback in Transaction 1
commit; 