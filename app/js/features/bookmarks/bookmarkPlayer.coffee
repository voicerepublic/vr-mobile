###
@ngdoc service
@name Advanced Player

@object

@description
  The Player used to play talks in the Bookmarks View.

  This player is advanced since it uses the cordova media api directly. The other player
  is a angular wrapper contained in ngCordova to provide better DI and encapsulation 
  (hopefully in the future also testability).

  **Note:** 
    Using the following cordova plugins:
    - cordova.media

@example
  Player.start talk
  Player.stop()

@events
  Player.on "stopped" ->
    #stopped

  Player.on "error", (error) ->
    #stopped with error
###
angular.module("voicerepublic")

.service 'BookmarkPlayer', ($cordovaMedia, ObserverFactory, $window, $log) ->
  new class BookmarkPlayer extends ObserverFactory
    constructor: ->
      @talkMedia = undefined