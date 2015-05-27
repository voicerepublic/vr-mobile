angular.module("voicerepublic")

.service 'Auth', ($http, PromiseFactory, ObserverFactory) ->
  USER_EMAIL_CACHE_KEY = "user_email"
  USER_TOKEN_CACHE_KEY = "user_token"

  new class Auth extends ObserverFactory
    constructor: ->
      @setAuthToken(localStorage.getItem(USER_EMAIL_CACHE_KEY), localStorage.getItem(USER_TOKEN_CACHE_KEY))

    setAuthToken: (@email = null, @token = null, user) ->
      if @email
        $http.defaults.headers.common["X-User-Email"] = @email
        #$http.defaults.headers.common["X-User-Token"] = @token
        localStorage.setItem(USER_EMAIL_CACHE_KEY, @email)
        #localStorage.setItem(USER_TOKEN_CACHE_KEY, @token)
      else
        delete $http.defaults.headers.common["X-User-Email"]
        #delete $http.defaults.headers.common["X-User-Token"]
        localStorage.removeItem(USER_EMAIL_CACHE_KEY)
        #localStorage.removeItem(USER_TOKEN_CACHE_KEY)
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
      #!!@token
      #workaround
      !!@email

    resetSession: ->
      #AccountResource.signOut()
      @setAuthToken(null, null)
