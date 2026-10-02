#!/usr/bin/env bash
# No UID - Build the Godot editor for Termux (Android, aarch64).
#
# Run this inside Termux (on a device or in the termux/termux-docker image).
# It fetches upstream Godot at a release tag, applies the No-UID patch
# (PR #100973 + default forced to false), and builds an X11 editor binary.
#
# Usage: ./build_termux.sh [--prepare-only] [version-tag] [output-dir]
#   version-tag  Upstream Godot tag, e.g. 4.7.2-stable (default: latest stable)
#   output-dir   Where the finished binary is written (default: current dir)
#   --prepare-only  Download, patch and install deps, but skip the compile
#
# Output: <output-dir>/godot-<version-tag>-nouid-Termux-aarch64
#
# Heads up: a full build is long (hours on a phone, ~1h on a 4-core arm64 CI
# runner) and needs several GB of RAM and disk.
set -euo pipefail

PREPARE_ONLY=0
if [ "${1:-}" = "--prepare-only" ]; then
  PREPARE_ONLY=1
  shift
fi

VERSION="${1:-}"
OUT_DIR="${2:-$PWD}"
WORK_DIR="${WORK_DIR:-$HOME/godot-nouid-build}"
JOBS="${JOBS:-$(nproc)}"
PREFIX="${PREFIX:-/data/data/com.termux/files/usr}"

if [ ! -d "$PREFIX" ]; then
  echo "ERROR: $PREFIX not found. This script must run inside Termux." >&2
  exit 1
fi

if [ -z "$VERSION" ]; then
  VERSION=$(curl -fsSL https://api.github.com/repos/godotengine/godot/releases/latest | grep -m1 '"tag_name"' | cut -d'"' -f4)
  echo "Latest upstream tag: $VERSION"
fi

echo "==> Installing build dependencies"
pkg update -y
pkg install -y x11-repo
pkg install -y \
  clang python git curl patch binutils pkg-config yasm \
  brotli fontconfig freetype glu libandroid-execinfo libenet libgraphite \
  libjpeg-turbo libogg libtheora libvorbis libvpx libwebp libwslay libxcursor \
  libxi libxinerama libxkbcommon libxrandr mbedtls miniupnpc opengl opusfile \
  pcre2 pulseaudio sdl3 speechd zlib zstd
# scons is not packaged in Termux
pip install scons

echo "==> Fetching Godot $VERSION"
rm -rf "$WORK_DIR"
mkdir -p "$WORK_DIR"
cd "$WORK_DIR"
curl -fsSL "https://github.com/godotengine/godot/archive/refs/tags/$VERSION.tar.gz" | tar xz
cd "godot-$VERSION"

echo "==> Applying No-UID patch (PR #100973)"
curl -fsSL https://github.com/godotengine/godot/pull/100973.diff -o ../no_uid.patch
patch -p1 < ../no_uid.patch

echo "==> Forcing default to FALSE"
# Termux has no perl; sed is enough here.
if grep -q 'editor/resource/generate_uid_files' editor/register_editor_types.cpp; then
  sed -i 's|GLOBAL_DEF("editor/resource/generate_uid_files", true)|GLOBAL_DEF("editor/resource/generate_uid_files", false)|' editor/register_editor_types.cpp
  if ! grep -q 'GLOBAL_DEF("editor/resource/generate_uid_files", false)' editor/register_editor_types.cpp; then
    echo "ERROR: Could not flip the default. The PR might have changed." >&2
    exit 1
  fi
  echo "SUCCESS: Default set to false."
else
  echo "ERROR: Could not find settings line to patch. The PR might have changed." >&2
  exit 1
fi

if [ "$PREPARE_ONLY" = 1 ]; then
  echo "==> --prepare-only: source is patched at $PWD, skipping build"
  exit 0
fi

# Use Termux's shared libraries instead of the bundled copies (as the official
# Termux godot package does). Wayland is off because Android's libc has no
# shm_open; OpenXR is off because it needs secure_getenv, which Android lacks.
system_libs=""
for lib in brotli enet freetype graphite libjpeg-turbo libogg libtheora libvorbis \
           libvpx libwebp mbedtls miniupnpc opus pcre2 sdl wslay zlib zstd; do
  rm -rf "thirdparty/$lib"
  system_libs+="builtin_${lib//-/_}=no "
done

echo "==> Building ($JOBS jobs)"
export BUILD_NAME=termux
# shellcheck disable=SC2086
scons -j"$JOBS" \
  platform=linuxbsd \
  target=editor \
  arch=arm64 \
  use_llvm=yes \
  use_static_cpp=no \
  wayland=no \
  module_openxr_enabled=no \
  module_camera_enabled=no \
  alsa=no \
  udev=no \
  pulseaudio=yes \
  execinfo=yes \
  system_certs_path="$PREFIX/etc/tls/cert.pem" \
  CPPPATH="$PREFIX/include" \
  LIBPATH="$PREFIX/lib" \
  linkflags="-landroid-execinfo -lturbojpeg" \
  $system_libs

mkdir -p "$OUT_DIR"
OUT="$OUT_DIR/godot-$VERSION-nouid-Termux-aarch64"
cp bin/godot.linuxbsd.editor.arm64.llvm "$OUT"
chmod +x "$OUT"
echo "==> Done: $OUT"
