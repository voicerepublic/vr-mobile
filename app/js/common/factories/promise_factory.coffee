angular.module("voicerepublic")
# Wraps the value in Promise if it's not.
# This allows you to call `Promise(varIDontKnow).then ->` whenever you can.
.factory 'PromiseFactory', ($q) ->
  constructor = (value, resolve = true) ->
    if value? && typeof value?.then == 'function'
      value
    else
      deferred = $q.defer()
      if resolve
        deferred.resolve(value)
      else
        deferred.reject(value)
      deferred.promise

