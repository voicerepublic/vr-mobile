#!/bin/sh

# Exit, if there's no android here.
[[ $CORDOVA_PLATFORMS == *"android"* ]] || exit 0

if test ! -f "keys/android/$ANDROID_KEYSTORE_NAME.keystore"; then
  echo "HOOK-configure_android_keys >> Android key's file \"keys/android/$ANDROID_KEYSTORE_NAME.keystore\" doesn't exist!"
  exit 1
fi

if test ! -n "$ANDROID_KEYSTORE_PASSWORD"; then
  echo "HOOK-configure_android_keys >> Enter key.store.password:\t"
  read ANDROID_KEYSTORE_PASSWORD
fi

if test ! -n "$ANDROID_ALIAS_PASSWORD"; then
  echo "HOOK-configure_android_keys >> Enter key.alias.password:\t"
  read ANDROID_ALIAS_PASSWORD
fi

echo "key.store=../../keys/android/$ANDROID_KEYSTORE_NAME.keystore" > platforms/android/ant.properties
echo "key.alias=$ANDROID_ALIAS_NAME" >> platforms/android/ant.properties
echo "" >> platforms/android/ant.properties
echo "# If you want, put also key passwords here" >> platforms/android/ant.properties
echo "key.store.password=$ANDROID_KEYSTORE_PASSWORD" >> platforms/android/ant.properties
echo "key.alias.password=$ANDROID_ALIAS_PASSWORD" >> platforms/android/ant.properties

