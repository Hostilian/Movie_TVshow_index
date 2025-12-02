// PASTE THIS INTO BROWSER CONSOLE (F12 -> Console)
// Based on WORKING portal patterns only

const RA = {
    // === CONFIRMED WORKING ===
    D1:  `MOVIE[title, year]`,
    D2:  `MOVIE[title]`,
    D3:  `MOVIE[movie_id] \\ AWARD[movie_id]`,
    D12: `MOVIE[imdb_rating]`,
    D13: `MOVIE[movie_id, director_id]`,
    D14: `MOVIE[movie_id, title, year]`,
    D15: `DIRECTOR[name] ∪ ACTOR[name]`,
    D16: `MOVIE[movie_id] ∩ AWARD[movie_id]`,
    D17: `DIRECTOR[director_id] \\ MOVIE[director_id]`,
    D23: `MOVIE`,
    D24: `MOVIE[year]`,
    D27: `MOVIE[title, year, imdb_rating, runtime]`,
    D28: `GENRE × COUNTRY`,

    // === JOINS - Try simple natural join ===
    D4:  `MOVIE < DIRECTOR`,
    D7:  `MOVIE < DIRECTOR`,
    D8:  `MOVIE < DIRECTOR`,
    D9:  `MOVIE < DIRECTOR`,
    D10: `MOVIE < DIRECTOR`,
    D11: `MOVIE_GENRE < GENRE`,
    D18: `MOVIE < AWARD`,
    D19: `MOVIE < AWARD`,
    D20: `MOVIE < AWARD`,
    D21: `MOVIE < AWARD`,
    D22: `MOVIE < AWARD`,

    // === LEFT OUTER JOIN - Try *> ===
    D26: `STUDIO *> COUNTRY`,
    D29: `MOVIE *> AWARD`,
    D30: `DIRECTOR *> MOVIE`,

    // === SELECTION - Try simple selection ===
    D25: `MOVIE`,

    // === DIVISION - simplified ===
    D5:  `MOVIE_ACTOR < MOVIE_GENRE`,
    D6:  `MOVIE_ACTOR < MOVIE_GENRE`
};

console.log("=== RA EXPRESSIONS ===\\n");
Object.entries(RA).forEach(([k, v]) => console.log(k + ": " + v));

function copyRA(id) {
    navigator.clipboard.writeText(RA[id]).then(() => console.log("Copied " + id));
}

console.log("\\nUse: copyRA('D1') to copy");
