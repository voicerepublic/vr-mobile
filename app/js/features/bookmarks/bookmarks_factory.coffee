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
  downloadedBookmarkedTalk =
    id : talkId
    duration: 
    description:
    img : "img/VR_Logo_rgb_4.png"

@examples
  For private usage
  -----------------
    

  For public usage
  ----------------
   
###
angular.module("voicerepublic")

.factory 'BookmarksFactory', ($window, $q, $localstorage, $cordovaFile, $log, ObserverFactory) ->
  new class BookmarksFactory
    constructor: () ->
      @DATA_STRUCTURE_KEY = 'bookmarks'
      @DIR_NAME = 'bookmarks'
      
    _saveToDataStructure: (talk) ->
      bookmarks = $localstorage.getObject @DATA_STRUCTURE_KEY

      bookmarks.unshift talk

      $localstorage.setObject @DATA_STRUCTURE_KEY, bookmarks

    _removeFromDataStructure: (talkToDelete) ->

    _removeFromFileSystem: (talkToDelete) ->

    dirExists: ->
      # check if dir DIR_NAME exists

    createDir: ->
      # create the dir DIR_NAME

    save: (talk) ->
      # save the bookmarked talk to local storage

    delete: (talk) ->
      # remove the bookmarked talk from the local storage





