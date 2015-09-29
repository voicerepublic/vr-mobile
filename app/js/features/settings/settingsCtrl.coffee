###
@ngdoc controller
@name settingsCtrl

@function

@description
  This Controller is responsible for settings tab.

###
angular.module("voicerepublic")

.controller "settingsCtrl", ($rootScope, $scope, $state, $stateParams, $window, $ionicHistory, $ionicActionSheet, $ionicPopup, Auth, $log, User, Settings) ->

  #platform specific
  $scope.isAndroid = $window.ionic.Platform.isAndroid()
  $scope.isIOS = $window.ionic.Platform.isIOS()

  #swiped right
  $scope.onSwipedRight = () ->
    $state.go "tab.talkList"

  $scope.data = Settings.data
  $scope.toggleDownloadOption = ->
    data.limitDownloadToWifi = !data.limitDownloadToWifi
    Settings.set 'limitDownloadToWifi', data.limitDownloadToWifi

  $scope.refreshCredits = ->
    User.reload()

  $scope.data = User.data

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
