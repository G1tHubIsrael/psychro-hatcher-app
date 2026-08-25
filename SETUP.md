# Psychrometric Hatcher Calc — Setup Guide

This folder is a small, self-contained web app: `index.html` + `manifest.json` + `sw.js` + `icons/`.
No build step, no npm, nothing to compile. It's ready to publish as-is.

Two things need a one-time setup, both free and both entirely under your own accounts:

1. **Hosting** (GitHub Pages) — gives you a real URL you can install as an app icon on your phone.
2. **Cloud sync** (Supabase) — optional; lets batch data sync across devices. Skip this and the app
   still works perfectly, just saving data only on the device you're using.

---

## 1. Host it on GitHub Pages

1. Go to [github.com/new](https://github.com/new) and create a new **public** repository —
   name it anything, e.g. `psychro-hatcher-app`. Don't add a README/gitignore (this folder already
   has the files).
2. On your PC, open a terminal in this folder and run:
   ```bash
   git init
   git add .
   git commit -m "Psychrometric hatcher app"
   git branch -M main
   git remote add origin https://github.com/<your-username>/psychro-hatcher-app.git
   git push -u origin main
   ```
3. On GitHub, go to your new repo → **Settings → Pages** → under "Build and deployment",
   set **Source** to **GitHub Actions**. The included workflow
   (`.github/workflows/pages.yml`) will build and publish automatically on every push.
4. After a minute, your app is live at:
   `https://<your-username>.github.io/psychro-hatcher-app/`

### Installing it as an app
- **Android (Chrome)**: open the URL, tap the ⋮ menu → **Add to Home screen** / **Install app**.
- **iPhone (Safari)**: open the URL, tap the Share icon → **Add to Home Screen**.
- **Desktop (Chrome/Edge)**: open the URL, click the install icon (⊕) in the address bar.

Once installed, it opens like a real app with your icon, and keeps working offline —
the service worker (`sw.js`) caches the app shell the first time you open it online.

---

## 2. Cloud sync (optional) — Supabase

Skip this section entirely if you're happy with local-only storage per device.

1. Go to [supabase.com](https://supabase.com) and create a free account + a new project
   (pick any name/region; the free tier is enough for this).
2. Once the project is ready, open **SQL Editor → New query**, paste in the contents of
   `supabase-schema.sql` (in this folder), and run it. This creates the `batches` and
   `readings` tables.
3. In your Supabase project, go to **Project Settings → API**. Copy:
   - **Project URL** (looks like `https://xxxxx.supabase.co`)
   - **anon public** key (a long string starting with `eyJ...`)
4. In the app, go to the **Batches** tab → **Cloud Sync Setup** → paste both values in →
   **Save & Sync**. From then on, every batch/reading you record syncs automatically
   whenever you have a connection, and pulls in data recorded from other devices too.

**Security note:** the anon key isn't a secret in the usual sense (it's meant to be used from a
browser), but the Row Level Security policy in `supabase-schema.sql` is set to fully permissive —
anyone with your Project URL + anon key can read/write this data. That's a reasonable tradeoff for
a small private hatchery tool, but don't post those two values publicly (e.g. in a public GitHub repo
README, a public spreadsheet, etc). If you ever want tighter security (e.g. a login/PIN), that's a
further step we can add later — similar to how the existing Cloudflare dashboard's PIN auth works.

---

## What stays the same

- `psychro-calc.html` (in the parent `psychometric calculator` folder) is untouched — it's still a
  zero-setup, fully offline, double-click file with no batch tracking. Keep using it if you just
  want the calculator with nothing to install.
- This new `index.html` app is the "leveled up" version: same calculator + Hatcher Guide + Live
  Profile, plus batch recording, analytics charts, CSV export, and installable app icon.
