###
@ngdoc service
@name Player

@object

@description
  The Player used to play talks in the Bookmarks View and List View.

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

.service 'Player', ($cordovaMedia, ObserverFactory, $window) ->
  new class Player extends ObserverFactory
    constructor: ->
      @talkMedia = undefined
      @hasLoaded = false

    start : (talk) ->
      #check if talk is local or from url
      if talk.nativeURL
        #IOS QUIRKS
        talk.nativeURL = "documents://" + talk.fullPath if $window.ionic.Platform.isIOS()

        @talkMedia = $cordovaMedia.newMedia talk.nativeURL
      else
        @talkMedia = $cordovaMedia.newMedia talk.url

      # after settling the wrapper -> play it
      @play()

    play : () ->
      self = @
      #play or resume
      if typeof @talkMedia.play is 'function'
        #returning the promise
        @talkMedia.play().then ((success) ->
          #notify that player stopped playing successfully
          self.fireEvent 'stopped'
        ), ((error) ->
          if error.code is MediaError.MEDIA_ERR_NETWORK
            self.fireEvent 'offline'
          else
            self.fireEvent 'error', error
        ), (update) ->
          if update.duration
            if self.hasLoaded
              self.fireEvent 'duration', update.duration
          else if update.position
            if self.hasLoaded
              self.fireEvent 'progress', update.position
          else if update.status
            switch update.status
              when Media.MEDIA_STARTING
                self.fireEvent 'loadStart'
                self.hasLoaded = false
              when Media.MEDIA_RUNNING
                if !self.hasLoaded
                  self.fireEvent 'loadEnd'
                  self.hasLoaded = true
              #when Media.MEDIA_PAUSED
              when Media.MEDIA_NONE, Media.MEDIA_STOPPED
                self.hasLoaded = false

    pause : () ->
      if typeof @talkMedia.pause is 'function'
        @talkMedia.pause()

    seekTo : (pos) ->
      if typeof @talkMedia.seekTo is 'function'
        @talkMedia.seekTo pos

    stop : () ->
      if typeof @talkMedia.stop is 'function'
        @talkMedia.stop()
        @talkMedia.release()
        @talkMedia = undefined