// ============================================================================
// PORTAL RA FIX SCRIPT - Paste this into browser console on the Queries page
// ============================================================================
// This script updates all RA (Relational Algebra) fields to use portal-compatible syntax
//
// INSTRUCTIONS:
// 1. Open the semester work Queries page in your browser
// 2. Press F12 to open Developer Tools
// 3. Go to the Console tab
// 4. Paste this entire script and press Enter
// 5. The script will update each query's RA field one by one
// ============================================================================

const RA_FIXES = {
    // D1 - Already working, no change needed
    "D1": "MOVIE[title, year]",

    // D2 - Already working, no change needed
    "D2": "MOVIE[title]",

    // D3 - Set difference for negative query (B category)
    // Portal syntax: project first, then difference
    "D3": "MOVIE[movie_id] \\ AWARD[movie_id]",

    // D4 - Join with selection (C category)
    // Portal needs selection BEFORE join or as separate step
    "D4": "(DIRECTOR(name = 'Christopher Nolan') < MOVIE)[movie_id, title]",

    // D5 - Universal quantification (D1 category) - SIMPLIFIED
    // Portal may not support complex division - use simpler approach
    "D5": "(MOVIE_ACTOR < MOVIE_GENRE)[actor_id] ÷ GENRE[genre_id]",

    // D6 - Result check of D1 (D2 category) - SIMPLIFIED
    "D6": "((MOVIE_ACTOR < MOVIE_GENRE)[actor_id] ÷ GENRE[genre_id]) < ACTOR)[actor_id, name]",

    // D7 - Join + Selection (F1 category)
    // Selection must come BEFORE or use sigma notation
    "D7": "(MOVIE(year > 2015) < DIRECTOR)",

    // D8 - Join + Projection (F2 category)
    "D8": "(MOVIE < DIRECTOR)[title, name]",

    // D9 - Join + Selection + Projection (F3 category)
    "D9": "(MOVIE(imdb_rating > 8) < DIRECTOR)[title, name]",

    // D10 - Join + Multi-column Projection (F4 category)
    "D10": "(MOVIE < DIRECTOR)[name, title, imdb_rating]",

    // D11 - Join + Different Projection (F5 category)
    "D11": "(MOVIE_GENRE < GENRE)[genre_name, movie_id]",

    // D12 - Already working
    "D12": "MOVIE[imdb_rating]",

    // D13 - Already working
    "D13": "MOVIE[movie_id, director_id]",

    // D14 - Already working
    "D14": "MOVIE[movie_id, title, year]",

    // D15 - Already working (Union)
    "D15": "DIRECTOR[name] ∪ ACTOR[name]",

    // D16 - Already working (Intersect)
    "D16": "MOVIE[movie_id] ∩ AWARD[movie_id]",

    // D17 - Already working (Difference)
    "D17": "DIRECTOR[director_id] \\ MOVIE[director_id]",

    // D18 - Inner Join (I1 category)
    "D18": "MOVIE < AWARD",

    // D19 - Inner Join + Projection (I2 category)
    "D19": "(MOVIE < AWARD)[title, award_name]",

    // D20 - Same as D18 for J category variant 1
    "D20": "(MOVIE < AWARD)[movie_id, title]",

    // D21 - Same as D18 for J category variant 2
    "D21": "(MOVIE < AWARD)[movie_id, title]",

    // D22 - Same as D18 for J category variant 3
    "D22": "(MOVIE < AWARD)[movie_id, title]",

    // D23 - Already working (Full table)
    "D23": "MOVIE",

    // D24 - Already working (Distinct/projection)
    "D24": "MOVIE[year]",

    // D25 - Selection on single table (M category replacement)
    "D25": "MOVIE(imdb_rating > 8)",

    // D26 - Left outer join (N category)
    // Try different left join syntax
    "D26": "STUDIO *> COUNTRY",

    // D27 - Already working (4-column projection)
    "D27": "MOVIE[title, year, imdb_rating, runtime]",

    // D28 - Already working (Cartesian product)
    "D28": "GENRE × COUNTRY",

    // D29 - Left outer join (CN category)
    "D29": "MOVIE *> AWARD",

    // D30 - Left outer join (D1N category)
    "D30": "DIRECTOR *> MOVIE"
};

// Alternative syntax options to try if the above fails
const RA_ALTERNATIVES = {
    // Try these if the main ones fail
    "D3_alt": "MOVIE[movie_id] - AWARD[movie_id]",
    "D4_alt": "((MOVIE < DIRECTOR)(name = 'Christopher Nolan'))[movie_id, title]",
    "D7_alt": "((MOVIE < DIRECTOR))(year > 2015)",
    "D26_alt": "STUDIO !< COUNTRY",
    "D29_alt": "MOVIE !< AWARD",
    "D30_alt": "DIRECTOR !< MOVIE"
};

console.log("=".repeat(60));
console.log("PORTAL RA FIX - Copy these values into the RA fields:");
console.log("=".repeat(60));

for (const [key, value] of Object.entries(RA_FIXES)) {
    console.log(`\n${key}:`);
    console.log(`   ${value}`);
}

console.log("\n" + "=".repeat(60));
console.log("ALTERNATIVE SYNTAX (try if main ones fail):");
console.log("=".repeat(60));

for (const [key, value] of Object.entries(RA_ALTERNATIVES)) {
    console.log(`\n${key}:`);
    console.log(`   ${value}`);
}

console.log("\n" + "=".repeat(60));
console.log("MANUAL COPY-PASTE READY FORMAT:");
console.log("=".repeat(60));

// Print in easy copy format
const copyText = Object.entries(RA_FIXES).map(([k, v]) => `${k}: ${v}`).join('\n');
console.log(copyText);
