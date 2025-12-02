"""
Database Setup Script - Run DDL and DML on PostgreSQL
Student: Ozturk Eren (xkonj108)
Database: xkonj108 @ db.kii.pef.czu.cz
"""

import psycopg2
from psycopg2 import sql
import os

# Database connection parameters
DB_CONFIG = {
    'host': 'db.kii.pef.czu.cz',
    'database': 'xozte001',
    'user': 'xozte001',
    'password': None,  # Will prompt for password
    'port': 5432
}

def get_password():
    """Get password from user input"""
    import getpass
    return getpass.getpass("Enter database password for xkonj108: ")

def read_sql_file(filepath):
    """Read SQL file content"""
    with open(filepath, 'r', encoding='utf-8') as f:
        return f.read()

def execute_sql_script(conn, script_content, script_name):
    """Execute a SQL script"""
    print(f"\n{'='*60}")
    print(f"Executing: {script_name}")
    print('='*60)

    cursor = conn.cursor()
    try:
        cursor.execute(script_content)
        conn.commit()
        print(f"✓ {script_name} executed successfully!")
        return True
    except psycopg2.Error as e:
        conn.rollback()
        print(f"✗ Error executing {script_name}:")
        print(f"  {e}")
        return False
    finally:
        cursor.close()

def test_connection(conn):
    """Test database connection"""
    cursor = conn.cursor()
    cursor.execute("SELECT version();")
    version = cursor.fetchone()[0]
    print(f"Connected to: {version[:50]}...")
    cursor.close()

def verify_tables(conn):
    """Verify all tables were created"""
    cursor = conn.cursor()
    cursor.execute("""
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = 'public'
        ORDER BY table_name;
    """)
    tables = cursor.fetchall()
    print(f"\n{'='*60}")
    print("Tables in database:")
    print('='*60)
    for table in tables:
        print(f"  • {table[0]}")
    print(f"\nTotal tables: {len(tables)}")
    cursor.close()
    return len(tables)

def count_records(conn):
    """Count records in each table"""
    tables = ['director', 'actor', 'genre', 'country', 'studio',
              'movie', 'movie_actor', 'movie_genre', 'movie_country',
              'user_rating', 'award']

    cursor = conn.cursor()
    print(f"\n{'='*60}")
    print("Record counts:")
    print('='*60)

    for table in tables:
        try:
            cursor.execute(sql.SQL("SELECT COUNT(*) FROM {}").format(sql.Identifier(table)))
            count = cursor.fetchone()[0]
            print(f"  {table:20} : {count:5} records")
        except psycopg2.Error:
            print(f"  {table:20} : (table not found)")

    cursor.close()

def run_sample_queries(conn):
    """Run a few sample queries to verify data"""
    cursor = conn.cursor()

    print(f"\n{'='*60}")
    print("Sample Query Results:")
    print('='*60)

    # Query 1: Top 5 movies by rating
    print("\n1. Top 5 movies by IMDb rating:")
    cursor.execute("""
        SELECT title, year, imdb_rating
        FROM movie
        ORDER BY imdb_rating DESC
        LIMIT 5;
    """)
    for row in cursor.fetchall():
        print(f"   {row[0]} ({row[1]}) - Rating: {row[2]}")

    # Query 2: Movies with directors
    print("\n2. Sample movies with their directors:")
    cursor.execute("""
        SELECT m.title, d.name as director
        FROM movie m
        JOIN director d ON m.director_id = d.director_id
        LIMIT 5;
    """)
    for row in cursor.fetchall():
        print(f"   {row[0]} - directed by {row[1]}")

    # Query 3: Genre counts
    print("\n3. Movies per genre:")
    cursor.execute("""
        SELECT g.genre_name, COUNT(mg.movie_id) as count
        FROM genre g
        LEFT JOIN movie_genre mg ON g.genre_id = mg.genre_id
        GROUP BY g.genre_id, g.genre_name
        ORDER BY count DESC
        LIMIT 5;
    """)
    for row in cursor.fetchall():
        print(f"   {row[0]}: {row[1]} movies")

    cursor.close()

def main():
    # Get script directory
    script_dir = os.path.dirname(os.path.abspath(__file__))

    # File paths
    ddl_file = os.path.join(script_dir, '03_create_script.sql')
    dml_file = os.path.join(script_dir, '04_insert_script.sql')

    # Check files exist
    if not os.path.exists(ddl_file):
        print(f"Error: DDL file not found: {ddl_file}")
        return
    if not os.path.exists(dml_file):
        print(f"Error: DML file not found: {dml_file}")
        return

    print("="*60)
    print("Movie Database Setup Script")
    print("="*60)
    print(f"Host: {DB_CONFIG['host']}")
    print(f"Database: {DB_CONFIG['database']}")
    print(f"User: {DB_CONFIG['user']}")

    # Get password
    DB_CONFIG['password'] = get_password()

    try:
        # Connect to database
        print("\nConnecting to database...")
        conn = psycopg2.connect(**DB_CONFIG)
        test_connection(conn)

        # Read SQL files
        ddl_content = read_sql_file(ddl_file)
        dml_content = read_sql_file(dml_file)

        # Execute DDL (Create tables)
        ddl_success = execute_sql_script(conn, ddl_content, "DDL (Create Script)")

        if ddl_success:
            # Execute DML (Insert data)
            dml_success = execute_sql_script(conn, dml_content, "DML (Insert Script)")

            if dml_success:
                # Verify results
                verify_tables(conn)
                count_records(conn)
                run_sample_queries(conn)

        conn.close()
        print(f"\n{'='*60}")
        print("Database setup complete!")
        print('='*60)

    except psycopg2.Error as e:
        print(f"\nDatabase connection error: {e}")
    except Exception as e:
        print(f"\nError: {e}")

if __name__ == "__main__":
    main()
