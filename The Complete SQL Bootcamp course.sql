-- SELECT --
SELECT * FROM Film;
SELECT * FROM actor;
SELECT * FROM customer;

SELECT first_name, last_name FROM actor;

--Select Challenge
SELECT first_name, Last_name, email FROM customer;

-- SELECT DISTINCT --

SELECT DISTINCT(release_year) FROM film;

SELECT DISTINCT(rental_rate) FROM film;

--Select Distinct Challenge
SELECT DISTINCT(rating) FROM film;

-- COUNT --
SELECT COUNT(*) FROM film;
SELECT COUNT(DISTINCT first_name) FROM customer;
SELECT COUNT(DISTINCT(amount)) FROM payment;

-- WHERE --
-- Operators: =, >, <, >=, <=, (<> or !=), AND, OR, NOT
SELECT * FROM customer
WHERE first_name = 'Jerry';

SELECT * FROM film
WHERE rental_rate > 4 AND replacement_cost >= 19.99
AND (rating != 'R' OR rental_duration = '5');

SELECT COUNT(title) FROM film
WHERE rental_rate > 4 AND replacement_cost >= 19.99
AND rating != 'R' OR rating = 'PG-13';

-- Challenge
SELECT email FROM customer WHERE first_name = 'Nancy' AND last_name = 'Thomas';
SELECT description from film WHERE title = 'Outlaw Hanky';
SELECT phone FROM address WHERE address = '259 Ipoh Drive';

-- ORDER BY --
-- ASC ascending DESC descending
SELECT * FROM film ORDER BY release_year;
SELECT store_id, first_name, last_name FROM customer ORDER BY store_id ASC, first_name ASC;

-- LIMIT --
SELECT * FROM payment
WHERE amount != 0
ORDER BY payment_date DESC, amount DESC
LIMIT 5

-- Challenge
SELECT customer_id FROM payment
ORDER BY payment_date ASC, amount DESC
LIMIT 10

SELECT title, length, rental_rate FROM film
ORDER BY length ASC, rental_rate DESC
LIMIT 5

SELECT COUNT(title) FROM film
WHERE length <= 50;

-- BETWEEN --
-- value BETWEEN low AND high
-- same as value >= low AND value <= high
-- it's inclusive and can also be used with dates
-- DATE FORMAT: ISO 8601 YYYY-MM-DD

SELECT COUNT(*) FROM payment
WHERE amount BETWEEN 8 AND 9;

SELECT COUNT(*) FROM payment
WHERE amount NOT BETWEEN 8 AND 9;

SELECT * FROM payment
WHERE payment_date BETWEEN '2007-02-01' AND '2007-02-15';
--NOTE: this will depend if PostgresSQL sets the date to count up to 00 hour or 24 hour mark
SELECT * FROM payment
WHERE payment_date BETWEEN '2007-02-01' AND '2007-02-14';
-- The above returns no results as the 14th only goes until 00 hours

-- IN --
SELECT COUNT(*) FROM payment;
SELECT COUNT(*) FROM payment
WHERE amount IN (0.99, 1.98, 1.99);
SELECT COUNT(*) FROM payment
WHERE amount NOT IN (0.99, 1.98, 1.99);

SELECT * FROM customer
WHERE first_name IN ('John', 'Jake', 'Julie');

-- LIKE / ILIKE --
-- LIKE = case sensitive ILIKE case insensitive
-- % any number of characters _ any single character
-- SQL supports regex
SELECT * FROM customer
WHERE first_name LIKE 'A%';

SELECT * FROM customer
WHERE first_name ILIKE 'a%';

SELECT * FROM customer
WHERE first_name ILIKE '_her%';

SELECT * FROM customer
WHERE first_name ILIKE '%er%';
-- Note that this will return 'er' at the beginning and end of a name too

SELECT * FROM film
WHERE title LIKE 'Mission Impossible _';

-- Challenge
SELECT COUNT(payment_id) FROM payment WHERE amount > 5;
SELECT COUNT(first_name) FROM actor WHERE first_name LIKE 'P%';
SELECT COUNT(DISTINCT district) FROM address;
SELECT DISTINCT district FROM address;
SELECT COUNT(*) FROM film
WHERE rating = 'R' AND replacement_cost BETWEEN 5 AND 15;
SELECT COUNT(title) FROM film WHERE title ILIKE '%truman%';

-- GROUP BY --
-- Aggregate Functions --
-- Takes multiple inputs and returns a single output
-- AVG() COUNT() MAX() MIN() SUM()
-- Happen only in SELECT or HAVING clauses
-- AVG() returns floating point values - you can use ROUND() to specify decimal precision

SELECT * FROM film;

SELECT MIN(replacement_cost) FROM film;
SELECT MAX(replacement_cost) FROM film;
SELECT MAX(replacement_cost), MIN(replacement_cost) FROM film;
-- aggregate functions can be returned together but cannot be returned with multiple values
-- SELECT MAX(replacement_cost), payment_date FROM film; -- does not work

SELECT COUNT(*) FROM film;
SELECT COUNT(title) FROM film;

SELECT AVG(replacement_cost) FROM film;
SELECT ROUND(AVG(replacement_cost), 2) FROM film;

SELECT SUM(replacement_cost) FROM film;

-- GROUP BY --
-- Need to choose a CATEGORICAL column to group by - those are NON-CONTINUOUS
-- It will take the aggregate value for each category in the categorical column
-- Columns called must be categorical or aggregate
-- GROUP BY must come immediately after a FROM or WHERE statement
-- You can have multiple columns on the GROUP BY statement

SELECT * FROM payment;

SELECT customer_id FROM payment
GROUP BY customer_id
ORDER BY customer_id;

SELECT customer_id, SUM(amount) FROM payment
GROUP BY customer_id
ORDER BY SUM(amount) DESC;

SELECT customer_id, COUNT(amount) FROM payment
GROUP BY customer_id
ORDER BY COUNT(amount) DESC;

SELECT staff_id, customer_id, SUM(amount) FROM payment
GROUP BY customer_id, staff_id
ORDER BY customer_id;
-- How much did each customer spend with each staff member

SELECT DATE(payment_date), SUM(amount) FROM payment
GROUP BY DATE(payment_date)
ORDER BY SUM(amount) DESC;

-- This DATE() function solves our inclusion/exclusion date dilema!
SELECT * FROM payment
WHERE DATE(payment_date) BETWEEN '2007-02-01' AND '2007-02-14'
ORDER BY payment_date;

-- Challenge
SELECT staff_id, COUNT(amount) FROM payment
GROUP BY staff_id
ORDER BY COUNT(amount) DESC;

SELECT rating, ROUND(AVG(replacement_cost),2) FROM film
GROUP BY rating;

SELECT customer_id, SUM(amount) FROM payment
GROUP BY customer_id
ORDER BY SUM(amount) DESC
LIMIT 5;

-- My own challenge: It's staff 1's anniversary in the company, reward their top 5 customers with coupons
SELECT customer_id, SUM(amount) FROM payment
WHERE staff_id = 1
GROUP BY customer_id
ORDER BY SUM(amount) DESC
LIMIT 5;


-- HAVING --
-- Allows you to filter after an aggregation has taken place i.e filter by aggregate value

SELECT customer_id, SUM(amount) FROM payment
WHERE customer_id NOT IN (184, 87, 477, 148)
GROUP BY customer_id
ORDER BY SUM(amount) DESC;

SELECT customer_id, SUM(amount) FROM payment
WHERE customer_id NOT IN (184, 87, 477, 148)
GROUP BY customer_id
HAVING SUM(amount) >= 100
ORDER BY SUM(amount) ASC;

SELECT store_id, COUNT(customer_id) FROM customer
GROUP BY store_id
HAVING COUNT(*) > 300;

-- Challenges
SELECT customer_id, COUNT(*) FROM payment
WHERE amount > 0
GROUP BY customer_id
HAVING COUNT(*) >= 40
ORDER BY COUNT(*) DESC;

SELECT customer_id, SUM(amount) FROM payment
WHERE staff_id = 2
GROUP BY customer_id
HAVING SUM(amount) > 100
ORDER BY customer_id;

-- Assessment
SELECT customer_id, SUM(amount) FROM payment
WHERE staff_id = 2
GROUP BY customer_id
HAVING SUM(amount) >= 110
ORDER BY SUM(amount) ASC;

SELECT COUNT(*) FROM film
WHERE title ILIKE 'j%'

SELECT first_name, last_name FROM customer
WHERE first_name LIKE 'E%' AND address_id < 500
ORDER BY customer_id DESC
LIMIT 1;
