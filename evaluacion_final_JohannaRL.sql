USE sakila;

-- 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.

SELECT DISTINCT title
	FROM film;
    
-- 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".

SELECT title 
	FROM film
		WHERE rating = 'PG-13';

-- 3.Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.

SELECT title, description
	FROM film
		WHERE description LIKE '%amazing%';
        
-- 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.

SELECT title
	FROM film 
		WHERE length > 120;

-- 5.Recupera los nombres de todos los actores. 

SELECT first_name
	FROM actor;

-- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.

SELECT first_name, last_name 
	FROM actor
		WHERE last_name = 'Gibson'; -- Puedo utilizar LIKE como comodín con % ??

-- 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.

SELECT first_name
	FROM actor 
		WHERE actor_id BETWEEN 10 AND 20;
        
-- 8.Encuentra el título de las películas en la tabla `film` que no sean ni "R" ni "PG-13" en cuanto a su clasificación
    -- Primero había utilizado NOT IN pero excluia incluso las que solo eran PG. -- 
    -- Con el operador != busco los valores que no coincidan con el valor indicado. 
    
 SELECT title 
	FROM film
		WHERE rating != 'R' AND rating != 'PG-13';

-- 9.Encuentra la cantidad total de películas en cada clasificación de la tabla `film` y muestra la clasificación junto con el recuento.

SELECT rating, COUNT(*) AS cantidadTotal
	FROM film
		GROUP BY rating;
        
-- 10.Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.

SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS total_peliculas_alquiladas
	FROM customer AS c
		INNER JOIN rental AS r  ON r.customer_id = c.customer_id
        INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id
			GROUP BY c.customer_id, c.first_name, c.last_name;
            
-- 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.

SELECT cat.name AS categoria, COUNT(rental_id) AS cantidad_total
	FROM film_category AS fcat 
    INNER JOIN inventory AS i ON fcat.film_id = i.film_id
    INNER JOIN category AS cat ON fcat.category_id = cat.category_id
    INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
    GROUP BY cat.name;
    
-- 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla `film` y muestra la clasificación junto con el promedio de duración.
	
SELECT rating, AVG(length) AS promedio
FROM film
GROUP BY rating;

-- 13.Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".

SELECT act.first_name, act.last_name
FROM actor AS act
INNER JOIN film_actor AS fa ON act.actor_id = fa.actor_id
INNER JOIN film AS f ON fa.film_id = f.film_id
WHERE f.title = 'Indian Love' ;

-- 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.

SELECT title 
	FROM film
		WHERE description LIKE '%dog%' OR description LIKE '%cat%' ;

-- 15.Hay algún actor o actriz que no apareca en ninguna película en la tabla `film_actor`. Subconsulta. ? Left Join?

SELECT actor.actor_id, actor.first_name, actor.last_name
	FROM actor 
		LEFT JOIN film_actor ON actor.actor_id = film_actor.actor_id
			WHERE film_actor.actor_id IS NULL;

-- 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010. (Año de lanzamiento para todas 2006)

SELECT title
	FROM film
		WHERE release_year between 2005 AND 2010;
        
-- 17. Encuentra el título de todas las películas que son de la misma categoría que "Family".

SELECT f.title
	FROM film AS f
		INNER JOIN film_category AS fcat ON f.film_id = fcat.film_id
        INNER JOIN category AS c ON fcat.category_id = c.category_id
		WHERE c.name = 'Family';
        
-- 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.

SELECT actor.first_name, actor.last_name 
	FROM actor
		INNER JOIN film_actor AS fc ON actor.actor_id = fc.actor_id
        GROUP BY actor.actor_id
        HAVING COUNT(film_id) > 10; 
			
-- 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla `film`.

SELECT title
	FROM film
		WHERE rating = 'R' AND length > 120;
        
-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.
-- Subconsulta o Join -- 

SELECT category.name AS categoria,
	(SELECT AVG(film.length)
		FROM film 
		INNER JOIN film_category ON film.film_id = film_category.film_id
		WHERE film_category.category_id = category.category_id) AS promedio
FROM category
HAVING promedio > 120;

-- Inner join -- *

SELECT category.name AS categoria, AVG(film.length) AS promedio_duracion
	FROM category
    INNER JOIN film_category ON category.category_id = film_category.category_id
    INNER JOIN film ON film_category.film_id = film.film_id
    GROUP BY category.name
    HAVING  AVG(film.length) > 120;


-- 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.

SELECT actor.first_name, actor.last_name, COUNT(film_actor.film_id) AS cantidad_peliculas
	FROM actor
		INNER JOIN film_actor ON actor.actor_id = film_actor.actor_id
			GROUP BY actor.actor_id
            HAVING COUNT(film_actor.film_id) >= 5; -- "Al menos" -- 
            
-- 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. 
-- Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes.
            
SELECT film.title
	FROM film
			WHERE film.film_id IN (
								SELECT inventory.film_id
										FROM inventory
												INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
													 WHERE DATEDIFF(rental.return_date, rental.rental_date) > 5 );
										
                                                

-- 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". 
-- Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.

SELECT first_name ,last_name 
	FROM actor 
		WHERE actor_id NOT IN (
								SELECT DISTINCT fact.actor_id
										FROM film_category as fcateg
											INNER JOIN film_actor AS fact ON fcateg.film_id = fact.film_id
												WHERE fcateg.category_id = (
																			SELECT category_id 
																				FROM category
																					WHERE name = "Horror")
);
                                                                                    

## BONUS

-- 24. BONUS: Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla `film`.

-- 25. BONUS: Encuentra todos los actores que han actuado juntos en al menos una película. La consulta debe mostrar el nombre y ape-- llido de los actores y el número de películas en las que han actuado juntos.

            