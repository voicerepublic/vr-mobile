app = angular.module(GLOBALS.ANGULAR_APP_NAME)


app.config ($ionicConfigProvider) ->
  # Customize navigation look
  # $ionicConfigProvider.backButton.icon('ion-ios7-arrow-back')
  # $ionicConfigProvider.backButton.text($translateProvider.instant("GO_BACK"))
  # $ionicConfigProvider.backButton.previousTitleText(false)
  # $ionicConfigProvider.navBar.alignTitle('center')
  # $ionicConfigProvider.navBar.positionPrimaryButtons('left')
  # $ionicConfigProvider.navBar.positionSecondaryButtons('right')

  # Change views cache limit from 10 to 4
  $ionicConfigProvider.views.maxCache(4)

  # Don't prefetch any templates - we use $templateCache for that
  $ionicConfigProvider.templates.maxPrefetch(false)

  # Turn off animations on Android and iOS 6 devices.
  # More info: http://ionicframework.com/docs/nightly/api/provider/%24ionicConfigProvider/
  unless ionic.Platform.grade == "a"
    $ionicConfigProvider.views.transition("none")
    $ionicConfigProvider.views.maxCache(2)
