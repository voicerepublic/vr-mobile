###
@ngdoc controller
@name shareCtrl

@function

@description
  This Controller is responsible for the uploading view.
  It uses the following factory:
  - TalkFactory

  **Note:** 
  Using the following cordova plugins:
  - cordova.SocialSharing
###
angular.module("voicerepublic")

.controller "shareCtrl", ($rootScope, $window, $scope, $state, $stateParams, $ionicHistory, $cordovaSocialSharing, TalkToShare, TalkFactory) ->
  #needed to keep track of state
  #for swipe
  $scope.shared = no
  $scope.isAndroid = $window.ionic.Platform.isAndroid()
  $scope.isIOS = $window.ionic.Platform.isIOS()

  #get the "resolved" talk
  $scope.talk = TalkToShare

  #swipe actions
  #
  #swiped right
  $scope.onSwipedRight = () ->
    #redirect, probably more 
    #to do here
    $scope.back() if $scope.shared

  #button actions
  #
  $scope.back = () ->
    lastTitle = $ionicHistory.backTitle() or ""
    if lastTitle is "Talks overview" then $ionicHistory.goBack -1
    else $ionicHistory.goBack -2

  $scope.share = () ->
    #shared stuff
    message = "My first talk..."
    subject = "First talk!"
    file = null
    link = "https://voicerepublic.com/talks/1"

    TalkFactory.setTalkShared $scope.talk

    $cordovaSocialSharing
    .share(message, subject, file, link)
    .then((result) ->
      TalkFactory.setTalkShared $scope.talk
      $scope.shared = yes
    (error) ->
      $scope.shared = no
    )