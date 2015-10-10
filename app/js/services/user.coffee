userFn = ($log, $http, $localStorage, Settings) ->

  attributes = $localStorage.$default(user: {}).user

  $log.info "setup User service #{JSON.stringify(attributes)}"

  login = (email, password, success, error) ->
    $log.info "login #{email} with password"
    url = "#{Settings.endpoints().api}/api/sessions"
    $log.info "POST #{url}"
    $http.post(url, { email, password })
      .success (data, status) ->
        $log.info "success: #{status} #{JSON.stringify(data)}"
        attributes[key] = value for key, value of data
        $http.defaults.headers.common["X-User-Email"] = email
        $http.defaults.headers.common["X-User-Token"] = data.authentication_token
        success(data, status) if success?
      .error (data, status) ->
        $log.info "error: #{status} #{JSON.stringify(data)}"
        error(data, status) if error?

  logout = ->
    delete $http.defaults.headers.common["X-User-Email"]
    delete $http.defaults.headers.common["X-User-Token"]
    delete key for key, value of attributes

  reload = ->
    $log.info "reload #{data.email}"
    url = "#{Settings.endpoints().api}/api/users/#{data.id}"
    $log.info "GET #{url}"
    $http.get(url)
      .success (data, status) ->
        $log.info "success: #{status} #{JSON.stringify(data)}"
        attributes[key] = value for key, value of data
      .error (data, status) ->
        # TODO handle error properly
        $log.info "error: #{status} #{JSON.stringify(data)}"

  signedIn = ->
    !!attributes.id?


  {
    attributes
    login
    logout
    reload
    signedIn
  }

angular.module("voicerepublic").service('User', userFn)
