"""
Database Verification Script
Verify your Movie Database on db.kii.pef.czu.cz

Student: xkonj108
"""

import psycopg2
import getpass

def main():
    print("=" * 60)
    print("DATABASE VERIFICATION - db.kii.pef.czu.cz")
    print("=" * 60)

    # Connection details
    host = "db.kii.pef.czu.cz"
    database = "xozte001"
    user = "xozte001"
    port = 5432

    print(f"Host: {host}")
    print(f"Database: {database}")
    print(f"User: {user}")
    print()

    # Get password
    password = getpass.getpass("Enter your database password: ")

    try:
        # Connect
        print("\nConnecting...")
        conn = psycopg2.connect(
            host=host,
            database=database,
            user=user,
            password=password,
            port=port
        )
        print("✓ Connected successfully!\n")

        cursor = conn.cursor()

        # 1. Check PostgreSQL version
        cursor.execute("SELECT version();")
        version = cursor.fetchone()[0]
        print(f"PostgreSQL: {version[:60]}...\n")

        # 2. List all tables
        print("=" * 60)
        print("TABLES IN YOUR DATABASE:")
        print("=" * 60)
        cursor.execute("""
            SELECT table_name
            FROM information_schema.tables
            WHERE table_schema = 'public'
            ORDER BY table_name;
        """)
        tables = cursor.fetchall()

        expected_tables = [
            'actor', 'award', 'country', 'director', 'genre',
            'movie', 'movie_actor', 'movie_country', 'movie_genre',
            'studio', 'user_rating'
        ]

        found_tables = [t[0] for t in tables]

        for table in expected_tables:
            status = "✓" if table in found_tables else "✗ MISSING"
            print(f"  {status} {table}")

        print(f"\nFound {len(found_tables)}/11 expected tables")

        # 3. Count records in each table
        print("\n" + "=" * 60)
        print("RECORD COUNTS:")
        print("=" * 60)

        for table in expected_tables:
            if table in found_tables:
                cursor.execute(f"SELECT COUNT(*) FROM {table}")
                count = cursor.fetchone()[0]
                print(f"  {table:20}: {count:5} records")
            else:
                print(f"  {table:20}: TABLE NOT FOUND")

        # 4. Sample data verification
        print("\n" + "=" * 60)
        print("SAMPLE DATA VERIFICATION:")
        print("=" * 60)

        # Check for Guardians of the Galaxy Vol. 2 (from OMDb API)
        if 'movie' in found_tables:
            cursor.execute("""
                SELECT title, year, imdb_id, imdb_rating
                FROM movie
                WHERE imdb_id = 'tt3896198'
            """)
            gotg = cursor.fetchone()
            if gotg:
                print(f"\n✓ Found OMDb movie: {gotg[0]} ({gotg[1]})")
                print(f"  IMDb ID: {gotg[2]}, Rating: {gotg[3]}")
            else:
                print("\n✗ Guardians of the Galaxy Vol. 2 not found")

            # Top 5 movies
            print("\nTop 5 movies by rating:")
            cursor.execute("""
                SELECT title, imdb_rating
                FROM movie
                ORDER BY imdb_rating DESC
                LIMIT 5
            """)
            for row in cursor.fetchall():
                print(f"  • {row[0]}: {row[1]}")

        # 5. Test a JOIN query
        print("\n" + "=" * 60)
        print("JOIN QUERY TEST:")
        print("=" * 60)

        if 'movie' in found_tables and 'director' in found_tables:
            cursor.execute("""
                SELECT m.title, d.name as director
                FROM movie m
                JOIN director d ON m.director_id = d.director_id
                LIMIT 5
            """)
            print("\nMovies with Directors:")
            for row in cursor.fetchall():
                print(f"  • {row[0]} - by {row[1]}")

        # 6. Foreign key verification
        print("\n" + "=" * 60)
        print("FOREIGN KEY CONSTRAINTS:")
        print("=" * 60)

        cursor.execute("""
            SELECT
                tc.constraint_name,
                tc.table_name,
                kcu.column_name,
                ccu.table_name AS foreign_table_name
            FROM information_schema.table_constraints AS tc
            JOIN information_schema.key_column_usage AS kcu
              ON tc.constraint_name = kcu.constraint_name
            JOIN information_schema.constraint_column_usage AS ccu
              ON ccu.constraint_name = tc.constraint_name
            WHERE tc.constraint_type = 'FOREIGN KEY'
            ORDER BY tc.table_name;
        """)
        fks = cursor.fetchall()
        print(f"\nFound {len(fks)} foreign key constraints:")
        for fk in fks[:10]:  # Show first 10
            print(f"  • {fk[1]}.{fk[2]} -> {fk[3]}")
        if len(fks) > 10:
            print(f"  ... and {len(fks) - 10} more")

        conn.close()

        print("\n" + "=" * 60)
        print("✓ VERIFICATION COMPLETE")
        print("=" * 60)

    except psycopg2.OperationalError as e:
        print(f"\n✗ Connection failed: {e}")
        print("\nTips:")
        print("  1. Check your password")
        print("  2. Make sure you're on the university network or VPN")
        print("  3. Verify the server is accessible")
    except psycopg2.Error as e:
        print(f"\n✗ Database error: {e}")
    except Exception as e:
        print(f"\n✗ Error: {e}")

if __name__ == "__main__":
    main()
