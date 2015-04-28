###
@ngdoc service
@name Player

@object

@description
  The Player used to play talks in the List View

  **Note:** 
    Using the following cordova plugins:
    - cordova.media

@example
  Player.start talk
  Player.stop talk
###
angular.module("voicerepublic")

.service 'Player', ($cordovaMedia, ObserverFactory, $window, $log) ->
  new class Player extends ObserverFactory
    constructor: ->
      @talkMedia = undefined

    start : (talk) ->
      @talkMedia = $cordovaMedia.newMedia talk.src

      @talkMedia.then((success) ->
        $log.debug "Successfully playing file!"
      (error) ->
        $log.debug "An error occured while playing!"
        $window.alert "error while playing:" + error.message + ", " + error.code
      )

      if typeof @talkMedia.play is "function"
        @talkMedia.play()
      else
        $window.alert "something went wrong!"

    stop : ->
      if typeof @talkMedia.stop is "function"
        @talkMedia.stop()
        @talkMedia.release()
      else
        $window.alert "something went wrong!"