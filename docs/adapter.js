/**
 * Cinema Database Adapter
 * Fetches data from static JSON files (GitHub Pages) or optional API
 * 
 * Usage:
 *   const movies = await getMovies();
 *   const actors = await getActors();
 */

// API URL - set to your deployed FastAPI endpoint, or null for static JSON
const API_URL = null; // e.g., "https://your-api.onrender.com"

// Data cache
const cache = {};

/**
 * Fetch JSON data with caching
 */
async function fetchJSON(path) {
  if (cache[path]) return cache[path];
  
  const res = await fetch(path);
  if (!res.ok) throw new Error(`Failed to fetch ${path}: ${res.status}`);
  
  const data = await res.json();
  cache[path] = data;
  return data;
}

/**
 * Get all movies
 */
async function getMovies() {
  if (API_URL) {
    return fetchJSON(`${API_URL}/movies`);
  }
  return fetchJSON("./data/movies.json");
}

/**
 * Get all actors
 */
async function getActors() {
  if (API_URL) {
    return fetchJSON(`${API_URL}/actors`);
  }
  return fetchJSON("./data/actors.json");
}

/**
 * Get all directors
 */
async function getDirectors() {
  if (API_URL) {
    return fetchJSON(`${API_URL}/directors`);
  }
  return fetchJSON("./data/directors.json");
}

/**
 * Get all genres
 */
async function getGenres() {
  if (API_URL) {
    return fetchJSON(`${API_URL}/genres`);
  }
  return fetchJSON("./data/genres.json");
}

/**
 * Get all studios
 */
async function getStudios() {
  return fetchJSON("./data/studios.json");
}

/**
 * Get all countries
 */
async function getCountries() {
  return fetchJSON("./data/countries.json");
}

/**
 * Get combined database
 */
async function getDatabase() {
  return fetchJSON("./data/database.json");
}

/**
 * Format movie card HTML
 */
function movieCard(movie) {
  return `
    <div class="movie-card">
      <h3>${movie.title}</h3>
      <p class="year">${movie.release_year || movie.year || 'N/A'}</p>
      <p class="director">Director: ${movie.director_name || 'Unknown'}</p>
      <p class="duration">${movie.duration_minutes || '?'} min</p>
      <p class="studio">${movie.studio_name || ''}</p>
    </div>
  `;
}

/**
 * Render movies list
 */
async function renderMovies(containerId = 'movies-list') {
  const container = document.getElementById(containerId);
  if (!container) return;
  
  try {
    const movies = await getMovies();
    container.innerHTML = movies.map(movieCard).join('');
  } catch (e) {
    console.error('Failed to load movies:', e);
    container.innerHTML = '<p class="error">Failed to load movies data</p>';
  }
}

/**
 * Render stats
 */
async function renderStats(containerId = 'stats') {
  const container = document.getElementById(containerId);
  if (!container) return;
  
  try {
    const db = await getDatabase();
    container.innerHTML = `
      <div class="stat">
        <span class="number">${db.movies?.length || 0}</span>
        <span class="label">Movies</span>
      </div>
      <div class="stat">
        <span class="number">${db.actors?.length || 0}</span>
        <span class="label">Actors</span>
      </div>
      <div class="stat">
        <span class="number">${db.directors?.length || 0}</span>
        <span class="label">Directors</span>
      </div>
      <div class="stat">
        <span class="number">${db.genres?.length || 0}</span>
        <span class="label">Genres</span>
      </div>
    `;
  } catch (e) {
    console.error('Failed to load stats:', e);
  }
}

/**
 * Initialize the site
 */
async function initSite() {
  console.log('Cinema Database initialized');
  
  // Render movies if container exists
  await renderMovies('movies-list');
  
  // Render stats if container exists
  await renderStats('stats');
}

// Initialize on page load
document.addEventListener('DOMContentLoaded', initSite);
