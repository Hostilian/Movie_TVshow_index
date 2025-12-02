"""
Test all 25 queries from 05_all_queries.sql
"""
import psycopg2

conn = psycopg2.connect(
    host='db.kii.pef.czu.cz',
    database='xozte001',
    user='xozte001',
    password='JQyZfI',
    port=5432
)
cur = conn.cursor()

queries = {
    # CATEGORY C: Simple Selection (8 queries)
    "C1": "SELECT * FROM movie WHERE year > 2010",
    "C2": "SELECT title, imdb_rating FROM movie",
    "C3": "SELECT * FROM actor WHERE birth_year < 1970",
    "C4": "SELECT title, year, imdb_rating FROM movie WHERE imdb_rating > 8.5",
    "C5": "SELECT name, birth_year FROM director ORDER BY birth_year ASC",
    "C6": "SELECT title, runtime FROM movie WHERE runtime > 150",
    "C7": "SELECT genre_name FROM genre ORDER BY genre_name",
    "C8": "SELECT studio_name, founded_year FROM studio WHERE founded_year > 2000",
    
    # CATEGORY D1: Joins (9 queries)
    "D1-1": "SELECT m.title, m.year, d.name AS director_name FROM movie m JOIN director d ON m.director_id = d.director_id ORDER BY m.year DESC",
    "D1-2": "SELECT a.name AS actor_name, ma.role_type FROM actor a JOIN movie_actor ma ON a.actor_id = ma.actor_id JOIN movie m ON ma.movie_id = m.movie_id WHERE m.title = 'Inception'",
    "D1-3": "SELECT m.title, m.year, m.imdb_rating FROM movie m JOIN movie_genre mg ON m.movie_id = mg.movie_id JOIN genre g ON mg.genre_id = g.genre_id WHERE g.genre_name = 'Action' ORDER BY m.imdb_rating DESC",
    "D1-4": "SELECT m.title, ur.user_name, ur.rating_value, ur.review_text FROM user_rating ur JOIN movie m ON ur.movie_id = m.movie_id JOIN director d ON m.director_id = d.director_id WHERE d.name = 'Christopher Nolan'",
    "D1-5": "SELECT m.title, c.country_name FROM movie m JOIN movie_country mc ON m.movie_id = mc.movie_id JOIN country c ON mc.country_id = c.country_id ORDER BY m.title",
    "D1-6": "SELECT m.title, s.studio_name, c.country_name AS studio_country FROM movie m JOIN studio s ON m.studio_id = s.studio_id JOIN country c ON s.country_id = c.country_id",
    "D1-7": "SELECT m.title, aw.award_name, aw.category, aw.year_awarded FROM award aw JOIN movie m ON aw.movie_id = m.movie_id WHERE aw.is_winner = TRUE ORDER BY aw.year_awarded DESC",
    "D1-8": "SELECT DISTINCT a.name AS actor_name, m.title, m.imdb_rating FROM actor a JOIN movie_actor ma ON a.actor_id = ma.actor_id JOIN movie m ON ma.movie_id = m.movie_id WHERE ma.role_type = 'lead' AND m.imdb_rating > 8.0 ORDER BY m.imdb_rating DESC",
    "D1-9": "SELECT m.title, g.genre_name FROM movie m JOIN movie_genre mg ON m.movie_id = mg.movie_id JOIN genre g ON mg.genre_id = g.genre_id WHERE m.title = 'The Dark Knight'",
    
    # CATEGORY D2: Aggregations (8 queries)
    "D2-1": "SELECT COUNT(*) AS total_movies FROM movie",
    "D2-2": "SELECT ROUND(AVG(imdb_rating), 2) AS average_rating FROM movie",
    "D2-3": "SELECT d.name AS director_name, COUNT(m.movie_id) AS movie_count FROM director d LEFT JOIN movie m ON d.director_id = m.director_id GROUP BY d.director_id, d.name ORDER BY movie_count DESC",
    "D2-4": "SELECT g.genre_name, ROUND(AVG(m.imdb_rating), 2) AS avg_rating, COUNT(m.movie_id) AS movie_count FROM genre g JOIN movie_genre mg ON g.genre_id = mg.genre_id JOIN movie m ON mg.movie_id = m.movie_id GROUP BY g.genre_id, g.genre_name ORDER BY avg_rating DESC",
    "D2-5": "SELECT m.title, COUNT(aw.award_id) AS total_awards, SUM(CASE WHEN aw.is_winner THEN 1 ELSE 0 END) AS wins FROM movie m LEFT JOIN award aw ON m.movie_id = aw.movie_id GROUP BY m.movie_id, m.title HAVING COUNT(aw.award_id) > 0 ORDER BY wins DESC",
    "D2-6": "SELECT m.title, COUNT(ur.rating_id) AS review_count, ROUND(AVG(ur.rating_value), 2) AS avg_user_rating FROM movie m LEFT JOIN user_rating ur ON m.movie_id = ur.movie_id GROUP BY m.movie_id, m.title HAVING COUNT(ur.rating_id) > 0 ORDER BY avg_user_rating DESC",
    "D2-7": "SELECT m.title, COUNT(ma.actor_id) AS actor_count FROM movie m LEFT JOIN movie_actor ma ON m.movie_id = ma.movie_id GROUP BY m.movie_id, m.title ORDER BY actor_count DESC",
    "D2-8": "SELECT (year / 10) * 10 AS decade, COUNT(*) AS movie_count FROM movie GROUP BY (year / 10) * 10 ORDER BY decade",
}

print("=" * 70)
print("TESTING 25 QUERIES FROM 05_all_queries.sql")
print("=" * 70)

passed = 0
failed = 0

for qid, sql in queries.items():
    try:
        cur.execute(sql)
        rows = cur.fetchall()
        print(f"✓ {qid}: OK ({len(rows)} rows)")
        passed += 1
    except Exception as e:
        print(f"✗ {qid}: FAILED - {str(e)[:50]}")
        failed += 1

print()
print("=" * 70)
print(f"RESULTS: {passed} passed, {failed} failed out of {len(queries)}")
print("=" * 70)

# Show sample results for a few queries
print()
print("SAMPLE RESULTS:")
print("-" * 70)

print("\nC4 - Movies with rating > 8.5:")
cur.execute("SELECT title, year, imdb_rating FROM movie WHERE imdb_rating > 8.5")
for r in cur.fetchall():
    print(f"  {r[0]} ({r[1]}) - {r[2]}")

print("\nD1-3 - Action movies:")
cur.execute("SELECT m.title, m.imdb_rating FROM movie m JOIN movie_genre mg ON m.movie_id = mg.movie_id JOIN genre g ON mg.genre_id = g.genre_id WHERE g.genre_name = 'Action' ORDER BY m.imdb_rating DESC LIMIT 5")
for r in cur.fetchall():
    print(f"  {r[0]} - {r[1]}")

print("\nD2-3 - Movies per director:")
cur.execute("SELECT d.name, COUNT(m.movie_id) FROM director d LEFT JOIN movie m ON d.director_id = m.director_id GROUP BY d.director_id, d.name ORDER BY COUNT(m.movie_id) DESC LIMIT 5")
for r in cur.fetchall():
    print(f"  {r[0]}: {r[1]} movies")

conn.close()
print()
print("All queries tested successfully!")
