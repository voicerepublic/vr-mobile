###
@ngdoc factory
@name BookmarksFactory

@object

@description
  The TalkFactory provides functionality to
  create/retrieve/delete downloaded & bookmarked Talks (audio files)
  from the native persistent filesystem (storage).

  **Note:** 
    Using the following cordova plugins:
    - cordova.file

@models

@examples
  For private usage
  -----------------
    

  For public usage
  ----------------
   
###
angular.module("voicerepublic")

.factory 'BookmarksFactory', ($window, $q, $localstorage, $cordovaFile, ObserverFactory) ->
  new class BookmarksFactory extends ObserverFactory
    constructor: () ->
      @DATA_STRUCTURE_KEY = 'bookmarks'
      @DIR_NAME_BOOKMARKS = 'bookmarks'
      @DIR_NAME_IMAGES = 'images'
      @FILE_SYS_LOCATION = ''
      if $window.ionic.Platform.isIOS()
        @FILE_SYS_LOCATION = $window.cordova.file?.documentsDirectory
      else if $window.ionic.Platform.isAndroid()
        @FILE_SYS_LOCATION = $window.cordova.file?.externalDataDirectory
      
    _saveToDataStructure: (talk) ->
      talks = $localstorage.getObject @DATA_STRUCTURE_KEY

      talks.push talk

      $localstorage.setObject @DATA_STRUCTURE_KEY, talks

    _saveAllToDataStructure: (talks) ->
      $localstorage.setObject @DATA_STRUCTURE_KEY, talks

    _removeFromDataStructure: (talkToDelete) ->
      #retrieve talks
      talks = $localstorage.getObject @DATA_STRUCTURE_KEY

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
      $localstorage.setObject @DATA_STRUCTURE_KEY, talks

    _removeImageFromFileSystem: (talkToDelete) ->
      path = @FILE_SYS_LOCATION
      path = path + @DIR_NAME_IMAGES + '/'
      fileName = talkToDelete.title.trim " "
      fileName = fileName.replace /\s+/g, "_"
      fileName += '.png'

      #remove image from filesystem
      $cordovaFile.removeFile path, fileName
      .then ((success) ->
        #not that important
      ), ((error) ->
        #not that important
      )

    _removeAudioFromFileSystem: (talkToDelete) ->
      self = @
      path = @FILE_SYS_LOCATION
      path = path + @DIR_NAME_BOOKMARKS + '/'
      fileName = talkToDelete.title.trim " "
      fileName = fileName.replace /\s+/g, "_"
      fileName += '.mp3'

      #remove bookmarked talk from filesystem
      removeTalkPromise = $cordovaFile.removeFile path, fileName
      removeTalkPromise.then ((success) ->
        #remove from DataStructure
        self._removeImageFromFileSystem talkToDelete
        self._removeFromDataStructure talkToDelete
        self.fireEvent 'delete', talkToDelete
      ), ((error) ->
        #remove from DataStructure
        self._removeFromDataStructure talkToDelete
        self.fireEvent 'delete', talkToDelete
        self._removeImageFromFileSystem talkToDelete
      )

      #expose promise
      removeTalkPromise

    checkDirs: () ->
      # reject means the folders does not exist or something went wrong
      # resolve means the folders exist
      self = @
      deferred = $q.defer()
      bookmarksFolderExists = no
      # check if dir bookmarks exists
      checkBookmarksDirPromise = $cordovaFile.checkDir @FILE_SYS_LOCATION, @DIR_NAME_BOOKMARKS
      checkImagesDirPromise = checkBookmarksDirPromise.then ((success) ->
        bookmarksFolderExists = yes
        #check for images dir
        $cordovaFile.checkDir self.FILE_SYS_LOCATION, self.DIR_NAME_IMAGES
      ), ((error) ->
        code = error.code # 1: NOT_FOUND_ERR
        if code is FileError.NOT_FOUND_ERR
          #check for images dir anyway
          $cordovaFile.checkDir self.FILE_SYS_LOCATION, self.DIR_NAME_IMAGES
        else
          deferred.reject error
      )
      # check if dir images exists
      checkImagesDirPromise.then ((success) ->
        if bookmarksFolderExists
          deferred.resolve success
        else
          # simulate code 1: NOT_FOUND_ERR
          deferred.reject {code: FileError.NOT_FOUND_ERR}
      ), ((error) ->
        deferred.reject error
      )

      # expose the deferred promise
      deferred.promise


    createDirs: () ->
      # reject means something went wrong
      # resolve means the folders were created or already exist
      self = @
      deferred = $q.defer()
      shouldReplace = no
      #create the bookmarks folder
      createBookmarksDirPromise = $cordovaFile.createDir @FILE_SYS_LOCATION, @DIR_NAME_BOOKMARKS, shouldReplace
      createImagesDirPromise = createBookmarksDirPromise.then ((success) ->
        #create the images folder
        $cordovaFile.createDir self.FILE_SYS_LOCATION, self.DIR_NAME_IMAGES, shouldReplace
      ), ((error) ->
        code = error.code # 12: PATH_EXISTS_ERR
        #if folder bookmarks exists try to create images folder anyway
        if code is FileError.PATH_EXISTS_ERR
          $cordovaFile.createDir self.FILE_SYS_LOCATION, self.DIR_NAME_IMAGES, shouldReplace
        else
          deferred.reject error
      )
      #create the images folder
      createImagesDirPromise.then ((success) ->
        #both created
        deferred.resolve success
      ), ((error) ->
        code = error.code # 12: PATH_EXISTS_ERR
        #already exists
        if code is FileError.PATH_EXISTS_ERR
          deferred.resolve yes
        else
          deferred.reject error
      )

      # expose the deferred promise
      deferred.promise

    getAllPersistedTalks: () ->
      $localstorage.getObject @DATA_STRUCTURE_KEY

    saveTalkWithNativeUrl: (talk, url) ->
      talk.nativeURL = url
      # save the bookmarked talk to local storage
      @_saveToDataStructure talk

    assignImageUrlToTalk: (url, talkWithLocalImage) ->
      talkWithLocalImage.image_url = url
      # save the local image url
      allPersistedTalks = @getAllPersistedTalks()

      for talk, i in allPersistedTalks when talk.id is talkWithLocalImage.id
        allPersistedTalks[i] = talkWithLocalImage

      @_saveAllToDataStructure allPersistedTalks

    mergeWithPersistedTalks: (scopeBookmarks) ->
      #merge the persisted talks with the existing
      #ones got from the fetcher

      persistedTalks = @getAllPersistedTalks()
      remainingPersistedTalks = []
      for persistedTalk in persistedTalks
        wasNotReplaced = yes
        for fetchedTalk, i in scopeBookmarks
          if fetchedTalk.id is persistedTalk.id
            scopeBookmarks[i] = persistedTalk
            wasNotReplaced = no
            break
        remainingPersistedTalks.push persistedTalk if wasNotReplaced

      #fill list with talks persisted on device but not in backend
      scopeBookmarks.push remainingPersistedTalk for remainingPersistedTalk in remainingPersistedTalks

    delete: (talk) ->
      # remove the bookmarked talk from the local storage
      @_removeAudioFromFileSystem talk




