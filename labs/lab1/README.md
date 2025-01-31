# Lab 1. Data Normalization

## Objective
In this lab, you will learn to identify normalization issues and the effects of lack of normalization (anomalies) using PostreSQL. You will use SQL queries to observe how update, insert and delete anomalies occur in unnormalized or partially normalized tables, and you will practice normalizing tables up to Third Normal Form (3NF).

## Sample Database
For this lab, you will use the DVD Rental Smaple Database, which is widely used for learning database concepts. It includes various entities like customers, rentals, films and actors. The database is available for PostgreSQL, and can be downloaded from PostgreSQL Sample Databases.

## Exercise 1: Identifying Redundancy and Anomalies in an Unnormalized Table

- Create an Unnormalized Table.
-  Insert some sample data.

### Demonstrate Update Anomaly**
- **Problem**: If John Doe changes his addrss, you must update every row where John Doe appears.
- **Task**: Create an update query and observe the redundancy. Example could be that maybe the bussiness logic is to update addresses only for a customer's latest rental.

**Theoretical Explanation:**
- **Redundant Data**: If there are more customers with the same name or multiple rentals, updating the address means executing the update on all relevant rows. This is complicated and error-prone.
- **Inconsistent Data**: If the update is not performed on all relevant rows, you could end up with inconsistent data. For instance, one record could show the old address, while another record shows the new address. This inconsistency can lead to confusion and errors in customer data.
- **Bussiness Logic Challenge**: If bussiness logic dictates that only the latest renatl address should be updated, the current structure doesn't support that efficiently. You would have to manually ensure that you are only updating the correct row, increasing the risk of human error.

### Demonstrate Insert Anomaly
- **Task**: Try inserting a new customer without film information.

As a result, a lot of null values are inserted into the film's columns.

### Demonstrate Delete Anomaly
- **Task**: Run a delete query to delete a record and observe any issues this might have caused.

As a result, if you delete the only record for a customer, the information on that customer will be lost.

## Exercise 2: Normalizing the Table

- Move to 1NF (``lab1-2``).
- Move to 2NF (``lab1-3``).
- No need to move to 3NF as it is already in that form.
