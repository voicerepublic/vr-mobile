###
@ngdoc service
@name Player

@object

@description
  The Player used to play talks in the List View.

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

.service 'Player', ($cordovaMedia, ObserverFactory, $window, $log) ->
  new class Player extends ObserverFactory
    constructor: ->
      @talkMedia = undefined

    start : (talk) ->
      self = @

      @talkMedia = $cordovaMedia.newMedia talk.nativeURL

      @talkMedia.then((success) ->
        $log.debug "Successfully playing file!"
        #notify that player stopped
        self.fireEvent "stopped"
      (error) ->
        $log.debug "An error occured while playing!"
        self.fireEvent "error", error
      )

      if typeof @talkMedia.play is "function"
        @talkMedia.play()

    stop : ->
      if typeof @talkMedia.stop is "function"
        @talkMedia.stop()
        @talkMedia.release()