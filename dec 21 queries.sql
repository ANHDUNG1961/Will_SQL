select rental_id from rental
where rental_id not in (select rental_id from payment)
--
select rental_id from rental
except
select rental_id from payment





select a.actor_id, concat(a.first_name,' ', a.last_name) as actor, c.customer_id, concat(c.first_name,' ', c.last_name) as customer 
from actor a, customer c
where concat(a.first_name,' ', a.last_name) = concat(c.first_name,' ', c.last_name)


SELECT avg(rental_count)
FROM (
    SELECT customer_id, COUNT(*) AS rental_count
    FROM rental
    GROUP BY customer_id
) as customer_rental_count;




SELECT customer_id, first_name, last_name,
    (SELECT COUNT(*) FROM rental WHERE rental.customer_id = customer.customer_id) 
FROM customer;


--come back to this to add more data to time series

SELECT ct.city, EXTRACT(MONTH FROM p.payment_date) as month, SUM(p.amount) AS total_payment
FROM payment p
full JOIN customer c ON p.customer_id = c.customer_id
full JOIN address a ON c.address_id = a.address_id
full JOIN city ct ON a.city_id = ct.city_id
GROUP BY ct.city, EXTRACT(MONTH FROM p.payment_date) 
ORDER BY total_payment desc;
--inner below outer above
SELECT ct.city as city, EXTRACT(MONTH FROM p.payment_date) AS month, SUM(p.amount) AS total_payment
FROM payment p
JOIN customer c ON p.customer_id = c.customer_id
JOIN address a ON c.address_id = a.address_id
JOIN city ct ON a.city_id = ct.city_id
GROUP BY city, month
ORDER BY total_payment DESC;



--use generate_series tool

SELECT generate_series(
         '2023-01-01'::date,  -- Replace with your start date
         '2023-12-31'::date,  -- Replace with your end date
         '1 day'::interval    -- Replace with your desired interval
       )::date AS date_value;




SELECT
  title,
  rental_duration, rental_rate,
  AVG(rental_duration) over(partition by rental_rate)
FROM film;





SELECT amount, customer_id, 
avg(amount) OVER (PARTITION BY EXTRACT(MONTH FROM payment_date)) as month_average, EXTRACT(month FROM payment_date) as month
FROM payment
ORDER BY month desc;

with customer_month_total as (
select sum(amount) as customer_sum, customer_id, EXTRACT(MONTH FROM payment_date) as month
from payment
group by customer_id, month )

select customer_sum, customer_id, month, avg(customer_sum) over(PARTITION BY month)
from customer_month_total
order by customer_sum asc









WITH revenue_vs_month AS (

SELECT DISTINCT avg(amount) OVER (PARTITION BY EXTRACT(MONTH FROM payment_date)) as month_average, EXTRACT(month FROM payment_date) as month
FROM payment	
)

SELECT avg(amount), EXTRACT(MONTH FROM payment_date)
FROM payment
GROUP BY EXTRACT(MONTH FROM payment_date);





WITH film_rentals AS (
  SELECT inventory.film_id, COUNT(*) AS rental_count
  FROM rental
  JOIN inventory ON rental.inventory_id = inventory.inventory_id
  GROUP BY inventory.film_id
)
SELECT f.title, fr.rental_count
FROM film f
JOIN film_rentals fr ON f.film_id = fr.film_id
WHERE fr.rental_count > 1;







