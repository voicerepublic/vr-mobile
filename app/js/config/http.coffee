app = angular.module(GLOBALS.ANGULAR_APP_NAME)

app.provider "myCSRF", ->
  headerName = 'X-CSRF-TOKEN'
  storageName = 'csrfToken'
  #cannot access cookies
  #cookieName = 'XSRF-TOKEN'
  allowedMethods = [ 'GET' ]

  @setHeaderName = (n) ->
    headerName = n

  @setAllowedMethods = (n) ->
    allowedMethods = n

  @$get = ["$localstorage", ($localstorage) ->

    { 'request': (config) ->
      if allowedMethods.indexOf(config.method) == -1
        config.headers[headerName] = $localstorage.get storageName
      #expose config
      config
    }

  ]
  #return needed for proper functionallity
  return

app.config ($httpProvider) ->
  # Combine multiple $http requests into one $applyAsync (boosts performance)
  $httpProvider.useApplyAsync(true)

  # Add support for PATCH requests
  $httpProvider.defaults.headers.patch ||= {}
  $httpProvider.defaults.headers.patch['Content-Type'] = 'application/json'

  # Send API version code in header (might be useful in future)
  $httpProvider.defaults.headers.common["X-Api-Version"] = "1.0"

  # According to Ionic needed to store Cookies
  $httpProvider.defaults.withCredentials = true
  #$httpProvider.defaults.useXDomain = true

  #CSRF provider/interceptor
  $httpProvider.interceptors.push "myCSRF"

  $httpProvider.interceptors.push ($injector, $q, $log, $location) ->
    responseError: (response) ->
      $log.debug "httperror: ", response.status unless GLOBALS.ENV == "test"

      # Sign out current user if we receive a 401 status.
      if response.status == 401
        $injector.invoke (Auth) ->
          Auth.setAuthToken(null, null)
          $location.path("/")

      $q.reject(response)
