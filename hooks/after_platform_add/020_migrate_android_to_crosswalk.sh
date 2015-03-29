#!/bin/sh
# Migrate Android's WebView to ChromeView.
#
# (see https://crosswalk-project.org/#documentation/cordova/migrate_an_application
# for more information)

# Exit, if there's no android here.
[[ $CORDOVA_PLATFORMS == *"android"* ]] || exit 0

# Set to 1 to enable crosswalk mode.
test ! "$ANDROID_CROSSWALK_MODE" -eq "1" && exit

# TODO currently this must be a crosswalk-cordova-android repository with included library/xwalk_core_library from proper crosswalk-webview package (arm is for devices, x86 for some others)
# TODO move it to vendor/ submodule
CROSSWALK_BUNDLE_PATH="$HOME/Downloads/crosswalk-cordova-10.39.235.15-arm"

rm -rf platforms/android/CordovaLib/*
cp -a $CROSSWALK_BUNDLE_PATH/framework/* platforms/android/CordovaLib/
cp -a $CROSSWALK_BUNDLE_PATH/VERSION platforms/android/

echo "HOOK-migrate_android_to_crosswalk >> crosswalk-cordova/framework has been copied to android's project path."


# Crosswalk requires a couple of extra permissions,
# which are not inserted by the Cordova application generator.
#
# We'll add them automatically to platforms/android/AndroidManifest.xml:
ANDROID_MANIFEST_PATH="platforms/android/AndroidManifest.xml"
function insert_line_to_manifest {
  LINE=$1

  if ! fgrep --silent "$LINE" $ANDROID_MANIFEST_PATH; then
    awk "/<\/manifest>/{print \"$LINE\"}1" $ANDROID_MANIFEST_PATH > tmp && mv tmp $ANDROID_MANIFEST_PATH
    echo "HOOK-migrate_android_to_crosswalk >> Line inserted to AndroidManifest.xml:"
    echo "HOOK-migrate_android_to_crosswalk >> $LINE"
  fi
}

insert_line_to_manifest "    <uses-permission android:name='android.permission.ACCESS_NETWORK_STATE' />"
insert_line_to_manifest "    <uses-permission android:name='android.permission.ACCESS_WIFI_STATE' />"
echo "HOOK-migrate_android_to_crosswalk >> AndroidManifest.xml should now contain required permissions: ACCESS_NETWORK_STATE, ACCESS_WIFI_STATE."


cd platforms/android/CordovaLib
echo "HOOK-migrate_android_to_crosswalk >> Building the crosswalk's CordovaLib..."

# This updates the CordovaLib project and the
# xwalk_core_library subproject and target Android 4.4.2 (API
# level 19)
android update project --subprojects --path . --target "android-19"

# build both the CordovaLib and xwalk_core_library projects
ant debug

echo "HOOK-migrate_android_to_crosswalk >> Crosswalk has been sucessfully built."

# TODO add support for both architectures (arm and x86)
