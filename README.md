# Twelve Standalone

Unofficial, continuously-rebuilt Android APKs of the [LineageOS Twelve music
player](https://github.com/LineageOS/android_packages_apps_Twelve)
(`org.lineageos.twelve`), delivered as an installable F-Droid repository.

This repository ships **no original code**. Workflows clone the upstream
LineageOS source, build it with Gradle, sign it, and publish a self-hosted
F-Droid repo on GitHub Pages — so the app can run on any **Android 11+**
device without LineageOS installed.

## How it works

One workflow (`.github/workflows/sync-build-fdroid.yml`) runs daily at 05:30 UTC
and on demand, in three stages:

1. **Sync** — reads the latest commit of the upstream `lineage-24.0` branch via
   the GitHub API. No manual pinning needed: every run builds whatever upstream
   published most recently.
2. **Build** — clones that exact upstream snapshot, rewrites the hardcoded
   `versionCode`/`versionName` to a commit-date / commit-hash scheme
   (upstream pins both, which would break app updates), builds a universal
   `assembleRelease` APK, then zipaligns + signs it.
3. **F-Droid repo** — runs `fdroidserver`, regenerates the signed
   `index-v1`/`index-v2` from the APK (metadata and `config.yml` are generated
   in CI from the repository secrets; passwords never touch git), commits the
   metadata for traceability, and force-pushes the repo contents to the
   `gh-pages` branch under `/repo/`. `UPSTREAM_COMMIT` records the last
   successfully published upstream snapshot.

## Install

### Via F-Droid

1. Open the F-Droid client → **Settings** → **Repositories** → **+**.
2. Add: `https://jantozm-dev.github.io/lineage-music-standalone-/repo`
3. Leave the fingerprint empty (the repo is served over GitHub Pages HTTPS).
4. Refresh, search **"Twelve"**, install. Updates continue to arrive there
   automatically as upstream changes.

Landing page: [index.html](https://jantozm-dev.github.io/lineage-music-standalone-/repo/)
(copy lives in `fdroid/repo/index.html`).

### Direct APK

Each build also produces an APK artifact
(`org.lineageos.twelve_<versionCode>.apk`) on the workflow run page, which can
be sideloaded directly ("install unknown apps" permission required).

## Configuration

The signing setup is stored as repository secrets (Settings → Secrets →
Actions):

| Secret | Purpose |
| --- | --- |
| `FDROID_KEYSTORE` | Base64-encoded `.jks` used to sign the APKs and the F-Droid index |
| `FDROID_KEYSTORE_PASSWORD` | Keystore password |
| `FDROID_KEY_ALIAS` | Key alias |
| `FDROID_KEY_PASSWORD` | Key password |

If the secrets are absent, the workflow falls back to an **ephemeral keystore**:
builds still succeed, but every run produces a differently-signed APK, so
installed apps **cannot update in place** and F-Droid clients cannot upgrade
them. Set the secrets once with the helper script to get stable updates:

```bash
scripts/make-keystore.sh '<your-password>'
```

The script prints four `gh secret set` commands (it never commits the key).

## Manual triggers

- **Run everything now:** Actions → *Sync upstream, build APK, publish F-Droid
  repo* → **Run workflow**.
- The daily cron does the same thing automatically.
- `UPSTREAM_COMMIT` shows the upstream snapshot the current release was built
  from; check it out locally any time:
  `git clone https://github.com/LineageOS/android_packages_apps_Twelve && git -C android_packages_apps_Twelve checkout $(cat UPSTREAM_COMMIT)`

## Requirements & limits

- Android 11+ (upstream `minSdk 30`). Older Android versions are not supported
  by the twelve-lineage-24.0 branch.
- Universal APK (all ABIs), minified `release` build.
- Each upstream commit becomes one release; its `versionCode` is the upstream
  commit date formatted as `YYYYMMDDHH`.

## Legal

Twelve is © The LineageOS Project, licensed [Apache-2.0](https://www.apache.org/licenses/LICENSE-2.0).
This is a community packaging project and is not affiliated with or endorsed
by LineageOS.
