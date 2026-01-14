-- ============================================================================
-- Movie and TV Database Management System - CREATE Script
-- Database: PostgreSQL
-- Author: xozte001
-- Date: 2026-01-14
-- ============================================================================

-- Drop existing tables if they exist (in reverse dependency order)
DROP TABLE IF EXISTS user_rating CASCADE;
DROP TABLE IF EXISTS movie_actor CASCADE;
DROP TABLE IF EXISTS movie_genre CASCADE;
DROP TABLE IF EXISTS award CASCADE;
DROP TABLE IF EXISTS movie CASCADE;
DROP TABLE IF EXISTS actor CASCADE;
DROP TABLE IF EXISTS director CASCADE;
DROP TABLE IF EXISTS studio CASCADE;
DROP TABLE IF EXISTS genre CASCADE;
DROP TABLE IF EXISTS country CASCADE;

-- ============================================================================
-- Create Tables
-- ============================================================================

-- Country table
CREATE TABLE country (
    country_id SERIAL PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL,
    country_code CHAR(2) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Genre table
CREATE TABLE genre (
    genre_id SERIAL PRIMARY KEY,
    genre_name VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Studio table
CREATE TABLE studio (
    studio_id SERIAL PRIMARY KEY,
    studio_name VARCHAR(100) NOT NULL,
    founded_year INTEGER,
    country_id INTEGER REFERENCES country(country_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Director table
CREATE TABLE director (
    director_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    birth_date DATE,
    nationality VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Actor table
CREATE TABLE actor (
    actor_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    birth_date DATE,
    nationality VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Movie table
CREATE TABLE movie (
    movie_id SERIAL PRIMARY KEY,
    imdb_id VARCHAR(20) UNIQUE,
    title VARCHAR(200) NOT NULL,
    year INTEGER NOT NULL,
    runtime INTEGER,
    imdb_rating DECIMAL(3,1),
    imdb_votes INTEGER,
    plot TEXT,
    box_office VARCHAR(50),
    release_date DATE,
    director_id INTEGER REFERENCES director(director_id),
    studio_id INTEGER REFERENCES studio(studio_id),
    sequel_of INTEGER REFERENCES movie(movie_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_year CHECK (year >= 1888 AND year <= 2100),
    CONSTRAINT chk_rating CHECK (imdb_rating >= 0 AND imdb_rating <= 10)
);

-- Award table
CREATE TABLE award (
    award_id SERIAL PRIMARY KEY,
    award_name VARCHAR(100) NOT NULL,
    category VARCHAR(100),
    year_awarded INTEGER,
    movie_id INTEGER REFERENCES movie(movie_id) ON DELETE CASCADE,
    is_winner BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Movie_Actor junction table (many-to-many)
CREATE TABLE movie_actor (
    movie_id INTEGER REFERENCES movie(movie_id) ON DELETE CASCADE,
    actor_id INTEGER REFERENCES actor(actor_id) ON DELETE CASCADE,
    role_name VARCHAR(100),
    is_lead BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (movie_id, actor_id)
);

-- Movie_Genre junction table (many-to-many)
CREATE TABLE movie_genre (
    movie_id INTEGER REFERENCES movie(movie_id) ON DELETE CASCADE,
    genre_id INTEGER REFERENCES genre(genre_id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (movie_id, genre_id)
);

-- User_Rating table
CREATE TABLE user_rating (
    rating_id SERIAL PRIMARY KEY,
    movie_id INTEGER REFERENCES movie(movie_id) ON DELETE CASCADE,
    user_name VARCHAR(100) NOT NULL,
    rating_value INTEGER NOT NULL,
    review_text TEXT,
    rating_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_rating_value CHECK (rating_value >= 1 AND rating_value <= 10)
);

-- ============================================================================
-- Create Indexes for Performance
-- ============================================================================

CREATE INDEX idx_movie_title ON movie(title);
CREATE INDEX idx_movie_year ON movie(year);
CREATE INDEX idx_movie_rating ON movie(imdb_rating);
CREATE INDEX idx_movie_director ON movie(director_id);
CREATE INDEX idx_movie_studio ON movie(studio_id);
CREATE INDEX idx_award_movie ON award(movie_id);
CREATE INDEX idx_user_rating_movie ON user_rating(movie_id);

-- ============================================================================
-- Create Views
-- ============================================================================

-- View for high-rated movies
CREATE OR REPLACE VIEW high_rated_movies AS
SELECT movie_id, title, year, imdb_rating
FROM movie
WHERE imdb_rating >= 8.0
ORDER BY imdb_rating DESC;

-- ============================================================================
-- End of CREATE Script
-- ============================================================================
