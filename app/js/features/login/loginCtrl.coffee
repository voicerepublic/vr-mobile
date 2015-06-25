###
@ngdoc controller
@name loginCtrl

@function

@description
  This Controller is responsible for 
  loggin in and signing up the user.
  It uses the following services:
  - Auth

  **Note:** 
  Using the following cordova plugins:
  - cordova.InAppBrowser
###
angular.module("voicerepublic")

.controller "loginCtrl", ($http, $ionicLoading, $rootScope, $scope, $window, $state, $cordovaToast, $cordovaInAppBrowser, Auth) ->
  $scope.user = {}

  #ionic loading template
  if $window.ionic.Platform.isAndroid()
    condTemplate = '<ion-spinner icon="android"></ion-spinner> <br/> Logging in...'
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

  signUpURL = "https://voicerepublic.com/users/sign_up"
  forgotPasswordURL = "https://voicerepublic.com/users/password/new"
  target = "_blank"

  #close the browser if location hash equals
  $rootScope.$on "$cordovaInAppBrowser:loadstart", (e, event) ->
    if event.url.search("backToTheApp") isnt -1
      $cordovaInAppBrowser.close()
    $window.console.log event

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

    #URL's
    url = 'https://staging.voicerepublic.com/users/sign_in.json'
    #url = "https://voicerepublic.com/users/sign_in"

    options = 
      url: url
      method: "POST"
      headers:
        "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
      params:
        "user[email]": $scope.user.email
        "user[password]": $scope.user.password
        "user[remember_me]": 1
        
    #login request
    $http(options)
    .success (data, status) ->
      $window.console.log data
      $ionicLoading.hide()

      #set the auth & user relevant data
      Auth.setAuthToken $scope.user.email, data.authentication_token
      Auth.setSeries data.series
      Auth.setUserName data.firstname
      # future usage
      #Auth.setCredits data.credits

    .error (data, status) ->
      $window.console.log data
      $window.console.log status
      $ionicLoading.hide()
      $cordovaToast.showShortBottom "Login failed, please try again"

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

  ###send the http post as 'application/json' for signin purpose (without authenticity token)
    creds = 
      "user[email]": $scope.user.email
      "user[password]": $scope.user.password
      "user[remember_me]": 1

    $http.post(url, creds)
    .success (data, status, headers, config) ->
      #success
      $window.alert JSON.stringify data
      Auth.setAuthToken $scope.user.email, data.token
      $ionicLoading.hide()
      $state.go "tab.record"
      $cordovaToast.showShortBottom "Hello #{name}"
    .error (data, status, headers, config) ->
      #error
      opts =
        data: data
        status: status
        headers: headers
        config: config

      $window.opts = opts
      $window.console.log opts

      $ionicLoading.hide()
      $cordovaToast.showShortBottom "Login failed, please try again"
    ###