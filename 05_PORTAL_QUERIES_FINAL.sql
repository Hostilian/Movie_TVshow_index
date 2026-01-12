-- ==============================================================================
-- MOVIE DATABASE - PORTAL QUERIES (D1-D41)
-- Matches EXACTLY what is in DBS Portal: czu.dbsportal.cz
--
-- Student: Ozturk Eren
-- Login: xozte001
-- Database: xozte001
-- Server: db.kii.pef.czu.cz
-- Last Updated: January 6, 2026
--
-- TOTAL: 41 QUERIES
-- ==============================================================================

-- ============================================================================
-- D1: Show only the title and year for every movie to build a compact catalog view.
-- Category: A (Projection)
-- ============================================================================
-- RA: MOVIE[title, year]
SELECT title, year
FROM MOVIE;

-- ============================================================================
-- D2: List every movie title in the database to produce an alphabetical film list.
-- Category: A, G1 (Single Column Projection)
-- ============================================================================
-- RA: MOVIE[title]
SELECT title
FROM MOVIE;

-- ============================================================================
-- D3: Find movie IDs for films that have never received any awards.
-- Category: H3 (Except/Difference)
-- ============================================================================
-- RA: MOVIE[movie_id] \ AWARD[movie_id]
SELECT DISTINCT movie_id
FROM MOVIE
EXCEPT
SELECT DISTINCT movie_id
FROM AWARD;

-- ============================================================================
-- D4: Return movies directed by Christopher Nolan.
-- Category: B, F1 (Selection with Join)
-- ============================================================================
-- RA: MOVIE <* (DIRECTOR(name='Christopher Nolan'))
SELECT DISTINCT *
FROM MOVIE
JOIN DIRECTOR USING (director_id)
WHERE name = 'Christopher Nolan';

-- ============================================================================
-- D5: Find actors who have appeared in every genre (Universal Quantification).
-- Category: D1 (Division - Universal Quantification)
-- ============================================================================
-- RA: actor <* movie_actor
SELECT a.actor_id, a.name
FROM actor a
WHERE NOT EXISTS (
    SELECT 1
    FROM genre g
    WHERE NOT EXISTS (
        SELECT 1
        FROM movie_actor ma
        JOIN movie_genre mg ON ma.movie_id = mg.movie_id
        WHERE ma.actor_id = a.actor_id
        AND mg.genre_id = g.genre_id
    )
)
ORDER BY a.name;

-- ============================================================================
-- D6: Show the names of actors found in the previous query (D5) to verify the results.
-- Category: D2 (Result Check)
-- ============================================================================
-- RA: actor <* movie_actor <* movie_genre <* genre
SELECT DISTINCT a.* FROM actor a WHERE NOT EXISTS (SELECT genre_id FROM genre g WHERE NOT EXISTS (SELECT 1 FROM movie_actor ma JOIN movie_genre mg ON ma.movie_id = mg.movie_id WHERE ma.actor_id = a.actor_id AND mg.genre_id = g.genre_id)) ORDER BY a.actor_id;

-- ============================================================================
-- D7: Show movies with their directors, keeping only films released after 2015.
-- Category: F1 (Join + Selection)
-- ============================================================================
-- RA: (MOVIE(year > 2015)) <* DIRECTOR
SELECT DISTINCT *
FROM MOVIE
JOIN DIRECTOR USING (director_id)
WHERE year > 2015;

-- ============================================================================
-- D8: List movie titles together with director names.
-- Category: F2 (Join + Projection)
-- ============================================================================
-- RA: (MOVIE <* DIRECTOR)[title, name]
SELECT title, name
FROM MOVIE
JOIN DIRECTOR USING (director_id);

-- ============================================================================
-- D9: Display titles and director names only for movies rated above 8.0.
-- Category: F3 (Join + Selection + Projection)
-- ============================================================================
-- RA: ((MOVIE(imdb_rating > 8)) <* DIRECTOR)[title, name]
SELECT title, name
FROM MOVIE
JOIN DIRECTOR USING (director_id)
WHERE imdb_rating > 8;

-- ============================================================================
-- D10: Show director names alongside their movie titles and IMDb ratings.
-- Category: F4 (Join + Multi-column Projection)
-- ============================================================================
-- RA: (MOVIE <* DIRECTOR)[name, title, imdb_rating]
SELECT name, title, imdb_rating
FROM MOVIE
JOIN DIRECTOR USING (director_id);

-- ============================================================================
-- D11: Show each genre with the IDs of movies assigned to it.
-- Category: F5 (Join + Different Projection)
-- ============================================================================
-- RA: (MOVIE_GENRE <* GENRE)[genre_name, movie_id]
SELECT genre_name, movie_id
FROM MOVIE_GENRE
JOIN GENRE USING (genre_id);

-- ============================================================================
-- D12: List all IMDb ratings from the movie table.
-- Category: G2 (Single Column Projection)
-- ============================================================================
-- RA: MOVIE[imdb_rating]
SELECT imdb_rating
FROM MOVIE;

-- ============================================================================
-- D13: List each movie with its director ID.
-- Category: G3 (Two Column Projection)
-- ============================================================================
-- RA: MOVIE[movie_id, director_id]
SELECT movie_id, director_id
FROM MOVIE;

-- ============================================================================
-- D14: Show the ID, title, and release year of every movie.
-- Category: G4 (Three Column Projection)
-- ============================================================================
-- RA: MOVIE[movie_id, title, year]
SELECT DISTINCT movie_id, title, year
FROM MOVIE
ORDER BY movie_id;

-- ============================================================================
-- D15: Combine director and actor names.
-- Category: H1 (Union)
-- ============================================================================
-- RA: DIRECTOR[name] ∪ ACTOR[name]
SELECT DISTINCT name
FROM DIRECTOR
UNION
SELECT DISTINCT name
FROM ACTOR;

-- ============================================================================
-- D16: Find movie IDs that appear both in the movie table and in awards.
-- Category: H2 (Intersect)
-- ============================================================================
-- RA: MOVIE[movie_id] ∩ AWARD[movie_id]
SELECT DISTINCT movie_id
FROM MOVIE
INTERSECT
SELECT DISTINCT movie_id
FROM AWARD;

-- ============================================================================
-- D17: Find directors who have not directed any movie yet.
-- Category: H3 (Except/Difference)
-- ============================================================================
-- RA: DIRECTOR[director_id] \ MOVIE[director_id]
SELECT DISTINCT director_id
FROM DIRECTOR
EXCEPT
SELECT DISTINCT director_id
FROM MOVIE;

-- ============================================================================
-- D18: List all movies that have at least one award.
-- Category: G1, H2 (Nested Query/Intersect)
-- ============================================================================
-- RA: MOVIE[movie_id] ∩ AWARD[movie_id]
SELECT DISTINCT movie_id
FROM movie
WHERE movie_id IN (SELECT movie_id FROM award)
ORDER BY movie_id;

-- ============================================================================
-- D19: Show movie titles together with each award name they received.
-- Category: D1 (Natural Join 2 tables)
-- ============================================================================
-- RA: MOVIE <* AWARD
SELECT *
FROM MOVIE
JOIN AWARD USING (movie_id)
ORDER BY movie_id;

-- ============================================================================
-- D20: Find awarded movies using an EXISTS predicate (Variant 1).
-- Category: J (Same Query - 3 ways) - EXISTS version
-- ============================================================================
-- RA: σ(∃ award)(MOVIE)
SELECT DISTINCT m.movie_id, m.title
FROM movie m
WHERE EXISTS (SELECT 1 FROM award a WHERE a.movie_id = m.movie_id)
ORDER BY m.movie_id;

-- ============================================================================
-- D21: Find awarded movies using an IN predicate (Variant 2).
-- Category: J (Same Query - 3 ways) - IN version
-- ============================================================================
-- RA: σ(movie_id ∈ AWARD[movie_id])(MOVIE)
SELECT DISTINCT m.movie_id, m.title
FROM movie m
WHERE m.movie_id IN (SELECT a.movie_id FROM award a)
ORDER BY m.movie_id;

-- ============================================================================
-- D22: Find awarded movies using a direct JOIN (Variant 3).
-- Category: J (Same Query - 3 ways) - JOIN version
-- ============================================================================
-- RA: MOVIE <* AWARD
SELECT DISTINCT m.movie_id, m.title
FROM movie m
JOIN award a ON m.movie_id = a.movie_id
ORDER BY m.movie_id;

-- ============================================================================
-- D23: Show every column and row from the movie table.
-- Category: K (Full Table)
-- ============================================================================
-- RA: MOVIE
SELECT *
FROM movie
ORDER BY movie_id;

-- ============================================================================
-- D24: List all distinct release years present in the movie table.
-- Category: L (Distinct Values)
-- ============================================================================
-- RA: MOVIE[year] (with distinct)
SELECT DISTINCT year
FROM MOVIE
ORDER BY year;

-- ============================================================================
-- D25: Find movies with IMDb rating greater than 8.0.
-- Category: B (Selection)
-- ============================================================================
-- RA: MOVIE(imdb_rating > 8.0)
SELECT *
FROM movie
WHERE imdb_rating > 8.0
ORDER BY movie_id;

-- ============================================================================
-- D26: Show all studios with their country information.
-- Category: D1N (Natural Join 2 tables)
-- ============================================================================
-- RA: STUDIO <* COUNTRY
SELECT *
FROM studio
JOIN country USING (country_id);

-- ============================================================================
-- D27: Display movie title, release year, IMDb rating, and runtime.
-- Category: O (Multi-column - 4 columns)
-- ============================================================================
-- RA: MOVIE[title, year, imdb_rating, runtime]
SELECT DISTINCT title, year, imdb_rating, runtime
FROM movie
ORDER BY title;

-- ============================================================================
-- D28: Generate every combination of genres and countries.
-- Category: P (Cartesian Product)
-- ============================================================================
-- RA: GENRE × COUNTRY
SELECT
    GENRE.genre_id,
    GENRE.genre_name,
    GENRE.created_at,
    COUNTRY.country_id,
    COUNTRY.country_name,
    COUNTRY.country_code,
    COUNTRY.created_at AS created_at_1
FROM GENRE
CROSS JOIN COUNTRY;

-- ============================================================================
-- D29: List all movies with their award information, keeping rows for movies that have never won.
-- Category: CN (Left Outer Join)
-- ============================================================================
-- RA: MOVIE !< AWARD
SELECT *
FROM movie m
LEFT JOIN award a ON m.movie_id = a.movie_id;

-- ============================================================================
-- D30: List all directors together with their movies, including directors who have no films yet.
-- Category: D1N (Left Outer Join)
-- ============================================================================
-- RA: DIRECTOR !< MOVIE
SELECT *
FROM director d
LEFT JOIN movie m ON d.director_id = m.director_id;

-- ============================================================================
-- D31: Show all movies and all awards including unmatched records from both sides using FULL OUTER JOIN.
-- Category: N (Full Outer Join)
-- ============================================================================
-- RA: MOVIE >!< AWARD
SELECT *
FROM movie m
FULL OUTER JOIN award a ON m.movie_id = a.movie_id;

-- ============================================================================
-- D32: Find directors with their average movie rating using a subquery in the FROM clause.
-- Category: I2 (Subquery in FROM)
-- ============================================================================
-- RA: DIRECTOR <* (aggregation subquery)
SELECT d.director_id, d.name, stats.avg_rating
FROM director d
JOIN (
    SELECT director_id, ROUND(AVG(imdb_rating), 2) AS avg_rating
    FROM movie
    GROUP BY director_id
) stats ON d.director_id = stats.director_id
ORDER BY stats.avg_rating DESC;

-- ============================================================================
-- D33: Display each movie with the count of its awards as a scalar subquery in SELECT clause.
-- Category: I1 (Scalar Subquery in SELECT)
-- ============================================================================
-- RA: MOVIE with scalar count subquery
SELECT m.movie_id, m.title,
    (SELECT COUNT(*) FROM award a WHERE a.movie_id = m.movie_id) AS award_count
FROM movie m
ORDER BY award_count DESC, m.movie_id;

-- ============================================================================
-- D34: Group movies by their release year to see which years have films.
-- Category: G3 (GROUP BY without aggregate - listing)
-- ============================================================================
-- RA: γ(year)(MOVIE)
SELECT year
FROM movie
GROUP BY year
ORDER BY year;

-- ============================================================================
-- D35: Count the number of movies released each year using GROUP BY with aggregate.
-- Category: G4 (GROUP BY with COUNT)
-- ============================================================================
-- RA: γ(year; COUNT(movie_id))(MOVIE)
SELECT year, COUNT(*) AS movie_count
FROM movie
GROUP BY year
ORDER BY year;

-- ============================================================================
-- D36: Calculate movie statistics: total count, average rating, highest rating, lowest rating, and total votes.
-- Category: G2 (Aggregate Functions)
-- ============================================================================
-- RA: γ(COUNT, AVG, MAX, MIN, SUM)(MOVIE)
SELECT
    COUNT(*) AS total_movies,
    ROUND(AVG(imdb_rating), 2) AS avg_rating,
    MAX(imdb_rating) AS highest_rating,
    MIN(imdb_rating) AS lowest_rating,
    SUM(imdb_votes) AS total_votes
FROM movie;

-- ============================================================================
-- D37: Order movies first by year descending, then by rating descending to find best recent films.
-- Category: ORDER BY
-- ============================================================================
-- RA: τ(year DESC, imdb_rating DESC)(MOVIE)
SELECT movie_id, title, year, imdb_rating
FROM movie
ORDER BY year DESC, imdb_rating DESC;

-- ============================================================================
-- D38: Categorize movies by their rating into quality tiers using CASE expression.
-- Category: CASE Expression
-- ============================================================================
-- RA: Extended with CASE
SELECT movie_id, title, imdb_rating,
    CASE
        WHEN imdb_rating >= 8.5 THEN 'Excellent'
        WHEN imdb_rating >= 7.5 THEN 'Good'
        WHEN imdb_rating >= 6.0 THEN 'Average'
        ELSE 'Below Average'
    END AS quality_tier
FROM movie
ORDER BY imdb_rating DESC;

-- ============================================================================
-- D39: Find movies whose title contains a specific word using string pattern matching with LIKE.
-- Category: String Functions (LIKE)
-- ============================================================================
-- RA: σ(title LIKE '%The%')(MOVIE)
SELECT movie_id, title, year
FROM movie
WHERE title LIKE '%The%'
ORDER BY title;

-- ============================================================================
-- D40: Calculate movie age and extract year components from release dates using date functions.
-- Category: Date Functions
-- ============================================================================
-- RA: Extended with date functions
SELECT movie_id, title, year, release_date,
    EXTRACT(YEAR FROM CURRENT_DATE) - year AS movie_age
FROM movie
ORDER BY movie_age DESC;

-- ============================================================================
-- D41: Query the high_rated_movies view to find critically acclaimed films with rating above 8.
-- Category: M (Query over View)
-- ============================================================================
-- Note: Requires view to be created first:
-- CREATE OR REPLACE VIEW high_rated_movies AS
-- SELECT movie_id, title, year, imdb_rating, director_id FROM movie WHERE imdb_rating > 7.5;

SELECT *
FROM high_rated_movies
WHERE imdb_rating > 8
ORDER BY imdb_rating DESC;

-- ==============================================================================
-- END OF PORTAL QUERIES
-- Total: 41 queries (D1-D41)
-- ==============================================================================
