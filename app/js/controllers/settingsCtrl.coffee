###
@ngdoc controller
@name settingsCtrl

@function

@description
  This Controller is responsible for settings tab.

###
settingsFn = ( $scope,
               $state,
               $ionicHistory,
               $ionicPopup,
               $cordovaToast,
               User,
               Settings,
               Player ) ->

  # navigation
  $scope.onSwipedRight = () ->
    $state.go "tab.talkList"

  # settings
  $scope.settings = Settings.data
  $scope.targets = Settings.targets

  $scope.toggleDownloadOption = ->
    $scope.settings.limitDownloadToWifi = !$scope.settings.limitDownloadToWifi
    Settings.set 'limitDownloadToWifi', $scope.settings.limitDownloadToWifi

  $scope.resetSettings = ->
    Settings.reset()
    $cordovaToast.showLongBottom "Settings have been reset, restarting..."

  $scope.clearStorage = ->
    Settings.clear()
    $cordovaToast.showLongBottom "Storage has been cleared, restarting..."

  # user
  $scope.refreshCredits = ->
    User.reload()
    $scope.user = User.data
    $cordovaToast.showLongBottom "Refreshed successfully."

  $scope.user = User.data

  # logout
  $scope.logout = ->
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
        Player.stop()
        User.logout()
        $state.go "login"


angular.module("voicerepublic").controller("settingsCtrl", settingsFn)
