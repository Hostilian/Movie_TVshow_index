# 🎬 Cinema Database System

> **EIE36E Database Systems** - Semester Project
> Student: Ozturk Eren (xozte001)
> Database: PostgreSQL @ db.kii.pef.czu.cz

[![Deploy to GitHub Pages](https://github.com/Hostilian/Movie_TVshow_index/actions/workflows/jekyll-gh-pages.yml/badge.svg)](https://github.com/Hostilian/Movie_TVshow_index/actions/workflows/jekyll-gh-pages.yml)
[![GitHub Pages](https://img.shields.io/badge/demo-live-brightgreen)](https://hostilian.github.io/Movie_TVshow_index/)
[![PostgreSQL](https://img.shields.io/badge/database-PostgreSQL-336791)](https://www.postgresql.org/)

---

## 🌐 Live Site

**[https://hostilian.github.io/Movie_TVshow_index/](https://hostilian.github.io/Movie_TVshow_index/)**

---

## 📋 Project Overview

This project implements a **Cinema Database System** designed to manage movie metadata. It tracks:
- **Films** with runtime, box office, and release dates
- **People** involved (actors, directors) with biographical data
- **Categorization** (genres) for content classification
- **Production details** (countries, studios)
- **User reception** (ratings, awards)

**Data Source:** [OMDb API](https://www.omdbapi.com/) (API Key: 11888daa)

---

## 🗃️ Database Schema

| Entity | Type | Description |
|--------|------|-------------|
| `DIRECTOR` | Primary | Film directors with birth year |
| `ACTOR` | Primary | Actors/performers |
| `GENRE` | Primary | Genre categories (Action, Drama, etc.) |
| `COUNTRY` | Primary | Production countries with ISO codes |
| `STUDIO` | Primary | Production companies |
| `MOVIE` | Primary | Central entity with all film metadata |
| `USER_RATING` | Primary | User ratings (1-10 scale) |
| `AWARD` | Primary | Award nominations and wins |
| `MOVIE_ACTOR` | Junction | M:N movie-actor relationship |
| `MOVIE_GENRE` | Junction | M:N movie-genre relationship |
| `MOVIE_COUNTRY` | Junction | M:N movie-country relationship |

**Total: 11 tables** (8 primary + 3 junction)

---

## 📁 Project Structure

```
Movie_TVshow_index/
├── 01_semester_work.xml      # Portal semester work config
├── 02_relational_schema.txt  # Relational schema notation
├── 03_create_script.sql      # DDL - Create tables
├── 04_insert_script.sql      # DML - Insert sample data
├── 05_all_queries_NEW.sql    # All 30 queries (RA + SQL)
├── 06_conceptual_schema.md   # Conceptual schema docs
├── conceptual_schema.json    # JSON schema for portal
├── docs/                     # GitHub Pages website
│   ├── index.html           # Main site (dual-view: Netflix + Index)
│   ├── .nojekyll            # Prevent Jekyll processing
│   └── data/                # Static JSON data
│       └── database.json    # Complete database export
├── .github/workflows/
│   └── jekyll-gh-pages.yml  # GitHub Pages CI/CD
└── README.md                # This file
```

---

## ✨ Website Features

### 🎥 Main View (Netflix-style)
- **Movie Grid:** Poster cards with hover effects and ratings
- **Quick Info:** Click any movie for detailed modal with cast, awards, plot
- **Genre Filters:** Filter by Action, Drama, Thriller, etc.
- **Search:** Real-time search across all movies
- **Responsive:** Works on desktop, tablet, and mobile

### 📁 Index View (Pirate Bay-style)
- **File Listing:** All movies displayed as files with metadata
- **Columns:** Title, Year, Size, Runtime, Rating, Director
- **Sortable:** Click headers to sort by any column
- **Search:** Filter the file listing in real-time
- **Database-connected:** Pulls data directly from database.json

---

## 🚀 Quick Start

### 1. Database Setup (PostgreSQL)

```bash
# Connect to your database
psql -h db.kii.pef.czu.cz -U xozte001 -d xozte001

# Run DDL script
\i 03_create_script.sql

# Run DML script
\i 04_insert_script.sql

# Verify
SELECT COUNT(*) FROM movie;  -- Should return 15
```

### 2. Local Preview

```bash
# Start local server
cd docs
python -m http.server 8080

# Visit http://localhost:8080
```

### 3. Deploy to GitHub Pages

```bash
git add .
git commit -m "Deploy cinema database site"
git push origin main

# Enable Pages: Settings → Pages → Source: GitHub Actions
# Deployment configured via .github/workflows/jekyll-gh-pages.yml
```

---

## 📊 Database Statistics

| Entity | Count | Description |
|--------|-------|-------------|
| Movies | 15 | Feature films with metadata |
| Directors | 15 | Film directors |
| Actors | 30 | Cast members |
| Genres | 12 | Genre categories |
| Countries | 10 | Production countries |
| Studios | 10 | Production companies |
| Awards | 15 | Award nominations/wins |
| User Ratings | 10 | User reviews |

---

## 📊 Query Categories Covered

| Category | Count | Description |
|----------|-------|-------------|
| A | 2 | Projection |
| B | 2 | Selection |
| CN | 2 | Left Outer Join (C-type) |
| D1N | 2 | Left Outer Join (D1-type) |
| D2 | 1 | Three-table join |
| F1-F5 | 5 | Join + Selection/Projection combos |
| G1-G4 | 4 | Column projections |
| H1-H3 | 3 | Set operations (Union, Intersect, Except) |
| I1-I2 | 2 | Inner join variants |
| J | 1 | Selection with comparison |
| K | 1 | Full table scan |
| L | 1 | Distinct projection |
| M | 1 | NULL check |
| O | 1 | Multi-column projection |
| P | 1 | Cartesian product |

**Total: 30 queries** covering all required categories

---

## 🛠️ Technology Stack

- **Database:** PostgreSQL 15
- **Frontend:** HTML5, CSS3, JavaScript (vanilla)
- **Styling:** Netflix-inspired dark theme
- **Deployment:** GitHub Pages + Jekyll Actions
- **Data Source:** OMDb API (key: 11888daa)
- **Data Format:** JSON (database.json)

---

## 📝 Portal Submission Checklist

- [x] Conceptual schema (JSON)
- [x] Relational schema (text)
- [x] Create script (DDL)
- [x] Insert script (DML)
- [x] 30 queries with Natural, RA, SQL
- [x] All category coverage (CN, D1N, etc.)
- [x] Loop discussion document
- [x] Live website deployment

---

## 📄 License

Academic project for EIE36E Database Systems course.
© 2025 Ozturk Eren (xozte001)
