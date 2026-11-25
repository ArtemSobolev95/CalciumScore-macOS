#!/bin/bash
#
# Builds the universal plugin (Apple silicon + Intel) and packs it for colleagues:
#   dist/CalciumScore-IsiX-<version>.zip   (TARGET=horos: dist/CalciumScore-Horos-<version>.zip)
#
set -euo pipefail
cd "$(dirname "$0")"

TARGET="${TARGET:-isix}"
if [ "$TARGET" = "horos" ]; then BUILD=build-horos; HOSTNAME=Horos; DIST_FILES=Distribution/Horos
else BUILD=build; HOSTNAME=IsiX; DIST_FILES=Distribution; fi
TARGET="$TARGET" ./build.sh

VERSION=$(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" $BUILD/CalciumScore.osirixplugin/Contents/Info.plist)
NAME="CalciumScore-$HOSTNAME-$VERSION"
STAGE="dist/$NAME"

rm -rf "$STAGE" "dist/$NAME.zip"
mkdir -p "$STAGE"
cp -R $BUILD/CalciumScore.osirixplugin "$STAGE/"
cp "$DIST_FILES/Install CalciumScore.command" "$STAGE/"
chmod +x "$STAGE/Install CalciumScore.command"
sed "s/@VERSION@/$VERSION/g" Distribution/README.txt > "$STAGE/README.txt"
cp LICENSE "$STAGE/LICENSE.txt"

codesign --verify --deep "$STAGE/CalciumScore.osirixplugin"
echo "==> Architectures: $(lipo -archs "$STAGE/CalciumScore.osirixplugin/Contents/MacOS/CalciumScore")"
(cd dist && ditto -c -k --sequesterRsrc --keepParent "$NAME" "$NAME.zip")
echo "==> Package: $(pwd)/dist/$NAME.zip"
