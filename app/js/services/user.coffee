userFn = ($log, $http, $localStorage, Settings) ->

  # NOTE $localStorage.$default is buggy when used in multiple places
  # this is a workaround
  attributes = $localStorage.user || {}
  $localStorage.user = attributes

  signedIn = ->
    attributes.id?

  _set_headers = ->
    $http.defaults.headers.common["X-User-Email"] = attributes.email
    $http.defaults.headers.common["X-User-Token"] = attributes.authentication_token

  _set_headers() if signedIn()

  $log.info "setup User service #{JSON.stringify(attributes)}"


  login = (email, password, success, error) ->
    $log.info "login #{email} with password"
    url = "#{Settings.endpoints().api}/api/sessions"
    $log.info "POST #{url}"
    $http.post(url, { email, password })
      .success (data, status) ->
        $log.info "success: #{status} #{JSON.stringify(data)}"
        attributes[key] = value for key, value of data
        _set_headers()
        success(data, status) if success?
      .error (data, status) ->
        $log.info "error: #{status} #{JSON.stringify(data)}"
        error(data, status) if error?

  logout = ->
    delete $http.defaults.headers.common["X-User-Email"]
    delete $http.defaults.headers.common["X-User-Token"]
    $localStorage.user = {}

  reload = ->
    $log.info "reload #{attributes.email}"
    url = "#{Settings.endpoints().api}/api/users/#{attributes.id}"
    $log.info "GET #{url}"
    $http.get(url)
      .success (data, status) ->
        $log.info "success: #{status} #{JSON.stringify(data)}"
        attributes[key] = value for key, value of data
      .error (data, status) ->
        # TODO handle error properly
        $log.info "error: #{status} #{JSON.stringify(data)}"



  {
    attributes
    login
    logout
    reload
    signedIn
  }

angular.module("voicerepublic").service('User', userFn)
