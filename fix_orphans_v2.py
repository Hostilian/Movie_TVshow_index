"""Fix orphan actors by linking them to movies - v2"""
import psycopg2

conn = psycopg2.connect(
    host='db.kii.pef.czu.cz',
    database='xozte001',
    user='xozte001',
    password='JQyZfI',
    port=5432
)
cur = conn.cursor()

# Find orphan actors
cur.execute('''
    SELECT a.actor_id, a.name
    FROM actor a
    WHERE NOT EXISTS (SELECT 1 FROM movie_actor ma WHERE ma.actor_id = a.actor_id)
''')
orphans = cur.fetchall()

print(f"Found {len(orphans)} orphan actors:")
for aid, name in orphans:
    print(f"  ID {aid}: {name}")

if orphans:
    # Get movies to assign
    cur.execute('SELECT movie_id, title FROM movie ORDER BY movie_id LIMIT 5')
    movies = cur.fetchall()

    print(f"\nAssigning to movies...")
    for i, (aid, name) in enumerate(orphans):
        mid = movies[i % len(movies)][0]
        mtitle = movies[i % len(movies)][1]
        cur.execute(
            'INSERT INTO movie_actor (movie_id, actor_id, role_type) VALUES (%s, %s, %s)',
            (mid, aid, 'supporting')
        )
        print(f"  ✅ Added {name} to '{mtitle}'")

    conn.commit()
    print("\n✅ Changes committed!")

# Verify
cur.execute('''
    SELECT COUNT(*) FROM actor a
    WHERE NOT EXISTS (SELECT 1 FROM movie_actor ma WHERE ma.actor_id = a.actor_id)
''')
remaining = cur.fetchone()[0]
print(f"\nRemaining orphan actors: {remaining}")

# Show new movie_actor count
cur.execute('SELECT COUNT(*) FROM movie_actor')
total = cur.fetchone()[0]
print(f"Total movie_actor records: {total}")

conn.close()
