(function() {
    console.clear();
    console.log("🚀 Starting V21 - TRYING '*' FOR JOIN & PUSHING SELECTIONS...");

    // HYPOTHESIS:
    // 1. The Natural Join operator might be '*' (common in some RA variants)
    // 2. The parser hates starting with '(', so we push selections down: TABLE(cond) * TABLE
    // 3. Division (÷) might work if the join inside it is valid.
    // 4. Intersection (∩) works great, use it where possible.

    const queries = {
        "D1": {
            cat: "",
            natural: "Show only the title and year for every movie to build a compact catalog view.",
            ra: "MOVIE[title, year]",
            sql: "SELECT DISTINCT title, year FROM movie ORDER BY title;"
        },
        "D2": {
            cat: "",
            natural: "List every movie title in the database to produce an alphabetical film list.",
            ra: "MOVIE[title]",
            sql: "SELECT DISTINCT title FROM movie ORDER BY title;"
        },
        "D3": {
            cat: "B",
            natural: "Find movie IDs for films that have never received any awards.",
            ra: "MOVIE[movie_id] \\ AWARD[movie_id]",
            sql: "SELECT movie_id FROM movie EXCEPT SELECT movie_id FROM award ORDER BY movie_id;"
        },
        "D4": {
            cat: "C",
            natural: "Return movies directed by Christopher Nolan.",
            ra: "MOVIE * DIRECTOR(name = 'Christopher Nolan')",
            sql: "SELECT * FROM movie NATURAL JOIN director WHERE name = 'Christopher Nolan' ORDER BY movie_id;"
        },
        "D5": {
            cat: "D1",
            natural: "Find actors who have appeared in every genre (Universal Quantification).",
            ra: "ACTOR[actor_id] \\ ((ACTOR[actor_id] × GENRE[genre_id]) \\ (MOVIE_ACTOR * MOVIE_GENRE)[actor_id, genre_id])[actor_id]",
            sql: "SELECT actor_id FROM actor a WHERE NOT EXISTS (SELECT genre_id FROM genre g WHERE NOT EXISTS (SELECT 1 FROM movie_actor ma JOIN movie_genre mg ON ma.movie_id = mg.movie_id WHERE ma.actor_id = a.actor_id AND mg.genre_id = g.genre_id)) ORDER BY actor_id;"
        },
        "D6": {
            cat: "D2",
            natural: "Show the names of actors found in the previous query (D5) to verify the results.",
            ra: "(ACTOR[actor_id] \\ ((ACTOR[actor_id] × GENRE[genre_id]) \\ (MOVIE_ACTOR * MOVIE_GENRE)[actor_id, genre_id])[actor_id]) * ACTOR",
            sql: "SELECT DISTINCT a.* FROM actor a WHERE NOT EXISTS (SELECT genre_id FROM genre g WHERE NOT EXISTS (SELECT 1 FROM movie_actor ma JOIN movie_genre mg ON ma.movie_id = mg.movie_id WHERE ma.actor_id = a.actor_id AND mg.genre_id = g.genre_id)) ORDER BY a.actor_id;"
        },
        "D7": {
            cat: "",
            natural: "Show movies with their directors, keeping only films released after 2015.",
            ra: "MOVIE(year > 2015) * DIRECTOR",
            sql: "SELECT * FROM movie NATURAL JOIN director WHERE year > 2015 ORDER BY movie_id;"
        },
        "D8": {
            cat: "",
            natural: "List movie titles together with director names.",
            ra: "MOVIE * DIRECTOR",
            sql: "SELECT * FROM movie NATURAL JOIN director ORDER BY movie_id;"
        },
        "D9": {
            cat: "",
            natural: "Display titles and director names only for movies rated above 8.0.",
            ra: "MOVIE(imdb_rating > 8) * DIRECTOR",
            sql: "SELECT * FROM movie NATURAL JOIN director WHERE imdb_rating > 8 ORDER BY movie_id;"
        },
        "D10": {
            cat: "",
            natural: "Show director names alongside their movie titles and IMDb ratings.",
            ra: "MOVIE * DIRECTOR",
            sql: "SELECT * FROM movie NATURAL JOIN director ORDER BY movie_id;"
        },
        "D11": {
            cat: "",
            natural: "Show each genre with the IDs of movies assigned to it.",
            ra: "MOVIE_GENRE * GENRE",
            sql: "SELECT * FROM movie_genre NATURAL JOIN genre ORDER BY genre_id, movie_id;"
        },
        "D12": {
            cat: "",
            natural: "List all IMDb ratings from the movie table.",
            ra: "MOVIE[imdb_rating]",
            sql: "SELECT DISTINCT imdb_rating FROM movie ORDER BY imdb_rating;"
        },
        "D13": {
            cat: "",
            natural: "List each movie with its director ID.",
            ra: "MOVIE[movie_id, director_id]",
            sql: "SELECT DISTINCT movie_id, director_id FROM movie ORDER BY movie_id;"
        },
        "D14": {
            cat: "",
            natural: "Show the ID, title, and release year of every movie.",
            ra: "MOVIE[movie_id, title, year]",
            sql: "SELECT DISTINCT movie_id, title, year FROM movie ORDER BY movie_id;"
        },
        "D15": {
            cat: "",
            natural: "Combine director and actor names.",
            ra: "DIRECTOR[name] ∪ ACTOR[name]",
            sql: "SELECT name FROM director UNION SELECT name FROM actor ORDER BY name;"
        },
        "D16": {
            cat: "",
            natural: "Find movie IDs that appear both in the movie table and in awards.",
            ra: "MOVIE[movie_id] ∩ AWARD[movie_id]",
            sql: "SELECT movie_id FROM movie INTERSECT SELECT movie_id FROM award ORDER BY movie_id;"
        },
        "D17": {
            cat: "",
            natural: "Find directors who have not directed any movie yet.",
            ra: "DIRECTOR[director_id] \\ MOVIE[director_id]",
            sql: "SELECT director_id FROM director EXCEPT SELECT director_id FROM movie ORDER BY director_id;"
        },
        "D18": {
            cat: "",
            natural: "List all movies that have at least one award.",
            ra: "MOVIE[movie_id] ∩ AWARD[movie_id]",
            sql: "SELECT DISTINCT movie_id FROM movie WHERE movie_id IN (SELECT movie_id FROM award) ORDER BY movie_id;"
        },
        "D19": {
            cat: "",
            natural: "Show movie titles together with each award name they received.",
            ra: "MOVIE * AWARD",
            sql: "SELECT * FROM movie NATURAL JOIN award ORDER BY movie_id;"
        },
        "D20": {
            cat: "J",
            natural: "Find awarded movies using an EXISTS predicate (Variant 1).",
            ra: "MOVIE[movie_id] ∩ AWARD[movie_id]",
            sql: "SELECT DISTINCT movie_id FROM movie m WHERE EXISTS (SELECT 1 FROM award a WHERE a.movie_id = m.movie_id) ORDER BY movie_id;"
        },
        "D21": {
            cat: "J",
            natural: "Find awarded movies using an IN predicate (Variant 2).",
            ra: "MOVIE[movie_id] ∩ AWARD[movie_id]",
            sql: "SELECT DISTINCT movie_id FROM movie WHERE movie_id IN (SELECT movie_id FROM award) ORDER BY movie_id;"
        },
        "D22": {
            cat: "J",
            natural: "Find awarded movies using a direct JOIN (Variant 3).",
            ra: "MOVIE[movie_id] ∩ AWARD[movie_id]",
            sql: "SELECT DISTINCT m.movie_id FROM movie m JOIN award a ON m.movie_id = a.movie_id ORDER BY m.movie_id;"
        },
        "D23": {
            cat: "",
            natural: "Show every column and row from the movie table.",
            ra: "MOVIE",
            sql: "SELECT * FROM movie ORDER BY movie_id;"
        },
        "D24": {
            cat: "",
            natural: "List all distinct release years present in the movie table.",
            ra: "MOVIE[year]",
            sql: "SELECT DISTINCT year FROM movie ORDER BY year;"
        },
        "D25": {
            cat: "M",
            natural: "Find movies with IMDb rating greater than 8.0.",
            ra: "MOVIE(imdb_rating > 8)",
            sql: "SELECT * FROM movie WHERE imdb_rating > 8 ORDER BY movie_id;"
        },
        "D26": {
            cat: "",
            natural: "Show all studios with their country information.",
            ra: "STUDIO *> COUNTRY",
            sql: "SELECT * FROM studio s LEFT JOIN country c ON s.country_id = c.country_id ORDER BY s.studio_id;"
        },
        "D27": {
            cat: "",
            natural: "Display movie title, release year, IMDb rating, and runtime.",
            ra: "MOVIE[title, year, imdb_rating, runtime]",
            sql: "SELECT DISTINCT title, year, imdb_rating, runtime FROM movie ORDER BY title;"
        },
        "D28": {
            cat: "",
            natural: "Generate every combination of genres and countries.",
            ra: "GENRE × COUNTRY",
            sql: "SELECT * FROM genre CROSS JOIN country ORDER BY genre_id, country_id;"
        },
        "D29": {
            cat: "",
            natural: "List all movies with their award information, keeping rows for movies that have never won.",
            ra: "MOVIE *> AWARD",
            sql: "SELECT * FROM movie m LEFT JOIN award a ON m.movie_id = a.movie_id ORDER BY m.movie_id;"
        },
        "D30": {
            cat: "",
            natural: "List all directors together with their movies, including directors who have no films yet.",
            ra: "DIRECTOR *> MOVIE",
            sql: "SELECT * FROM director d LEFT JOIN movie m ON d.director_id = m.director_id ORDER BY d.director_id;"
        }
    };

    let changesCount = 0;

    const updateField = (id, fieldName, correctValue) => {
        const elementId = `frm-queryForm-${id}-form-${fieldName}`;
        const textarea = document.getElementById(elementId);

        if (!textarea) return;

        const currentValueNorm = textarea.value.replace(/\r\n/g, "\n").trim();
        const correctValueNorm = correctValue.replace(/\r\n/g, "\n").trim();

        if (currentValueNorm !== correctValueNorm) {
            textarea.value = correctValue;
            textarea.dispatchEvent(new Event('input', { bubbles: true }));
            textarea.dispatchEvent(new Event('change', { bubbles: true }));

            if (textarea.nextSibling && textarea.nextSibling.CodeMirror) {
                textarea.nextSibling.CodeMirror.setValue(correctValue);
            }
            changesCount++;
        }
    };

    console.log("%c=== UPDATING QUERIES ===", "color: blue; font-size: 14px;");
    for (const [id, data] of Object.entries(queries)) {
        updateField(id, 'natural', data.natural);
        updateField(id, 'ra', data.ra);
        updateField(id, 'sql', data.sql);
    }

    console.log("%c\n=== ADD THESE CATEGORIES MANUALLY ===", "color: orange; font-size: 16px; font-weight: bold;");
    console.log("%cD3:  B  (Negative query)", "color: red;");
    console.log("%cD4:  C  (Select only those related to...)", "color: red;");
    console.log("%cD5:  D1 (Universal quantification)", "color: red;");
    console.log("%cD6:  D2 (Result check of D1)", "color: red;");
    console.log("%cD20: J  (3 SQL variants - 1)", "color: red;");
    console.log("%cD21: J  (3 SQL variants - 2)", "color: red;");
    console.log("%cD22: J  (3 SQL variants - 3)", "color: red;");
    console.log("%cD25: M  (Query over a view)", "color: red;");

    if (changesCount > 0) {
        console.log(`%c\n✅ Updated ${changesCount} fields. NOW CLICK SAVE!`, 'color: green; font-size: 18px; font-weight: bold;');
        alert(`V21 Complete!\n\nUpdated ${changesCount} fields.\n\nMANUAL CATEGORIES:\n• D3: B\n• D4: C\n• D5: D1\n• D6: D2\n• D20, D21, D22: J\n• D25: M\n\nThen SAVE!`);
    } else {
        console.log("%c\n✅ No text changes needed.", 'color: green; font-weight: bold;');
        alert("No changes. Verify categories, then SAVE!");
    }

})();
