/**
 * ErenFlix Library Generator
 * Generates 2000+ titles with realistic metadata for the streaming platform
 * Used to expand the library client-side
 */

const LibraryGenerator = {
    movieGenres: ["Action", "Adventure", "Animation", "Comedy", "Crime", "Drama", "Fantasy", "Horror", "Mystery", "Romance", "Sci-Fi", "Thriller"],
    seriesGenres: ["Drama", "Comedy", "Sci-Fi & Fantasy", "Crime", "Mystery", "Action & Adventure", "Animation"],

    // Realistic title components
    adjectives: ["Dark", "Silent", "Last", "First", "Lost", "Hidden", "Secret", "Final", "Eternal", "Ancient", "Modern", "Future", "Past", "Broken", "Perfect", "Fallen", "Rising", "Crimson", "Golden", "Frozen", "Infinite", "Neon", "Cyber", "Deadly"],
    nouns: ["Knight", "Warrior", "Legend", "War", "Storm", "Shadow", "Light", "Dawn", "Night", "Day", "Dream", "Hope", "Fear", "Truth", "Lie", "Empire", "Kingdom", "Galaxy", "Soul", "Heart", "Ghost", "Machine", "System", "Matrix"],
    verbs: ["Rising", "Falling", "Running", "Hunting", "Searching", "Finding", "Losing", "Saving", "Destroying", "Creating", "Awakening", "Dreaming", "Fighting", "Surviving", "Return"],

    // Valid range of TMDB IDs (approximate) to ensure *some* stream links might actually work or at least look valid
    // We'll use IDs from 10000 to 100000 which covers many classic/pop movies

    generateTitle: function (type) {
        const r = Math.random();
        if (r < 0.3) return `The ${this.item(this.adjectives)} ${this.item(this.nouns)}`;
        if (r < 0.6) return `${this.item(this.nouns)} of ${this.item(this.nouns)}`;
        return `${this.item(this.verbs)} the ${this.item(this.nouns)}`;
    },

    item: function (arr) {
        return arr[Math.floor(Math.random() * arr.length)];
    },

    generateMovies: function (count, startId) {
        const movies = [];
        for (let i = 0; i < count; i++) {
            const year = 1990 + Math.floor(Math.random() * 35);
            const tmdbId = 10000 + Math.floor(Math.random() * 500000); // Random real-looking ID

            movies.push({
                id: startId + i,
                tmdb_id: tmdbId, // Random ID for randomness
                title: this.generateTitle(),
                year: year,
                poster: `https://image.tmdb.org/t/p/w500/rCzpDGLbOoPwLjy3OAm5NUPOTrC.jpg`, // Fallback generic poster or use a set of known ones if we wanted
                // NOTE: For demo purposes, we reuse some known posters or placeholders to ensure the grid looks good
                // In a real app we'd need real API data. We'll use a placeholder logic in the main app.
                poster_path: null, // Let the app handle the fallback
                backdrop: null,
                rating: (5 + Math.random() * 4.9).toFixed(1),
                genres: [this.item(this.movieGenres), this.item(this.movieGenres)],
                overview: "A generated movie entry for the expanded library demo. This allows simulating a massive database without 200MB of JSON files.",
                runtime: 90 + Math.floor(Math.random() * 90)
            });
        }
        return movies;
    },

    generateSeries: function (count, startId) {
        const series = [];
        for (let i = 0; i < count; i++) {
            const year = 2000 + Math.floor(Math.random() * 25);
            const tmdbId = 10000 + Math.floor(Math.random() * 100000);

            series.push({
                id: startId + i,
                tmdb_id: tmdbId,
                title: this.generateTitle(),
                year: year,
                seasons: 1 + Math.floor(Math.random() * 8),
                rating: (6 + Math.random() * 3.9).toFixed(1),
                genres: [this.item(this.seriesGenres)],
                overview: "A generated TV show entry for the expanded library demo.",
                creator: "ErenFlix AI"
            });
        }
        return series;
    }
};
