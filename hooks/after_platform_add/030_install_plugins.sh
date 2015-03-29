#!/bin/sh

function install_plugin {
  # Possible values: 'android', 'ios', 'android ios'
  PLATFORMS=$1

  # NAME can be a cordova's plugin name, local path to plugin or a link to git repository
  NAME=$2

  # Additional args passed to plugman after --plugin (f.e. variables)
  ARGS=$3

  for PLATFORM in $PLATFORMS; do
    # Is this the platform currently issued by cordova's command?
    [[ $CORDOVA_PLATFORMS == *"$PLATFORM"* ]] || continue

    plugman install --plugins_dir plugins --project platforms/$PLATFORM --platform $PLATFORM --plugin $NAME $ARGS || (echo "HOOK-install_plugins >> Installation of plugin $NAME on $PLATFORM has failed." && exit 1)
  done
}

# NOW, LET'S INSTALL PLUGINS

# Some basic cordova plugins
# install_plugin "android ios" org.apache.cordova.console || exit $?
# install_plugin "android ios" org.apache.cordova.device || exit $?
# install_plugin "android ios" org.apache.cordova.device-orientation || exit $?
# install_plugin "android ios" org.apache.cordova.geolocation || exit $?
# install_plugin "android ios" org.apache.cordova.inappbrowser || exit $?
# install_plugin "android ios" org.apache.cordova.network-information || exit $?
install_plugin "android ios" org.apache.cordova.splashscreen || exit $?

# Created by authors of Ionic, fixes keyboard issues on iOS
install_plugin "android ios" vendor/plugins/ionic-plugins-keyboard || exit $?

# Use native SDK of google analytics (see angulartics-ga-cordova plugin)
# install_plugin "android ios" vendor/plugins/GAPlugin || exit $?


echo "HOOK-install_plugins >> Plugins have been installed."
