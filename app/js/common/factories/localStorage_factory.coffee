angular.module("voicerepublic")

.factory "$localstorage", ($window) ->
  new class localstorage
    set: (key, value) ->
      $window.localStorage[key] = value
    get: (key, defaultValue) ->
      $window.localStorage[key] or defaultValue
    setObject: (key, value) ->
      $window.localStorage[key] = JSON.stringify value
    getObject: (key) ->
      JSON.parse $window.localStorage[key] or "[]"