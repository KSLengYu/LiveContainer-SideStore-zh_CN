#!/bin/bash
set -euo pipefail

LC_DIR="${GITHUB_WORKSPACE:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
SS_DIR="$LC_DIR/SideStore-src"

curl -fL "https://github.com/LiveContainer/dylibify/releases/download/1.0/dylibify" -o "$LC_DIR/dylibify"
chmod +x "$LC_DIR/dylibify"

export LC_DIR
export SS_DIR
export LC_ARCHIVE="$LC_DIR/archive.xcarchive"
export SS_ARCHIVE="$SS_DIR/SideStore.xcarchive"
export OUT_DIR="$LC_DIR"
export DYLIBIFY="$LC_DIR/dylibify"

bash "$LC_DIR/scripts/package_combined.sh"
