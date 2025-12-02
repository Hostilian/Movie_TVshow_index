# Cinema Database System (DBS-2025)

A polished static website and CI/CD pipeline to showcase your BI-DBS.21 semester project and publish it via GitHub Pages.

## Live Site

After deployment: `https://hostilian.github.io/0zeroipsumgenerator/`

## Project Structure

- `project_submission/docs/index.html` — main website (static)
- `.github/workflows/deploy.yml` — GitHub Actions Pages pipeline
- `project_submission/docs/assets/` — optional images/css/js
- `project_submission/docs/data/` — optional JSON stubs

## Deploy (one-time)

1. Commit and push:
```cmd
cd "c:\Users\Hostilian\Downloads\database\Course_EIE36E_Database_System..._.1068306"
git add .
git commit -m "Website + Pages pipeline"
git push origin main
```
2. Enable Pages: Repository → Settings → Pages → Source: GitHub Actions.
3. Wait for the `Deploy to GitHub Pages` workflow to finish.

## Updating the Site
Push changes to `main` — the site redeploys automatically.

## Connecting to a Database
GitHub Pages serves static files only; it cannot connect directly to your database. Use one of these approaches:

- REST API: Host a simple API (e.g., on Render/Heroku/Vercel) that the site can fetch (
  `https://your-api.example.com/movies`).
- JSON snapshots: Export read-only data (e.g., `movies.json`) into `project_submission/docs/data/` for static display.

The site includes a small client adapter (`adapter.js`) to:
- Load static JSON from `docs/data/` if present;
- Or fetch remote API if `SITE_API_URL` is set.

### Configure Remote API
Edit `project_submission/docs/adapter.js`:
```js
const SITE_API_URL = "https://your-api.example.com"; // set to your API base or leave null for static JSON
```

### Static JSON Option
Place JSON files under `project_submission/docs/data/`:
- `movies.json`
- `actors.json`
- `directors.json`

The adapter will render sections when files exist.

## Local Preview
You can open `project_submission/docs/index.html` directly in a browser. For local CORS-friendly previews, use:
```cmd
python -m http.server 8080
```
Then visit `http://localhost:8080/project_submission/docs/`.

## Troubleshooting
- Ensure default branch is `main` or update `deploy.yml`.
- If Pages shows 404, wait 1–2 minutes after workflow success.
- If assets aren’t loading, confirm paths under `project_submission/docs/`.
