app = angular.module(GLOBALS.ANGULAR_APP_NAME)


# It will equal to the root path of the directory where index.html is located.
# f.e. "file:///android_assets/www/" or "http://localhost/"
GLOBALS.APP_ROOT = location.href.replace(location.hash, "").replace("index.html", "")


for k, v of GLOBALS
  app.constant k, v


# Make GLOBALS visible in every scope.
app.run ($rootScope) ->
  $rootScope.GLOBALS = GLOBALS
