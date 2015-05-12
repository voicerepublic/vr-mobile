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

.controller "loginCtrl", ($rootScope, $scope, $window, $state, $cordovaToast, $ionicHistory, $cordovaInAppBrowser) ->
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

  # log the user in and preset recording view
  $scope.login = () ->
    $state.go "tab.record"
    #clear History after login
    $ionicHistory.clearHistory()

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