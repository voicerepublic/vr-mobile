###
@ngdoc service
@name Recorder

@object

@description
  The Recorder service is used to handle
  the whole recording logic. It depends
  on the TalkFactory!

  **Note:** 
    Using the following cordova plugins:
    - cordova.media
    - cordova.toast

@example
  initialized = Recorder.init()
  initialized.then((talk)->
    #start the recorder
    Recorder.start talk
  ()->
    $cordovaToast.showShortBottom "Could not create the talk, #{error.message}"
  )

  Recorder.start talk

  Recorder.cancel()

  Recorder.stop()

  Recorder.setDuration h=00, m=13, s=37

@events
  Recorder.on "started", () ->
    #started

  Recorder.on "saved", () ->
    #talk saved successfully

###
angular.module("voicerepublic")

.service 'Recorder', ($q, $ionicPlatform, $cordovaToast, $cordovaMedia, ObserverFactory, TalkFactory, $window, $log) ->
  new class Recorder extends ObserverFactory
    constructor: ->
      @talkMedia = undefined
      @talk = undefined
      @isCanceled = no

    init: () ->
      #init the cancel flag
      @isCanceled = no
      #create a new Talk before starting
      #the recording, expose the promise
      TalkFactory.createNew()

    start: (@talk) ->
      self = @

      @talkMedia = $cordovaMedia.newMedia @talk.nativeURL

      #start the recording
      if typeof @talkMedia.startRecord is "function"
        @talkMedia.startRecord()
        #notify controller that recording started
        self.fireEvent "started"

      #handle recording result
      @talkMedia.then((success) ->
        #notify controller that recording saved
        unless self.isCanceled
          self.fireEvent "saved"
      (error) ->
        $cordovaToast.showShortBottom "Could not save the talk, #{error.message}"
      )

    cancel: () ->
      @isCanceled = yes

      if typeof @talkMedia.release is "function"
        @talkMedia.release()
        #remove the created talk from FileSystem
        deletePromise = TalkFactory.deleteTalk @talk
        deletePromise.then((success) ->
          $cordovaToast.showShortBottom "Talk canceled"
        (error) ->
          $cordovaToast.showShortBottom "Talk canceled, but file still exists"
        )

    stop: () ->
      if typeof @talkMedia.stopRecord is "function"
        @talkMedia.stopRecord()
        @talkMedia.release()

    setDuration: (h, m, s) ->
      unless @isCanceled
        TalkFactory.setDurationForTalk @talk, h, m, s
