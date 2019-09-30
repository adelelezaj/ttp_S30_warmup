-- You're wandering through the wilderness of someone else's code, and you stumble across
-- the following queries that use subqueries. You think they'd be better as CTE's
-- Go ahead and re-write the queries to use CTE's

-- -- EXAMPLE CTE:
--Returns the customer ID’s of ALL customers who have spent more money than $100 in their life.

WITH customer_totals AS (
  SELECT customer_id, 
         SUM(amount) as total
  FROM payment
  GROUP BY customer_id
)

SELECT customer_id, total 
FROM customer_totals 
WHERE total > 100;


--YOUR TURN:
-- Returns the average of the amount of stock each store has in their inventory. 
SELECT AVG(stock)
FROM (SELECT COUNT(inventory_id) as stock
	  FROM inventory
	  GROUP BY store_id) as store_stock;

	*SOLUTION*

WITH store_stock AS(
	SELECT COUNT(inventory_id )AS stock, store_id
	FROM inventory
	GROUP BY store_id
)
SELECT store_id, AVG(stock)
FROM store_stock
GROUP BY store_id;
	  
-- Returns the average customer lifetime spending, for each staff member.
-- HINT: you can work off the example
SELECT staff_id, AVG(total)
FROM (SELECT staff_id, SUM(amount) as total
	  FROM payment 
	  GROUP BY customer_id, staff_id) as customer_totals
GROUP BY staff_id;

	*SOLUTION*

WITH customer_totals AS(
	SELECT staff_id, SUM(amount) AS total
	FROM payment
	GROUP BY staff_id, customer_id
)
SELECT AVG(total), staff_id
FROM customer_totals
GROUP BY staff_id;

-- Returns the average rental rate for each genre of film.
SELECT AVG(rental_rate)
FROM film JOIN film_category ON film.film_id=film_category.film_id
GROUP BY category_id;

	*SOLUTION*

WITH category_per_film AS (
	SELECT * FROM film JOIN film_category ON film.film_id=film_category.film_id
)
SELECT category_id, avg(rental_rate)
FROM category_per_film 
GROUP BY 1
ORDER BY 1;


-- Return all films that have the rating that is biggest category 
-- (ie. rating with the highest count of films)
SELECT title, rating
FROM film
WHERE rating = (SELECT rating FROM film GROUP BY rating ORDER BY COUNT(*) LIMIT 1);


	*SOLUTION*

WITH total_films AS(
    SELECT rating,  
    FROM film
    GROUP BY rating
    ORDER BY COUNT(*)
    LIMIT 1
)
SELECT title, rating
FROM film
JOIN total_films USING (rating);



-- Return all purchases from the longest standing customer
-- (ie customer who has the earliest payment_date)
SELECT * 
FROM payment
WHERE customer_id = (SELECT customer_id
					  FROM payment
					  ORDER BY payment_date
					 LIMIT 1);

	*SOLUTION*

WITH longest_standing_payment AS (
	SELECT customer_id
	FROM payment
	ORDER BY payment_date
	LIMIT 1
)
SELECT customer_id, amount, payment_date
FROM payment
JOIN longest_standing_payment USING (customer_id);