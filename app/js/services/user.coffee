userFn = ($log, $http, $localstorage, Settings) ->

  USER_DATA_CACHE_KEY = "user"

  LOGIN_URL  = "#{Settings.endpoint.api}/api/sessions"
  RELOAD_URL = "#{Settings.endpoint.api}/api/users/"

  data = $localstorage.getObject USER_DATA_CACHE_KEY || {}

  $log.info "setup User service #{JSON.stringify(data)}"


  # TODO checkout if we can use data binding here
  _store = (_data) ->
    $log.info "storing #{JSON.stringify(_data)}"
    data = _data
    $localstorage.setObject USER_DATA_CACHE_KEY, _data


  login = (email, password, success, error) ->
    $log.info "login #{email} with password"
    $log.info "POST #{LOGIN_URL}"
    $http.post(LOGIN_URL, { email, password })
      .success (data, status) ->
        $log.info "success: #{status} #{JSON.stringify(data)}"
        _store(data)
        $http.defaults.headers.common["X-User-Email"] = email
        $http.defaults.headers.common["X-User-Token"] = data.authentication_token
        success(data, status) if success?
      .error (data, status) ->
        $log.info "error: #{status} #{JSON.stringify(data)}"
        error(data, status) if error?

  logout = ->
    delete $http.defaults.headers.common["X-User-Email"]
    delete $http.defaults.headers.common["X-User-Token"]
    _store {}

  reload = ->
    $log.info "reload #{data.email}"
    $log.info "POST #{RELOAD_URL}#{data.id}"
    $http.get(RELOAD_URL+data.id)
      .success (data, status) ->
        $log.info "success: #{status} #{JSON.stringify(data)}"
        _store(data)
      .error (data, status) ->
        # TODO handle error properly
        $log.info "error: #{status} #{JSON.stringify(data)}"

  signedIn = ->
    !!data.id?


  {
    login
    logout
    reload
    data
    signedIn
  }

angular.module("voicerepublic").service('User', userFn)
