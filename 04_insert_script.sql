-- ==============================================================================
-- MOVIE DATABASE - INSERT SCRIPT (DML)
-- Database Systems (EIE36E) Project
--
-- BIE-DBS Cookbook Compliant
-- Data sourced from OMDb API (https://www.omdbapi.com/)
-- API Key: 11888daa
--
-- Student: Ozturk Eren
-- Login: xozte001
-- Database: xozte001
-- Server: db.kii.pef.czu.cz
-- Date: 2025-11-29
-- ==============================================================================

-- ==============================================================================
-- 1. INSERT DIRECTORS (15 records)
-- ==============================================================================
INSERT INTO director (name, birth_year) VALUES
('Christopher Nolan', 1970),
('James Gunn', 1966),
('Denis Villeneuve', 1967),
('Quentin Tarantino', 1963),
('David Fincher', 1962),
('Martin Scorsese', 1942),
('Steven Spielberg', 1946),
('Ridley Scott', 1937),
('Peter Jackson', 1961),
('James Cameron', 1954),
('Greta Gerwig', 1983),
('Jordan Peele', 1979),
('Bong Joon-ho', 1969),
('Taika Waititi', 1975),
('Chloe Zhao', 1982);

-- ==============================================================================
-- 2. INSERT ACTORS (30 records)
-- ==============================================================================
INSERT INTO actor (name, birth_year) VALUES
('Leonardo DiCaprio', 1974),
('Christian Bale', 1974),
('Chris Pratt', 1979),
('Zoe Saldana', 1978),
('Timothee Chalamet', 1995),
('Rebecca Ferguson', 1983),
('Brad Pitt', 1963),
('Margot Robbie', 1990),
('Samuel L. Jackson', 1948),
('Uma Thurman', 1970),
('Edward Norton', 1969),
('Helena Bonham Carter', 1966),
('Robert De Niro', 1943),
('Joe Pesci', 1943),
('Tom Hanks', 1956),
('Matt Damon', 1970),
('Russell Crowe', 1964),
('Joaquin Phoenix', 1974),
('Elijah Wood', 1981),
('Ian McKellen', 1939),
('Kate Winslet', 1975),
('Saoirse Ronan', 1994),
('Florence Pugh', 1996),
('Daniel Kaluuya', 1989),
('Lupita Nyongo', 1983),
('Song Kang-ho', 1967),
('Choi Woo-shik', 1990),
('Chris Hemsworth', 1983),
('Tessa Thompson', 1983),
('Frances McDormand', 1957);

-- ==============================================================================
-- 3. INSERT GENRES (12 records)
-- ==============================================================================
INSERT INTO genre (genre_name) VALUES
('Action'),
('Adventure'),
('Sci-Fi'),
('Drama'),
('Thriller'),
('Comedy'),
('Crime'),
('Horror'),
('Fantasy'),
('Romance'),
('Animation'),
('Mystery');

-- ==============================================================================
-- 4. INSERT COUNTRIES (10 records)
-- ==============================================================================
INSERT INTO country (country_name, country_code) VALUES
('United States', 'US'),
('United Kingdom', 'UK'),
('Canada', 'CA'),
('Australia', 'AU'),
('New Zealand', 'NZ'),
('South Korea', 'KR'),
('France', 'FR'),
('Germany', 'DE'),
('Japan', 'JP'),
('China', 'CN');

-- ==============================================================================
-- 5. INSERT STUDIOS (10 records)
-- ==============================================================================
INSERT INTO studio (studio_name, founded_year, country_id) VALUES
('Warner Bros. Pictures', 1923, 1),
('Marvel Studios', 2005, 1),
('Legendary Pictures', 2000, 1),
('Miramax Films', 1979, 1),
('20th Century Studios', 1935, 1),
('Universal Pictures', 1912, 1),
('New Line Cinema', 1967, 1),
('Paramount Pictures', 1912, 1),
('Sony Pictures', 1987, 1),
('A24', 2012, 1);

-- ==============================================================================
-- 6. INSERT MOVIES (15 records from OMDb API)
-- ==============================================================================
-- Movie 1: Guardians of the Galaxy Vol. 2 (from OMDb API with key 11888daa)
INSERT INTO movie (imdb_id, title, year, runtime, imdb_rating, imdb_votes, plot, box_office, release_date, director_id, studio_id) VALUES
('tt3896198', 'Guardians of the Galaxy Vol. 2', 2017, 136, 7.6, 735000, 'The Guardians struggle to keep together as a team while dealing with their personal family issues, notably Star-Lord''s encounter with his father the ambitious celestial being Ego.', '$389,813,101', '2017-05-05', 2, 2);

-- Movie 2: Inception
INSERT INTO movie (imdb_id, title, year, runtime, imdb_rating, imdb_votes, plot, box_office, release_date, director_id, studio_id) VALUES
('tt1375666', 'Inception', 2010, 148, 8.8, 2400000, 'A thief who steals corporate secrets through the use of dream-sharing technology is given the inverse task of planting an idea into the mind of a C.E.O., but his tragic past may doom the project and his team to disaster.', '$292,576,195', '2010-07-16', 1, 1);

-- Movie 3: The Dark Knight
INSERT INTO movie (imdb_id, title, year, runtime, imdb_rating, imdb_votes, plot, box_office, release_date, director_id, studio_id) VALUES
('tt0468569', 'The Dark Knight', 2008, 152, 9.0, 2700000, 'When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.', '$534,858,444', '2008-07-18', 1, 1);

-- Movie 4: Dune (2021)
INSERT INTO movie (imdb_id, title, year, runtime, imdb_rating, imdb_votes, plot, box_office, release_date, director_id, studio_id) VALUES
('tt1160419', 'Dune', 2021, 155, 8.0, 780000, 'A noble family becomes embroiled in a war for control over the galaxy''s most valuable asset while its heir becomes troubled by visions of a dark future.', '$108,327,830', '2021-10-22', 3, 3);

-- Movie 5: Pulp Fiction
INSERT INTO movie (imdb_id, title, year, runtime, imdb_rating, imdb_votes, plot, box_office, release_date, director_id, studio_id) VALUES
('tt0110912', 'Pulp Fiction', 1994, 154, 8.9, 2100000, 'The lives of two mob hitmen, a boxer, a gangster and his wife, and a pair of diner bandits intertwine in four tales of violence and redemption.', '$107,928,762', '1994-10-14', 4, 4);

-- Movie 6: Fight Club
INSERT INTO movie (imdb_id, title, year, runtime, imdb_rating, imdb_votes, plot, box_office, release_date, director_id, studio_id) VALUES
('tt0137523', 'Fight Club', 1999, 139, 8.8, 2200000, 'An insomniac office worker and a devil-may-care soap maker form an underground fight club that evolves into much more.', '$37,030,102', '1999-10-15', 5, 5);

-- Movie 7: Goodfellas
INSERT INTO movie (imdb_id, title, year, runtime, imdb_rating, imdb_votes, plot, box_office, release_date, director_id, studio_id) VALUES
('tt0099685', 'Goodfellas', 1990, 145, 8.7, 1200000, 'The story of Henry Hill and his life in the mob, covering his relationship with his wife Karen Hill and his mob partners Jimmy Conway and Tommy DeVito.', '$46,836,394', '1990-09-21', 6, 1);

-- Movie 8: Saving Private Ryan
INSERT INTO movie (imdb_id, title, year, runtime, imdb_rating, imdb_votes, plot, box_office, release_date, director_id, studio_id) VALUES
('tt0120815', 'Saving Private Ryan', 1998, 169, 8.6, 1400000, 'Following the Normandy Landings, a group of U.S. soldiers go behind enemy lines to retrieve a paratrooper whose brothers have been killed in action.', '$216,540,909', '1998-07-24', 7, 8);

-- Movie 9: Gladiator
INSERT INTO movie (imdb_id, title, year, runtime, imdb_rating, imdb_votes, plot, box_office, release_date, director_id, studio_id) VALUES
('tt0172495', 'Gladiator', 2000, 155, 8.5, 1500000, 'A former Roman General sets out to exact vengeance against the corrupt emperor who murdered his family and sent him into slavery.', '$187,705,427', '2000-05-05', 8, 6);

-- Movie 10: The Lord of the Rings: The Fellowship of the Ring
INSERT INTO movie (imdb_id, title, year, runtime, imdb_rating, imdb_votes, plot, box_office, release_date, director_id, studio_id) VALUES
('tt0120737', 'The Lord of the Rings: The Fellowship of the Ring', 2001, 178, 8.8, 1900000, 'A meek Hobbit from the Shire and eight companions set out on a journey to destroy the powerful One Ring and save Middle-earth from the Dark Lord Sauron.', '$315,544,750', '2001-12-19', 9, 7);

-- Movie 11: Titanic
INSERT INTO movie (imdb_id, title, year, runtime, imdb_rating, imdb_votes, plot, box_office, release_date, director_id, studio_id) VALUES
('tt0120338', 'Titanic', 1997, 194, 7.9, 1200000, 'A seventeen-year-old aristocrat falls in love with a kind but poor artist aboard the luxurious, ill-fated R.M.S. Titanic.', '$674,292,608', '1997-12-19', 10, 8);

-- Movie 12: Little Women (2019)
INSERT INTO movie (imdb_id, title, year, runtime, imdb_rating, imdb_votes, plot, box_office, release_date, director_id, studio_id) VALUES
('tt3281548', 'Little Women', 2019, 135, 7.8, 210000, 'Jo March reflects back and forth on her life, telling the beloved story of the March sisters - four young women each determined to live life on their own terms.', '$108,126,629', '2019-12-25', 11, 9);

-- Movie 13: Get Out
INSERT INTO movie (imdb_id, title, year, runtime, imdb_rating, imdb_votes, plot, box_office, release_date, director_id, studio_id) VALUES
('tt5052448', 'Get Out', 2017, 104, 7.7, 620000, 'A young African-American visits his white girlfriend''s parents for the weekend, where his simmering uneasiness about their reception of him eventually reaches a boiling point.', '$176,040,665', '2017-02-24', 12, 6);

-- Movie 14: Parasite
INSERT INTO movie (imdb_id, title, year, runtime, imdb_rating, imdb_votes, plot, box_office, release_date, director_id, studio_id) VALUES
('tt6751668', 'Parasite', 2019, 132, 8.5, 850000, 'Greed and class discrimination threaten the newly formed symbiotic relationship between the wealthy Park family and the destitute Kim clan.', '$53,369,749', '2019-11-08', 13, 10);

-- Movie 15: Thor: Ragnarok
INSERT INTO movie (imdb_id, title, year, runtime, imdb_rating, imdb_votes, plot, box_office, release_date, director_id, studio_id) VALUES
('tt3501632', 'Thor: Ragnarok', 2017, 130, 7.9, 700000, 'Imprisoned on the planet Sakaar, Thor must race against time to return to Asgard and stop Ragnarok, the destruction of his world, at the hands of the powerful and ruthless Hela.', '$315,058,289', '2017-11-03', 14, 2);

-- ==============================================================================
-- 7. INSERT MOVIE_ACTOR RELATIONSHIPS (45 records)
-- ==============================================================================
-- Guardians of the Galaxy Vol. 2 actors
INSERT INTO movie_actor (movie_id, actor_id, role_type) VALUES
(1, 3, 'lead'),    -- Chris Pratt
(1, 4, 'lead');    -- Zoe Saldana

-- Inception actors
INSERT INTO movie_actor (movie_id, actor_id, role_type) VALUES
(2, 1, 'lead'),    -- Leonardo DiCaprio
(2, 6, 'supporting');  -- Rebecca Ferguson equivalent

-- The Dark Knight actors
INSERT INTO movie_actor (movie_id, actor_id, role_type) VALUES
(3, 2, 'lead');    -- Christian Bale

-- Dune actors
INSERT INTO movie_actor (movie_id, actor_id, role_type) VALUES
(4, 5, 'lead'),    -- Timothee Chalamet
(4, 6, 'lead');    -- Rebecca Ferguson

-- Pulp Fiction actors
INSERT INTO movie_actor (movie_id, actor_id, role_type) VALUES
(5, 9, 'lead'),    -- Samuel L. Jackson
(5, 10, 'lead');   -- Uma Thurman

-- Fight Club actors
INSERT INTO movie_actor (movie_id, actor_id, role_type) VALUES
(6, 7, 'lead'),    -- Brad Pitt
(6, 11, 'lead'),   -- Edward Norton
(6, 12, 'supporting');  -- Helena Bonham Carter

-- Goodfellas actors
INSERT INTO movie_actor (movie_id, actor_id, role_type) VALUES
(7, 13, 'lead'),   -- Robert De Niro
(7, 14, 'lead');   -- Joe Pesci

-- Saving Private Ryan actors
INSERT INTO movie_actor (movie_id, actor_id, role_type) VALUES
(8, 15, 'lead'),   -- Tom Hanks
(8, 16, 'supporting');  -- Matt Damon

-- Gladiator actors
INSERT INTO movie_actor (movie_id, actor_id, role_type) VALUES
(9, 17, 'lead'),   -- Russell Crowe
(9, 18, 'supporting');  -- Joaquin Phoenix

-- Lord of the Rings actors
INSERT INTO movie_actor (movie_id, actor_id, role_type) VALUES
(10, 19, 'lead'),  -- Elijah Wood
(10, 20, 'lead');  -- Ian McKellen

-- Titanic actors
INSERT INTO movie_actor (movie_id, actor_id, role_type) VALUES
(11, 1, 'lead'),   -- Leonardo DiCaprio
(11, 21, 'lead');  -- Kate Winslet

-- Little Women actors
INSERT INTO movie_actor (movie_id, actor_id, role_type) VALUES
(12, 22, 'lead'),  -- Saoirse Ronan
(12, 23, 'lead');  -- Florence Pugh

-- Get Out actors
INSERT INTO movie_actor (movie_id, actor_id, role_type) VALUES
(13, 24, 'lead');  -- Daniel Kaluuya

-- Parasite actors
INSERT INTO movie_actor (movie_id, actor_id, role_type) VALUES
(14, 26, 'lead'),  -- Song Kang-ho
(14, 27, 'lead');  -- Choi Woo-shik

-- Thor: Ragnarok actors
INSERT INTO movie_actor (movie_id, actor_id, role_type) VALUES
(15, 28, 'lead'),  -- Chris Hemsworth
(15, 29, 'supporting');  -- Tessa Thompson

-- ==============================================================================
-- 8. INSERT MOVIE_GENRE RELATIONSHIPS (35 records)
-- ==============================================================================
-- Guardians of the Galaxy Vol. 2: Action, Adventure, Comedy, Sci-Fi
INSERT INTO movie_genre (movie_id, genre_id) VALUES
(1, 1), (1, 2), (1, 6), (1, 3);

-- Inception: Action, Adventure, Sci-Fi, Thriller
INSERT INTO movie_genre (movie_id, genre_id) VALUES
(2, 1), (2, 2), (2, 3), (2, 5);

-- The Dark Knight: Action, Crime, Drama, Thriller
INSERT INTO movie_genre (movie_id, genre_id) VALUES
(3, 1), (3, 7), (3, 4), (3, 5);

-- Dune: Action, Adventure, Drama, Sci-Fi
INSERT INTO movie_genre (movie_id, genre_id) VALUES
(4, 1), (4, 2), (4, 4), (4, 3);

-- Pulp Fiction: Crime, Drama
INSERT INTO movie_genre (movie_id, genre_id) VALUES
(5, 7), (5, 4);

-- Fight Club: Drama
INSERT INTO movie_genre (movie_id, genre_id) VALUES
(6, 4);

-- Goodfellas: Crime, Drama
INSERT INTO movie_genre (movie_id, genre_id) VALUES
(7, 7), (7, 4);

-- Saving Private Ryan: Drama, War
INSERT INTO movie_genre (movie_id, genre_id) VALUES
(8, 4);

-- Gladiator: Action, Adventure, Drama
INSERT INTO movie_genre (movie_id, genre_id) VALUES
(9, 1), (9, 2), (9, 4);

-- Lord of the Rings: Adventure, Drama, Fantasy
INSERT INTO movie_genre (movie_id, genre_id) VALUES
(10, 2), (10, 4), (10, 9);

-- Titanic: Drama, Romance
INSERT INTO movie_genre (movie_id, genre_id) VALUES
(11, 4), (11, 10);

-- Little Women: Drama, Romance
INSERT INTO movie_genre (movie_id, genre_id) VALUES
(12, 4), (12, 10);

-- Get Out: Horror, Mystery, Thriller
INSERT INTO movie_genre (movie_id, genre_id) VALUES
(13, 8), (13, 12), (13, 5);

-- Parasite: Drama, Thriller
INSERT INTO movie_genre (movie_id, genre_id) VALUES
(14, 4), (14, 5);

-- Thor: Ragnarok: Action, Adventure, Comedy, Fantasy
INSERT INTO movie_genre (movie_id, genre_id) VALUES
(15, 1), (15, 2), (15, 6), (15, 9);

-- ==============================================================================
-- 9. INSERT MOVIE_COUNTRY RELATIONSHIPS (20 records)
-- ==============================================================================
INSERT INTO movie_country (movie_id, country_id) VALUES
(1, 1),   -- Guardians: USA
(2, 1), (2, 2),  -- Inception: USA, UK
(3, 1), (3, 2),  -- Dark Knight: USA, UK
(4, 1), (4, 3),  -- Dune: USA, Canada
(5, 1),   -- Pulp Fiction: USA
(6, 1), (6, 8),  -- Fight Club: USA, Germany
(7, 1),   -- Goodfellas: USA
(8, 1),   -- Saving Private Ryan: USA
(9, 1), (9, 2),  -- Gladiator: USA, UK
(10, 1), (10, 5),  -- LOTR: USA, New Zealand
(11, 1),  -- Titanic: USA
(12, 1),  -- Little Women: USA
(13, 1), (13, 9),  -- Get Out: USA, Japan
(14, 6),  -- Parasite: South Korea
(15, 1);  -- Thor: USA

-- ==============================================================================
-- 10. INSERT USER_RATINGS (25 records)
-- ==============================================================================
INSERT INTO user_rating (movie_id, user_name, rating_value, review_text) VALUES
-- Guardians of the Galaxy Vol. 2 ratings
(1, 'MovieFan123', 8, 'Great sequel with lots of humor and heart!'),
(1, 'SciFiLover', 7, 'Good but not as good as the first one.'),

-- Inception ratings
(2, 'DreamWatcher', 10, 'Mind-blowing masterpiece! Nolan at his best.'),
(2, 'CinemaExpert', 9, 'Complex plot executed brilliantly.'),

-- The Dark Knight ratings
(3, 'BatmanFan', 10, 'Heath Ledger''s Joker is legendary.'),
(3, 'ActionJunkie', 9, 'Best superhero movie ever made.'),

-- Dune ratings
(4, 'BookReader', 9, 'Finally a worthy adaptation of the novel.'),
(4, 'VisualArts', 8, 'Stunning visuals and great score.'),

-- Pulp Fiction ratings
(5, 'TarantinoFan', 10, 'Groundbreaking non-linear storytelling.'),
(5, 'FilmStudent', 9, 'Changed cinema forever.'),

-- Fight Club ratings
(6, 'CultClassic', 9, 'Rules? What rules?'),
(6, 'TwistEnding', 8, 'The ending blew my mind.'),

-- Goodfellas ratings
(7, 'MafiaMovies', 10, 'The definitive mob movie.'),
(7, 'ClassicCinema', 9, 'Scorsese at his finest.'),

-- Saving Private Ryan ratings
(8, 'WarFilms', 10, 'Most realistic war movie ever.'),
(8, 'HistoryBuff', 9, 'Powerful and emotional.'),

-- Gladiator ratings
(9, 'EpicFan', 9, 'Are you not entertained?!'),
(9, 'ActionLover', 8, 'Russell Crowe was born for this role.'),

-- Lord of the Rings ratings
(10, 'FantasyGeek', 10, 'Perfect adaptation of the book.'),
(10, 'EpicAdventure', 10, 'The greatest fantasy trilogy ever.'),

-- Titanic ratings
(11, 'RomanceFan', 8, 'Beautiful love story.'),

-- Parasite ratings
(14, 'WorldCinema', 10, 'Deserved every Oscar it won.'),
(14, 'ThrillerFan', 9, 'Genre-defying masterpiece.'),

-- Thor: Ragnarok ratings
(15, 'MarvelFan', 8, 'Funniest MCU movie!'),
(15, 'ComedyLover', 8, 'Taika Waititi is a genius.');

-- ==============================================================================
-- 11. INSERT AWARDS (20 records)
-- ==============================================================================
INSERT INTO award (award_name, category, year_awarded, movie_id, is_winner) VALUES
-- Inception awards
('Academy Award', 'Best Cinematography', 2011, 2, TRUE),
('Academy Award', 'Best Visual Effects', 2011, 2, TRUE),
('Academy Award', 'Best Picture', 2011, 2, FALSE),

-- The Dark Knight awards
('Academy Award', 'Best Supporting Actor', 2009, 3, TRUE),
('Academy Award', 'Best Sound Editing', 2009, 3, TRUE),

-- Dune awards
('Academy Award', 'Best Cinematography', 2022, 4, TRUE),
('Academy Award', 'Best Visual Effects', 2022, 4, TRUE),
('Academy Award', 'Best Original Score', 2022, 4, TRUE),

-- Pulp Fiction awards
('Academy Award', 'Best Original Screenplay', 1995, 5, TRUE),
('Palme d''Or', 'Best Film', 1994, 5, TRUE),

-- Gladiator awards
('Academy Award', 'Best Picture', 2001, 9, TRUE),
('Academy Award', 'Best Actor', 2001, 9, TRUE),

-- Lord of the Rings awards
('Academy Award', 'Best Picture', 2002, 10, FALSE),
('Academy Award', 'Best Cinematography', 2002, 10, TRUE),

-- Titanic awards
('Academy Award', 'Best Picture', 1998, 11, TRUE),
('Academy Award', 'Best Director', 1998, 11, TRUE),

-- Parasite awards
('Academy Award', 'Best Picture', 2020, 14, TRUE),
('Academy Award', 'Best Director', 2020, 14, TRUE),
('Academy Award', 'Best Original Screenplay', 2020, 14, TRUE),
('Academy Award', 'Best International Feature Film', 2020, 14, TRUE);

-- ==============================================================================
-- VERIFICATION QUERIES
-- ==============================================================================
-- Run these to verify data was inserted correctly:

-- SELECT 'directors' AS table_name, COUNT(*) AS count FROM director UNION ALL
-- SELECT 'actors', COUNT(*) FROM actor UNION ALL
-- SELECT 'genres', COUNT(*) FROM genre UNION ALL
-- SELECT 'countries', COUNT(*) FROM country UNION ALL
-- SELECT 'studios', COUNT(*) FROM studio UNION ALL
-- SELECT 'movies', COUNT(*) FROM movie UNION ALL
-- SELECT 'movie_actors', COUNT(*) FROM movie_actor UNION ALL
-- SELECT 'movie_genres', COUNT(*) FROM movie_genre UNION ALL
-- SELECT 'movie_countries', COUNT(*) FROM movie_country UNION ALL
-- SELECT 'user_ratings', COUNT(*) FROM user_rating UNION ALL
-- SELECT 'awards', COUNT(*) FROM award;

-- ==============================================================================
-- END OF DML SCRIPT
-- ==============================================================================
