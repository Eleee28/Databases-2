# Lab 4. Performance Optimisation in PostgreSQL

## Objective
1. Understand how rewritting queries can improve performance.
2. Learn how indexes can affect query performance, both positively and negatively.
3. Gain experience in reading and interpreting PostgreSQL query execution plans.

## Exercise 1: Query Rewiting for Better Performance

**Goal: Demonstrate how rewriting a query can improve its performance**
Optimize a query by rewriting it from a subquery to a join and comapare the performance of the two versions.

**Step 1: Run the Subquery Version**
Execute a query that retrieves all the customers who have rented films by using a subquery.

- Review the Execution Plan

**Step 2: Rewrite the Query Using a Join**
Rewrite the query using a join instead of a subquery.

- Review the Execution Plan

**Step 3: Compare Performance**
- Compare the execution times (the actual time in milliseconds) and the number of rows processed between the subquery and join versions.
- **Key Learning**: The rewritten query should execute faster, as PostgreSQL only scans the rental table once instead of performing a subquery for each customer.

## Exercise 2: Positive Impact of Indexing

**Step 1: Run the Query Without Index**
Execute a query that retrieves all rentals for a specific customer (customer ID 123) from the rental table.

- Interpret the Execution Plan: Look for a **Sequential Scan** (Seq Scan) in the execution plan, meaning the query is scanning the entire rental table without using an index.

**Step 2: Add an Index on the customer_id Column**
1. Create an index on the customer_id column to improve the query performance.
2. Re-run the query with the Index (execute the previous query again).

- Interpret the new Execution Plan: You should now see an **Index Scan** instead of a **Sequential Scan**, indicating the index is being used.

## Exercise 3: More Query Re-writes

**Step 1: Run the Original Correlated Subquery**
Run a query that finds customers who have rented more than 3 movies.

- **Explanation**: it is a **correlated subquery** because for each row in the customer table, PostgreSQL must run the subquery to count the number of rentals for that particular customer. This can be ineffiecient since the subquery must be executed repeatedly for each customer.

- **Expected Output**: Look for a SubPlan in the execution plan, which indicates that the subquery is being executed multiple times.

**Step 2: Analyse the Execution Plan**
- Check for the **SubPlan** in the output
- Observe the execution time, number of rows processed, and whether PostgreSQL is performing a sequential scan on both tables.

**Step 3: Rewrite the Query Using a Join**
Rewrite this query to use a join and aggregation instead of a correlated subquery. By grouping the renatl data, we can pre-aggregate the results and then join the data to the customer table in a single pass.

**Step 4: Compare Execution Plans**
- Run the new query and compare it to the previous version.
- Check the execution time and see if the SubPlan has been eliminated.
- You should see a **Hash Join** or **Merge Join** instead of repeated subquery execution.

**Expected Results:**
The new query using a join should be more efficient, especially for larger datasets, because the subquery is no longer repeatedly executed for each row in the customer table.
**Hash Join** or **Merge Join** is expected to be used, reducing execution time.

## Exercise 4: Optimising a Query with Multiple Conditions

**Goal**: Learn how to optimise a query with multiple filtering conditions that can be rewritten to improve efficiency, especially by leveraging indexes.

- **Explanation**: this query contains two separate subqueries in the WHERE clause:
    - The first subquery checks for customers who have made a payment of more than $5.
    - The second subquery checks for customers who have rented more than 2 movies.
- The issue here is that each subquery is evaluated separately, which can be inefficient.

**Step 2: Analyse the Execution Plan**
- Run the query and observe whether the execution plan includes multiple subplans.
- The query may use sequential scans on both payment and rental tables, and each subquery is evaluated separately, increasing the execution cost.

**Step 3: Rewrite the Query Using Joins**
Rewrite the query using joins and aggregation to avoid multiple sebqueries and improve efficiency.

**Step 4: Compare Execution Plans**
- Run the rewritten query.
- Compare the execution time and the operations used in the execution plan.
- Look for joins (Hash Join or Merge Join) instead of subquery evaluations.

Original query's execution plan:
- **Key Highlights**:
    - **Nested Loop Semi Join** is used between customer and rental.
    - **Hash Join** is used between rental and payment.
    - **Index Scan** on the payment tabel using idx_fk_customer_id.

- **Observations**:
    - This query uses a **Nested Loop Semi Join** and **Hash Join** efficiently.
    - The **Index Scan** on payment helps reduce the rows processed early, focusing only on the customers who have made a payment of more than $5.

**Expected Result:**
- The rewritten query should be more efficient as it combines the two subqueries into a single execution with joins.
- The use of joins reduces the need for multiple subplans and makes better use of indexes on customer_id in the payment and rental tables.

**Solution 1**, still containing subqueries
- **Key Highlights**:
    - **Hash Join** is used between customer and rental with a **Subquery Scan** on rental (likely to calculate the count of rentals).
    - **HashAggregate** is used to group by rental.customer_id and apply the filter count(*) > 3.
    - **Seq Scan** on rental.

- **Observations**:
    - The execution time is better than the original query. The **HashAggregate** combined with a subquery pre-filters some data, reducing the number of rows processed.
    - PostgreSQL can reduce the number of rows it has to process due to the **Subquery Scan** and **HashAggregate** happening earlier in the plan.

**Solution 2**, without subqueries
This solution does not result in a query plan that is as efficient.

- **Key Highlights**:
    - **Hash Join** is used between customer and rental.
    - **HashAggregate** is used to group by rental.customer_id and apply the filter count(*) > 2.
    - **Seq Scan** on both rental and payment.

- **Observations**: this version is performing much worse than the other.
    - **Number of Rows Processed**: the query processes significantly more rows than the previous one.
    - **Multiple Joins**: there are multiple Hash Joins in the plan and the final aggregation happens later in the query. This means PostgreSQL processes more data before filtering.
    - **No Early Filtering**: since this query joins all tables and processes a lot of data before filtering, more rows are passed through the joins than necessary, slowing down the query execution.
    - **Sorting and Distinct**: there's an additional sort and unique step at the end of the execution plan, which adds overhead. Sorting is expensive, especially when dealing with large datasets, and this step occurs due to the need for deduplication after the join.
