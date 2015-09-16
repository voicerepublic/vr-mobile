#!/bin/bash

# Exit, if there's no ios here.
[[ $CORDOVA_PLATFORMS == *"ios"* ]] || exit 0


#
# CODE_SIGN_IDENTITY
#

echo "CODE_SIGN_IDENTITY = $IOS_CODE_SIGN_IDENTITY" > platforms/ios/cordova/build.xcconfig
# to list all installed iOS identities, run:
#     security find-identity |  sed -n 's/.*\("[^"]*"\).*/\1/p' | grep 'iPhone'
#
# generic 'iPhone Developer' (no quotes) will match the right Identity with the right Provisioning Profile plus Certificate, based on the app bundle id


#
# IOS_PROVISIONING_PROFILE
#

if test ! -n "$IOS_PROVISIONING_PROFILE" && test ! -f "$IOS_PROVISIONING_PROFILE"; then
  echo "HOOK-configure_ios_keys >> Provisioning profile's file is missing! (path: $IOS_PROVISIONING_PROFILE) Xcode will find matching profile on his own."
else
  PROVISIONING_PROFILE_UUID=$(grep UUID -A1 -a $IOS_PROVISIONING_PROFILE | grep -o "[-A-z0-9]\{36\}")
  echo "PROVISIONING_PROFILE = $PROVISIONING_PROFILE_UUID" >> platforms/ios/cordova/build.xcconfig
fi


echo "HOOK-configure_ios_keys >> iOS platform has been configured to sign the app with key '$IOS_CODE_SIGN_IDENTITY.'"
