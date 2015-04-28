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

.factory 'TalkFactory', ($window, $localstorage, $cordovaFile, $log) ->
  new class TalkFactory
    constructor: () ->
      #constructor

    createNew: () ->
      date = new $window.Date()
      prefix = "" #window.cordova?.file.dataDirectory not working!!!?

      talkId = $localstorage.get "idCounter", 0
      $localstorage.set "idCounter", ++talkId
      
      sufix = "talk" + talkId + "_from_" + date.toDateString().replace /\s/g, ''
      
      if $window.ionic.Platform.isAndroid() then sufix+=".amr"
      if $window.ionic.Platform.isIOS() then sufix+=".wav"

      talk =
        id : talkId
        src : prefix + sufix
        filename : sufix
        isUploaded : false
        title : "Talk " + talkId
        recordDate : date.getUTCDate()+"."+(1+date.getUTCMonth())+"."+date.getUTCFullYear()
        img : "img/vr_400x400.png"

      talks = $localstorage.getObject "talks"

      talks.push talk

      $localstorage.setObject "talks", talks

      #expose talk
      talk

    getAllTalks: () ->
      talks = $localstorage.getObject "talks"

      #expose talks
      talks

    deleteTalk: (talk) ->
      isDeleted = false
      path = $window.cordova?.file.dataDirectory
      $cordovaFile.removeFile(path, talk.filename)
      .then ((success) ->
        isDeleted = true
      (error) ->
        isDeleted = false
        $log.debug error
      )

      talks = @getAllTalks()
      pos = 0
      pos++ until talk.id > id
      talks = talks.splice pos, 1

      $localstorage.setObject "talks", talks

      #expose status of removing talk
      isDeleted

    #if needed
    _getTalkById: (id) ->
      talks = $localstorage.getObject "talks"

      talk = talk for talk in talks when talk.id is id

      #expose talk which has the id
      talk