###
@ngdoc controller
@name loginCtrl

@function

@description
  This Controller is responsible for
  loggin in and signing up the user.
  It uses the following services:
  - User

  **Note:**
  Using the following cordova plugins:
  - cordova.InAppBrowser
###

loginCtrlFn = ( $scope,
                $http,
                $log,
                $window,
                $state,
                $rootScope,
                $ionicLoading,
                $ionicHistory,
                $cordovaToast,
                $cordovaInAppBrowser,
                User,
                Settings ) ->

  $scope.settings = Settings.attributes
  $scope.developerOptions = GLOBALS.DEVELOPER_OPTIONS

  $scope.user = {}

  #ionic loading template
  if $window.ionic.Platform.isAndroid()
    condTemplate = '<ion-spinner icon="android"'
    condTemplate += 'class="spinner-assertive"' if $window.ionic.Platform.grade is "a"
    condTemplate += '></ion-spinner> <br/> Logging in...'
  if $window.ionic.Platform.isIOS()
    condTemplate = '<ion-spinner icon="ios"></ion-spinner> <br/> Logging in...'
  ionicLoadingOpts =
    template: condTemplate
    hideOnStateChange: yes

  #InAppBrowserOptions
  options =
    location: "no"
    clearcache: "yes"
    toolbar: "no"

  #script to be injected
  script =
    file: "js/script.js"

  signUpURL = "#{Settings.endpoints().api}/users/sign_up"
  forgotPasswordURL = "#{Settings.endpoints().api}/users/password/new"
  target = "_blank"

  #close the browser if location hash equals
  $rootScope.$on "$cordovaInAppBrowser:loadstart", (e, event) ->
    if event.url.search("backToTheApp") isnt -1
      $cordovaInAppBrowser.close()

  #inject the script after loading the assets
  $rootScope.$on "$cordovaInAppBrowser:loadstop", (e, event) ->
    #inject the script via ajax
    ajaxRequest =
      type: "GET"
      url: script.file
      dataType: "text"
      success: (msg) ->
        $cordovaInAppBrowser.executeScript({code: msg}, ->
            #successfully injected
        )
      error: ->
        #error
    $.ajax ajaxRequest
    #check urls and close the browser if matching
    if event.url.search("onboard") != -1
      $cordovaInAppBrowser.close()
      $cordovaToast.showLongBottom "Welcome on board, please feel free to log in with your new created account!"


  $rootScope.$on "$cordovaInAppBrowser:loaderror", (e, event) ->
    $cordovaInAppBrowser.close()
    $cordovaToast.showShortBottom "Cannot load the resources, please try again"

  $rootScope.$on "$cordovaInAppBrowser:exit", (e, event) ->
    #$cordovaToast.showShortBottom "Welcome back to the App!"

  #log the user in and preset recording view
  $scope.login = () ->
    unless $scope.user.email and $scope.user.password
      $cordovaToast.showShortBottom "Invalid email or password"
      return

    #show the loading modal
    $ionicLoading.show ionicLoadingOpts

    success = (data, status) ->
      $ionicLoading.hide()

      $scope.user.email = ""
      $scope.user.password = ""

      #next view should become root
      nextViewOpts =
        disableBack: yes
        historyRoot: yes
      $ionicHistory.nextViewOptions nextViewOpts

      $state.go "tab.record"
      $cordovaToast.showShortBottom "Hello #{data.firstname}!"

    error = (data, status) ->
      $ionicLoading.hide()
      $cordovaToast.showShortBottom "Error with your login or password, please try again"

    User.login($scope.user.email, $scope.user.password, success, error)

  #open the InAppBrowser and redirect to VR Website
  $scope.register = () ->
    $cordovaToast.showShortBottom "loading..."
    browserPromise = $cordovaInAppBrowser.open signUpURL, target, options
    browserPromise.then((event) ->
      #success
    ).catch (event) ->
      #error
      $cordovaToast.showShortBottom "Something went wrong, please try again"

  #open the InAppBrowser and redirect to VR Website
  $scope.forgot = () ->
    $cordovaToast.showShortBottom "loading..."
    browserPromise = $cordovaInAppBrowser.open forgotPasswordURL, target, options
    browserPromise.then((event) ->
      #success
    ).catch (event) ->
      #error
      $cordovaToast.showShortBottom "Something went wrong, please try again"

  $scope.loginAsDev = ->
    $scope.user.email = 'voicerepublic.device@gmail.com'
    $scope.user.password = 'ohwahsh1ag1einoh'

angular.module("voicerepublic").controller("loginCtrl", loginCtrlFn)
