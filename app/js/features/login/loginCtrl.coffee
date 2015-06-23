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

.controller "loginCtrl", ($http, $localstorage, $cordovaProgress, ipCookie, $rootScope, $scope, $window, $state, $cordovaToast, $ionicHistory, $cordovaInAppBrowser, Auth) ->
  $scope.user = {}
  
  #InAppBrowserOptions
  options =
    location: "no"
    clearcache: "yes"
    toolbar: "no"

  #script to be injected
  script =
    file: "script.js"

  signUpURL = "https://voicerepublic.com/users/sign_up"
  forgotPasswordURL = "https://voicerepublic.com/users/password/new"
  target = "_blank"

  #TODO inject a Script into the Browser, which adds an EventListener to
  #the completion of the Sign Up process. So that we can close the InAppBrowser
  #programmaticly in order to get better UX!
  #TODO also inject a button to the DOM on the bottom, with which
  #the user is able to return to the app
  $rootScope.$on "$cordovaInAppBrowser:loadstop", (e, event) ->
    #$cordovaInAppBrowser.executeScript script

  $rootScope.$on "$cordovaInAppBrowser:loaderror", (e, event) ->
    $cordovaInAppBrowser.close()
    $cordovaToast.showShortBottom "Cannot load resources, please try again"

  $rootScope.$on "$cordovaInAppBrowser:exit", (e, event) ->
    $cordovaToast.showShortBottom "Welcome on board"

  #log the user in and preset recording view
  $scope.login = () ->
    unless $scope.user.email and $scope.user.password
      $cordovaToast.showShortBottom "Invalid email or password"
      return

    if $window.ionic.Platform.isAndroid()
      $cordovaProgress.showSimple()

    if $window.ionic.Platform.isIOS()
      $cordovaProgress.showSimpleWithLabel true, "Logging in..."

    $http.get("https://voicerepublic.com/users/sign_in")
    #get authenticity_token
    .success (data, status) ->
      el = angular.element data
      authToken = el.find("input[name=authenticity_token]").val()

      $localstorage.set "csrfToken", authToken 

      optionsPost = 
        url: "https://voicerepublic.com/users/sign_in"
        method: "POST"
        headers:
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
        params:
          "authenticity_token": authToken
          "user[email]": $scope.user.email
          "user[password]": $scope.user.password
          "user[remember_me]": 1
          
      #login request
      $http(optionsPost)
      .success (data, status) ->
        el = angular.element data
        name = el.find(".user-name").text()

        #statusCode 200 even if password wrong??!
        #workaraound:
        if name is ""
          $cordovaProgress.hide()
          $cordovaToast.showShortBottom "Login failed, please try again"
          return

        #cache the name for further usage
        $localstorage.set "user_name", name
        authToken = el.find("input[name=authenticity_token]").val()
        #userToken = ipCookie "remember_user_token"
        # save the token to put it dynamically into the header with 
        # the interceptor called MyCSRF
        $localstorage.set "csrfToken", authToken

        Auth.setAuthToken $scope.user.email, authToken

        ###login success - not in use yet since backend not rdy
        getUser = Auth.setAuthToken $scope.user.email, userToken
        getUser.then((res) ->
          #name = res.data.name
        (err) ->
          $window.alert JSON.stringify err
        )
        ###

        $cordovaProgress.hide()

        $state.go "tab.record"
        $cordovaToast.showShortBottom "Hello #{name}"
      .error (data, status, headers, config) ->
        $cordovaProgress.hide()
        $cordovaToast.showShortBottom "Login failed, please try again"
    .error (data, status, headers, config) ->
      $cordovaProgress.hide()
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