# 🎬 Movie Database Project

[![Deploy to GitHub Pages](https://github.com/Hostilian/Movie_TVshow_index/actions/workflows/deploy.yml/badge.svg)](https://github.com/Hostilian/Movie_TVshow_index/actions/workflows/deploy.yml)
[![GitHub Pages](https://img.shields.io/badge/demo-live-brightgreen)](https://hostilian.github.io/Movie_TVshow_index/)

A comprehensive movie database system built with **PostgreSQL** for the **EIE36E Database Systems** course at Czech University of Life Sciences Prague.

---

## 🌐 Live Demo

**[View Live Website →](https://hostilian.github.io/Movie_TVshow_index/)**

---

## 📋 Project Overview

This project demonstrates relational database design principles through a movie database featuring:

| Data | Count |
|------|-------|
| 🎬 Movies | 15 |
| 🎥 Directors | 15 |
| 🎭 Actors | 30 |
| 🏷️ Genres | 12 |
| 🌍 Countries | 10 |
| 🏢 Studios | 10 |
| 🏆 Awards | 15 |

---

## 🗄️ Database Schema

The database consists of **11 tables** organized into primary entities and binding (junction) tables:

### Primary Entities (8 Tables)

| Table | Description |
|-------|-------------|
| `DIRECTOR` | Director information (name, birth year) |
| `ACTOR` | Actor information (name, birth year) |
| `GENRE` | Film genre categories |
| `COUNTRY` | Countries with ISO codes |
| `STUDIO` | Production studios/companies |
| `MOVIE` | Central entity with all movie details |
| `USER_RATING` | User reviews and ratings |
| `AWARD` | Movie awards and nominations |

### Binding Tables (3 Tables)

| Table | Relationship |
|-------|--------------|
| `MOVIE_ACTOR` | M:N relationship between movies and actors |
| `MOVIE_GENRE` | M:N relationship between movies and genres |
| `MOVIE_COUNTRY` | M:N relationship between movies and countries |

---

## 🛠️ Technologies Used

- **Database:** PostgreSQL
- **Frontend:** HTML5, CSS3, JavaScript (Vanilla)
- **Hosting:** GitHub Pages
- **CI/CD:** GitHub Actions
- **Data Source:** [OMDb API](https://www.omdbapi.com/)

---

## 📁 Project Structure

```
Movie_TVshow_index/
├── .github/
│   └── workflows/
│       └── deploy.yml          # GitHub Pages deployment
├── docs/                       # Website files (deployed)
│   ├── index.html              # Main website
│   ├── adapter.js              # Database adapter
│   └── data/
│       └── database.json       # Full database export
├── 01_semester_work.xml        # Project documentation
├── 02_relational_schema.txt    # Schema description
├── 03_create_script.sql        # DDL - Table creation
├── 04_insert_script.sql        # DML - Data insertion
├── 05_all_queries_NEW.sql      # 30+ SQL queries
├── 06_conceptual_schema.md     # ER diagram description
└── README.md                   # This file
```

---

## 🚀 Getting Started

### View the Website

Simply visit the [live demo](https://hostilian.github.io/Movie_TVshow_index/).

### Run the Database Locally

1. **Install PostgreSQL** (version 12+)

2. **Create the database:**
   ```sql
   CREATE DATABASE movie_db;
   ```

3. **Run the DDL script:**
   ```bash
   psql -d movie_db -f 03_create_script.sql
   ```

4. **Insert sample data:**
   ```bash
   psql -d movie_db -f 04_insert_script.sql
   ```

5. **Run queries:**
   ```bash
   psql -d movie_db -f 05_all_queries_NEW.sql
   ```

---

## 📊 SQL Query Categories

The project includes **30+ SQL queries** covering all required categories:

| Category | Description | Count |
|----------|-------------|-------|
| A | Simple SELECT with WHERE | 4 |
| B | JOIN queries (2+ tables) | 4 |
| C | Aggregate functions (GROUP BY) | 4 |
| D1 | SELECT with nested SELECT (WHERE) | 2 |
| D2 | SELECT with nested SELECT (FROM) | 2 |
| F | UNION / INTERSECT / EXCEPT | 2 |
| G | INSERT with SELECT | 2 |
| H | UPDATE with nested SELECT | 2 |
| I | DELETE with nested SELECT | 2 |
| J | CREATE VIEW + SELECT | 2 |
| CN | Correlated nested SELECT | 2 |
| N | Non-correlated nested SELECT | 2 |

---

## ✨ Website Features

- 🎥 **Movie Grid** — Browse all movies with poster images
- 🔍 **Search** — Filter movies by title in real-time
- 🏷️ **Genre Filters** — Filter by Action, Drama, Sci-Fi, etc.
- 📱 **Responsive Design** — Works on mobile, tablet, desktop
- 🎭 **Movie Details Modal** — Full info with cast, director, awards
- 👥 **Director & Actor Carousels** — Horizontal scroll galleries
- 📊 **Database Schema Section** — View all table structures
- 🌙 **Dark Theme** — Netflix-inspired modern design

---

## 🔧 Deployment

### Automatic Deployment

Push to `main` branch triggers automatic deployment via GitHub Actions:

```cmd
git add .
git commit -m "Update website"
git push origin main
```

### Manual Setup (First Time)

1. Go to **Repository Settings** → **Pages**
2. Set Source to **GitHub Actions**
3. Wait for the workflow to complete

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
</p>
