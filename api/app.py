"""
Cinema Database REST API
FastAPI service providing endpoints for the movie database.

Usage:
    pip install fastapi uvicorn psycopg2-binary
    uvicorn api.app:app --reload --port 8000
    
Endpoints:
    GET /           - API info
    GET /movies     - List all movies
    GET /movies/{id} - Get movie by ID
    GET /actors     - List all actors
    GET /directors  - List all directors
    GET /genres     - List all genres
    GET /stats      - Database statistics
"""

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Optional, List
import json
import os
from datetime import date, datetime

# Try to import psycopg2
try:
    import psycopg2
    from psycopg2.extras import RealDictCursor
    DB_AVAILABLE = True
except ImportError:
    DB_AVAILABLE = False
    print("⚠️  psycopg2 not installed. Using static JSON data.")

# FastAPI app
app = FastAPI(
    title="Cinema Database API",
    description="REST API for the BI-DBS.21 Cinema Database project",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc"
)

# CORS middleware (allow all origins for development)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Database config
DB_CONFIG = {
    "host": "db.kii.pef.czu.cz",
    "database": "xozte001",
    "user": "xozte001",
    "password": os.environ.get("DB_PASSWORD", "YOUR_PASSWORD"),
    "port": 5432
}

# Path to static JSON data
DATA_DIR = os.path.join(os.path.dirname(__file__), "..", "docs", "data")


# ---- Pydantic Models ----

class Movie(BaseModel):
    movie_id: int
    title: str
    release_year: Optional[int] = None
    duration_minutes: Optional[int] = None
    director_name: Optional[str] = None
    studio_name: Optional[str] = None
    box_office_usd: Optional[int] = None
    imdb_id: Optional[str] = None
    plot_summary: Optional[str] = None

class Actor(BaseModel):
    actor_id: int
    name: str
    birth_date: Optional[str] = None
    nationality: Optional[str] = None

class Director(BaseModel):
    director_id: int
    name: str
    birth_year: Optional[int] = None

class Genre(BaseModel):
    genre_id: int
    name: str

class Stats(BaseModel):
    movies: int
    actors: int
    directors: int
    genres: int
    countries: int
    studios: int


# ---- Helper Functions ----

def get_db_connection():
    """Get a database connection."""
    if not DB_AVAILABLE:
        return None
    try:
        return psycopg2.connect(**DB_CONFIG)
    except Exception as e:
        print(f"Database connection failed: {e}")
        return None

def load_json_data(filename: str) -> list:
    """Load data from static JSON file."""
    filepath = os.path.join(DATA_DIR, filename)
    if os.path.exists(filepath):
        with open(filepath, "r", encoding="utf-8") as f:
            return json.load(f)
    return []

def query_db(query: str, params: tuple = None) -> list:
    """Execute query and return results."""
    conn = get_db_connection()
    if conn:
        try:
            cursor = conn.cursor(cursor_factory=RealDictCursor)
            cursor.execute(query, params)
            results = [dict(row) for row in cursor.fetchall()]
            cursor.close()
            conn.close()
            return results
        except Exception as e:
            print(f"Query failed: {e}")
            if conn:
                conn.close()
    return None


# ---- API Endpoints ----

@app.get("/")
def root():
    """API root - returns basic info."""
    return {
        "name": "Cinema Database API",
        "version": "1.0.0",
        "database": "PostgreSQL @ db.kii.pef.czu.cz" if DB_AVAILABLE else "Static JSON",
        "endpoints": [
            "/movies", "/movies/{id}",
            "/actors", "/directors", "/genres",
            "/stats", "/docs"
        ]
    }


@app.get("/movies", response_model=List[Movie])
def get_movies(
    year: Optional[int] = None,
    director: Optional[str] = None,
    limit: int = 100
):
    """Get all movies with optional filters."""
    # Try database first
    query = """
        SELECT m.movie_id, m.title, m.release_year, m.duration_minutes,
               m.box_office_usd, m.imdb_id, m.plot_summary,
               d.name as director_name, s.name as studio_name
        FROM movie m
        LEFT JOIN director d ON m.director_id = d.director_id
        LEFT JOIN studio s ON m.studio_id = s.studio_id
        WHERE 1=1
    """
    params = []
    
    if year:
        query += " AND m.release_year = %s"
        params.append(year)
    if director:
        query += " AND LOWER(d.name) LIKE LOWER(%s)"
        params.append(f"%{director}%")
    
    query += f" ORDER BY m.title LIMIT {limit}"
    
    results = query_db(query, tuple(params) if params else None)
    
    if results is not None:
        return results
    
    # Fallback to JSON
    movies = load_json_data("movies.json")
    if year:
        movies = [m for m in movies if m.get("release_year") == year]
    if director:
        movies = [m for m in movies if director.lower() in m.get("director_name", "").lower()]
    return movies[:limit]


@app.get("/movies/{movie_id}", response_model=Movie)
def get_movie(movie_id: int):
    """Get a specific movie by ID."""
    query = """
        SELECT m.movie_id, m.title, m.release_year, m.duration_minutes,
               m.box_office_usd, m.imdb_id, m.plot_summary,
               d.name as director_name, s.name as studio_name
        FROM movie m
        LEFT JOIN director d ON m.director_id = d.director_id
        LEFT JOIN studio s ON m.studio_id = s.studio_id
        WHERE m.movie_id = %s
    """
    
    results = query_db(query, (movie_id,))
    
    if results:
        return results[0]
    
    # Fallback to JSON
    movies = load_json_data("movies.json")
    for m in movies:
        if m.get("movie_id") == movie_id:
            return m
    
    raise HTTPException(status_code=404, detail="Movie not found")


@app.get("/actors", response_model=List[Actor])
def get_actors(
    name: Optional[str] = None,
    nationality: Optional[str] = None,
    limit: int = 100
):
    """Get all actors with optional filters."""
    query = """
        SELECT actor_id, name, birth_date::text, nationality
        FROM actor WHERE 1=1
    """
    params = []
    
    if name:
        query += " AND LOWER(name) LIKE LOWER(%s)"
        params.append(f"%{name}%")
    if nationality:
        query += " AND LOWER(nationality) LIKE LOWER(%s)"
        params.append(f"%{nationality}%")
    
    query += f" ORDER BY name LIMIT {limit}"
    
    results = query_db(query, tuple(params) if params else None)
    
    if results is not None:
        return results
    
    # Fallback to JSON
    actors = load_json_data("actors.json")
    if name:
        actors = [a for a in actors if name.lower() in a.get("name", "").lower()]
    if nationality:
        actors = [a for a in actors if nationality.lower() in a.get("nationality", "").lower()]
    return actors[:limit]


@app.get("/directors", response_model=List[Director])
def get_directors(name: Optional[str] = None, limit: int = 100):
    """Get all directors with optional name filter."""
    query = "SELECT director_id, name, birth_year FROM director WHERE 1=1"
    params = []
    
    if name:
        query += " AND LOWER(name) LIKE LOWER(%s)"
        params.append(f"%{name}%")
    
    query += f" ORDER BY name LIMIT {limit}"
    
    results = query_db(query, tuple(params) if params else None)
    
    if results is not None:
        return results
    
    # Fallback to JSON
    directors = load_json_data("directors.json")
    if name:
        directors = [d for d in directors if name.lower() in d.get("name", "").lower()]
    return directors[:limit]


@app.get("/genres", response_model=List[Genre])
def get_genres():
    """Get all genres."""
    query = "SELECT genre_id, name FROM genre ORDER BY name"
    
    results = query_db(query)
    
    if results is not None:
        return results
    
    return load_json_data("genres.json")


@app.get("/stats", response_model=Stats)
def get_stats():
    """Get database statistics."""
    stats = {}
    tables = ["movies", "actors", "directors", "genres", "countries", "studios"]
    
    # Try database
    conn = get_db_connection()
    if conn:
        try:
            cursor = conn.cursor()
            for table in tables:
                # Map plural to singular table names
                db_table = table[:-1] if table.endswith("s") else table
                if table == "movies":
                    db_table = "movie"
                cursor.execute(f"SELECT COUNT(*) FROM {db_table}")
                stats[table] = cursor.fetchone()[0]
            cursor.close()
            conn.close()
            return stats
        except Exception as e:
            print(f"Stats query failed: {e}")
            if conn:
                conn.close()
    
    # Fallback to JSON
    for table in tables:
        data = load_json_data(f"{table}.json")
        stats[table] = len(data)
    
    return stats


# Health check endpoint
@app.get("/health")
def health():
    """Health check endpoint."""
    db_status = "connected" if get_db_connection() else "disconnected"
    return {
        "status": "healthy",
        "database": db_status,
        "timestamp": datetime.now().isoformat()
    }


if __name__ == "__main__":
    import uvicorn
    print("Starting Cinema Database API...")
    print("Docs: http://localhost:8000/docs")
    uvicorn.run(app, host="0.0.0.0", port=8000)
