log 'setup google analytics'

return unless GLOBALS.CORDOVA_GOOGLE_ANALYTICS_ID
app = angular.module(GLOBALS.ANGULAR_APP_NAME)


ionic.Platform.ready ->
  app.config (googleAnalyticsCordovaProvider) ->
      googleAnalyticsCordovaProvider.debug = GLOBALS.ENV != 'production'
      googleAnalyticsCordovaProvider.trackingId = GLOBALS.CORDOVA_GOOGLE_ANALYTICS_ID
