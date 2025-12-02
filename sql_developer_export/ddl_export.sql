-- ==============================================================================
-- SQL DEVELOPER DDL EXPORT
-- Movie Database - Complete DDL Script
--
-- Generated from SQL Developer Data Modeler
--
-- Student: Ozturk Eren
-- Login: xozte001
-- Database: xozte001
-- Server: db.kii.pef.czu.cz
-- Date: 2025-11-29
--
-- This file contains all DDL statements for the Movie Database schema.
-- Copy of 03_create_script.sql for SQL Developer export package.
-- ==============================================================================

-- ==============================================================================
-- DROP EXISTING TABLES (reverse dependency order)
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
-- TABLE: DIRECTOR
-- Type: Primary Entity
-- ==============================================================================
CREATE TABLE director (
    director_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    birth_year INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_director_birth_year CHECK (birth_year IS NULL OR (birth_year >= 1850 AND birth_year <= 2010))
);

-- ==============================================================================
-- TABLE: ACTOR
-- Type: Primary Entity
-- ==============================================================================
CREATE TABLE actor (
    actor_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    birth_year INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_actor_birth_year CHECK (birth_year IS NULL OR (birth_year >= 1850 AND birth_year <= 2010))
);

-- ==============================================================================
-- TABLE: GENRE
-- Type: Primary Entity
-- ==============================================================================
CREATE TABLE genre (
    genre_id SERIAL PRIMARY KEY,
    genre_name VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==============================================================================
-- TABLE: COUNTRY
-- Type: Primary Entity
-- ==============================================================================
CREATE TABLE country (
    country_id SERIAL PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL UNIQUE,
    country_code CHAR(2) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==============================================================================
-- TABLE: STUDIO
-- Type: Primary Entity
-- References: COUNTRY
-- ==============================================================================
CREATE TABLE studio (
    studio_id SERIAL PRIMARY KEY,
    studio_name VARCHAR(100) NOT NULL UNIQUE,
    founded_year INTEGER,
    country_id INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_studio_country FOREIGN KEY (country_id) REFERENCES country(country_id) ON DELETE SET NULL,
    CONSTRAINT chk_studio_founded_year CHECK (founded_year IS NULL OR (founded_year >= 1850 AND founded_year <= 2025))
);

-- ==============================================================================
-- TABLE: MOVIE
-- Type: Primary Entity (Central)
-- References: DIRECTOR, STUDIO
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
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_movie_director FOREIGN KEY (director_id) REFERENCES director(director_id) ON DELETE RESTRICT,
    CONSTRAINT fk_movie_studio FOREIGN KEY (studio_id) REFERENCES studio(studio_id) ON DELETE SET NULL,
    CONSTRAINT chk_movie_year CHECK (year >= 1888 AND year <= 2030),
    CONSTRAINT chk_movie_runtime CHECK (runtime IS NULL OR runtime > 0),
    CONSTRAINT chk_movie_imdb_rating CHECK (imdb_rating IS NULL OR (imdb_rating >= 0 AND imdb_rating <= 10)),
    CONSTRAINT chk_movie_imdb_votes CHECK (imdb_votes IS NULL OR imdb_votes >= 0)
);

-- ==============================================================================
-- TABLE: USER_RATING
-- Type: Primary Entity
-- References: MOVIE
-- ==============================================================================
CREATE TABLE user_rating (
    rating_id SERIAL PRIMARY KEY,
    movie_id INTEGER NOT NULL,
    user_name VARCHAR(100) NOT NULL,
    rating_value INTEGER NOT NULL,
    review_text TEXT,
    rating_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_rating_movie FOREIGN KEY (movie_id) REFERENCES movie(movie_id) ON DELETE CASCADE,
    CONSTRAINT chk_rating_value CHECK (rating_value >= 1 AND rating_value <= 10)
);

-- ==============================================================================
-- TABLE: AWARD
-- Type: Primary Entity
-- References: MOVIE
-- ==============================================================================
CREATE TABLE award (
    award_id SERIAL PRIMARY KEY,
    award_name VARCHAR(100) NOT NULL,
    category VARCHAR(100),
    year_awarded INTEGER,
    movie_id INTEGER NOT NULL,
    is_winner BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_award_movie FOREIGN KEY (movie_id) REFERENCES movie(movie_id) ON DELETE CASCADE,
    CONSTRAINT chk_award_year CHECK (year_awarded IS NULL OR (year_awarded >= 1900 AND year_awarded <= 2030))
);

-- ==============================================================================
-- TABLE: MOVIE_ACTOR
-- Type: Binding Entity (M:N)
-- References: MOVIE, ACTOR
-- ==============================================================================
CREATE TABLE movie_actor (
    movie_id INTEGER NOT NULL,
    actor_id INTEGER NOT NULL,
    role_type VARCHAR(20) DEFAULT 'supporting',
    PRIMARY KEY (movie_id, actor_id),
    CONSTRAINT fk_movie_actor_movie FOREIGN KEY (movie_id) REFERENCES movie(movie_id) ON DELETE CASCADE,
    CONSTRAINT fk_movie_actor_actor FOREIGN KEY (actor_id) REFERENCES actor(actor_id) ON DELETE CASCADE,
    CONSTRAINT chk_role_type CHECK (role_type IN ('lead', 'supporting'))
);

-- ==============================================================================
-- TABLE: MOVIE_GENRE
-- Type: Binding Entity (M:N)
-- References: MOVIE, GENRE
-- ==============================================================================
CREATE TABLE movie_genre (
    movie_id INTEGER NOT NULL,
    genre_id INTEGER NOT NULL,
    PRIMARY KEY (movie_id, genre_id),
    CONSTRAINT fk_movie_genre_movie FOREIGN KEY (movie_id) REFERENCES movie(movie_id) ON DELETE CASCADE,
    CONSTRAINT fk_movie_genre_genre FOREIGN KEY (genre_id) REFERENCES genre(genre_id) ON DELETE CASCADE
);

-- ==============================================================================
-- TABLE: MOVIE_COUNTRY
-- Type: Binding Entity (M:N)
-- References: MOVIE, COUNTRY
-- ==============================================================================
CREATE TABLE movie_country (
    movie_id INTEGER NOT NULL,
    country_id INTEGER NOT NULL,
    PRIMARY KEY (movie_id, country_id),
    CONSTRAINT fk_movie_country_movie FOREIGN KEY (movie_id) REFERENCES movie(movie_id) ON DELETE CASCADE,
    CONSTRAINT fk_movie_country_country FOREIGN KEY (country_id) REFERENCES country(country_id) ON DELETE CASCADE
);

-- ==============================================================================
-- INDEXES
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
-- END OF DDL EXPORT
-- ==============================================================================
