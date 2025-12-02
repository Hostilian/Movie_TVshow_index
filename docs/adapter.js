// Simple client-side adapter: static JSON fallback + optional remote API

const SITE_API_URL = null; // e.g., "https://your-api.example.com" or leave null for static JSON

async function fetchJSON(path) {
  const res = await fetch(path);
  if (!res.ok) throw new Error(`Failed to fetch ${path}: ${res.status}`);
  return res.json();
}

async function getMovies() {
  if (SITE_API_URL) {
    return fetchJSON(`${SITE_API_URL}/movies`);
  }
  return fetchJSON("./data/movies.json");
}

async function getActors() {
  if (SITE_API_URL) {
    return fetchJSON(`${SITE_API_URL}/actors`);
  }
  return fetchJSON("./data/actors.json");
}

async function getDirectors() {
  if (SITE_API_URL) {
    return fetchJSON(`${SITE_API_URL}/directors`);
  }
  return fetchJSON("./data/directors.json");
}

async function initSite() {
  const m = document.getElementById("movies-list");
  if (m) {
    try {
      const movies = await getMovies();
      m.innerHTML = movies.map(x => `<li>${x.title} (${x.year})</li>`).join("");
    } catch (e) {
      m.innerHTML = `<li style='color:#f87171'>No movies data found</li>`;
    }
  }
}

document.addEventListener("DOMContentLoaded", initSite);
