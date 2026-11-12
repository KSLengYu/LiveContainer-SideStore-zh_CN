#!/bin/bash
set -euo pipefail

LC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PARENT_DIR="$(dirname "$LC_DIR")"

if [ -d "$PARENT_DIR/SideStore" ]; then
  SS_DIR="$PARENT_DIR/SideStore"
else
  SS_DIR="$LC_DIR/SideStore-src"
  if [ ! -d "$SS_DIR/.git" ]; then
    echo "==> Cloning KSLengYu/SideStore (LiveContainerSupport)..."
    git clone --recursive -b LiveContainerSupport https://github.com/KSLengYu/SideStore.git "$SS_DIR"
  fi
fi

DYLIBIFY="${DYLIBIFY:-}"
if [ -z "$DYLIBIFY" ]; then
  if [ -x "$PARENT_DIR/tools/dylibify" ]; then
    DYLIBIFY="$PARENT_DIR/tools/dylibify"
  elif [ -x "$LC_DIR/dylibify" ]; then
    DYLIBIFY="$LC_DIR/dylibify"
  else
    echo "==> Downloading dylibify..."
    curl -fL "https://github.com/LiveContainer/dylibify/releases/download/1.0/dylibify" -o "$LC_DIR/dylibify"
    chmod +x "$LC_DIR/dylibify"
    DYLIBIFY="$LC_DIR/dylibify"
  fi
fi

if [ -d "$HOME/Desktop/Xcode.app/Contents/Developer" ] && [ -z "${DEVELOPER_DIR:-}" ]; then
  export DEVELOPER_DIR="$HOME/Desktop/Xcode.app/Contents/Developer"
fi

echo "==> [1/4] Ensuring SwiftPM binary artifacts (OpenSSL & Unicorn)..."
ARTIFACTS_DIR="$HOME/Library/Caches/org.swift.swiftpm/artifacts"
mkdir -p "$ARTIFACTS_DIR"

OPENSSL_FILE="$ARTIFACTS_DIR/https___github_com_krzyzanowskim_OpenSSL_releases_download_3_6_2000_OpenSSL_xcframework_zip"
if [ ! -f "$OPENSSL_FILE" ]; then
  curl -fL "https://github.com/krzyzanowskim/OpenSSL/releases/download/3.6.2000/OpenSSL.xcframework.zip" -o "$OPENSSL_FILE"
fi

UNICORN_FILE="$ARTIFACTS_DIR/https___github_com_mahee96_unicorn_releases_download_2_1_4_multiarch_Unicorn_xcframework_zip"
if [ ! -f "$UNICORN_FILE" ]; then
  curl -fL "https://github.com/mahee96/unicorn/releases/download/2.1.4-multiarch/Unicorn.xcframework.zip" -o "$UNICORN_FILE"
fi

echo "==> [2/4] Archiving SideStore..."
python3 "$SS_DIR/scripts/generate_full_strings.py"
cd "$SS_DIR"
xcodebuild archive \
  -archivePath "$SS_DIR/SideStore" \
  -project AltStore.xcodeproj \
  -scheme SideStore \
  -sdk iphoneos \
  -configuration Release \
  CODE_SIGNING_REQUIRED=NO \
  AD_HOC_CODE_SIGNING_ALLOWED=YES \
  CODE_SIGNING_ALLOWED=NO \
  DEVELOPMENT_TEAM=XYZ0123456 \
  ORG_IDENTIFIER=com.SideStore \
  -quiet

echo "==> [3/4] Archiving LiveContainer..."
cd "$LC_DIR"
xcodebuild archive \
  -archivePath "$LC_DIR/archive" \
  -project LiveContainer.xcodeproj \
  -scheme LiveContainer \
  -sdk iphoneos \
  -arch arm64 \
  -configuration Release \
  CODE_SIGNING_REQUIRED=NO \
  AD_HOC_CODE_SIGNING_ALLOWED=YES \
  CODE_SIGNING_ALLOWED=NO \
  -quiet

echo "==> [4/4] Packaging IPAs..."
export LC_DIR SS_DIR DYLIBIFY
export LC_ARCHIVE="$LC_DIR/archive.xcarchive"
export SS_ARCHIVE="$SS_DIR/SideStore.xcarchive"
export OUT_DIR="${OUT_DIR:-$LC_DIR/dist}"

bash "$LC_DIR/scripts/package_combined.sh"
