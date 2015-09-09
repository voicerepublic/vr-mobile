###
@ngdoc factory
@name TalkFactory

@object

@description
  The Fetcher

@models
  bookmarked_talk =
    key: value

@examples
  For private usage
  -----------------

  For public usage
  ----------------
###
angular.module("voicerepublic")

.factory 'Fetcher', ($window, $q, $localstorage, $log, ObserverFactory) ->
  new class Fetcher extends ObserverFactory
    constructor: () ->
      offset = 0
      
    _fetchNextBundle: () ->
      #fetch

    refresh: () ->
      _fetchNextBundle()