#!/bin/bash
set -euo pipefail

LC_DIR="${LC_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
SS_DIR="${SS_DIR:-$LC_DIR/SideStore-src}"
LC_ARCHIVE="${LC_ARCHIVE:-$LC_DIR/archive.xcarchive}"
SS_ARCHIVE="${SS_ARCHIVE:-$SS_DIR/SideStore.xcarchive}"
OUT_DIR="${OUT_DIR:-$LC_DIR/dist}"
DYLIBIFY="${DYLIBIFY:-$LC_DIR/dylibify}"

mkdir -p "$OUT_DIR"

echo "==> [pkg 1/2] Signing SideStore components and packaging SideStore-zh_CN.ipa..."
APP_DIR="$SS_ARCHIVE/Products/Applications/SideStore.app"

cp -R "$SS_DIR/AltStore/Resources/zh-Hans.lproj" "$APP_DIR/"
cp -R "$SS_DIR/AltStore/Resources/en.lproj" "$APP_DIR/"

if [ -f "$APP_DIR/SideBackup.ipa" ]; then
  unzip -q -o "$APP_DIR/SideBackup.ipa" -d "$APP_DIR/"
  if [ -d "$APP_DIR/Payload/SideBackup.app" ]; then
    /usr/bin/codesign -f -s - --entitlements "$SS_DIR/SideBackup/SideBackup.entitlements" "$APP_DIR/Payload/SideBackup.app/SideBackup"
    /usr/bin/codesign -f -s - --entitlements "$SS_DIR/SideBackup/SideBackup.entitlements" "$APP_DIR/Payload/SideBackup.app"
  fi
  pushd "$APP_DIR" > /dev/null
  rm -f SideBackup.ipa
  zip -qr SideBackup.ipa Payload
  popd > /dev/null
  rm -rf "$APP_DIR/Payload"
fi

if [ -d "$APP_DIR/Frameworks" ]; then
  find "$APP_DIR/Frameworks" -type f -name "*.dylib" -exec /usr/bin/codesign -f -s - {} + 2>/dev/null || true
  for fw in "$APP_DIR/Frameworks/"*.framework; do
    if [ -d "$fw" ]; then
      /usr/bin/codesign -f -s - "$fw"
    fi
  done
fi

if [ -d "$APP_DIR/PlugIns/AltWidgetExtension.appex" ]; then
  /usr/bin/codesign -f -s - --entitlements "$SS_DIR/AltWidget/Resources/ReleaseEntitlements.plist" "$APP_DIR/PlugIns/AltWidgetExtension.appex/AltWidgetExtension"
  /usr/bin/codesign -f -s - --entitlements "$SS_DIR/AltWidget/Resources/ReleaseEntitlements.plist" "$APP_DIR/PlugIns/AltWidgetExtension.appex"
fi

/usr/bin/codesign -f -s - --entitlements "$SS_DIR/AltStore/Resources/ReleaseEntitlements.plist" "$APP_DIR/SideStore"
/usr/bin/codesign -f -s - --entitlements "$SS_DIR/AltStore/Resources/ReleaseEntitlements.plist" "$APP_DIR"

rm -rf "$SS_DIR/Payload"
mkdir -p "$SS_DIR/Payload"
cp -R "$APP_DIR" "$SS_DIR/Payload/SideStore.app"
rm -f "$OUT_DIR/SideStore-zh_CN.ipa"
pushd "$SS_DIR" > /dev/null
zip -qr "$OUT_DIR/SideStore-zh_CN.ipa" Payload -x "._*" -x ".DS_Store" -x "__MACOSX"
popd > /dev/null
rm -rf "$SS_DIR/Payload"

echo "==> [pkg 2/2] Building combined LiveContainer+SideStore.ipa..."
cd "$LC_DIR"
rm -rf Payload tmp "$OUT_DIR/LiveContainer+SideStore.ipa"
cp -R "$LC_ARCHIVE/Products/Applications" Payload

/usr/libexec/PlistBuddy -c 'Add :ALTAppGroups array' ./Payload/LiveContainer.app/Info.plist || true
/usr/libexec/PlistBuddy -c 'Add :ALTAppGroups: string group.com.SideStore.SideStore' ./Payload/LiveContainer.app/Info.plist || true

/usr/libexec/PlistBuddy -c "Add :CFBundleURLTypes:1 dict" ./Payload/LiveContainer.app/Info.plist || true
/usr/libexec/PlistBuddy -c "Add :CFBundleURLTypes:1:CFBundleURLName string com.kdt.livecontainer.sidestoreurlscheme" ./Payload/LiveContainer.app/Info.plist || true
/usr/libexec/PlistBuddy -c "Add :CFBundleURLTypes:1:CFBundleURLSchemes array" ./Payload/LiveContainer.app/Info.plist || true
/usr/libexec/PlistBuddy -c "Add :CFBundleURLTypes:1:CFBundleURLSchemes:0 string sidestore" ./Payload/LiveContainer.app/Info.plist || true
/usr/libexec/PlistBuddy -c "Add :CFBundleURLTypes:2 dict" ./Payload/LiveContainer.app/Info.plist || true
/usr/libexec/PlistBuddy -c "Add :CFBundleURLTypes:2:CFBundleURLName string com.kdt.livecontainer.sidestorebackupurlscheme" ./Payload/LiveContainer.app/Info.plist || true
/usr/libexec/PlistBuddy -c "Add :CFBundleURLTypes:2:CFBundleURLSchemes array" ./Payload/LiveContainer.app/Info.plist || true
/usr/libexec/PlistBuddy -c "Add :CFBundleURLTypes:2:CFBundleURLSchemes:0 string sidestore-com.kdt.livecontainer" ./Payload/LiveContainer.app/Info.plist || true

/usr/libexec/PlistBuddy -c "Add :INIntentsSupported array" ./Payload/LiveContainer.app/Info.plist || true
/usr/libexec/PlistBuddy -c "Add :INIntentsSupported:0 string RefreshAllIntent" ./Payload/LiveContainer.app/Info.plist || true
/usr/libexec/PlistBuddy -c "Add :INIntentsSupported:1 string ViewAppIntent" ./Payload/LiveContainer.app/Info.plist || true
/usr/libexec/PlistBuddy -c "Add :NSUserActivityTypes array" ./Payload/LiveContainer.app/Info.plist || true
/usr/libexec/PlistBuddy -c "Add :NSUserActivityTypes:0 string RefreshAllIntent" ./Payload/LiveContainer.app/Info.plist || true
/usr/libexec/PlistBuddy -c "Add :NSUserActivityTypes:1 string ViewAppIntent" ./Payload/LiveContainer.app/Info.plist || true

/usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers:3:Type string PSToggleSwitchSpecifier" ./Payload/LiveContainer.app/Settings.bundle/Root.plist || true
/usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers:3:Title string Open SideStore" ./Payload/LiveContainer.app/Settings.bundle/Root.plist || true
/usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers:3:Key string LCOpenSideStore" ./Payload/LiveContainer.app/Settings.bundle/Root.plist || true
/usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers:3:DefaultValue bool false" ./Payload/LiveContainer.app/Settings.bundle/Root.plist || true

cp -R "$APP_DIR" ./Payload/LiveContainer.app/Frameworks/SideStoreApp.framework
cp -R "$SS_DIR/AltStore/Resources/zh-Hans.lproj" ./Payload/LiveContainer.app/Frameworks/SideStoreApp.framework/
cp -R "$SS_DIR/AltStore/Resources/en.lproj" ./Payload/LiveContainer.app/Frameworks/SideStoreApp.framework/

LC_ZH_ORIG=$(mktemp)
if [ -f ./Payload/LiveContainer.app/zh-Hans.lproj/Localizable.strings ]; then
  cp ./Payload/LiveContainer.app/zh-Hans.lproj/Localizable.strings "$LC_ZH_ORIG"
fi
cp -R "$SS_DIR/AltStore/Resources/zh-Hans.lproj" ./Payload/LiveContainer.app/
if [ -s "$LC_ZH_ORIG" ]; then
  cp "$LC_ZH_ORIG" ./Payload/LiveContainer.app/zh-Hans.lproj/Localizable.strings
  mkdir -p ./Payload/LiveContainer.app/zh_CN.lproj
  cp "$LC_ZH_ORIG" ./Payload/LiveContainer.app/zh_CN.lproj/Localizable.strings
fi
rm -f "$LC_ZH_ORIG"

python3 "$LC_DIR/scripts/merge_strings.py" ./Payload/LiveContainer.app/zh-Hans.lproj/Localizable.strings "$SS_DIR/scripts"
python3 "$LC_DIR/scripts/merge_strings.py" ./Payload/LiveContainer.app/zh_CN.lproj/Localizable.strings "$SS_DIR/scripts"

"$DYLIBIFY" ./Payload/LiveContainer.app/Frameworks/SideStoreApp.framework/SideStore ./Payload/LiveContainer.app/Frameworks/SideStoreApp.framework/SideStore.dylib
rm ./Payload/LiveContainer.app/Frameworks/SideStoreApp.framework/SideStore
mv ./Payload/LiveContainer.app/Frameworks/SideStoreApp.framework/SideStore.dylib ./Payload/LiveContainer.app/Frameworks/SideStoreApp.framework/SideStore
/usr/bin/codesign -f -s - ./Payload/LiveContainer.app/Frameworks/SideStoreApp.framework/SideStore
cp ./.github/sidelc/LCAppInfo.plist ./Payload/LiveContainer.app/Frameworks/SideStoreApp.framework/

cp ./Payload/LiveContainer.app/Frameworks/SideStoreApp.framework/Intents.intentdefinition ./Payload/LiveContainer.app/
cp ./Payload/LiveContainer.app/Frameworks/SideStoreApp.framework/ViewApp.intentdefinition ./Payload/LiveContainer.app/
rm -rf ./Payload/LiveContainer.app/Metadata.appintents
cp -r ./Payload/LiveContainer.app/Frameworks/SideStoreApp.framework/Metadata.appintents ./Payload/LiveContainer.app/Metadata.appintents
sed -i '' 's/9SideStore20RefreshAllAppsIntentV/16SideStoreSupport20RefreshAllAppsIntentV/g' ./Payload/LiveContainer.app/Metadata.appintents/extract.actionsdata
sed -i '' 's/9SideStore26RefreshAllAppsWidgetIntentV/16SideStoreSupport26RefreshAllAppsWidgetIntentV/g' ./Payload/LiveContainer.app/Metadata.appintents/extract.actionsdata

rm -rf ./Payload/LiveContainer.app/PlugIns/LiveWidgetExtension.appex
mv ./Payload/LiveContainer.app/Frameworks/SideStoreApp.framework/PlugIns/AltWidgetExtension.appex ./Payload/LiveContainer.app/PlugIns/LiveWidgetExtension.appex
/usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier com.kdt.livecontainer.LiveWidget" ./Payload/LiveContainer.app/PlugIns/LiveWidgetExtension.appex/Info.plist
/usr/libexec/PlistBuddy -c "Set :CFBundleExecutable LiveWidgetExtension" ./Payload/LiveContainer.app/PlugIns/LiveWidgetExtension.appex/Info.plist
mv ./Payload/LiveContainer.app/PlugIns/LiveWidgetExtension.appex/AltWidgetExtension ./Payload/LiveContainer.app/PlugIns/LiveWidgetExtension.appex/LiveWidgetExtension
/usr/bin/codesign -f -s - --entitlements .github/sidelc/LiveWidgetExtension_adhoc.xml ./Payload/LiveContainer.app/PlugIns/LiveWidgetExtension.appex/LiveWidgetExtension

zip -qr "$OUT_DIR/LiveContainer+SideStore.ipa" Payload -x "._*" -x ".DS_Store" -x "__MACOSX"
rm -rf Payload

echo "==> Packaging complete:"
ls -lh "$OUT_DIR"/*.ipa
