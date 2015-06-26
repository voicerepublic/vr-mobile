angular.module("voicerepublic")

.service 'Auth', ($http, $localstorage, PromiseFactory, ObserverFactory) ->
  USER_EMAIL_CACHE_KEY = "user_email"
  USER_TOKEN_CACHE_KEY = "user_token"
  USER_SERIES_CACHE_KEY = "user_series"
  USER_DATA_CACHE_KEY = "user_data"

  new class Auth extends ObserverFactory
    constructor: ->
      @setAuthToken(localStorage.getItem(USER_EMAIL_CACHE_KEY), localStorage.getItem(USER_TOKEN_CACHE_KEY))

    setAuthToken: (@email = null, @token = null) ->
      if @email and @token
        $http.defaults.headers.common["X-User-Email"] = @email
        $http.defaults.headers.common["X-User-Token"] = @token
        localStorage.setItem(USER_EMAIL_CACHE_KEY, @email)
        localStorage.setItem(USER_TOKEN_CACHE_KEY, @token)
      else
        delete $http.defaults.headers.common["X-User-Email"]
        delete $http.defaults.headers.common["X-User-Token"]
        localStorage.removeItem(USER_EMAIL_CACHE_KEY)
        localStorage.removeItem(USER_TOKEN_CACHE_KEY)
      #@refreshUser(user)

    refreshUser: (user = null) ->
      @user = if user
        user.$promise = PromiseFactory(user)
        user.$resolved = true
        user
      else if @email && @token
        #AccountResource.getProfile({email: @email})
      else
        null

    isSignedIn: ->
      !!@token

    resetSession: ->
      #AccountResource.signOut()
      @setAuthToken(null, null)

    #user relvant data saved with Authservice rather than 
    #creating an extra fac or srvc could be refactored later
    getSeries: ->
      $localstorage.getObject USER_SERIES_CACHE_KEY

    setSeries: (series) ->
      seriesJsonArray = []
      for key,value of series
        seriesJson =
          "id": key
          "name": value
        seriesJsonArray.push seriesJson
      $localstorage.setObject USER_SERIES_CACHE_KEY, seriesJsonArray

    getUserData: ->
      $localstorage.getObject USER_DATA_CACHE_KEY

    setUserData: (id, firstname, lastname) ->
      userdata = 
        "id": id
        "firstname": firstname
        "lastname": lastname
      $localstorage.setObject USER_DATA_CACHE_KEY, userdata


