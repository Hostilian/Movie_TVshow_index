// PASTE THIS ENTIRE SCRIPT INTO BROWSER CONSOLE (F12 -> Console)
// It will help you copy RA expressions one by one

const RA = {
    D1:  `MOVIE[title, year]`,
    D2:  `MOVIE[title]`,
    D3:  `MOVIE[movie_id] \\ AWARD[movie_id]`,
    D4:  `(DIRECTOR[director_id, name] < MOVIE[movie_id, title, director_id])(name = 'Christopher Nolan')[movie_id, title]`,
    D5:  `(MOVIE_ACTOR[actor_id, movie_id] < MOVIE_GENRE[movie_id, genre_id])[actor_id, genre_id] ÷ GENRE[genre_id]`,
    D6:  `((MOVIE_ACTOR[actor_id, movie_id] < MOVIE_GENRE[movie_id, genre_id])[actor_id, genre_id] ÷ GENRE[genre_id]) < ACTOR[actor_id, name]`,
    D7:  `(MOVIE[movie_id, title, year, director_id] < DIRECTOR[director_id, name])(year > 2015)`,
    D8:  `(MOVIE[title, director_id] < DIRECTOR[director_id, name])[title, name]`,
    D9:  `(MOVIE[title, imdb_rating, director_id] < DIRECTOR[director_id, name])(imdb_rating > 8)[title, name]`,
    D10: `(MOVIE[title, imdb_rating, director_id] < DIRECTOR[director_id, name])[name, title, imdb_rating]`,
    D11: `(MOVIE_GENRE[movie_id, genre_id] < GENRE[genre_id, genre_name])[genre_name, movie_id]`,
    D12: `MOVIE[imdb_rating]`,
    D13: `MOVIE[movie_id, director_id]`,
    D14: `MOVIE[movie_id, title, year]`,
    D15: `DIRECTOR[name] ∪ ACTOR[name]`,
    D16: `MOVIE[movie_id] ∩ AWARD[movie_id]`,
    D17: `DIRECTOR[director_id] \\ MOVIE[director_id]`,
    D18: `MOVIE[movie_id] < AWARD[movie_id]`,
    D19: `(MOVIE[movie_id, title] < AWARD[movie_id, award_name])[title, award_name]`,
    D20: `(MOVIE[movie_id, title] < AWARD[movie_id])[movie_id, title]`,
    D21: `(MOVIE[movie_id, title] < AWARD[movie_id])[movie_id, title]`,
    D22: `(MOVIE[movie_id, title] < AWARD[movie_id])[movie_id, title]`,
    D23: `MOVIE`,
    D24: `MOVIE[year]`,
    D25: `MOVIE(imdb_rating > 8)`,
    D26: `STUDIO[studio_id, studio_name, country_id] !< COUNTRY[country_id, country_name]`,
    D27: `MOVIE[title, year, imdb_rating, runtime]`,
    D28: `GENRE × COUNTRY`,
    D29: `MOVIE[movie_id, title] !< AWARD[movie_id, award_name]`,
    D30: `DIRECTOR[director_id, name] !< MOVIE[movie_id, title, director_id]`
};

// Function to copy to clipboard
function copyRA(id) {
    const expr = RA[id];
    if (expr) {
        navigator.clipboard.writeText(expr).then(() => {
            console.log(`✓ Copied ${id}: ${expr}`);
        });
    } else {
        console.log(`✗ ${id} not found`);
    }
}

// Print all expressions
console.log("=== RA EXPRESSIONS FOR PORTAL ===\n");
Object.entries(RA).forEach(([k, v]) => console.log(`${k}: ${v}`));

console.log("\n=== HOW TO USE ===");
console.log("Type: copyRA('D1') to copy D1 expression to clipboard");
console.log("Then paste (Ctrl+V) into the RA field in portal\n");

// Quick copy all to clipboard
function copyAll() {
    const all = Object.entries(RA).map(([k,v]) => `${k}: ${v}`).join('\n');
    navigator.clipboard.writeText(all).then(() => console.log("✓ All expressions copied!"));
}
console.log("Type: copyAll() to copy everything at once");
