###
@ngdoc service
@name Downloader

@object

@description
  The Downloader service is used to 

  **Note:** 
    Using the following cordova plugins:
    - cordova.fileTransfer

@example

@events

###
angular.module("voicerepublic")

.service 'Downloader', ($http, $localstorage, PromiseFactory, ObserverFactory) ->
  new class Downloader extends ObserverFactory
    constructor: ->
      #code here

    downloadTalk: (url) ->
      #code here