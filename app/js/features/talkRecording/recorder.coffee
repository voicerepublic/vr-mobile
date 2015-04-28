###
@ngdoc service
@name Recorder

@object

@description
  The Recorder service is used to handle
  the whole recording logic. It depends on
  our TalkFactory.

  **Note:** 
    Using the following cordova plugins:
    - cordova.media

@example
  Recorder.start()
  Recorder.mute()
  Recorder.stop()
###
angular.module("voicerepublic")

.service 'Recorder', ($ionicPlatform, $cordovaMedia, TalkFactory, ObserverFactory, $window, $log) ->
  new class Recorder extends ObserverFactory
    constructor: ->
      @talkMedia = undefined

    start : ->
      talk = TalkFactory.createNew()

      @talkMedia = $cordovaMedia.newMedia talk.src

      @talkMedia.then((success) ->
        $log.debug "Successfully recorded file!"
      (error) ->
        $log.debug "An error occured while recording!"
        $window.alert "error while recording:" + error.message
      )

      if typeof @talkMedia.startRecord is "function"
        @talkMedia.startRecord()
      else
        $window.alert "something went wrong!"

    mute : -> 
      @talkMedia.setVolume "0.0"

    unMute : ->
      @talkMedia.setVolume "1.0"

    stop : ->
      if typeof @talkMedia.stopRecord is "function"
        @talkMedia.stopRecord()
      else
        $window.alert "something went wrong!"