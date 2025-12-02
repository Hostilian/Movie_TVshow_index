-- ==============================================================================
-- MOVIE DATABASE - CREATE SCRIPT (DDL) - For Portal Import
-- 8 Primary Entities + 3 Binding Entities = 11 Tables
-- ==============================================================================

-- Drop tables if exist
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

-- PRIMARY ENTITY 1: DIRECTOR
CREATE TABLE director (
    director_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    birth_year INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- PRIMARY ENTITY 2: ACTOR
CREATE TABLE actor (
    actor_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    birth_year INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- PRIMARY ENTITY 3: GENRE
CREATE TABLE genre (
    genre_id SERIAL PRIMARY KEY,
    genre_name VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- PRIMARY ENTITY 4: COUNTRY
CREATE TABLE country (
    country_id SERIAL PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL UNIQUE,
    country_code CHAR(2) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- PRIMARY ENTITY 5: STUDIO
CREATE TABLE studio (
    studio_id SERIAL PRIMARY KEY,
    studio_name VARCHAR(100) NOT NULL UNIQUE,
    founded_year INTEGER,
    country_id INTEGER REFERENCES country(country_id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- PRIMARY ENTITY 6: MOVIE (with self-referencing sequel_of - creates LOOP)
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
    director_id INTEGER NOT NULL REFERENCES director(director_id),
    studio_id INTEGER REFERENCES studio(studio_id) ON DELETE SET NULL,
    sequel_of INTEGER REFERENCES movie(movie_id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- PRIMARY ENTITY 7: USER_RATING
CREATE TABLE user_rating (
    rating_id SERIAL PRIMARY KEY,
    movie_id INTEGER NOT NULL REFERENCES movie(movie_id) ON DELETE CASCADE,
    user_name VARCHAR(100) NOT NULL,
    rating_value INTEGER NOT NULL CHECK (rating_value >= 1 AND rating_value <= 10),
    review_text TEXT,
    rating_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- PRIMARY ENTITY 8: AWARD
CREATE TABLE award (
    award_id SERIAL PRIMARY KEY,
    award_name VARCHAR(100) NOT NULL,
    category VARCHAR(100),
    year_awarded INTEGER,
    movie_id INTEGER NOT NULL REFERENCES movie(movie_id) ON DELETE CASCADE,
    is_winner BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- BINDING ENTITY B1: MOVIE_ACTOR
CREATE TABLE movie_actor (
    movie_id INTEGER NOT NULL REFERENCES movie(movie_id) ON DELETE CASCADE,
    actor_id INTEGER NOT NULL REFERENCES actor(actor_id) ON DELETE CASCADE,
    role_type VARCHAR(20) DEFAULT 'supporting',
    PRIMARY KEY (movie_id, actor_id)
);

-- BINDING ENTITY B2: MOVIE_GENRE
CREATE TABLE movie_genre (
    movie_id INTEGER NOT NULL REFERENCES movie(movie_id) ON DELETE CASCADE,
    genre_id INTEGER NOT NULL REFERENCES genre(genre_id) ON DELETE CASCADE,
    PRIMARY KEY (movie_id, genre_id)
);

-- BINDING ENTITY B3: MOVIE_COUNTRY
CREATE TABLE movie_country (
    movie_id INTEGER NOT NULL REFERENCES movie(movie_id) ON DELETE CASCADE,
    country_id INTEGER NOT NULL REFERENCES country(country_id) ON DELETE CASCADE,
    PRIMARY KEY (movie_id, country_id)
);

-- Create indexes
CREATE INDEX idx_movie_director ON movie(director_id);
CREATE INDEX idx_movie_year ON movie(year);
CREATE INDEX idx_movie_rating ON movie(imdb_rating);
