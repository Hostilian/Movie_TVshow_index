"""
Generate submission text files for easy copy-paste to DBS Portal
"""

print("=" * 80)
print("BIE-DBS PORTAL SUBMISSION - COPY-PASTE READY TEXT")
print("=" * 80)

# ============================================================================
# ITERATION 1 - CONTENT TO COPY
# ============================================================================
print("\n")
print("╔" + "═" * 78 + "╗")
print("║" + " ITERATION 1 - COPY THESE TO PORTAL ".center(78) + "║")
print("╚" + "═" * 78 + "╝")

print("\n" + "-" * 40)
print("TITLE (copy below):")
print("-" * 40)
print("""Movie and TV Database Management System""")

print("\n" + "-" * 40)
print("DESCRIPTION (copy below - 285 words):")
print("-" * 40)
print("""This comprehensive database system is designed to manage and organize detailed information about movies and television productions from around the world. The system serves as a centralized repository for film metadata, enabling users to explore relationships between movies, their cast members, directors, genres, and production details.

The primary purpose of this database is to support a movie information platform similar to IMDb, providing functionality for movie discovery, cast analysis, genre exploration, and ratings aggregation. Users can search for films by various criteria including title, release year, genre, actor, or director. The system tracks many-to-many relationships between movies and actors, as well as movies and genres, reflecting the real-world complexity of film production.

Key features include storage of movie ratings from both IMDb and user-submitted reviews, allowing for comprehensive quality assessment. The database also maintains information about production studios and countries of origin, supporting analysis of international co-productions and studio output patterns.

Data is sourced from the OMDb API (Open Movie Database), which provides reliable, well-structured movie metadata including titles, release dates, runtime, plot summaries, cast lists, and ratings. This ensures the database contains realistic, verifiable information rather than fabricated test data.

The system architecture follows best practices in relational database design, implementing proper normalization to Third Normal Form (3NF), establishing referential integrity through foreign key constraints, and utilizing indexes for query optimization. The design specifically avoids circular dependencies to ensure clean query paths and straightforward data maintenance operations.""")

print("\n" + "-" * 40)
print("NATURAL QUERIES - Iteration 1 (3 queries):")
print("-" * 40)
print("""Query 1: Find all movies that were released after the year 2010.

Query 2: Show the title and IMDb rating for all movies in the database.

Query 3: List all actors who were born before 1970.""")

# ============================================================================
# ITERATION 2 - CONTENT TO COPY
# ============================================================================
print("\n")
print("╔" + "═" * 78 + "╗")
print("║" + " ITERATION 2 - COPY THESE TO PORTAL ".center(78) + "║")
print("╚" + "═" * 78 + "╝")

print("\n" + "-" * 40)
print("LOOPS DISCUSSION (copy below):")
print("-" * 40)
print("""There are NO circular dependencies (loops) in this database model. The relationship graph is strictly acyclic.

DEPENDENCY FLOW ANALYSIS:
- Level 0 (Independent): DIRECTOR, ACTOR, GENRE, COUNTRY
- Level 1 (Depends on Level 0): STUDIO references COUNTRY
- Level 2 (Depends on Level 0-1): MOVIE references DIRECTOR and STUDIO
- Level 3 (Depends on Level 2): USER_RATING and AWARD reference MOVIE
- Binding Tables: MOVIE_ACTOR, MOVIE_GENRE, MOVIE_COUNTRY connect entities

No entity at any level references back to a higher level, therefore no circular dependency exists in this model.

BENEFITS:
- No infinite loops during recursive queries
- Clean CASCADE DELETE behavior
- Unambiguous JOIN paths
- Simplified transaction management""")

print("\n" + "-" * 40)
print("NATURAL QUERIES - Iteration 2 (10 queries with categories):")
print("-" * 40)
print("""Category C (Simple Selection):
1. Find all movies that were released after the year 2010.
2. Show the title and IMDb rating for all movies in the database.
3. List all actors who were born before 1970.

Category D1 (Joins):
4. List all movies together with their director names.
5. Find all actors who appeared in the movie "Inception".
6. Show all movies that belong to the "Action" genre.
7. List all user reviews for movies directed by Christopher Nolan.

Category D2 (Aggregations):
8. Count the total number of movies in the database.
9. Find the average IMDb rating of all movies.
10. Show how many movies each director has directed, sorted by count.""")

print("\n" + "-" * 40)
print("ENTITY TYPES (8 Primary + 3 Binding):")
print("-" * 40)
print("""PRIMARY ENTITIES (8):
1. DIRECTOR - Film directors with name and birth year
2. ACTOR - Film actors with name and birth year
3. GENRE - Film genre categories (Action, Comedy, Drama, etc.)
4. COUNTRY - Countries for production origins and studio locations
5. STUDIO - Production studios and companies
6. MOVIE - Central entity with core movie information
7. USER_RATING - User-submitted ratings and reviews
8. AWARD - Awards and nominations received by movies

BINDING ENTITIES (3):
1. MOVIE_ACTOR - M:N relationship between movies and actors
2. MOVIE_GENRE - M:N relationship between movies and genres
3. MOVIE_COUNTRY - M:N relationship for international co-productions""")

print("\n")
print("=" * 80)
print("CONCEPTUAL SCHEMA:")
print("=" * 80)
print("""
Open the file: 06_conceptual_schema.html
in your web browser to see the ER Diagram.

Then:
1. Take a screenshot or use browser Print to PDF
2. Upload to the DBS portal as the conceptual schema

OR copy the Mermaid diagram code from 06_conceptual_schema.md
""")

print("\n")
print("=" * 80)
print("SUBMISSION COMPLETE!")
print("=" * 80)
