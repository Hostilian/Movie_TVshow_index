-- ==============================================================================
-- MOVIE DATABASE - INSERT SCRIPT (DML) - For Portal Import
-- ==============================================================================

-- 1. DIRECTORS (15 records)
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

-- 2. ACTORS (30 records)
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

-- 3. GENRES (12 records)
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

-- 4. COUNTRIES (10 records)
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

-- 5. STUDIOS (10 records)
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

-- 6. MOVIES (15 records)
INSERT INTO movie (imdb_id, title, year, runtime, imdb_rating, imdb_votes, plot, box_office, release_date, director_id, studio_id) VALUES
('tt3896198', 'Guardians of the Galaxy Vol. 2', 2017, 136, 7.6, 735000, 'The Guardians struggle to keep together as a team while dealing with their personal family issues.', '$389,813,101', '2017-05-05', 2, 2),
('tt1375666', 'Inception', 2010, 148, 8.8, 2400000, 'A thief who steals corporate secrets through dream-sharing technology is given the task of planting an idea.', '$292,576,195', '2010-07-16', 1, 1),
('tt0468569', 'The Dark Knight', 2008, 152, 9.0, 2700000, 'When the menace known as the Joker wreaks havoc on Gotham, Batman must accept one of the greatest tests.', '$534,858,444', '2008-07-18', 1, 1),
('tt1160419', 'Dune', 2021, 155, 8.0, 780000, 'A noble family becomes embroiled in a war for control over the galaxys most valuable asset.', '$108,327,830', '2021-10-22', 3, 3),
('tt0110912', 'Pulp Fiction', 1994, 154, 8.9, 2100000, 'The lives of two mob hitmen, a boxer, a gangster and his wife intertwine in four tales of violence.', '$107,928,762', '1994-10-14', 4, 4),
('tt0137523', 'Fight Club', 1999, 139, 8.8, 2200000, 'An insomniac office worker and a soap maker form an underground fight club that evolves into much more.', '$37,030,102', '1999-10-15', 5, 5),
('tt0099685', 'Goodfellas', 1990, 145, 8.7, 1200000, 'The story of Henry Hill and his life in the mob, covering his relationship with his mob partners.', '$46,836,394', '1990-09-21', 6, 1),
('tt0120815', 'Saving Private Ryan', 1998, 169, 8.6, 1400000, 'Following the Normandy Landings, a group of U.S. soldiers go behind enemy lines to retrieve a paratrooper.', '$216,540,909', '1998-07-24', 7, 8),
('tt0172495', 'Gladiator', 2000, 155, 8.5, 1500000, 'A former Roman General sets out to exact vengeance against the corrupt emperor who murdered his family.', '$187,705,427', '2000-05-05', 8, 6),
('tt0120737', 'The Lord of the Rings: The Fellowship of the Ring', 2001, 178, 8.8, 1900000, 'A meek Hobbit and eight companions set out on a journey to destroy the powerful One Ring.', '$315,544,750', '2001-12-19', 9, 7),
('tt0120338', 'Titanic', 1997, 194, 7.9, 1200000, 'A seventeen-year-old aristocrat falls in love with a kind but poor artist aboard the ill-fated Titanic.', '$674,292,608', '1997-12-19', 10, 8),
('tt3281548', 'Little Women', 2019, 135, 7.8, 210000, 'Jo March reflects on her life, telling the story of the March sisters determined to live on their own terms.', '$108,126,629', '2019-12-25', 11, 9),
('tt5052448', 'Get Out', 2017, 104, 7.7, 620000, 'A young African-American visits his white girlfriends parents for the weekend with unsettling results.', '$176,040,665', '2017-02-24', 12, 6),
('tt6751668', 'Parasite', 2019, 132, 8.5, 850000, 'Greed and class discrimination threaten the relationship between the wealthy Park family and the Kim clan.', '$53,369,749', '2019-11-08', 13, 10),
('tt3501632', 'Thor: Ragnarok', 2017, 130, 7.9, 700000, 'Thor must race against time to return to Asgard and stop Ragnarok at the hands of the powerful Hela.', '$315,058,289', '2017-11-03', 14, 2);

-- 7. MOVIE_ACTOR (30 records)
INSERT INTO movie_actor (movie_id, actor_id, role_type) VALUES
(1, 3, 'lead'), (1, 4, 'lead'),
(2, 1, 'lead'), (2, 6, 'supporting'),
(3, 2, 'lead'),
(4, 5, 'lead'), (4, 6, 'lead'),
(5, 9, 'lead'), (5, 10, 'lead'),
(6, 7, 'lead'), (6, 11, 'lead'), (6, 12, 'supporting'),
(7, 13, 'lead'), (7, 14, 'lead'),
(8, 15, 'lead'), (8, 16, 'supporting'),
(9, 17, 'lead'), (9, 18, 'supporting'),
(10, 19, 'lead'), (10, 20, 'lead'),
(11, 1, 'lead'), (11, 21, 'lead'),
(12, 22, 'lead'), (12, 23, 'lead'),
(13, 24, 'lead'),
(14, 26, 'lead'), (14, 27, 'lead'),
(15, 28, 'lead'), (15, 29, 'supporting');

-- 8. MOVIE_GENRE (35 records)
INSERT INTO movie_genre (movie_id, genre_id) VALUES
(1, 1), (1, 2), (1, 6), (1, 3),
(2, 1), (2, 2), (2, 3), (2, 5),
(3, 1), (3, 7), (3, 4), (3, 5),
(4, 1), (4, 2), (4, 4), (4, 3),
(5, 7), (5, 4),
(6, 4),
(7, 7), (7, 4),
(8, 4),
(9, 1), (9, 2), (9, 4),
(10, 2), (10, 4), (10, 9),
(11, 4), (11, 10),
(12, 4), (12, 10),
(13, 8), (13, 12), (13, 5),
(14, 4), (14, 5),
(15, 1), (15, 2), (15, 6), (15, 9);

-- 9. MOVIE_COUNTRY (20 records)
INSERT INTO movie_country (movie_id, country_id) VALUES
(1, 1), (2, 1), (2, 2), (3, 1), (3, 2),
(4, 1), (4, 3), (5, 1), (6, 1), (6, 8),
(7, 1), (8, 1), (9, 1), (9, 2), (10, 1),
(10, 5), (11, 1), (12, 1), (13, 1), (14, 6), (15, 1);

-- 10. USER_RATING (20 records)
INSERT INTO user_rating (movie_id, user_name, rating_value, review_text) VALUES
(1, 'MovieFan123', 8, 'Great sequel with lots of humor!'),
(2, 'DreamWatcher', 10, 'Mind-blowing masterpiece!'),
(2, 'CinemaExpert', 9, 'Complex plot executed brilliantly.'),
(3, 'BatmanFan', 10, 'Heath Ledgers Joker is legendary.'),
(3, 'ActionJunkie', 9, 'Best superhero movie ever made.'),
(4, 'BookReader', 9, 'Finally a worthy adaptation.'),
(5, 'TarantinoFan', 10, 'Groundbreaking storytelling.'),
(6, 'CultClassic', 9, 'Iconic film.'),
(7, 'MafiaMovies', 10, 'The definitive mob movie.'),
(8, 'WarFilms', 10, 'Most realistic war movie ever.'),
(9, 'EpicFan', 9, 'Are you not entertained?!'),
(10, 'FantasyGeek', 10, 'Perfect adaptation of the book.'),
(11, 'RomanceFan', 8, 'Beautiful love story.'),
(14, 'WorldCinema', 10, 'Deserved every Oscar.'),
(15, 'MarvelFan', 8, 'Funniest MCU movie!');

-- 11. AWARD (15 records)
INSERT INTO award (award_name, category, year_awarded, movie_id, is_winner) VALUES
('Academy Award', 'Best Cinematography', 2011, 2, TRUE),
('Academy Award', 'Best Visual Effects', 2011, 2, TRUE),
('Academy Award', 'Best Supporting Actor', 2009, 3, TRUE),
('Academy Award', 'Best Cinematography', 2022, 4, TRUE),
('Academy Award', 'Best Original Screenplay', 1995, 5, TRUE),
('Palme dOr', 'Best Film', 1994, 5, TRUE),
('Academy Award', 'Best Picture', 2001, 9, TRUE),
('Academy Award', 'Best Actor', 2001, 9, TRUE),
('Academy Award', 'Best Cinematography', 2002, 10, TRUE),
('Academy Award', 'Best Picture', 1998, 11, TRUE),
('Academy Award', 'Best Director', 1998, 11, TRUE),
('Academy Award', 'Best Picture', 2020, 14, TRUE),
('Academy Award', 'Best Director', 2020, 14, TRUE),
('Academy Award', 'Best Original Screenplay', 2020, 14, TRUE),
('Academy Award', 'Best International Feature', 2020, 14, TRUE);
