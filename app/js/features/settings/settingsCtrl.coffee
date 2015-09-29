###
@ngdoc controller
@name settingsCtrl

@function

@description
  This Controller is responsible for settings tab.

###
angular.module("voicerepublic")

.controller "settingsCtrl", ($rootScope, $scope, $state, $stateParams, $window, $ionicHistory, $ionicActionSheet, $ionicPopup, Auth, $log) ->

  $log.log 'hello from settingsCtrl'
  $log.debug 'hello from settingsCtrl'
  $log.info 'hello from settingsCtrl'
  $log.error 'hello from settingsCtrl'

  #platform specific
  $scope.isAndroid = $window.ionic.Platform.isAndroid()
  $scope.isIOS = $window.ionic.Platform.isIOS()

  #swiped right
  $scope.onSwipedRight = () ->
    $state.go "tab.talkList"

  $scope.logOut = () ->
    nextViewOpts =
      disableBack: yes
      historyRoot: yes
    $ionicHistory.nextViewOptions nextViewOpts
    popupOpts =
      title: "Logout"
      template: "Do you really want to log out?"
      cancelText: "No"
      okText: "Yes"
      okType: "button-assertive"
    popupPromise = $ionicPopup.confirm popupOpts
    popupPromise.then (logout) ->
      if logout
        $scope.stopPlaying()
        Auth.setAuthToken null, null
        $state.go "login"
