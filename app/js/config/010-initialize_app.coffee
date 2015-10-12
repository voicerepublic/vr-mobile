log 'setup angular app (init)'

# Initialize angular's app.

app = angular.module(GLOBALS.ANGULAR_APP_NAME, [
  "#{GLOBALS.ANGULAR_APP_NAME}.templates"
  "ionic"
  "#{GLOBALS.NGCORDOVA}"
  "timer"
  "ipCookie"
  "angulartics.google.analytics"
  "angulartics.google.analytics.cordova"
  'ngStorage'
])

app.config ['$localStorageProvider', ($localStorageProvider) ->
  $localStorageProvider.setKeyPrefix('vr-')
]
