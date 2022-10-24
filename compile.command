#!/bin/bash

set -ex

# cd script dir
cd "$(dirname "$0")" || exit

GIT_ROOT=$(pwd)

rm -rf build Payload ModMyIPA.ipa

 xcodebuild -project "$GIT_ROOT/ModMyIPA.xcodeproj" \
 -scheme ModMyIPA -configuration Release \
 -derivedDataPath "$GIT_ROOT/build" \
 -destination 'generic/platform=iOS' \
 -sdk iphoneos \
 clean build \
 CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO ONLY_ACTIVE_ARCH=NO \
 PRODUCT_BUNDLE_IDENTIFIER="com.powen.ModMyIPA" \

ldid -S -M build/Build/Products/Release-iphoneos/ModMyIPA.app
ln -sf build/Build/Products/Release-iphoneos Payload
zip -r9 ModMyIPA.ipa Payload/ModMyIPA.app
