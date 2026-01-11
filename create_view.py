"""
Create the high_rated_movies view for D41 query
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

# Create the view for D41
print("Creating high_rated_movies view...")
cur.execute('DROP VIEW IF EXISTS high_rated_movies')
cur.execute('''
CREATE VIEW high_rated_movies AS
SELECT movie_id, title, year, imdb_rating, director_id
FROM movie
WHERE imdb_rating > 7.5
''')
conn.commit()

# Verify
cur.execute('SELECT * FROM high_rated_movies ORDER BY imdb_rating DESC LIMIT 5')
rows = cur.fetchall()
print('View created successfully!')
print('Sample data from high_rated_movies:')
for row in rows:
    print(f'  {row[1]} ({row[2]}) - Rating: {row[3]}')

conn.close()
print("\nDone! D41 query will now work in the portal.")
