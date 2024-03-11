-- Accedemos a la BBDD sakila. 
USE sakila; 

-- 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.
-- Empleamos DISTINCT para sacar los valores unicos seleccionados para evitar los duplicados.Los datos distintos.

SELECT DISTINCT title
	FROM film;
    
-- 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".
-- Con WHERE podemos filtramos el valor solicitado para extraer especificamente lo que buscamos.

SELECT title 
	FROM film
		WHERE rating = 'PG-13';

-- 3.Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.
-- Para obtener datos que contengan lo solicitado utilizamos WHERE para filtrar y LIKE con el patrón %amazing%. la palabra amazing para indicar que contiene.

SELECT title, description
	FROM film
		WHERE description LIKE '%amazing%';
        
-- 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.
-- WHERE filtra en la duración y el operador > mayor que para filtrar las peliculas que tengan mayor duración a lo indicado.

SELECT title
	FROM film 
		WHERE length > 120;

-- 5.Recupera los nombres de todos los actores. 

SELECT first_name
	FROM actor;

-- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.
-- Filtramos con WHERE el apellido.

SELECT first_name, last_name 
	FROM actor
		WHERE last_name = 'Gibson'; -- ¿Puedo utilizar LIKE con patrón con % ?

-- 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.
-- Utilizando BETWEEN podemos filtrar los valores a localizar entre el rango 10 y 20.

SELECT first_name
	FROM actor 
		WHERE actor_id BETWEEN 10 AND 20;
        
-- 8.Encuentra el título de las películas en la tabla `film` que no sean ni "R" ni "PG-13" en cuanto a su clasificación
    -- Con NOT IN pero excluia incluso las que solo eran PG. -- 
    -- Con el operador != busco los valores que no coincidan con el valor indicado. 
    
 SELECT title 
	FROM film
		WHERE rating != 'R' AND rating != 'PG-13';

-- 9.Encuentra la cantidad total de películas en cada clasificación de la tabla `film` y muestra la clasificación junto con el recuento.
-- Contamos el total de registros de cada tipo de clasificación con COUNT y lo agrupamos con GROUP BY. 

SELECT rating, COUNT(*) AS cantidadTotal
	FROM film
		GROUP BY rating;
        
-- 10.Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.
-- Buscamos la relación entre las tablas , customer, rental y inventory y las unimos con 2 INNER JOIN para unir los datos de las columnas relacionadas. 
-- I.J permite obtener datos comunes de las tablas indicadas. 


SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS total_peliculas_alquiladas
	FROM customer AS c
		INNER JOIN rental AS r  ON r.customer_id = c.customer_id
        INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id
			GROUP BY c.customer_id, c.first_name, c.last_name;
            
-- 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.
--  Con el COUNT haremos el recuento de las películas alquiladas que queremos mostrar con cada categoria que se habrá agrupado con el GROUP BY.
-- Unimos las las tablas con cada columna relacionada/ necesaria utilizando 3 INNER JOIN. 

SELECT cat.name AS categoria, COUNT(rental_id) AS cantidad_total
	FROM film_category AS fcat 
    INNER JOIN inventory AS i ON fcat.film_id = i.film_id
    INNER JOIN category AS cat ON fcat.category_id = cat.category_id
    INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
    GROUP BY cat.name;
    
-- 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla `film` y muestra la clasificación junto con el promedio de duración.
-- Con AVG conseguimos el promedio de la duración de las películas, y las agrupamos por clasificación  con GROUP BY.
	
SELECT rating, AVG(length) AS average
FROM film
GROUP BY rating;

-- 13.Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".
-- Utilizamos dos INNER JOIN para unir 3 tablas con la relacion que necesitamos para extraer la info , y el WHERE para filtrar por la película indicada.

SELECT act.first_name, act.last_name
FROM actor AS act
INNER JOIN film_actor AS fa ON act.actor_id = fa.actor_id
INNER JOIN film AS f ON fa.film_id = f.film_id
WHERE f.title = 'Indian Love' ;

-- 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.
-- Con WHERE obtiene todos los datos de la columna indicada incluyendo LIKE con el patrón %*% donde contenga las palabras indicadas dog y cat.

SELECT title 
	FROM film
		WHERE description LIKE '%dog%' OR description LIKE '%cat%' ;

-- 15.Hay algún actor o actriz que no apareca en ninguna película en la tabla `film_actor`.  
-- Que no aparezca es igual a nulo, y con LEFT JOIN relacionamos inlcuso que aparezcan datos que no se especifican, que no coinciden .

SELECT actor.actor_id, actor.first_name, actor.last_name
	FROM actor 
		LEFT JOIN film_actor ON actor.actor_id = film_actor.actor_id
			WHERE film_actor.actor_id IS NULL;

-- 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010. (Año de lanzamiento para todas 2006)
-- WHERE filtrar columna, BETWEEEN el rango a filtrar.

SELECT title
	FROM film
		WHERE release_year BETWEEN 2005 AND 2010;
        
-- 17. Encuentra el título de todas las películas que son de la misma categoría que "Family".
-- Utilizamos dos INNER JOIN para unir/ establecer la relación entre las tres columnas que necesitamos extraer la información.

SELECT f.title
	FROM film AS f
		INNER JOIN film_category AS fcat ON f.film_id = fcat.film_id
        INNER JOIN category AS c ON fcat.category_id = c.category_id
		WHERE c.name = 'Family';
        
-- 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.
-- INNER JOIN para unir tablas actor y film_actor relación de columnas con los datos necesarios , HAVING COUNT condición de grupo , filtra el recuento del valor indicado para el grupo generado por la clausula GROUP BY.

SELECT actor.first_name, actor.last_name 
	FROM actor
		INNER JOIN film_actor AS fc ON actor.actor_id = fc.actor_id
        GROUP BY actor.actor_id
        HAVING COUNT(film_id) > 10; 
			
-- 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla `film`.
-- WHERE filtra el rating que sea R y añadimos el AND para añadir la duración que queremos buscar.

SELECT title
	FROM film
		WHERE rating = 'R' AND length > 120;
        
-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.
-- Seleccionamos las columnas category y AVG(lenght) aquí queremos que extraiga el promedio de la duración y las renombramos.
-- Relacionamos las tablas con las coincidencias que tengan las columnas relacionadas .
-- Agrupamos los resultados por el nombre de la categoría y los filtramos por la condición de la duración.


SELECT category.name AS categoria, AVG(film.length) AS length_avg
	FROM category
    INNER JOIN film_category ON category.category_id = film_category.category_id
    INNER JOIN film ON film_category.film_id = film.film_id
    GROUP BY category.name
    HAVING  AVG(film.length) > 120 ;


-- 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.
-- COUNT para contar la cantidad de películas. 
-- Unión de las tablas mediante Inner Join con las columnas en común , agrupando por actor con GROUP BY filtrando por la condición de que hayan actuado al menos en 5 películas.
-- Operador >= ya que indica al menos.


SELECT actor.first_name, actor.last_name, COUNT(film_actor.film_id) AS total_films
	FROM actor
		INNER JOIN film_actor ON actor.actor_id = film_actor.actor_id
			GROUP BY actor.actor_id
            HAVING COUNT(film_actor.film_id) >= 5; 
            
-- 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. 
-- Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes.
-- WHERE filtra fehcas con la función DATEDIFF : calcula la diferencia.        
-- Subconsulta : inner join uniendo inventory y rental con columna común.    
	SELECT film.title
		FROM film
			WHERE film.film_id IN (
								SELECT inventory.film_id
										FROM inventory
												INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
													 WHERE DATEDIFF(rental.return_date, rental.rental_date) > 5 );
										
                                                

-- 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". 
-- Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.
-- Con WHERE *  NOT IN busca actores cuyo actor_id no esté en la lista de actores (SELECT DISTINCT) que han actuado en películas de la categoría (WHERE) "Horror".
-- La consulta principal mostrara resultados que cumplan la condición de la subconsulta.

SELECT first_name, last_name
FROM actor
WHERE actor_id NOT IN (
						SELECT DISTINCT fa.actor_id
								FROM film_category AS fc
									INNER JOIN film_actor AS fa ON fc.film_id = fa.film_id
									INNER JOIN category AS c ON fc.category_id = c.category_id
											WHERE c.name = 'Horror'
);


-- Opción CTE -- 
WITH Horror_Actor AS ( 
						SELECT DISTINCT fa.actor_id
							FROM film_category AS fc
								INNER JOIN film_actor AS fa ON fc.film_id = fa.film_id
								INNER JOIN category AS c ON fc.category_id = c.category_id
									WHERE c.name = 'Horror' )
                                    
SELECT first_name, last_name
FROM actor
WHERE actor_id NOT IN (
						SELECT actor_id
                        FROM Horror_Actor
);
                                                                                    

## BONUS

-- 24. BONUS: Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla `film`.
-- Relacionamos las tablas donde aparecen los datos a buscar con INNER JOIN, y filtramos con WHERE para la categoría y duración indicada.

SELECT title
	FROM film
		INNER JOIN film_category ON film_category.film_id = film.film_id
        INNER JOIN category ON film_category.category_id = category.category_id
        WHERE category.name = 'Comedy' AND film.length > 180;

-- 25. BONUS: Encuentra todos los actores que han actuado juntos en al menos una película. 
-- La consulta debe mostrar el nombre y apellido de los actores y el número de películas en las que han actuado juntos.
-- Tablas a usar : actor, film_actor. 
-- Crear alias para tener nombre de 2 actores diferentes.
-- Autoasociación de la misma tabla. 
--

SELECT a1.first_name AS actor1_first_name, a1.last_name AS actor1_last_name,
       a2.first_name AS actor2_first_name, a2.last_name AS actor2_last_name,
       COUNT(DISTINCT fa1.film_id) AS numero_peliculas
FROM actor AS a1
	JOIN film_actor AS fa1 ON a1.actor_id = fa1.actor_id
	JOIN film_actor AS fa2 ON fa1.film_id = fa2.film_id AND fa1.actor_id < fa2.actor_id
	JOIN actor AS a2 ON fa2.actor_id = a2.actor_id
GROUP BY a1.actor_id, a1.first_name, a1.last_name, a2.actor_id, a2.first_name, a2.last_name
HAVING COUNT(DISTINCT fa1.film_id) >= 1;





            