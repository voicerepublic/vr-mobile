log 'setup angular app (run)'

app = angular.module(GLOBALS.ANGULAR_APP_NAME)

# Run the app only after cordova has been initialized
# (this is why we don't include ng-app in the index.jade)
ionic.Platform.ready ->
  unless GLOBALS.ENV == "test"
    console.log 'ionic.Platform is ready! Running `angular.bootstrap()`...'
  angular.bootstrap document, [GLOBALS.ANGULAR_APP_NAME]

runFn = ( $rootScope,
          $state,
          $log,
          $timeout,
          $ionicPlatform,
          $ionicLoading,
          $cordovaToast,
          $cordovaSplashscreen,
          $cordovaMedia,
          User,
          Settings ) ->

  $ionicPlatform.ready ->
    window.cordova?.plugins.Keyboard?.hideKeyboardAccessoryBar()
    window.StatusBar?.styleDefault()
    window.ionic.Platform.isFullScreen = true

    #handle authenticity from state to state
    $rootScope.$on '$stateChangeStart', (event, toState, toParams, fromState, fromParams) ->
      $ionicLoading.show template: 'Loading...'
      if toState.isLoginState and User.signedIn()
        # TODO check why is 'tab.record' hardcoded here? rationale?
        $state.transitionTo 'tab.record'
        event.preventDefault()
      else if toState.authenticate and !User.signedIn()
        # User isn’t authenticated
        $state.transitionTo 'login'
        event.preventDefault()

    $rootScope.$on '$stateChangeSuccess', (event, toState, toParams, fromState, fromParams) ->
      $ionicLoading.hide()

  $log.debug "Ionic app \"#{GLOBALS.ANGULAR_APP_NAME}\" has just started (app.run) in env #{GLOBALS.ENV}!" unless GLOBALS.ENV == "test"

  if GLOBALS.ENV == 'development' && Settings.attributes.playDevGreeting
    # TODO fix the path to make it find the audio file
    url = '/android_asset/www/audio/hallo-hallo-hallo.mp3'
    media = $cordovaMedia.newMedia(url)
    media.play()

  # Finally, let's show the app, by hiding the splashscreen
  # (it should be visible up until this moment)
  $timeout ->
    $cordovaSplashscreen.hide()
  , 1000

  # greet the user if we know him or her
  if User.signedIn()
    $timeout ->
      $cordovaToast.showLongBottom "Welcome Back, #{User.attributes.firstname}!"
    , 1337

app.run(runFn)
