"""
RA vs SQL Verification Script
Executes all D1-D30 SQL queries and shows results to verify RA matching
"""

import psycopg2
import getpass

DB_CONFIG = {
    'host': 'db.kii.pef.czu.cz',
    'database': 'xozte001',
    'user': 'xozte001',
    'port': 5432
}

# All queries from D1-D30
QUERIES = {
    "D1": {
        "desc": "Projection - movie title and year",
        "ra": "MOVIE[title, year]",
        "sql": "SELECT title, year FROM movie;"
    },
    "D2": {
        "desc": "Projection - actor name and birth_year",
        "ra": "ACTOR[name, birth_year]",
        "sql": "SELECT name, birth_year FROM actor;"
    },
    "D3": {
        "desc": "Selection - movies after 2010",
        "ra": "MOVIE(year > 2010)",
        "sql": "SELECT * FROM movie WHERE year > 2010;"
    },
    "D4": {
        "desc": "Selection - movies rating > 8.5",
        "ra": "MOVIE(imdb_rating > 8.5)",
        "sql": "SELECT * FROM movie WHERE imdb_rating > 8.5;"
    },
    "D5": {
        "desc": "LEFT JOIN movie-award",
        "ra": "MOVIE !< AWARD",
        "sql": "SELECT m.movie_id, m.title, m.year, a.award_name, a.is_winner FROM movie m LEFT JOIN award a ON m.movie_id = a.movie_id;"
    },
    "D6": {
        "desc": "LEFT JOIN director-movie",
        "ra": "DIRECTOR !< MOVIE",
        "sql": "SELECT d.director_id, d.name, m.movie_id, m.title FROM director d LEFT JOIN movie m ON d.director_id = m.director_id;"
    },
    "D7": {
        "desc": "LEFT JOIN genre-movie_genre-movie",
        "ra": "(GENRE !< MOVIE_GENRE) !< MOVIE",
        "sql": "SELECT g.genre_id, g.genre_name, m.movie_id, m.title FROM genre g LEFT JOIN movie_genre mg ON g.genre_id = mg.genre_id LEFT JOIN movie m ON mg.movie_id = m.movie_id;"
    },
    "D8": {
        "desc": "LEFT JOIN actor-movie_actor",
        "ra": "ACTOR !< MOVIE_ACTOR",
        "sql": "SELECT a.actor_id, a.name, ma.movie_id, ma.role_type FROM actor a LEFT JOIN movie_actor ma ON a.actor_id = ma.actor_id;"
    },
    "D9": {
        "desc": "Natural join movie-director",
        "ra": "MOVIE <* DIRECTOR",
        "sql": "SELECT * FROM movie m JOIN director d ON m.director_id = d.director_id;"
    },
    "D10": {
        "desc": "3-table join movie-movie_actor-actor",
        "ra": "(MOVIE <* MOVIE_ACTOR) <* ACTOR",
        "sql": "SELECT * FROM movie m JOIN movie_actor ma ON m.movie_id = ma.movie_id JOIN actor a ON ma.actor_id = a.actor_id;"
    },
    "D11": {
        "desc": "Join + Selection",
        "ra": "(MOVIE <* DIRECTOR)(year > 2015)",
        "sql": "SELECT * FROM movie m JOIN director d ON m.director_id = d.director_id WHERE m.year > 2015;"
    },
    "D12": {
        "desc": "Join + Projection",
        "ra": "(MOVIE <* DIRECTOR)[title, name]",
        "sql": "SELECT m.title, d.name FROM movie m JOIN director d ON m.director_id = d.director_id;"
    },
    "D13": {
        "desc": "Join + Selection + Projection",
        "ra": "((MOVIE(imdb_rating > 8.5)) <* DIRECTOR)[title, name]",
        "sql": "SELECT m.title, d.name FROM movie m JOIN director d ON m.director_id = d.director_id WHERE m.imdb_rating > 8.5;"
    },
    "D14": {
        "desc": "Join + Aggregation (AVG)",
        "ra": "(MOVIE <* DIRECTOR)[director_id, name, imdb_rating]",
        "sql": "SELECT d.director_id, d.name, ROUND(AVG(m.imdb_rating), 2) AS avg_rating FROM movie m JOIN director d ON m.director_id = d.director_id GROUP BY d.director_id, d.name;"
    },
    "D15": {
        "desc": "Join + GROUP BY (COUNT)",
        "ra": "(MOVIE_GENRE <* GENRE)[genre_id, genre_name, movie_id]",
        "sql": "SELECT g.genre_id, g.genre_name, COUNT(mg.movie_id) AS movie_count FROM genre g JOIN movie_genre mg ON g.genre_id = mg.genre_id GROUP BY g.genre_id, g.genre_name;"
    },
    "D16": {
        "desc": "COUNT all movies",
        "ra": "MOVIE[movie_id]",
        "sql": "SELECT COUNT(*) AS total_movies FROM movie;"
    },
    "D17": {
        "desc": "AVG, MIN, MAX",
        "ra": "MOVIE[imdb_rating]",
        "sql": "SELECT ROUND(AVG(imdb_rating), 2) AS avg_rating, MIN(imdb_rating) AS min_rating, MAX(imdb_rating) AS max_rating FROM movie;"
    },
    "D18": {
        "desc": "GROUP BY director",
        "ra": "MOVIE[director_id, movie_id]",
        "sql": "SELECT director_id, COUNT(movie_id) AS movie_count FROM movie GROUP BY director_id;"
    },
    "D19": {
        "desc": "GROUP BY + HAVING",
        "ra": "MOVIE[director_id, movie_id]",
        "sql": "SELECT director_id, COUNT(movie_id) AS movie_count FROM movie GROUP BY director_id HAVING COUNT(movie_id) > 1;"
    },
    "D20": {
        "desc": "UNION",
        "ra": "DIRECTOR[name] ∪ ACTOR[name]",
        "sql": "SELECT name FROM director UNION SELECT name FROM actor;"
    },
    "D21": {
        "desc": "INTERSECT - Action AND Sci-Fi",
        "ra": "((MOVIE_GENRE <* GENRE(genre_name = \"Action\"))[movie_id]) ∩ ((MOVIE_GENRE <* GENRE(genre_name = \"Sci-Fi\"))[movie_id])",
        "sql": "SELECT movie_id FROM movie_genre JOIN genre USING (genre_id) WHERE genre_name = 'Action' INTERSECT SELECT movie_id FROM movie_genre JOIN genre USING (genre_id) WHERE genre_name = 'Sci-Fi';"
    },
    "D22": {
        "desc": "EXCEPT/DIFFERENCE",
        "ra": "DIRECTOR[director_id] \\ MOVIE[director_id]",
        "sql": "SELECT director_id FROM director EXCEPT SELECT director_id FROM movie;"
    },
    "D23": {
        "desc": "EXISTS subquery",
        "ra": "MOVIE <* AWARD[movie_id]",
        "sql": "SELECT DISTINCT m.* FROM movie m WHERE EXISTS (SELECT 1 FROM award a WHERE a.movie_id = m.movie_id);"
    },
    "D24": {
        "desc": "Scalar subquery",
        "ra": "MOVIE[title, movie_id]",
        "sql": "SELECT m.title, (SELECT COUNT(*) FROM movie_actor ma WHERE ma.movie_id = m.movie_id) AS actor_count FROM movie m;"
    },
    "D25": {
        "desc": "Correlated subquery",
        "ra": "MOVIE(imdb_rating > 8.0)",
        "sql": "SELECT * FROM movie m1 WHERE imdb_rating > (SELECT AVG(imdb_rating) FROM movie m2 WHERE m2.year = m1.year);"
    },
    "D26": {
        "desc": "ORDER BY",
        "ra": "MOVIE",
        "sql": "SELECT * FROM movie ORDER BY imdb_rating DESC;"
    },
    "D27": {
        "desc": "DISTINCT",
        "ra": "MOVIE[year]",
        "sql": "SELECT DISTINCT year FROM movie ORDER BY year;"
    },
    "D28": {
        "desc": "Self-join sequel",
        "ra": "MOVIE <* MOVIE",
        "sql": "SELECT m1.title AS sequel_title, m2.title AS original_title FROM movie m1 JOIN movie m2 ON m1.sequel_of = m2.movie_id;"
    },
    "D29": {
        "desc": "Rename/Alias",
        "ra": "MOVIE[title, year, imdb_rating]",
        "sql": "SELECT title AS film_title, year AS release_year, imdb_rating AS rating FROM movie;"
    },
    "D30": {
        "desc": "Cartesian Product",
        "ra": "GENRE × COUNTRY",
        "sql": "SELECT g.genre_name, c.country_name FROM genre g CROSS JOIN country c;"
    }
}

def main():
    password = getpass.getpass("Enter database password for xozte001: ")

    try:
        conn = psycopg2.connect(
            host=DB_CONFIG['host'],
            database=DB_CONFIG['database'],
            user=DB_CONFIG['user'],
            password=password,
            port=DB_CONFIG['port']
        )
        print("✓ Connected to database successfully!\n")

        cursor = conn.cursor()

        print("="*80)
        print("SQL QUERY EXECUTION RESULTS - D1 to D30")
        print("="*80)

        for query_id in sorted(QUERIES.keys(), key=lambda x: int(x[1:])):
            q = QUERIES[query_id]
            print(f"\n{'='*80}")
            print(f"{query_id}: {q['desc']}")
            print(f"{'='*80}")
            print(f"RA:  {q['ra']}")
            print(f"SQL: {q['sql'][:100]}...")

            try:
                cursor.execute(q['sql'])
                rows = cursor.fetchall()
                cols = [desc[0] for desc in cursor.description]

                print(f"\nColumns: {cols}")
                print(f"Row count: {len(rows)}")

                # Show first 5 rows
                print("Sample data (first 5 rows):")
                for i, row in enumerate(rows[:5]):
                    print(f"  {i+1}. {row}")
                if len(rows) > 5:
                    print(f"  ... and {len(rows) - 5} more rows")

                print(f"\n✓ {query_id} executed successfully")

            except Exception as e:
                print(f"\n✗ {query_id} ERROR: {e}")

        cursor.close()
        conn.close()
        print("\n" + "="*80)
        print("All queries executed. Review results above.")
        print("="*80)

    except Exception as e:
        print(f"Connection error: {e}")

if __name__ == "__main__":
    main()
