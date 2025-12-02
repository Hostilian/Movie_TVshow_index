// ============================================================================
// PORTAL RA EXPRESSIONS - CORRECTED FOR RAT TRANSLATOR V2
// Copy each RA expression directly into the portal
// ============================================================================

// WORKING PATTERNS (based on portal errors):
// - Simple projection: TABLE[col1, col2]
// - Natural join without projection: TABLE < TABLE
// - Join WITH projection: TABLE < TABLE [col1, col2]  (NO parentheses!)
// - Set operations: TABLE[col] ∪ TABLE[col], TABLE[col] ∩ TABLE[col], TABLE[col] \ TABLE[col]
// - Cartesian: TABLE × TABLE
// - Left outer join: TABLE *> TABLE  (note: NOT !<)
// - Selection: σ condition (TABLE)  OR  TABLE (condition) before join

const raExpressions = {
    // ===== WORKING (keep as-is) =====
    D1:  "MOVIE[title, year]",
    D2:  "MOVIE[title]",
    D12: "MOVIE[imdb_rating]",
    D13: "MOVIE[movie_id, director_id]",
    D14: "MOVIE[movie_id, title, year]",
    D15: "DIRECTOR[name] ∪ ACTOR[name]",
    D16: "MOVIE[movie_id] ∩ AWARD[movie_id]",
    D17: "DIRECTOR[director_id] \\ MOVIE[director_id]",
    D23: "MOVIE",
    D24: "MOVIE[year]",
    D27: "MOVIE[title, year, imdb_rating, runtime]",
    D28: "GENRE × COUNTRY",

    // ===== FIXED: Set difference =====
    D3:  "MOVIE[movie_id] \\ AWARD[movie_id]",

    // ===== FIXED: Selection with sigma =====
    D4:  "σ name='Christopher Nolan' (DIRECTOR) < MOVIE [movie_id, title]",
    // Alt: "σ name='Christopher Nolan' (DIRECTOR < MOVIE) [movie_id, title]"

    // ===== FIXED: Division (universal quantification) =====
    D5:  "MOVIE_ACTOR < MOVIE_GENRE [actor_id, genre_id] ÷ GENRE[genre_id]",
    // Simpler alt: "MOVIE_ACTOR[actor_id, movie_id] < MOVIE_GENRE[movie_id, genre_id] ÷ GENRE[genre_id]"

    D6:  "(MOVIE_ACTOR < MOVIE_GENRE [actor_id, genre_id] ÷ GENRE[genre_id]) < ACTOR [actor_id, name]",

    // ===== FIXED: Join + Selection (sigma syntax) =====
    D7:  "σ year>2015 (MOVIE) < DIRECTOR",
    // Alt: "σ year>2015 (MOVIE < DIRECTOR)"

    // ===== FIXED: Join + Projection (NO parentheses around join) =====
    D8:  "MOVIE < DIRECTOR [title, name]",

    D9:  "σ imdb_rating>8 (MOVIE) < DIRECTOR [title, name]",
    // Alt: "σ imdb_rating>8 (MOVIE < DIRECTOR) [title, name]"

    D10: "MOVIE < DIRECTOR [name, title, imdb_rating]",

    D11: "MOVIE_GENRE < GENRE [genre_name, movie_id]",

    // ===== FIXED: Inner join (simple, no parens needed) =====
    D18: "MOVIE < AWARD",

    D19: "MOVIE < AWARD [title, award_name]",

    D20: "MOVIE < AWARD [movie_id, title]",
    D21: "MOVIE < AWARD [movie_id, title]",
    D22: "MOVIE < AWARD [movie_id, title]",

    // ===== FIXED: Selection only =====
    D25: "σ imdb_rating>8 (MOVIE)",
    // Alt: "MOVIE (imdb_rating > 8)"  -- if sigma doesn't work

    // ===== FIXED: Left outer join (use *> not !<) =====
    D26: "STUDIO *> COUNTRY",

    D29: "MOVIE *> AWARD",

    D30: "DIRECTOR *> MOVIE"
};

// ============================================================================
// COPY-PASTE READY LIST (one per line)
// ============================================================================
console.log("=== RA Expressions for Portal ===\n");
for (const [key, value] of Object.entries(raExpressions)) {
    console.log(`${key}: ${value}`);
}

// ============================================================================
// ALTERNATIVE SYNTAX OPTIONS (if above doesn't work)
// ============================================================================
const alternatives = {
    // If sigma σ doesn't work, try these:
    D4_alt1: "(DIRECTOR (name = 'Christopher Nolan')) < MOVIE [movie_id, title]",
    D4_alt2: "DIRECTOR < MOVIE (name = 'Christopher Nolan') [movie_id, title]",

    D7_alt1: "MOVIE (year > 2015) < DIRECTOR",
    D7_alt2: "MOVIE < DIRECTOR (year > 2015)",

    D9_alt1: "MOVIE (imdb_rating > 8) < DIRECTOR [title, name]",

    D25_alt1: "MOVIE (imdb_rating > 8)",

    // If division ÷ doesn't work:
    D5_alt: "ACTOR[actor_id] \\ ((ACTOR × GENRE)[actor_id, genre_id] \\ (MOVIE_ACTOR < MOVIE_GENRE)[actor_id, genre_id])[actor_id]"
};

console.log("\n=== Alternative Syntax ===\n");
for (const [key, value] of Object.entries(alternatives)) {
    console.log(`${key}: ${value}`);
}
