###
@ngdoc factory
@name TalkFactory

@object

@description
  The TalkFactory provides functionallity to 
  create/retrieve/delete talks (audio files)
  from the native persistent filesystem (storage).

  **Note:** 
    Using the following cordova plugins:
    - cordova.file

@example
  talk =  TalkFactory.createNew()

  talks = TalkFactory.getAllTalks()

  talk = TalkFactory.getTalkById id

  TalkFactory.deleteTalk id
###
angular.module("voicerepublic")

.factory 'TalkFactory', ($localstorage, $cordovaFile, $log) ->
  class TalkFactory
    constructor: () ->
      #constructor

    createNew: () ->
      date = new window.Date()
      prefix = window.cordova.file.dataDirectory
      sufix = "talk_on_" + date.toDateString().replace /\s/g, ''
      sufix += ".wav"

      talkId = $localstorage.get "idCounter", 0
      $localstorage.set "idCounter", ++talkId

      talk =
        id : talkId
        src : prefix + sufix
        filename : sufix
        isUploaded : false

      talks = $localstorage.getObject "talks"

      if talks is {}
        talks = []
        talks.push talk
      else
        talks.push talk

      $localstorage.setObject "talks", talks

      #expose talk
      talk

    getAllTalks: () ->
      talks = $localstorage.getObject "talks"

      #expose talks
      talks

    getTalkById: (id) ->
      talks = $localstorage.getObject "talks"

      talk = talk for talk in talks when talk.id is id

      #expose talk which has the id
      talk

    deleteTalk: (id) ->
      talk = @getTalkById id
      deleted = false

      $cordovaFile.removeFile(window.cordova.file.dataDirectory, talk.filename)
      .then ((success) ->
        deleted = true
      (error) ->
        deleted = false
        $log.debug error
      )

      talks = @getAllTalks()
      pos = 0
      pos++ until talk.id > id
      talks = talks.splice pos, 1

      $localstorage.setObject "talks", talks

      #expose status of delete
      deleted