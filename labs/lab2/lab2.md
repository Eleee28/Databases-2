# Lab 2. SQL Practice

## Objective
This lab will focus on querying the dvdrentals database, helping you to solidify your understanding of SQL. The exercises are designed to enhance familiarity with database structure, querying and basic logic-building tasks.

## Lab tasks

### Task 1: Exploring the Database Structure

1. List all the tables in the dvdrentals database:
    a. Query the PostgreSQL catalogue to find out what tables are available in the database.
    b. Examine the columns of the film table: Retrieve the structure of the film table, including column names, data types, and any constraints.

### Task 2: Writing Basic Queries

1. Write a query that returns the top 10 films based on the longest rental duration.
2. Use a query to find out how many films each customer has rented. Sort the result by the number of rentals in descending order.
3. Write a query to find out which customers have never made a payment.

### Task 3: Using Conditional Logic

1. Write a query that classifies films into different rental price categories.
2. Write a query that checks whether a customer is active based on whether they have made any payments in the last 30 days. Return only customers who have made at least one payment in that time.

### Task 4: Aggregation and Grouping

1. Write a query that counts how many films have been rented per category and lists the categories in descending order of popularity.
2. Write a query that calculates the average rental duration for each customer, rounded to the nearest day.