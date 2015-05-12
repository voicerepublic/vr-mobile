###
@ngdoc controller
@name talkListCtrl

@function

@description
  This Controller is responsible for the Talk overview.
  It uses the following services & factories:
  - TalkFactory
  - Player

  **Note:** 
  Using the following cordova plugins:
  - cordova.toast
###
angular.module("voicerepublic")

.controller "talkListCtrl", ($rootScope, $scope, $state, $stateParams, $window, $ionicHistory, $ionicActionSheet, $cordovaToast, TalkFactory, Player) ->
  #needed to display playing talks
  $scope.isPlayingId = ""

  #platform specific
  $scope.isAndroid = $window.ionic.Platform.isAndroid()
  $scope.isIOS = $window.ionic.Platform.isIOS()

  #init arrays on startup
  $scope.talksToUpload = TalkFactory.getTalksToUpload()
  $scope.uploadedTalks = TalkFactory.getUploadedTalks()

  #list options
  $scope.shouldShowDelete = no
  $scope.hideActionSheet = undefined

  #events
  #
  #refresh data if view rentered & loading
  $rootScope.$on "$viewContentLoading", (event, viewConfig) ->
    #fix some bad behaviours of the list
    $scope.talksToUpload = TalkFactory.getTalksToUpload()
    $scope.uploadedTalks = TalkFactory.getUploadedTalks()
    $scope.shouldShowDelete = no

  #notify view if Player stopped
  Player.on "stopped", () ->
    ($scope.isPlayingId = "") unless $scope.isPlayingId is ""
      
  #notify user if Player had an error
  Player.on "error", (error) ->
    $cordovaToast.showShortBottom "Could not play talk #{talk.id}, #{error.message}"
    ($scope.isPlayingId = "") unless $scope.isPlayingId is ""

  #swipe actions
  #
  #swiped right
  $scope.onSwipedRight = () ->
    #handle if user does not stop manually
    $scope.stopPlaying() unless $scope.isPlayingId is ""
    $state.go "tab.record"

  #ActionSheet on list item click
  #
  $scope.openActionSheet = (talk, position, thisTalkIsUploaded) ->
    #conditional button text
    #based on platform
    if $scope.isAndroid 
      specificShareButton = 
        text: '<i class="icon ion-android-share-alt"></i> <b>Share</b>'
    else
      specificShareButton = 
        text: '<i class="icon ion-share"></i> <b>Share</b>'
    #needed Buttons
    stopButton = 
      text: '<i class="icon ion-stop assertive"></i> Stop'
    playButton =
      text: '<i class="icon ion-play"></i> Play'
    uploadButton =
      text: '<i class="icon ion-upload"></i> <b>Upload</b>'
    shareButton = specificShareButton
    #determine if this talk is playing
    thisTalkIsPlaying = $scope.isPlayingId is talk.id
    #button array
    sheetButtons = []
    #fill the sheetButtons dynamically
    if thisTalkIsUploaded then sheetButtons.push shareButton
    else sheetButtons.push uploadButton
    if thisTalkIsPlaying then sheetButtons.unshift stopButton
    else sheetButtons.push playButton
    #options needed for the ActionSheet
    options = 
      buttons: sheetButtons
      titleText: "Please select an action for #{talk.title}"
      destructiveText: '<i class="icon ion-trash-b assertive"></i> <b class="assertive">Delete</b>'
      cancelText: "Cancel"
      destructiveButtonClicked: ->
        $scope.delete talk, position
        #close the sheet
        true
      cancel: ->
        #basically close the Sheet
        $scope.hideActionSheet()
      buttonClicked: (index) ->
        switch index
          when 0
            if thisTalkIsPlaying then $scope.stopPlaying()
            else 
              if thisTalkIsUploaded then $scope.share talk
              else $scope.upload talk
          when 1
            if not thisTalkIsPlaying then $scope.play talk
            else
              if thisTalkIsUploaded then $scope.share talk
              else $scope.upload talk
        #close the sheet
        true
    #finally show the ActionSheet
    $scope.hideActionSheet = $ionicActionSheet.show options

  $scope.upload = (talk) ->
    #handle if user does not stop manually
    $scope.stopPlaying() unless $scope.isPlayingId is ""

    params =
      talkToUploadId: talk.id

    $state.go "tab.upload", params

  $scope.share = (talk) ->
    #handle if user does not stop manually
    $scope.stopPlaying() unless $scope.isPlayingId is ""
    params =
      talkToShareId: talk.id

    $state.go "tab.share", params

  #menu button
  #
  $scope.toggleDelete = () ->
    $scope.shouldShowDelete = not $scope.shouldShowDelete

  #list buttons
  #
  $scope.delete = (talk, position) ->
    #handle if user does not stop manually
    $scope.stopPlaying() unless $scope.isPlayingId is ""
    promise = TalkFactory.deleteTalk talk
    promise.then((success) ->
      unless talk.isUploaded then $scope.talksToUpload.splice position, 1
      else $scope.uploadedTalks.splice position, 1
      $cordovaToast.showShortBottom "Deleted talk #{talk.id}"
    (error) ->
      unless talk.isUploaded then $scope.talksToUpload.splice position, 1
      else $scope.uploadedTalks.splice position, 1
      $cordovaToast.showShortBottom "Deleted talk #{talk.id}, with error: #{error.message}"
    )

  $scope.play = (talk) ->
    #handle if user does not stop manually
    $scope.stopPlaying() unless $scope.isPlayingId is ""
    #start the player
    Player.start talk
    $cordovaToast.showShortBottom("Playing talk #{talk.id}")
    .then(() ->
      #view update, little hack^^
      $scope.isPlayingId = talk.id
    () ->
      #error
    )

  $scope.stopPlaying = () ->
    Player.stop() if $scope.isPlayingId isnt ""
    $scope.isPlayingId = ""