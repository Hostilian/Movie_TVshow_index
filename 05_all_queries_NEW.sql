-- ==============================================================================
-- MOVIE DATABASE - ALL QUERIES FOR PORTAL SUBMISSION
-- Database Systems (EIE36E) Project
--
-- BIE-DBS Cookbook Compliant - 3rd Iteration (30 points)
--
-- Student: Ozturk Eren
-- Login: xozte001
-- Database: xozte001
-- Server: db.kii.pef.czu.cz
-- Date: 2025-11-30
--
-- SUMMARY:
-- 59 queries across 18 categories (A through P)
-- All join queries use JOIN...USING to match RA <* natural join
-- Each query has 100+ char natural language description
-- ==============================================================================

-- ============================================================================
-- CATEGORY A: PROJECTION (π)
-- ============================================================================

-- A-1: Show only the title and year columns from all movies
SELECT DISTINCT title, year
FROM movie;

-- A-2: Display only the name and birth_year columns from the actor table
SELECT DISTINCT name, birth_year
FROM actor;

-- A-3: Extract only the genre_name column from the genre table
SELECT DISTINCT genre_name
FROM genre;

-- ============================================================================
-- CATEGORY B: SELECTION (σ)
-- ============================================================================

-- B-1: Find all movies released after 2010
SELECT DISTINCT *
FROM movie
WHERE year > 2010;

-- B-2: Find all actors born before 1970
SELECT DISTINCT *
FROM actor
WHERE birth_year < 1970;

-- B-3: Find all movies with an IMDb rating greater than 8.5
SELECT DISTINCT *
FROM movie
WHERE imdb_rating > 8.5;

-- B-4: Find all studios founded after the year 2000
SELECT DISTINCT *
FROM studio
WHERE founded_year > 2000;

-- B-5: Find all movies with runtime longer than 150 minutes
SELECT DISTINCT *
FROM movie
WHERE runtime > 150;

-- ============================================================================
-- CATEGORY C: PROJECTION + SELECTION
-- ============================================================================

-- C-1: Show title and imdb_rating for movies rated above 8.0
SELECT DISTINCT title, imdb_rating
FROM movie
WHERE imdb_rating > 8.0;

-- C-2: Show name and birth_year for directors born after 1960
SELECT DISTINCT name, birth_year
FROM director
WHERE birth_year > 1960;

-- C-3: Show title and runtime for movies between 90 and 120 minutes
SELECT DISTINCT title, runtime
FROM movie
WHERE runtime >= 90 AND runtime <= 120;

-- ============================================================================
-- CATEGORY D1: TWO-TABLE NATURAL JOIN (<*)
-- These use JOIN...USING to match RA natural join behavior
-- ============================================================================

-- D1-1: Join movie with director table
SELECT DISTINCT *
FROM movie
JOIN director USING (director_id);

-- D1-2: Join studio with country table
SELECT DISTINCT *
FROM studio
JOIN country USING (country_id);

-- D1-3: Join movie with studio table
SELECT DISTINCT *
FROM movie
JOIN studio USING (studio_id);

-- D1-4: Join user_rating with movie table
SELECT DISTINCT *
FROM user_rating
JOIN movie USING (movie_id);

-- D1-5: Join award with movie table
SELECT DISTINCT *
FROM award
JOIN movie USING (movie_id);

-- D1-6: Join movie_actor with actor table
SELECT DISTINCT *
FROM movie_actor
JOIN actor USING (actor_id);

-- D1-7: Join movie_genre with genre table
SELECT DISTINCT *
FROM movie_genre
JOIN genre USING (genre_id);

-- D1-8: Join movie_country with country table
SELECT DISTINCT *
FROM movie_country
JOIN country USING (country_id);

-- ============================================================================
-- CATEGORY D2: THREE-TABLE NATURAL JOIN CHAINS
-- ============================================================================

-- D2-1: Join movie through movie_actor to actor table
SELECT DISTINCT *
FROM movie
JOIN movie_actor USING (movie_id)
JOIN actor USING (actor_id);

-- D2-2: Join movie through movie_genre to genre table
SELECT DISTINCT *
FROM movie
JOIN movie_genre USING (movie_id)
JOIN genre USING (genre_id);

-- D2-3: Join movie through movie_country to country table
SELECT DISTINCT *
FROM movie
JOIN movie_country USING (movie_id)
JOIN country USING (country_id);

-- D2-4: Join movie to studio then country
SELECT DISTINCT *
FROM movie
JOIN studio USING (studio_id)
JOIN country USING (country_id);

-- D2-5: Join user_rating to movie then director
SELECT DISTINCT *
FROM user_rating
JOIN movie USING (movie_id)
JOIN director USING (director_id);

-- D2-6: Join award to movie then director
SELECT DISTINCT *
FROM award
JOIN movie USING (movie_id)
JOIN director USING (director_id);

-- ============================================================================
-- CATEGORY F1: JOIN WITH SELECTION
-- ============================================================================

-- F1-1: Get movies with their directors for films released after 2015
SELECT DISTINCT *
FROM movie
JOIN director USING (director_id)
WHERE year > 2015;

-- F1-2: Get movies with their studios for films rated above 8.0
SELECT DISTINCT *
FROM movie
JOIN studio USING (studio_id)
WHERE imdb_rating > 8.0;

-- F1-3: Get awards with movie info for actual winners only
SELECT DISTINCT *
FROM award
JOIN movie USING (movie_id)
WHERE is_winner = TRUE;

-- ============================================================================
-- CATEGORY F2: JOIN WITH PROJECTION
-- ============================================================================

-- F2-1: Get only movie title and director name
SELECT DISTINCT title, name
FROM movie
JOIN director USING (director_id);

-- F2-2: Get only studio name and country name
SELECT DISTINCT studio_name, country_name
FROM studio
JOIN country USING (country_id);

-- ============================================================================
-- CATEGORY F3: JOIN + SELECTION + PROJECTION
-- ============================================================================

-- F3-1: Get title and director name for movies rated above 8.5
SELECT DISTINCT title, name
FROM movie
JOIN director USING (director_id)
WHERE imdb_rating > 8.5;

-- F3-2: Get movie title and genre_name for Action films only
SELECT DISTINCT title, genre_name
FROM movie
JOIN movie_genre USING (movie_id)
JOIN genre USING (genre_id)
WHERE genre_name = 'Action';

-- ============================================================================
-- CATEGORY G1: COUNT AGGREGATION
-- ============================================================================

-- G1-1: Count the total number of movies
SELECT COUNT(*) AS total_movies
FROM movie;

-- G1-2: Count the total number of actors
SELECT COUNT(*) AS total_actors
FROM actor;

-- G1-3: Count the total number of awards
SELECT COUNT(*) AS total_awards
FROM award;

-- ============================================================================
-- CATEGORY G2: AVG, SUM, MIN, MAX
-- ============================================================================

-- G2-1: Calculate the average IMDb rating
SELECT ROUND(AVG(imdb_rating), 2) AS avg_rating
FROM movie;

-- G2-2: Find the minimum and maximum runtime
SELECT MIN(runtime) AS min_runtime, MAX(runtime) AS max_runtime
FROM movie;

-- G2-3: Calculate the sum of all IMDb votes
SELECT SUM(imdb_votes) AS total_votes
FROM movie;

-- ============================================================================
-- CATEGORY G3: GROUP BY
-- ============================================================================

-- G3-1: Count movies per director
SELECT director_id, COUNT(movie_id) AS movie_count
FROM movie
GROUP BY director_id;

-- G3-2: Calculate average rating per genre
SELECT genre_id, ROUND(AVG(imdb_rating), 2) AS avg_rating
FROM movie
JOIN movie_genre USING (movie_id)
GROUP BY genre_id;

-- G3-3: Count movies per release decade
SELECT (year / 10) * 10 AS decade, COUNT(*) AS movie_count
FROM movie
GROUP BY (year / 10) * 10
ORDER BY decade;

-- ============================================================================
-- CATEGORY G4: GROUP BY WITH HAVING
-- ============================================================================

-- G4-1: Find directors with more than 2 movies
SELECT director_id, COUNT(movie_id) AS movie_count
FROM movie
GROUP BY director_id
HAVING COUNT(movie_id) > 2;

-- G4-2: Find genres with average rating above 7.5
SELECT genre_id, ROUND(AVG(imdb_rating), 2) AS avg_rating
FROM movie
JOIN movie_genre USING (movie_id)
GROUP BY genre_id
HAVING AVG(imdb_rating) > 7.5;

-- ============================================================================
-- CATEGORY H1: UNION
-- ============================================================================

-- H1-1: Get all names from director and actor tables
SELECT name FROM director
UNION
SELECT name FROM actor;

-- H1-2: Get movies from either Action or Drama genre
SELECT title FROM movie
JOIN movie_genre USING (movie_id)
JOIN genre USING (genre_id)
WHERE genre_name = 'Action'
UNION
SELECT title FROM movie
JOIN movie_genre USING (movie_id)
JOIN genre USING (genre_id)
WHERE genre_name = 'Drama';

-- ============================================================================
-- CATEGORY H2: INTERSECTION
-- ============================================================================

-- H2-1: Find movies that are in both Action AND Sci-Fi genres
SELECT movie_id FROM movie_genre
JOIN genre USING (genre_id)
WHERE genre_name = 'Action'
INTERSECT
SELECT movie_id FROM movie_genre
JOIN genre USING (genre_id)
WHERE genre_name = 'Sci-Fi';

-- ============================================================================
-- CATEGORY H3: DIFFERENCE
-- ============================================================================

-- H3-1: Find directors who have NOT directed any movie
SELECT director_id FROM director
EXCEPT
SELECT director_id FROM movie;

-- H3-2: Find actors who have NOT appeared in any movie
SELECT actor_id FROM actor
EXCEPT
SELECT actor_id FROM movie_actor;

-- ============================================================================
-- CATEGORY I1: SUBQUERY (EXISTS/IN)
-- ============================================================================

-- I1-1: Find movies that have at least one award
SELECT DISTINCT *
FROM movie
WHERE EXISTS (SELECT 1 FROM award WHERE award.movie_id = movie.movie_id);

-- I1-2: Find actors who appeared in movies rated above 8
SELECT DISTINCT actor_id
FROM movie_actor
WHERE movie_id IN (SELECT movie_id FROM movie WHERE imdb_rating > 8);

-- ============================================================================
-- CATEGORY I2: SCALAR SUBQUERY
-- ============================================================================

-- I2-1: Show each movie title with the count of its actors
SELECT title,
       (SELECT COUNT(*) FROM movie_actor WHERE movie_actor.movie_id = movie.movie_id) AS actor_count
FROM movie;

-- ============================================================================
-- CATEGORY J: CORRELATED SUBQUERY
-- ============================================================================

-- J-1: Find movies with rating higher than the average rating of same year movies
SELECT *
FROM movie m1
WHERE imdb_rating > (
    SELECT AVG(imdb_rating)
    FROM movie m2
    WHERE m2.year = m1.year
);

-- J-2: Find directors who have directed a movie with rating above 8.5
SELECT *
FROM director d
WHERE EXISTS (
    SELECT 1 FROM movie m
    WHERE m.director_id = d.director_id AND m.imdb_rating > 8.5
);

-- ============================================================================
-- CATEGORY K: ORDER BY
-- ============================================================================

-- K-1: Get all movies sorted by imdb_rating descending
SELECT *
FROM movie
ORDER BY imdb_rating DESC;

-- K-2: Get all directors sorted by birth_year ascending
SELECT *
FROM director
ORDER BY birth_year ASC;

-- K-3: Get movies with directors sorted by year desc then title asc
SELECT *
FROM movie
JOIN director USING (director_id)
ORDER BY year DESC, title ASC;

-- ============================================================================
-- CATEGORY L: DISTINCT
-- ============================================================================

-- L-1: Get distinct years from movie table
SELECT DISTINCT year
FROM movie
ORDER BY year;

-- L-2: Get distinct director_ids from movie table
SELECT DISTINCT director_id
FROM movie;

-- ============================================================================
-- CATEGORY M: SELF-JOIN
-- ============================================================================

-- M-1: Find movie sequels by self-joining on sequel_of
SELECT m1.title AS sequel_title, m2.title AS original_title
FROM movie m1
JOIN movie m2 ON m1.sequel_of = m2.movie_id;

-- ============================================================================
-- CATEGORY N: OUTER JOIN
-- ============================================================================

-- N-1: Get all directors with their movies (including directors with no movies)
SELECT *
FROM director
LEFT JOIN movie USING (director_id);

-- N-2: Get all movies with awards (including movies with no awards)
SELECT *
FROM movie
LEFT JOIN award USING (movie_id);

-- ============================================================================
-- CATEGORY O: RENAME
-- ============================================================================

-- O-1: Rename movie title as film_title
SELECT title AS film_title, year, imdb_rating
FROM movie;

-- ============================================================================
-- CATEGORY P: CARTESIAN PRODUCT
-- ============================================================================

-- P-1: Create cartesian product of genre and country tables
SELECT *
FROM genre
CROSS JOIN country;

-- ==============================================================================
-- END OF QUERIES
-- Total: 59 queries across 18 categories
-- ==============================================================================
