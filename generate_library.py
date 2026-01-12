import json
import random
import os

# Top movie genres and their characteristics
movie_genres = {
    "Action": {"avgRating": 7.2, "avgRuntime": 115},
    "Adventure": {"avgRating": 7.4, "avgRuntime": 125},
    "Animation": {"avgRating": 7.6, "avgRuntime": 95},
    "Comedy": {"avgRating": 6.8, "avgRuntime": 105},
    "Crime": {"avgRating": 7.5, "avgRuntime": 120},
    "Drama": {"avgRating": 7.3, "avgRuntime": 125},
    "Fantasy": {"avgRating": 7.1, "avgRuntime": 130},
    "Horror": {"avgRating": 6.5, "avgRuntime": 95},
    "Mystery": {"avgRating": 7.2, "avgRuntime": 110},
    "Romance": {"avgRating": 6.9, "avgRuntime": 110},
    "Sci-Fi": {"avgRating": 7.3, "avgRuntime": 120},
    "Thriller": {"avgRating": 7.1, "avgRuntime": 110}
}

# Famous directors
directors = [
    "Christopher Nolan", "Steven Spielberg", "Martin Scorsese", "Quentin Tarantino",
    "James Cameron", "Ridley Scott", "Denis Villeneuve", "David Fincher",
    "Peter Jackson", "George Lucas", "Francis Ford Coppola", "Stanley Kubrick",
    "Alfred Hitchcock", "Wes Anderson", "Edgar Wright", "Greta Gerwig",
    "Bong Joon-ho", "Park Chan-wook", "Guillermo del Toro", "Jordan Peele"
]

# Title generation words
adjectives = ["Dark", "Silent", "Last", "First", "Lost", "Hidden", "Secret", "Final", "Eternal", "Ancient", "Modern", "Future", "Past", "Broken", "Perfect", "Fallen", "Rising", "Crimson", "Golden", "Frozen"]
nouns = ["Knight", "Warrior", "Legend", "War", "Storm", "Shadow", "Light", "Dawn", "Night", "Day", "Dream", "Hope", "Fear", "Truth", "Lie", "Empire", "Kingdom", "Galaxy", "Soul", "Heart"]
verbs = ["Rising", "Falling", "Running", "Hunting", "Searching", "Finding", "Losing", "Saving", "Destroying", "Creating", "Awakening", "Dreaming", "Fighting", "Surviving"]

def generate_movie(id, starting_tmdb_id=100000):
    genre_keys = list(movie_genres.keys())
    primary_genre = random.choice(genre_keys)
    genres = [primary_genre]
    
    if random.random() > 0.5:
        secondary_genre = random.choice(genre_keys)
        if secondary_genre != primary_genre:
            genres.append(secondary_genre)
    
    genre_data = movie_genres[primary_genre]
    year = 1990 + int(random.random() * 35)
    rating = min(9.9, max(4.0, round(genre_data["avgRating"] + (random.random() - 0.5) * 2, 1)))
    runtime = int(genre_data["avgRuntime"] + (random.random() - 0.5) * 40)
    
    # Generate title
    title_type = random.random()
    if title_type < 0.3:
        title = f"The {random.choice(adjectives)} {random.choice(nouns)}"
    elif title_type < 0.6:
        title = f"{random.choice(nouns)} of {random.choice(nouns)}"
    else:
        title = f"{random.choice(verbs)} the {random.choice(nouns)}"
        
    if random.random() > 0.9:
        if random.random() > 0.5:
            title += f" {random.randint(2, 6)}"
        else:
            title += f": {random.choice(nouns)}"
            
    tmdb_id = starting_tmdb_id + id
    imdb_id = f"tt{str(1000000 + id).zfill(7)}"
    director = random.choice(directors)
    
    poster_hash = hex(random.getrandbits(64))[2:]
    backdrop_hash = hex(random.getrandbits(64))[2:]
    
    return {
        "id": id,
        "tmdb_id": tmdb_id,
        "imdb_id": imdb_id,
        "title": title,
        "year": year,
        "poster": f"/{poster_hash[:20]}.jpg",
        "backdrop": f"/{backdrop_hash[:20]}.jpg",
        "rating": rating,
        "genres": genres,
        "overview": f"A {primary_genre} film that explores the depths of human {random.choice(['courage', 'resilience', 'fear', 'ambition'])} in the face of {random.choice(['overwhelming', 'impossible', 'unseen', 'ancient'])} {random.choice(['odds', 'challenges', 'enemies', 'forces'])}. This {year} masterpiece showcases {director}'s unique vision.",
        "runtime": runtime,
        "director": director
    }

def generate_series(id, starting_tmdb_id=50000):
    series_genres = ["Drama", "Comedy", "Sci-Fi & Fantasy", "Crime", "Mystery", "Action & Adventure", "Animation"]
    networks = ["Netflix", "HBO", "AMC", "Apple TV+", "Amazon Prime", "Hulu", "Disney+", "FX", "BBC", "Showtime"]
    creators = [
        "Vince Gilligan", "David Benioff & D.B. Weiss", "The Duffer Brothers",
        "Greg Berlanti", "Chuck Lorre", "Ryan Murphy", "Shonda Rhimes",
        "Dick Wolf", "Aaron Sorkin", "Jason Rothenberg"
    ]
    
    primary_genre = random.choice(series_genres)
    genres = [primary_genre]
    
    if random.random() > 0.6:
        secondary_genre = random.choice(series_genres)
        if secondary_genre != primary_genre:
            genres.append(secondary_genre)
            
    year = 2005 + int(random.random() * 20)
    seasons = random.randint(1, 10)
    rating = min(9.5, max(5.0, round(7.0 + (random.random() - 0.5) * 3, 1)))
    
    title_type = random.random()
    if title_type < 0.4:
        title = f"{random.choice(nouns)} {random.choice(nouns)}"
    elif title_type < 0.7:
        title = f"The {random.choice(adjectives)} {random.choice(nouns)}"
    else:
        title = f"{random.choice(verbs)} {random.choice(nouns)}"
        
    tmdb_id = starting_tmdb_id + id
    imdb_id = f"tt{str(5000000 + id).zfill(7)}"
    creator = random.choice(creators)
    network = random.choice(networks)
    
    poster_hash = hex(random.getrandbits(64))[2:]
    backdrop_hash = hex(random.getrandbits(64))[2:]
    
    return {
        "id": id,
        "tmdb_id": tmdb_id,
        "imdb_id": imdb_id,
        "title": title,
        "year": year,
        "seasons": seasons,
        "poster": f"/{poster_hash[:20]}.jpg",
        "backdrop": f"/{backdrop_hash[:20]}.jpg",
        "rating": rating,
        "genres": genres,
        "overview": f"An acclaimed {primary_genre} series that follows the journey of extraordinary characters through {seasons} captivating seasons. This {network} production has redefined modern television storytelling.",
        "creator": creator,
        "network": network
    }

print("Starting library generation...")

movies = []
for i in range(1, 2001):  # 2000 movies
    movies.append(generate_movie(i))

series = []
for i in range(1, 501):   # 500 series
    series.append(generate_series(i))

# Create directory if not exists
os.makedirs("docs/data", exist_ok=True)

with open("docs/data/movies_extended.json", "w") as f:
    json.dump(movies, f, indent=2)
    
with open("docs/data/series_extended.json", "w") as f:
    json.dump(series, f, indent=2)

print(f"Successfully generated {len(movies)} movies and {len(series)} series!")
