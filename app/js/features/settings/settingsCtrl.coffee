###
@ngdoc controller
@name settingsCtrl

@function

@description
  This Controller is responsible for settings tab.

###
angular.module("voicerepublic")

.controller "settingsCtrl", ($rootScope, $scope, $state, $stateParams, $window, $ionicHistory, $ionicActionSheet, $ionicPopup, Auth, $log, User, Settings, $cordovaToast) ->

  #platform specific
  $scope.isAndroid = $window.ionic.Platform.isAndroid()
  $scope.isIOS = $window.ionic.Platform.isIOS()

  #swiped right
  $scope.onSwipedRight = () ->
    $state.go "tab.talkList"

  $scope.settings = Settings.data
  $scope.toggleDownloadOption = ->
    $scope.settings.limitDownloadToWifi = !$scope.settings.limitDownloadToWifi
    Settings.set 'limitDownloadToWifi', $scope.settings.limitDownloadToWifi

  $scope.refreshCredits = ->
    User.reload()
    $scope.user = User.data
    $cordovaToast.showLongBottom "Refreshed successfully."

  $scope.user = User.data

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
