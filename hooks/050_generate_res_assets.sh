#!/bin/sh
#
# Compile image resources (images and splashscreens) from assets/img/ to assets/img/res/ dasrectory.

if test ! -d "hooks"; then
  echo "HOOK-generate_res_assets >> You must run it in main directory of cordova project."
  exit 1
fi

LOGO="assets/img/logo-square.png"
PORTRAIT_SPLASH="assets/img/splash-portrait.png"
LANDSCAPE_SPLASH="assets/img/splash-landscape.png"

if [[ $CORDOVA_PLATFORMS == *"android"* ]]; then
  convert $LOGO -resize "96x96" "platforms/android/res/drawable/icon.png"
  convert $LOGO -resize "36x36" "platforms/android/res/drawable-ldpi/icon.png"
  convert $LOGO -resize "48x48" "platforms/android/res/drawable-mdpi/icon.png"
  convert $LOGO -resize "72x72" "platforms/android/res/drawable-hdpi/icon.png"
  convert $LOGO -resize "96x96" "platforms/android/res/drawable-xhdpi/icon.png"

  convert $PORTRAIT_SPLASH -resize "720x1280^" \
    -gravity center -crop 720x1280+0+0 +repage\
    "platforms/android/res/drawable/screen.png"
  convert $PORTRAIT_SPLASH -resize "200x320^" \
    -gravity center -crop 200x320+0+0 +repage\
    "platforms/android/res/drawable-ldpi/screen.png"
  convert $PORTRAIT_SPLASH -resize "320x480^" \
    -gravity center -crop 320x480+0+0 +repage\
    "platforms/android/res/drawable-mdpi/screen.png"
  convert $PORTRAIT_SPLASH -resize "480x800^" \
    -gravity center -crop 480x800+0+0 +repage\
    "platforms/android/res/drawable-hdpi/screen.png"
  convert $PORTRAIT_SPLASH -resize "720x1280^" \
    -gravity center -crop 720x1280+0+0 +repage\
    "platforms/android/res/drawable-xhdpi/screen.png"

  convert $LANDSCAPE_SPLASH -resize "1280x720^" \
    -gravity center -crop 1280x720+0+0 +repage\
    "platforms/android/res/drawable/screen_landscape.png"
  convert $LANDSCAPE_SPLASH -resize "320x200^" \
    -gravity center -crop 320x200+0+0 +repage\
    "platforms/android/res/drawable-ldpi/screen_landscape.png"
  convert $LANDSCAPE_SPLASH -resize "480x320^" \
    -gravity center -crop 480x320+0+0 +repage\
    "platforms/android/res/drawable-mdpi/screen_landscape.png"
  convert $LANDSCAPE_SPLASH -resize "800x480^" \
    -gravity center -crop 800x480+0+0 +repage\
    "platforms/android/res/drawable-hdpi/screen_landscape.png"
  convert $LANDSCAPE_SPLASH -resize "1280x720^" \
    -gravity center -crop 1280x720+0+0 +repage\
    "platforms/android/res/drawable-xhdpi/screen_landscape.png"

  # Copy to new file paths which are supported since Cordova 3.5.
  cp platforms/android/res/drawable-ldpi/screen.png platforms/android/res/drawable-port-ldpi/screen.png
  cp platforms/android/res/drawable-ldpi/screen_landscape.png platforms/android/res/drawable-land-ldpi/screen_landscape.png
  cp platforms/android/res/drawable-ldpi/screen_landscape.png platforms/android/res/drawable-land-ldpi/screen.png

  cp platforms/android/res/drawable-mdpi/screen.png platforms/android/res/drawable-port-mdpi/screen.png
  cp platforms/android/res/drawable-mdpi/screen_landscape.png platforms/android/res/drawable-land-mdpi/screen_landscape.png
  cp platforms/android/res/drawable-mdpi/screen_landscape.png platforms/android/res/drawable-land-mdpi/screen.png

  cp platforms/android/res/drawable-hdpi/screen.png platforms/android/res/drawable-port-hdpi/screen.png
  cp platforms/android/res/drawable-hdpi/screen_landscape.png platforms/android/res/drawable-land-hdpi/screen_landscape.png
  cp platforms/android/res/drawable-hdpi/screen_landscape.png platforms/android/res/drawable-land-hdpi/screen.png

  cp platforms/android/res/drawable-xhdpi/screen.png platforms/android/res/drawable-port-xhdpi/screen.png
  cp platforms/android/res/drawable-xhdpi/screen_landscape.png platforms/android/res/drawable-land-xhdpi/screen_landscape.png
  cp platforms/android/res/drawable-xhdpi/screen_landscape.png platforms/android/res/drawable-land-xhdpi/screen.png

  echo "HOOK-generate_res_assets >> Android res images have been generated."
fi

if test -d "platforms/ios"; then
  BUNDLE_PATH=$(find platforms/ios/*.xcodeproj -type d | head -n 1 | sed 's/\.xcodeproj//g')

  convert $LOGO -resize "57x57" "$BUNDLE_PATH/Resources/icons/icon.png"
  convert $LOGO -resize "114x114" "$BUNDLE_PATH/Resources/icons/icon@2x.png"
  convert $LOGO -resize "120x120" "$BUNDLE_PATH/Resources/icons/icon-60@2x.png"
  convert $LOGO -resize "72x72" "$BUNDLE_PATH/Resources/icons/icon-72.png"
  convert $LOGO -resize "144x144" "$BUNDLE_PATH/Resources/icons/icon-72@2x.png"
  convert $LOGO -resize "76x76" "$BUNDLE_PATH/Resources/icons/icon-76.png"
  convert $LOGO -resize "152x152" "$BUNDLE_PATH/Resources/icons/icon-76@2x.png"

  convert $LOGO -resize "29x29" "$BUNDLE_PATH/Resources/icons/icon-small.png"
  convert $LOGO -resize "58x58" "$BUNDLE_PATH/Resources/icons/icon-small@2x.png"
  convert $LOGO -resize "40x40" "$BUNDLE_PATH/Resources/icons/icon-40.png"
  convert $LOGO -resize "80x80" "$BUNDLE_PATH/Resources/icons/icon-40@2x.png"
  convert $LOGO -resize "50x50" "$BUNDLE_PATH/Resources/icons/icon-50.png"
  convert $LOGO -resize "100x100" "$BUNDLE_PATH/Resources/icons/icon-50@2x.png"
  convert $LOGO -resize "60x60" "$BUNDLE_PATH/Resources/icons/icon-60.png"

  convert $PORTRAIT_SPLASH -resize "640x1136^" \
    -gravity center -crop 640x1136+0+0 +repage\
    "$BUNDLE_PATH/Resources/splash/Default-568h@2x~iphone.png"
  convert $LANDSCAPE_SPLASH -resize "2048x1496^" \
    -gravity center -crop 2048x1496+0+0 +repage\
    "$BUNDLE_PATH/Resources/splash/Default-Landscape@2x~ipad.png"
  convert $LANDSCAPE_SPLASH -resize "1024x748^" \
    -gravity center -crop 1024x748+0+0 +repage\
    "$BUNDLE_PATH/Resources/splash/Default-Landscape~ipad.png"
  convert $PORTRAIT_SPLASH -resize "1536x2008^" \
    -gravity center -crop 1536x2008+0+0 +repage\
    "$BUNDLE_PATH/Resources/splash/Default-Portrait@2x~ipad.png"
  convert $PORTRAIT_SPLASH -resize "768x1004^" \
    -gravity center -crop 768x1004+0+0 +repage\
    "$BUNDLE_PATH/Resources/splash/Default-Portrait~ipad.png"
  convert $PORTRAIT_SPLASH -resize "640x960^" \
    -gravity center -crop 640x960+0+0 +repage\
    "$BUNDLE_PATH/Resources/splash/Default@2x~iphone.png"
  convert $PORTRAIT_SPLASH -resize "320x480^" \
    -gravity center -crop 320x480+0+0 +repage\
    "$BUNDLE_PATH/Resources/splash/Default~iphone.png"

  echo "HOOK-generate_res_assets >> iOS res images have been generated."
fi

