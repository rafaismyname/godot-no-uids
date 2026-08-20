# Godot "No UID" Fork

> **This is a custom build of Godot Engine.**
>
> 🛑 **Feature**: This build **disables** the automatic generation of `.uid` files by default.
> 📦 **Builds**: Check the [Releases Page](../../releases) for pre-compiled binaries of stable versions (Windows, macOS, Linux).
> 🤖 **Automation**: This repo automatically checks for new Godot stable versions daily, applies [Patch #100973](https://github.com/godotengine/godot/pull/100973), and compiles new binaries.

---

## 📥 Installation

### macOS (Homebrew)

The easiest way to install on macOS is via Homebrew:

```bash
brew tap rafaismyname/godot-no-uids
brew install --cask godot-no-uids
```

### Linux (Homebrew)

```bash
brew tap rafaismyname/godot-no-uids
brew install godot-no-uids
```

### A specific version

Every published release stays installable, side by side:

```bash
brew install --cask godot-no-uids@4.6.2   # macOS
brew install godot-no-uids@4.6.2          # Linux
```

See the [tap repository](https://github.com/rafaismyname/homebrew-godot-no-uids) for the full list.

### Manual Download

Download the release for your platform from the [Releases page](../../releases). Windows users: Homebrew doesn't run on Windows, so grab the `.exe` directly.

---

## 🛠 One-Line Clean Script

If you have an existing project with UIDs, you can delete them all in one go using our hosted script.

### Mac / Linux
```bash
curl -sL https://raw.githubusercontent.com/rafaismyname/godot-no-uids/master/scripts/clean_uids.sh | bash
```

### Automation (CI/CD)
You can include this in your project's CI pipeline to ensure no `.uid` files are ever checked in.

```bash
wget -O clean_uids.sh https://raw.githubusercontent.com/rafaismyname/godot-no-uids/master/scripts/clean_uids.sh
chmod +x clean_uids.sh
./clean_uids.sh .
```

---

## 📁 What's in this repo

This repo holds the **build automation only** — it does not vendor a copy of the Godot source tree.
Each build checks out [`godotengine/godot`](https://github.com/godotengine/godot) fresh at the
upstream release tag, applies the patch, and compiles.

| Path | Purpose |
| --- | --- |
| [`.github/workflows/build_no_uid.yml`](.github/workflows/build_no_uid.yml) | Daily check for a new Godot stable release; builds and publishes it |
| [`.github/workflows/manual_build.yml`](.github/workflows/manual_build.yml) | Build a specific version on demand |
| [`.github/workflows/update_homebrew_tap.yml`](.github/workflows/update_homebrew_tap.yml) | Publishes each release to the Homebrew tap |
| [`scripts/clean_uids.sh`](scripts/clean_uids.sh) | Standalone UID cleanup utility for existing projects |

`LICENSE.txt` and `COPYRIGHT.txt` are Godot's, retained because the published binaries are builds of Godot.

---

## ❤️ Credits & Thanks

*   **[Godot Engine](https://godotengine.org)**: The amazing engine we all love.
*   **[Daylily-Zeleen](https://github.com/Daylily-Zeleen)**: For authoring [PR #100973](https://github.com/godotengine/godot/pull/100973) which makes the optional UID system possible.
