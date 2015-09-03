#!/bin/bash

clear_platform() {
  PLATFORM=$1
  rm -rf "platforms/$PLATFORM" "plugins/$PLATFORM.json" "plugins/com.phonegap.plugins.facebookconnect"
}

echo '------------------------------------------------------------'
echo $CORDOVA_PLATFORMS
echo $SHELL
echo '------------------------------------------------------------'

if [[ $CORDOVA_PLATFORMS == *"android"* ]]; then
  if ! cat "platforms/android/assets/www/config.xml" | grep -q "id=\"$BUNDLE_ID\""; then
    echo "HOOK-clear_current_platform >> Current android app isn't named as $BUNDLE_ID, clearing it..."
    clear_platform android
  fi
fi

if [[ $CORDOVA_PLATFORMS == *"ios"* ]]; then
  if ! cat "platforms/ios/www/config.xml" | grep -q "id=\"$BUNDLE_ID\""; then
    echo "HOOK-clear_current_platform >> Current ios app isn't named as $BUNDLE_ID, clearing it..."
    clear_platform ios
  fi
fi
