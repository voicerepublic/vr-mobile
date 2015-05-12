###
@ngdoc controller
@name uploadCtrl

@function

@description
  This Controller is responsible for the uploading view.
  It uses the following services & factories:
  - TalkFactory
  - Uploader

  **Note:** 
  Using the following cordova plugins:
  - cordova.toast
###
angular.module("voicerepublic")

.controller "uploadCtrl", ($scope, $rootScope, $window, $state, $timeout, $ionicHistory, $cordovaToast, TalkToUpload, TalkFactory) ->
  #needed to keep track of uploading
  #if user swipes away
  $scope.uploaded = no

  #get the "resolved" talk
  $scope.talk = TalkToUpload

  #swipe actions
  #
  #swiped right
  $scope.onSwipedRight = () ->
    #redirect, probably more 
    #to do here
    $scope.back() if $scope.uploaded

  #button actions
  #
  $scope.back = () ->
    $ionicHistory.goBack -1

  $scope.startUpload = () ->
    $scope.uploaded = yes

    params = 
      talkToShareId: $scope.talk.id

    $cordovaToast.showShortBottom "Uploading your talk..."
    $timeout ->
      TalkFactory.setTalkUploaded $scope.talk
      $state.go "tab.share", params
      $cordovaToast.showShortBottom "Talk uploaded"
    , 3000