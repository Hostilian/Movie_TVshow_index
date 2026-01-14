-- ============================================================================
-- Movie and TV Database Management System - INSERT Script
-- Database: PostgreSQL
-- Author: xozte001
-- Date: 2026-01-14
-- ============================================================================

-- Insert Countries
INSERT INTO country (country_name, country_code) VALUES
('United States', 'US'),
('United Kingdom', 'UK'),
('Canada', 'CA'),
('Australia', 'AU'),
('New Zealand', 'NZ');

-- Insert Genres
INSERT INTO genre (genre_name) VALUES
('Action'),
('Adventure'),
('Sci-Fi'),
('Drama'),
('Thriller'),
('Comedy'),
('Crime'),
('Mystery'),
('Fantasy'),
('War'),
('Animation'),
('Romance'),
('Horror');

-- Insert Studios
INSERT INTO studio (studio_name, founded_year, country_id) VALUES
('Warner Bros. Pictures', 1923, 1),
('Marvel Studios', 2005, 1),
('Legendary Pictures', 2000, 1),
('Miramax Films', 1979, 1),
('20th Century Studios', 1935, 1),
('DreamWorks Pictures', 1994, 1),
('New Line Cinema', 1967, 1),
('Paramount Pictures', 1912, 1),
('Sony Pictures', 1987, 1),
('A24', 2012, 1);

-- Insert Directors
INSERT INTO director (name, birth_date, nationality) VALUES
('Christopher Nolan', '1970-07-30', 'British-American'),
('James Gunn', '1966-08-05', 'American'),
('Denis Villeneuve', '1967-10-03', 'Canadian'),
('Quentin Tarantino', '1963-03-27', 'American'),
('David Fincher', '1962-08-28', 'American'),
('Steven Spielberg', '1946-12-18', 'American'),
('Martin Scorsese', '1942-11-17', 'American'),
('Ridley Scott', '1937-11-30', 'British'),
('Peter Jackson', '1961-10-31', 'New Zealander'),
('James Cameron', '1954-08-16', 'Canadian'),
('Greta Gerwig', '1983-08-04', 'American'),
('Jordan Peele', '1979-02-21', 'American'),
('Bong Joon-ho', '1969-09-14', 'South Korean'),
('Taika Waititi', '1975-08-16', 'New Zealander');

-- Add more directors for testing queries (directors with no movies)
INSERT INTO director (name, birth_date, nationality) VALUES
('Director 15', '1980-01-01', 'American'),
('Director 16', '1981-01-01', 'American'),
('Director 17', '1982-01-01', 'American'),
('Director 18', '1983-01-01', 'American'),
('Director 19', '1984-01-01', 'American'),
('Director 20', '1985-01-01', 'American'),
('Director 21', '1986-01-01', 'American'),
('Director 22', '1987-01-01', 'American'),
('Director 23', '1988-01-01', 'American'),
('Director 24', '1989-01-01', 'American'),
('Director 25', '1990-01-01', 'American'),
('Director 26', '1991-01-01', 'American'),
('Director 27', '1992-01-01', 'American'),
('Director 28', '1993-01-01', 'American'),
('Director 29', '1994-01-01', 'American'),
('Director 30', '1995-01-01', 'American'),
('Director 31', '1996-01-01', 'American'),
('Director 32', '1997-01-01', 'American'),
('Director 33', '1998-01-01', 'American'),
('Director 34', '1999-01-01', 'American'),
('Director 35', '2000-01-01', 'American'),
('Director 36', '2001-01-01', 'American'),
('Director 37', '2002-01-01', 'American'),
('Director 38', '2003-01-01', 'American'),
('Director 39', '2004-01-01', 'American'),
('Director 40', '2005-01-01', 'American'),
('Director 41', '2006-01-01', 'American'),
('Director 42', '2007-01-01', 'American'),
('Director 43', '2008-01-01', 'American'),
('Director 44', '2009-01-01', 'American'),
('Director 45', '2010-01-01', 'American');

-- Insert Actors
INSERT INTO actor (name, birth_date, nationality) VALUES
('Christian Bale', '1974-01-30', 'British'),
('Leonardo DiCaprio', '1974-11-11', 'American'),
('Chris Pratt', '1979-06-21', 'American'),
('Timothée Chalamet', '1995-12-27', 'American'),
('John Travolta', '1954-02-18', 'American'),
('Edward Norton', '1969-08-18', 'American'),
('Brad Pitt', '1963-12-18', 'American'),
('Robert De Niro', '1943-08-17', 'American'),
('Tom Hanks', '1956-07-09', 'American'),
('Elijah Wood', '1981-01-28', 'American');

-- Insert Movies
INSERT INTO movie (imdb_id, title, year, runtime, imdb_rating, imdb_votes, plot, box_office, release_date, director_id, studio_id) VALUES
('tt3896198', 'Guardians of the Galaxy Vol. 2', 2017, 136, 7.6, 735000, 'The Guardians struggle to keep together as a team while dealing with their personal family issues.', '$389,813,101', '2017-05-05', 2, 2),
('tt1375666', 'Inception', 2010, 148, 9.3, 2400000, 'A thief who steals corporate secrets through dream-sharing technology is given the task of planting an idea.', '$292,576,195', '2010-07-16', 1, 1),
('tt0468569', 'The Dark Knight', 2008, 152, 9.5, 2700000, 'When the menace known as the Joker wreaks havoc on Gotham, Batman must accept one of the greatest tests.', '$534,858,444', '2008-07-18', 1, 1),
('tt1160419', 'Dune', 2021, 156, 8.5, 780000, 'A noble family becomes embroiled in a war for control over the galaxys most valuable asset.', '$108,327,830', '2021-10-22', 3, 3),
('tt0110912', 'Pulp Fiction', 1994, 154, 9.4, 2100000, 'The lives of two mob hitmen, a boxer, a gangster and his wife intertwine in four tales of violence.', '$107,928,762', '1994-10-14', 4, 4),
('tt0137523', 'Fight Club', 1999, 139, 8.8, 2200000, 'An insomniac office worker and a soap maker form an underground fight club that evolves into much more.', '$37,030,102', '1999-10-15', 5, 5),
('tt0099685', 'Goodfellas', 1990, 146, 8.7, 1100000, 'The story of Henry Hill and his life in the mob, covering his relationship with his wife and friends.', '$46,836,394', '1990-09-21', 7, 1),
('tt0120815', 'Saving Private Ryan', 1998, 169, 8.6, 1400000, 'Following the Normandy Landings, a group of soldiers goes behind enemy lines to retrieve a paratrooper.', '$217,049,603', '1998-07-24', 6, 6),
('tt0172495', 'Gladiator', 2000, 155, 9.0, 1500000, 'A former Roman General sets out to exact vengeance against the corrupt emperor who murdered his family.', '$187,705,427', '2000-05-05', 8, 6),
('tt0120737', 'The Lord of the Rings: The Fellowship of the Ring', 2001, 178, 9.3, 1900000, 'A meek Hobbit and eight companions set out on a journey to destroy the powerful One Ring.', '$315,544,750', '2001-12-19', 9, 7),
('tt0120338', 'Titanic', 1997, 194, 8.4, 1200000, 'A seventeen-year-old aristocrat falls in love with a kind but poor artist aboard the ill-fated Titanic.', '$674,292,608', '1997-12-19', 10, 8),
('tt3281548', 'Little Women', 2019, 135, 7.8, 210000, 'Jo March reflects on her life, telling the story of the March sisters determined to live on their own terms.', '$108,126,629', '2019-12-25', 11, 9),
('tt5052448', 'Get Out', 2017, 104, 7.7, 620000, 'A young African-American visits his white girlfriends parents for the weekend with unsettling results.', '$176,040,665', '2017-02-24', 12, 6),
('tt6751668', 'Parasite', 2019, 132, 9.0, 850000, 'Greed and class discrimination threaten the relationship between the wealthy Park family and the Kim clan.', '$53,369,749', '2019-11-08', 13, 10),
('tt3501632', 'Thor: Ragnarok', 2017, 130, 7.9, 750000, 'Thor is imprisoned and must race against time to return to Asgard to stop Ragnarok.', '$315,058,289', '2017-11-03', 14, 2);

-- Insert Awards
INSERT INTO award (award_name, category, year_awarded, movie_id, is_winner) VALUES
('Academy Award', 'Best Picture', 2011, 2, TRUE),
('Academy Award', 'Best Cinematography', 2011, 2, TRUE),
('Academy Award', 'Best Sound Editing', 2011, 2, TRUE),
('Academy Award', 'Best Sound Mixing', 2011, 2, TRUE),
('Academy Award', 'Best Visual Effects', 2011, 2, TRUE),
('Academy Award', 'Best Film Editing', 2011, 2, TRUE),
('Academy Award', 'Best Sound Editing', 2009, 3, TRUE),
('Academy Award', 'Best Sound Mixing', 2009, 3, TRUE),
('Academy Award', 'Best Supporting Actor', 2009, 3, TRUE),
('Academy Award', 'Best Cinematography', 2022, 4, TRUE),
('Academy Award', 'Best Film Editing', 2022, 4, TRUE),
('Academy Award', 'Best Sound', 2022, 4, TRUE),
('Academy Award', 'Best Original Screenplay', 1995, 5, TRUE),
('Academy Award', 'Best Actor', 1995, 5, FALSE),
('Academy Award', 'Best Director', 1995, 5, FALSE),
('Academy Award', 'Best Picture', 1995, 5, FALSE),
('Academy Award', 'Best Editing', 1995, 5, FALSE),
('Academy Award', 'Best Supporting Actress', 1995, 5, FALSE),
('Academy Award', 'Best Picture', 2001, 9, TRUE),
('Academy Award', 'Best Actor', 2001, 9, TRUE),
('Academy Award', 'Best Cinematography', 2001, 9, TRUE),
('Academy Award', 'Best Costume Design', 2001, 9, TRUE),
('Academy Award', 'Best Sound', 2001, 9, TRUE),
('Academy Award', 'Best Picture', 2002, 10, TRUE),
('Academy Award', 'Best Director', 2002, 10, TRUE),
('Academy Award', 'Best Cinematography', 2002, 10, TRUE),
('Academy Award', 'Best Makeup', 2002, 10, TRUE),
('Academy Award', 'Best Original Score', 2002, 10, TRUE),
('Academy Award', 'Best Visual Effects', 2002, 10, TRUE),
('Academy Award', 'Best Picture', 1998, 11, TRUE),
('Academy Award', 'Best Director', 1998, 11, TRUE),
('Academy Award', 'Best Cinematography', 1998, 11, TRUE),
('Academy Award', 'Best Film Editing', 1998, 11, TRUE),
('Academy Award', 'Best Original Song', 1998, 11, TRUE),
('Academy Award', 'Best Picture', 2020, 14, TRUE),
('Academy Award', 'Best Director', 2020, 14, TRUE),
('Academy Award', 'Best Original Screenplay', 2020, 14, TRUE),
('Academy Award', 'Best Film Editing', 2020, 14, TRUE);

-- Insert Movie-Actor relationships
INSERT INTO movie_actor (movie_id, actor_id, role_name, is_lead) VALUES
(1, 3, 'Peter Quill', TRUE),
(2, 2, 'Dom Cobb', TRUE),
(3, 1, 'Bruce Wayne', TRUE),
(4, 4, 'Paul Atreides', TRUE),
(5, 5, 'Vincent Vega', TRUE),
(6, 6, 'Narrator', TRUE),
(6, 7, 'Tyler Durden', TRUE),
(7, 8, 'James Conway', TRUE),
(8, 9, 'Captain Miller', TRUE),
(10, 10, 'Frodo Baggins', TRUE);

-- Insert Movie-Genre relationships
INSERT INTO movie_genre (movie_id, genre_id) VALUES
(1, 1), (1, 2), (1, 6), (1, 3),  -- Guardians: Action, Adventure, Comedy, Sci-Fi
(2, 1), (2, 3), (2, 5),          -- Inception: Action, Sci-Fi, Thriller
(3, 1), (3, 7), (3, 4),          -- Dark Knight: Action, Crime, Drama
(4, 1), (4, 2), (4, 3),          -- Dune: Action, Adventure, Sci-Fi
(5, 7), (5, 4),                  -- Pulp Fiction: Crime, Drama
(6, 4),                          -- Fight Club: Drama
(7, 7), (7, 4),                  -- Goodfellas: Crime, Drama
(8, 4), (8, 10),                 -- Saving Private Ryan: Drama, War
(9, 1), (9, 2), (9, 4),          -- Gladiator: Action, Adventure, Drama
(10, 2), (10, 4), (10, 9),       -- LOTR: Adventure, Drama, Fantasy
(11, 4), (11, 12),               -- Titanic: Drama, Romance
(12, 4), (12, 12),               -- Little Women: Drama, Romance
(13, 13), (13, 8), (13, 5),      -- Get Out: Horror, Mystery, Thriller
(14, 4), (14, 5),                -- Parasite: Drama, Thriller
(15, 1), (15, 2), (15, 6);       -- Thor: Action, Adventure, Comedy

-- Insert User Ratings
INSERT INTO user_rating (movie_id, user_name, rating_value, review_text) VALUES
(1, 'MovieFan123', 8, 'Great sequel with lots of humor!'),
(2, 'DreamWatcher', 10, 'Mind-blowing masterpiece!'),
(2, 'InceptionFan', 9, 'Complex but amazing'),
(3, 'BatmanLover', 10, 'Best Batman movie ever!'),
(3, 'ActionJunkie', 9, 'Best superhero movie ever made.'),
(4, 'SciFiGeek', 9, 'Visually stunning adaptation'),
(5, 'TarantinoFan', 10, 'Groundbreaking storytelling.'),
(5, 'ClassicLover', 10, 'Timeless classic'),
(6, 'ThrillerFan', 9, 'Mind-bending experience'),
(7, 'MafiaMovieFan', 9, 'Greatest mob movie'),
(8, 'HistoryBuff', 9, 'Powerful war film'),
(9, 'EpicFan', 9, 'Epic story of revenge'),
(10, 'FantasyLover', 10, 'Best fantasy trilogy'),
(10, 'LOTRFan', 10, 'Perfect adaptation'),
(11, 'RomanceFan', 8, 'Beautiful love story'),
(12, 'BookReader', 8, 'Wonderful adaptation'),
(13, 'HorrorFan', 8, 'Clever social commentary'),
(14, 'ArtFilmLover', 10, 'Brilliant social satire');

-- Add more user ratings to reach at least 45 records
INSERT INTO user_rating (movie_id, user_name, rating_value, review_text) VALUES
(1, 'User1', 7, 'Good movie'),
(1, 'User2', 8, 'Really enjoyed it'),
(2, 'User3', 9, 'Amazing visuals'),
(2, 'User4', 8, 'Great concept'),
(3, 'User5', 10, 'Perfect superhero film'),
(3, 'User6', 9, 'Dark and compelling'),
(4, 'User7', 8, 'Great adaptation'),
(4, 'BookReader', 9, 'Finally a worthy adaptation.'),
(5, 'User8', 10, 'Best Tarantino film'),
(5, 'User9', 9, 'Iconic scenes'),
(6, 'User10', 9, 'Deep and thought-provoking'),
(7, 'User11', 8, 'Classic gangster movie'),
(8, 'User12', 9, 'Emotional and powerful'),
(9, 'User13', 9, 'Russell Crowe at his best'),
(10, 'User14', 10, 'Epic adventure'),
(11, 'User15', 7, 'Long but beautiful'),
(12, 'User16', 8, 'Heartwarming story'),
(13, 'User17', 8, 'Scary and smart'),
(14, 'User18', 10, 'Masterpiece'),
(15, 'User19', 7, 'Fun Marvel movie'),
(1, 'User20', 8, 'Space adventure'),
(2, 'User21', 10, 'Nolan genius'),
(3, 'User22', 10, 'Heath Ledger amazing'),
(4, 'User23', 9, 'Spectacular visuals'),
(5, 'User24', 9, 'Quotable dialogue'),
(6, 'User25', 8, 'Twisted and dark'),
(7, 'User26', 9, 'Scorsese classic');

-- ============================================================================
-- End of INSERT Script
-- ============================================================================
