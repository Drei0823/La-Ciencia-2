# Login & Logout Tracker

Real-time login/logout tracking app with shared data across all devices. Built for **GitHub Pages** deployment with **Supabase** as the database.

## Features

- Log In / Log Out with Full Name and Section
- Real-time sync across all users (no page refresh)
- Philippine Standard Time (Asia/Manila) timestamps
- Dashboard: Total Log Ins, Log Outs, Active Users
- Search, filter, CSV export, dark mode
- Mobile-responsive modern UI

---

## Deploy to GitHub Pages (Recommended)

### Step 1: Create a Supabase Project (Free)

1. Go to [supabase.com](https://supabase.com) and create a free account
2. Click **New Project** and wait for it to finish setting up
3. Open **SQL Editor** → **New query**
4. Paste the contents of `supabase/setup.sql` and click **Run**
5. Go to **Project Settings → API** and copy:
   - **Project URL** (e.g. `https://xxxxx.supabase.co`)
   - **anon public** key

### Step 2: Enable Realtime (if not already)

1. Go to **Database → Replication**
2. Enable replication for the `attendance_logs` table

### Step 3: Push to GitHub

```bash
git init
git add .
git commit -m "Add login logout tracker"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
git push -u origin main
```

### Step 4: Add GitHub Secrets

In your GitHub repo:

1. Go to **Settings → Secrets and variables → Actions**
2. Add these repository secrets:

| Secret Name | Value |
|---|---|
| `SUPABASE_URL` | Your Supabase Project URL |
| `SUPABASE_ANON_KEY` | Your Supabase anon public key |

### Step 5: Enable GitHub Pages

1. Go to **Settings → Pages**
2. Under **Build and deployment**, set **Source** to **GitHub Actions**
3. Push to `main` — the workflow in `.github/workflows/deploy.yml` runs automatically
4. Your app will be live at: `https://YOUR_USERNAME.github.io/YOUR_REPO/`

---

## Alternative: Simple Branch Deploy

If you prefer not to use GitHub Actions:

1. Edit `js/config.js` with your Supabase URL and anon key
2. Push to GitHub
3. **Settings → Pages → Deploy from branch → `main` / root**

> Supabase anon keys are safe to commit — they are designed for client-side use. Security is enforced via Row Level Security policies.

---

## Run Locally

You need a local server (browsers block database requests from `file://`):

```powershell
cd "c:\Users\Andrei\Documents\New folder (2)"
# Edit js/config.js with your Supabase credentials first
python -m http.server 8080
```

Open **http://localhost:8080**

---

## Project Structure

```
├── index.html                  # Main app
├── 404.html                    # GitHub Pages SPA fallback
├── .nojekyll                   # Prevents Jekyll processing on GitHub Pages
├── .github/workflows/deploy.yml # Auto-deploy with secret injection
├── css/styles.css              # Styles + dark mode
├── js/
│   ├── config.js               # Supabase credentials
│   └── app.js                  # Application logic
├── supabase/setup.sql          # Database table + policies
└── README.md
```

---

## How It Works

| Field | Description |
|---|---|
| `full_name` | User's full name |
| `section` | User's section |
| `action_type` | `IN` or `OUT` |
| `date_display` | Pre-formatted date (PST) |
| `time_display` | Pre-formatted time (PST) |
| `created_at` | ISO timestamp for sorting |

**Active users** = users whose most recent action is `IN` (by name + section).

**Real-time** = Supabase `postgres_changes` subscription pushes updates instantly to all connected clients.

---

## Troubleshooting

| Problem | Fix |
|---|---|
| "Database not configured" banner | Add Supabase credentials to `js/config.js` or GitHub secrets |
| CSS/JS not loading on GitHub Pages | Ensure `.nojekyll` exists; use GitHub Actions deploy |
| "Failed to load data" | Run `supabase/setup.sql` and enable Realtime replication |
| "Failed to record action" | Check RLS policies in Supabase SQL Editor |
| Works locally but not on GitHub | Verify GitHub Actions completed and secrets are set |

---

## License

MIT
