-- ==============================================================================
-- MOVIE DATABASE - UPDATED QUERIES WITH CN AND D1N CATEGORIES
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
-- IMPORTANT: This file adds CN and D1N category queries that were MISSING
-- ==============================================================================

-- ============================================================================
-- CATEGORY CN: SELECTION/PROJECTION + OUTER JOIN
-- These queries combine projection (π) and selection (σ) with LEFT JOIN (⟕)
-- ============================================================================

-- CN-1: Show movie titles and their awards, including movies without awards
-- Natural: Show all movies with their award information including movies that
-- have never received any awards so the marketing team can identify films
-- needing promotion push.
-- RA: π(movie_id, title, year, award_name, is_winner)(MOVIE ⟕ AWARD)
SELECT m.movie_id, m.title, m.year, a.award_name, a.is_winner
FROM movie AS m
LEFT JOIN award AS a ON m.movie_id = a.movie_id;

-- CN-2: Show genres with their movies including empty genres
-- Natural: Display all genres and show which movies belong to each genre
-- including genres that currently have no movies assigned so content managers
-- can identify gaps in catalog coverage.
-- RA: π(genre_id, genre_name, movie_id, title)(GENRE ⟕ MOVIE_GENRE ⟕ MOVIE)
SELECT g.genre_id, g.genre_name, m.movie_id, m.title
FROM genre AS g
LEFT JOIN movie_genre AS mg ON g.genre_id = mg.genre_id
LEFT JOIN movie AS m ON mg.movie_id = m.movie_id;

-- CN-3: Show studios with their movies including studios with no films
-- Natural: List all production studios and their movies including studios
-- that have not produced any films in our database so executives can
-- identify partnership opportunities.
-- RA: π(studio_id, studio_name, movie_id, title)(STUDIO ⟕ MOVIE)
SELECT s.studio_id, s.studio_name, m.movie_id, m.title
FROM studio AS s
LEFT JOIN movie AS m ON s.studio_id = m.studio_id;

-- CN-4: Show countries with studios including countries with no studios
-- Natural: Display all countries and their associated production studios
-- including countries that have no registered studios so business development
-- can target new markets.
-- RA: π(country_id, country_name, studio_id, studio_name)(COUNTRY ⟕ STUDIO)
SELECT c.country_id, c.country_name, s.studio_id, s.studio_name
FROM country AS c
LEFT JOIN studio AS s ON c.country_id = s.country_id;

-- CN-5: Show movies with user ratings including unrated movies
-- Natural: Display each movie with user rating information returning unrated
-- titles too so support knows where feedback is still missing.
-- RA: π(movie_id, title, rating_id, user_name, rating_value)(MOVIE ⟕ USER_RATING)
SELECT m.movie_id, m.title, ur.rating_id, ur.user_name, ur.rating_value
FROM movie AS m
LEFT JOIN user_rating AS ur ON m.movie_id = ur.movie_id;

-- ============================================================================
-- CATEGORY D1N: TWO-TABLE NATURAL JOIN + OUTER JOIN
-- These queries use LEFT JOIN between two entity tables
-- ============================================================================

-- D1N-1: Directors with their movies including directors without films
-- Natural: List all directors together with their movies including directors
-- who have not yet directed any films in our database so HR can track inactive talent.
-- RA: π(director_id, name, birth_year, movie_id, title, year)(DIRECTOR ⟕ MOVIE)
SELECT d.director_id, d.name, d.birth_year, m.movie_id, m.title, m.year
FROM director AS d
LEFT JOIN movie AS m ON d.director_id = m.director_id;

-- D1N-2: Actors with their movie appearances including actors without films
-- Natural: Show all actors with their movie appearances including actors who
-- have not been cast in any films yet so casting directors can find available
-- talent for new projects.
-- RA: π(actor_id, name, movie_id, role_type)(ACTOR ⟕ MOVIE_ACTOR)
SELECT a.actor_id, a.name, ma.movie_id, ma.role_type
FROM actor AS a
LEFT JOIN movie_actor AS ma ON a.actor_id = ma.actor_id;

-- D1N-3: Movies with sequel information including movies without sequels
-- Natural: List every movie with its sequel information including films that
-- have no sequels so franchise analysts can identify standalone titles.
-- RA: π(m1.movie_id, m1.title, m2.movie_id, m2.title)(MOVIE m1 ⟕ MOVIE m2)
SELECT m1.movie_id AS original_id, m1.title AS original_title,
       m2.movie_id AS sequel_id, m2.title AS sequel_title
FROM movie AS m1
LEFT JOIN movie AS m2 ON m1.movie_id = m2.sequel_of;

-- D1N-4: Movies with production countries including movies without countries
-- Natural: Show all movies with their production countries including films
-- that have no country assignment so data quality teams can fix incomplete records.
-- RA: π(movie_id, title, country_id, country_name)(MOVIE ⟕ MOVIE_COUNTRY ⟕ COUNTRY)
SELECT m.movie_id, m.title, c.country_id, c.country_name
FROM movie AS m
LEFT JOIN movie_country AS mc ON m.movie_id = mc.movie_id
LEFT JOIN country AS c ON mc.country_id = c.country_id;

-- D1N-5: Countries with their production movies including countries with no films
-- Natural: List every country together with movies produced there including
-- countries with no film production so international distribution teams can
-- identify market opportunities.
-- RA: π(country_id, country_name, movie_id, title)(COUNTRY ⟕ MOVIE_COUNTRY ⟕ MOVIE)
SELECT c.country_id, c.country_name, m.movie_id, m.title
FROM country AS c
LEFT JOIN movie_country AS mc ON c.country_id = mc.country_id
LEFT JOIN movie AS m ON mc.movie_id = m.movie_id;

-- ============================================================================
-- COMBINED CATEGORY QUERIES (For Portal Second Iteration)
-- These 10 queries replace D1-D10 to ensure CN and D1N coverage
-- ============================================================================

-- D1 (A F2): List all movies with director names
-- Natural: List all movies together with their director names by joining the
-- movie and director tables so we can see who directed each film sorted by year.
SELECT m.movie_id, m.title, m.year, d.name AS director_name
FROM movie AS m
JOIN director AS d ON m.director_id = d.director_id
ORDER BY m.year;

-- D2 (A F2): Find actors in Inception
-- Natural: Find all actors who appeared in the movie titled Inception by
-- joining actor and movie_actor tables to see the complete cast with their role types.
SELECT a.actor_id, a.name, ma.role_type
FROM actor AS a
JOIN movie_actor AS ma ON a.actor_id = ma.actor_id
JOIN movie AS m ON ma.movie_id = m.movie_id
WHERE m.title = 'Inception';

-- D3 (A F2): Show Action movies
-- Natural: Show all movies that belong to the Action genre by joining movie,
-- movie_genre and genre tables to filter action films sorted by their IMDb rating.
SELECT m.movie_id, m.title, m.year, m.imdb_rating
FROM movie AS m
JOIN movie_genre AS mg ON m.movie_id = mg.movie_id
JOIN genre AS g ON mg.genre_id = g.genre_id
WHERE g.genre_name = 'Action'
ORDER BY m.imdb_rating DESC;

-- D4 (A F2): User reviews for Nolan films
-- Natural: List all user reviews for movies directed by Christopher Nolan by
-- joining user_rating, movie and director tables to see audience feedback on his films.
SELECT m.title, ur.user_name, ur.rating_value, ur.review_text
FROM user_rating AS ur
JOIN movie AS m ON ur.movie_id = m.movie_id
JOIN director AS d ON m.director_id = d.director_id
WHERE d.name = 'Christopher Nolan';

-- D5 (CN): Movies with awards including movies without awards ← COVERS CN!
-- Natural: Show all movies with their award information including movies that
-- have never received any awards so the marketing team can identify films needing promotion.
SELECT m.movie_id, m.title, m.year, a.award_name, a.is_winner
FROM movie AS m
LEFT JOIN award AS a ON m.movie_id = a.movie_id;

-- D6 (D1N): Directors with movies including directors without films ← COVERS D1N!
-- Natural: List all directors together with their movies including directors
-- who have not yet directed any films in our database so HR can track inactive talent.
SELECT d.director_id, d.name, d.birth_year, m.movie_id, m.title, m.year
FROM director AS d
LEFT JOIN movie AS m ON d.director_id = m.director_id;

-- D7 (A F2): Award winners only
-- Natural: List all awards that were won not just nominated along with movie
-- title using WHERE clause to filter winners and ORDER BY to sort by year awarded.
SELECT a.award_id, a.award_name, a.category, a.year_awarded, m.title
FROM award AS a
JOIN movie AS m ON a.movie_id = m.movie_id
WHERE a.is_winner = TRUE
ORDER BY a.year_awarded;

-- D8 (A F2): Lead actors in high-rated films
-- Natural: Find all lead actors in movies that have an IMDb rating above eight
-- using DISTINCT to avoid duplicates when actors have multiple lead roles.
SELECT DISTINCT a.actor_id, a.name
FROM actor AS a
JOIN movie_actor AS ma ON a.actor_id = ma.actor_id
JOIN movie AS m ON ma.movie_id = m.movie_id
WHERE m.imdb_rating > 8 AND ma.role_type = 'lead';

-- D9 (CN): Genres with movies including empty genres ← COVERS CN!
-- Natural: Display all genres and show which movies belong to each genre
-- including genres that currently have no movies assigned so content managers
-- can identify gaps in catalog coverage.
SELECT g.genre_id, g.genre_name, m.movie_id, m.title
FROM genre AS g
LEFT JOIN movie_genre AS mg ON g.genre_id = mg.genre_id
LEFT JOIN movie AS m ON mg.movie_id = m.movie_id;

-- D10 (D1N): Actors with appearances including uncast actors ← COVERS D1N!
-- Natural: Show all actors with their movie appearances including actors who
-- have not been cast in any films yet so casting directors can find available talent.
SELECT a.actor_id, a.name, ma.movie_id, ma.role_type
FROM actor AS a
LEFT JOIN movie_actor AS ma ON a.actor_id = ma.actor_id;

-- ==============================================================================
-- END OF CN AND D1N CATEGORY QUERIES
-- ==============================================================================
