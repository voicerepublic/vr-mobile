log 'setup logging'

app = angular.module(GLOBALS.ANGULAR_APP_NAME)


# Turn off $log.debug on production
app.config ($logProvider, $compileProvider) ->
  if GLOBALS.ENV == "production"
    $logProvider.debugEnabled(false)
    $compileProvider.debugInfoEnabled(false)
