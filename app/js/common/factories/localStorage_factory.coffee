angular.module("voicerepublic")

.factory "$localstorage", ($window, $log) ->
  new class localstorage
    set: (key, value) ->
      $log.warn "Don't use $localstorage; use $localStorage of ngStorage instead."
      $window.localStorage[key] = value
    get: (key, defaultValue) ->
      $log.warn "Don't use $localstorage; use $localStorage of ngStorage instead."
      $window.localStorage[key] or defaultValue
    setObject: (key, value) ->
      $log.warn "Don't use $localstorage; use $localStorage of ngStorage instead."
      $window.localStorage[key] = JSON.stringify value
    getObject: (key) ->
      $log.warn "Don't use $localstorage; use $localStorage of ngStorage instead."
      JSON.parse $window.localStorage[key] or "[]"
