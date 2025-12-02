"""
Cinema Database Export Script
Exports PostgreSQL data to JSON files for the GitHub Pages website.

Usage:
    python export_data.py
    
Creates JSON files in docs/data/
"""

import json
import os
from datetime import date, datetime

# Try to import psycopg2, provide fallback instructions if not installed
try:
    import psycopg2
    from psycopg2.extras import RealDictCursor
except ImportError:
    print("psycopg2 not installed. Install with: pip install psycopg2-binary")
    print("Generating sample data instead...")
    psycopg2 = None

# Database connection settings
DB_CONFIG = {
    "host": "db.kii.pef.czu.cz",
    "database": "xozte001",
    "user": "xozte001",
    "password": "YOUR_PASSWORD_HERE",  # Update this!
    "port": 5432
}

# Output directory
OUTPUT_DIR = "docs/data"


def json_serializer(obj):
    """Handle date/datetime serialization for JSON."""
    if isinstance(obj, (date, datetime)):
        return obj.isoformat()
    raise TypeError(f"Object of type {type(obj)} is not JSON serializable")


def export_table(cursor, table_name: str, query: str) -> list:
    """Execute query and return results as list of dicts."""
    print(f"  Exporting {table_name}...")
    cursor.execute(query)
    rows = cursor.fetchall()
    print(f"    → {len(rows)} records")
    return rows


def export_from_database():
    """Connect to PostgreSQL and export all tables to JSON."""
    print("Connecting to database...")
    
    conn = psycopg2.connect(**DB_CONFIG)
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    
    exports = {
        "movies": """
            SELECT m.movie_id, m.title, m.release_year, m.duration_minutes,
                   m.box_office_usd, m.imdb_id, m.plot_summary,
                   d.name as director_name, s.name as studio_name
            FROM movie m
            LEFT JOIN director d ON m.director_id = d.director_id
            LEFT JOIN studio s ON m.studio_id = s.studio_id
            ORDER BY m.title
        """,
        "actors": """
            SELECT actor_id, name, birth_date, nationality
            FROM actor ORDER BY name
        """,
        "directors": """
            SELECT director_id, name, birth_year
            FROM director ORDER BY name
        """,
        "genres": """
            SELECT genre_id, name
            FROM genre ORDER BY name
        """,
        "countries": """
            SELECT country_id, name, iso_code
            FROM country ORDER BY name
        """,
        "studios": """
            SELECT studio_id, name, founded_year
            FROM studio ORDER BY name
        """,
        "ratings": """
            SELECT r.rating_id, r.movie_id, m.title as movie_title,
                   r.rating, r.review_text, r.rating_date
            FROM user_rating r
            JOIN movie m ON r.movie_id = m.movie_id
            ORDER BY r.rating_date DESC
        """,
        "awards": """
            SELECT a.award_id, a.movie_id, m.title as movie_title,
                   a.award_name, a.category, a.year, a.is_winner
            FROM award a
            JOIN movie m ON a.movie_id = m.movie_id
            ORDER BY a.year DESC
        """,
        "movie_actors": """
            SELECT ma.movie_id, m.title as movie_title,
                   ma.actor_id, a.name as actor_name, ma.role_name
            FROM movie_actor ma
            JOIN movie m ON ma.movie_id = m.movie_id
            JOIN actor a ON ma.actor_id = a.actor_id
            ORDER BY m.title, a.name
        """,
        "movie_genres": """
            SELECT mg.movie_id, m.title as movie_title,
                   mg.genre_id, g.name as genre_name
            FROM movie_genre mg
            JOIN movie m ON mg.movie_id = m.movie_id
            JOIN genre g ON mg.genre_id = g.genre_id
            ORDER BY m.title, g.name
        """
    }
    
    # Create output directory if it doesn't exist
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    
    for name, query in exports.items():
        data = export_table(cursor, name, query)
        
        # Convert to regular dicts (from RealDictRow)
        data = [dict(row) for row in data]
        
        # Write to JSON file
        output_path = os.path.join(OUTPUT_DIR, f"{name}.json")
        with open(output_path, "w", encoding="utf-8") as f:
            json.dump(data, f, indent=2, default=json_serializer, ensure_ascii=False)
        
        print(f"    → Saved to {output_path}")
    
    # Create combined data file for the website
    print("\n  Creating combined database.json...")
    combined = {}
    for name in exports.keys():
        with open(os.path.join(OUTPUT_DIR, f"{name}.json"), "r", encoding="utf-8") as f:
            combined[name] = json.load(f)
    
    combined["metadata"] = {
        "exported_at": datetime.now().isoformat(),
        "source": "PostgreSQL @ db.kii.pef.czu.cz",
        "tables": len(exports),
        "total_records": sum(len(v) for v in combined.values() if isinstance(v, list))
    }
    
    with open(os.path.join(OUTPUT_DIR, "database.json"), "w", encoding="utf-8") as f:
        json.dump(combined, f, indent=2, ensure_ascii=False)
    
    print(f"    → Saved to {OUTPUT_DIR}/database.json")
    
    cursor.close()
    conn.close()
    print("\n✅ Export complete!")


def generate_sample_data():
    """Generate sample JSON data without database connection."""
    print("Generating sample data...")
    
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    
    # Movies
    movies = [
        {"movie_id": 1, "title": "Inception", "release_year": 2010, "duration_minutes": 148, "director_name": "Christopher Nolan", "studio_name": "Warner Bros."},
        {"movie_id": 2, "title": "The Shawshank Redemption", "release_year": 1994, "duration_minutes": 142, "director_name": "Frank Darabont", "studio_name": "Columbia Pictures"},
        {"movie_id": 3, "title": "Pulp Fiction", "release_year": 1994, "duration_minutes": 154, "director_name": "Quentin Tarantino", "studio_name": "Miramax Films"},
        {"movie_id": 4, "title": "The Dark Knight", "release_year": 2008, "duration_minutes": 152, "director_name": "Christopher Nolan", "studio_name": "Warner Bros."},
        {"movie_id": 5, "title": "Forrest Gump", "release_year": 1994, "duration_minutes": 142, "director_name": "Robert Zemeckis", "studio_name": "Paramount Pictures"},
        {"movie_id": 6, "title": "Interstellar", "release_year": 2014, "duration_minutes": 169, "director_name": "Christopher Nolan", "studio_name": "Warner Bros."},
        {"movie_id": 7, "title": "The Matrix", "release_year": 1999, "duration_minutes": 136, "director_name": "The Wachowskis", "studio_name": "Warner Bros."},
        {"movie_id": 8, "title": "Fight Club", "release_year": 1999, "duration_minutes": 139, "director_name": "David Fincher", "studio_name": "20th Century Fox"},
        {"movie_id": 9, "title": "Goodfellas", "release_year": 1990, "duration_minutes": 146, "director_name": "Martin Scorsese", "studio_name": "Warner Bros."},
        {"movie_id": 10, "title": "The Godfather", "release_year": 1972, "duration_minutes": 175, "director_name": "Francis Ford Coppola", "studio_name": "Paramount Pictures"},
        {"movie_id": 11, "title": "Schindlers List", "release_year": 1993, "duration_minutes": 195, "director_name": "Steven Spielberg", "studio_name": "Universal Pictures"},
        {"movie_id": 12, "title": "Saving Private Ryan", "release_year": 1998, "duration_minutes": 169, "director_name": "Steven Spielberg", "studio_name": "DreamWorks"},
        {"movie_id": 13, "title": "The Silence of the Lambs", "release_year": 1991, "duration_minutes": 118, "director_name": "Jonathan Demme", "studio_name": "Orion Pictures"},
        {"movie_id": 14, "title": "Se7en", "release_year": 1995, "duration_minutes": 127, "director_name": "David Fincher", "studio_name": "New Line Cinema"},
        {"movie_id": 15, "title": "Gladiator", "release_year": 2000, "duration_minutes": 155, "director_name": "Ridley Scott", "studio_name": "DreamWorks"}
    ]
    
    actors = [
        {"actor_id": 1, "name": "Leonardo DiCaprio", "nationality": "USA"},
        {"actor_id": 2, "name": "Morgan Freeman", "nationality": "USA"},
        {"actor_id": 3, "name": "John Travolta", "nationality": "USA"},
        {"actor_id": 4, "name": "Christian Bale", "nationality": "UK"},
        {"actor_id": 5, "name": "Tom Hanks", "nationality": "USA"},
        {"actor_id": 6, "name": "Matthew McConaughey", "nationality": "USA"},
        {"actor_id": 7, "name": "Keanu Reeves", "nationality": "Canada"},
        {"actor_id": 8, "name": "Brad Pitt", "nationality": "USA"},
        {"actor_id": 9, "name": "Robert De Niro", "nationality": "USA"},
        {"actor_id": 10, "name": "Marlon Brando", "nationality": "USA"}
    ]
    
    directors = [
        {"director_id": 1, "name": "Christopher Nolan", "birth_year": 1970},
        {"director_id": 2, "name": "Frank Darabont", "birth_year": 1959},
        {"director_id": 3, "name": "Quentin Tarantino", "birth_year": 1963},
        {"director_id": 4, "name": "Robert Zemeckis", "birth_year": 1952},
        {"director_id": 5, "name": "The Wachowskis", "birth_year": 1965},
        {"director_id": 6, "name": "David Fincher", "birth_year": 1962},
        {"director_id": 7, "name": "Martin Scorsese", "birth_year": 1942},
        {"director_id": 8, "name": "Francis Ford Coppola", "birth_year": 1939},
        {"director_id": 9, "name": "Steven Spielberg", "birth_year": 1946},
        {"director_id": 10, "name": "Jonathan Demme", "birth_year": 1944},
        {"director_id": 11, "name": "Ridley Scott", "birth_year": 1937}
    ]
    
    genres = [
        {"genre_id": 1, "name": "Action"},
        {"genre_id": 2, "name": "Drama"},
        {"genre_id": 3, "name": "Thriller"},
        {"genre_id": 4, "name": "Sci-Fi"},
        {"genre_id": 5, "name": "Crime"},
        {"genre_id": 6, "name": "Romance"},
        {"genre_id": 7, "name": "Horror"},
        {"genre_id": 8, "name": "Comedy"},
        {"genre_id": 9, "name": "War"},
        {"genre_id": 10, "name": "Biography"},
        {"genre_id": 11, "name": "Mystery"},
        {"genre_id": 12, "name": "Adventure"}
    ]
    
    countries = [
        {"country_id": 1, "name": "USA", "iso_code": "US"},
        {"country_id": 2, "name": "United Kingdom", "iso_code": "GB"},
        {"country_id": 3, "name": "France", "iso_code": "FR"},
        {"country_id": 4, "name": "Germany", "iso_code": "DE"},
        {"country_id": 5, "name": "Italy", "iso_code": "IT"},
        {"country_id": 6, "name": "Canada", "iso_code": "CA"},
        {"country_id": 7, "name": "Australia", "iso_code": "AU"},
        {"country_id": 8, "name": "Japan", "iso_code": "JP"},
        {"country_id": 9, "name": "South Korea", "iso_code": "KR"},
        {"country_id": 10, "name": "Spain", "iso_code": "ES"}
    ]
    
    studios = [
        {"studio_id": 1, "name": "Warner Bros.", "founded_year": 1923},
        {"studio_id": 2, "name": "Columbia Pictures", "founded_year": 1924},
        {"studio_id": 3, "name": "Miramax Films", "founded_year": 1979},
        {"studio_id": 4, "name": "Paramount Pictures", "founded_year": 1912},
        {"studio_id": 5, "name": "20th Century Fox", "founded_year": 1935},
        {"studio_id": 6, "name": "Universal Pictures", "founded_year": 1912},
        {"studio_id": 7, "name": "DreamWorks", "founded_year": 1994},
        {"studio_id": 8, "name": "Orion Pictures", "founded_year": 1978},
        {"studio_id": 9, "name": "New Line Cinema", "founded_year": 1967},
        {"studio_id": 10, "name": "Lionsgate", "founded_year": 1997}
    ]
    
    # Write individual JSON files
    data_sets = {
        "movies": movies,
        "actors": actors,
        "directors": directors,
        "genres": genres,
        "countries": countries,
        "studios": studios
    }
    
    for name, data in data_sets.items():
        output_path = os.path.join(OUTPUT_DIR, f"{name}.json")
        with open(output_path, "w", encoding="utf-8") as f:
            json.dump(data, f, indent=2, ensure_ascii=False)
        print(f"  → Saved {name}.json ({len(data)} records)")
    
    # Create combined file
    combined = {
        **data_sets,
        "metadata": {
            "exported_at": datetime.now().isoformat(),
            "source": "Sample data (no database connection)",
            "tables": len(data_sets),
            "total_records": sum(len(v) for v in data_sets.values())
        }
    }
    
    with open(os.path.join(OUTPUT_DIR, "database.json"), "w", encoding="utf-8") as f:
        json.dump(combined, f, indent=2, ensure_ascii=False)
    
    print(f"  → Saved database.json")
    print("\n✅ Sample data generated!")


if __name__ == "__main__":
    print("=" * 50)
    print("Cinema Database Export Script")
    print("=" * 50 + "\n")
    
    if psycopg2 is None:
        generate_sample_data()
    else:
        try:
            export_from_database()
        except Exception as e:
            print(f"\n⚠️  Database connection failed: {e}")
            print("Falling back to sample data...\n")
            generate_sample_data()
