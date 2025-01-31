# Lab 5. Performance and Indexing

## Objective
1. Optimise SQL queries by starting with a correlated subquery.
2. Rewriting it to use a join. 
3. Explore the impacts of indexing, and analyze PostgreSQL’s decision-making between sequential scans and index scans. 

## Task 1: Start with an Unoptimised Query

1. Write an SQL query to retrieve:

    a. customer_id, first_name, last_name, and total amount spent from the payment and customer tables.

    b. Only include customers who have spent more than $100 in total.

    c. Use a correlated subquery to find the total amount for each customer.

    d. Upload a screenshot of your query plan to question 1 in the brightspace quiz item, and insert your query, and an explanation of the query plan into the text box provided.

## Task 2: Rewrite the Query Using a Join

1. Rewrite your query from Task 1 to use a join instead of a correlated subquery. Ensure it retrieves the same information but eliminates the need for a SubPlan.

    a. Upload a screenshot of your query plan to question 2 in the brightspace quiz item, and insert your query and an explanation of the query plan into the text box provided.

Task 3: Optimise Further with Indexing (4 Points)

1. Create an Index on payment.customer_id: The query can still be slow if there are a lot of payment records. Adding an index on customer_id in the payment table can help PostgreSQL quickly locate the relevant rows.

    a. Was the index used?

    b. If the index was not used, force the index by

        SET enable_seqscan = OFF;

    and re-run your query.

    c. Does the index improve things?

    d. Upload your query plan that uses an index to question 3 in the brightspace quiz area. Explain in the text box provided if the index has or has not improved your query and explain why. 
