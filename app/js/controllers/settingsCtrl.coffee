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

  $scope.developerOptions = GLOBALS.DEVELOPER_OPTIONS


  # settings
  $scope.settings = Settings.attributes
  $scope.targets = Settings.targets

  $scope.resetSettings = ->
    Settings.reset()
    $cordovaToast.showLongBottom "Settings have been reset."

  $scope.clearStorage = ->
    User.logout()
    Settings.clear()
    $cordovaToast.showLongBottom "Storage has been cleared, logout..."
    $state.go "login"


  # user
  $scope.user = User.attributes

  $scope.refreshCredits = ->
    User.reload()
    $cordovaToast.showLongBottom "Refreshed successfully."


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
