-- ============================================================================
-- COMPLETE QUERY TEST FILE
-- Test ALL portal queries in DataGrip BEFORE updating the portal
-- Run these one section at a time (Ctrl+Enter on each query)
-- ============================================================================

-- ============================================================================
-- SECTION 1: BASIC QUERIES (Should all work)
-- ============================================================================

-- D1 - Basic SELECT
SELECT title, year FROM movie;
-- Expected: 15 rows

-- D2 - Simple projection
SELECT title FROM movie;
-- Expected: 15 rows

-- D3 - EXCEPT (movies without awards)
SELECT movie_id FROM movie
EXCEPT
SELECT movie_id FROM award;
-- Expected: 7 rows

-- D4 - Christopher Nolan movies
SELECT DISTINCT m.title
FROM movie m
JOIN director d ON m.director_id = d.director_id
WHERE d.name = 'Christopher Nolan';
-- Expected: 2 rows (Inception, The Dark Knight)

-- ============================================================================
-- SECTION 2: COMPLEX QUERIES (Division, Joins)
-- ============================================================================

-- D5 - Actors in every genre (DIVISION)
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
-- Expected: 0 rows (no actor in ALL 13 genres)

-- D7 - Movie titles with director names
SELECT m.title, d.name
FROM movie m
JOIN director d ON m.director_id = d.director_id
ORDER BY m.title;
-- Expected: 15 rows

-- D15 - Movies per studio (GROUP BY + HAVING)
SELECT studio_id, COUNT(*) as movie_cnt
FROM movie
WHERE year > 2000
GROUP BY studio_id
HAVING COUNT(*) >= 1
ORDER BY movie_cnt DESC;
-- Expected: 7 rows

-- D16 - INTERSECT
SELECT movie_id FROM movie
INTERSECT
SELECT movie_id FROM award;
-- Expected: 8 rows

-- D17 - Directors with no movies
SELECT director_id, name
FROM director
WHERE NOT EXISTS (
    SELECT 1 FROM movie WHERE movie.director_id = director.director_id
)
ORDER BY director_id;
-- Expected: 31 rows

-- D18 - Movies with at least one award
SELECT DISTINCT movie_id, title
FROM movie
WHERE EXISTS (
    SELECT 1 FROM award WHERE award.movie_id = movie.movie_id
);
-- Expected: 8 rows

-- ============================================================================
-- SECTION 3: MISSING CATEGORIES - TEST THESE!
-- ============================================================================

-- F2 - NATURAL JOIN (D23)
SELECT studio_id, studio_name, founded_year, country_id, created_at
FROM studio
NATURAL JOIN country;
-- Expected: 10 rows

-- F3 - CROSS JOIN (D25)
SELECT g.genre_id, g.genre_name, c.country_id, c.country_name, c.country_code
FROM genre g
CROSS JOIN country c
ORDER BY g.genre_name, c.country_name;
-- Expected: 65 rows (13 × 5)

-- J - Three ways to get award-winning movies

-- D20 - EXISTS version
SELECT movie_id, title
FROM movie m
WHERE EXISTS (SELECT 1 FROM award a WHERE a.movie_id = m.movie_id);
-- Expected: 8 rows

-- D21 - IN version
SELECT movie_id, title
FROM movie
WHERE movie_id IN (SELECT movie_id FROM award);
-- Expected: 8 rows

-- D22 - JOIN version
SELECT DISTINCT m.movie_id, m.title
FROM movie m
JOIN award a ON m.movie_id = a.movie_id;
-- Expected: 8 rows

-- L - VIEW query (D36)
SELECT * FROM high_rated_movies
WHERE imdb_rating >= 8.0
ORDER BY imdb_rating DESC;
-- Expected: 11 rows

-- ============================================================================
-- SECTION 4: BROKEN QUERIES - FIXED VERSIONS
-- ============================================================================

-- D42 - Movie award counts (FIXED with subquery in SELECT)
SELECT m.movie_id, m.title,
       (SELECT COUNT(*) FROM award a WHERE a.movie_id = m.movie_id) as award_count
FROM movie m
ORDER BY award_count DESC, m.title;
-- Expected: 15 rows (counts from 0 to multiple)

-- D43 - Show titles three ways (FIXED with proper UNION)
SELECT title FROM movie WHERE year < 2000
UNION
SELECT title FROM movie WHERE year BETWEEN 2000 AND 2010
UNION
SELECT title FROM movie WHERE year > 2010;
-- Expected: 15 unique titles

-- D44 - Genres with >2 movies (FIXED with proper JOINs)
SELECT g.genre_name, 
       COUNT(mg.movie_id) as movie_count,
       ROUND(AVG(m.imdb_rating), 2) as avg_rating
FROM genre g
JOIN movie_genre mg ON g.genre_id = mg.genre_id
JOIN movie m ON mg.movie_id = m.movie_id
GROUP BY g.genre_name
HAVING COUNT(mg.movie_id) > 2
ORDER BY movie_count DESC;
-- Expected: 3-4 rows (Drama, Action, etc.)

-- D47 - UPDATE award-winning movies (TEST SAFELY FIRST!)
-- DON'T RUN THE UPDATE YET! First see what will be updated:
SELECT movie_id, title, imdb_rating, 
       imdb_rating + 0.1 as new_rating
FROM movie
WHERE movie_id IN (SELECT DISTINCT movie_id FROM award);
-- Expected: 8 rows showing current and new ratings

-- If the above looks good, run the actual UPDATE:
-- UPDATE movie
-- SET imdb_rating = imdb_rating + 0.1
-- WHERE movie_id IN (SELECT DISTINCT movie_id FROM award);

-- D48 - DELETE orphaned ratings (TEST SAFELY FIRST!)
-- Check what would be deleted (should be 0 rows):
SELECT * FROM user_rating
WHERE movie_id NOT IN (SELECT movie_id FROM movie);
-- Expected: 0 rows (no orphans)

-- If there are orphans, run the DELETE:
-- DELETE FROM user_rating
-- WHERE movie_id NOT IN (SELECT movie_id FROM movie);

-- D49 - INSERT Critic Choice awards (TEST SAFELY FIRST!)
-- See what will be inserted:
SELECT movie_id, title, imdb_rating
FROM movie
WHERE imdb_rating > 9.0;
-- Expected: 5 movies (Dark Knight 9.5, Pulp Fiction 9.4, Inception 9.3, LOTR 9.3, Gladiator 9.0)

-- If the above looks good, run the INSERT:
-- INSERT INTO award (award_name, category, year_awarded, movie_id, is_winner)
-- SELECT 'Critic Choice', 'Excellence', 2026, movie_id, TRUE
-- FROM movie
-- WHERE imdb_rating > 9.0;

-- ============================================================================
-- SECTION 5: ADDITIONAL PORTAL QUERIES
-- ============================================================================

-- D23 - Studios with country
SELECT * FROM studio ORDER BY studio_id;
-- Expected: 10 rows

-- D24 - LEFT OUTER JOIN with UNION (movie + award info)
SELECT m.title, a.award_name
FROM movie m
LEFT JOIN award a ON m.movie_id = a.movie_id
UNION
SELECT m.title, a.award_name
FROM movie m
RIGHT JOIN award a ON m.movie_id = a.movie_id;
-- Expected: 16 rows

-- D26 - Directors with movies (LEFT JOIN)
SELECT d.name, m.title
FROM director d
LEFT JOIN movie m ON d.director_id = m.director_id
ORDER BY d.name;
-- Expected: 46 rows (14 with movies, 31 with NULL titles)

-- D27 - FULL OUTER JOIN (movies and awards)
SELECT m.title, a.award_name
FROM movie m
FULL OUTER JOIN award a ON m.movie_id = a.movie_id;
-- Expected: 52 rows (all movies + all awards, including unmatched)

-- D28 - Directors with average ratings
SELECT d.name, ROUND(AVG(m.imdb_rating), 2) as avg_r
FROM director d
JOIN movie m ON d.director_id = m.director_id
GROUP BY d.name
ORDER BY avg_r DESC;
-- Expected: 14 rows

-- D32 - Nested subquery in SELECT (movie with award count)
SELECT m.movie_id, m.title,
       (SELECT COUNT(*) FROM award a WHERE a.movie_id = m.movie_id) as aw_count
FROM movie m
ORDER BY m.year DESC, m.imdb_rating DESC;
-- Expected: 15 rows

-- D37 - Same as D32 (award counts)
SELECT m.movie_id, m.title,
       (SELECT COUNT(*) FROM award a WHERE a.movie_id = m.movie_id) as aw_count
FROM movie m
ORDER BY aw_count DESC;
-- Expected: 15 rows

-- ============================================================================
-- SECTION 6: VERIFICATION QUERIES
-- ============================================================================

-- Count check
SELECT 
    (SELECT COUNT(*) FROM country) as countries,
    (SELECT COUNT(*) FROM genre) as genres,
    (SELECT COUNT(*) FROM studio) as studios,
    (SELECT COUNT(*) FROM director) as directors,
    (SELECT COUNT(*) FROM actor) as actors,
    (SELECT COUNT(*) FROM movie) as movies,
    (SELECT COUNT(*) FROM award) as awards,
    (SELECT COUNT(*) FROM movie_actor) as movie_actors,
    (SELECT COUNT(*) FROM movie_genre) as movie_genres,
    (SELECT COUNT(*) FROM user_rating) as ratings;
-- Expected: 5, 13, 10, 45, 10, 15, 38, 10, 15, 45

-- Check for high-rated movies
SELECT COUNT(*) as high_rated_count 
FROM high_rated_movies;
-- Expected: 11 rows

-- View details
SELECT * FROM high_rated_movies 
ORDER BY imdb_rating DESC;
-- Expected: 11 movies rated >= 8.0

-- ============================================================================
-- TESTING COMPLETE!
-- If all queries above return expected results, you're ready for the portal!
-- ============================================================================
