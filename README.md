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

### Android (Termux)

Experimental. The release includes a `godot-<version>-nouid-Termux-aarch64` binary (X11 only, so use it with
[Termux:X11](https://github.com/termux/termux-x11); no Wayland or OpenXR). It links against Termux's shared
libraries, so install them first:

```bash
pkg install x11-repo
pkg install brotli ca-certificates fontconfig freetype glu libandroid-execinfo libc++ libenet libgraphite \
  libjpeg-turbo libogg libtheora libvorbis libvpx libwebp libwslay libxcursor libxi libxinerama libxkbcommon \
  libxrandr mbedtls miniupnpc opengl opusfile pcre2 pulseaudio sdl3 speechd zlib zstd
# then download the release asset and:
install -Dm755 godot-*-nouid-Termux-aarch64 "$PREFIX/bin/godot-nouid"
```

To build it yourself inside Termux (slow: hours on a phone), run
[`scripts/build_termux.sh`](scripts/build_termux.sh) `[version-tag] [output-dir]`.

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
| [`.github/workflows/build_termux.yml`](.github/workflows/build_termux.yml) | Termux (Android aarch64) build, called by both workflows above; optional, never blocks a release |
| [`.github/workflows/update_homebrew_tap.yml`](.github/workflows/update_homebrew_tap.yml) | Publishes each release to the Homebrew tap |
| [`scripts/build_termux.sh`](scripts/build_termux.sh) | Builds the patched editor natively in Termux (used by `build_termux.yml`) |
| [`scripts/clean_uids.sh`](scripts/clean_uids.sh) | Standalone UID cleanup utility for existing projects |

`LICENSE.txt` and `COPYRIGHT.txt` are Godot's, retained because the published binaries are builds of Godot.

---

## ❤️ Credits & Thanks

*   **[Godot Engine](https://godotengine.org)**: The amazing engine we all love.
*   **[Daylily-Zeleen](https://github.com/Daylily-Zeleen)**: For authoring [PR #100973](https://github.com/godotengine/godot/pull/100973) which makes the optional UID system possible.
