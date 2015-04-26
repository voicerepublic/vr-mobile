angular.module("voicerepublic")
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
        - cordova.file

@example
    Recorder.start()
    Recorder.mute()
    Recorder.stop()
###
.service 'Recorder', ($window, $cordovaMedia, TalkFactory, $log) ->

	new Class Recorder extends ObserverFactory
        constructor: ->
            @talkMedia = undefined

        start : ->
            talkFile = TalkFactory.createNew()

            @talkMedia = $cordovaMedia.newMedia(talkFile.src).then(() ->
                $log.debug "Successfully recorded file!"
                ,() ->
                    $log.debug "An error occured while recording!"
                    @fireEvent "error", "some params"
                )

            @talkMedia.startRecord()

        mute : -> 
            #mute recording here

        stop : ->
            @talkMedia.stopRecord()