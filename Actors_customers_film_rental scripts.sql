

-- Sakila schema has various tables that contain data on actors, films, customers, inventory, rental, and staff. 

-- Below I will analyze the data and answer seven questions: 

-- 1. Top 5 customers based on total payment made

SELECT c.customer_id,
concat(c.first_name, " ", c.last_name) AS customer_name,
sum(p.amount) AS total_payments
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY 
	c.customer_id, customer_name
ORDER BY 
	total_payments DESC
LIMIT 5;

-- Karl Seal with customer ID 526 is the top paying customer




-- 2. The most rented film

SELECT 
f.title, 
	count(r.rental_id) AS rental_count
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY 
	f.film_id, f.title
ORDER BY 
	rental_count DESC
LIMIT 1;
-- The most rented film is Bucket Brotherhood. It was rented  34 times. 




-- 3. Actors who starred in the most films

SELECT
	a. actor_id, 
    concat(a.first_name, ' ', a.last_name) AS actor_name,
    COUNT(fa.film_id) AS film_count
FROM 
	actor a
JOIN 
	film_actor fa ON a.actor_id = fa.actor_id
GROUP BY 
	a.actor_id, actor_name
ORDER BY 
	film_count DESC;
-- Gina Degeneres starred in the most mumber of films, 42 in all. 




-- 4. Total revenue by store

SELECT s.store_id,
sum(p.amount) AS total_revenue
FROM 
	store s 
JOIN 
	staff st ON s.store_id = st.store_id
JOIN
	payment p ON st.staff_id = p.staff_id
GROUP BY
	s.store_id;

-- Store 2 has the most revenue with $33,924.06




-- 5. Most popular film in the "action" category

SELECT 
f.title,
count(r.rental_id) AS rental_count
FROM
	film f 
JOIN
	film_category fc ON f.film_id = fc.film_id
JOIN 
	category c ON fc.category_id = c.category_id
JOIN
	inventory i ON f.film_id = i.film_id
JOIN 
	rental r ON i.inventory_id = r.inventory_id
WHERE
	c.name = 'Action'
GROUP BY
	f.title
ORDER BY
	rental_count desc
LIMIT 5;
-- Both 'Rugrats Shakespeare' and 'Suspects Quills' are equally popular at 30 rentals. 




-- 6. Customers in the cities with the most rentals

SELECT ci.city,
count(r.rental_id) AS total_rentals
FROM 
	rental r
JOIN
	customer c ON r.customer_id = c.customer_id
JOIN
	address a ON c.address_id = a.address_id
JOIN 
	city ci ON a.city_id = ci.city_id
GROUP BY
	ci.city
ORDER BY 
	total_rentals DESC
LIMIT 5;
-- City of Aurora had the most rentals at 50




-- 7. Average number of rentals /customer / month
SELECT
	c.customer_id,
    concat(c.first_name, ' ', c.last_name) AS customer_name,
count(r.rental_id) / count(distinct date_format(r.rental_date, '%Y-%m'))
	AS avg_monthly_rentals
FROM 
	customer c
JOIN 
	rental r ON c.customer_id = r.customer_id
GROUP BY
	c.customer_id, customer_name
ORDER BY 
	avg_monthly_rentals DESC
LIMIT 10;

-- Average monthly rental = 11.50 by Eleanor Hunt
