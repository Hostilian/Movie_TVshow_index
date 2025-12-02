# 🎬 MovieDB Index

[![Deploy to GitHub Pages](https://github.com/Hostilian/Movie_TVshow_index/actions/workflows/jekyll-gh-pages.yml/badge.svg)](https://github.com/Hostilian/Movie_TVshow_index/actions/workflows/jekyll-gh-pages.yml)
[![GitHub Pages](https://img.shields.io/badge/demo-live-brightgreen)](https://hostilian.github.io/Movie_TVshow_index/)
[![PostgreSQL](https://img.shields.io/badge/database-PostgreSQL-336791)](https://www.postgresql.org/)

A comprehensive movie database system with a dual-view interface: a polished Netflix-style showcase and a Pirate Bay-style file index. Built with **PostgreSQL** for the **EIE36E Database Systems** course.

---

## 🌐 Live Demo

**[🎬 View Live Website →](https://hostilian.github.io/Movie_TVshow_index/)**

The website features two views:
- **Main View**: Netflix-style movie showcase with cards, modals, and carousels
- **Index View**: Pirate Bay-style file listing for 2TB+ of content

---

## 📋 Project Overview

| Component | Details |
|-----------|---------|
| 🎬 Movies | 15+ in database, 2000+ indexed |
| 🎥 Directors | 15 featured |
| 🎭 Actors | 30 featured |
| 🏷️ Genres | 12 categories |
| 🌍 Countries | 10 production locations |
| 🏢 Studios | 10 production companies |
| 🏆 Awards | 15 documented |
| 💾 Total Content | 2TB+ indexed files |

---

## 🗄️ Database Architecture

### PostgreSQL Schema (11 Tables)

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  DIRECTOR   │     │    MOVIE    │     │    ACTOR    │
├─────────────┤     ├─────────────┤     ├─────────────┤
│ director_id │◄────│ director_id │     │ actor_id    │
│ name        │     │ movie_id    │────►│ name        │
│ birth_year  │     │ title       │     │ birth_year  │
└─────────────┘     │ year        │     └─────────────┘
                    │ runtime     │            ▲
┌─────────────┐     │ imdb_rating │     ┌──────┴──────┐
│   STUDIO    │     │ plot        │     │ MOVIE_ACTOR │
├─────────────┤     │ poster      │     ├─────────────┤
│ studio_id   │◄────│ studio_id   │     │ movie_id    │
│ studio_name │     └─────────────┘     │ actor_id    │
│ founded_year│            │            └─────────────┘
└─────────────┘            │
                           ▼
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│    GENRE    │◄────│ MOVIE_GENRE │     │   COUNTRY   │
├─────────────┤     ├─────────────┤     ├─────────────┤
│ genre_id    │     │ movie_id    │     │ country_id  │
│ genre_name  │     │ genre_id    │     │ country_name│
└─────────────┘     └─────────────┘     │ country_code│
                                        └─────────────┘
┌─────────────┐     ┌─────────────┐            ▲
│ USER_RATING │     │    AWARD    │     ┌──────┴──────┐
├─────────────┤     ├─────────────┤     │MOVIE_COUNTRY│
│ rating_id   │     │ award_id    │     ├─────────────┤
│ movie_id    │     │ movie_id    │     │ movie_id    │
│ username    │     │ award_name  │     │ country_id  │
│ rating      │     │ category    │     └─────────────┘
│ review      │     │ year        │
└─────────────┘     │ won         │
                    └─────────────┘
```

### Entity Types

| Type | Tables | Description |
|------|--------|-------------|
| **Primary** | DIRECTOR, ACTOR, GENRE, COUNTRY, STUDIO, MOVIE, USER_RATING, AWARD | Core data entities |
| **Binding** | MOVIE_ACTOR, MOVIE_GENRE, MOVIE_COUNTRY | M:N relationships |

---

## 🛠️ Technologies

| Layer | Technology |
|-------|------------|
| **Database** | PostgreSQL 14+ |
| **Backend Data** | JSON (static export from PostgreSQL) |
| **Frontend** | HTML5, CSS3, Vanilla JavaScript |
| **Hosting** | GitHub Pages |
| **CI/CD** | GitHub Actions (Jekyll) |
| **Data Source** | [OMDb API](https://www.omdbapi.com/) |

---

## 📁 Project Structure

```
Movie_TVshow_index/
├── .github/
│   └── workflows/
│       └── jekyll-gh-pages.yml    # GitHub Pages deployment
├── docs/                          # Website (deployed to GitHub Pages)
│   ├── index.html                 # Main website with dual views
│   ├── .nojekyll                  # Bypass Jekyll processing
│   ├── adapter.js                 # Database adapter
│   └── data/
│       └── database.json          # Full database export
├── 01_semester_work.xml           # Project documentation
├── 02_relational_schema.txt       # Schema description
├── 03_create_script.sql           # DDL - Table creation
├── 04_insert_script.sql           # DML - Data insertion
├── 05_all_queries_NEW.sql         # 30+ SQL queries
├── 06_conceptual_schema.md        # ER diagram description
└── README.md                      # This file
```

---

## 🚀 Deployment

### Automatic (GitHub Pages)

Push to `main` triggers automatic deployment:

```bash
git add .
git commit -m "Update"
git push origin main
```

### Manual Setup

1. **Repository Settings** → **Pages**
2. **Source**: GitHub Actions
3. Wait for workflow completion

### Local Preview

```bash
cd docs
python -m http.server 8080
# Visit http://localhost:8080
```

---

## 🗃️ Database Connection

### Static JSON (Current)

The website loads data from `docs/data/database.json`:

```javascript
async function loadDatabase() {
    const response = await fetch('data/database.json');
    db = await response.json();
}
```

### PostgreSQL (Development)

Connect to the course database:

```sql
-- Connection details
Host: db.kii.pef.czu.cz
Database: xozte001
User: xozte001
```

### Exporting to JSON

To update the static JSON from PostgreSQL:

```sql
-- Export movies
COPY (SELECT json_agg(row_to_json(m)) FROM movie m) TO '/tmp/movies.json';
```

---

## 📊 SQL Query Categories

The project includes **30+ SQL queries** covering all requirements:

| Cat | Description | Count |
|-----|-------------|-------|
| A | Simple SELECT with WHERE | 4 |
| B | JOIN queries (2+ tables) | 4 |
| C | Aggregate functions (GROUP BY) | 4 |
| D1 | Nested SELECT in WHERE | 2 |
| D2 | Nested SELECT in FROM | 2 |
| F | UNION / INTERSECT / EXCEPT | 2 |
| G | INSERT with SELECT | 2 |
| H | UPDATE with nested SELECT | 2 |
| I | DELETE with nested SELECT | 2 |
| J | CREATE VIEW + SELECT | 2 |
| CN | Correlated nested SELECT | 2 |
| N | Non-correlated nested SELECT | 2 |

---

## ✨ Website Features

### Main View (Netflix-Style)
- 🎥 Movie grid with poster cards
- 🔍 Real-time search
- 🏷️ Genre filtering
- 🎭 Movie detail modals
- 👥 Director & Actor carousels
- 📊 Database schema visualization
- 🌙 Dark theme

### Index View (Pirate Bay-Style)
- 🏴‍☠️ File listing table
- 📁 Category filters (Movies, TV, Anime, 4K, HDR)
- 🔍 Search functionality
- 📊 File stats (size, seeds, date)
- 💾 Pagination support
- 🎯 Ready for 2TB+ file index

---

## 🔧 Adding Your Movies to Index

Edit the `indexData` array in `docs/index.html`:

```javascript
const indexData = [
    {
        type: 'movie',        // movie, tv, or anime
        name: 'Movie Title',
        year: 2024,
        quality: '4K',        // 4K, 1080p, 720p
        hdr: true,            // HDR support
        codec: 'x265',        // x265 or x264
        size: '45.2 GB',
        date: '2024-12-01',
        seeds: 100,
        category: 'Action'
    },
    // Add more entries...
];
```

### Bulk Import (Future)

For your 2TB collection, create a script to generate JSON:

```python
import os
import json

def scan_movies(path):
    movies = []
    for root, dirs, files in os.walk(path):
        for file in files:
            if file.endswith(('.mkv', '.mp4', '.avi')):
                movies.append({
                    'type': 'movie',
                    'name': os.path.splitext(file)[0],
                    'size': os.path.getsize(os.path.join(root, file)),
                    # Parse more metadata...
                })
    return movies

# Export to JSON
with open('movies_index.json', 'w') as f:
    json.dump(scan_movies('/path/to/movies'), f)
```

---

## 📝 Course Information

| Field | Value |
|-------|-------|
| **Course** | EIE36E Database Systems |
| **University** | Czech University of Life Sciences Prague |
| **Faculty** | Faculty of Economics and Management |
| **Student** | Ozturk Eren |
| **Login** | xozte001 |
| **Server** | db.kii.pef.czu.cz |

---

## 📄 License

This project was created for educational purposes as part of the EIE36E Database Systems course.

---

<p align="center">
  <b>⭐ Star this repo if you found it helpful!</b>
  <br><br>
  <a href="https://hostilian.github.io/Movie_TVshow_index/">🎬 View Live Demo</a>
</p>
