###
@ngdoc factory
@name TalkFactory

@object

@description
  The TalkFactory provides functionallity to 
  create/retrieve/delete talks (audio files)
  from the native persistent filesystem (storage).

  It extends the provided ObserverFactory to fire events
  in order to handle native features, which are implemented
  anynchronously with the use of promises.

  **Note:** 
    Using the following cordova plugins:
    - cordova.file

@models
  talk =
    id : talkId
    fullPath : "/talks/" + fileName
    nativeURL : path + fileName
    shareURL : "https://voicerepublic.com/talks/testformobile"
    filename : fileName
    isUploaded : false
    isShared : false
    recordDate : recordDate
    recordTime : recordTime
    duration : ""
    title : "Talk " + talkId
    teaser : ""
    description : ""
    venue : ""
    language : "English"
    isShared: ""
    img : "img/VR_Logo_rgb_4.png"

@examples
  For private usage
  -----------------
    talk = TalkFactory._createTalkDataStructure path=""
      -> where path is the platform specific absolute path to the talk (without filename)

    TalkFactory._removeTalkFromDataStructure talk

  For public usage
  ----------------
    promise = TalkFactory.createNew()
    promise.then((talk) ->
      #do amazing stuff with your talk
    (error) ->
      #notify user that something went wrong
      alert "Error: #{error.message} with code #{error.code}"
    )

    talks = TalkFactory.getAllTalks()

    talks = TalkFactory.getUploadedTalks()

    talks = TalkFactory.getTalksToUpload()

    talk = TalkFactory.getTalkById id=1337

    TalkFactory.setDurationForTalk talk, hours=1, minutes=2, seconds=3

    promise = TalkFactory.deleteTalk talk
    promise.then((success) ->
      #talk deleted
      alert JSON.stringify success
    (error) ->
      #notify user that something went wrong
      alert "Error: #{error.message} with code #{error.code}"
    )
###
angular.module("voicerepublic")

.factory 'TalkFactory', ($window, $q, $localstorage, $cordovaFile, $log, ObserverFactory) ->
  new class TalkFactory extends ObserverFactory
    constructor: () ->
      #constructor
      
    _createTalkDataStructure: (path = "") ->
      #keep track of date data
      date = new $window.Date()
      recordDate = date.toLocaleDateString()
      recordTime = date.toLocaleTimeString()
      startsAtDate_year = "#{date.getFullYear()}"
      startsAtDate_month = date.getMonth() + 1 #strange...
      startsAtDate_month = if startsAtDate_month < 10 then "0#{startsAtDate_month}" else "#{startsAtDate_month}"
      startsAtDate_day = if date.getDate() < 10 then "0#{date.getDate()}" else "#{date.getDate()}"
      startsAtDate = "#{startsAtDate_year}-#{startsAtDate_month}-#{startsAtDate_day}"
      startsAtTime_hours = if date.getHours() < 10 then "0#{date.getHours()}" else "#{date.getHours()}"
      startsAtTime_minutes = if date.getMinutes() < 10 then "0#{date.getMinutes()}" else "#{date.getMinutes()}"
      startsAtTime = "#{startsAtTime_hours}:#{startsAtTime_minutes}"

      #persistent autoincrement of id
      talkId = $localstorage.get "idCounter", 0
      $localstorage.set "idCounter", ++talkId

      #filename based on id and date
      fileName = "talk" + talkId + "_" + date.toDateString().replace /\s+/g, "_"
      
      #set the platform specific file ending to maintain the compatibility
      if $window.ionic.Platform.isAndroid() then fileName+=".amr"
      if $window.ionic.Platform.isIOS() then fileName+=".wav"

      talk =
        id : talkId
        fullPath : "/talks/" + fileName
        nativeURL : path + fileName
        filename : fileName
        isUploaded : false
        isShared : false
        starts_at_date : startsAtDate
        starts_at_time : startsAtTime
        recordDate : recordDate
        recordTime : recordTime
        unifiedDate : date.toLocaleString()
        duration : ""
        title : "Talk " + talkId
        teaser : ""
        description : ""
        venue : ""
        language : "English"
        sharedVia: "" #not given yet by cordova plugin
        img : "img/VR_Logo_rgb_4.png" #prophylactic for later use

      talks = $localstorage.getObject "talks"
      #make sure newer talks appear on the top of the list
      talks.unshift talk

      $localstorage.setObject "talks", talks

      #expose the created talk
      talk

    _removeTalkFromDataStructure: (talkToDelete) ->
      #retrieve talks
      talks = $localstorage.getObject "talks"

      #talk position
      position = 0

      #get the position
      for talk in talks
        if talk.id is talkToDelete.id
          break
        else
          position++

      #remove the talk from the array
      talks.splice position, 1

      #save the talks Object without the removed one
      $localstorage.setObject "talks", talks

    createNew: () ->
      self = @
      q = $q.defer()
      talk = undefined

      #Filesystem Operations
      #
      #path to the platform specific data directories
      path = $window.cordova.file?.externalDataDirectory if $window.ionic.Platform.isAndroid()
      path = $window.cordova.file?.documentsDirectory if $window.ionic.Platform.isIOS()
      
      #needed Promises
      createDirPromise = undefined
      createFilePromise = undefined

      #create the "talks" directory or proceed with file creation
      #if the directory already exists
      createDirPromise = $cordovaFile.createDir path, "talks", false
      createFilePromise = createDirPromise.then((success) ->
        #first creation
        #get the nativeURL with ANDROID
        nativeURLtoTalksDir = success?.nativeURL
        #success is undefined with IOS
        nativeURLtoTalksDir = path + "talks/" if $window.ionic.Platform.isIOS()
        talk = self._createTalkDataStructure nativeURLtoTalksDir

        #return the next promise and build a chain \(^^)/
        $cordovaFile.createFile nativeURLtoTalksDir, talk.filename, false
      (error) ->
        if error.code is 12 and error.message is "PATH_EXISTS_ERR"
          #directory talks exists already! good!
          path = path + "talks/"
          talk = self._createTalkDataStructure path

          #return the next promise and build a chain \(^^)/
          $cordovaFile.createFile path, talk.filename, false
      )

      #handle file creation result
      createFilePromise.then((success) ->
        #assigning not necessary
        #talk.nativeURL = success?.nativeURL
        #talk.fullPath = success?.fullPath
        #resolve with talk as param when success
        q.resolve talk
      (error) ->
        #remove the talk in the DataStructure
        #since it was not created
        self._removeTalkFromDataStructure talk
        #reject with error as param
        q.reject error
      )
      #end Filessystem Operations
      #
      #expose file creation promise
      q.promise

    getAllTalks: () ->
      talks = $localstorage.getObject "talks"

      #expose talks
      talks

    getUploadedTalks: () ->
      talks = $localstorage.getObject "talks"

      uploadedTalks = (talk for talk in talks when talk.isUploaded)

      #expose uploaded talks
      uploadedTalks

    getTalksToUpload: () ->
      talks = $localstorage.getObject "talks"

      talksToUpload = (talk for talk in talks when not talk.isUploaded)

      #expose talks to upload
      talksToUpload

    getTalkById: (id) ->
      talks = $localstorage.getObject "talks"

      talkById = talk for talk in talks when talk.id is $window.parseInt id

      #expose talk which has the id
      talkById

    setDurationForTalk: (talkToEdit, hours, minutes, seconds) ->
      talks = $localstorage.getObject "talks"

      hours = "0" + hours if hours < 10
      minutes = "0" + minutes if minutes < 10
      seconds = "0" + seconds if seconds < 10

      duration = "#{hours}:#{minutes}:#{seconds}"

      talk.duration = duration for talk in talks when talk.id is talkToEdit.id

      $localstorage.setObject "talks", talks

    setTalkUploaded: (uploadedTalk, shareUrl, metadata...) ->
      talks = $localstorage.getObject "talks"

      uploadedTalk.isUploaded = yes
      uploadedTalk.shareURL = shareUrl

      talks[i] = uploadedTalk for talk, i in talks when talk.id is uploadedTalk.id

      $localstorage.setObject "talks", talks

    setTalkShared: (sharedTalk, metadata...) ->
      ###
      via = metadata[0]

      return unless sharedTalk.sharedVia.search(via) is -1
      ###

      return if sharedTalk.isShared
      sharedTalk.isShared = yes
      talks = $localstorage.getObject "talks"
      ###
      if sharedTalk.sharedVia is ""
        sharedTalk.sharedVia+=via
      else
        sharedTalk.sharedVia+=", #{via}"
      ###
      talks[i] = sharedTalk for talk, i in talks when talk.id is sharedTalk.id

      $localstorage.setObject "talks", talks

    deleteTalk: (talkToDelete) ->
      self = @
      #used the angular q, but one could return the existing
      #promise and chain it... but for simplicity's sake:
      q = $q.defer()

      path = $window.cordova.file?.externalDataDirectory if $window.ionic.Platform.isAndroid()
      path = $window.cordova.file?.documentsDirectory if $window.ionic.Platform.isIOS()
      path = path + "talks/"
      file = talkToDelete.filename
      
      #remove talk from filesystem
      $cordovaFile.removeFile(path, file)
      .then((success) ->
        #remove from DataStructure
        self._removeTalkFromDataStructure talkToDelete
        #notify that deleting the talk was successfull
        q.resolve success
      (error) ->
        #remove from DataStructure
        self._removeTalkFromDataStructure talkToDelete
        #notify that deleting the talk was not successfull
        q.reject error
      )

      #expose promise
      q.promise