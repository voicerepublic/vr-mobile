log 'setup debugging hack'

app = angular.module(GLOBALS.ANGULAR_APP_NAME)


# Useful for debugging, like `$a("$rootScope")`
app.run ($window, $injector) ->
  $window.$a = $injector.get
