(function() {
    console.clear();
    console.log("🚀 Starting V15 FINAL FIX (Corrected RA Syntax for Portal)...");

    const queries = {
        "D1": {
            cat: "A",
            natural: "Show only the title and year for every movie to build a compact catalog view.",
            ra: "MOVIE[title, year]",
            sql: "SELECT DISTINCT title, year FROM movie ORDER BY title;"
        },
        "D2": {
            cat: "G1",
            natural: "List every movie title in the database to produce an alphabetical film list.",
            ra: "MOVIE[title]",
            sql: "SELECT DISTINCT title FROM movie ORDER BY title;"
        },
        "D3": {
            cat: "B, H2",
            natural: "Find movie IDs for films that have never received any awards.",
            ra: "MOVIE[movie_id] \\ AWARD[movie_id]",
            sql: "SELECT movie_id FROM movie EXCEPT SELECT movie_id FROM award ORDER BY movie_id;"
        },
        "D4": {
            cat: "C",
            natural: "Return movies directed by Christopher Nolan.",
            ra: "(DIRECTOR < MOVIE)(name = 'Christopher Nolan')[movie_id, title]",
            sql: "SELECT DISTINCT m.movie_id, m.title FROM movie m JOIN director d ON m.director_id = d.director_id WHERE d.name = 'Christopher Nolan' ORDER BY m.movie_id;"
        },
        "D5": {
            cat: "D1",
            natural: "Find actors who have appeared in every genre (Universal Quantification).",
            ra: "(MOVIE_ACTOR < MOVIE_GENRE)[actor_id, genre_id] ÷ GENRE[genre_id]",
            sql: "SELECT actor_id FROM actor a WHERE NOT EXISTS (SELECT genre_id FROM genre g WHERE NOT EXISTS (SELECT 1 FROM movie_actor ma JOIN movie_genre mg ON ma.movie_id = mg.movie_id WHERE ma.actor_id = a.actor_id AND mg.genre_id = g.genre_id)) ORDER BY actor_id;"
        },
        "D6": {
            cat: "D2",
            natural: "Show the names of actors found in the previous query (D5) to verify the results.",
            ra: "((MOVIE_ACTOR < MOVIE_GENRE)[actor_id, genre_id] ÷ GENRE[genre_id]) < ACTOR[actor_id, name]",
            sql: "SELECT DISTINCT a.actor_id, a.name FROM actor a WHERE NOT EXISTS (SELECT genre_id FROM genre g WHERE NOT EXISTS (SELECT 1 FROM movie_actor ma JOIN movie_genre mg ON ma.movie_id = mg.movie_id WHERE ma.actor_id = a.actor_id AND mg.genre_id = g.genre_id)) ORDER BY a.actor_id;"
        },
        "D7": {
            cat: "F1",
            natural: "Show movies with their directors, keeping only films released after 2015.",
            ra: "(MOVIE < DIRECTOR)(year > 2015)",
            sql: "SELECT DISTINCT m.movie_id, m.title, m.year, m.director_id, d.name FROM movie m JOIN director d ON m.director_id = d.director_id WHERE m.year > 2015 ORDER BY m.movie_id;"
        },
        "D8": {
            cat: "F2",
            natural: "List movie titles together with director names.",
            ra: "(MOVIE < DIRECTOR)[title, name]",
            sql: "SELECT DISTINCT m.title, d.name FROM movie m JOIN director d ON m.director_id = d.director_id ORDER BY m.title;"
        },
        "D9": {
            cat: "F3",
            natural: "Display titles and director names only for movies rated above 8.0.",
            ra: "(MOVIE < DIRECTOR)(imdb_rating > 8)[title, name]",
            sql: "SELECT DISTINCT m.title, d.name FROM movie m JOIN director d ON m.director_id = d.director_id WHERE m.imdb_rating > 8 ORDER BY m.title;"
        },
        "D10": {
            cat: "F4",
            natural: "Show director names alongside their movie titles and IMDb ratings.",
            ra: "(MOVIE < DIRECTOR)[name, title, imdb_rating]",
            sql: "SELECT DISTINCT d.name, m.title, m.imdb_rating FROM movie m JOIN director d ON m.director_id = d.director_id ORDER BY d.name;"
        },
        "D11": {
            cat: "F5",
            natural: "Show each genre with the IDs of movies assigned to it.",
            ra: "(MOVIE_GENRE < GENRE)[genre_name, movie_id]",
            sql: "SELECT DISTINCT g.genre_name, mg.movie_id FROM movie_genre mg JOIN genre g ON mg.genre_id = g.genre_id ORDER BY g.genre_name;"
        },
        "D12": {
            cat: "G2",
            natural: "List all IMDb ratings from the movie table.",
            ra: "MOVIE[imdb_rating]",
            sql: "SELECT DISTINCT imdb_rating FROM movie ORDER BY imdb_rating;"
        },
        "D13": {
            cat: "G3",
            natural: "List each movie with its director ID.",
            ra: "MOVIE[movie_id, director_id]",
            sql: "SELECT DISTINCT movie_id, director_id FROM movie ORDER BY movie_id;"
        },
        "D14": {
            cat: "G4",
            natural: "Show the ID, title, and release year of every movie.",
            ra: "MOVIE[movie_id, title, year]",
            sql: "SELECT DISTINCT movie_id, title, year FROM movie ORDER BY movie_id;"
        },
        "D15": {
            cat: "H1",
            natural: "Combine director and actor names.",
            ra: "DIRECTOR[name] ∪ ACTOR[name]",
            sql: "SELECT name FROM director UNION SELECT name FROM actor ORDER BY name;"
        },
        "D16": {
            cat: "H3",
            natural: "Find movie IDs that appear both in the movie table and in awards.",
            ra: "MOVIE[movie_id] ∩ AWARD[movie_id]",
            sql: "SELECT movie_id FROM movie INTERSECT SELECT movie_id FROM award ORDER BY movie_id;"
        },
        "D17": {
            cat: "H2",
            natural: "Find directors who have not directed any movie yet.",
            ra: "DIRECTOR[director_id] \\ MOVIE[director_id]",
            sql: "SELECT director_id FROM director EXCEPT SELECT director_id FROM movie ORDER BY director_id;"
        },
        "D18": {
            cat: "I1",
            natural: "List all movies that have at least one award.",
            ra: "MOVIE < AWARD",
            sql: "SELECT DISTINCT m.movie_id FROM movie m JOIN award a ON m.movie_id = a.movie_id ORDER BY m.movie_id;"
        },
        "D19": {
            cat: "I2",
            natural: "Show movie titles together with each award name they received.",
            ra: "(MOVIE < AWARD)[title, award_name]",
            sql: "SELECT DISTINCT m.title, a.award_name FROM movie m JOIN award a ON m.movie_id = a.movie_id ORDER BY m.title;"
        },
        "D20": {
            cat: "J",
            natural: "Find awarded movies using an EXISTS predicate (Variant 1).",
            ra: "(MOVIE < AWARD)[movie_id, title]",
            sql: "SELECT DISTINCT m.movie_id, m.title FROM movie m WHERE EXISTS (SELECT 1 FROM award a WHERE a.movie_id = m.movie_id) ORDER BY m.movie_id;"
        },
        "D21": {
            cat: "J",
            natural: "Find awarded movies using an IN predicate (Variant 2).",
            ra: "(MOVIE < AWARD)[movie_id, title]",
            sql: "SELECT DISTINCT m.movie_id, m.title FROM movie m WHERE m.movie_id IN (SELECT a.movie_id FROM award a) ORDER BY m.movie_id;"
        },
        "D22": {
            cat: "J",
            natural: "Find awarded movies using a direct JOIN (Variant 3).",
            ra: "(MOVIE < AWARD)[movie_id, title]",
            sql: "SELECT DISTINCT m.movie_id, m.title FROM movie m JOIN award a ON m.movie_id = a.movie_id ORDER BY m.movie_id;"
        },
        "D23": {
            cat: "K",
            natural: "Show every column and row from the movie table.",
            ra: "MOVIE",
            sql: "SELECT * FROM movie ORDER BY movie_id;"
        },
        "D24": {
            cat: "L",
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
            cat: "N",
            natural: "Show all studios with their country information.",
            ra: "STUDIO !< COUNTRY",
            sql: "SELECT s.studio_id, s.studio_name, s.country_id, c.country_id, c.country_name FROM studio s LEFT JOIN country c ON s.country_id = c.country_id ORDER BY s.studio_id;"
        },
        "D27": {
            cat: "O",
            natural: "Display movie title, release year, IMDb rating, and runtime.",
            ra: "MOVIE[title, year, imdb_rating, runtime]",
            sql: "SELECT DISTINCT title, year, imdb_rating, runtime FROM movie ORDER BY title;"
        },
        "D28": {
            cat: "P",
            natural: "Generate every combination of genres and countries.",
            ra: "GENRE × COUNTRY",
            sql: "SELECT * FROM genre CROSS JOIN country ORDER BY genre_id, country_id;"
        },
        "D29": {
            cat: "CN",
            natural: "List all movies with their award information, keeping rows for movies that have never won.",
            ra: "MOVIE !< AWARD",
            sql: "SELECT m.movie_id, m.title, a.movie_id, a.award_name FROM movie m LEFT JOIN award a ON m.movie_id = a.movie_id ORDER BY m.movie_id;"
        },
        "D30": {
            cat: "D1N",
            natural: "List all directors together with their movies, including directors who have no films yet.",
            ra: "DIRECTOR !< MOVIE",
            sql: "SELECT d.director_id, d.name, m.movie_id, m.title, m.director_id FROM director d LEFT JOIN movie m ON d.director_id = m.director_id ORDER BY d.director_id;"
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

            if (fieldName === 'natural' && textarea.nextSibling && textarea.nextSibling.CodeMirror) {
                textarea.nextSibling.CodeMirror.setValue(correctValue);
            }
            changesCount++;
        }
    };

    console.group("%c📝 CATEGORY CHECKLIST (Click these manually!)", "color: blue; font-size: 14px;");
    for (const [id, data] of Object.entries(queries)) {
        updateField(id, 'natural', data.natural);
        updateField(id, 'ra', data.ra);
        updateField(id, 'sql', data.sql);
        console.log(`${id}: %c${data.cat}`, "color: green; font-weight: bold;");
    }
    console.groupEnd();

    if (changesCount > 0) {
        console.log(`%c✅ DONE! Updated ${changesCount} fields.`, 'color: green; font-size: 16px; font-weight: bold;');
        alert(`V15 FIX COMPLETE!\n\n1. CHECK CONSOLE for Categories.\n2. Add Categories manually.\n3. CLICK SAVE.\n\nNote: RA simplified - no column projections on joins.`);
    } else {
        console.log("%c✅ Data is already synchronized.", 'color: green; font-weight: bold;');
        alert("No text changes needed. Please ensure Categories are set correctly.");
    }

})();
