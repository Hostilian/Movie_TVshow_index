-- ==============================================================================
-- MOVIE DATABASE - CREATE SCRIPT (DDL)
-- Database Systems (EIE36E) Project
--
-- BIE-DBS Cookbook Compliant
--
-- Student: Ozturk Eren
-- Login: xozte001
-- Database: xozte001
-- Server: db.kii.pef.czu.cz
-- Date: 2025-11-29
--
-- SUMMARY:
-- - 8 Primary Entities: DIRECTOR, ACTOR, GENRE, COUNTRY, STUDIO, MOVIE, USER_RATING, AWARD
-- - 3 Binding Entities: MOVIE_ACTOR, MOVIE_GENRE, MOVIE_COUNTRY
-- - Total Tables: 11
-- ==============================================================================

-- ==============================================================================
-- DROP EXISTING TABLES (in correct dependency order)
-- ==============================================================================
DROP TABLE IF EXISTS movie_country CASCADE;
DROP TABLE IF EXISTS movie_genre CASCADE;
DROP TABLE IF EXISTS movie_actor CASCADE;
DROP TABLE IF EXISTS award CASCADE;
DROP TABLE IF EXISTS user_rating CASCADE;
DROP TABLE IF EXISTS movie CASCADE;
DROP TABLE IF EXISTS studio CASCADE;
DROP TABLE IF EXISTS country CASCADE;
DROP TABLE IF EXISTS genre CASCADE;
DROP TABLE IF EXISTS actor CASCADE;
DROP TABLE IF EXISTS director CASCADE;

-- ==============================================================================
-- PRIMARY ENTITY 1: DIRECTOR
-- ==============================================================================
CREATE TABLE director (
    director_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    birth_year INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_director_birth_year CHECK (birth_year IS NULL OR (birth_year >= 1850 AND birth_year <= 2010))
);

COMMENT ON TABLE director IS 'Stores information about film directors';
COMMENT ON COLUMN director.director_id IS 'Unique identifier for each director';
COMMENT ON COLUMN director.name IS 'Full name of the director';
COMMENT ON COLUMN director.birth_year IS 'Year the director was born';

-- ==============================================================================
-- PRIMARY ENTITY 2: ACTOR
-- ==============================================================================
CREATE TABLE actor (
    actor_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    birth_year INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_actor_birth_year CHECK (birth_year IS NULL OR (birth_year >= 1850 AND birth_year <= 2010))
);

COMMENT ON TABLE actor IS 'Stores information about film actors';
COMMENT ON COLUMN actor.actor_id IS 'Unique identifier for each actor';
COMMENT ON COLUMN actor.name IS 'Full name of the actor';
COMMENT ON COLUMN actor.birth_year IS 'Year the actor was born';

-- ==============================================================================
-- PRIMARY ENTITY 3: GENRE
-- ==============================================================================
CREATE TABLE genre (
    genre_id SERIAL PRIMARY KEY,
    genre_name VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE genre IS 'Film genre categories';
COMMENT ON COLUMN genre.genre_id IS 'Unique identifier for each genre';
COMMENT ON COLUMN genre.genre_name IS 'Name of the genre (e.g., Action, Comedy)';

-- ==============================================================================
-- PRIMARY ENTITY 4: COUNTRY
-- ==============================================================================
CREATE TABLE country (
    country_id SERIAL PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL UNIQUE,
    country_code CHAR(2) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE country IS 'Countries for production origins and studio locations';
COMMENT ON COLUMN country.country_id IS 'Unique identifier for each country';
COMMENT ON COLUMN country.country_name IS 'Full name of the country';
COMMENT ON COLUMN country.country_code IS 'ISO 3166-1 alpha-2 country code';

-- ==============================================================================
-- PRIMARY ENTITY 5: STUDIO
-- ==============================================================================
CREATE TABLE studio (
    studio_id SERIAL PRIMARY KEY,
    studio_name VARCHAR(100) NOT NULL UNIQUE,
    founded_year INTEGER,
    country_id INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_studio_country
        FOREIGN KEY (country_id)
        REFERENCES country(country_id)
        ON DELETE SET NULL,

    CONSTRAINT chk_studio_founded_year CHECK (founded_year IS NULL OR (founded_year >= 1850 AND founded_year <= 2025))
);

COMMENT ON TABLE studio IS 'Production studios/companies';
COMMENT ON COLUMN studio.studio_id IS 'Unique identifier for each studio';
COMMENT ON COLUMN studio.studio_name IS 'Name of the production studio';
COMMENT ON COLUMN studio.founded_year IS 'Year the studio was established';
COMMENT ON COLUMN studio.country_id IS 'Country where the studio headquarters is located';

-- ==============================================================================
-- PRIMARY ENTITY 6: MOVIE (Central Entity)
-- ==============================================================================
CREATE TABLE movie (
    movie_id SERIAL PRIMARY KEY,
    imdb_id VARCHAR(20) UNIQUE,
    title VARCHAR(200) NOT NULL,
    year INTEGER NOT NULL,
    runtime INTEGER,
    imdb_rating DECIMAL(3,1),
    imdb_votes INTEGER DEFAULT 0,
    plot TEXT,
    box_office VARCHAR(50),
    release_date DATE,
    director_id INTEGER NOT NULL,
    studio_id INTEGER,
    sequel_of INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_movie_director
        FOREIGN KEY (director_id)
        REFERENCES director(director_id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_movie_studio
        FOREIGN KEY (studio_id)
        REFERENCES studio(studio_id)
        ON DELETE SET NULL,

    CONSTRAINT fk_movie_sequel
        FOREIGN KEY (sequel_of)
        REFERENCES movie(movie_id)
        ON DELETE SET NULL,

    CONSTRAINT chk_movie_year CHECK (year >= 1888 AND year <= 2030),
    CONSTRAINT chk_movie_runtime CHECK (runtime IS NULL OR runtime > 0),
    CONSTRAINT chk_movie_imdb_rating CHECK (imdb_rating IS NULL OR (imdb_rating >= 0 AND imdb_rating <= 10)),
    CONSTRAINT chk_movie_imdb_votes CHECK (imdb_votes IS NULL OR imdb_votes >= 0)
);

COMMENT ON TABLE movie IS 'Central entity storing core movie information';
COMMENT ON COLUMN movie.movie_id IS 'Unique identifier for each movie';
COMMENT ON COLUMN movie.imdb_id IS 'IMDb reference ID (e.g., tt1234567)';
COMMENT ON COLUMN movie.title IS 'Movie title';
COMMENT ON COLUMN movie.year IS 'Release year';
COMMENT ON COLUMN movie.runtime IS 'Duration in minutes';
COMMENT ON COLUMN movie.imdb_rating IS 'IMDb rating from 0.0 to 10.0';
COMMENT ON COLUMN movie.imdb_votes IS 'Number of IMDb votes';
COMMENT ON COLUMN movie.plot IS 'Movie synopsis/description';
COMMENT ON COLUMN movie.box_office IS 'Box office revenue';
COMMENT ON COLUMN movie.director_id IS 'Foreign key to director table';
COMMENT ON COLUMN movie.studio_id IS 'Foreign key to studio table';
COMMENT ON COLUMN movie.sequel_of IS 'Self-referencing FK - points to the original movie this is a sequel of (creates loop in schema)';

-- ==============================================================================
-- PRIMARY ENTITY 7: USER_RATING
-- ==============================================================================
CREATE TABLE user_rating (
    rating_id SERIAL PRIMARY KEY,
    movie_id INTEGER NOT NULL,
    user_name VARCHAR(100) NOT NULL,
    rating_value INTEGER NOT NULL,
    review_text TEXT,
    rating_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_rating_movie
        FOREIGN KEY (movie_id)
        REFERENCES movie(movie_id)
        ON DELETE CASCADE,

    CONSTRAINT chk_rating_value CHECK (rating_value >= 1 AND rating_value <= 10)
);

COMMENT ON TABLE user_rating IS 'User-submitted ratings and reviews for movies';
COMMENT ON COLUMN user_rating.rating_id IS 'Unique identifier for each rating';
COMMENT ON COLUMN user_rating.movie_id IS 'Foreign key to the rated movie';
COMMENT ON COLUMN user_rating.user_name IS 'Name or username of the reviewer';
COMMENT ON COLUMN user_rating.rating_value IS 'Rating score from 1 to 10';
COMMENT ON COLUMN user_rating.review_text IS 'Optional written review';
COMMENT ON COLUMN user_rating.rating_date IS 'When the rating was submitted';

-- ==============================================================================
-- PRIMARY ENTITY 8: AWARD
-- ==============================================================================
CREATE TABLE award (
    award_id SERIAL PRIMARY KEY,
    award_name VARCHAR(100) NOT NULL,
    category VARCHAR(100),
    year_awarded INTEGER,
    movie_id INTEGER NOT NULL,
    is_winner BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_award_movie
        FOREIGN KEY (movie_id)
        REFERENCES movie(movie_id)
        ON DELETE CASCADE,

    CONSTRAINT chk_award_year CHECK (year_awarded IS NULL OR (year_awarded >= 1900 AND year_awarded <= 2030))
);

COMMENT ON TABLE award IS 'Awards and nominations received by movies';
COMMENT ON COLUMN award.award_id IS 'Unique identifier for each award entry';
COMMENT ON COLUMN award.award_name IS 'Name of the award (Oscar, BAFTA, Golden Globe)';
COMMENT ON COLUMN award.category IS 'Award category (Best Picture, Best Director, etc.)';
COMMENT ON COLUMN award.year_awarded IS 'Year the award was given';
COMMENT ON COLUMN award.movie_id IS 'Foreign key to the movie';
COMMENT ON COLUMN award.is_winner IS 'TRUE if won, FALSE if only nominated';

-- ==============================================================================
-- BINDING ENTITY B1: MOVIE_ACTOR (M:N relationship)
-- ==============================================================================
CREATE TABLE movie_actor (
    movie_id INTEGER NOT NULL,
    actor_id INTEGER NOT NULL,
    role_type VARCHAR(20) DEFAULT 'supporting',

    PRIMARY KEY (movie_id, actor_id),

    CONSTRAINT fk_movie_actor_movie
        FOREIGN KEY (movie_id)
        REFERENCES movie(movie_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_movie_actor_actor
        FOREIGN KEY (actor_id)
        REFERENCES actor(actor_id)
        ON DELETE CASCADE,

    CONSTRAINT chk_role_type CHECK (role_type IN ('lead', 'supporting'))
);

COMMENT ON TABLE movie_actor IS 'Many-to-many relationship between movies and actors';
COMMENT ON COLUMN movie_actor.role_type IS 'Type of role: lead or supporting';

-- ==============================================================================
-- BINDING ENTITY B2: MOVIE_GENRE (M:N relationship)
-- ==============================================================================
CREATE TABLE movie_genre (
    movie_id INTEGER NOT NULL,
    genre_id INTEGER NOT NULL,

    PRIMARY KEY (movie_id, genre_id),

    CONSTRAINT fk_movie_genre_movie
        FOREIGN KEY (movie_id)
        REFERENCES movie(movie_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_movie_genre_genre
        FOREIGN KEY (genre_id)
        REFERENCES genre(genre_id)
        ON DELETE CASCADE
);

COMMENT ON TABLE movie_genre IS 'Many-to-many relationship between movies and genres';

-- ==============================================================================
-- BINDING ENTITY B3: MOVIE_COUNTRY (M:N relationship)
-- ==============================================================================
CREATE TABLE movie_country (
    movie_id INTEGER NOT NULL,
    country_id INTEGER NOT NULL,

    PRIMARY KEY (movie_id, country_id),

    CONSTRAINT fk_movie_country_movie
        FOREIGN KEY (movie_id)
        REFERENCES movie(movie_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_movie_country_country
        FOREIGN KEY (country_id)
        REFERENCES country(country_id)
        ON DELETE CASCADE
);

COMMENT ON TABLE movie_country IS 'Many-to-many relationship for international co-productions';

-- ==============================================================================
-- CREATE INDEXES FOR PERFORMANCE
-- ==============================================================================
CREATE INDEX idx_director_name ON director(name);
CREATE INDEX idx_actor_name ON actor(name);
CREATE INDEX idx_movie_title ON movie(title);
CREATE INDEX idx_movie_year ON movie(year);
CREATE INDEX idx_movie_director ON movie(director_id);
CREATE INDEX idx_movie_studio ON movie(studio_id);
CREATE INDEX idx_movie_imdb_rating ON movie(imdb_rating);
CREATE INDEX idx_user_rating_movie ON user_rating(movie_id);
CREATE INDEX idx_award_movie ON award(movie_id);
CREATE INDEX idx_award_year ON award(year_awarded);

-- ==============================================================================
-- VERIFICATION QUERY
-- ==============================================================================
-- Run this to verify all tables were created:
-- SELECT table_name FROM information_schema.tables
-- WHERE table_schema = 'public' ORDER BY table_name;

-- Expected output: 11 tables
-- actor, award, country, director, genre, movie, movie_actor,
-- movie_country, movie_genre, studio, user_rating

-- ==============================================================================
-- END OF DDL SCRIPT
-- ==============================================================================
