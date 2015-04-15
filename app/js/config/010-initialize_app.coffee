# Initialize angular's app.

app = angular.module(GLOBALS.ANGULAR_APP_NAME, [
  "#{GLOBALS.ANGULAR_APP_NAME}.templates"
  "ionic"
  "ngCordova"
  "angulartics.google.analytics"
  "angulartics.google.analytics.cordova"
])
