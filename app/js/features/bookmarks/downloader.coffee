###
@ngdoc service
@name Downloader

@object

@description
  The Downloader service is used to download talks.

  **Note:** 
    Using the following cordova plugins:
    - cordova.fileTransfer

@example

@events
  progress - ''
  aborted - ''
  offline - ''
  error - param: error
  talkDownloaded - param: talk
  imageDownloaded - ''

###
angular.module("voicerepublic")

.service 'Downloader', ($timeout, $http, $localstorage, $cordovaFileTransfer, ObserverFactory, BookmarksFactory) ->
  new class Downloader extends ObserverFactory
    constructor: ->
      @promise = undefined
      @isDownloading = no

    _resetMembers: () ->
      @promise = undefined
      @isDownloading = no

    _downloadImageForTalk: (talk) ->
      self = @
      fileName = talk.title.trim " "
      fileName = fileName.replace /\s+/g, "_"
      fileName += '.png'
      #needs a file bcs it opens a file via native file.open() to write download data
      targetPath = BookmarksFactory.FILE_SYS_LOCATION + BookmarksFactory.DIR_NAME_IMAGES + '/' + fileName
      url = talk.image_url
      trustHosts = yes
      options = {}

      imageDownloadPromise = $cordovaFileTransfer.download url, targetPath, options, trustHosts
      imageDownloadPromise.then ((success) ->
        self.isDownloading = no
        self.promise = undefined
        #assign the image nativeURL to talk
        BookmarksFactory.assignImageUrlToTalk success.nativeURL, talk
        self.fireEvent 'imageDownloaded'
      ), ((error) ->
        self.isDownloading = no
        self.promise = undefined
        #something went wrong
        self._resetMembers()
        if error.code is FileTransferError.ABORT_ERR
          self.fireEvent 'aborted'
        else if error.code is FileTransferError.CONNECTION_ERR
          self.fireEvent 'offline'
        else
          self.fireEvent 'error', error
      ), ((progress) ->
        # big files -> not computable
        #show progress
        if progress.lengthComputable
          $timeout () ->
            downloadProgress = (progress.loaded / progress.total) * 100
            self.fireEvent 'progress', downloadProgress
      )

      #needed for cancellation
      @isDownloading = yes
      @promise = imageDownloadPromise

      #expose the image download promise
      imageDownloadPromise

    #depends on _downloadImageForTalk
    _downloadTalkResourceWithImage: (talk) ->
      self = @
      fileName = talk.title.trim " "
      fileName = fileName.replace /\s+/g, "_"
      fileName += '.mp3'
      #needs a file bcs it opens a file via native file.open() to write download data
      targetPath = BookmarksFactory.FILE_SYS_LOCATION + BookmarksFactory.DIR_NAME_BOOKMARKS + '/' + fileName
      url = talk.url
      trustHosts = yes
      options = {}

      downloadTalkPromise = $cordovaFileTransfer.download url, targetPath, options, trustHosts
      downloadImagePromise = downloadTalkPromise.then ((success) ->
        self.promise = undefined
        self.isDownloading = no
        #save the talk to storage and assign nativeURL
        talk.isDownloaded = yes
        #assign fullPath for IOS PLAYER QUIRKS
        talk.fullPath = success.fullPath
        BookmarksFactory.saveTalkWithNativeUrl talk, success.nativeURL
        #alright now download the image
        self._downloadImageForTalk talk
        self.fireEvent 'talkDownloaded', talk
      ), ((error) ->
        self.promise = undefined
        self.isDownloading = no
        #something went wrong
        self._resetMembers()
        if error.code is FileTransferError.ABORT_ERR
          self.fireEvent 'aborted'
        else if error.code is FileTransferError.CONNECTION_ERR
          self.fireEvent 'offline'
        else
          self.fireEvent 'error', error
      ), ((progress) ->
        # big files -> not computable
        #show progress
        if progress.lengthComputable
          $timeout () ->
            downloadProgress = (progress.loaded / progress.total) * 100
            self.fireEvent 'progress', downloadProgress
      )

      #needed for cancellation
      @isDownloading = yes
      @promise = downloadTalkPromise

      #expose the talk & image download promise chain
      downloadImagePromise

    cancelDownload: () ->
      if @promise and @isDownloading
        @promise.abort()

    downloadTalk: (talk) ->
      self = @
      #checkDirs
      checkDirsPromise = BookmarksFactory.checkDirs()
      downloadTalkPromise = checkDirsPromise.then ((success) ->
        #Folders exist proceed with download
        self._downloadTalkResourceWithImage talk
      ), ((error) ->
        code = error.code # 1: NOT_FOUND_ERR
        if code is FileError.NOT_FOUND_ERR
          # Dir does not exist
          createDirsPromise = BookmarksFactory.createDirs()
          createDirsPromise.then ((success) ->
            #Folders created proceed with download
            self._downloadTalkResourceWithImage talk
          ), ((error) ->
            #something went wrong
            self.fireEvent  'error', error
          )
          #expose the createDir promise
          createDirsPromise
        else
          #something went wrong
          self.fireEvent 'error', error
      )

      #expose the whole promise chain
      downloadTalkPromise
