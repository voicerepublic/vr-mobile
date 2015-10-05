app = angular.module(GLOBALS.ANGULAR_APP_NAME)
###angular should do vvv_this_vvv natively
app.provider "myCSRF", ->
  headerName = 'X-CSRF-TOKEN'
  cookieName = 'XSRF-TOKEN'

  allowedMethods = [ 'GET' ]

  @setHeaderName = (n) ->
    headerName = n

  @setAllowedMethods = (n) ->
    allowedMethods = n

  @$get = ["ipCookie", (ipCookie) ->

    { 'request': (config) ->
      if allowedMethods.indexOf(config.method) == -1
        config.headers[headerName] = ipCookie cookieName
      #expose config
      config
    }

  ]
  #return needed for proper functionallity
  return
###
app.config ($httpProvider) ->
  # Combine multiple $http requests into one $applyAsync (boosts performance)
  $httpProvider.useApplyAsync(true)

  # if staging
  $httpProvider.defaults.headers.common.Authorization = 'Basic c3RhZ2luZzpvcGg1bG9oYg=='

  # override the csrf header
  $httpProvider.defaults.xsrfHeaderName = 'X-CSRF-TOKEN'

  # set JSON for post
  $httpProvider.defaults.headers.post['Content-Type'] = 'application/json'
  $httpProvider.defaults.headers.post['Accept'] = 'application/json'

  # Add support for PATCH requests
  $httpProvider.defaults.headers.patch ||= {}
  $httpProvider.defaults.headers.patch['Content-Type'] = 'application/json'

  # Send API version code in header (might be useful in future)
  #$httpProvider.defaults.headers.common["X-Api-Version"] = "1.0"

  # According to Ionic needed to store Cookies
  $httpProvider.defaults.withCredentials = true
  $httpProvider.defaults.useXDomain = true

  #CSRF provider/interceptor
  #$httpProvider.interceptors.push "myCSRF"

  $httpProvider.interceptors.push ($injector, $q, $log, $location) ->
    responseError: (response) ->
      $log.debug "httperror: ", response.status unless GLOBALS.ENV == "test"

      # Sign out current user if we receive a 401 status.
      if response.status == 401
        $injector.invoke (User) ->
          User.logout()
          $location.path("/")

      $q.reject(response)
