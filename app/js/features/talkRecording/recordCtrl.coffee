###
@ngdoc controller
@name recordCtrl

@function

@description
  This Controller is responsible for the recording view.
  It uses the following service:
  - Recorder

  **Note:** 
  Using the following cordova plugins:
  - cordova.toast
###
angular.module("voicerepublic")

.controller "recordCtrl", ($scope, $state, $window, $timeout, $ionicHistory, $ionicLoading, $ionicPopup, $cordovaToast, Recorder, User) ->
  #needed as flag for view
  $scope.isRecording = no
  
  #overlay options
  opts =
    templateUrl: "templates/recordingTemplate.html"
    scope: $scope

  #events
  #
  #listen for Recorder started
  Recorder.on "started", () ->
    #recording started
    $scope.isRecording = yes
    #show the overlay
    $ionicLoading.show opts
    #notify timer directive
    $scope.$broadcast "timer-start"
    #notify user that the recording has started
    $cordovaToast.showShortBottom "Recording started"

  #listen for Recorder saved
  Recorder.on "saved", () ->
    #go to saved talk
    $state.go "tab.talkList"
    #notify saved
    $cordovaToast.showShortBottom "Talk saved"

  #listen for timer-stopped to evaluate
  #and set the duration of the talk 
  #based on the timer directive
  $scope.$on "timer-stopped", (event, data) ->
    h = data.hours
    m = data.minutes
    s = data.seconds
    Recorder.setDuration h, m, s

  #swipe actions
  #
  #swiped left
  $scope.onSwipedLeft = () ->
    $state.go "tab.talkList"

  #swiped left
  $scope.onSwipedRight = () ->
    $state.go "tab.bookmarks"
    
  #Button actions
  #
  $scope.start = () ->
    #init the recorder
    initialized = Recorder.init()
    initialized.then((talk) ->
      #start the recorder
      Recorder.start talk
    (error) ->
      $cordovaToast.showShortBottom "Could not create the talk, #{error.message}"
    )

  $scope.stop = () ->
    #stop the recorder
    Recorder.stop()
    #recording stopped
    $scope.isRecording = no
    #notify timer directive
    $scope.$broadcast "timer-stop"
    #hide the overlay
    $ionicLoading.hide()

  $scope.cancel = () ->
    #cancel the recorder
    Recorder.cancel()
    #recording stopped
    $scope.isRecording = no
    #notify timer directive
    $scope.$broadcast "timer-stop"
    #hide the overlay
    $ionicLoading.hide()

