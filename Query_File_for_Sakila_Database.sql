use sakila;

#Q.1- Retrive staff_id, first_name, and respective district's_name-
SELECT s.staff_id, s.first_name, a.district
FROM staff AS s INNER JOIN store AS st INNER JOIN address AS a 
ON s.store_id = st.store_id AND st.address_id = a.address_id;

#Q.2- Find for How many actors have the first name scarlett?
SELECT COUNT(DISTINCT(actor_id)), first_name
FROM film_view
WHERE first_name="scarlett";

#Q.3- Which actors have the last name Johansson?
SELECT actor_id, last_name 
FROM actor 
WHERE last_name="Johansson";

#Q.4- How many actors  distinct last_names are there in database?
SELECT COUNT(DISTINCT(last_name)) AS "Total_no_of_Actors_with_Distinct_Last_Names" 
FROM actor;

#Q.5- Which actors with last names are not repeated?
SELECT last_name
FROM actor
WHERE last_name NOT IN (
					SELECT last_name 
					FROM actor 
					GROUP BY last_name 
					HAVING COUNT(last_name)>1);

#Q.6- Find top 5 actors that have appeared in the most film?
SELECT COUNT(fi.actor_id) AS "Actor_ID", LOWER(CONCAT(a.first_name," ",last_name)) AS "Name_of_the_Actor"
FROM film AS f INNER JOIN film_actor as fi INNER JOIN actor as a
ON f.film_id=fi.film_id AND fi.actor_id=a.actor_id
GROUP BY fi.actor_id
ORDER BY COUNT(fi.actor_id) DESC LIMIT 5;

#Q.7- Is Academy Dinosaur available for rent from store 1?
SELECT f.film_id, f.title
FROM film AS F INNER JOIN inventory AS i INNER JOIN store AS s
ON f.film_id=i.film_id AND i.store_id=s.store_id
WHERE ((f.title="Academy Dinosaur") AND (s.store_id="store_1"));

#Q.8- The business wants to run email campaigns for customers in store id 2, 
# for that it needs the email ids, first name as well as last name of the customers. Write a query to fetch this data.
SELECT first_name, last_name, email 
FROM customer 
WHERE store_id=2;

#Q.9- While doing the audit of the business, one of the financial analyst found out that some dvd's are being rented out for $0.99. 
# The finance department needs the count of such movies whose rental rate is $0.99. Can you help them?
SELECT COUNT(DISTINCT(title)) 
FROM film 
WHERE rental_rate = 0.99;

#Q.10- The accounts department, is thinking of comping up with a different way of accounting for the business costs. 
# To be able to do that they need to find out the number of movies rented at different rental price points. 
# Write an sql query so that this crucial input can be provided to the accounts department.
SELECT film_id, rental_rate FROM film;
SELECT MAX(rental_rate) FROM film;
SELECT MIN(rental_rate) FROM film;

SELECT COUNT(film_id) AS "Total_no_of_Films", rental_rate AS "Resntal_Rate_Classes" 
FROM film 
GROUP BY rental_rate;

#Q.11- The marketing team wants to understand how number of movies is spread across movie ratings. Can you help them?
SELECT COUNT(film_id) AS "Total_Count_of_Films_with_Respective_Ratings", rating AS "Film_Rating" 
FROM film 
GROUP BY rating;

#Q.12- The marketing team now also wants to know how ratings are distributed across stores. 
# The team needs to know the distribution of ratings for each store in the dataset. 
# Write a sql query to help solve this problem.
SELECT AVG(f.rating), i.store_id 
FROM film AS f RIGHT JOIN inventory as i 
ON f.film_id=i.film_id 
GROUP BY i.store_id;

#Q.13- The digital marketing team is studying what other movie rental businesses are doing. 
# One of the analysis that they want to do is study,
# what are the kind of movies that are being rented out by competitors as well as the current company. 
# Your job is to provide the team with details on film name, category each film belongs to and the language in which the film is.
SELECT f.film_id, f.title, ca.name, l.name 
FROM language as l INNER JOIN film as f INNER JOIN film_category as fi INNER JOIN category as ca
ON l.language_id=f.language_id AND f.film_id=fi.film_id AND fi.category_id=ca.category_id;

#Q.14- One of the questions that the business is interested in is about the popularity of the movies in the current inventory,
# also the stores and customers who bring in more revenue. Help the business in finding out-

# A. The number of times each movie is rented out
SELECT film_id, title, rental_duration AS "The_no_f_Time_each_movie_is_Rented_out" 
FROM film;

# B. Revenue pre movie
SELECT AVG(rental_rate) AS "Revenue_Per_Movie" 
FROM film;
SELECT MAX(rental_rate) AS "Most_Revenue_Earned_by_a_Store" 
FROM film;

# C. Most revenue earned by a store
SELECT f.rental_rate, i.store_id 
FROM film AS f RIGHT JOIN inventory as i 
ON f.film_id=i.film_id ORDER BY f.rental_rate DESC;

SELECT AVG(f.rental_rate), i.store_id 
FROM film AS f RIGHT JOIN inventory as i 
ON f.film_id=i.film_id 
GROUP BY i.store_id 
ORDER BY AVG(f.rental_rate) DESC;

# D. Which customer has spent the most
SELECT c.customer_id, c.store_id, p.rental_id, p.amount 
FROM customer as c RIGHT JOIN payment as p
ON c.customer_id=P.customer_id 
ORDER BY p.amount DESC;

SELECT c.store_id, AVG(p.amount) 
FROM customer as c RIGHT JOIN payment as p
ON c.customer_id=P.customer_id 
GROUP BY c.store_id 
ORDER BY AVG(p.amount) DESC;

#Q.14- One important aspect of business is loyalty and reward programs for customers as well as internal stakeholder. 
# The business is currently looking at launching some strategic initiatives for which they need to know the following information.

# A. Last Rental Date of every customer
SELECT c.customer_id AS 'Customer_ID', LOWER(CONCAT(c.first_name,' ',c.last_name)) AS 'Customer_Name', MAX(r.rental_date) AS "Last Rental Date"
FROM customer c LEFT JOIN rental r 
ON r.customer_id = c.customer_id 
GROUP BY c.customer_id ORDER BY c.customer_id ASC;

# B. Total Revenue Per Month-
SELECT MONTH(payment_date) AS "Month_No", SUM(amount) AS "Revenue Per Month"
FROM payment 
GROUP BY MONTH(payment_date);

# C. Number of distinct Renters per month-
SELECT COUNT(DISTINCT(customer_id)) AS "Total_no_of_Distinct_Renters", MONTH(payment_date) AS "Month_No" 
FROM payment 
GROUP BY MONTH(payment_date) 
ORDER BY COUNT(DISTINCT(customer_id)) DESC;

# D. Number of Distinct Film Rented Each Year-
SELECT YEAR(r.rental_date) AS "Year", COUNT(DISTINCT(f.film_id)) AS "No_of_Films_Rented"
FROM film as f INNER JOIN inventory as i INNER JOIN rental as r
ON f.film_id=i.film_id AND i.inventory_id=r.inventory_id
GROUP BY YEAR(r.rental_date) 
ORDER BY YEAR(r.rental_date) ASC; 

# E. Number of Rentals in Comedy , Sports and Family
SELECT COUNT(f.film_id) AS "Rental_Movie_Count", fi.category_id AS "Movie_Category_IDs", ca.name AS "Movie_Categories"
FROM film as f INNER JOIN film_category as fi INNER JOIN category as ca
ON f.film_id=fi.film_id AND fi.category_id=ca.category_id
WHERE ca.name IN ("Comedy","Sports","Family")
GROUP BY fi.category_id, ca.name;

# F. Users who have been rented at least 3 times
SELECT c.customer_id AS "Customer_ID", COUNT(c.customer_id) AS "Movie_Rented_for_atleast_Thrice"
FROM customer AS C LEFT JOIN rental AS r 
ON c.customer_id = r.customer_id
GROUP BY c.customer_id
HAVING COUNT(c.customer_id) >= 3
ORDER BY c.customer_id ASC;

# G. How much revenue has one single store made over PG13 and R rated films-
# G.1- Display it for different store_id and film_rating-
SELECT s.store_id AS "Store_ID", f.rating AS "Film_Rating", SUM(p.amount) AS "Revenue_Generated_by_Store"
FROM store AS s 
INNER JOIN inventory AS i ON s.store_id=i.store_id
INNER JOIN rental as r ON i.inventory_id=r.inventory_id
INNER JOIN payment as p ON r.rental_id=p.rental_id
INNER JOIN film AS f ON f.film_id=i.film_id
WHERE f.rating IN ("PG-13","R")
GROUP BY s.store_id, f.rating
ORDER BY s.store_id ASC;

# G.2- Display it for different store_id only-
SELECT s.store_id AS "Store_ID", SUM(p.amount) AS "Revenue_Generated_by_Store"
FROM store AS s 
INNER JOIN inventory AS i ON s.store_id=i.store_id
INNER JOIN rental as r ON i.inventory_id=r.inventory_id
INNER JOIN payment as p ON r.rental_id=p.rental_id
INNER JOIN film AS f ON f.film_id=i.film_id
WHERE f.rating IN ("PG-13","R")
GROUP BY s.store_id
ORDER BY s.store_id ASC;

#Q.15- Retrive the star cast for films-
SELECT CONCAT(a.first_name," ",a.last_name) AS "Name_of_the_Actor", f.title AS "Film_Tite", f.film_id AS "Film_ID"
FROM actor AS a INNER JOIN film_actor AS fa INNER JOIN film AS f
ON a.actor_id = fa.actor_id AND fa.film_id = f.film_id
ORDER BY CONCAT(a.first_name," ",a.last_name) ASC;

#Q.16- Every actor's count of films-
SELECT CONCAT(a.first_name," ",a.last_name) AS "Name_of_the_Actor", COUNT(title) AS "No_of_Films"
FROM actor AS a INNER JOIN film_actor AS fa INNER JOIN film AS f
ON a.actor_id = fa.actor_id AND fa.film_id = f.film_id 
GROUP BY CONCAT (a.first_name," ",a.last_name)
ORDER BY COUNT(title) DESC;